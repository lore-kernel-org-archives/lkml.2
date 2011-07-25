Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab1GYUoj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 16:44:39 -0400
Received: from powered.by.root24.eu ([91.121.20.142]:40445 "EHLO Root24.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478Ab1GYUoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 16:44:37 -0400
Message-ID: <4E2DD5B2.8020205@ionic.de>
Date: Mon, 25 Jul 2011 22:44:34 +0200
From: Mihai Moldovan <ionic@ionic.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: [PATCH v2] fatfs: fix utf8 iocharset warning message
X-Enigmail-Version: 1.2
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms000502020100010603020807"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms000502020100010603020807
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

The fat_msg function already formats the given message and appends
a newline to it - we don't need to do this in the passed message
string as well, or will end up with a blank line printed in the
kernel log ring buffer.

Also change the loglevel from error to warning.

Signed-off-by: Mihai Moldovan <ionic@ionic.de>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---
 fs/fat/inode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 5942fec..6dbab1b 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -1188,9 +1188,9 @@ static int parse_options(struct super_block *sb,
char *options, int is_vfat,
 out:
 	/* UTF-8 doesn't provide FAT semantics */
 	if (!strcmp(opts->iocharset, "utf8")) {
-		fat_msg(sb, KERN_ERR, "utf8 is not a recommended IO charset"
+		fat_msg(sb, KERN_WARNING, "utf8 is not a recommended IO charset"
 		       " for FAT filesystems, filesystem will be "
-		       "case sensitive!\n");
+		       "case sensitive!");
 	}

 	/* If user doesn't specify allow_utime, it's initialized from dmask. */=

--=20
1.7.6


--------------ms000502020100010603020807
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIINBjCC
BjQwggQcoAMCAQICASAwDQYJKoZIhvcNAQEFBQAwfTELMAkGA1UEBhMCSUwxFjAUBgNVBAoT
DVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNp
Z25pbmcxKTAnBgNVBAMTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTA3
MTAyNDIxMDI1NVoXDTE3MTAyNDIxMDI1NVowgYwxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1T
dGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWdu
aW5nMTgwNgYDVQQDEy9TdGFydENvbSBDbGFzcyAyIFByaW1hcnkgSW50ZXJtZWRpYXRlIENs
aWVudCBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMsohUWcASz7GfKrpTOM
KqANy9BV7V0igWdGxA8IU77L3aTxErQ+fcxtDYZ36Z6GH0YFn7fq5RADteP0AYzrCA+EQTfi
8q1+kA3m0nwtwXG94M5sIqsvs7lRP1aycBke/s5g9hJHryZ2acScnzczjBCAo7X1v5G3yw8M
DP2m2RCye0KfgZ4nODerZJVzhAlOD9YejvAXZqHksw56HzElVIoYSZ3q4+RJuPXXfIoyby+Y
2m1E+YzX5iCZXBx05gk6MKAW1vaw4/v2OOLy6FZH3XHHtOkzUreG//CsFnB9+uaYSlR65cdG
zTsmoIK8WH1ygoXhRBm98SD7Hf/r3FELNvUCAwEAAaOCAa0wggGpMA8GA1UdEwEB/wQFMAMB
Af8wDgYDVR0PAQH/BAQDAgEGMB0GA1UdDgQWBBSuVYNv7DHKufcd+q9rMfPIHeOsuzAfBgNV
HSMEGDAWgBROC+8apEBbpRdphzDKNGhD0EGu8jBmBggrBgEFBQcBAQRaMFgwJwYIKwYBBQUH
MAGGG2h0dHA6Ly9vY3NwLnN0YXJ0c3NsLmNvbS9jYTAtBggrBgEFBQcwAoYhaHR0cDovL3d3
dy5zdGFydHNzbC5jb20vc2ZzY2EuY3J0MFsGA1UdHwRUMFIwJ6AloCOGIWh0dHA6Ly93d3cu
c3RhcnRzc2wuY29tL3Nmc2NhLmNybDAnoCWgI4YhaHR0cDovL2NybC5zdGFydHNzbC5jb20v
c2ZzY2EuY3JsMIGABgNVHSAEeTB3MHUGCysGAQQBgbU3AQIBMGYwLgYIKwYBBQUHAgEWImh0
dHA6Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeS5wZGYwNAYIKwYBBQUHAgEWKGh0dHA6Ly93
d3cuc3RhcnRzc2wuY29tL2ludGVybWVkaWF0ZS5wZGYwDQYJKoZIhvcNAQEFBQADggIBADqp
Jw3I07QWke9plNBpxUxcffc7nUrIQpJHDci91DFG7fVhHRkMZ1J+BKg5UNUxIFJ2Z9B90Mic
c/NXcs7kPBRdn6XGO/vPc87Y6R+cWS9Nc9+fp3Enmsm94OxOwI9wn8qnr/6o3mD4noP9Jphw
UPTXwHovjavRnhUQHLfo/i2NG0XXgTHXS2Xm0kVUozXqpYpAdumMiB/vezj1QHQJDmUdPYMc
p+reg9901zkyT3fDW/ivJVv6pWtkh6Pw2ytZT7mvg7YhX3V50Nv860cV11mocUVcqBLv0gcT
+HBDYtbuvexNftwNQKD5193A7zN4vG7CTYkXxytSjKuXrpEatEiFPxWgb84nVj25SU5q/r1X
hwby6mLhkbaXslkVtwEWT3Van49rKjlK4XrUKYYWtnfzq6aSak5u0Vpxd1rY79tWhD3EdCvO
hNz/QplNa+VkIsrcp7+8ZhP1l1b2U6MaxIVteuVMD3X0vziIwr7jxYae9FZjbxlpUemqXjcC
0QaFfN7qI0JsQMALL7iGRBg7K0CoOBzECdD3fuZil5kU/LP9cr1BK31U0Uy651bFnAMMMkqh
AChIbn0ei72VnbpSsrrSdF0BAGYQ8vyHae5aCg+H75dVCV33K6FuxZrf09yTz+Vx/PkdRUYk
XmZz/OTfyJXsUOUXrym6KvI2rYpccSk5MIIGyjCCBbKgAwIBAgICBnIwDQYJKoZIhvcNAQEF
BQAwgYwxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSswKQYDVQQLEyJT
ZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWduaW5nMTgwNgYDVQQDEy9TdGFydENvbSBD
bGFzcyAyIFByaW1hcnkgSW50ZXJtZWRpYXRlIENsaWVudCBDQTAeFw0xMDAzMjMxNjI2NTZa
Fw0xMjAzMjQwNTQ2MjJaMIHHMSAwHgYDVQQNExcxNjg2MTctOUo5elVlMUVuNHg5b3ZiTzEL
MAkGA1UEBhMCREUxGzAZBgNVBAgTEkJhZGVuLVd1ZXJ0dGVtYmVyZzESMBAGA1UEBxMJS2Fy
bHNydWhlMS0wKwYDVQQLEyRTdGFydENvbSBWZXJpZmllZCBDZXJ0aWZpY2F0ZSBNZW1iZXIx
FzAVBgNVBAMTDk1paGFpIE1vbGRvdmFuMR0wGwYJKoZIhvcNAQkBFg5pb25pY0Bpb25pYy5k
ZTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMssU6wPYwJJAxY07er/P6ANPXgz
yCczuA+7q/eql1St56r91yQ534A4oeXEqRZvpMsDuvczNG1Yz80nLpM+lO3Wg8csxaGReewe
RBIS3abf40HCIBVlOl7oTcmzZuzqz2KE70CHZ7p3k0WAEUfUb7AS8qrqxuoj0dtUkrdMwjoD
rPWs3zJ+vHo5FU3sTvj2ksiStjG3NMERBT+1Gzf2pVx2cKJRBmqACbKZfwE9QufRqrZT8bWY
i5DCV34RL7eVLnejLL+MvtarZv2K8Acojq9t7zO9Z+0rnlr6o46c2egVB+s/ol28q3DEce6f
p1KrCiujqRqQwVQ8O/2ogg4l5h0CAwEAAaOCAvcwggLzMAkGA1UdEwQCMAAwCwYDVR0PBAQD
AgSwMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDBDAdBgNVHQ4EFgQU3JbCyOa+BBzV
nBAKycZGQAzit2wwHwYDVR0jBBgwFoAUrlWDb+wxyrn3HfqvazHzyB3jrLswGQYDVR0RBBIw
EIEOaW9uaWNAaW9uaWMuZGUwggFCBgNVHSAEggE5MIIBNTCCATEGCysGAQQBgbU3AQIBMIIB
IDAuBggrBgEFBQcCARYiaHR0cDovL3d3dy5zdGFydHNzbC5jb20vcG9saWN5LnBkZjA0Bggr
BgEFBQcCARYoaHR0cDovL3d3dy5zdGFydHNzbC5jb20vaW50ZXJtZWRpYXRlLnBkZjCBtwYI
KwYBBQUHAgIwgaowFBYNU3RhcnRDb20gTHRkLjADAgEBGoGRTGltaXRlZCBMaWFiaWxpdHks
IHNlZSBzZWN0aW9uICpMZWdhbCBMaW1pdGF0aW9ucyogb2YgdGhlIFN0YXJ0Q29tIENlcnRp
ZmljYXRpb24gQXV0aG9yaXR5IFBvbGljeSBhdmFpbGFibGUgYXQgaHR0cDovL3d3dy5zdGFy
dHNzbC5jb20vcG9saWN5LnBkZjBjBgNVHR8EXDBaMCugKaAnhiVodHRwOi8vd3d3LnN0YXJ0
c3NsLmNvbS9jcnR1Mi1jcmwuY3JsMCugKaAnhiVodHRwOi8vY3JsLnN0YXJ0c3NsLmNvbS9j
cnR1Mi1jcmwuY3JsMIGOBggrBgEFBQcBAQSBgTB/MDkGCCsGAQUFBzABhi1odHRwOi8vb2Nz
cC5zdGFydHNzbC5jb20vc3ViL2NsYXNzMi9jbGllbnQvY2EwQgYIKwYBBQUHMAKGNmh0dHA6
Ly93d3cuc3RhcnRzc2wuY29tL2NlcnRzL3N1Yi5jbGFzczIuY2xpZW50LmNhLmNydDAjBgNV
HRIEHDAahhhodHRwOi8vd3d3LnN0YXJ0c3NsLmNvbS8wDQYJKoZIhvcNAQEFBQADggEBACle
v1JwhVI4Pu8GzKRJzJdcYdsT7fJ9R5OzNnec4CADsb9Xu7HDyRa5qABBXihHvmo+fxGVe6Hy
8TxPvZYCGaeUi2t6aodIFOTQDWcdEP9o7SynBOXHqsN2lZ08Q4MBuoGfquJi0XjpCNnLY9KS
OZTHTwAIqGVH7lf99egY1Atfl+y/Lc0e6Sw/0qvcnaQSzwCZ/OkqVWSTGDZXwCDFuy6Cbwjy
Kn9qshZzeMqvSKHmHPihzJQ6eVXImZgrgWk5FrBpO8d59xoqO32PbSyM0cZhqvkbG/nlWPbz
Xn13+cgG7ajAGCg8XueMeh3m03sIIHinvgaeHOAqeO3TvVVv6WQxggPNMIIDyQIBATCBkzCB
jDELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3Vy
ZSBEaWdpdGFsIENlcnRpZmljYXRlIFNpZ25pbmcxODA2BgNVBAMTL1N0YXJ0Q29tIENsYXNz
IDIgUHJpbWFyeSBJbnRlcm1lZGlhdGUgQ2xpZW50IENBAgIGcjAJBgUrDgMCGgUAoIICDjAY
BgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMTA3MjUyMDQ0MzRa
MCMGCSqGSIb3DQEJBDEWBBQfb/cmat4j32xpF6B9EDUF729C3zBfBgkqhkiG9w0BCQ8xUjBQ
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgaQGCSsGAQQBgjcQBDGBljCBkzCBjDELMAkG
A1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdp
dGFsIENlcnRpZmljYXRlIFNpZ25pbmcxODA2BgNVBAMTL1N0YXJ0Q29tIENsYXNzIDIgUHJp
bWFyeSBJbnRlcm1lZGlhdGUgQ2xpZW50IENBAgIGcjCBpgYLKoZIhvcNAQkQAgsxgZaggZMw
gYwxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1
cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWduaW5nMTgwNgYDVQQDEy9TdGFydENvbSBDbGFz
cyAyIFByaW1hcnkgSW50ZXJtZWRpYXRlIENsaWVudCBDQQICBnIwDQYJKoZIhvcNAQEBBQAE
ggEAx1carDT/FUXZ/JwcA0U0k+jxasX/YOLxYViGQu1dIjjqIXQxXih6duGVAiKE+pKxFuWt
2KpOypYlULDi3IHN2ZVBJB2aVF8bXwL9w4GMfbQBueI9BqfBj3W51Vg4q+MUtRZsWFZTZjqE
f1ypyf10q78aWBSJ8q1reyr0cgPvIHpRCR4MJ0hI93FgxgxfWWw0iU2QWtBdA+1OdiF1t+ug
D1v9eR2tZmJwa4bi/x94zijyqRxbDFKoxdHYZjkW7lLqvfIzazHpF3f1lriArdeLtw07EMAE
/yGWUGMGE5wssIHqAQFRGCLHlvEZteb77iGvnB5nrZkCo60nal2DdZXzmwAAAAAAAA==
--------------ms000502020100010603020807--
