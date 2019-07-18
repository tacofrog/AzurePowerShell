<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
.INPUTS
   Inputs to this cmdlet (if any)
.OUTPUTS
   Output from this cmdlet (if any)
.NOTES
   General notes
.COMPONENT
   The component this cmdlet belongs to
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>
function Get-AzWhiteList {
    [CmdletBinding()]
    #Supports "USGov","China","Germany" or "Public" as possible parameters which define the URL
    param (
    [Parameter(Mandatory=$true,
    Position=0)]
    [string]
    [validateSet("USGov","China","Germany","Public")]
    $CloudLocation,

    #Input the region as defined in the JSON file
    [Parameter(Mandatory = $true,
    Position = 0)]
    [string]
    $Region
    )
    $URIInput
switch ($CloudLocation) {
        USGov { $URIInput = "https://download.microsoft.com/download/6/4/D/64DB03BF-895B-4173-A8B1-BA4AD5D4DF22/ServiceTags_AzureGovernment_20190715.json" }
        China { $URIInput = "https://download.microsoft.com/download/9/D/0/9D03B7E2-4B80-4BF3-9B91-DA8C7D3EE9F9/ServiceTags_China_20190715.json" }
        Germany { $URIInput = "https://download.microsoft.com/download/0/7/6/076274AB-4B0B-4246-A422-4BAF1E03F974/ServiceTags_AzureGermany_20190715.json" }
        Public { $URIInput = "https://download.microsoft.com/download/7/1/D/71D86715-5596-4529-9B13-DA13A5DE5B63/ServiceTags_Public_20190715.json" }
        Default { $URIInput = "https://download.microsoft.com/download/7/1/D/71D86715-5596-4529-9B13-DA13A5DE5B63/ServiceTags_Public_20190715.json" }
}

    $JSONobj = Invoke-WebRequest $URIInput | ConvertFrom-Json  | select -ExpandProperty values
    [string[]]$GovAddresses = @()
    ForEach ($JsonProp in $JSONobj) {
        If ($JsonProp.id -eq $Region) {
            $GovAddresses = $JsonProp.properties | select -ExpandProperty address*
        }
    }
    $GovAddresses
}
 Get-AzWhiteList -CloudLocation 'USGov' -Region "AzureCloud"
