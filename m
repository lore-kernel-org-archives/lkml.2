Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148Ab1KBMlv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 08:41:51 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39249 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab1KBMlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 08:41:49 -0400
From: Roberto Sassu <roberto.sassu@polito.it>
To: keyrings@linux-nfs.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        safford@watson.ibm.com, zohar@us.ibm.com, dhowells@redhat.com,
        jmorris@namei.org, Roberto Sassu <roberto.sassu@polito.it>
Subject: [PATCH 1/2] trusted-key: allow overwriting the migratable flag
Date: Wed,  2 Nov 2011 13:41:18 +0100
Message-Id: <1320237682-3857-1-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.7.6.4
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----2A02F66388F696A441594133055C4E0A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------2A02F66388F696A441594133055C4E0A

The migratable should be modifiable during the key update() method. This
allows for example to update a migratable trusted key, wrapped by a TPM
key, to a a non-migratable one sealed under the SRK with a PCR set.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
---
 security/keys/trusted.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/security/keys/trusted.c b/security/keys/trusted.c
index 0c33e2e..8777015 100644
--- a/security/keys/trusted.c
+++ b/security/keys/trusted.c
@@ -1036,7 +1036,6 @@ static int trusted_update(struct key *key, const void *data, size_t datalen)
 		goto out;
 	}
 	/* copy old key values, and reseal with new pcrs */
-	new_p->migratable = p->migratable;
 	new_p->key_len = p->key_len;
 	memcpy(new_p->key, p->key, p->key_len);
 	dump_payload(p);
-- 
1.7.6.4


------2A02F66388F696A441594133055C4E0A
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"

MIIICQYJKoZIhvcNAQcCoIIH+jCCB/YCAQExCzAJBgUrDgMCGgUAMAsGCSqGSIb3
DQEHAaCCBWQwggVgMIIESKADAgECAgICuzANBgkqhkiG9w0BAQUFADBlMQswCQYD
VQQGEwJJVDEeMBwGA1UEChMVUG9saXRlY25pY28gZGkgVG9yaW5vMTYwNAYDVQQD
Ey1Qb2xpdGVjbmljbyBkaSBUb3Jpbm8gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkw
HhcNMTAxMjIwMTExOTU0WhcNMTUxMjMxMjM1OTU5WjBfMQswCQYDVQQGEwJJVDEe
MBwGA1UEChMVUG9saXRlY25pY28gZGkgVG9yaW5vMRcwFQYDVQQDEw5Sb2JlcnRv
ICBTYXNzdTEXMBUGCgmSJomT8ixkAQETB2QwMjEzMDUwggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQDS6p4SaJdmmJHJu9On9ZohhBFE2GgYiY7YtRnhhQJA
NfOtHEhSbpUMaSOfq/Pna6ipR5nAFrlM8cOGcSHZdxrPcgzeJU7F2v1fl2ThvFOc
TIkcC1aAJGQUuCaCXDlQt+KFecJWTrRZnalMHZueO+J6cgHcvR1CQz5e88dSzo3Q
XZy0w/hxGL9Ht9velqsl48ohBk2rs/svAOCp6GfqT1Yxwx1p87d3ViTrmuZB4/X+
da39nJqmo6AZ/y3Zg+r91BgNcfsHVqFT0JTcG6qRIaeqTtqVYpYl+rH1rZzYCakD
yQyys66sBvaXyaiMr0M+SpyH+LaGz5bDn5Odq16FYEq7AgMBAAGjggIeMIICGjAO
BgNVHQ8BAf8EBAMCA/gwJwYDVR0lBCAwHgYIKwYBBQUHAwIGCCsGAQUFBwMDBggr
BgEFBQcDBDAiBgNVHREEGzAZgRdyb2JlcnRvLnNhc3N1QHBvbGl0by5pdDAMBgNV
HRMBAf8EAjAAMB0GA1UdDgQWBBQgKbXSXn+j769x0tsZQ9pSOzIIdDAfBgNVHSME
GDAWgBTNm1tbnup2IcQQaOjSLTfbHy/I5DCBywYDVR0gBIHDMIHAMD4GCisGAQQB
qQcBAQIwMDAuBggrBgEFBQcCARYiaHR0cDovL3d3dy5ldXJvcGtpLm9yZy9jYS9j
cHMvMS4yLzBEBgorBgEEAakHAgECMDYwNAYIKwYBBQUHAgEWKGh0dHA6Ly93d3cu
aXRhbHkuZXVyb3BraS5vcmcvY2EvY3BzLzEuMi8wOAYKKwYBBAGVYgECAjAqMCgG
CCsGAQUFBwIBFhxodHRwOi8vY2EucG9saXRvLml0L2Nwcy8yLjIvMGYGCCsGAQUF
BwEBBFowWDAhBggrBgEFBQcwAYYVaHR0cDovL29jc3AucG9saXRvLml0MDMGCCsG
AQUFBzAChidodHRwOi8vY2EucG9saXRvLml0L2NlcnRzL3BvbGl0b19jYS5jZXIw
NwYDVR0fBDAwLjAsoCqgKIYmaHR0cDovL2NhLnBvbGl0by5pdC9jcmwvcG9saXRv
X2NybC5jcmwwDQYJKoZIhvcNAQEFBQADggEBADMe0aHcBJXV6pMJPVVSt1Vazd8Y
LuTLO45Igs9Sb2LuaO6pvcDGvq9dEJnBhP1B+zBAK6WEA1PWb66xC4QXaJnlGZTX
S3XeBivHWm6BNOH2kNeU0HBeGZCV/n5r70TPxkEAcc7u8YY2i6CiMM428YhZK8Zj
oN9D3QNIRf4HZgh0FTbf8eL/XvBbK/oPC+Rew+Qql6M3DHnaS1q2SKUwwO/4VXA4
JsOdatFI68AMXH0Xx9UIcjRi+kvsyvwHlc0Z8AoAtfRMoIl4zFF4Qaowec2UunBK
YlqPpFTtU9czuoEP12A86nqSVsoNok2mZOeYa9IdIjeE2rfdKx6k3YNRg08xggJt
MIICaQIBATBrMGUxCzAJBgNVBAYTAklUMR4wHAYDVQQKExVQb2xpdGVjbmljbyBk
aSBUb3Jpbm8xNjA0BgNVBAMTLVBvbGl0ZWNuaWNvIGRpIFRvcmlubyBDZXJ0aWZp
Y2F0aW9uIEF1dGhvcml0eQICArswCQYFKw4DAhoFAKCB2DAYBgkqhkiG9w0BCQMx
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMTExMDIxMjQxMjJaMCMGCSqG
SIb3DQEJBDEWBBSeXxY14kHSYWOL4fyWDFK9b8Qi/DB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQA2VK92M2j1EraY34cmGVPfnpsl
hJ7cEpl+r688EidEYBdQicRcd4/4+UsB2Qs6EfJZStcNV1ZG3+JQiU6bOJMNDlD5
hrIJzjppLVPWbu2RWMU+peNQmtKBGpCxaw8eMijJ05xR7uyELevzdmuHf7O4fOP4
wLceZ5FLcOHplT4bdbCym1pPy8DsS9VBLNN3aOHpWezRAZ2gm787kzBwP9kZ5X34
xF1pj5LYfhRcOgTfIv+AHZFN2etcB/vDPBkLY0+GSs+G+TdYdCrOwVk25PgMeRon
nZ0PG0kQJd3Wi2iw8Zp4GLaREY258Yuaca2eAhR94xO31OlFa+lBo1AUO2Hp

------2A02F66388F696A441594133055C4E0A--


