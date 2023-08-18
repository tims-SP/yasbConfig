$text = powershell -Command "(wmic path Win32_PerfFormattedData_Tcpip_NetworkInterface get BytesReceivedPerSec,BytesSentPerSec /format:list) -replace '=', ' : '"

# 将文本按行分割，并去除空行
$lines = $text -split '\r?\n' | Where-Object { $_.Trim() -ne '' }

# 创建一个空的数组来存储对象
$objects = @{}

# 初始化一个变量用于累加value值
$totalValue = 0

# 遍历每两行数据，构造键值对对象
for ($i = 0; $i -lt $lines.Count; $i += 1) {

    $key = ($lines[$i] -split ':')[0].Trim()
    $value = ($lines[$i] -split ':')[1].Trim()

    # 累加value值
    $totalValue += $intValue

    # 创建包含键值对的自定义对象
    # $obj = [PSCustomObject] @{
    #     Key   = $key
    #     Value = $value / 1024
    # }
    # $objects += $obj

    if (-not $objects[$key]) {
        $objects[$key] = 0
    }
    $objects[$key] += "{0:N2}" -f($value/1024/1024)
}

# 转换为 JSON 格式的字符串
$jsonString = $objects | ConvertTo-Json

# 输出 JSON 字符串
Write-Output $jsonString
