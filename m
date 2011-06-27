Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab1F0LxB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 07:53:01 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:55423 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758830Ab1F0LvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 07:51:00 -0400
X-Sasl-enc: ZCPf4aS0FSLY+oBj4xzcRtReaOjHYQLjItEVNCliFSwn 1309175459
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Cc: keyrings@linux-nfs.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, dhowells@redhat.com, jmorris@namei.org,
        zohar@linux.vnet.ibm.com, safford@watson.ibm.com, ramunno@polito.it,
        tyhicks@linux.vnet.ibm.com, kirkland@canonical.com,
        ecryptfs-devel@lists.launchpad.net,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [PATCH v5 5/7] eCryptfs: export global eCryptfs definitions to include/linux/ecryptfs.h
Date: Mon, 27 Jun 2011 13:45:43 +0200
Message-Id: <1309175148-6651-6-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1309175148-6651-1-git-send-email-roberto.sassu@polito.it>
References: <1309175148-6651-1-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----D3D6A1FE84B6764E263F56369551AF77"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------D3D6A1FE84B6764E263F56369551AF77

Some eCryptfs specific definitions, such as the current version and the
authentication token structure, are moved to the new include file
'include/linux/ecryptfs.h', in order to be available for all kernel
subsystems.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
Acked-by: Gianluca Ramunno <ramunno@polito.it>
Acked-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Acked-by: David Howells <dhowells@redhat.com>
---
 fs/ecryptfs/ecryptfs_kernel.h |  109 +---------------------------------------
 include/linux/ecryptfs.h      |  113 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 114 insertions(+), 108 deletions(-)
 create mode 100644 include/linux/ecryptfs.h

diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index 43c7c43..bb8ec5d 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -36,125 +36,18 @@
 #include <linux/hash.h>
 #include <linux/nsproxy.h>
 #include <linux/backing-dev.h>
+#include <linux/ecryptfs.h>
 
-/* Version verification for shared data structures w/ userspace */
-#define ECRYPTFS_VERSION_MAJOR 0x00
-#define ECRYPTFS_VERSION_MINOR 0x04
-#define ECRYPTFS_SUPPORTED_FILE_VERSION 0x03
-/* These flags indicate which features are supported by the kernel
- * module; userspace tools such as the mount helper read
- * ECRYPTFS_VERSIONING_MASK from a sysfs handle in order to determine
- * how to behave. */
-#define ECRYPTFS_VERSIONING_PASSPHRASE            0x00000001
-#define ECRYPTFS_VERSIONING_PUBKEY                0x00000002
-#define ECRYPTFS_VERSIONING_PLAINTEXT_PASSTHROUGH 0x00000004
-#define ECRYPTFS_VERSIONING_POLICY                0x00000008
-#define ECRYPTFS_VERSIONING_XATTR                 0x00000010
-#define ECRYPTFS_VERSIONING_MULTKEY               0x00000020
-#define ECRYPTFS_VERSIONING_DEVMISC               0x00000040
-#define ECRYPTFS_VERSIONING_HMAC                  0x00000080
-#define ECRYPTFS_VERSIONING_FILENAME_ENCRYPTION   0x00000100
-#define ECRYPTFS_VERSIONING_GCM                   0x00000200
-#define ECRYPTFS_VERSIONING_MASK (ECRYPTFS_VERSIONING_PASSPHRASE \
-				  | ECRYPTFS_VERSIONING_PLAINTEXT_PASSTHROUGH \
-				  | ECRYPTFS_VERSIONING_PUBKEY \
-				  | ECRYPTFS_VERSIONING_XATTR \
-				  | ECRYPTFS_VERSIONING_MULTKEY \
-				  | ECRYPTFS_VERSIONING_DEVMISC \
-				  | ECRYPTFS_VERSIONING_FILENAME_ENCRYPTION)
-#define ECRYPTFS_MAX_PASSWORD_LENGTH 64
-#define ECRYPTFS_MAX_PASSPHRASE_BYTES ECRYPTFS_MAX_PASSWORD_LENGTH
-#define ECRYPTFS_SALT_SIZE 8
-#define ECRYPTFS_SALT_SIZE_HEX (ECRYPTFS_SALT_SIZE*2)
-/* The original signature size is only for what is stored on disk; all
- * in-memory representations are expanded hex, so it better adapted to
- * be passed around or referenced on the command line */
-#define ECRYPTFS_SIG_SIZE 8
-#define ECRYPTFS_SIG_SIZE_HEX (ECRYPTFS_SIG_SIZE*2)
-#define ECRYPTFS_PASSWORD_SIG_SIZE ECRYPTFS_SIG_SIZE_HEX
-#define ECRYPTFS_MAX_KEY_BYTES 64
-#define ECRYPTFS_MAX_ENCRYPTED_KEY_BYTES 512
 #define ECRYPTFS_DEFAULT_IV_BYTES 16
