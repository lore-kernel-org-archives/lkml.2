Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab0IFIlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 04:41:49 -0400
Received: from relay02-haj2.antispameurope.com ([83.246.65.52]:50893 "EHLO
	relay02-haj2.antispameurope.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752554Ab0IFIls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 04:41:48 -0400
Message-ID: <4C84A93B.2050507@iis.fraunhofer.de>
Date: Mon, 06 Sep 2010 10:41:31 +0200
From: Manuel Stahl <manuel.stahl@iis.fraunhofer.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.2.8) Gecko/20100802 Lightning/1.0b2 Thunderbird/3.1.2
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: [IIO] Proposal for sysfs attributes
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms070709020307020009040802"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms070709020307020009040802
Content-Type: multipart/mixed;
 boundary="------------010807060400000800070702"

This is a multi-part message in MIME format.
--------------010807060400000800070702
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi all,

there were some sysfs userspace questions on linux-iio where we would=20
like to get some more comments on.

First thing, there are some attributes describing the layout of a ring=20
buffer that can be read out via a char device. The buffer contains=20
several entries with each containing so called scan elements. All=20
entries have the same layout. It is described in a directory=20
scan_elements (see below) that contains three attributes per scan element=
=2E

> OK, no packed buffers for now, but we should implement variable
 > sample sizes for standard types. Indeed we already have this for
 > the timestamp, which is always 64 bit.
>
> To be compatible with future extensions we could have:
>    |- /sys/bus/iio/device0/buffer0/scan_elements/
>       |- accel_x_en    (0 or 1)
>       |- accel_x_type  (i.e. s14/16, see *)
>       |- accel_x_index (position inside the buffer entry)
>
> * s14/16 means signed 14 bits, stored in 16 bits, right aligned.
 >   If it's left aligned we can just modify the scale attribute and
 >   give the 16 bit interpretation in <channel>_raw.

Is the 's14/16' self explaining or should we use some other format?
Is 'type' a good postfix for the attribute?


Next question: how strictly we want to resamble the hwmon ABI?

To sum up the discussion:
Hwmon has files with the postfix _input to read values scaled to
reasonable units for fixed point representation. So the units are
sometimes scaled down to 'millis' e.g. millivolt, millidegree Celsius.
We agreed that we want to keep this, whenever we use the _input postfix.
For IIO there is also the postfix triple _raw, _scale and _offset,
where the final value is calculated by (_raw + _offset) * _scale.
Floating point values are allowed for any of these files.

The question in place was:
Do we want to resamble the 'milli' units or should we stick to
standard SI units (radians, kelvin, etc.) as floating point math is
necessary anyway.

Regards,
--=20
Dipl.-Inf. Manuel Stahl
Fraunhofer-Institut f=C3=BCr Integrierte Schaltungen IIS
- Leistungsoptimierte Systeme -
Nordostpark 93                Telefon  +49 (0)911/58061-6419
90411 N=C3=BCrnberg                Fax      +49 (0)911/58061-6398
http://www.iis.fraunhofer.de  manuel.stahl@iis.fraunhofer.de

--------------010807060400000800070702
Content-Type: text/x-vcard; charset=utf-8;
 name="manuel_stahl.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="manuel_stahl.vcf"

YmVnaW46dmNhcmQNCmZuOk1hbnVlbCBTdGFobA0KbjpTdGFobDtNYW51ZWwNCmVtYWlsO2lu
dGVybmV0Om1hbnVlbC5zdGFobEBpaXMuZnJhdW5ob2Zlci5kZQ0KdGVsO3dvcms6KzQ5IDkx
MSA1ODA2MS02NDE5DQp4LW1vemlsbGEtaHRtbDpGQUxTRQ0KdmVyc2lvbjoyLjENCmVuZDp2
Y2FyZA0KDQo=
--------------010807060400000800070702--

