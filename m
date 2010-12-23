Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab0LWRfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 12:35:41 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:50606 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753701Ab0LWRfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 12:35:37 -0500
X-Sasl-enc: i9qXYDF4ndYQpJzQCu8QMViGKq6XsVDgbR3S1c8+sFKK 1293125736
To: linux-security-module@vger.kernel.org
Subject: [RFC][PATCH 4/6] ecryptfs: export global ecryptfs definitions to include/linux/ecryptfs.h
From: Roberto Sassu <roberto.sassu@polito.it>
Date: Thu, 23 Dec 2010 18:35:32 +0100
Cc: keyrings@linux-nfs.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Gianluca Ramunno <ramunno@polito.it>,
        Tyler Hicks <tyhicks@linux.vnet.ibm.com>, kirkland@canonical.com
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1838943.iilOWeT4xR";
  protocol="application/pkcs7-signature";
  micalg=sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201012231835.33240.roberto.sassu@polito.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1838943.iilOWeT4xR
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Some ecryptfs specific definitions, such as the current version and the
authentication token structure, are moved to the new include file
'include/linux/ecryptfs.h', in order to be available for all kernel
subsystems.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
=2D--
 fs/ecryptfs/ecryptfs_kernel.h |  109 +------------------------------------=
=2D--
 include/linux/ecryptfs.h      |  113 +++++++++++++++++++++++++++++++++++++=
++++
 2 files changed, 114 insertions(+), 108 deletions(-)
 create mode 100644 include/linux/ecryptfs.h

diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index 0032a9f..a27cad4 100644
=2D-- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -36,125 +36,18 @@
 #include <linux/hash.h>
 #include <linux/nsproxy.h>
 #include <linux/backing-dev.h>
+#include <linux/ecryptfs.h>
=20
=2D/* Version verification for shared data structures w/ userspace */
=2D#define ECRYPTFS_VERSION_MAJOR 0x00
=2D#define ECRYPTFS_VERSION_MINOR 0x04
=2D#define ECRYPTFS_SUPPORTED_FILE_VERSION 0x03
=2D/* These flags indicate which features are supported by the kernel
=2D * module; userspace tools such as the mount helper read
=2D * ECRYPTFS_VERSIONING_MASK from a sysfs handle in order to determine
=2D * how to behave. */
=2D#define ECRYPTFS_VERSIONING_PASSPHRASE            0x00000001
=2D#define ECRYPTFS_VERSIONING_PUBKEY                0x00000002
=2D#define ECRYPTFS_VERSIONING_PLAINTEXT_PASSTHROUGH 0x00000004
=2D#define ECRYPTFS_VERSIONING_POLICY                0x00000008
=2D#define ECRYPTFS_VERSIONING_XATTR                 0x00000010
=2D#define ECRYPTFS_VERSIONING_MULTKEY               0x00000020
=2D#define ECRYPTFS_VERSIONING_DEVMISC               0x00000040
=2D#define ECRYPTFS_VERSIONING_HMAC                  0x00000080
=2D#define ECRYPTFS_VERSIONING_FILENAME_ENCRYPTION   0x00000100
=2D#define ECRYPTFS_VERSIONING_GCM                   0x00000200
=2D#define ECRYPTFS_VERSIONING_MASK (ECRYPTFS_VERSIONING_PASSPHRASE \
=2D				  | ECRYPTFS_VERSIONING_PLAINTEXT_PASSTHROUGH \
=2D				  | ECRYPTFS_VERSIONING_PUBKEY \
=2D				  | ECRYPTFS_VERSIONING_XATTR \
=2D				  | ECRYPTFS_VERSIONING_MULTKEY \
=2D				  | ECRYPTFS_VERSIONING_DEVMISC \
=2D				  | ECRYPTFS_VERSIONING_FILENAME_ENCRYPTION)
=2D#define ECRYPTFS_MAX_PASSWORD_LENGTH 64
=2D#define ECRYPTFS_MAX_PASSPHRASE_BYTES ECRYPTFS_MAX_PASSWORD_LENGTH
=2D#define ECRYPTFS_SALT_SIZE 8
=2D#define ECRYPTFS_SALT_SIZE_HEX (ECRYPTFS_SALT_SIZE*2)
=2D/* The original signature size is only for what is stored on disk; all
=2D * in-memory representations are expanded hex, so it better adapted to
=2D * be passed around or referenced on the command line */
=2D#define ECRYPTFS_SIG_SIZE 8
=2D#define ECRYPTFS_SIG_SIZE_HEX (ECRYPTFS_SIG_SIZE*2)
=2D#define ECRYPTFS_PASSWORD_SIG_SIZE ECRYPTFS_SIG_SIZE_HEX
=2D#define ECRYPTFS_MAX_KEY_BYTES 64
=2D#define ECRYPTFS_MAX_ENCRYPTED_KEY_BYTES 512
 #define ECRYPTFS_DEFAULT_IV_BYTES 16