-#define ECRYPTFS_FILE_VERSION 0x03
 #define ECRYPTFS_DEFAULT_EXTENT_SIZE 4096
 #define ECRYPTFS_MINIMUM_HEADER_EXTENT_SIZE 8192
 #define ECRYPTFS_DEFAULT_MSG_CTX_ELEMS 32
 #define ECRYPTFS_DEFAULT_SEND_TIMEOUT HZ
 #define ECRYPTFS_MAX_MSG_CTX_TTL (HZ*3)
-#define ECRYPTFS_MAX_PKI_NAME_BYTES 16
 #define ECRYPTFS_DEFAULT_NUM_USERS 4
 #define ECRYPTFS_MAX_NUM_USERS 32768
 #define ECRYPTFS_XATTR_NAME "user.ecryptfs"
 
-#define RFC2440_CIPHER_DES3_EDE 0x02
-#define RFC2440_CIPHER_CAST_5 0x03
-#define RFC2440_CIPHER_BLOWFISH 0x04
-#define RFC2440_CIPHER_AES_128 0x07
-#define RFC2440_CIPHER_AES_192 0x08
-#define RFC2440_CIPHER_AES_256 0x09
-#define RFC2440_CIPHER_TWOFISH 0x0a
-#define RFC2440_CIPHER_CAST_6 0x0b
-
-#define RFC2440_CIPHER_RSA 0x01
-
-/**
- * For convenience, we may need to pass around the encrypted session
- * key between kernel and userspace because the authentication token
- * may not be extractable.  For example, the TPM may not release the
- * private key, instead requiring the encrypted data and returning the
- * decrypted data.
- */
-struct ecryptfs_session_key {
-#define ECRYPTFS_USERSPACE_SHOULD_TRY_TO_DECRYPT 0x00000001
-#define ECRYPTFS_USERSPACE_SHOULD_TRY_TO_ENCRYPT 0x00000002
-#define ECRYPTFS_CONTAINS_DECRYPTED_KEY 0x00000004
-#define ECRYPTFS_CONTAINS_ENCRYPTED_KEY 0x00000008
-	u32 flags;
-	u32 encrypted_key_size;
-	u32 decrypted_key_size;
-	u8 encrypted_key[ECRYPTFS_MAX_ENCRYPTED_KEY_BYTES];
-	u8 decrypted_key[ECRYPTFS_MAX_KEY_BYTES];
-};
-
-struct ecryptfs_password {
-	u32 password_bytes;
-	s32 hash_algo;
-	u32 hash_iterations;
-	u32 session_key_encryption_key_bytes;
-#define ECRYPTFS_PERSISTENT_PASSWORD 0x01
-#define ECRYPTFS_SESSION_KEY_ENCRYPTION_KEY_SET 0x02
-	u32 flags;
-	/* Iterated-hash concatenation of salt and passphrase */
-	u8 session_key_encryption_key[ECRYPTFS_MAX_KEY_BYTES];
-	u8 signature[ECRYPTFS_PASSWORD_SIG_SIZE + 1];
-	/* Always in expanded hex */
-	u8 salt[ECRYPTFS_SALT_SIZE];
-};
-
-enum ecryptfs_token_types {ECRYPTFS_PASSWORD, ECRYPTFS_PRIVATE_KEY};
-
-struct ecryptfs_private_key {
-	u32 key_size;
-	u32 data_len;
-	u8 signature[ECRYPTFS_PASSWORD_SIG_SIZE + 1];
-	char pki_type[ECRYPTFS_MAX_PKI_NAME_BYTES + 1];
-	u8 data[];
-};
-
-/* May be a password or a private key */
-struct ecryptfs_auth_tok {
-	u16 version; /* 8-bit major and 8-bit minor */
-	u16 token_type;
-#define ECRYPTFS_ENCRYPT_ONLY 0x00000001
-	u32 flags;
-	struct ecryptfs_session_key session_key;
-	u8 reserved[32];
-	union {
-		struct ecryptfs_password password;
-		struct ecryptfs_private_key private_key;
-	} token;
-} __attribute__ ((packed));
-
 void ecryptfs_dump_auth_tok(struct ecryptfs_auth_tok *auth_tok);
 extern void ecryptfs_to_hex(char *dst, char *src, size_t src_size);
 extern void ecryptfs_from_hex(char *dst, char *src, int dst_size);