--------------ms070709020307020009040802
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIUWDCC
BC4wggMWoAMCAQICAgEMMA0GCSqGSIb3DQEBBQUAMHExCzAJBgNVBAYTAkRFMRwwGgYDVQQK
ExNEZXV0c2NoZSBUZWxla29tIEFHMR8wHQYDVQQLExZULVRlbGVTZWMgVHJ1c3QgQ2VudGVy
MSMwIQYDVQQDExpEZXV0c2NoZSBUZWxla29tIFJvb3QgQ0EgMjAeFw0wNzEyMDUxNTE4NTha
Fw0xOTA2MzAyMzU5NTlaMGcxCzAJBgNVBAYTAkRFMRMwEQYDVQQKEwpGcmF1bmhvZmVyMSEw
HwYDVQQLExhGcmF1bmhvZmVyIENvcnBvcmF0ZSBQS0kxIDAeBgNVBAMTF0ZyYXVuaG9mZXIg
Um9vdCBDQSAyMDA3MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwz0eyWWNW4g3
9z7BIbZU3rA6VxsaHO6YCHQBWm+13zZXK0RFzvNGE2V2lZhUx6iFFW4SpBfoC+EhpzE9Kd3/
o9ZP0rSJ/WNK2qtT71kFtE/iOyqRmcDLZVeBozCTkA7Jvf0VMjIIpEh8VgXyuzaJ4kjCb0uS
DCVFvq0+1McB7bHIErQwCG6nb396IKe7tOU1gFQsGY/ZS8Adq0P4YRSU+7AdXbeR7GLAkdFe
3acLsy0fZjkYPK4EFOXSfTbZss2nE7DMRZ1WBFFxMzZcL11RE55PSJAOl1pLcNu5edmh1pTI
ktCl+2C/La2ecQAXhsD9SGadFEwFTkzRcUQL0HoPsQIDAQABo4HZMIHWMB8GA1UdIwQYMBaA
FDHDeRu69VPXF+CJei0XbAqzK50zMA4GA1UdDwEB/wQEAwIBBjAdBgNVHQ4EFgQUL0VCHjEF
gNVw2PgdV8tbetU9nPcwEgYDVR0TAQH/BAgwBgEB/wIBATBwBgNVHR8EaTBnMGWgY6Bhhl9o
dHRwOi8vcGtpLnRlbGVzZWMuZGUvY2dpLWJpbi9zZXJ2aWNlL2FmX0Rvd25sb2FkQVJMLmNy
bD8tY3JsX2Zvcm1hdD1YXzUwOSYtaXNzdWVyPURUX1JPT1RfQ0FfMjANBgkqhkiG9w0BAQUF
AAOCAQEAGrdMejzl3cJjst6GJU5FYkz08o9fXdfljc4O1/WU4YuTMTanmiPnZ+FSwVoY1pnh
gGQ4D0o1M11meijcOH83cs1SdW4Qjmx9jPcp63fCuRkF1Lc9YbroBRLUUGJT7yJUYvxNAcNe
1A2DdGlR1TyerNukK3xthJbTcU3P1S1xo5LEP1XPmz0jdwdX6cjOHZe2M/uRl2CWD/f23m8l
kBKrGUfVRCOuwZI1KL8qQ14P6gdd0kTQhYLjErxH6iyt+PBBUn02uiKfeqAy70u8+ToHtinG
fThfNVV+OPI/fLPuLW4heF+5E8/v3mWAyCX1Zi1USq3O2S4OMM+AM6eLGXLqQTCCBMYwggOu
oAMCAQICCmEdMxkAAAAAAAMwDQYJKoZIhvcNAQEFBQAwZzELMAkGA1UEBhMCREUxEzARBgNV
BAoTCkZyYXVuaG9mZXIxITAfBgNVBAsTGEZyYXVuaG9mZXIgQ29ycG9yYXRlIFBLSTEgMB4G
A1UEAxMXRnJhdW5ob2ZlciBSb290IENBIDIwMDcwHhcNMDcxMjEyMTQ0OTM1WhcNMTkwNjMw
MjM1OTU5WjBnMQswCQYDVQQGEwJERTETMBEGA1UEChMKRnJhdW5ob2ZlcjEhMB8GA1UECxMY
RnJhdW5ob2ZlciBDb3Jwb3JhdGUgUEtJMSAwHgYDVQQDExdGcmF1bmhvZmVyIFVzZXIgQ0Eg
MjAwNzCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMJ0EFHLddGB8Ss1nVqCOq+S
rs0C/K7I+yB3Dv9oEhWQSadnfGgkX/oOJhplPkqeCQrTh08zEYprVaJLTaVPVhvjx3h5+KML
3lVGZIfajA89TolhLwk+ml29VbqV5nLhNrSwdZy157b6dCu5JffxvpO5wXCn95Z/TLyLdeux
gVHs/MnhczvmBbBRS+Ow9UoKn+PZvyYmUEdOHg8cA5PGFaRP9q88q734VnlI+W4+y7BoN5wt
uqVrqWbbpOQ2sHYo9riv3b+x5WdsMrVieKGApQ/dNvgB5vuuAchRnsANZHgpAiPCzP7/QFYY
qk2undcxEXwPgo72oifB3uQZ3xHOV/cCAwEAAaOCAXIwggFuMBIGA1UdEwEB/wQIMAYBAf8C
AQAwHQYDVR0OBBYEFE8dr4jKbbiqHAn5xdER7Vm0k/oLMA4GA1UdDwEB/wQEAwIBBjAfBgNV
HSMEGDAWgBQvRUIeMQWA1XDY+B1Xy1t61T2c9zB1BgNVHR8EbjBsMGqgaKBmhjFodHRwOi8v
Y3JsLnBraS5mcmF1bmhvZmVyLmRlL2ZoZy1yb290LWNhLTIwMDcuY3JshjFodHRwOi8vY3Js
LmZyYXVuaG9mZXItcGtpLmRlL2ZoZy1yb290LWNhLTIwMDcuY3JsMIGQBggrBgEFBQcBAQSB
gzCBgDA+BggrBgEFBQcwAoYyaHR0cDovL2NlcnQucGtpLmZyYXVuaG9mZXIuZGUvZmhnLXJv
b3QtY2EtMjAwNy5jZXIwPgYIKwYBBQUHMAKGMmh0dHA6Ly9jZXJ0LmZyYXVuaG9mZXItcGtp
LmRlL2ZoZy1yb290LWNhLTIwMDcuY2VyMA0GCSqGSIb3DQEBBQUAA4IBAQAAd2yMM/nuVwQl
ysuIOeZOTKTOwpZLGYZNuERXwpWpEDfsMFUxX/Wetbu1a1qhd+x6SyXY4V1CzcFDOGF3wA7b
yIV/6dyC53I9luZTjy9zjUsjLZucD4jeNja3QEu39sQsYsuE3MTfFFJgr/NeAFMHVkkHGx3l
VXb+F3J3+9xeXHk/wB/yIKd/RIiMMTT4+a+ra2MTCsYAe4kgJ0vz2TXYGN8tujjCgsUUbwfJ
C9wrOiCJMNJM1i7sUVqVKIoswW7h5QpWUNu1E4RAsDEz7depXCYaAIwPprEIkr0dE63zqHhm
M4egS7iGmBfNQohUO6jJOWNcJ9dIxqc0c/4WUHg8MIIFpDCCBIygAwIBAgIKXts1tgAAAACh
VTANBgkqhkiG9w0BAQUFADBnMQswCQYDVQQGEwJERTETMBEGA1UEChMKRnJhdW5ob2ZlcjEh
MB8GA1UECxMYRnJhdW5ob2ZlciBDb3Jwb3JhdGUgUEtJMSAwHgYDVQQDExdGcmF1bmhvZmVy
IFVzZXIgQ0EgMjAwNzAeFw0wOTEyMDkxNDQ3MTlaFw0xNTEyMDgxNDQ3MTlaMFgxCzAJBgNV
BAYTAkRFMRMwEQYDVQQKEwpGcmF1bmhvZmVyMQwwCgYDVQQLEwNJSVMxDzANBgNVBAsTBlBl
b3BsZTEVMBMGA1UEAxMMTWFudWVsIFN0YWhsMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB
CgKCAQEAyc3xmHk19YZAmko+jIM52UsU0keIMlZuSsQvl7HCAGEzifKcfmrR6EX1lYPUKVZJ
BpqMSG3jyA4GW6gR/7cwz0IbnwFPC40KHPODRVIWDIJbZrP6zl+hF+G6/ZTe7ttPahSNhfeq
wkhQZJYQwoxEPoaODFpgQ8St+WRRkgfi3jvjuUIddgWV4NyVAm6m5fmF9a6iv20e+ZSW0As7
brNVf4Xvl5+y58MWniD3hjryz2OsqH1+NrFk8dxPjR4z3tWfty4x4J5af1z25tKX3xnJtx6Q
l61FI1UlSUqR3DHxkmLY7RRCccxtpwOES2YgmBBpJzrxCJ+cYwVJIVHR7I/3qwIDAQABo4IC
XzCCAlswDgYDVR0PAQH/BAQDAgbAMCkGA1UdEQQiMCCBHm1hbnVlbC5zdGFobEBpaXMuZnJh
dW5ob2Zlci5kZTAdBgNVHQ4EFgQUbNwp94oWTogPsGGtBT3dcKtNhXUwHwYDVR0jBBgwFoAU
Tx2viMptuKocCfnF0RHtWbST+gswdQYDVR0fBG4wbDBqoGigZoYxaHR0cDovL2NybC5wa2ku
ZnJhdW5ob2Zlci5kZS9maGctdXNlci1jYS0yMDA3LmNybIYxaHR0cDovL2NybC5mcmF1bmhv
ZmVyLXBraS5kZS9maGctdXNlci1jYS0yMDA3LmNybDCCAQoGCCsGAQUFBwEBBIH9MIH6MD4G
CCsGAQUFBzAChjJodHRwOi8vY2VydC5wa2kuZnJhdW5ob2Zlci5kZS9maGctdXNlci1jYS0y
MDA3LmNlcjA+BggrBgEFBQcwAoYyaHR0cDovL2NlcnQuZnJhdW5ob2Zlci1wa2kuZGUvZmhn
LXVzZXItY2EtMjAwNy5jZXIwOwYIKwYBBQUHMAGGL2h0dHA6Ly9maGctdXNlci1jYS0yMDA3
Lm9jc3AucGtpLmZyYXVuaG9mZXIuZGUvMDsGCCsGAQUFBzABhi9odHRwOi8vZmhnLXVzZXIt
Y2EtMjAwNy5vY3NwLmZyYXVuaG9mZXItcGtpLmRlLzATBgNVHSUEDDAKBggrBgEFBQcDBDBE
BgNVHSAEPTA7MDkGCysGAQQBhgpQAwEBMCowKAYIKwYBBQUHAgEWHGh0dHA6Ly9wa2kuZnJh
dW5ob2Zlci5kZS9jcC8wDQYJKoZIhvcNAQEFBQADggEBACWdlXdPPIhNtjC0aYQgGYQ9+e0N
XHqtaQsxgzZ2D4Rp34VeuZPWkF/YMDXgxB9sarzCO4WcBxz0QWjWiQOtAYzPc+2U3C3Pyw6Y
Mc0yxSpg6R602Hy/O1aNn7XZ50gujpIjuwo0fAFhg8OI63uolkgKAYyoUcTRHc4Z4kwb8bgg
+5a56lKIqBwTweqd2VaNnW0FCfk5bJsaw2j3bHnWkS2D9BWt0U+t+/zCqMYT9E38vTP57kho
vpb44u+8m6Xaaorn3bCK2WzHH5HZp/mVEZ6TZw+mJ+Ltjrcnz+9JAFYZxtpSpZN/k1zRM0P6
6CKxV9JfFqwQJnso0LtpcfLFGuMwggWwMIIEmKADAgECAgpe2zMWAAAAAKFUMA0GCSqGSIb3
DQEBBQUAMGcxCzAJBgNVBAYTAkRFMRMwEQYDVQQKEwpGcmF1bmhvZmVyMSEwHwYDVQQLExhG
cmF1bmhvZmVyIENvcnBvcmF0ZSBQS0kxIDAeBgNVBAMTF0ZyYXVuaG9mZXIgVXNlciBDQSAy
MDA3MB4XDTA5MTIwOTE0NDcxOVoXDTE1MTIwODE0NDcxOVowWDELMAkGA1UEBhMCREUxEzAR
BgNVBAoTCkZyYXVuaG9mZXIxDDAKBgNVBAsTA0lJUzEPMA0GA1UECxMGUGVvcGxlMRUwEwYD
VQQDEwxNYW51ZWwgU3RhaGwwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC18idY
1AthSSVhkq1AFUnVfm5pzin5dEuixfJs+PaEQah9OWHYqSCxvXYL/58MtfpCsMl8HpIUsnuh
O4GPDjdxawgLSItU/LCF5/cmdc6swyi2efJC5QviHJ/aB/MbD3TKl9aGQXE0K85/iS4KQT2c
GM8uvWhF3yNNJIuauJ8BMX55vyelXT1rsldiGsBwKQ2PRcoM24jdtw/4DigsImSAkV6rxgg7
CeV92wE1trfx7OOoK9PPgAE9D95oiZz25f2MH7NnD4Wzo+73chdoQnhPZHNBojcxdyg+Rf3O
PCuKfXLYdTgEzEFGNFIwojaKoJ2ws1t2z3O62h7Tye0EMBtTAgMBAAGjggJrMIICZzAOBgNV
HQ8BAf8EBAMCBDAwKQYDVR0RBCIwIIEebWFudWVsLnN0YWhsQGlpcy5mcmF1bmhvZmVyLmRl
MB0GA1UdDgQWBBR3QN2wMBSsk+rxgVGtX5Plvb9tNzAfBgNVHSMEGDAWgBRPHa+Iym24qhwJ
+cXREe1ZtJP6CzB1BgNVHR8EbjBsMGqgaKBmhjFodHRwOi8vY3JsLnBraS5mcmF1bmhvZmVy
LmRlL2ZoZy11c2VyLWNhLTIwMDcuY3JshjFodHRwOi8vY3JsLmZyYXVuaG9mZXItcGtpLmRl
L2ZoZy11c2VyLWNhLTIwMDcuY3JsMIIBCgYIKwYBBQUHAQEEgf0wgfowPgYIKwYBBQUHMAKG
Mmh0dHA6Ly9jZXJ0LnBraS5mcmF1bmhvZmVyLmRlL2ZoZy11c2VyLWNhLTIwMDcuY2VyMD4G
CCsGAQUFBzAChjJodHRwOi8vY2VydC5mcmF1bmhvZmVyLXBraS5kZS9maGctdXNlci1jYS0y
MDA3LmNlcjA7BggrBgEFBQcwAYYvaHR0cDovL2ZoZy11c2VyLWNhLTIwMDcub2NzcC5wa2ku
ZnJhdW5ob2Zlci5kZS8wOwYIKwYBBQUHMAGGL2h0dHA6Ly9maGctdXNlci1jYS0yMDA3Lm9j
c3AuZnJhdW5ob2Zlci1wa2kuZGUvMB8GA1UdJQQYMBYGCisGAQQBgjcKAwQGCCsGAQUFBwME
MEQGA1UdIAQ9MDswOQYLKwYBBAGGClADAQEwKjAoBggrBgEFBQcCARYcaHR0cDovL3BraS5m
cmF1bmhvZmVyLmRlL2NwLzANBgkqhkiG9w0BAQUFAAOCAQEAIny6T0ZtZyrpF4dLpcM6G07I
HDC4cdGFLqfnqRLfMLwgdgxACPkYB8VbApcGKiSxcXaZEaz8CLLMrdwXkta1o+ZA6dz90Y1T
dYlvHvdsuhGeIkNwlJoGwlf4Ts4+7pi2d7sbYX3GFSzD3KcBn6DJp71pl4+MEcvkwVVaBKCw
+ohHssiRmG40fYAmdxBqPmjGyer4PftJdkvZQqmhqVDFp1NTJU9k/CQaIB24iSnuXfjHi1+z
Lz4flTgIGuN6lNAKGGt51kBl+WGy8olUDuyMwFAP7f1WIK4OWKWK0SbmMeDZtdN/aEpRRQ6l
0QATNFeFf1cK8auS+lRgG7lj74w/KzGCA24wggNqAgEBMHUwZzELMAkGA1UEBhMCREUxEzAR
BgNVBAoTCkZyYXVuaG9mZXIxITAfBgNVBAsTGEZyYXVuaG9mZXIgQ29ycG9yYXRlIFBLSTEg
MB4GA1UEAxMXRnJhdW5ob2ZlciBVc2VyIENBIDIwMDcCCl7bNbYAAAAAoVUwCQYFKw4DAhoF
AKCCAc4wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTAwOTA2
MDg0MTMxWjAjBgkqhkiG9w0BCQQxFgQU4RpYBSTVQtW4tP+2+wdvxyEYf7YwXwYJKoZIhvcN
AQkPMVIwUDALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqG
SIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGEBgkrBgEEAYI3EAQxdzB1MGcx
CzAJBgNVBAYTAkRFMRMwEQYDVQQKEwpGcmF1bmhvZmVyMSEwHwYDVQQLExhGcmF1bmhvZmVy
IENvcnBvcmF0ZSBQS0kxIDAeBgNVBAMTF0ZyYXVuaG9mZXIgVXNlciBDQSAyMDA3Agpe2zMW
AAAAAKFUMIGGBgsqhkiG9w0BCRACCzF3oHUwZzELMAkGA1UEBhMCREUxEzARBgNVBAoTCkZy
YXVuaG9mZXIxITAfBgNVBAsTGEZyYXVuaG9mZXIgQ29ycG9yYXRlIFBLSTEgMB4GA1UEAxMX
RnJhdW5ob2ZlciBVc2VyIENBIDIwMDcCCl7bMxYAAAAAoVQwDQYJKoZIhvcNAQEBBQAEggEA
EmlAPDO3iHAYI3JfQL16R6T2f7DZ5jS4FQfLCHj36/3Dkl/Q2f1LFwfW/T4/VShMAq0GKrFa
00LHAu+75Bz6qLQWeVxIDDhfaDOBSJa1s3/y8U6BNQZClZ8nMVVBeRbDxXcsvofEQYbIzPt9
lssCQxcrheAZpJy7z/FFEpiBmZx2phqL6NKKxjDxkdL4SSrC8+7/Ywg+dVBRIjYmYiEXvM6m
zkityG+U1s+BBnI95x+j2E64Q2c1Lel/PTm7wRzZDlgXxcmpE+H8i1YMykMstr22XXGL503e
k8lh1WqZ8V3QIr7yk9xOCnagVA3GoiQbcbomURWYl5ONyyCaKxPNPgAAAAAAAA==
--------------ms070709020307020009040802--
