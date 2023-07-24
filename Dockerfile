#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:8.0-preview AS base
USER app
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

FROM mcr.microsoft.com/dotnet/sdk:8.0-preview AS build
WORKDIR /src
COPY ["aws-auction-api.csproj", "."]
RUN dotnet restore "./aws-auction-api.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "aws-auction-api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "aws-auction-api.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "aws-auction-api.dll"]