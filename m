Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab1CUPEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 11:04:16 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:51018 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751259Ab1CUPEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 11:04:14 -0400
X-Sasl-enc: PWwSA6qWA+k7jpnACW5KomZ6iWzOIOloDO2ywWKxfOPm 1300719853
From: Roberto Sassu <roberto.sassu@polito.it>
To: tyhicks@linux.vnet.ibm.com
Cc: kirkland@canonical.com, dhowells@redhat.com, jmorris@namei.org,
        linux-fsdevel@vger.kernel.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org, ecryptfs-devel@lists.launchpad.net,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [PATCH v2 0/5] eCryptfs key locking patches
Date: Mon, 21 Mar 2011 16:00:50 +0100
Message-Id: <1300719658-3184-1-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.7.4
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----26EB38108E5E47D2BA80565D14C7CA4B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------26EB38108E5E47D2BA80565D14C7CA4B

This patch set modifies the eCryptfs code in order to lock requested keys
while authentication tokens are used to encrypt or decrypt files.

Changelog:
  - removed patch "eCryptfs: ecryptfs_keyring_auth_tok_for_sig() bug fix"
	(already applied to the eCryptfs git repository at git.kernel.org);
  - added new patch "eCryptfs: removed num_global_auth_toks from 
	ecryptfs_mount_crypt_stat";
  - patch 3/5: avoid invalidating a global authentication token only if
	key_validate() returns the error -EKEYEXPIRED;
  - patch 3/5: added new function
	process_find_global_auth_tok_for_sig_err() to handle errors
	returned by ecryptfs_find_global_auth_tok_for_sig();
  - patch 3/5: return an error in the function
	ecryptfs_generate_key_packet_set() if at least one global
	authentication token cannot be retrieved.

Roberto Sassu


Roberto Sassu (5):
  eCryptfs: removed num_global_auth_toks from ecryptfs_mount_crypt_stat
  eCryptfs: modified size of keysig in the ecryptfs_key_sig structure
  eCryptfs: verify authentication tokens before their use
  eCryptfs: move ecryptfs_find_auth_tok_for_sig() call before
    mutex_lock
  eCryptfs: write lock requested keys

 fs/ecryptfs/crypto.c          |    1 -
 fs/ecryptfs/ecryptfs_kernel.h |    4 +-
 fs/ecryptfs/keystore.c        |  280 ++++++++++++++++++++++++++---------------
 fs/ecryptfs/main.c            |    8 +-
 4 files changed, 185 insertions(+), 108 deletions(-)

-- 
1.7.4


------26EB38108E5E47D2BA80565D14C7CA4B
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMTAzMjExNTAwNThaMCMGCSqG
SIb3DQEJBDEWBBRGZ16nobd+isjv8L8lRU1h8riJrzB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQB0zHBm0ZSNvpo9uom+CI/Thiir
/b71NXWdg19eTmN0Q4TnXv5U56GBEe+tjBQy2Ff5ddMDiTBCWfbTNIUF81avHLut
JH4mhIWTc0cCJmD45amMjbGe2MKmBTHWy/d03YpZMPJj0S8Tc8t4VFGOxnHpOmCy
12/9tcvIalX2Grq8iuiPjbzW6Dv4umQcPe8Gs5Ii3LqzbGsirhBwReJoHlgaH/YP
FDQ/wsihYdoAmKEN6O/qxOeRy906w/0U9VMnPwvNQeTMR0qgdZuD3urqC3atsbCT
DQMRjL3h+lzCX2jho7Yf364O/xhprqFUC4QF6JKnUimYP8p+1sN7DGKGHxY9

------26EB38108E5E47D2BA80565D14C7CA4B--