=2D#define ECRYPTFS_FILE_VERSION 0x03
 #define ECRYPTFS_DEFAULT_EXTENT_SIZE 4096
 #define ECRYPTFS_MINIMUM_HEADER_EXTENT_SIZE 8192
 #define ECRYPTFS_DEFAULT_MSG_CTX_ELEMS 32
 #define ECRYPTFS_DEFAULT_SEND_TIMEOUT HZ
 #define ECRYPTFS_MAX_MSG_CTX_TTL (HZ*3)
=2D#define ECRYPTFS_MAX_PKI_NAME_BYTES 16
 #define ECRYPTFS_DEFAULT_NUM_USERS 4
 #define ECRYPTFS_MAX_NUM_USERS 32768
 #define ECRYPTFS_XATTR_NAME "user.ecryptfs"
=20
=2D#define RFC2440_CIPHER_DES3_EDE 0x02
=2D#define RFC2440_CIPHER_CAST_5 0x03
=2D#define RFC2440_CIPHER_BLOWFISH 0x04
=2D#define RFC2440_CIPHER_AES_128 0x07
=2D#define RFC2440_CIPHER_AES_192 0x08
=2D#define RFC2440_CIPHER_AES_256 0x09
=2D#define RFC2440_CIPHER_TWOFISH 0x0a
=2D#define RFC2440_CIPHER_CAST_6 0x0b
=2D
=2D#define RFC2440_CIPHER_RSA 0x01
=2D
=2D/**
=2D * For convenience, we may need to pass around the encrypted session
=2D * key between kernel and userspace because the authentication token
=2D * may not be extractable.  For example, the TPM may not release the
=2D * private key, instead requiring the encrypted data and returning the
=2D * decrypted data.
=2D */
=2Dstruct ecryptfs_session_key {
=2D#define ECRYPTFS_USERSPACE_SHOULD_TRY_TO_DECRYPT 0x00000001
=2D#define ECRYPTFS_USERSPACE_SHOULD_TRY_TO_ENCRYPT 0x00000002
=2D#define ECRYPTFS_CONTAINS_DECRYPTED_KEY 0x00000004
=2D#define ECRYPTFS_CONTAINS_ENCRYPTED_KEY 0x00000008
=2D	u32 flags;
=2D	u32 encrypted_key_size;
=2D	u32 decrypted_key_size;
=2D	u8 encrypted_key[ECRYPTFS_MAX_ENCRYPTED_KEY_BYTES];
=2D	u8 decrypted_key[ECRYPTFS_MAX_KEY_BYTES];
=2D};
=2D
=2Dstruct ecryptfs_password {
=2D	u32 password_bytes;
=2D	s32 hash_algo;
=2D	u32 hash_iterations;
=2D	u32 session_key_encryption_key_bytes;
=2D#define ECRYPTFS_PERSISTENT_PASSWORD 0x01
=2D#define ECRYPTFS_SESSION_KEY_ENCRYPTION_KEY_SET 0x02
=2D	u32 flags;
=2D	/* Iterated-hash concatenation of salt and passphrase */
=2D	u8 session_key_encryption_key[ECRYPTFS_MAX_KEY_BYTES];
=2D	u8 signature[ECRYPTFS_PASSWORD_SIG_SIZE + 1];
=2D	/* Always in expanded hex */
=2D	u8 salt[ECRYPTFS_SALT_SIZE];
=2D};
=2D
=2Denum ecryptfs_token_types {ECRYPTFS_PASSWORD, ECRYPTFS_PRIVATE_KEY};
=2D
=2Dstruct ecryptfs_private_key {
=2D	u32 key_size;
=2D	u32 data_len;
=2D	u8 signature[ECRYPTFS_PASSWORD_SIG_SIZE + 1];
=2D	char pki_type[ECRYPTFS_MAX_PKI_NAME_BYTES + 1];
=2D	u8 data[];
=2D};
=2D
=2D/* May be a password or a private key */
=2Dstruct ecryptfs_auth_tok {
=2D	u16 version; /* 8-bit major and 8-bit minor */
=2D	u16 token_type;
=2D#define ECRYPTFS_ENCRYPT_ONLY 0x00000001
=2D	u32 flags;
=2D	struct ecryptfs_session_key session_key;
=2D	u8 reserved[32];
=2D	union {
=2D		struct ecryptfs_password password;
=2D		struct ecryptfs_private_key private_key;
=2D	} token;
=2D} __attribute__ ((packed));
=2D
 void ecryptfs_dump_auth_tok(struct ecryptfs_auth_tok *auth_tok);
 extern void ecryptfs_to_hex(char *dst, char *src, size_t src_size);
 extern void ecryptfs_from_hex(char *dst, char *src, int dst_size);
