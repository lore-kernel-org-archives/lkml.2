Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab1CUPEZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 11:04:25 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:36359 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753521Ab1CUPEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 11:04:20 -0400
X-Sasl-enc: HLArzNNZTiZIVIMLNnPxctY/UvAF4O96Q013eAdv7nmP 1300719859
From: Roberto Sassu <roberto.sassu@polito.it>
To: tyhicks@linux.vnet.ibm.com
Cc: kirkland@canonical.com, dhowells@redhat.com, jmorris@namei.org,
        linux-fsdevel@vger.kernel.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org, ecryptfs-devel@lists.launchpad.net,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [PATCH v2 1/5] eCryptfs: removed num_global_auth_toks from ecryptfs_mount_crypt_stat
Date: Mon, 21 Mar 2011 16:00:51 +0100
Message-Id: <1300719658-3184-2-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1300719658-3184-1-git-send-email-roberto.sassu@polito.it>
References: <1300719658-3184-1-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----EBE5D53A4519B70136405A28375AEECF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------EBE5D53A4519B70136405A28375AEECF

This patch removes the 'num_global_auth_toks' field of the
ecryptfs_mount_crypt_stat structure, used to count the number of items in
the 'global_auth_tok_list' list. This variable is not needed because there
are no checks based upon it.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
---
 fs/ecryptfs/crypto.c          |    1 -
 fs/ecryptfs/ecryptfs_kernel.h |    1 -
 fs/ecryptfs/keystore.c        |    1 -
 3 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index bfd8b68..38178ff 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -266,7 +266,6 @@ void ecryptfs_destroy_mount_crypt_stat(
 				 &mount_crypt_stat->global_auth_tok_list,
 				 mount_crypt_stat_list) {
 		list_del(&auth_tok->mount_crypt_stat_list);
-		mount_crypt_stat->num_global_auth_toks--;
 		if (auth_tok->global_auth_tok_key
 		    && !(auth_tok->flags & ECRYPTFS_AUTH_TOK_INVALID))
 			key_put(auth_tok->global_auth_tok_key);
diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index e007534..6ea1faa 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -380,7 +380,6 @@ struct ecryptfs_mount_crypt_stat {
 	u32 flags;
 	struct list_head global_auth_tok_list;
 	struct mutex global_auth_tok_list_mutex;
-	size_t num_global_auth_toks;
 	size_t global_default_cipher_key_size;
 	size_t global_default_fn_cipher_key_bytes;
 	unsigned char global_default_cipher_name[ECRYPTFS_MAX_CIPHER_NAME_SIZE
diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index 4feb78c..523e51d 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -2454,7 +2454,6 @@ ecryptfs_add_global_auth_tok(struct ecryptfs_mount_crypt_stat *mount_crypt_stat,
 	mutex_lock(&mount_crypt_stat->global_auth_tok_list_mutex);
 	list_add(&new_auth_tok->mount_crypt_stat_list,
 		 &mount_crypt_stat->global_auth_tok_list);
-	mount_crypt_stat->num_global_auth_toks++;
 	mutex_unlock(&mount_crypt_stat->global_auth_tok_list_mutex);
 out:
 	return rc;
-- 
1.7.4


------EBE5D53A4519B70136405A28375AEECF
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMTAzMjExNTAxMDlaMCMGCSqG
SIb3DQEJBDEWBBTW3uKYjlB1ekE3sLk9NNVDXNZ6FzB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQCwfPVPV88czY1umtzZZ7GQbieC
l1Mj25qzsytCvfXC7/EcDgKxbC+LtFhyI81wuQwwpbWpQHDAlMyX0SWeSH6YT5no
qg0kUdAyw/mLlnZqXx669yoJXb5PK/0kWTtzBqXctKTEYiQVLlM+gt4iss2YNW1N
qcZ0isMwWwH+6D/1rbfrBNIlQJbQ/NZKWcjz4vsaPGmIjN28rUxPE5pbLXGsWY8V
v06KISzme3uZJm6RCo0rxaktDKfzSmhMbg5rAV7aG5rEpPBpjGh5PtPpNw0lIXWt
7I4UxiuBHPs8HrDVWTw27Wa5Ihr58ihlKb2HN2IvI1YPf6ejmqNmVMO1KIji

------EBE5D53A4519B70136405A28375AEECF--