diff --git a/include/linux/ecryptfs.h b/include/linux/ecryptfs.h
new file mode 100644
index 0000000..2224a8c
--- /dev/null
+++ b/include/linux/ecryptfs.h
@@ -0,0 +1,113 @@
+#ifndef _LINUX_ECRYPTFS_H
+#define _LINUX_ECRYPTFS_H
+
+/* Version verification for shared data structures w/ userspace */
+#define ECRYPTFS_VERSION_MAJOR 0x00
+#define ECRYPTFS_VERSION_MINOR 0x04
+#define ECRYPTFS_SUPPORTED_FILE_VERSION 0x03
+/* These flags indicate which features are supported by the kernel
+ * module; userspace tools such as the mount helper read
+ * ECRYPTFS_VERSIONING_MASK from a sysfs handle in order to determine
+ * how to behave. */
+#define ECRYPTFS_VERSIONING_PASSPHRASE            0x00000001
+#define ECRYPTFS_VERSIONING_PUBKEY                0x00000002
+#define ECRYPTFS_VERSIONING_PLAINTEXT_PASSTHROUGH 0x00000004
+#define ECRYPTFS_VERSIONING_POLICY                0x00000008
+#define ECRYPTFS_VERSIONING_XATTR                 0x00000010
+#define ECRYPTFS_VERSIONING_MULTKEY               0x00000020
+#define ECRYPTFS_VERSIONING_DEVMISC               0x00000040
+#define ECRYPTFS_VERSIONING_HMAC                  0x00000080
+#define ECRYPTFS_VERSIONING_FILENAME_ENCRYPTION   0x00000100
+#define ECRYPTFS_VERSIONING_GCM                   0x00000200
+#define ECRYPTFS_VERSIONING_MASK (ECRYPTFS_VERSIONING_PASSPHRASE \
+				  | ECRYPTFS_VERSIONING_PLAINTEXT_PASSTHROUGH \
+				  | ECRYPTFS_VERSIONING_PUBKEY \
+				  | ECRYPTFS_VERSIONING_XATTR \
+				  | ECRYPTFS_VERSIONING_MULTKEY \
+				  | ECRYPTFS_VERSIONING_DEVMISC \
+				  | ECRYPTFS_VERSIONING_FILENAME_ENCRYPTION)
+#define ECRYPTFS_MAX_PASSWORD_LENGTH 64
+#define ECRYPTFS_MAX_PASSPHRASE_BYTES ECRYPTFS_MAX_PASSWORD_LENGTH
+#define ECRYPTFS_SALT_SIZE 8
+#define ECRYPTFS_SALT_SIZE_HEX (ECRYPTFS_SALT_SIZE*2)
+/* The original signature size is only for what is stored on disk; all
+ * in-memory representations are expanded hex, so it better adapted to
+ * be passed around or referenced on the command line */
+#define ECRYPTFS_SIG_SIZE 8
+#define ECRYPTFS_SIG_SIZE_HEX (ECRYPTFS_SIG_SIZE*2)
+#define ECRYPTFS_PASSWORD_SIG_SIZE ECRYPTFS_SIG_SIZE_HEX
+#define ECRYPTFS_MAX_KEY_BYTES 64
+#define ECRYPTFS_MAX_ENCRYPTED_KEY_BYTES 512
+#define ECRYPTFS_FILE_VERSION 0x03
+#define ECRYPTFS_MAX_PKI_NAME_BYTES 16
+
+#define RFC2440_CIPHER_DES3_EDE 0x02
+#define RFC2440_CIPHER_CAST_5 0x03
+#define RFC2440_CIPHER_BLOWFISH 0x04
+#define RFC2440_CIPHER_AES_128 0x07
+#define RFC2440_CIPHER_AES_192 0x08
+#define RFC2440_CIPHER_AES_256 0x09
+#define RFC2440_CIPHER_TWOFISH 0x0a
+#define RFC2440_CIPHER_CAST_6 0x0b
+
+#define RFC2440_CIPHER_RSA 0x01
+
+/**
+ * For convenience, we may need to pass around the encrypted session
+ * key between kernel and userspace because the authentication token
+ * may not be extractable.  For example, the TPM may not release the
+ * private key, instead requiring the encrypted data and returning the
+ * decrypted data.
+ */
+struct ecryptfs_session_key {
+#define ECRYPTFS_USERSPACE_SHOULD_TRY_TO_DECRYPT 0x00000001
+#define ECRYPTFS_USERSPACE_SHOULD_TRY_TO_ENCRYPT 0x00000002
+#define ECRYPTFS_CONTAINS_DECRYPTED_KEY 0x00000004
+#define ECRYPTFS_CONTAINS_ENCRYPTED_KEY 0x00000008
+	u32 flags;
+	u32 encrypted_key_size;
+	u32 decrypted_key_size;
+	u8 encrypted_key[ECRYPTFS_MAX_ENCRYPTED_KEY_BYTES];
+	u8 decrypted_key[ECRYPTFS_MAX_KEY_BYTES];
+};
+
+struct ecryptfs_password {
+	u32 password_bytes;
+	s32 hash_algo;
+	u32 hash_iterations;
+	u32 session_key_encryption_key_bytes;
+#define ECRYPTFS_PERSISTENT_PASSWORD 0x01
+#define ECRYPTFS_SESSION_KEY_ENCRYPTION_KEY_SET 0x02
+	u32 flags;
+	/* Iterated-hash concatenation of salt and passphrase */
+	u8 session_key_encryption_key[ECRYPTFS_MAX_KEY_BYTES];
+	u8 signature[ECRYPTFS_PASSWORD_SIG_SIZE + 1];
+	/* Always in expanded hex */
+	u8 salt[ECRYPTFS_SALT_SIZE];
+};
+
+enum ecryptfs_token_types {ECRYPTFS_PASSWORD, ECRYPTFS_PRIVATE_KEY};
+
+struct ecryptfs_private_key {
+	u32 key_size;
+	u32 data_len;
+	u8 signature[ECRYPTFS_PASSWORD_SIG_SIZE + 1];
+	char pki_type[ECRYPTFS_MAX_PKI_NAME_BYTES + 1];
+	u8 data[];
+};
+
+/* May be a password or a private key */
+struct ecryptfs_auth_tok {
+	u16 version; /* 8-bit major and 8-bit minor */
+	u16 token_type;
+#define ECRYPTFS_ENCRYPT_ONLY 0x00000001
+	u32 flags;
+	struct ecryptfs_session_key session_key;
+	u8 reserved[32];
+	union {
+		struct ecryptfs_password password;
+		struct ecryptfs_private_key private_key;
+	} token;
+} __attribute__ ((packed));
+
+#endif /* _LINUX_ECRYPTFS_H */
-- 
1.7.4.4


------D3D6A1FE84B6764E263F56369551AF77
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMTA2MjcxMTQ2MjFaMCMGCSqG
SIb3DQEJBDEWBBSSV8kmINar9DnMKawGcKPvkv8WQjB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQArKYB1DuBcb6+hhISQVO0arqy3
pQQQn4+ft9kIzUZMpguFFRzcPWn2lXxm7RY/C0Jv1qC9m6Q5Zjyp34ZSq+CaI9Wk
xYeNnpyfmuariOxeWwIzMTK4ZeKYPFvDr4/eoCcF/h94c4KX0RCvGsD0Nzm0Konv
g4qlo17UsAVs+3h514kLo2gjdvYV8EDMD3HtP/9rJCRaF3w7mVd4u5npr70UZv9z
OMshXKoiOzlRBenFNNimiu8kDOL5JGPny2FFkSTPDd3jUg8OdnHBe5iT9mwxdG4q
I6fEwHfu0YtMqE6OYhuZahQTlCmg2qzihlc+jdD4Zf90w8aDZXsUIP9yNdY2

------D3D6A1FE84B6764E263F56369551AF77--