diff --git a/include/linux/ecryptfs.h b/include/linux/ecryptfs.h
new file mode 100644
index 0000000..2224a8c
=2D-- /dev/null
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
=2D-=20
1.7.2.3


--nextPart1838943.iilOWeT4xR
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

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
IwQYMBaAFNB15T/ryrprllF8IKWYvfNn07RKMIGRBgNVHSAEgYkwgYYwPgYKKwYBBAGpBwEBAjAw
MC4GCCsGAQUFBwIBFiJodHRwOi8vd3d3LmV1cm9wa2kub3JnL2NhL2Nwcy8xLjIvMEQGCisGAQQB
qQcCAQIwNjA0BggrBgEFBQcCARYoaHR0cDovL3d3dy5pdGFseS5ldXJvcGtpLm9yZy9jYS9jcHMv
MS4yLzB+BggrBgEFBQcBAQRyMHAwKQYIKwYBBQUHMAGGHWh0dHA6Ly9vY3NwLml0YWx5LmV1cm9w
a2kub3JnMEMGCCsGAQUFBzAChjdodHRwOi8vd3d3Lml0YWx5LmV1cm9wa2kub3JnL2NhL2NlcnRz
L2V1cm9wa2lfaXRhbHkuY2VyMEIGA1UdHwQ7MDkwN6A1oDOGMWh0dHA6Ly93d3cuaXRhbHkuZXVy
b3BraS5vcmcvY2EvY3JsL2l0YWx5X2NybC5jcmwwDQYJKoZIhvcNAQEFBQADggEBAFNUlYhQGVuP
EVBOSNEuC80+3TebY0iGAK35IggW4LiuEHXRWoeKwBbryFfEcR8VnTovF4wufegac+uJZB2k+QLs
wC3zuJLIgbo593W83ShSG5aCJioMoQ5X9Zfd+j1BfIV/zARyhorEvgC7doGfBVxG3qAmQEYbonot
hz4UJWld3Gd3zmwpqpNMLG2JO3BJWOrAun9SWPVRLOE/92Pq/jTMB6Lkse0KNJTBbNHPUzydOzPU
tPA7JvMDnzb6L98hVVqKoxmJw3C2sV/NOl/tuTfS6dnZypZstRaOV0JSWgP4PAqcPte0N40h8q4D
/Rdg5P7EcUklgZqL57cyUCCQro8wggVgMIIESKADAgECAgICuzANBgkqhkiG9w0BAQUFADBlMQsw
CQYDVQQGEwJJVDEeMBwGA1UEChMVUG9saXRlY25pY28gZGkgVG9yaW5vMTYwNAYDVQQDEy1Qb2xp
dGVjbmljbyBkaSBUb3Jpbm8gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMTAxMjIwMTExOTU0
WhcNMTUxMjMxMjM1OTU5WjBfMQswCQYDVQQGEwJJVDEeMBwGA1UEChMVUG9saXRlY25pY28gZGkg
VG9yaW5vMRcwFQYDVQQDEw5Sb2JlcnRvICBTYXNzdTEXMBUGCgmSJomT8ixkAQETB2QwMjEzMDUw
ggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDS6p4SaJdmmJHJu9On9ZohhBFE2GgYiY7Y
tRnhhQJANfOtHEhSbpUMaSOfq/Pna6ipR5nAFrlM8cOGcSHZdxrPcgzeJU7F2v1fl2ThvFOcTIkc
C1aAJGQUuCaCXDlQt+KFecJWTrRZnalMHZueO+J6cgHcvR1CQz5e88dSzo3QXZy0w/hxGL9Ht9ve
lqsl48ohBk2rs/svAOCp6GfqT1Yxwx1p87d3ViTrmuZB4/X+da39nJqmo6AZ/y3Zg+r91BgNcfsH
VqFT0JTcG6qRIaeqTtqVYpYl+rH1rZzYCakDyQyys66sBvaXyaiMr0M+SpyH+LaGz5bDn5Odq16F
YEq7AgMBAAGjggIeMIICGjAOBgNVHQ8BAf8EBAMCA/gwJwYDVR0lBCAwHgYIKwYBBQUHAwIGCCsG
AQUFBwMDBggrBgEFBQcDBDAiBgNVHREEGzAZgRdyb2JlcnRvLnNhc3N1QHBvbGl0by5pdDAMBgNV
HRMBAf8EAjAAMB0GA1UdDgQWBBQgKbXSXn+j769x0tsZQ9pSOzIIdDAfBgNVHSMEGDAWgBTNm1tb
nup2IcQQaOjSLTfbHy/I5DCBywYDVR0gBIHDMIHAMD4GCisGAQQBqQcBAQIwMDAuBggrBgEFBQcC
ARYiaHR0cDovL3d3dy5ldXJvcGtpLm9yZy9jYS9jcHMvMS4yLzBEBgorBgEEAakHAgECMDYwNAYI
KwYBBQUHAgEWKGh0dHA6Ly93d3cuaXRhbHkuZXVyb3BraS5vcmcvY2EvY3BzLzEuMi8wOAYKKwYB
BAGVYgECAjAqMCgGCCsGAQUFBwIBFhxodHRwOi8vY2EucG9saXRvLml0L2Nwcy8yLjIvMGYGCCsG
AQUFBwEBBFowWDAhBggrBgEFBQcwAYYVaHR0cDovL29jc3AucG9saXRvLml0MDMGCCsGAQUFBzAC
hidodHRwOi8vY2EucG9saXRvLml0L2NlcnRzL3BvbGl0b19jYS5jZXIwNwYDVR0fBDAwLjAsoCqg
KIYmaHR0cDovL2NhLnBvbGl0by5pdC9jcmwvcG9saXRvX2NybC5jcmwwDQYJKoZIhvcNAQEFBQAD
ggEBADMe0aHcBJXV6pMJPVVSt1Vazd8YLuTLO45Igs9Sb2LuaO6pvcDGvq9dEJnBhP1B+zBAK6WE
A1PWb66xC4QXaJnlGZTXS3XeBivHWm6BNOH2kNeU0HBeGZCV/n5r70TPxkEAcc7u8YY2i6CiMM42
8YhZK8ZjoN9D3QNIRf4HZgh0FTbf8eL/XvBbK/oPC+Rew+Qql6M3DHnaS1q2SKUwwO/4VXA4JsOd
atFI68AMXH0Xx9UIcjRi+kvsyvwHlc0Z8AoAtfRMoIl4zFF4Qaowec2UunBKYlqPpFTtU9czuoEP
12A86nqSVsoNok2mZOeYa9IdIjeE2rfdKx6k3YNRg08xggIcMIICGAIBATBrMGUxCzAJBgNVBAYT
AklUMR4wHAYDVQQKExVQb2xpdGVjbmljbyBkaSBUb3Jpbm8xNjA0BgNVBAMTLVBvbGl0ZWNuaWNv
IGRpIFRvcmlubyBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eQICArswCQYFKw4DAhoFAKCBhzAYBgkq
hkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMDEyMjMxNzM1MzNaMCMGCSqG
SIb3DQEJBDEWBBS4+UPoYk3O9evHI2dfSg9ddDfhtjAoBgkqhkiG9w0BCQ8xGzAZMAsGCWCGSAFl
AwQBAjAKBggqhkiG9w0DBzANBgkqhkiG9w0BAQEFAASCAQC1xy993/Srxl3BBa5PoRvi0alS1P7/
w6uHBb2GPPWxzmu9a0dAjWrBtqyfOzg8TTXDAPOCUxtqni3ZuAEGiD2myTrXL/VaMpy2fGyDOezt
RSOq8jlQ+BA616T+4kdgllhIGUlCam90/Hpt0Yy1utdcby1o+QV/B0Wjob0AZOWFvxBDNYe2IIgS
4t+hphjNJulsVnoQSq4F2PfEa+E2wrsFFTuFevQlgr4RG+YTC0Fw+FYCak5gzbohtmJYIEAhYTJZ
/KvxraFMFTVXML00aE71n/CB7Cq6ZCbseQDvy2e23V6pHmrbP+zkJHdd+gdFsRaFQLN4BXx24Kq6
eBTAUzRBAAAAAAAA

--nextPart1838943.iilOWeT4xR--
