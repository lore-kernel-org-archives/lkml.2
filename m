Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965616Ab2J3TTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 15:19:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934272Ab2J3TTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 15:19:45 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 01/23] KEYS: Rename public key parameter name arrays
To: rusty@rustcorp.com.au
Cc: dhowells@redhat.com, pjones@redhat.com, jwboyer@redhat.com, mjg@redhat.com,
        dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        keescook@chromium.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org
Date: Tue, 30 Oct 2012 19:19:37 +0000
Message-ID: <20121030191936.11000.32457.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121030191927.11000.68420.stgit@warthog.procyon.org.uk>
References: <20121030191927.11000.68420.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the arrays of public key parameters (public key algorithm names, hash
algorithm names and ID type names) so that the array name ends in "_name".

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/public_key.c      |   14 +++++++-------
 crypto/asymmetric_keys/x509_public_key.c |    8 ++++----
 include/crypto/public_key.h              |    6 +++---
 kernel/module_signing.c                  |    4 ++--
 4 files changed, 16 insertions(+), 16 deletions(-)


diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index cb2e291..b313df1 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -22,13 +22,13 @@
 
 MODULE_LICENSE("GPL");
 
-const char *const pkey_algo[PKEY_ALGO__LAST] = {
+const char *const pkey_algo_name[PKEY_ALGO__LAST] = {
 	[PKEY_ALGO_DSA]		= "DSA",
 	[PKEY_ALGO_RSA]		= "RSA",
 };
-EXPORT_SYMBOL_GPL(pkey_algo);
+EXPORT_SYMBOL_GPL(pkey_algo_name);
 
-const char *const pkey_hash_algo[PKEY_HASH__LAST] = {
+const char *const pkey_hash_algo_name[PKEY_HASH__LAST] = {
 	[PKEY_HASH_MD4]		= "md4",
 	[PKEY_HASH_MD5]		= "md5",
 	[PKEY_HASH_SHA1]	= "sha1",
@@ -38,13 +38,13 @@ const char *const pkey_hash_algo[PKEY_HASH__LAST] = {
 	[PKEY_HASH_SHA512]	= "sha512",
 	[PKEY_HASH_SHA224]	= "sha224",
 };
-EXPORT_SYMBOL_GPL(pkey_hash_algo);
+EXPORT_SYMBOL_GPL(pkey_hash_algo_name);
 
-const char *const pkey_id_type[PKEY_ID_TYPE__LAST] = {
+const char *const pkey_id_type_name[PKEY_ID_TYPE__LAST] = {
 	[PKEY_ID_PGP]		= "PGP",
 	[PKEY_ID_X509]		= "X509",
 };
-EXPORT_SYMBOL_GPL(pkey_id_type);
+EXPORT_SYMBOL_GPL(pkey_id_type_name);
 
 /*
  * Provide a part of a description of the key for /proc/keys.
@@ -56,7 +56,7 @@ static void public_key_describe(const struct key *asymmetric_key,
 
 	if (key)
 		seq_printf(m, "%s.%s",
-			   pkey_id_type[key->id_type], key->algo->name);
+			   pkey_id_type_name[key->id_type], key->algo->name);
 }
 
 /*
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 06007f0..afbbc36 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -49,7 +49,7 @@ static int x509_check_signature(const struct public_key *pub,
 	/* Allocate the hashing algorithm we're going to need and find out how
 	 * big the hash operational data will be.
 	 */
-	tfm = crypto_alloc_shash(pkey_hash_algo[cert->sig_hash_algo], 0, 0);
+	tfm = crypto_alloc_shash(pkey_hash_algo_name[cert->sig_hash_algo], 0, 0);
 	if (IS_ERR(tfm))
 		return (PTR_ERR(tfm) == -ENOENT) ? -ENOPKG : PTR_ERR(tfm);
 
@@ -117,7 +117,7 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 
 	pr_devel("Cert Issuer: %s\n", cert->issuer);
 	pr_devel("Cert Subject: %s\n", cert->subject);
-	pr_devel("Cert Key Algo: %s\n", pkey_algo[cert->pkey_algo]);
+	pr_devel("Cert Key Algo: %s\n", pkey_algo_name[cert->pkey_algo]);
 	pr_devel("Cert Valid From: %04ld-%02d-%02d %02d:%02d:%02d\n",
 		 cert->valid_from.tm_year + 1900, cert->valid_from.tm_mon + 1,
 		 cert->valid_from.tm_mday, cert->valid_from.tm_hour,
@@ -127,8 +127,8 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 		 cert->valid_to.tm_mday, cert->valid_to.tm_hour,
 		 cert->valid_to.tm_min,  cert->valid_to.tm_sec);
 	pr_devel("Cert Signature: %s + %s\n",
-		 pkey_algo[cert->sig_pkey_algo],
-		 pkey_hash_algo[cert->sig_hash_algo]);
+		 pkey_algo_name[cert->sig_pkey_algo],
+		 pkey_hash_algo_name[cert->sig_hash_algo]);
 
 	if (!cert->fingerprint || !cert->authority) {
 		pr_warn("Cert for '%s' must have SubjKeyId and AuthKeyId extensions\n",
diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
index f5b0224..619d570 100644
--- a/include/crypto/public_key.h
+++ b/include/crypto/public_key.h
@@ -22,7 +22,7 @@ enum pkey_algo {
 	PKEY_ALGO__LAST
 };
 
-extern const char *const pkey_algo[PKEY_ALGO__LAST];
+extern const char *const pkey_algo_name[PKEY_ALGO__LAST];
 
 enum pkey_hash_algo {
 	PKEY_HASH_MD4,
@@ -36,7 +36,7 @@ enum pkey_hash_algo {
 	PKEY_HASH__LAST
 };
 
-extern const char *const pkey_hash_algo[PKEY_HASH__LAST];
+extern const char *const pkey_hash_algo_name[PKEY_HASH__LAST];
 
 enum pkey_id_type {
 	PKEY_ID_PGP,		/* OpenPGP generated key ID */
@@ -44,7 +44,7 @@ enum pkey_id_type {
 	PKEY_ID_TYPE__LAST
 };
 
-extern const char *const pkey_id_type[PKEY_ID_TYPE__LAST];
+extern const char *const pkey_id_type_name[PKEY_ID_TYPE__LAST];
 
 /*
  * Cryptographic data for the public-key subtype of the asymmetric key type.
diff --git a/kernel/module_signing.c b/kernel/module_signing.c
index ea1b1df..015e5b7 100644
--- a/kernel/module_signing.c
+++ b/kernel/module_signing.c
@@ -54,7 +54,7 @@ static struct public_key_signature *mod_make_digest(enum pkey_hash_algo hash,
 	/* Allocate the hashing algorithm we're going to need and find out how
 	 * big the hash operational data will be.
 	 */
-	tfm = crypto_alloc_shash(pkey_hash_algo[hash], 0, 0);
+	tfm = crypto_alloc_shash(pkey_hash_algo_name[hash], 0, 0);
 	if (IS_ERR(tfm))
 		return (PTR_ERR(tfm) == -ENOENT) ? ERR_PTR(-ENOPKG) : ERR_CAST(tfm);
 
@@ -217,7 +217,7 @@ int mod_verify_sig(const void *mod, unsigned long *_modlen)
 		return -ENOPKG;
 
 	if (ms.hash >= PKEY_HASH__LAST ||
-	    !pkey_hash_algo[ms.hash])
+	    !pkey_hash_algo_name[ms.hash])
 		return -ENOPKG;
 
 	key = request_asymmetric_key(sig, ms.signer_len,

