# Update Giada loop machine

$giadaDirectory = "C:\Tools\Giada"
$giadaUri = "https://www.giadamusic.com/download"

# Get version of the remote Giada
if ((Invoke-WebRequest -Uri $giadaUri).Content -notmatch ".*Changes in version ([\d\.]+).*")
{
    Write-Output "Could not find current version at $giadaUri"
    exit 1
}

$giadaRemoteVersion = $Matches[1]

# Search for remote version in the local ChangeLog file
$foundRemoteVersionInLocalChangeLog = Select-String -Path "$giadaDirectory\ChangeLog" -Pattern $giadaRemoteVersion

if ($foundRemoteVersionInLocalChangeLog)
{
    Write-Output "Nothing to update"
}
else
{
    Write-Output "Updating..."
    # Download archive
    $tmpZipFile = "$env:TEMP\giada.zip"
    $giadaArchiveUri = "https://www.giadamusic.com/data/giada-$giadaRemoteVersion-win-amd64.zip"
    Invoke-WebRequest -Uri $giadaArchiveUri -OutFile $tmpZipFile
    # Expand archive
    Expand-Archive -LiteralPath $tmpZipFile -DestinationPath $giadaDirectory -Force
    # Clean up
    Remove-Item $tmpZipFile -Force
    Write-Output "Done"
}
