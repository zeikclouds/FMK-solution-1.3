@echo off
title FKM Solutions Local Web Server
echo ========================================================
echo Starting FKM Solutions Local Server on http://localhost:8080
echo ========================================================
echo Press Ctrl+C in this window to stop the server.
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command "$port = 8080; $folder = (Get-Location).Path; $listener = New-Object System.Net.HttpListener; $listener.Prefixes.Add(\"http://localhost:$port/\"); $listener.Start(); Write-Host \"Server running at http://localhost:$port/\"; Start-Process \"http://localhost:$port/\"; while ($listener.IsListening) { try { $context = $listener.GetContext(); $request = $context.Request; $response = $context.Response; $relPath = $request.Url.LocalPath.TrimStart('/'); if ([string]::IsNullOrEmpty($relPath)) { $relPath = 'index.html' }; $filePath = Join-Path $folder $relPath; if (Test-Path $filePath -PathType Leaf) { $bytes = [System.IO.File]::ReadAllBytes($filePath); $ext = [System.IO.Path]::GetExtension($filePath).ToLower(); switch ($ext) { '.html' { $response.ContentType = 'text/html' } '.css' { $response.ContentType = 'text/css' } '.js' { $response.ContentType = 'application/javascript' } '.png' { $response.ContentType = 'image/png' } '.jpg' { $response.ContentType = 'image/jpeg' } '.svg' { $response.ContentType = 'image/svg+xml' } default { $response.ContentType = 'application/octet-stream' } }; $response.ContentLength64 = $bytes.Length; $response.OutputStream.Write($bytes, 0, $bytes.Length) } else { $response.StatusCode = 404; $err = [System.Text.Encoding]::UTF8.GetBytes('404 Not Found'); $response.OutputStream.Write($err, 0, $err.Length) }; $response.Close() } catch {} }"
