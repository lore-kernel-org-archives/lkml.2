Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab0HTIt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:49:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661Ab0HTIqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:46:53 -0400
From: =?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-crypto@vger.kernel.org,
        Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
        Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
Subject: [PATCH 10/19] Add libtomcrypt implementation
Date: Fri, 20 Aug 2010 10:45:53 +0200
Message-Id: <1282293963-27807-11-git-send-email-mitr@redhat.com>
In-Reply-To: <1282293963-27807-1-git-send-email-mitr@redhat.com>
References: <1282293963-27807-1-git-send-email-mitr@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No use postponing it any more I'm afraid.

(Reviewing this in detail is probably premature, we are considering
replacing the implementation by something based on libgcrypt, which is
more actively maintained and has been probably more thorouhgly examined
for vulnerabilities.)
---
 crypto/userspace/Makefile                          |   38 ++-
 .../libtomcrypt/hashes/crypt_hash_is_valid.c       |   30 ++
 crypto/userspace/libtomcrypt/hashes/hash_get_oid.c |   78 ++++
 crypto/userspace/libtomcrypt/hashes/hash_memory.c  |   66 ++++
 .../libtomcrypt/hashes/hash_memory_multi.c         |   84 +++++
 .../userspace/libtomcrypt/headers/tomcrypt_prng.h  |   80 ++++
 crypto/userspace/libtomcrypt/math/rand_prime.c     |   80 ++++
 .../libtomcrypt/misc/crypt/crypt_argchk.c          |   28 ++
 crypto/userspace/libtomcrypt/misc/pk_get_oid.c     |   40 ++
 crypto/userspace/libtomcrypt/misc/qsort.c          |  247 ++++++++++++
 crypto/userspace/libtomcrypt/misc/zeromem.c        |   34 ++
 .../pk/asn1/der/bit/der_decode_bit_string.c        |  106 ++++++
 .../pk/asn1/der/bit/der_encode_bit_string.c        |   92 +++++
 .../pk/asn1/der/bit/der_length_bit_string.c        |   54 +++
 .../pk/asn1/der/boolean/der_decode_boolean.c       |   47 +++
 .../pk/asn1/der/boolean/der_encode_boolean.c       |   51 +++
 .../pk/asn1/der/boolean/der_length_boolean.c       |   35 ++
 .../pk/asn1/der/choice/der_decode_choice.c         |  182 +++++++++
 .../pk/asn1/der/ia5/der_decode_ia5_string.c        |   96 +++++
 .../pk/asn1/der/ia5/der_encode_ia5_string.c        |   85 +++++
 .../pk/asn1/der/ia5/der_length_ia5_string.c        |  194 ++++++++++
 .../pk/asn1/der/integer/der_decode_integer.c       |  110 ++++++
 .../pk/asn1/der/integer/der_encode_integer.c       |  130 +++++++
 .../pk/asn1/der/integer/der_length_integer.c       |   82 ++++
 .../der_decode_object_identifier.c                 |   99 +++++
 .../der_encode_object_identifier.c                 |  111 ++++++
 .../der_length_object_identifier.c                 |   89 +++++
 .../pk/asn1/der/octet/der_decode_octet_string.c    |   91 +++++
 .../pk/asn1/der/octet/der_encode_octet_string.c    |   86 +++++
 .../pk/asn1/der/octet/der_length_octet_string.c    |   53 +++
 .../printable_string/der_decode_printable_string.c |   96 +++++
 .../printable_string/der_encode_printable_string.c |   85 +++++
 .../printable_string/der_length_printable_string.c |  166 ++++++++
 .../pk/asn1/der/sequence/der_decode_sequence_ex.c  |  287 ++++++++++++++
 .../asn1/der/sequence/der_decode_sequence_flexi.c  |  394 ++++++++++++++++++++
 .../asn1/der/sequence/der_decode_sequence_multi.c  |  140 +++++++
 .../pk/asn1/der/sequence/der_encode_sequence_ex.c  |  335 +++++++++++++++++
 .../asn1/der/sequence/der_encode_sequence_multi.c  |  139 +++++++
 .../pk/asn1/der/sequence/der_length_sequence.c     |  169 +++++++++
 .../pk/asn1/der/sequence/der_sequence_free.c       |   66 ++++
 .../libtomcrypt/pk/asn1/der/set/der_encode_set.c   |  104 +++++
 .../libtomcrypt/pk/asn1/der/set/der_encode_setof.c |  163 ++++++++
 .../der/short_integer/der_decode_short_integer.c   |   68 ++++
 .../der/short_integer/der_encode_short_integer.c   |   97 +++++
 .../der/short_integer/der_length_short_integer.c   |   70 ++++
 .../pk/asn1/der/utctime/der_decode_utctime.c       |  127 +++++++
 .../pk/asn1/der/utctime/der_encode_utctime.c       |   83 ++++
 .../pk/asn1/der/utctime/der_length_utctime.c       |   46 +++
 .../pk/asn1/der/utf8/der_decode_utf8_string.c      |  111 ++++++
 .../pk/asn1/der/utf8/der_encode_utf8_string.c      |  105 ++++++
 .../pk/asn1/der/utf8/der_length_utf8_string.c      |   83 ++++
 .../der/x509/der_decode_subject_public_key_info.c  |  112 ++++++
 .../der/x509/der_encode_subject_public_key_info.c  |   83 ++++
 crypto/userspace/libtomcrypt/pk/dsa/dsa_export.c   |   99 +++++
 crypto/userspace/libtomcrypt/pk/dsa/dsa_free.c     |   34 ++
 crypto/userspace/libtomcrypt/pk/dsa/dsa_import.c   |  101 +++++
 crypto/userspace/libtomcrypt/pk/dsa/dsa_make_key.c |  125 ++++++
 .../userspace/libtomcrypt/pk/dsa/dsa_sign_hash.c   |  147 ++++++++
 .../userspace/libtomcrypt/pk/dsa/dsa_verify_hash.c |  126 +++++++
 .../userspace/libtomcrypt/pk/dsa/dsa_verify_key.c  |  100 +++++
 .../userspace/libtomcrypt/pk/pkcs1/pkcs_1_i2osp.c  |   51 +++
 .../userspace/libtomcrypt/pk/pkcs1/pkcs_1_mgf1.c   |   91 +++++
 .../libtomcrypt/pk/pkcs1/pkcs_1_oaep_decode.c      |  192 ++++++++++
 .../libtomcrypt/pk/pkcs1/pkcs_1_oaep_encode.c      |  164 ++++++++
 .../userspace/libtomcrypt/pk/pkcs1/pkcs_1_os2ip.c  |   36 ++
 .../libtomcrypt/pk/pkcs1/pkcs_1_pss_decode.c       |  168 +++++++++
 .../libtomcrypt/pk/pkcs1/pkcs_1_pss_encode.c       |  157 ++++++++
 .../libtomcrypt/pk/pkcs1/pkcs_1_v1_5_decode.c      |  110 ++++++
 .../libtomcrypt/pk/pkcs1/pkcs_1_v1_5_encode.c      |   95 +++++
 .../userspace/libtomcrypt/pk/rsa/rsa_decrypt_key.c |  107 ++++++
 .../userspace/libtomcrypt/pk/rsa/rsa_encrypt_key.c |   96 +++++
 crypto/userspace/libtomcrypt/pk/rsa/rsa_export.c   |   87 +++++
 crypto/userspace/libtomcrypt/pk/rsa/rsa_exptmod.c  |  147 ++++++++
 crypto/userspace/libtomcrypt/pk/rsa/rsa_free.c     |   34 ++
 crypto/userspace/libtomcrypt/pk/rsa/rsa_import.c   |  128 +++++++
 crypto/userspace/libtomcrypt/pk/rsa/rsa_make_key.c |  105 ++++++
 .../userspace/libtomcrypt/pk/rsa/rsa_sign_hash.c   |  130 +++++++
 .../userspace/libtomcrypt/pk/rsa/rsa_verify_hash.c |  170 +++++++++
 78 files changed, 8526 insertions(+), 1 deletions(-)
 create mode 100644 crypto/userspace/libtomcrypt/hashes/crypt_hash_is_valid.c
 create mode 100644 crypto/userspace/libtomcrypt/hashes/hash_get_oid.c
 create mode 100644 crypto/userspace/libtomcrypt/hashes/hash_memory.c
 create mode 100644 crypto/userspace/libtomcrypt/hashes/hash_memory_multi.c
 create mode 100644 crypto/userspace/libtomcrypt/headers/tomcrypt_prng.h
 create mode 100644 crypto/userspace/libtomcrypt/math/rand_prime.c
 create mode 100644 crypto/userspace/libtomcrypt/misc/crypt/crypt_argchk.c
 create mode 100644 crypto/userspace/libtomcrypt/misc/pk_get_oid.c
 create mode 100644 crypto/userspace/libtomcrypt/misc/qsort.c
 create mode 100644 crypto/userspace/libtomcrypt/misc/zeromem.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/asn1/der/bit/der_decode_bit_string.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/asn1/der/bit/der_encode_bit_string.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/asn1/der/bit/der_length_bit_string.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/asn1/der/boolean/der_decode_boolean.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/asn1/der/boolean/der_encode_boolean.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/asn1/der/boolean/der_length_boolean.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/asn1/der/choice/der_decode_choice.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/asn1/der/ia5/der_decode_ia5_string.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/asn1/der/ia5/der_encode_ia5_string.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/asn1/der/ia5/der_length_ia5_string.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/asn1/der/integer/der_decode_integer.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/asn1/der/integer/der_encode_integer.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/asn1/der/integer/der_length_integer.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/asn1/der/object_identifier/der_decode_object_identifier.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/asn1/der/object_identifier/der_encode_object_identifier.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/asn1/der/object_identifier/der_length_object_identifier.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/asn1/der/octet/der_decode_octet_string.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/asn1/der/octet/der_encode_octet_string.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/asn1/der/octet/der_length_octet_string.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/asn1/der/printable_string/der_decode_printable_string.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/asn1/der/printable_string/der_encode_printable_string.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/asn1/der/printable_string/der_length_printable_string.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/asn1/der/sequence/der_decode_sequence_ex.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/asn1/der/sequence/der_decode_sequence_flexi.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/asn1/der/sequence/der_decode_sequence_multi.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/asn1/der/sequence/der_encode_sequence_ex.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/asn1/der/sequence/der_encode_sequence_multi.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/asn1/der/sequence/der_length_sequence.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/asn1/der/sequence/der_sequence_free.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/asn1/der/set/der_encode_set.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/asn1/der/set/der_encode_setof.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/asn1/der/short_integer/der_decode_short_integer.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/asn1/der/short_integer/der_encode_short_integer.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/asn1/der/short_integer/der_length_short_integer.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/asn1/der/utctime/der_decode_utctime.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/asn1/der/utctime/der_encode_utctime.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/asn1/der/utctime/der_length_utctime.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/asn1/der/utf8/der_decode_utf8_string.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/asn1/der/utf8/der_encode_utf8_string.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/asn1/der/utf8/der_length_utf8_string.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/asn1/der/x509/der_decode_subject_public_key_info.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/asn1/der/x509/der_encode_subject_public_key_info.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/dsa/dsa_export.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/dsa/dsa_free.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/dsa/dsa_import.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/dsa/dsa_make_key.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/dsa/dsa_sign_hash.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/dsa/dsa_verify_hash.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/dsa/dsa_verify_key.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/pkcs1/pkcs_1_i2osp.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/pkcs1/pkcs_1_mgf1.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/pkcs1/pkcs_1_oaep_decode.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/pkcs1/pkcs_1_oaep_encode.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/pkcs1/pkcs_1_os2ip.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/pkcs1/pkcs_1_pss_decode.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/pkcs1/pkcs_1_pss_encode.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/pkcs1/pkcs_1_v1_5_decode.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/pkcs1/pkcs_1_v1_5_encode.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/rsa/rsa_decrypt_key.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/rsa/rsa_encrypt_key.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/rsa/rsa_export.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/rsa/rsa_exptmod.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/rsa/rsa_free.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/rsa/rsa_import.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/rsa/rsa_make_key.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/rsa/rsa_sign_hash.c
 create mode 100644 crypto/userspace/libtomcrypt/pk/rsa/rsa_verify_hash.c

diff --git a/crypto/userspace/Makefile b/crypto/userspace/Makefile
index 60a9b31..81e4122 100644
--- a/crypto/userspace/Makefile
+++ b/crypto/userspace/Makefile
@@ -28,8 +28,44 @@ TOMMATH_OBJECTS = libtommath/bncore.o libtommath/bn_mp_init.o libtommath/bn_mp_c
 	libtommath/bn_mp_init_set_int.o libtommath/bn_mp_invmod_slow.o libtommath/bn_mp_prime_rabin_miller_trials.o \
 	libtommath/bn_mp_to_signed_bin_n.o libtommath/bn_mp_to_unsigned_bin_n.o
 
+TOMCRYPT_OBJECTS = libtomcrypt/misc/zeromem.o libtomcrypt/misc/crypt/crypt_argchk.o \
+	libtomcrypt/math/rand_prime.o  libtomcrypt/misc/qsort.o libtomcrypt/hashes/hash_get_oid.o \
+	libtomcrypt/hashes/crypt_hash_is_valid.o libtomcrypt/hashes/hash_memory.o libtomcrypt/hashes/hash_memory_multi.o \
+	libtomcrypt/pk/dsa/dsa_make_key.o libtomcrypt/pk/dsa/dsa_export.o libtomcrypt/pk/dsa/dsa_import.o \
+	libtomcrypt/pk/dsa/dsa_free.o libtomcrypt/pk/dsa/dsa_sign_hash.o libtomcrypt/pk/dsa/dsa_verify_hash.o \
+	libtomcrypt/pk/dsa/dsa_verify_key.o \
+	libtomcrypt/pk/asn1/der/bit/der_decode_bit_string.o libtomcrypt/pk/asn1/der/bit/der_encode_bit_string.o \
+	libtomcrypt/pk/asn1/der/bit/der_length_bit_string.o libtomcrypt/pk/asn1/der/boolean/der_decode_boolean.o \
+	libtomcrypt/pk/asn1/der/boolean/der_encode_boolean.o libtomcrypt/pk/asn1/der/boolean/der_length_boolean.o \
+	libtomcrypt/pk/asn1/der/choice/der_decode_choice.o libtomcrypt/pk/asn1/der/ia5/der_decode_ia5_string.o \
+	libtomcrypt/pk/asn1/der/ia5/der_encode_ia5_string.o libtomcrypt/pk/asn1/der/ia5/der_length_ia5_string.o \
+	libtomcrypt/pk/asn1/der/integer/der_decode_integer.o libtomcrypt/pk/asn1/der/integer/der_encode_integer.o \
+	libtomcrypt/pk/asn1/der/integer/der_length_integer.o libtomcrypt/pk/asn1/der/object_identifier/der_decode_object_identifier.o \
+	libtomcrypt/pk/asn1/der/object_identifier/der_encode_object_identifier.o libtomcrypt/pk/asn1/der/object_identifier/der_length_object_identifier.o \
+	libtomcrypt/pk/asn1/der/octet/der_decode_octet_string.o libtomcrypt/pk/asn1/der/octet/der_encode_octet_string.o \
+	libtomcrypt/pk/asn1/der/octet/der_length_octet_string.o libtomcrypt/pk/asn1/der/printable_string/der_decode_printable_string.o \
+	libtomcrypt/pk/asn1/der/printable_string/der_encode_printable_string.o libtomcrypt/pk/asn1/der/printable_string/der_length_printable_string.o \
+	libtomcrypt/pk/asn1/der/sequence/der_decode_sequence_ex.o libtomcrypt/pk/asn1/der/sequence/der_decode_sequence_flexi.o \
+	libtomcrypt/pk/asn1/der/sequence/der_decode_sequence_multi.o libtomcrypt/pk/asn1/der/sequence/der_encode_sequence_ex.o \
+	libtomcrypt/pk/asn1/der/sequence/der_encode_sequence_multi.o libtomcrypt/pk/asn1/der/sequence/der_length_sequence.o \
+	libtomcrypt/pk/asn1/der/sequence/der_sequence_free.o libtomcrypt/pk/asn1/der/short_integer/der_decode_short_integer.o \
+	libtomcrypt/pk/asn1/der/short_integer/der_encode_short_integer.o libtomcrypt/pk/asn1/der/short_integer/der_length_short_integer.o \
+	libtomcrypt/pk/asn1/der/utctime/der_decode_utctime.o libtomcrypt/pk/asn1/der/utctime/der_encode_utctime.o \
+	libtomcrypt/pk/asn1/der/utctime/der_length_utctime.o libtomcrypt/pk/asn1/der/utf8/der_decode_utf8_string.o \
+	libtomcrypt/pk/asn1/der/utf8/der_encode_utf8_string.o libtomcrypt/pk/asn1/der/utf8/der_length_utf8_string.o \
+	libtomcrypt/pk/asn1/der/set/der_encode_set.o  libtomcrypt/pk/asn1/der/set/der_encode_setof.o \
+	libtomcrypt/pk/rsa/rsa_decrypt_key.o libtomcrypt/pk/rsa/rsa_encrypt_key.o libtomcrypt/pk/rsa/rsa_export.o \
+	libtomcrypt/pk/rsa/rsa_exptmod.o libtomcrypt/pk/rsa/rsa_free.o libtomcrypt/pk/rsa/rsa_import.o \
+	libtomcrypt/pk/rsa/rsa_make_key.o libtomcrypt/pk/rsa/rsa_sign_hash.o libtomcrypt/pk/rsa/rsa_verify_hash.o \
+	libtomcrypt/pk/pkcs1/pkcs_1_i2osp.o libtomcrypt/pk/pkcs1/pkcs_1_mgf1.o 	libtomcrypt/pk/pkcs1/pkcs_1_oaep_decode.o \
+	libtomcrypt/pk/pkcs1/pkcs_1_oaep_encode.o libtomcrypt/pk/pkcs1/pkcs_1_os2ip.o libtomcrypt/pk/pkcs1/pkcs_1_pss_decode.o \
+	libtomcrypt/pk/pkcs1/pkcs_1_pss_encode.o libtomcrypt/pk/pkcs1/pkcs_1_v1_5_decode.o libtomcrypt/pk/pkcs1/pkcs_1_v1_5_encode.o \
+	libtomcrypt/misc/pk_get_oid.o libtomcrypt/pk/asn1/der/x509/der_encode_subject_public_key_info.o \
+	libtomcrypt/pk/asn1/der/x509/der_decode_subject_public_key_info.o
+
 cryptodev-objs := cryptodev_main.o cryptodev_cipher.o ncr-limits.o \
-	utils.o $(TOMMATH_OBJECTS)
+	utils.o $(TOMMATH_OBJECTS) \
+	$(TOMCRYPT_OBJECTS)
 
 
 obj-$(CONFIG_CRYPTO_USERSPACE) += cryptodev.o
diff --git a/crypto/userspace/libtomcrypt/hashes/crypt_hash_is_valid.c b/crypto/userspace/libtomcrypt/hashes/crypt_hash_is_valid.c
new file mode 100644
index 0000000..d01d418
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/hashes/crypt_hash_is_valid.c
@@ -0,0 +1,30 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/**
+  @file crypt_hash_is_valid.c
+  Determine if hash is valid, Tom St Denis
+*/  
+
+/*
+   Test if a hash index is valid
+   @param idx   The hash to search for
+   @return CRYPT_OK if valid
+*/
+int hash_is_valid(const struct algo_properties_st *hash)
+{
+   return CRYPT_OK;
+}
+
+/* $Source: /cvs/libtom/libtomcrypt/src/misc/crypt/crypt_hash_is_valid.c,v $ */
+/* $Revision: 1.6 $ */
+/* $Date: 2006/12/28 01:27:24 $ */
diff --git a/crypto/userspace/libtomcrypt/hashes/hash_get_oid.c b/crypto/userspace/libtomcrypt/hashes/hash_get_oid.c
new file mode 100644
index 0000000..39f4372
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/hashes/hash_get_oid.c
@@ -0,0 +1,78 @@
+/* LibTomCrypt, modular cryptographic library
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ */
+#include "tomcrypt.h"
+#include <ncr-int.h>
+
+/*
+   Returns the OID of the hash.
+   @param idx   The hash identifier of the hash to search for
+   @return CRYPT_OK if valid
+*/
+
+static const oid_st sha1_oid = {
+   .OIDlen = 6,
+   .OID = { 1, 3, 14, 3, 2, 26  },
+};
+
+static const oid_st md5_oid = {
+   .OIDlen = 6,
+   .OID = { 1, 2, 840, 113549, 2, 5,  },
+};
+
+static const oid_st sha224_oid = {
+   .OIDlen = 9,
+   .OID = { 2, 16, 840, 1, 101, 3, 4, 2, 4,  },
+};
+
+static const oid_st sha256_oid = {
+   .OIDlen = 9,
+   .OID = { 2, 16, 840, 1, 101, 3, 4, 2, 1,  },
+};
+
+static const oid_st sha384_oid = {
+   .OIDlen = 9,
+   .OID = { 2, 16, 840, 1, 101, 3, 4, 2, 2,  },
+};
+
+static const oid_st sha512_oid = {
+   .OIDlen = 9,
+   .OID = { 2, 16, 840, 1, 101, 3, 4, 2, 3,  },
+};
+
+int hash_get_oid(const struct algo_properties_st *hash, oid_st *st)
+{
+   switch (hash->algo) {
+      case NCR_ALG_SHA1:
+         memcpy(st, &sha1_oid, sizeof(*st));
+         break;
+      case NCR_ALG_MD5:
+         memcpy(st, &md5_oid, sizeof(*st));
+         break;
+      case NCR_ALG_SHA2_224:
+         memcpy(st, &sha224_oid, sizeof(*st));
+         break;
+      case NCR_ALG_SHA2_256:
+         memcpy(st, &sha256_oid, sizeof(*st));
+         break;
+      case NCR_ALG_SHA2_384:
+         memcpy(st, &sha384_oid, sizeof(*st));
+         break;
+      case NCR_ALG_SHA2_512:
+         memcpy(st, &sha512_oid, sizeof(*st));
+         break;
+      default:
+         return CRYPT_INVALID_ARG;
+   }
+   return CRYPT_OK;
+}
+
+/* $Source: /cvs/libtom/libtomcrypt/src/misc/crypt/crypt_hash_is_valid.c,v $ */
+/* $Revision: 1.6 $ */
+/* $Date: 2006/12/28 01:27:24 $ */
diff --git a/crypto/userspace/libtomcrypt/hashes/hash_memory.c b/crypto/userspace/libtomcrypt/hashes/hash_memory.c
new file mode 100644
index 0000000..a416de9
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/hashes/hash_memory.c
@@ -0,0 +1,66 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+#include <ncr-int.h>
+#include <cryptodev_int.h>
+
+/**
+  @file hash_memory.c
+  Hash memory helper, Tom St Denis
+*/
+
+/**
+  Hash a block of memory and store the digest.
+  @param hash   The hash you wish to use
+  @param in     The data you wish to hash
+  @param inlen  The length of the data to hash (octets)
+  @param out    [out] Where to store the digest
+  @param outlen [in/out] Max size and resulting size of the digest
+  @return CRYPT_OK if successful
+*/
+int hash_memory(const struct algo_properties_st *hash, const unsigned char *in, unsigned long inlen, unsigned char *out, unsigned long *outlen)
+{
+    int err;
+    struct hash_data hdata;
+
+    LTC_ARGCHK(in     != NULL);
+    LTC_ARGCHK(out    != NULL);
+    LTC_ARGCHK(outlen != NULL);
+
+    if ((err = hash_is_valid(hash)) != CRYPT_OK) {
+        return err;
+    }
+
+    if (*outlen < hash->digest_size) {
+       *outlen = hash->digest_size;
+       return CRYPT_BUFFER_OVERFLOW;
+    }
+
+    err = cryptodev_hash_init( &hdata, hash->kstr, 0, NULL, 0);
+    if (err < 0) {
+       err = CRYPT_INVALID_HASH;
+       goto LBL_ERR;
+    }
+
+    if ((err = _cryptodev_hash_update(&hdata, in, inlen)) < 0) {
+       err = CRYPT_ERROR;
+       goto LBL_ERR;
+    }
+    
+    err = cryptodev_hash_final(&hdata, out);
+    
+    *outlen = hash->digest_size;
+LBL_ERR:
+    cryptodev_hash_deinit(&hdata);
+
+    return err;
+}
+
diff --git a/crypto/userspace/libtomcrypt/hashes/hash_memory_multi.c b/crypto/userspace/libtomcrypt/hashes/hash_memory_multi.c
new file mode 100644
index 0000000..a914916
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/hashes/hash_memory_multi.c
@@ -0,0 +1,84 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+#include <stdarg.h>
+#include <ncr-int.h>
+#include <cryptodev_int.h>
+
+/**
+  @file hash_memory_multi.c
+  Hash (multiple buffers) memory helper, Tom St Denis
+*/
+
+/**
+  Hash multiple (non-adjacent) blocks of memory at once.  
+  @param hash   The hash you wish to use
+  @param out    [out] Where to store the digest
+  @param outlen [in/out] Max size and resulting size of the digest
+  @param in     The data you wish to hash
+  @param inlen  The length of the data to hash (octets)
+  @param ...    tuples of (data,len) pairs to hash, terminated with a (NULL,x) (x=don't care)
+  @return CRYPT_OK if successful
+*/  
+int hash_memory_multi(const struct algo_properties_st *hash, unsigned char *out, unsigned long *outlen,
+                      const unsigned char *in, unsigned long inlen, ...)
+{
+    struct hash_data hdata;
+    int                  err;
+    va_list              args;
+    const unsigned char *curptr;
+    unsigned long        curlen;
+
+    LTC_ARGCHK(in     != NULL);
+    LTC_ARGCHK(out    != NULL);
+    LTC_ARGCHK(outlen != NULL);
+
+    if ((err = hash_is_valid(hash)) != CRYPT_OK) {
+        return err;
+    }
+
+    if (*outlen < hash->digest_size) {
+       *outlen = hash->digest_size;
+       return CRYPT_BUFFER_OVERFLOW;
+    }
+
+    err = cryptodev_hash_init( &hdata, hash->kstr, 0, NULL, 0);
+    if (err < 0) {
+       err = CRYPT_INVALID_HASH;
+       goto LBL_ERR;
+    }
+
+    va_start(args, inlen);
+    curptr = in; 
+    curlen = inlen;
+    for (;;) {
+       /* process buf */
+       if ((err = _cryptodev_hash_update(&hdata, curptr, curlen)) < 0) {
+	   err = CRYPT_ERROR;
+           goto LBL_ERR;
+       }
+       /* step to next */
+       curptr = va_arg(args, const unsigned char*);
+       if (curptr == NULL) {
+          break;
+       }
+       curlen = va_arg(args, unsigned long);
+    }
+ 
+    err = cryptodev_hash_final(&hdata, out);
+    
+    *outlen = hash->digest_size;
+LBL_ERR:
+    cryptodev_hash_deinit(&hdata);
+    va_end(args);
+    return err;
+}
+
diff --git a/crypto/userspace/libtomcrypt/headers/tomcrypt_prng.h b/crypto/userspace/libtomcrypt/headers/tomcrypt_prng.h
new file mode 100644
index 0000000..26bf711
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/headers/tomcrypt_prng.h
@@ -0,0 +1,80 @@
+/* ---- PRNG Stuff ---- */
+
+typedef union Prng_state {
+    char dummy[1];
+} prng_state;
+
+/** PRNG descriptor */
+extern struct ltc_prng_descriptor {
+    /** Name of the PRNG */
+    char *name;
+    /** size in bytes of exported state */
+    int  export_size;
+    /** Start a PRNG state
+        @param prng   [out] The state to initialize
+        @return CRYPT_OK if successful
+    */
+    int (*start)(prng_state *prng);
+    /** Add entropy to the PRNG
+        @param in         The entropy
+        @param inlen      Length of the entropy (octets)\
+        @param prng       The PRNG state
+        @return CRYPT_OK if successful
+    */
+    int (*add_entropy)(const unsigned char *in, unsigned long inlen, prng_state *prng);
+    /** Ready a PRNG state to read from
+        @param prng       The PRNG state to ready
+        @return CRYPT_OK if successful
+    */
+    int (*ready)(prng_state *prng);
+    /** Read from the PRNG
+        @param out     [out] Where to store the data
+        @param outlen  Length of data desired (octets)
+        @param prng    The PRNG state to read from
+        @return Number of octets read
+    */
+    unsigned long (*read)(unsigned char *out, unsigned long outlen, prng_state *prng);
+    /** Terminate a PRNG state
+        @param prng   The PRNG state to terminate
+        @return CRYPT_OK if successful
+    */
+    int (*done)(prng_state *prng);
+    /** Export a PRNG state  
+        @param out     [out] The destination for the state
+        @param outlen  [in/out] The max size and resulting size of the PRNG state
+        @param prng    The PRNG to export
+        @return CRYPT_OK if successful
+    */
+    int (*pexport)(unsigned char *out, unsigned long *outlen, prng_state *prng);
+    /** Import a PRNG state
+        @param in      The data to import
+        @param inlen   The length of the data to import (octets)
+        @param prng    The PRNG to initialize/import
+        @return CRYPT_OK if successful
+    */
+    int (*pimport)(const unsigned char *in, unsigned long inlen, prng_state *prng);
+    /** Self-test the PRNG
+        @return CRYPT_OK if successful, CRYPT_NOP if self-testing has been disabled
+    */
+    int (*test)(void);
+} prng_descriptor[];
+
+int linux_start(prng_state *prng);
+int linux_add_entropy(const unsigned char *in, unsigned long inlen, prng_state *prng);
+int linux_ready(prng_state *prng);
+unsigned long linux_read(unsigned char *out, unsigned long outlen, prng_state *prng);
+int linux_done(prng_state *prng);
+int  linux_export(unsigned char *out, unsigned long *outlen, prng_state *prng);
+int  linux_import(const unsigned char *in, unsigned long inlen, prng_state *prng);
+int  linux_test(void);
+
+extern const struct ltc_prng_descriptor linux_desc;
+
+int find_prng(const char *name);
+int register_prng(const struct ltc_prng_descriptor *prng);
+int unregister_prng(const struct ltc_prng_descriptor *prng);
+int prng_is_valid(int idx);
+
+/* $Source: /cvs/libtom/libtomcrypt/src/headers/tomcrypt_prng.h,v $ */
+/* $Revision: 1.9 $ */
+/* $Date: 2007/05/12 14:32:35 $ */
diff --git a/crypto/userspace/libtomcrypt/math/rand_prime.c b/crypto/userspace/libtomcrypt/math/rand_prime.c
new file mode 100644
index 0000000..ab73cd0
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/math/rand_prime.c
@@ -0,0 +1,80 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+#include <linux/slab.h>
+
+/**
+  @file rand_prime.c
+  Generate a random prime, Tom St Denis
+*/  
+
+#define USE_BBS 1
+
+int rand_prime(mp_int *N, long len)
+{
+   int            err, res, type;
+   unsigned char *buf;
+
+   LTC_ARGCHK(N != NULL);
+
+   /* get type */
+   if (len < 0) {
+      type = USE_BBS;
+      len = -len;
+   } else {
+      type = 0;
+   }
+
+   /* allow sizes between 2 and 512 bytes for a prime size */
+   if (len < 2 || len > 512) { 
+      return CRYPT_INVALID_PRIME_SIZE;
+   }
+
+   /* allocate buffer to work with */
+   buf = XCALLOC(1, len);
+   if (buf == NULL) {
+       return CRYPT_MEM;
+   }
+
+   do {
+      /* generate value */
+      get_random_bytes( buf, len);
+
+      /* munge bits */
+      buf[0]     |= 0x80 | 0x40;
+      buf[len-1] |= 0x01 | ((type & USE_BBS) ? 0x02 : 0x00);
+
+      /* load value */
+      if ((err = mp_read_unsigned_bin(N, buf, len)) != CRYPT_OK) {
+         XFREE(buf);
+         return err;
+      }
+
+      /* test */
+      if ((err = mp_prime_is_prime(N, 8, &res)) != CRYPT_OK) {
+         XFREE(buf);
+         return err;
+      }
+   } while (res == LTC_MP_NO);
+
+#ifdef LTC_CLEAN_STACK
+   zeromem(buf, len);
+#endif
+
+   XFREE(buf);
+   return CRYPT_OK;
+}
+      
+
+
+/* $Source: /cvs/libtom/libtomcrypt/src/math/rand_prime.c,v $ */
+/* $Revision: 1.7 $ */
+/* $Date: 2006/12/28 01:27:23 $ */
diff --git a/crypto/userspace/libtomcrypt/misc/crypt/crypt_argchk.c b/crypto/userspace/libtomcrypt/misc/crypt/crypt_argchk.c
new file mode 100644
index 0000000..143b784
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/misc/crypt/crypt_argchk.c
@@ -0,0 +1,28 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/**
+  @file crypt_argchk.c
+  Perform argument checking, Tom St Denis
+*/  
+
+#if (ARGTYPE == 0)
+void crypt_argchk(char *v, char *s, int d)
+{
+ printk("LTC_ARGCHK '%s' failure on line %d of file %s\n",
+         v, d, s);
+}
+#endif
+
+/* $Source: /cvs/libtom/libtomcrypt/src/misc/crypt/crypt_argchk.c,v $ */
+/* $Revision: 1.5 $ */
+/* $Date: 2006/12/28 01:27:24 $ */
diff --git a/crypto/userspace/libtomcrypt/misc/pk_get_oid.c b/crypto/userspace/libtomcrypt/misc/pk_get_oid.c
new file mode 100644
index 0000000..197d7ae
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/misc/pk_get_oid.c
@@ -0,0 +1,40 @@
+/* LibTomCrypt, modular cryptographic library
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ */
+#include "tomcrypt.h"
+
+static const oid_st rsa_oid = {
+   .OIDlen = 7,
+   .OID = { 1, 2, 840, 113549, 1, 1, 1  },
+};
+
+static const oid_st dsa_oid = {
+   .OIDlen = 6,
+   .OID = { 1, 2, 840, 10040, 4, 1  },
+};
+
+/*
+   Returns the OID of the public key algorithm.
+   @return CRYPT_OK if valid
+*/
+int pk_get_oid(int pk, oid_st *st)
+{
+   switch (pk) {
+      case PKA_RSA:
+         memcpy(st, &rsa_oid, sizeof(*st));
+         break;
+      case PKA_DSA:
+         memcpy(st, &dsa_oid, sizeof(*st));
+         break;
+      default:
+         return CRYPT_INVALID_ARG;
+   }
+   return CRYPT_OK;
+}
+
diff --git a/crypto/userspace/libtomcrypt/misc/qsort.c b/crypto/userspace/libtomcrypt/misc/qsort.c
new file mode 100644
index 0000000..72f5108
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/misc/qsort.c
@@ -0,0 +1,247 @@
+/* Copyright (C) 1991,1992,1996,1997,1999,2004 Free Software Foundation, Inc.
+   This file is part of the GNU C Library.
+   Written by Douglas C. Schmidt (schmidt@ics.uci.edu).
+
+   The GNU C Library is free software; you can redistribute it and/or
+   modify it under the terms of the GNU Lesser General Public
+   License as published by the Free Software Foundation; either
+   version 2.1 of the License, or (at your option) any later version.
+
+   The GNU C Library is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+   Lesser General Public License for more details.
+
+   You should have received a copy of the GNU Lesser General Public
+   License along with the GNU C Library; if not, write to the Free
+   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
+   02111-1307 USA.  */
+
+/* If you consider tuning this algorithm, you should consult first:
+   Engineering a sort function; Jon Bentley and M. Douglas McIlroy;
+   Software - Practice and Experience; Vol. 23 (11), 1249-1265, 1993.  */
+
+#include <tomcrypt.h>
+
+/* Byte-wise swap two items of size SIZE. */
+#define SWAP(a, b, size)						      \
+  do									      \
+    {									      \
+      register size_t __size = (size);					      \
+      register char *__a = (a), *__b = (b);				      \
+      do								      \
+	{								      \
+	  char __tmp = *__a;						      \
+	  *__a++ = *__b;						      \
+	  *__b++ = __tmp;						      \
+	} while (--__size > 0);						      \
+    } while (0)
+
+/* Discontinue quicksort algorithm when partition gets below this size.
+   This particular magic number was chosen to work best on a Sun 4/260. */
+#define MAX_THRESH 4
+
+/* Stack node declarations used to store unfulfilled partition obligations. */
+typedef struct
+  {
+    char *lo;
+    char *hi;
+  } stack_node;
+
+/* The next 4 #defines implement a very fast in-line stack abstraction. */
+/* The stack needs log (total_elements) entries (we could even subtract
+   log(MAX_THRESH)).  Since total_elements has type size_t, we get as
+   upper bound for log (total_elements):
+   bits per byte (CHAR_BIT) * sizeof(size_t).  */
+#define STACK_SIZE	(CHAR_BIT * sizeof(size_t))
+#define PUSH(low, high)	((void) ((top->lo = (low)), (top->hi = (high)), ++top))
+#define	POP(low, high)	((void) (--top, (low = top->lo), (high = top->hi)))
+#define	STACK_NOT_EMPTY	(stack < top)
+
+
+/* Order size using quicksort.  This implementation incorporates
+   four optimizations discussed in Sedgewick:
+
+   1. Non-recursive, using an explicit stack of pointer that store the
+      next array partition to sort.  To save time, this maximum amount
+      of space required to store an array of SIZE_MAX is allocated on the
+      stack.  Assuming a 32-bit (64 bit) integer for size_t, this needs
+      only 32 * sizeof(stack_node) == 256 bytes (for 64 bit: 1024 bytes).
+      Pretty cheap, actually.
+
+   2. Chose the pivot element using a median-of-three decision tree.
+      This reduces the probability of selecting a bad pivot value and
+      eliminates certain extraneous comparisons.
+
+   3. Only quicksorts TOTAL_ELEMS / MAX_THRESH partitions, leaving
+      insertion sort to order the MAX_THRESH items within each partition.
+      This is a big win, since insertion sort is faster for small, mostly
+      sorted array segments.
+
+   4. The larger of the two sub-partitions is always pushed onto the
+      stack first, with the algorithm then concentrating on the
+      smaller partition.  This *guarantees* no more than log (total_elems)
+      stack size is needed (actually O(1) in this case)!  */
+
+typedef int(*__compar_fn_t)(const void *, const void *);
+
+void
+qsort (void *const pbase, size_t total_elems, size_t size,
+	    __compar_fn_t cmp)
+{
+  register char *base_ptr = (char *) pbase;
+
+  const size_t max_thresh = MAX_THRESH * size;
+
+  if (total_elems == 0)
+    /* Avoid lossage with unsigned arithmetic below.  */
+    return;
+
+  if (total_elems > MAX_THRESH)
+    {
+      char *lo = base_ptr;
+      char *hi = &lo[size * (total_elems - 1)];
+      stack_node stack[STACK_SIZE];
+      stack_node *top = stack;
+
+      PUSH (NULL, NULL);
+
+      while (STACK_NOT_EMPTY)
+        {
+          char *left_ptr;
+          char *right_ptr;
+
+	  /* Select median value from among LO, MID, and HI. Rearrange
+	     LO and HI so the three values are sorted. This lowers the
+	     probability of picking a pathological pivot value and
+	     skips a comparison for both the LEFT_PTR and RIGHT_PTR in
+	     the while loops. */
+
+	  char *mid = lo + size * ((hi - lo) / size >> 1);
+
+	  if ((*cmp) ((void *) mid, (void *) lo) < 0)
+	    SWAP (mid, lo, size);
+	  if ((*cmp) ((void *) hi, (void *) mid) < 0)
+	    SWAP (mid, hi, size);
+	  else
+	    goto jump_over;
+	  if ((*cmp) ((void *) mid, (void *) lo) < 0)
+	    SWAP (mid, lo, size);
+	jump_over:;
+
+	  left_ptr  = lo + size;
+	  right_ptr = hi - size;
+
+	  /* Here's the famous ``collapse the walls'' section of quicksort.
+	     Gotta like those tight inner loops!  They are the main reason
+	     that this algorithm runs much faster than others. */
+	  do
+	    {
+	      while ((*cmp) ((void *) left_ptr, (void *) mid) < 0)
+		left_ptr += size;
+
+	      while ((*cmp) ((void *) mid, (void *) right_ptr) < 0)
+		right_ptr -= size;
+
+	      if (left_ptr < right_ptr)
+		{
+		  SWAP (left_ptr, right_ptr, size);
+		  if (mid == left_ptr)
+		    mid = right_ptr;
+		  else if (mid == right_ptr)
+		    mid = left_ptr;
+		  left_ptr += size;
+		  right_ptr -= size;
+		}
+	      else if (left_ptr == right_ptr)
+		{
+		  left_ptr += size;
+		  right_ptr -= size;
+		  break;
+		}
+	    }
+	  while (left_ptr <= right_ptr);
+
+          /* Set up pointers for next iteration.  First determine whether
+             left and right partitions are below the threshold size.  If so,
+             ignore one or both.  Otherwise, push the larger partition's
+             bounds on the stack and continue sorting the smaller one. */
+
+          if ((size_t) (right_ptr - lo) <= max_thresh)
+            {
+              if ((size_t) (hi - left_ptr) <= max_thresh)
+		/* Ignore both small partitions. */
+                POP (lo, hi);
+              else
+		/* Ignore small left partition. */
+                lo = left_ptr;
+            }
+          else if ((size_t) (hi - left_ptr) <= max_thresh)
+	    /* Ignore small right partition. */
+            hi = right_ptr;
+          else if ((right_ptr - lo) > (hi - left_ptr))
+            {
+	      /* Push larger left partition indices. */
+              PUSH (lo, right_ptr);
+              lo = left_ptr;
+            }
+          else
+            {
+	      /* Push larger right partition indices. */
+              PUSH (left_ptr, hi);
+              hi = right_ptr;
+            }
+        }
+    }
+
+  /* Once the BASE_PTR array is partially sorted by quicksort the rest
+     is completely sorted using insertion sort, since this is efficient
+     for partitions below MAX_THRESH size. BASE_PTR points to the beginning
+     of the array to sort, and END_PTR points at the very last element in
+     the array (*not* one beyond it!). */
+
+  {
+    char *const end_ptr = &base_ptr[size * (total_elems - 1)];
+    char *tmp_ptr = base_ptr;
+    char *thresh = min(end_ptr, base_ptr + max_thresh);
+    register char *run_ptr;
+
+    /* Find smallest element in first threshold and place it at the
+       array's beginning.  This is the smallest array element,
+       and the operation speeds up insertion sort's inner loop. */
+
+    for (run_ptr = tmp_ptr + size; run_ptr <= thresh; run_ptr += size)
+      if ((*cmp) ((void *) run_ptr, (void *) tmp_ptr) < 0)
+        tmp_ptr = run_ptr;
+
+    if (tmp_ptr != base_ptr)
+      SWAP (tmp_ptr, base_ptr, size);
+
+    /* Insertion sort, running from left-hand-side up to right-hand-side.  */
+
+    run_ptr = base_ptr + size;
+    while ((run_ptr += size) <= end_ptr)
+      {
+	tmp_ptr = run_ptr - size;
+	while ((*cmp) ((void *) run_ptr, (void *) tmp_ptr) < 0)
+	  tmp_ptr -= size;
+
+	tmp_ptr += size;
+        if (tmp_ptr != run_ptr)
+          {
+            char *trav;
+
+	    trav = run_ptr + size;
+	    while (--trav >= run_ptr)
+              {
+                char c = *trav;
+                char *hi, *lo;
+
+                for (hi = lo = trav; (lo -= size) >= tmp_ptr; hi = lo)
+                  *hi = *lo;
+                *hi = c;
+              }
+          }
+      }
+  }
+}
diff --git a/crypto/userspace/libtomcrypt/misc/zeromem.c b/crypto/userspace/libtomcrypt/misc/zeromem.c
new file mode 100644
index 0000000..a4bb124
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/misc/zeromem.c
@@ -0,0 +1,34 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/**
+   @file zeromem.c
+   Zero a block of memory, Tom St Denis
+*/
+
+/**
+   Zero a block of memory
+   @param out    The destination of the area to zero
+   @param outlen The length of the area to zero (octets)
+*/
+void zeromem(void *out, size_t outlen)
+{
+   unsigned char *mem = out;
+   LTC_ARGCHKVD(out != NULL);
+   while (outlen-- > 0) {
+      *mem++ = 0;
+   }
+}
+
+/* $Source: /cvs/libtom/libtomcrypt/src/misc/zeromem.c,v $ */
+/* $Revision: 1.7 $ */
+/* $Date: 2006/12/28 01:27:24 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/asn1/der/bit/der_decode_bit_string.c b/crypto/userspace/libtomcrypt/pk/asn1/der/bit/der_decode_bit_string.c
new file mode 100644
index 0000000..c9f6368
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/asn1/der/bit/der_decode_bit_string.c
@@ -0,0 +1,106 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/**
+  @file der_decode_bit_string.c
+  ASN.1 DER, encode a BIT STRING, Tom St Denis
+*/
+
+
+#ifdef LTC_DER
+
+#define setbit(v, n)    (v=((unsigned char)(v) | (1U << (unsigned char)(n))))
+
+/**
+  Store a BIT STRING
+  @param in      The DER encoded BIT STRING
+  @param inlen   The size of the DER BIT STRING
+  @param out     [out] The array of bits stored (8 per char)
+  @param outlen  [in/out] The number of bits stored
+  @return CRYPT_OK if successful
+*/
+int der_decode_bit_string(const unsigned char *in,  unsigned long inlen,
+                                unsigned char *out, unsigned long *outlen)
+{
+   unsigned long dlen, blen, x, y;
+
+   LTC_ARGCHK(in     != NULL);
+   LTC_ARGCHK(out    != NULL);
+   LTC_ARGCHK(outlen != NULL);
+
+   /* packet must be at least 4 bytes */
+   if (inlen < 4) {
+       return CRYPT_INVALID_ARG;
+   }
+
+   /* check for 0x03 */
+   if ((in[0]&0x1F) != 0x03) {
+      return CRYPT_INVALID_PACKET;
+   }
+
+    /* offset in the data */
+    x = 1;
+
+   /* get the length of the data */
+   if (in[x] & 0x80) {
+      /* long format get number of length bytes */
+      y = in[x++] & 0x7F;
+
+      /* invalid if 0 or > 2 */
+      if (y == 0 || y > 2) {
+         return CRYPT_INVALID_PACKET;
+      }
+
+      /* read the data len */
+      dlen = 0;
+      while (y--) {
+         dlen = (dlen << 8) | (unsigned long)in[x++];
+      }
+   } else {
+      /* short format */
+      dlen = in[x++] & 0x7F;
+   }
+  
+   /* is the data len too long or too short? */
+   if ((dlen == 0) || (dlen + x > inlen)) {
+       return CRYPT_INVALID_PACKET;
+   }
+
+   /* get padding count */
+   blen = ((dlen - 1) << 3) - (in[x++] & 7);
+
+   /* too many bits? */
+   if (blen > *outlen) {
+      *outlen = blen;
+      return CRYPT_BUFFER_OVERFLOW;
+   }
+
+   /* decode/store the bits */
+   for (y = 0; y < blen; y++) {
+       if (in[x] & (1 << (7 - (y & 7)))) {
+          setbit(out[y/8], 7-(y%8));
+       }
+       if ((y & 7) == 7) {
+          ++x;
+       }
+   }
+
+   /* we done */
+   *outlen = blen;
+   return CRYPT_OK;
+}
+
+#endif
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/asn1/der/bit/der_decode_bit_string.c,v $ */
+/* $Revision: 1.5 $ */
+/* $Date: 2006/12/28 01:27:24 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/asn1/der/bit/der_encode_bit_string.c b/crypto/userspace/libtomcrypt/pk/asn1/der/bit/der_encode_bit_string.c
new file mode 100644
index 0000000..d1b6064
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/asn1/der/bit/der_encode_bit_string.c
@@ -0,0 +1,92 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/**
+  @file der_encode_bit_string.c
+  ASN.1 DER, encode a BIT STRING, Tom St Denis
+*/
+
+
+#ifdef LTC_DER
+
+#define getbit(n, k) (((n) & ( 1 << (k) )) >> (k))
+
+/**
+  Store a BIT STRING
+  @param in       The array of bits to store (8 per char)
+  @param inlen    The number of bits tostore
+  @param out      [out] The destination for the DER encoded BIT STRING
+  @param outlen   [in/out] The max size and resulting size of the DER BIT STRING
+  @return CRYPT_OK if successful
+*/
+int der_encode_bit_string(const unsigned char *in, unsigned long inlen,
+                                unsigned char *out, unsigned long *outlen)
+{
+   unsigned long len, x, y;
+   unsigned char buf;
+   int           err;
+
+   LTC_ARGCHK(in     != NULL);
+   LTC_ARGCHK(out    != NULL);
+   LTC_ARGCHK(outlen != NULL);
+
+   /* avoid overflows */
+   if ((err = der_length_bit_string(inlen, &len)) != CRYPT_OK) {
+      return err;
+   }
+
+   if (len > *outlen) {
+      *outlen = len;
+      return CRYPT_BUFFER_OVERFLOW;
+   }
+
+   /* store header (include bit padding count in length) */
+   x = 0;
+   y = (inlen >> 3) + ((inlen&7) ? 1 : 0) + 1;
+
+   out[x++] = 0x03;
+   if (y < 128) {
+      out[x++] = (unsigned char)y;
+   } else if (y < 256) {
+      out[x++] = 0x81;
+      out[x++] = (unsigned char)y;
+   } else if (y < 65536) {
+      out[x++] = 0x82;
+      out[x++] = (unsigned char)((y>>8)&255);
+      out[x++] = (unsigned char)(y&255);
+   }
+
+   /* store number of zero padding bits */
+   out[x++] = (unsigned char)((8 - inlen) & 7);
+
+   /* store the bits in big endian format */
+   for (y = buf = 0; y < inlen; y++) {
+        buf |= (getbit(in[y/8],7-y%8)?1:0) << (7 - (y & 7));
+       if ((y & 7) == 7) {
+          out[x++] = buf;
+          buf      = 0;
+       }
+   }
+   /* store last byte */
+   if (inlen & 7) {
+      out[x++] = buf;
+   }
+
+   *outlen = x;
+   return CRYPT_OK;
+}
+
+#endif
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/asn1/der/bit/der_encode_bit_string.c,v $ */
+/* $Revision: 1.5 $ */
+/* $Date: 2006/12/28 01:27:24 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/asn1/der/bit/der_length_bit_string.c b/crypto/userspace/libtomcrypt/pk/asn1/der/bit/der_length_bit_string.c
new file mode 100644
index 0000000..3b7a8e1
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/asn1/der/bit/der_length_bit_string.c
@@ -0,0 +1,54 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/**
+  @file der_length_bit_string.c
+  ASN.1 DER, get length of BIT STRING, Tom St Denis
+*/
+
+#ifdef LTC_DER
+/**
+  Gets length of DER encoding of BIT STRING 
+  @param nbits  The number of bits in the string to encode
+  @param outlen [out] The length of the DER encoding for the given string
+  @return CRYPT_OK if successful
+*/
+int der_length_bit_string(unsigned long nbits, unsigned long *outlen)
+{
+   unsigned long nbytes;
+   LTC_ARGCHK(outlen != NULL);
+
+   /* get the number of the bytes */
+   nbytes = (nbits >> 3) + ((nbits & 7) ? 1 : 0) + 1;
+ 
+   if (nbytes < 128) {
+      /* 03 LL PP DD DD DD ... */
+      *outlen = 2 + nbytes;
+   } else if (nbytes < 256) {
+      /* 03 81 LL PP DD DD DD ... */
+      *outlen = 3 + nbytes;
+   } else if (nbytes < 65536) {
+      /* 03 82 LL LL PP DD DD DD ... */
+      *outlen = 4 + nbytes;
+   } else {
+      return CRYPT_INVALID_ARG;
+   }
+
+   return CRYPT_OK;
+}
+
+#endif
+
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/asn1/der/bit/der_length_bit_string.c,v $ */
+/* $Revision: 1.3 $ */
+/* $Date: 2006/12/28 01:27:24 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/asn1/der/boolean/der_decode_boolean.c b/crypto/userspace/libtomcrypt/pk/asn1/der/boolean/der_decode_boolean.c
new file mode 100644
index 0000000..f374aa6
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/asn1/der/boolean/der_decode_boolean.c
@@ -0,0 +1,47 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/**
+  @file der_decode_boolean.c
+  ASN.1 DER, decode a BOOLEAN, Tom St Denis
+*/
+
+
+#ifdef LTC_DER
+
+/**
+  Read a BOOLEAN
+  @param in      The destination for the DER encoded BOOLEAN
+  @param inlen   The size of the DER BOOLEAN
+  @param out     [out]  The boolean to decode
+  @return CRYPT_OK if successful
+*/
+int der_decode_boolean(const unsigned char *in, unsigned long inlen,
+                                       int *out)
+{
+   LTC_ARGCHK(in  != NULL);
+   LTC_ARGCHK(out != NULL);
+   
+   if (inlen != 3 || in[0] != 0x01 || in[1] != 0x01 || (in[2] != 0x00 && in[2] != 0xFF)) {
+      return CRYPT_INVALID_ARG;
+   }
+   
+   *out = (in[2]==0xFF) ? 1 : 0;
+   
+   return CRYPT_OK;
+}
+
+#endif
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/asn1/der/boolean/der_decode_boolean.c,v $ */
+/* $Revision: 1.2 $ */
+/* $Date: 2006/12/28 01:27:24 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/asn1/der/boolean/der_encode_boolean.c b/crypto/userspace/libtomcrypt/pk/asn1/der/boolean/der_encode_boolean.c
new file mode 100644
index 0000000..df497bf
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/asn1/der/boolean/der_encode_boolean.c
@@ -0,0 +1,51 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/**
+  @file der_encode_boolean.c
+  ASN.1 DER, encode a BOOLEAN, Tom St Denis
+*/
+
+
+#ifdef LTC_DER
+
+/**
+  Store a BOOLEAN
+  @param in       The boolean to encode
+  @param out      [out] The destination for the DER encoded BOOLEAN
+  @param outlen   [in/out] The max size and resulting size of the DER BOOLEAN
+  @return CRYPT_OK if successful
+*/
+int der_encode_boolean(int in, 
+                       unsigned char *out, unsigned long *outlen)
+{
+   LTC_ARGCHK(outlen != NULL);
+   LTC_ARGCHK(out    != NULL);
+   
+   if (*outlen < 3) {
+       *outlen = 3;
+       return CRYPT_BUFFER_OVERFLOW;
+   }
+   
+   *outlen = 3;
+   out[0] = 0x01;
+   out[1] = 0x01;
+   out[2] = in ? 0xFF : 0x00;
+   
+   return CRYPT_OK;
+}
+
+#endif
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/asn1/der/boolean/der_encode_boolean.c,v $ */
+/* $Revision: 1.4 $ */
+/* $Date: 2006/12/28 01:27:24 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/asn1/der/boolean/der_length_boolean.c b/crypto/userspace/libtomcrypt/pk/asn1/der/boolean/der_length_boolean.c
new file mode 100644
index 0000000..aa3e03d
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/asn1/der/boolean/der_length_boolean.c
@@ -0,0 +1,35 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/**
+  @file der_length_boolean.c
+  ASN.1 DER, get length of a BOOLEAN, Tom St Denis
+*/
+
+#ifdef LTC_DER
+/**
+  Gets length of DER encoding of a BOOLEAN 
+  @param outlen [out] The length of the DER encoding
+  @return CRYPT_OK if successful
+*/
+int der_length_boolean(unsigned long *outlen)
+{
+   LTC_ARGCHK(outlen != NULL);
+   *outlen = 3;
+   return CRYPT_OK;
+}
+
+#endif
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/asn1/der/boolean/der_length_boolean.c,v $ */
+/* $Revision: 1.3 $ */
+/* $Date: 2006/12/28 01:27:24 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/asn1/der/choice/der_decode_choice.c b/crypto/userspace/libtomcrypt/pk/asn1/der/choice/der_decode_choice.c
new file mode 100644
index 0000000..277c731
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/asn1/der/choice/der_decode_choice.c
@@ -0,0 +1,182 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/**
+  @file der_decode_choice.c
+  ASN.1 DER, decode a CHOICE, Tom St Denis
+*/
+
+#ifdef LTC_DER
+
+/**
+   Decode a CHOICE
+   @param in       The DER encoded input
+   @param inlen    [in/out] The size of the input and resulting size of read type
+   @param list     The list of items to decode
+   @param outlen   The number of items in the list
+   @return CRYPT_OK on success
+*/
+int der_decode_choice(const unsigned char *in,   unsigned long *inlen,
+                            ltc_asn1_list *list, unsigned long  outlen)
+{
+   unsigned long size, x, z;
+   void          *data;
+
+   LTC_ARGCHK(in    != NULL);
+   LTC_ARGCHK(inlen != NULL);
+   LTC_ARGCHK(list  != NULL);
+
+   /* get blk size */
+   if (*inlen < 2) {
+      return CRYPT_INVALID_PACKET;
+   }
+
+   /* set all of the "used" flags to zero */
+   for (x = 0; x < outlen; x++) {
+       list[x].used = 0;
+   }
+
+   /* now scan until we have a winner */
+   for (x = 0; x < outlen; x++) {
+       size = list[x].size;
+       data = list[x].data;
+
+       switch (list[x].type) {
+           case LTC_ASN1_INTEGER:
+               if (der_decode_integer(in, *inlen, data) == CRYPT_OK) {
+                  if (der_length_integer(data, &z) == CRYPT_OK) {
+                      list[x].used = 1;
+                      *inlen       = z;
+                      return CRYPT_OK;
+                  }
+               }
+               break;
+
+           case LTC_ASN1_SHORT_INTEGER:
+               if (der_decode_short_integer(in, *inlen, data) == CRYPT_OK) {
+                  if (der_length_short_integer(size, &z) == CRYPT_OK) {
+                      list[x].used = 1;
+                      *inlen       = z;
+                      return CRYPT_OK;
+                  }
+               }
+               break;
+
+           case LTC_ASN1_BIT_STRING:
+               if (der_decode_bit_string(in, *inlen, data, &size) == CRYPT_OK) {
+                  if (der_length_bit_string(size, &z) == CRYPT_OK) {
+                     list[x].used = 1;
+                     list[x].size = size;
+                     *inlen       = z;
+                     return CRYPT_OK;
+                  }
+               }
+               break;
+
+           case LTC_ASN1_OCTET_STRING:
+               if (der_decode_octet_string(in, *inlen, data, &size) == CRYPT_OK) {
+                  if (der_length_octet_string(size, &z) == CRYPT_OK) {
+                     list[x].used = 1;
+                     list[x].size = size;
+                     *inlen       = z;
+                     return CRYPT_OK;
+                  }
+               }
+               break;
+
+           case LTC_ASN1_NULL:
+               if (*inlen == 2 && in[x] == 0x05 && in[x+1] == 0x00) {
+                  *inlen = 2;
+                  list[x].used   = 1;
+                  return CRYPT_OK;
+               }
+               break;
+                  
+           case LTC_ASN1_OBJECT_IDENTIFIER:
+               if (der_decode_object_identifier(in, *inlen, data, &size) == CRYPT_OK) {
+                  if (der_length_object_identifier(data, size, &z) == CRYPT_OK) {
+                     list[x].used = 1;
+                     list[x].size = size;
+                     *inlen       = z;
+                     return CRYPT_OK;
+                  }
+               }
+               break;
+
+           case LTC_ASN1_IA5_STRING:
+               if (der_decode_ia5_string(in, *inlen, data, &size) == CRYPT_OK) {
+                  if (der_length_ia5_string(data, size, &z) == CRYPT_OK) {
+                     list[x].used = 1;
+                     list[x].size = size;
+                     *inlen       = z;
+                     return CRYPT_OK;
+                  }
+               }
+               break;
+
+
+           case LTC_ASN1_PRINTABLE_STRING:
+               if (der_decode_printable_string(in, *inlen, data, &size) == CRYPT_OK) {
+                  if (der_length_printable_string(data, size, &z) == CRYPT_OK) {
+                     list[x].used = 1;
+                     list[x].size = size;
+                     *inlen       = z;
+                     return CRYPT_OK;
+                  }
+               }
+               break;
+
+           case LTC_ASN1_UTF8_STRING:
+               if (der_decode_utf8_string(in, *inlen, data, &size) == CRYPT_OK) {
+                  if (der_length_utf8_string(data, size, &z) == CRYPT_OK) {
+                     list[x].used = 1;
+                     list[x].size = size;
+                     *inlen       = z;
+                     return CRYPT_OK;
+                  }
+               }
+               break;
+
+           case LTC_ASN1_UTCTIME:
+               z = *inlen;
+               if (der_decode_utctime(in, &z, data) == CRYPT_OK) {
+                  list[x].used = 1;
+                  *inlen       = z;
+                  return CRYPT_OK;
+               }
+               break;
+
+           case LTC_ASN1_SET:
+           case LTC_ASN1_SETOF:
+           case LTC_ASN1_SEQUENCE:
+               if (der_decode_sequence(in, *inlen, data, size) == CRYPT_OK) {
+                  if (der_length_sequence(data, size, &z) == CRYPT_OK) {
+                     list[x].used = 1;
+                     *inlen       = z;
+                     return CRYPT_OK;
+                  }
+               }
+               break;
+
+           default:
+               return CRYPT_INVALID_ARG;
+       }
+   }
+
+   return CRYPT_INVALID_PACKET;
+}
+
+#endif
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/asn1/der/choice/der_decode_choice.c,v $ */
+/* $Revision: 1.9 $ */
+/* $Date: 2006/12/28 01:27:24 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/asn1/der/ia5/der_decode_ia5_string.c b/crypto/userspace/libtomcrypt/pk/asn1/der/ia5/der_decode_ia5_string.c
new file mode 100644
index 0000000..001477b
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/asn1/der/ia5/der_decode_ia5_string.c
@@ -0,0 +1,96 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/**
+  @file der_decode_ia5_string.c
+  ASN.1 DER, encode a IA5 STRING, Tom St Denis
+*/
+
+
+#ifdef LTC_DER
+
+/**
+  Store a IA5 STRING
+  @param in      The DER encoded IA5 STRING
+  @param inlen   The size of the DER IA5 STRING
+  @param out     [out] The array of octets stored (one per char)
+  @param outlen  [in/out] The number of octets stored
+  @return CRYPT_OK if successful
+*/
+int der_decode_ia5_string(const unsigned char *in, unsigned long inlen,
+                                unsigned char *out, unsigned long *outlen)
+{
+   unsigned long x, y, len;
+   int           t;
+
+   LTC_ARGCHK(in     != NULL);
+   LTC_ARGCHK(out    != NULL);
+   LTC_ARGCHK(outlen != NULL);
+
+   /* must have header at least */
+   if (inlen < 2) {
+      return CRYPT_INVALID_PACKET;
+   }
+
+   /* check for 0x16 */
+   if ((in[0] & 0x1F) != 0x16) {
+      return CRYPT_INVALID_PACKET;
+   }
+   x = 1;
+
+   /* decode the length */
+   if (in[x] & 0x80) {
+      /* valid # of bytes in length are 1,2,3 */
+      y = in[x] & 0x7F;
+      if ((y == 0) || (y > 3) || ((x + y) > inlen)) {
+         return CRYPT_INVALID_PACKET;
+      }
+
+      /* read the length in */
+      len = 0;
+      ++x;
+      while (y--) {
+         len = (len << 8) | in[x++];
+      }
+   } else {
+      len = in[x++] & 0x7F;
+   }
+
+   /* is it too long? */
+   if (len > *outlen) {
+      *outlen = len;
+      return CRYPT_BUFFER_OVERFLOW;
+   }
+
+   if (len + x > inlen) {
+      return CRYPT_INVALID_PACKET;
+   }
+
+   /* read the data */
+   for (y = 0; y < len; y++) {
+       t = der_ia5_value_decode(in[x++]);
+       if (t == -1) {
+           return CRYPT_INVALID_ARG;
+       }
+       out[y] = t;
+   }
+
+   *outlen = y;
+
+   return CRYPT_OK;
+}
+ 
+#endif
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/asn1/der/ia5/der_decode_ia5_string.c,v $ */
+/* $Revision: 1.4 $ */
+/* $Date: 2006/12/28 01:27:24 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/asn1/der/ia5/der_encode_ia5_string.c b/crypto/userspace/libtomcrypt/pk/asn1/der/ia5/der_encode_ia5_string.c
new file mode 100644
index 0000000..82ed466
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/asn1/der/ia5/der_encode_ia5_string.c
@@ -0,0 +1,85 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/**
+  @file der_encode_ia5_string.c
+  ASN.1 DER, encode a IA5 STRING, Tom St Denis
+*/
+
+#ifdef LTC_DER
+
+/**
+  Store an IA5 STRING
+  @param in       The array of IA5 to store (one per char)
+  @param inlen    The number of IA5 to store
+  @param out      [out] The destination for the DER encoded IA5 STRING
+  @param outlen   [in/out] The max size and resulting size of the DER IA5 STRING
+  @return CRYPT_OK if successful
+*/
+int der_encode_ia5_string(const unsigned char *in, unsigned long inlen,
+                                unsigned char *out, unsigned long *outlen)
+{
+   unsigned long x, y, len;
+   int           err;
+
+   LTC_ARGCHK(in     != NULL);
+   LTC_ARGCHK(out    != NULL);
+   LTC_ARGCHK(outlen != NULL);
+
+   /* get the size */
+   if ((err = der_length_ia5_string(in, inlen, &len)) != CRYPT_OK) {
+      return err; 
+   }
+
+   /* too big? */
+   if (len > *outlen) {
+      *outlen = len;
+      return CRYPT_BUFFER_OVERFLOW;
+   }
+
+   /* encode the header+len */
+   x = 0;
+   out[x++] = 0x16;
+   if (inlen < 128) {
+      out[x++] = (unsigned char)inlen;
+   } else if (inlen < 256) {
+      out[x++] = 0x81;
+      out[x++] = (unsigned char)inlen;
+   } else if (inlen < 65536UL) {
+      out[x++] = 0x82;
+      out[x++] = (unsigned char)((inlen>>8)&255);
+      out[x++] = (unsigned char)(inlen&255);
+   } else if (inlen < 16777216UL) {
+      out[x++] = 0x83;
+      out[x++] = (unsigned char)((inlen>>16)&255);
+      out[x++] = (unsigned char)((inlen>>8)&255);
+      out[x++] = (unsigned char)(inlen&255);
+   } else {
+      return CRYPT_INVALID_ARG;
+   }
+
+   /* store octets */
+   for (y = 0; y < inlen; y++) {
+       out[x++] = der_ia5_char_encode(in[y]);
+   }
+
+   /* retun length */
+   *outlen = x;
+
+   return CRYPT_OK;
+}
+
+#endif
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/asn1/der/ia5/der_encode_ia5_string.c,v $ */
+/* $Revision: 1.5 $ */
+/* $Date: 2006/12/28 01:27:24 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/asn1/der/ia5/der_length_ia5_string.c b/crypto/userspace/libtomcrypt/pk/asn1/der/ia5/der_length_ia5_string.c
new file mode 100644
index 0000000..4d60f8e
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/asn1/der/ia5/der_length_ia5_string.c
@@ -0,0 +1,194 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/**
+  @file der_length_ia5_string.c
+  ASN.1 DER, get length of IA5 STRING, Tom St Denis
+*/
+
+#ifdef LTC_DER
+
+static const struct {
+   int code, value;
+} ia5_table[] = {
+{ '\0', 0 },
+{ '\a', 7 }, 
+{ '\b', 8 }, 
+{ '\t', 9 }, 
+{ '\n', 10 }, 
+{ '\f', 12 }, 
+{ '\r', 13 }, 
+{ ' ', 32 }, 
+{ '!', 33 }, 
+{ '"', 34 }, 
+{ '#', 35 }, 
+{ '$', 36 }, 
+{ '%', 37 }, 
+{ '&', 38 }, 
+{ '\'', 39 }, 
+{ '(', 40 }, 
+{ ')', 41 }, 
+{ '*', 42 }, 
+{ '+', 43 }, 
+{ ',', 44 }, 
+{ '-', 45 }, 
+{ '.', 46 }, 
+{ '/', 47 }, 
+{ '0', 48 }, 
+{ '1', 49 }, 
+{ '2', 50 }, 
+{ '3', 51 }, 
+{ '4', 52 }, 
+{ '5', 53 }, 
+{ '6', 54 }, 
+{ '7', 55 }, 
+{ '8', 56 }, 
+{ '9', 57 }, 
+{ ':', 58 }, 
+{ ';', 59 }, 
+{ '<', 60 }, 
+{ '=', 61 }, 
+{ '>', 62 }, 
+{ '?', 63 }, 
+{ '@', 64 }, 
+{ 'A', 65 }, 
+{ 'B', 66 }, 
+{ 'C', 67 }, 
+{ 'D', 68 }, 
+{ 'E', 69 }, 
+{ 'F', 70 }, 
+{ 'G', 71 }, 
+{ 'H', 72 }, 
+{ 'I', 73 }, 
+{ 'J', 74 }, 
+{ 'K', 75 }, 
+{ 'L', 76 }, 
+{ 'M', 77 }, 
+{ 'N', 78 }, 
+{ 'O', 79 }, 
+{ 'P', 80 }, 
+{ 'Q', 81 }, 
+{ 'R', 82 }, 
+{ 'S', 83 }, 
+{ 'T', 84 }, 
+{ 'U', 85 }, 
+{ 'V', 86 }, 
+{ 'W', 87 }, 
+{ 'X', 88 }, 
+{ 'Y', 89 }, 
+{ 'Z', 90 }, 
+{ '[', 91 }, 
+{ '\\', 92 }, 
+{ ']', 93 }, 
+{ '^', 94 }, 
+{ '_', 95 }, 
+{ '`', 96 }, 
+{ 'a', 97 }, 
+{ 'b', 98 }, 
+{ 'c', 99 }, 
+{ 'd', 100 }, 
+{ 'e', 101 }, 
+{ 'f', 102 }, 
+{ 'g', 103 }, 
+{ 'h', 104 }, 
+{ 'i', 105 }, 
+{ 'j', 106 }, 
+{ 'k', 107 }, 
+{ 'l', 108 }, 
+{ 'm', 109 }, 
+{ 'n', 110 }, 
+{ 'o', 111 }, 
+{ 'p', 112 }, 
+{ 'q', 113 }, 
+{ 'r', 114 }, 
+{ 's', 115 }, 
+{ 't', 116 }, 
+{ 'u', 117 }, 
+{ 'v', 118 }, 
+{ 'w', 119 }, 
+{ 'x', 120 }, 
+{ 'y', 121 }, 
+{ 'z', 122 }, 
+{ '{', 123 }, 
+{ '|', 124 }, 
+{ '}', 125 }, 
+{ '~', 126 }
+};
+
+int der_ia5_char_encode(int c)
+{
+   int x;
+   for (x = 0; x < (int)(sizeof(ia5_table)/sizeof(ia5_table[0])); x++) {
+       if (ia5_table[x].code == c) {
+          return ia5_table[x].value;
+       }
+   }
+   return -1;
+}
+
+int der_ia5_value_decode(int v)
+{
+   int x;
+   for (x = 0; x < (int)(sizeof(ia5_table)/sizeof(ia5_table[0])); x++) {
+       if (ia5_table[x].value == v) {
+          return ia5_table[x].code;
+       }
+   }
+   return -1;
+}
+   
+/**
+  Gets length of DER encoding of IA5 STRING 
+  @param octets   The values you want to encode 
+  @param noctets  The number of octets in the string to encode
+  @param outlen   [out] The length of the DER encoding for the given string
+  @return CRYPT_OK if successful
+*/
+int der_length_ia5_string(const unsigned char *octets, unsigned long noctets, unsigned long *outlen)
+{
+   unsigned long x;
+
+   LTC_ARGCHK(outlen != NULL);
+   LTC_ARGCHK(octets != NULL);
+
+   /* scan string for validity */
+   for (x = 0; x < noctets; x++) {
+       if (der_ia5_char_encode(octets[x]) == -1) {
+          return CRYPT_INVALID_ARG;
+       }
+   }
+
+   if (noctets < 128) {
+      /* 16 LL DD DD DD ... */
+      *outlen = 2 + noctets;
+   } else if (noctets < 256) {
+      /* 16 81 LL DD DD DD ... */
+      *outlen = 3 + noctets;
+   } else if (noctets < 65536UL) {
+      /* 16 82 LL LL DD DD DD ... */
+      *outlen = 4 + noctets;
+   } else if (noctets < 16777216UL) {
+      /* 16 83 LL LL LL DD DD DD ... */
+      *outlen = 5 + noctets;
+   } else {
+      return CRYPT_INVALID_ARG;
+   }
+
+   return CRYPT_OK;
+}
+
+#endif
+
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/asn1/der/ia5/der_length_ia5_string.c,v $ */
+/* $Revision: 1.3 $ */
+/* $Date: 2006/12/28 01:27:24 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/asn1/der/integer/der_decode_integer.c b/crypto/userspace/libtomcrypt/pk/asn1/der/integer/der_decode_integer.c
new file mode 100644
index 0000000..d7b13cf
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/asn1/der/integer/der_decode_integer.c
@@ -0,0 +1,110 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/**
+  @file der_decode_integer.c
+  ASN.1 DER, decode an integer, Tom St Denis
+*/
+
+
+#ifdef LTC_DER
+
+/**
+  Read a mp_int integer
+  @param in       The DER encoded data
+  @param inlen    Size of DER encoded data
+  @param num      The first mp_int to decode
+  @return CRYPT_OK if successful
+*/
+int der_decode_integer(const unsigned char *in, unsigned long inlen, mp_int_t num)
+{
+   unsigned long x, y, z;
+   int           err;
+
+   LTC_ARGCHK(num    != NULL);
+   LTC_ARGCHK(in     != NULL);
+
+   /* min DER INTEGER is 0x02 01 00 == 0 */
+   if (inlen < (1 + 1 + 1)) {
+      return CRYPT_INVALID_PACKET;
+   }
+
+   /* ok expect 0x02 when we AND with 0001 1111 [1F] */
+   x = 0;
+   if ((in[x++] & 0x1F) != 0x02) {
+      return CRYPT_INVALID_PACKET;
+   }
+
+   /* now decode the len stuff */
+   z = in[x++];
+
+   if ((z & 0x80) == 0x00) {
+      /* short form */
+
+      /* will it overflow? */
+      if (x + z > inlen) {
+         return CRYPT_INVALID_PACKET;
+      }
+     
+      /* no so read it */
+      if ((err = mp_read_unsigned_bin(num, (unsigned char *)in + x, z)) != CRYPT_OK) {
+         return err;
+      }
+   } else {
+      /* long form */
+      z &= 0x7F;
+      
+      /* will number of length bytes overflow? (or > 4) */
+      if (((x + z) > inlen) || (z > 4) || (z == 0)) {
+         return CRYPT_INVALID_PACKET;
+      }
+
+      /* now read it in */
+      y = 0;
+      while (z--) {
+         y = ((unsigned long)(in[x++])) | (y << 8);
+      }
+
+      /* now will reading y bytes overrun? */
+      if ((x + y) > inlen) {
+         return CRYPT_INVALID_PACKET;
+      }
+
+      /* no so read it */
+      if ((err = mp_read_unsigned_bin(num, (unsigned char *)in + x, y)) != CRYPT_OK) {
+         return err;
+      }
+   }
+
+   /* see if it's negative */
+   if (in[x] & 0x80) {
+      mp_int tmp;
+      if (mp_init(&tmp) != CRYPT_OK) {
+         return CRYPT_MEM;
+      }
+
+      if (mp_2expt(&tmp, mp_count_bits(num)) != CRYPT_OK || mp_sub(num, &tmp, num) != CRYPT_OK) {
+         mp_clear(&tmp);
+         return CRYPT_MEM;
+      }
+      mp_clear(&tmp);
+   } 
+
+   return CRYPT_OK;
+
+}
+
+#endif
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/asn1/der/integer/der_decode_integer.c,v $ */
+/* $Revision: 1.5 $ */
+/* $Date: 2006/12/28 01:27:24 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/asn1/der/integer/der_encode_integer.c b/crypto/userspace/libtomcrypt/pk/asn1/der/integer/der_encode_integer.c
new file mode 100644
index 0000000..830446a
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/asn1/der/integer/der_encode_integer.c
@@ -0,0 +1,130 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/**
+  @file der_encode_integer.c
+  ASN.1 DER, encode an integer, Tom St Denis
+*/
+
+
+#ifdef LTC_DER
+
+/* Exports a positive bignum as DER format (upto 2^32 bytes in size) */
+/**
+  Store a mp_int integer
+  @param num      The first mp_int to encode
+  @param out      [out] The destination for the DER encoded integers
+  @param outlen   [in/out] The max size and resulting size of the DER encoded integers
+  @return CRYPT_OK if successful
+*/
+int der_encode_integer(mp_int_t num, unsigned char *out, unsigned long *outlen)
+{  
+   unsigned long tmplen, y;
+   int           err, leading_zero;
+
+   LTC_ARGCHK(num    != NULL);
+   LTC_ARGCHK(out    != NULL);
+   LTC_ARGCHK(outlen != NULL);
+
+   /* find out how big this will be */
+   if ((err = der_length_integer(num, &tmplen)) != CRYPT_OK) {
+      return err;
+   }
+
+   if (*outlen < tmplen) {
+      *outlen = tmplen;
+      return CRYPT_BUFFER_OVERFLOW;
+   }
+
+   if (mp_cmp_d(num, 0) != LTC_MP_LT) {
+      /* we only need a leading zero if the msb of the first byte is one */
+      if ((mp_count_bits(num) & 7) == 0 || mp_iszero(num) == LTC_MP_YES) {
+         leading_zero = 1;
+      } else {
+         leading_zero = 0;
+      }
+
+      /* get length of num in bytes (plus 1 since we force the msbyte to zero) */
+      y = mp_unsigned_bin_size(num) + leading_zero;
+   } else {
+      leading_zero = 0;
+      y            = mp_count_bits(num);
+      y            = y + (8 - (y & 7));
+      y            = y >> 3;
+      if (((mp_cnt_lsb(num)+1)==mp_count_bits(num)) && ((mp_count_bits(num)&7)==0)) --y;
+   }
+
+   /* now store initial data */
+   *out++ = 0x02;
+   if (y < 128) {
+      /* short form */
+      *out++ = (unsigned char)y;
+   } else if (y < 256) {
+      *out++ = 0x81;
+      *out++ = (unsigned char)y;
+   } else if (y < 65536UL) {
+      *out++ = 0x82;
+      *out++ = (unsigned char)((y>>8)&255);
+      *out++ = (unsigned char)y;
+   } else if (y < 16777216UL) {
+      *out++ = 0x83;
+      *out++ = (unsigned char)((y>>16)&255);
+      *out++ = (unsigned char)((y>>8)&255);
+      *out++ = (unsigned char)y;
+   } else {
+      return CRYPT_INVALID_ARG;
+   }
+
+   /* now store msbyte of zero if num is non-zero */
+   if (leading_zero) {
+      *out++ = 0x00;
+   }
+
+   /* if it's not zero store it as big endian */
+   if (mp_cmp_d(num, 0) == LTC_MP_GT) {
+      /* now store the mpint */
+      if ((err = mp_to_unsigned_bin(num, out)) != CRYPT_OK) {
+          return err;
+      }
+   } else if (mp_iszero(num) != LTC_MP_YES) {
+      mp_int tmp;
+         
+      /* negative */
+      if (mp_init(&tmp) != CRYPT_OK) {
+         return CRYPT_MEM;
+      }
+
+      /* 2^roundup and subtract */
+      y = mp_count_bits(num);
+      y = y + (8 - (y & 7));
+      if (((mp_cnt_lsb(num)+1)==mp_count_bits(num)) && ((mp_count_bits(num)&7)==0)) y -= 8;
+      if (mp_2expt(&tmp, y) != CRYPT_OK || mp_add(&tmp, num, &tmp) != CRYPT_OK) {
+         mp_clear(&tmp);
+         return CRYPT_MEM;
+      }
+      if ((err = mp_to_unsigned_bin(&tmp, out)) != CRYPT_OK) {
+         mp_clear(&tmp);
+         return err;
+      }
+      mp_clear(&tmp);
+   }
+
+   /* we good */
+   *outlen = tmplen; 
+   return CRYPT_OK;
+}
+
+#endif
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/asn1/der/integer/der_encode_integer.c,v $ */
+/* $Revision: 1.9 $ */
+/* $Date: 2006/12/28 01:27:24 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/asn1/der/integer/der_length_integer.c b/crypto/userspace/libtomcrypt/pk/asn1/der/integer/der_length_integer.c
new file mode 100644
index 0000000..40addd5
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/asn1/der/integer/der_length_integer.c
@@ -0,0 +1,82 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/**
+  @file der_length_integer.c
+  ASN.1 DER, get length of encoding, Tom St Denis
+*/
+
+
+#ifdef LTC_DER
+/**
+  Gets length of DER encoding of num 
+  @param num    The int to get the size of 
+  @param outlen [out] The length of the DER encoding for the given integer
+  @return CRYPT_OK if successful
+*/
+int der_length_integer(mp_int_t num, unsigned long *outlen)
+{
+   unsigned long z, len;
+   int           leading_zero;
+
+   LTC_ARGCHK(num     != NULL);
+   LTC_ARGCHK(outlen  != NULL);
+
+   if (mp_cmp_d(num, 0) != LTC_MP_LT) {
+      /* positive */
+
+      /* we only need a leading zero if the msb of the first byte is one */
+      if ((mp_count_bits(num) & 7) == 0 || mp_iszero(num) == LTC_MP_YES) {
+         leading_zero = 1;
+      } else {
+         leading_zero = 0;
+      }
+
+      /* size for bignum */
+      z = len = leading_zero + mp_unsigned_bin_size(num);
+   } else {
+      /* it's negative */
+      /* find power of 2 that is a multiple of eight and greater than count bits */
+      leading_zero = 0;
+      z = mp_count_bits(num);
+      z = z + (8 - (z & 7));
+      if (((mp_cnt_lsb(num)+1)==mp_count_bits(num)) && ((mp_count_bits(num)&7)==0)) --z;
+      len = z = z >> 3;
+   }
+
+   /* now we need a length */
+   if (z < 128) {
+      /* short form */
+      ++len;
+   } else {
+      /* long form (relies on z != 0), assumes length bytes < 128 */
+      ++len;
+
+      while (z) {
+         ++len;
+         z >>= 8;
+      }
+   }
+
+   /* we need a 0x02 to indicate it's INTEGER */
+   ++len;
+
+   /* return length */
+   *outlen = len; 
+   return CRYPT_OK;
+}
+
+#endif
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/asn1/der/integer/der_length_integer.c,v $ */
+/* $Revision: 1.5 $ */
+/* $Date: 2006/12/28 01:27:24 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/asn1/der/object_identifier/der_decode_object_identifier.c b/crypto/userspace/libtomcrypt/pk/asn1/der/object_identifier/der_decode_object_identifier.c
new file mode 100644
index 0000000..cdd296d
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/asn1/der/object_identifier/der_decode_object_identifier.c
@@ -0,0 +1,99 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/**
+  @file der_decode_object_identifier.c
+  ASN.1 DER, Decode Object Identifier, Tom St Denis
+*/
+
+#ifdef LTC_DER
+/**
+  Decode OID data and store the array of integers in words
+  @param in      The OID DER encoded data
+  @param inlen   The length of the OID data
+  @param words   [out] The destination of the OID words
+  @param outlen  [in/out] The number of OID words
+  @return CRYPT_OK if successful
+*/
+int der_decode_object_identifier(const unsigned char *in,    unsigned long  inlen,
+                                       unsigned long *words, unsigned long *outlen)
+{
+   unsigned long x, y, t, len;
+
+   LTC_ARGCHK(in     != NULL);
+   LTC_ARGCHK(words  != NULL);
+   LTC_ARGCHK(outlen != NULL);
+
+   /* header is at least 3 bytes */
+   if (inlen < 3) {
+      return CRYPT_INVALID_PACKET;
+   }
+
+   /* must be room for at least two words */
+   if (*outlen < 2) {
+      return CRYPT_BUFFER_OVERFLOW;
+   }
+
+   /* decode the packet header */
+   x = 0;
+   if ((in[x++] & 0x1F) != 0x06) {
+      return CRYPT_INVALID_PACKET;
+   }
+   
+   /* get the length */
+   if (in[x] < 128) {
+      len = in[x++]; 
+   } else {
+       if (in[x] < 0x81 || in[x] > 0x82) {
+          return CRYPT_INVALID_PACKET;
+       }
+       y   = in[x++] & 0x7F;
+       len = 0;
+       while (y--) {
+          len = (len << 8) | (unsigned long)in[x++];
+       }
+   }
+
+   if (len < 1 || (len + x) > inlen) {
+      return CRYPT_INVALID_PACKET;
+   }
+
+   /* decode words */
+   y = 0;
+   t = 0;
+   while (len--) {
+       t = (t << 7) | (in[x] & 0x7F);
+       if (!(in[x++] & 0x80)) {
+           /* store t */
+           if (y >= *outlen) {
+              return CRYPT_BUFFER_OVERFLOW;
+           }
+      if (y == 0) {
+         words[0] = t / 40;
+         words[1] = t % 40;
+         y = 2;
+      } else {
+              words[y++] = t;
+      }
+           t          = 0;
+       }
+   }
+       
+   *outlen = y;
+   return CRYPT_OK;
+}
+
+#endif
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/asn1/der/object_identifier/der_decode_object_identifier.c,v $ */
+/* $Revision: 1.6 $ */
+/* $Date: 2006/12/28 01:27:24 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/asn1/der/object_identifier/der_encode_object_identifier.c b/crypto/userspace/libtomcrypt/pk/asn1/der/object_identifier/der_encode_object_identifier.c
new file mode 100644
index 0000000..b26ebdf
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/asn1/der/object_identifier/der_encode_object_identifier.c
@@ -0,0 +1,111 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/**
+  @file der_encode_object_identifier.c
+  ASN.1 DER, Encode Object Identifier, Tom St Denis
+*/
+
+#ifdef LTC_DER
+/**
+  Encode an OID
+  @param words   The words to encode  (upto 32-bits each)
+  @param nwords  The number of words in the OID
+  @param out     [out] Destination of OID data
+  @param outlen  [in/out] The max and resulting size of the OID
+  @return CRYPT_OK if successful
+*/
+int der_encode_object_identifier(unsigned long *words, unsigned long  nwords,
+                                 unsigned char *out,   unsigned long *outlen)
+{
+   unsigned long i, x, y, z, t, mask, wordbuf;
+   int           err;
+
+   LTC_ARGCHK(words  != NULL);
+   LTC_ARGCHK(out    != NULL);
+   LTC_ARGCHK(outlen != NULL);
+
+   /* check length */
+   if ((err = der_length_object_identifier(words, nwords, &x)) != CRYPT_OK) {
+      return err;
+   }
+   if (x > *outlen) {
+      *outlen = x;
+      return CRYPT_BUFFER_OVERFLOW;
+   }
+
+   /* compute length to store OID data */
+   z = 0;
+   wordbuf = words[0] * 40 + words[1];
+   for (y = 1; y < nwords; y++) {
+       t = der_object_identifier_bits(wordbuf);
+       z += t/7 + ((t%7) ? 1 : 0) + (wordbuf == 0 ? 1 : 0);
+       if (y < nwords - 1) {
+          wordbuf = words[y + 1];
+       }
+   }
+
+   /* store header + length */
+   x = 0; 
+   out[x++] = 0x06;
+   if (z < 128) {
+      out[x++] = (unsigned char)z;
+   } else if (z < 256) {
+      out[x++] = 0x81;
+      out[x++] = (unsigned char)z;
+   } else if (z < 65536UL) {
+      out[x++] = 0x82;
+      out[x++] = (unsigned char)((z>>8)&255);
+      out[x++] = (unsigned char)(z&255);
+   } else {
+      return CRYPT_INVALID_ARG;
+   }
+
+   /* store first byte */
+    wordbuf = words[0] * 40 + words[1];   
+    for (i = 1; i < nwords; i++) {
+        /* store 7 bit words in little endian */
+        t    = wordbuf & 0xFFFFFFFF;
+        if (t) {
+           y    = x;
+           mask = 0;
+           while (t) {
+               out[x++] = (unsigned char)((t & 0x7F) | mask);
+               t    >>= 7;
+               mask  |= 0x80;  /* upper bit is set on all but the last byte */
+           }
+           /* now swap bytes y...x-1 */
+           z = x - 1;
+           while (y < z) {
+               t = out[y]; out[y] = out[z]; out[z] = (unsigned char)t;
+               ++y; 
+               --z;
+           }
+       } else {
+          /* zero word */
+          out[x++] = 0x00;
+       }
+       
+       if (i < nwords - 1) {
+          wordbuf = words[i + 1];
+       }
+   }
+
+   *outlen = x;
+   return CRYPT_OK;
+}
+
+#endif
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/asn1/der/object_identifier/der_encode_object_identifier.c,v $ */
+/* $Revision: 1.7 $ */
+/* $Date: 2006/12/28 01:27:24 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/asn1/der/object_identifier/der_length_object_identifier.c b/crypto/userspace/libtomcrypt/pk/asn1/der/object_identifier/der_length_object_identifier.c
new file mode 100644
index 0000000..ada54ab
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/asn1/der/object_identifier/der_length_object_identifier.c
@@ -0,0 +1,89 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/**
+  @file der_length_object_identifier.c
+  ASN.1 DER, get length of Object Identifier, Tom St Denis
+*/
+
+#ifdef LTC_DER
+
+unsigned long der_object_identifier_bits(unsigned long x)
+{
+   unsigned long c;
+   x &= 0xFFFFFFFF;
+   c  = 0;
+   while (x) {
+     ++c;
+     x >>= 1;
+   }
+   return c;
+}
+
+
+/**
+  Gets length of DER encoding of Object Identifier
+  @param nwords   The number of OID words 
+  @param words    The actual OID words to get the size of
+  @param outlen   [out] The length of the DER encoding for the given string
+  @return CRYPT_OK if successful
+*/
+int der_length_object_identifier(unsigned long *words, unsigned long nwords, unsigned long *outlen)
+{
+   unsigned long y, z, t, wordbuf;   
+
+   LTC_ARGCHK(words  != NULL);
+   LTC_ARGCHK(outlen != NULL);
+
+
+   /* must be >= 2 words */
+   if (nwords < 2) {
+      return CRYPT_INVALID_ARG;
+   }
+
+   /* word1 = 0,1,2,3 and word2 0..39 */
+   if (words[0] > 3 || (words[0] < 2 && words[1] > 39)) {
+      return CRYPT_INVALID_ARG;
+   }
+
+   /* leading word is the first two */
+   z = 0;
+   wordbuf = words[0] * 40 + words[1];
+   for (y = 1; y < nwords; y++) {
+       t = der_object_identifier_bits(wordbuf);
+       z += t/7 + ((t%7) ? 1 : 0) + (wordbuf == 0 ? 1 : 0);
+       if (y < nwords - 1) {
+          /* grab next word */
+          wordbuf = words[y+1];
+       }
+   }
+
+   /* now depending on the length our length encoding changes */
+   if (z < 128) {
+      z += 2;
+   } else if (z < 256) {
+      z += 3;
+   } else if (z < 65536UL) {
+      z += 4;
+   } else {
+      return CRYPT_INVALID_ARG;
+   }
+
+   *outlen = z;
+   return CRYPT_OK;
+}
+
+#endif
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/asn1/der/object_identifier/der_length_object_identifier.c,v $ */
+/* $Revision: 1.5 $ */
+/* $Date: 2006/12/28 01:27:24 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/asn1/der/octet/der_decode_octet_string.c b/crypto/userspace/libtomcrypt/pk/asn1/der/octet/der_decode_octet_string.c
new file mode 100644
index 0000000..ab5bc10
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/asn1/der/octet/der_decode_octet_string.c
@@ -0,0 +1,91 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/**
+  @file der_decode_octet_string.c
+  ASN.1 DER, encode a OCTET STRING, Tom St Denis
+*/
+
+
+#ifdef LTC_DER
+
+/**
+  Store a OCTET STRING
+  @param in      The DER encoded OCTET STRING
+  @param inlen   The size of the DER OCTET STRING
+  @param out     [out] The array of octets stored (one per char)
+  @param outlen  [in/out] The number of octets stored
+  @return CRYPT_OK if successful
+*/
+int der_decode_octet_string(const unsigned char *in, unsigned long inlen,
+                                  unsigned char *out, unsigned long *outlen)
+{
+   unsigned long x, y, len;
+
+   LTC_ARGCHK(in     != NULL);
+   LTC_ARGCHK(out    != NULL);
+   LTC_ARGCHK(outlen != NULL);
+
+   /* must have header at least */
+   if (inlen < 2) {
+      return CRYPT_INVALID_PACKET;
+   }
+
+   /* check for 0x04 */
+   if ((in[0] & 0x1F) != 0x04) {
+      return CRYPT_INVALID_PACKET;
+   }
+   x = 1;
+
+   /* decode the length */
+   if (in[x] & 0x80) {
+      /* valid # of bytes in length are 1,2,3 */
+      y = in[x] & 0x7F;
+      if ((y == 0) || (y > 3) || ((x + y) > inlen)) {
+         return CRYPT_INVALID_PACKET;
+      }
+
+      /* read the length in */
+      len = 0;
+      ++x;
+      while (y--) {
+         len = (len << 8) | in[x++];
+      }
+   } else {
+      len = in[x++] & 0x7F;
+   }
+
+   /* is it too long? */
+   if (len > *outlen) {
+      *outlen = len;
+      return CRYPT_BUFFER_OVERFLOW;
+   }
+
+   if (len + x > inlen) {
+      return CRYPT_INVALID_PACKET;
+   }
+
+   /* read the data */
+   for (y = 0; y < len; y++) {
+       out[y] = in[x++];
+   }
+
+   *outlen = y;
+
+   return CRYPT_OK;
+}
+ 
+#endif
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/asn1/der/octet/der_decode_octet_string.c,v $ */
+/* $Revision: 1.4 $ */
+/* $Date: 2006/12/28 01:27:24 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/asn1/der/octet/der_encode_octet_string.c b/crypto/userspace/libtomcrypt/pk/asn1/der/octet/der_encode_octet_string.c
new file mode 100644
index 0000000..64a0770
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/asn1/der/octet/der_encode_octet_string.c
@@ -0,0 +1,86 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/**
+  @file der_encode_octet_string.c
+  ASN.1 DER, encode a OCTET STRING, Tom St Denis
+*/
+
+
+#ifdef LTC_DER
+
+/**
+  Store an OCTET STRING
+  @param in       The array of OCTETS to store (one per char)
+  @param inlen    The number of OCTETS to store
+  @param out      [out] The destination for the DER encoded OCTET STRING
+  @param outlen   [in/out] The max size and resulting size of the DER OCTET STRING
+  @return CRYPT_OK if successful
+*/
+int der_encode_octet_string(const unsigned char *in, unsigned long inlen,
+                                  unsigned char *out, unsigned long *outlen)
+{
+   unsigned long x, y, len;
+   int           err;
+
+   LTC_ARGCHK(in     != NULL);
+   LTC_ARGCHK(out    != NULL);
+   LTC_ARGCHK(outlen != NULL);
+
+   /* get the size */
+   if ((err = der_length_octet_string(inlen, &len)) != CRYPT_OK) {
+      return err; 
+   }
+
+   /* too big? */
+   if (len > *outlen) {
+      *outlen = len;
+      return CRYPT_BUFFER_OVERFLOW;
+   }
+
+   /* encode the header+len */
+   x = 0;
+   out[x++] = 0x04;
+   if (inlen < 128) {
+      out[x++] = (unsigned char)inlen;
+   } else if (inlen < 256) {
+      out[x++] = 0x81;
+      out[x++] = (unsigned char)inlen;
+   } else if (inlen < 65536UL) {
+      out[x++] = 0x82;
+      out[x++] = (unsigned char)((inlen>>8)&255);
+      out[x++] = (unsigned char)(inlen&255);
+   } else if (inlen < 16777216UL) {
+      out[x++] = 0x83;
+      out[x++] = (unsigned char)((inlen>>16)&255);
+      out[x++] = (unsigned char)((inlen>>8)&255);
+      out[x++] = (unsigned char)(inlen&255);
+   } else {
+      return CRYPT_INVALID_ARG;
+   }
+
+   /* store octets */
+   for (y = 0; y < inlen; y++) {
+       out[x++] = in[y];
+   }
+
+   /* retun length */
+   *outlen = x;
+
+   return CRYPT_OK;
+}
+
+#endif
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/asn1/der/octet/der_encode_octet_string.c,v $ */
+/* $Revision: 1.5 $ */
+/* $Date: 2006/12/28 01:27:24 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/asn1/der/octet/der_length_octet_string.c b/crypto/userspace/libtomcrypt/pk/asn1/der/octet/der_length_octet_string.c
new file mode 100644
index 0000000..c494159
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/asn1/der/octet/der_length_octet_string.c
@@ -0,0 +1,53 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/**
+  @file der_length_octet_string.c
+  ASN.1 DER, get length of OCTET STRING, Tom St Denis
+*/
+
+#ifdef LTC_DER
+/**
+  Gets length of DER encoding of OCTET STRING 
+  @param noctets  The number of octets in the string to encode
+  @param outlen   [out] The length of the DER encoding for the given string
+  @return CRYPT_OK if successful
+*/
+int der_length_octet_string(unsigned long noctets, unsigned long *outlen)
+{
+   LTC_ARGCHK(outlen != NULL);
+
+   if (noctets < 128) {
+      /* 04 LL DD DD DD ... */
+      *outlen = 2 + noctets;
+   } else if (noctets < 256) {
+      /* 04 81 LL DD DD DD ... */
+      *outlen = 3 + noctets;
+   } else if (noctets < 65536UL) {
+      /* 04 82 LL LL DD DD DD ... */
+      *outlen = 4 + noctets;
+   } else if (noctets < 16777216UL) {
+      /* 04 83 LL LL LL DD DD DD ... */
+      *outlen = 5 + noctets;
+   } else {
+      return CRYPT_INVALID_ARG;
+   }
+
+   return CRYPT_OK;
+}
+
+#endif
+
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/asn1/der/octet/der_length_octet_string.c,v $ */
+/* $Revision: 1.3 $ */
+/* $Date: 2006/12/28 01:27:24 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/asn1/der/printable_string/der_decode_printable_string.c b/crypto/userspace/libtomcrypt/pk/asn1/der/printable_string/der_decode_printable_string.c
new file mode 100644
index 0000000..8504f77
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/asn1/der/printable_string/der_decode_printable_string.c
@@ -0,0 +1,96 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/**
+  @file der_decode_printable_string.c
+  ASN.1 DER, encode a printable STRING, Tom St Denis
+*/
+
+
+#ifdef LTC_DER
+
+/**
+  Store a printable STRING
+  @param in      The DER encoded printable STRING
+  @param inlen   The size of the DER printable STRING
+  @param out     [out] The array of octets stored (one per char)
+  @param outlen  [in/out] The number of octets stored
+  @return CRYPT_OK if successful
+*/
+int der_decode_printable_string(const unsigned char *in, unsigned long inlen,
+                                unsigned char *out, unsigned long *outlen)
+{
+   unsigned long x, y, len;
+   int           t;
+
+   LTC_ARGCHK(in     != NULL);
+   LTC_ARGCHK(out    != NULL);
+   LTC_ARGCHK(outlen != NULL);
+
+   /* must have header at least */
+   if (inlen < 2) {
+      return CRYPT_INVALID_PACKET;
+   }
+
+   /* check for 0x13 */
+   if ((in[0] & 0x1F) != 0x13) {
+      return CRYPT_INVALID_PACKET;
+   }
+   x = 1;
+
+   /* decode the length */
+   if (in[x] & 0x80) {
+      /* valid # of bytes in length are 1,2,3 */
+      y = in[x] & 0x7F;
+      if ((y == 0) || (y > 3) || ((x + y) > inlen)) {
+         return CRYPT_INVALID_PACKET;
+      }
+
+      /* read the length in */
+      len = 0;
+      ++x;
+      while (y--) {
+         len = (len << 8) | in[x++];
+      }
+   } else {
+      len = in[x++] & 0x7F;
+   }
+
+   /* is it too long? */
+   if (len > *outlen) {
+      *outlen = len;
+      return CRYPT_BUFFER_OVERFLOW;
+   }
+
+   if (len + x > inlen) {
+      return CRYPT_INVALID_PACKET;
+   }
+
+   /* read the data */
+   for (y = 0; y < len; y++) {
+       t = der_printable_value_decode(in[x++]);
+       if (t == -1) {
+           return CRYPT_INVALID_ARG;
+       }
+       out[y] = t;
+   }
+
+   *outlen = y;
+
+   return CRYPT_OK;
+}
+ 
+#endif
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/asn1/der/printable_string/der_decode_printable_string.c,v $ */
+/* $Revision: 1.4 $ */
+/* $Date: 2006/12/28 01:27:24 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/asn1/der/printable_string/der_encode_printable_string.c b/crypto/userspace/libtomcrypt/pk/asn1/der/printable_string/der_encode_printable_string.c
new file mode 100644
index 0000000..deccdee
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/asn1/der/printable_string/der_encode_printable_string.c
@@ -0,0 +1,85 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/**
+  @file der_encode_printable_string.c
+  ASN.1 DER, encode a printable STRING, Tom St Denis
+*/
+
+#ifdef LTC_DER
+
+/**
+  Store an printable STRING
+  @param in       The array of printable to store (one per char)
+  @param inlen    The number of printable to store
+  @param out      [out] The destination for the DER encoded printable STRING
+  @param outlen   [in/out] The max size and resulting size of the DER printable STRING
+  @return CRYPT_OK if successful
+*/
+int der_encode_printable_string(const unsigned char *in, unsigned long inlen,
+                                unsigned char *out, unsigned long *outlen)
+{
+   unsigned long x, y, len;
+   int           err;
+
+   LTC_ARGCHK(in     != NULL);
+   LTC_ARGCHK(out    != NULL);
+   LTC_ARGCHK(outlen != NULL);
+
+   /* get the size */
+   if ((err = der_length_printable_string(in, inlen, &len)) != CRYPT_OK) {
+      return err; 
+   }
+
+   /* too big? */
+   if (len > *outlen) {
+      *outlen = len;
+      return CRYPT_BUFFER_OVERFLOW;
+   }
+
+   /* encode the header+len */
+   x = 0;
+   out[x++] = 0x13;
+   if (inlen < 128) {
+      out[x++] = (unsigned char)inlen;
+   } else if (inlen < 256) {
+      out[x++] = 0x81;
+      out[x++] = (unsigned char)inlen;
+   } else if (inlen < 65536UL) {
+      out[x++] = 0x82;
+      out[x++] = (unsigned char)((inlen>>8)&255);
+      out[x++] = (unsigned char)(inlen&255);
+   } else if (inlen < 16777216UL) {
+      out[x++] = 0x83;
+      out[x++] = (unsigned char)((inlen>>16)&255);
+      out[x++] = (unsigned char)((inlen>>8)&255);
+      out[x++] = (unsigned char)(inlen&255);
+   } else {
+      return CRYPT_INVALID_ARG;
+   }
+
+   /* store octets */
+   for (y = 0; y < inlen; y++) {
+       out[x++] = der_printable_char_encode(in[y]);
+   }
+
+   /* retun length */
+   *outlen = x;
+
+   return CRYPT_OK;
+}
+
+#endif
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/asn1/der/printable_string/der_encode_printable_string.c,v $ */
+/* $Revision: 1.5 $ */
+/* $Date: 2006/12/28 01:27:24 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/asn1/der/printable_string/der_length_printable_string.c b/crypto/userspace/libtomcrypt/pk/asn1/der/printable_string/der_length_printable_string.c
new file mode 100644
index 0000000..997d3b5
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/asn1/der/printable_string/der_length_printable_string.c
@@ -0,0 +1,166 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/**
+  @file der_length_printable_string.c
+  ASN.1 DER, get length of Printable STRING, Tom St Denis
+*/
+
+#ifdef LTC_DER
+
+static const struct {
+   int code, value;
+} printable_table[] = {
+{ ' ', 32 }, 
+{ '\'', 39 }, 
+{ '(', 40 }, 
+{ ')', 41 }, 
+{ '+', 43 }, 
+{ ',', 44 }, 
+{ '-', 45 }, 
+{ '.', 46 }, 
+{ '/', 47 }, 
+{ '0', 48 }, 
+{ '1', 49 }, 
+{ '2', 50 }, 
+{ '3', 51 }, 
+{ '4', 52 }, 
+{ '5', 53 }, 
+{ '6', 54 }, 
+{ '7', 55 }, 
+{ '8', 56 }, 
+{ '9', 57 }, 
+{ ':', 58 }, 
+{ '=', 61 }, 
+{ '?', 63 }, 
+{ 'A', 65 }, 
+{ 'B', 66 }, 
+{ 'C', 67 }, 
+{ 'D', 68 }, 
+{ 'E', 69 }, 
+{ 'F', 70 }, 
+{ 'G', 71 }, 
+{ 'H', 72 }, 
+{ 'I', 73 }, 
+{ 'J', 74 }, 
+{ 'K', 75 }, 
+{ 'L', 76 }, 
+{ 'M', 77 }, 
+{ 'N', 78 }, 
+{ 'O', 79 }, 
+{ 'P', 80 }, 
+{ 'Q', 81 }, 
+{ 'R', 82 }, 
+{ 'S', 83 }, 
+{ 'T', 84 }, 
+{ 'U', 85 }, 
+{ 'V', 86 }, 
+{ 'W', 87 }, 
+{ 'X', 88 }, 
+{ 'Y', 89 }, 
+{ 'Z', 90 }, 
+{ 'a', 97 }, 
+{ 'b', 98 }, 
+{ 'c', 99 }, 
+{ 'd', 100 }, 
+{ 'e', 101 }, 
+{ 'f', 102 }, 
+{ 'g', 103 }, 
+{ 'h', 104 }, 
+{ 'i', 105 }, 
+{ 'j', 106 }, 
+{ 'k', 107 }, 
+{ 'l', 108 }, 
+{ 'm', 109 }, 
+{ 'n', 110 }, 
+{ 'o', 111 }, 
+{ 'p', 112 }, 
+{ 'q', 113 }, 
+{ 'r', 114 }, 
+{ 's', 115 }, 
+{ 't', 116 }, 
+{ 'u', 117 }, 
+{ 'v', 118 }, 
+{ 'w', 119 }, 
+{ 'x', 120 }, 
+{ 'y', 121 }, 
+{ 'z', 122 }, 
+};
+
+int der_printable_char_encode(int c)
+{
+   int x;
+   for (x = 0; x < (int)(sizeof(printable_table)/sizeof(printable_table[0])); x++) {
+       if (printable_table[x].code == c) {
+          return printable_table[x].value;
+       }
+   }
+   return -1;
+}
+
+int der_printable_value_decode(int v)
+{
+   int x;
+   for (x = 0; x < (int)(sizeof(printable_table)/sizeof(printable_table[0])); x++) {
+       if (printable_table[x].value == v) {
+          return printable_table[x].code;
+       }
+   }
+   return -1;
+}
+   
+/**
+  Gets length of DER encoding of Printable STRING 
+  @param octets   The values you want to encode 
+  @param noctets  The number of octets in the string to encode
+  @param outlen   [out] The length of the DER encoding for the given string
+  @return CRYPT_OK if successful
+*/
+int der_length_printable_string(const unsigned char *octets, unsigned long noctets, unsigned long *outlen)
+{
+   unsigned long x;
+
+   LTC_ARGCHK(outlen != NULL);
+   LTC_ARGCHK(octets != NULL);
+
+   /* scan string for validity */
+   for (x = 0; x < noctets; x++) {
+       if (der_printable_char_encode(octets[x]) == -1) {
+          return CRYPT_INVALID_ARG;
+       }
+   }
+
+   if (noctets < 128) {
+      /* 16 LL DD DD DD ... */
+      *outlen = 2 + noctets;
+   } else if (noctets < 256) {
+      /* 16 81 LL DD DD DD ... */
+      *outlen = 3 + noctets;
+   } else if (noctets < 65536UL) {
+      /* 16 82 LL LL DD DD DD ... */
+      *outlen = 4 + noctets;
+   } else if (noctets < 16777216UL) {
+      /* 16 83 LL LL LL DD DD DD ... */
+      *outlen = 5 + noctets;
+   } else {
+      return CRYPT_INVALID_ARG;
+   }
+
+   return CRYPT_OK;
+}
+
+#endif
+
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/asn1/der/printable_string/der_length_printable_string.c,v $ */
+/* $Revision: 1.3 $ */
+/* $Date: 2006/12/28 01:27:24 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/asn1/der/sequence/der_decode_sequence_ex.c b/crypto/userspace/libtomcrypt/pk/asn1/der/sequence/der_decode_sequence_ex.c
new file mode 100644
index 0000000..2067437
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/asn1/der/sequence/der_decode_sequence_ex.c
@@ -0,0 +1,287 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+#include <stdarg.h>
+
+
+/**
+  @file der_decode_sequence_ex.c
+  ASN.1 DER, decode a SEQUENCE, Tom St Denis
+*/
+
+#ifdef LTC_DER
+
+/**
+   Decode a SEQUENCE
+   @param in       The DER encoded input
+   @param inlen    The size of the input
+   @param list     The list of items to decode
+   @param outlen   The number of items in the list
+   @param ordered  Search an unordeded or ordered list
+   @return CRYPT_OK on success
+*/
+int der_decode_sequence_ex(const unsigned char *in, unsigned long  inlen,
+                           ltc_asn1_list *list,     unsigned long  outlen, int ordered)
+{
+   int           err, type;
+   unsigned long size, x, y, z, i, blksize;
+   void          *data;
+
+   LTC_ARGCHK(in   != NULL);
+   LTC_ARGCHK(list != NULL);
+   
+   /* get blk size */
+   if (inlen < 2) {
+      return CRYPT_INVALID_PACKET;
+   }
+
+   /* sequence type? We allow 0x30 SEQUENCE and 0x31 SET since fundamentally they're the same structure */
+   x = 0;
+   if (in[x] != 0x30 && in[x] != 0x31) {
+      return CRYPT_INVALID_PACKET;
+   }
+   ++x;
+
+   if (in[x] < 128) {
+      blksize = in[x++];
+   } else if (in[x] & 0x80) {
+      if (in[x] < 0x81 || in[x] > 0x83) {
+         return CRYPT_INVALID_PACKET;
+      }
+      y = in[x++] & 0x7F;
+
+      /* would reading the len bytes overrun? */
+      if (x + y > inlen) {
+         return CRYPT_INVALID_PACKET;
+      }
+
+      /* read len */
+      blksize = 0;
+      while (y--) {
+          blksize = (blksize << 8) | (unsigned long)in[x++];
+      }
+  }
+
+  /* would this blksize overflow? */
+  if (x + blksize > inlen) {
+     return CRYPT_INVALID_PACKET;
+  }
+
+   /* mark all as unused */
+   for (i = 0; i < outlen; i++) {
+       list[i].used = 0;
+   }     
+
+  /* ok read data */
+   inlen = blksize;
+   for (i = 0; i < outlen; i++) {
+       z    = 0;
+       type = list[i].type;
+       size = list[i].size;
+       data = list[i].data;
+       if (!ordered && list[i].used == 1) { continue; }
+
+       if (type == LTC_ASN1_EOL) { 
+          break;
+       }
+
+       switch (type) {
+           case LTC_ASN1_BOOLEAN:
+               z = inlen;
+               if ((err = der_decode_boolean(in + x, z, ((int *)data))) != CRYPT_OK) {
+                   goto LBL_ERR;
+               }
+               if ((err = der_length_boolean(&z)) != CRYPT_OK) {
+                   goto LBL_ERR;
+                }
+                break;
+          
+           case LTC_ASN1_INTEGER:
+               z = inlen;
+               if ((err = der_decode_integer(in + x, z, data)) != CRYPT_OK) {
+                  if (!ordered) {  continue; }
+                  goto LBL_ERR;
+               }
+               if ((err = der_length_integer(data, &z)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               break;
+
+           case LTC_ASN1_SHORT_INTEGER:
+               z = inlen;
+               if ((err = der_decode_short_integer(in + x, z, data)) != CRYPT_OK) {
+                  if (!ordered) { continue; }
+                  goto LBL_ERR;
+               }
+               if ((err = der_length_short_integer(((unsigned long*)data)[0], &z)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               
+               break;
+
+           case LTC_ASN1_BIT_STRING:
+               z = inlen;
+               if ((err = der_decode_bit_string(in + x, z, data, &size)) != CRYPT_OK) {
+                  if (!ordered) { continue; }
+                  goto LBL_ERR;
+               }
+               list[i].size = size;
+               if ((err = der_length_bit_string(size, &z)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               break;
+
+           case LTC_ASN1_OCTET_STRING:
+               z = inlen;
+               if ((err = der_decode_octet_string(in + x, z, data, &size)) != CRYPT_OK) {
+                  if (!ordered) { continue; }
+                  goto LBL_ERR;
+               }
+               list[i].size = size;
+               if ((err = der_length_octet_string(size, &z)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               break;
+
+           case LTC_ASN1_NULL:
+               if (inlen < 2 || in[x] != 0x05 || in[x+1] != 0x00) {
+                  if (!ordered) { continue; }
+                  err = CRYPT_INVALID_PACKET;
+                  goto LBL_ERR;
+               }
+               z = 2;
+               break;
+                  
+           case LTC_ASN1_OBJECT_IDENTIFIER:
+               z = inlen;
+               if ((err = der_decode_object_identifier(in + x, z, data, &size)) != CRYPT_OK) {
+                  if (!ordered) { continue; }
+                  goto LBL_ERR;
+               }
+               list[i].size = size;
+               if ((err = der_length_object_identifier(data, size, &z)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               break;
+
+           case LTC_ASN1_IA5_STRING:
+               z = inlen;
+               if ((err = der_decode_ia5_string(in + x, z, data, &size)) != CRYPT_OK) {
+                  if (!ordered) { continue; }
+                  goto LBL_ERR;
+               }
+               list[i].size = size;
+               if ((err = der_length_ia5_string(data, size, &z)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               break;
+
+
+           case LTC_ASN1_PRINTABLE_STRING:
+               z = inlen;
+               if ((err = der_decode_printable_string(in + x, z, data, &size)) != CRYPT_OK) {
+                  if (!ordered) { continue; }
+                  goto LBL_ERR;
+               }
+               list[i].size = size;
+               if ((err = der_length_printable_string(data, size, &z)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               break;
+
+           case LTC_ASN1_UTF8_STRING:
+               z = inlen;
+               if ((err = der_decode_utf8_string(in + x, z, data, &size)) != CRYPT_OK) {
+                  if (!ordered) { continue; }
+                  goto LBL_ERR;
+               }
+               list[i].size = size;
+               if ((err = der_length_utf8_string(data, size, &z)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               break;
+
+           case LTC_ASN1_UTCTIME:
+               z = inlen;
+               if ((err = der_decode_utctime(in + x, &z, data)) != CRYPT_OK) {
+                  if (!ordered) { continue; }
+                  goto LBL_ERR;
+               }
+               break;
+
+           case LTC_ASN1_SET:
+               z = inlen;
+               if ((err = der_decode_set(in + x, z, data, size)) != CRYPT_OK) {
+                  if (!ordered) { continue; }
+                  goto LBL_ERR;
+               }
+               if ((err = der_length_sequence(data, size, &z)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               break;
+           
+           case LTC_ASN1_SETOF:
+           case LTC_ASN1_SEQUENCE:
+               /* detect if we have the right type */
+               if ((type == LTC_ASN1_SETOF && (in[x] & 0x3F) != 0x31) || (type == LTC_ASN1_SEQUENCE && (in[x] & 0x3F) != 0x30)) {
+                  err = CRYPT_INVALID_PACKET;
+                  goto LBL_ERR;
+               }
+
+               z = inlen;
+               if ((err = der_decode_sequence(in + x, z, data, size)) != CRYPT_OK) {
+                  if (!ordered) { continue; }
+                  goto LBL_ERR;
+               }
+               if ((err = der_length_sequence(data, size, &z)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               break;
+
+
+           case LTC_ASN1_CHOICE:
+               z = inlen;
+               if ((err = der_decode_choice(in + x, &z, data, size)) != CRYPT_OK) {
+                  if (!ordered) { continue; }
+                  goto LBL_ERR;
+               }
+               break;
+
+           default:
+               err = CRYPT_INVALID_ARG;
+               goto LBL_ERR;
+       }
+       x           += z;
+       inlen       -= z;
+       list[i].used = 1;
+       if (!ordered) { 
+          /* restart the decoder */
+          i = -1;
+       }          
+   }
+     
+   for (i = 0; i < outlen; i++) {
+      if (list[i].used == 0) {
+          err = CRYPT_INVALID_PACKET;
+          goto LBL_ERR;
+      }
+   }                
+   err = CRYPT_OK;   
+
+LBL_ERR:
+   return err;
+}  
+ 
+#endif
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/asn1/der/sequence/der_decode_sequence_ex.c,v $ */
+/* $Revision: 1.16 $ */
+/* $Date: 2006/12/28 01:27:24 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/asn1/der/sequence/der_decode_sequence_flexi.c b/crypto/userspace/libtomcrypt/pk/asn1/der/sequence/der_decode_sequence_flexi.c
new file mode 100644
index 0000000..3f01a57
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/asn1/der/sequence/der_decode_sequence_flexi.c
@@ -0,0 +1,394 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+#include <linux/slab.h>
+
+/**
+  @file der_decode_sequence_flexi.c
+  ASN.1 DER, decode an array of ASN.1 types with a flexi parser, Tom St Denis
+*/
+
+#ifdef LTC_DER
+
+static unsigned long fetch_length(const unsigned char *in, unsigned long inlen)
+{
+   unsigned long x, y, z;
+
+   y = 0;
+
+   /* skip type and read len */
+   if (inlen < 2) {
+      return 0xFFFFFFFF;
+   }
+   ++in; ++y;
+   
+   /* read len */
+   x = *in++; ++y;
+   
+   /* <128 means literal */
+   if (x < 128) {
+      return x+y;
+   }
+   x     &= 0x7F; /* the lower 7 bits are the length of the length */
+   inlen -= 2;
+   
+   /* len means len of len! */
+   if (x == 0 || x > 4 || x > inlen) {
+      return 0xFFFFFFFF;
+   }
+   
+   y += x;
+   z = 0;
+   while (x--) {   
+      z = (z<<8) | ((unsigned long)*in);
+      ++in;
+   }
+   return z+y;
+}
+
+/** 
+   ASN.1 DER Flexi(ble) decoder will decode arbitrary DER packets and create a linked list of the decoded elements.
+   @param in      The input buffer
+   @param inlen   [in/out] The length of the input buffer and on output the amount of decoded data 
+   @param out     [out] A pointer to the linked list
+   @return CRYPT_OK on success.
+*/   
+int der_decode_sequence_flexi(const unsigned char *in, unsigned long *inlen, ltc_asn1_list **out)
+{
+   ltc_asn1_list *l;
+   unsigned long err, type, len, totlen, x, y;
+   void          *realloc_tmp;
+   
+   LTC_ARGCHK(in    != NULL);
+   LTC_ARGCHK(inlen != NULL);
+   LTC_ARGCHK(out   != NULL);
+
+   l = NULL;
+   totlen = 0;
+   
+   /* scan the input and and get lengths and what not */
+   while (*inlen) {     
+      /* read the type byte */
+      type = *in;
+
+      /* fetch length */
+      len = fetch_length(in, *inlen);
+      if (len > *inlen) {
+         err = CRYPT_INVALID_PACKET;
+         goto error;
+      }
+
+      /* alloc new link */
+      if (l == NULL) {
+         l = XCALLOC(1, sizeof(*l));
+         if (l == NULL) {
+            err = CRYPT_MEM;
+            goto error;
+         }
+      } else {
+         l->next = XCALLOC(1, sizeof(*l));
+         if (l->next == NULL) {
+            err = CRYPT_MEM;
+            goto error;
+         }
+         l->next->prev = l;
+         l = l->next;
+      }
+
+      /* now switch on type */
+      switch (type) {
+         case 0x01: /* BOOLEAN */
+            l->type = LTC_ASN1_BOOLEAN;
+            l->size = 1;
+            l->data = XCALLOC(1, sizeof(int));
+       
+            if ((err = der_decode_boolean(in, *inlen, l->data)) != CRYPT_OK) {
+               goto error;
+            }
+        
+            if ((err = der_length_boolean(&len)) != CRYPT_OK) {
+               goto error;
+            }
+            break;
+
+         case 0x02: /* INTEGER */
+             /* init field */
+             l->type = LTC_ASN1_INTEGER;
+             l->size = 1;
+
+             l->data = XMALLOC(sizeof(mp_int));
+             if (l->data == NULL) {
+                 err = CRYPT_MEM;
+                 goto error;
+             }
+
+             if ((err = mp_init((mp_int_t)l->data)) != CRYPT_OK) {
+                 goto error;
+             }
+             
+             /* decode field */
+             if ((err = der_decode_integer(in, *inlen, (mp_int_t)l->data)) != CRYPT_OK) {
+                 goto error;
+             }
+             
+             /* calc length of object */
+             if ((err = der_length_integer((mp_int_t)l->data, &len)) != CRYPT_OK) {
+                 goto error;
+             }
+             break;
+
+         case 0x03: /* BIT */
+            /* init field */
+            l->type = LTC_ASN1_BIT_STRING;
+            l->size = len * 8; /* *8 because we store decoded bits one per char and they are encoded 8 per char.  */
+
+            if ((l->data = XCALLOC(1, l->size)) == NULL) {
+               err = CRYPT_MEM;
+               goto error;
+            }
+            
+            if ((err = der_decode_bit_string(in, *inlen, l->data, &l->size)) != CRYPT_OK) {
+               goto error;
+            }
+            
+            if ((err = der_length_bit_string(l->size, &len)) != CRYPT_OK) {
+               goto error;
+            }
+            break;
+
+         case 0x04: /* OCTET */
+
+            /* init field */
+            l->type = LTC_ASN1_OCTET_STRING;
+            l->size = len;
+
+            if ((l->data = XCALLOC(1, l->size)) == NULL) {
+               err = CRYPT_MEM;
+               goto error;
+            }
+            
+            if ((err = der_decode_octet_string(in, *inlen, l->data, &l->size)) != CRYPT_OK) {
+               goto error;
+            }
+            
+            if ((err = der_length_octet_string(l->size, &len)) != CRYPT_OK) {
+               goto error;
+            }
+            break;
+
+         case 0x05: /* NULL */
+         
+            /* valid NULL is 0x05 0x00 */
+            if (in[0] != 0x05 || in[1] != 0x00) {
+               err = CRYPT_INVALID_PACKET;
+               goto error;
+            }
+            
+            /* simple to store ;-) */
+            l->type = LTC_ASN1_NULL;
+            l->data = NULL;
+            l->size = 0;
+            len     = 2;
+            
+            break;
+         
+         case 0x06: /* OID */
+         
+            /* init field */
+            l->type = LTC_ASN1_OBJECT_IDENTIFIER;
+            l->size = len;
+
+            if ((l->data = XCALLOC(len, sizeof(unsigned long))) == NULL) {
+               err = CRYPT_MEM;
+               goto error;
+            }
+            
+            if ((err = der_decode_object_identifier(in, *inlen, l->data, &l->size)) != CRYPT_OK) {
+               goto error;
+            }
+            
+            if ((err = der_length_object_identifier(l->data, l->size, &len)) != CRYPT_OK) {
+               goto error;
+            }
+            
+            /* resize it to save a bunch of mem */
+            if ((realloc_tmp = XREALLOC(l->data, l->size * sizeof(unsigned long))) == NULL) {
+               /* out of heap but this is not an error */
+               break;
+            }
+            l->data = realloc_tmp;
+            break;
+  
+         case 0x0C: /* UTF8 */
+         
+            /* init field */
+            l->type = LTC_ASN1_UTF8_STRING;
+            l->size = len;
+
+            if ((l->data = XCALLOC(sizeof(wchar_t), l->size)) == NULL) {
+               err = CRYPT_MEM;
+               goto error;
+            }
+            
+            if ((err = der_decode_utf8_string(in, *inlen, l->data, &l->size)) != CRYPT_OK) {
+               goto error;
+            }
+            
+            if ((err = der_length_utf8_string(l->data, l->size, &len)) != CRYPT_OK) {
+               goto error;
+            }
+            break;
+
+         case 0x13: /* PRINTABLE */
+         
+            /* init field */
+            l->type = LTC_ASN1_PRINTABLE_STRING;
+            l->size = len;
+
+            if ((l->data = XCALLOC(1, l->size)) == NULL) {
+               err = CRYPT_MEM;
+               goto error;
+            }
+            
+            if ((err = der_decode_printable_string(in, *inlen, l->data, &l->size)) != CRYPT_OK) {
+               goto error;
+            }
+            
+            if ((err = der_length_printable_string(l->data, l->size, &len)) != CRYPT_OK) {
+               goto error;
+            }
+            break;
+         
+         case 0x16: /* IA5 */
+         
+            /* init field */
+            l->type = LTC_ASN1_IA5_STRING;
+            l->size = len;
+
+            if ((l->data = XCALLOC(1, l->size)) == NULL) {
+               err = CRYPT_MEM;
+               goto error;
+            }
+            
+            if ((err = der_decode_ia5_string(in, *inlen, l->data, &l->size)) != CRYPT_OK) {
+               goto error;
+            }
+            
+            if ((err = der_length_ia5_string(l->data, l->size, &len)) != CRYPT_OK) {
+               goto error;
+            }
+            break;
+         
+         case 0x17: /* UTC TIME */
+         
+            /* init field */
+            l->type = LTC_ASN1_UTCTIME;
+            l->size = 1;
+
+            if ((l->data = XCALLOC(1, sizeof(ltc_utctime))) == NULL) {
+               err = CRYPT_MEM;
+               goto error;
+            }
+            
+            len = *inlen;
+            if ((err = der_decode_utctime(in, &len, l->data)) != CRYPT_OK) {
+               goto error;
+            }
+            
+            if ((err = der_length_utctime(l->data, &len)) != CRYPT_OK) {
+               goto error;
+            }
+            break;
+         
+         case 0x30: /* SEQUENCE */
+         case 0x31: /* SET */
+         
+             /* init field */
+             l->type = (type == 0x30) ? LTC_ASN1_SEQUENCE : LTC_ASN1_SET;
+             
+             /* we have to decode the SEQUENCE header and get it's length */
+             
+                /* move past type */
+                ++in; --(*inlen);
+                
+                /* read length byte */
+                x = *in++; --(*inlen);
+                
+                /* smallest SEQUENCE/SET header */
+                y = 2;
+                
+                /* now if it's > 127 the next bytes are the length of the length */
+                if (x > 128) {
+                   x      &= 0x7F;
+                   in     += x;
+                   *inlen -= x;
+                   
+                   /* update sequence header len */
+                   y      += x;
+                }
+             
+             /* Sequence elements go as child */
+             len = len - y;
+             if ((err = der_decode_sequence_flexi(in, &len, &(l->child))) != CRYPT_OK) {
+                goto error;
+             }
+             
+             /* len update */
+             totlen += y;
+             
+             /* link them up y0 */
+             l->child->parent = l;
+             
+             break;
+         default:
+           /* invalid byte ... this is a soft error */
+           /* remove link */
+           l       = l->prev;
+           XFREE(l->next);
+           l->next = NULL;
+           goto outside;
+      }
+      
+      /* advance pointers */
+      totlen  += len;
+      in      += len;
+      *inlen  -= len;
+   }
+   
+outside:   
+
+   /* rewind l please */
+   while (l->prev != NULL || l->parent != NULL) {
+      if (l->parent != NULL) {
+         l = l->parent;
+      } else {
+         l = l->prev;
+      }
+   }
+   
+   /* return */
+   *out   = l;
+   *inlen = totlen;
+   return CRYPT_OK;
+
+error:
+   /* free list */
+   der_sequence_free(l);
+
+   return err;
+}
+
+#endif
+
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/asn1/der/sequence/der_decode_sequence_flexi.c,v $ */
+/* $Revision: 1.26 $ */
+/* $Date: 2006/12/28 01:27:24 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/asn1/der/sequence/der_decode_sequence_multi.c b/crypto/userspace/libtomcrypt/pk/asn1/der/sequence/der_decode_sequence_multi.c
new file mode 100644
index 0000000..d1b7878
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/asn1/der/sequence/der_decode_sequence_multi.c
@@ -0,0 +1,140 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+#include <stdarg.h>
+#include <linux/slab.h>
+
+
+/**
+  @file der_decode_sequence_multi.c
+  ASN.1 DER, decode a SEQUENCE, Tom St Denis
+*/
+
+#ifdef LTC_DER
+
+/**
+  Decode a SEQUENCE type using a VA list
+  @param in    Input buffer
+  @param inlen Length of input in octets
+  @remark <...> is of the form <type, size, data> (int, unsigned long, void*)
+  @return CRYPT_OK on success
+*/  
+int der_decode_sequence_multi(const unsigned char *in, unsigned long inlen, ...)
+{
+   int           err, type;
+   unsigned long size, x;
+   void          *data;
+   va_list       args;
+   ltc_asn1_list *list;
+
+   LTC_ARGCHK(in    != NULL);
+
+   /* get size of output that will be required */
+   va_start(args, inlen);
+   x = 0;
+   for (;;) {
+       type = va_arg(args, int);
+       size = va_arg(args, unsigned long);
+       data = va_arg(args, void*);
+
+       if (type == LTC_ASN1_EOL) { 
+          break;
+       }
+
+       switch (type) {
+           case LTC_ASN1_BOOLEAN:
+           case LTC_ASN1_INTEGER:
+           case LTC_ASN1_SHORT_INTEGER:
+           case LTC_ASN1_BIT_STRING:
+           case LTC_ASN1_OCTET_STRING:
+           case LTC_ASN1_NULL:
+           case LTC_ASN1_OBJECT_IDENTIFIER:
+           case LTC_ASN1_IA5_STRING:
+           case LTC_ASN1_PRINTABLE_STRING:
+           case LTC_ASN1_UTF8_STRING:
+           case LTC_ASN1_UTCTIME:
+           case LTC_ASN1_SET:
+           case LTC_ASN1_SETOF:
+           case LTC_ASN1_SEQUENCE:
+           case LTC_ASN1_CHOICE:
+                ++x; 
+                break;
+          
+           default:
+               va_end(args);
+               return CRYPT_INVALID_ARG;
+       }
+   }
+   va_end(args);
+
+   /* allocate structure for x elements */
+   if (x == 0) {
+      return CRYPT_NOP;
+   }
+
+   list = XCALLOC(sizeof(*list), x);
+   if (list == NULL) {
+      return CRYPT_MEM;
+   }
+
+   /* fill in the structure */
+   va_start(args, inlen);
+   x = 0;
+   for (;;) {
+       type = va_arg(args, int);
+       size = va_arg(args, unsigned long);
+       data = va_arg(args, void*);
+
+       if (type == LTC_ASN1_EOL) { 
+          break;
+       }
+
+       switch (type) {
+           case LTC_ASN1_BOOLEAN:
+           case LTC_ASN1_INTEGER:
+           case LTC_ASN1_SHORT_INTEGER:
+           case LTC_ASN1_BIT_STRING:
+           case LTC_ASN1_OCTET_STRING:
+           case LTC_ASN1_NULL:
+           case LTC_ASN1_OBJECT_IDENTIFIER:
+           case LTC_ASN1_IA5_STRING:
+           case LTC_ASN1_PRINTABLE_STRING:
+           case LTC_ASN1_UTF8_STRING:
+           case LTC_ASN1_UTCTIME:
+           case LTC_ASN1_SEQUENCE:
+           case LTC_ASN1_SET:
+           case LTC_ASN1_SETOF:          
+           case LTC_ASN1_CHOICE:
+                list[x].type   = type;
+                list[x].size   = size;
+                list[x++].data = data;
+                break;
+         
+           default:
+               va_end(args);
+               err = CRYPT_INVALID_ARG;
+               goto LBL_ERR;
+       }
+   }
+   va_end(args);
+
+   err = der_decode_sequence(in, inlen, list, x);
+LBL_ERR:
+   XFREE(list);
+   return err;
+}
+
+#endif
+
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/asn1/der/sequence/der_decode_sequence_multi.c,v $ */
+/* $Revision: 1.13 $ */
+/* $Date: 2006/12/28 01:27:24 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/asn1/der/sequence/der_encode_sequence_ex.c b/crypto/userspace/libtomcrypt/pk/asn1/der/sequence/der_encode_sequence_ex.c
new file mode 100644
index 0000000..e92f7c3
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/asn1/der/sequence/der_encode_sequence_ex.c
@@ -0,0 +1,335 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+#include <stdarg.h>
+
+
+/**
+  @file der_encode_sequence_ex.c
+  ASN.1 DER, encode a SEQUENCE, Tom St Denis
+*/
+
+#ifdef LTC_DER
+
+/**
+   Encode a SEQUENCE
+   @param list      The list of items to encode
+   @param inlen     The number of items in the list
+   @param out       [out] The destination 
+   @param outlen    [in/out] The size of the output
+   @param type_of   LTC_ASN1_SEQUENCE or LTC_ASN1_SET/LTC_ASN1_SETOF
+   @return CRYPT_OK on success
+*/
+int der_encode_sequence_ex(ltc_asn1_list *list, unsigned long inlen,
+                           unsigned char *out,  unsigned long *outlen, int type_of) 
+{
+   int           err, type;
+   unsigned long size, x, y, z, i;
+   void          *data;
+
+   LTC_ARGCHK(list    != NULL);
+   LTC_ARGCHK(out     != NULL);
+   LTC_ARGCHK(outlen  != NULL);
+
+   /* get size of output that will be required */
+   y = 0;
+   for (i = 0; i < inlen; i++) {
+       type = list[i].type;
+       size = list[i].size;
+       data = list[i].data;
+
+       if (type == LTC_ASN1_EOL) { 
+          break;
+       }
+
+       switch (type) {
+            case LTC_ASN1_BOOLEAN:
+               if ((err = der_length_boolean(&x)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               y += x;
+               break;
+
+           case LTC_ASN1_INTEGER:
+               if ((err = der_length_integer(data, &x)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               y += x;
+               break;
+
+           case LTC_ASN1_SHORT_INTEGER:
+               if ((err = der_length_short_integer(*((unsigned long*)data), &x)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               y += x;
+               break;
+
+           case LTC_ASN1_BIT_STRING:
+               if ((err = der_length_bit_string(size, &x)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               y += x;
+               break;
+
+           case LTC_ASN1_OCTET_STRING:
+               if ((err = der_length_octet_string(size, &x)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               y += x;
+               break;
+
+           case LTC_ASN1_NULL:
+               y += 2;
+               break;
+
+           case LTC_ASN1_OBJECT_IDENTIFIER:
+               if ((err = der_length_object_identifier(data, size, &x)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               y += x;
+               break;
+
+           case LTC_ASN1_IA5_STRING:
+               if ((err = der_length_ia5_string(data, size, &x)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               y += x;
+               break;
+
+           case LTC_ASN1_PRINTABLE_STRING:
+               if ((err = der_length_printable_string(data, size, &x)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               y += x;
+               break;
+
+           case LTC_ASN1_UTF8_STRING:
+               if ((err = der_length_utf8_string(data, size, &x)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               y += x;
+               break;
+
+           case LTC_ASN1_UTCTIME:
+               if ((err = der_length_utctime(data, &x)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               y += x;
+               break;
+
+           case LTC_ASN1_SET:
+           case LTC_ASN1_SETOF:
+           case LTC_ASN1_SEQUENCE:
+               if ((err = der_length_sequence(data, size, &x)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               y += x;
+               break;
+          
+           default:
+               err = CRYPT_INVALID_ARG;
+               goto LBL_ERR;
+       }
+   }
+
+   /* calc header size */
+   z = y;
+   if (y < 128) {
+      y += 2;
+   } else if (y < 256) {
+      /* 0x30 0x81 LL */
+      y += 3;
+   } else if (y < 65536UL) {
+      /* 0x30 0x82 LL LL */
+      y += 4;
+   } else if (y < 16777216UL) {
+      /* 0x30 0x83 LL LL LL */
+      y += 5;
+   } else {
+      err = CRYPT_INVALID_ARG;
+      goto LBL_ERR;
+   }
+
+   /* too big ? */
+   if (*outlen < y) {
+      *outlen = y;
+      err = CRYPT_BUFFER_OVERFLOW;
+      goto LBL_ERR;
+   }
+
+   /* store header */
+   x = 0;
+   out[x++] = (type_of == LTC_ASN1_SEQUENCE) ? 0x30 : 0x31;
+      
+   if (z < 128) {
+      out[x++] = (unsigned char)z;
+   } else if (z < 256) {
+      out[x++] = 0x81;
+      out[x++] = (unsigned char)z;
+   } else if (z < 65536UL) {
+      out[x++] = 0x82;
+      out[x++] = (unsigned char)((z>>8UL)&255);
+      out[x++] = (unsigned char)(z&255);
+   } else if (z < 16777216UL) {
+      out[x++] = 0x83;
+      out[x++] = (unsigned char)((z>>16UL)&255);
+      out[x++] = (unsigned char)((z>>8UL)&255);
+      out[x++] = (unsigned char)(z&255);
+   }
+
+   /* store data */
+   *outlen -= x;
+   for (i = 0; i < inlen; i++) {
+       type = list[i].type;
+       size = list[i].size;
+       data = list[i].data;
+
+       if (type == LTC_ASN1_EOL) { 
+          break;
+       }
+
+       switch (type) {
+            case LTC_ASN1_BOOLEAN:
+               z = *outlen;
+               if ((err = der_encode_boolean(*((int *)data), out + x, &z)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               x       += z;
+               *outlen -= z;
+               break;
+          
+           case LTC_ASN1_INTEGER:
+               z = *outlen;
+               if ((err = der_encode_integer(data, out + x, &z)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               x       += z;
+               *outlen -= z;
+               break;
+
+           case LTC_ASN1_SHORT_INTEGER:
+               z = *outlen;
+               if ((err = der_encode_short_integer(*((unsigned long*)data), out + x, &z)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               x       += z;
+               *outlen -= z;
+               break;
+
+           case LTC_ASN1_BIT_STRING:
+               z = *outlen;
+               if ((err = der_encode_bit_string(data, size, out + x, &z)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               x       += z;
+               *outlen -= z;
+               break;
+
+           case LTC_ASN1_OCTET_STRING:
+               z = *outlen;
+               if ((err = der_encode_octet_string(data, size, out + x, &z)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               x       += z;
+               *outlen -= z;
+               break;
+
+           case LTC_ASN1_NULL:
+               out[x++] = 0x05;
+               out[x++] = 0x00;
+               *outlen -= 2;
+               break;
+
+           case LTC_ASN1_OBJECT_IDENTIFIER:
+               z = *outlen;
+               if ((err = der_encode_object_identifier(data, size, out + x, &z)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               x       += z;
+               *outlen -= z;
+               break;
+
+           case LTC_ASN1_IA5_STRING:
+               z = *outlen;
+               if ((err = der_encode_ia5_string(data, size, out + x, &z)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               x       += z;
+               *outlen -= z;
+               break;
+          
+           case LTC_ASN1_PRINTABLE_STRING:
+               z = *outlen;
+               if ((err = der_encode_printable_string(data, size, out + x, &z)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               x       += z;
+               *outlen -= z;
+               break;
+
+           case LTC_ASN1_UTF8_STRING:
+               z = *outlen;
+               if ((err = der_encode_utf8_string(data, size, out + x, &z)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               x       += z;
+               *outlen -= z;
+               break;
+
+           case LTC_ASN1_UTCTIME:
+               z = *outlen;
+               if ((err = der_encode_utctime(data, out + x, &z)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               x       += z;
+               *outlen -= z;
+               break;
+
+           case LTC_ASN1_SET:
+               z = *outlen;
+               if ((err = der_encode_set(data, size, out + x, &z)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               x       += z;
+               *outlen -= z;
+               break;
+
+           case LTC_ASN1_SETOF:
+               z = *outlen;
+               if ((err = der_encode_setof(data, size, out + x, &z)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               x       += z;
+               *outlen -= z;
+               break;
+
+           case LTC_ASN1_SEQUENCE:
+               z = *outlen;
+               if ((err = der_encode_sequence_ex(data, size, out + x, &z, type)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               x       += z;
+               *outlen -= z;
+               break;
+           
+           default:
+               err = CRYPT_INVALID_ARG;
+               goto LBL_ERR;
+       }
+   }
+   *outlen = x;
+   err = CRYPT_OK;   
+
+LBL_ERR:
+   return err;
+}
+
+#endif
diff --git a/crypto/userspace/libtomcrypt/pk/asn1/der/sequence/der_encode_sequence_multi.c b/crypto/userspace/libtomcrypt/pk/asn1/der/sequence/der_encode_sequence_multi.c
new file mode 100644
index 0000000..7e813172
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/asn1/der/sequence/der_encode_sequence_multi.c
@@ -0,0 +1,139 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+#include <stdarg.h>
+#include <linux/slab.h>
+
+
+/**
+  @file der_encode_sequence_multi.c
+  ASN.1 DER, encode a SEQUENCE, Tom St Denis
+*/
+
+#ifdef LTC_DER
+
+/**
+  Encode a SEQUENCE type using a VA list
+  @param out    [out] Destination for data
+  @param outlen [in/out] Length of buffer and resulting length of output
+  @remark <...> is of the form <type, size, data> (int, unsigned long, void*)
+  @return CRYPT_OK on success
+*/  
+int der_encode_sequence_multi(unsigned char *out, unsigned long *outlen, ...)
+{
+   int           err, type;
+   unsigned long size, x;
+   void          *data;
+   va_list       args;
+   ltc_asn1_list *list;
+
+   LTC_ARGCHK(out    != NULL);
+   LTC_ARGCHK(outlen != NULL);
+
+   /* get size of output that will be required */
+   va_start(args, outlen);
+   x = 0;
+   for (;;) {
+       type = va_arg(args, int);
+       size = va_arg(args, unsigned long);
+       data = va_arg(args, void*);
+
+       if (type == LTC_ASN1_EOL) { 
+          break;
+       }
+
+       switch (type) {
+           case LTC_ASN1_BOOLEAN:
+           case LTC_ASN1_INTEGER:
+           case LTC_ASN1_SHORT_INTEGER:
+           case LTC_ASN1_BIT_STRING:
+           case LTC_ASN1_OCTET_STRING:
+           case LTC_ASN1_NULL:
+           case LTC_ASN1_OBJECT_IDENTIFIER:
+           case LTC_ASN1_IA5_STRING:
+           case LTC_ASN1_PRINTABLE_STRING:
+           case LTC_ASN1_UTF8_STRING:
+           case LTC_ASN1_UTCTIME:
+           case LTC_ASN1_SEQUENCE:
+           case LTC_ASN1_SET:
+           case LTC_ASN1_SETOF:
+                ++x; 
+                break;
+          
+           default:
+               va_end(args);
+               return CRYPT_INVALID_ARG;
+       }
+   }
+   va_end(args);
+
+   /* allocate structure for x elements */
+   if (x == 0) {
+      return CRYPT_NOP;
+   }
+
+   list = XCALLOC(sizeof(*list), x);
+   if (list == NULL) {
+      return CRYPT_MEM;
+   }
+
+   /* fill in the structure */
+   va_start(args, outlen);
+   x = 0;
+   for (;;) {
+       type = va_arg(args, int);
+       size = va_arg(args, unsigned long);
+       data = va_arg(args, void*);
+
+       if (type == LTC_ASN1_EOL) { 
+          break;
+       }
+
+       switch (type) {
+           case LTC_ASN1_BOOLEAN:
+           case LTC_ASN1_INTEGER:
+           case LTC_ASN1_SHORT_INTEGER:
+           case LTC_ASN1_BIT_STRING:
+           case LTC_ASN1_OCTET_STRING:
+           case LTC_ASN1_NULL:
+           case LTC_ASN1_OBJECT_IDENTIFIER:
+           case LTC_ASN1_IA5_STRING:
+           case LTC_ASN1_PRINTABLE_STRING:
+           case LTC_ASN1_UTF8_STRING:
+           case LTC_ASN1_UTCTIME:
+           case LTC_ASN1_SEQUENCE:
+           case LTC_ASN1_SET:
+           case LTC_ASN1_SETOF:
+                list[x].type   = type;
+                list[x].size   = size;
+                list[x++].data = data;
+                break;
+         
+           default:
+               va_end(args);
+               err = CRYPT_INVALID_ARG;
+               goto LBL_ERR;
+       }
+   }
+   va_end(args);
+
+   err = der_encode_sequence(list, x, out, outlen);   
+LBL_ERR:
+   XFREE(list);
+   return err;
+}
+
+#endif
+
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/asn1/der/sequence/der_encode_sequence_multi.c,v $ */
+/* $Revision: 1.12 $ */
+/* $Date: 2006/12/28 01:27:24 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/asn1/der/sequence/der_length_sequence.c b/crypto/userspace/libtomcrypt/pk/asn1/der/sequence/der_length_sequence.c
new file mode 100644
index 0000000..d2e9803
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/asn1/der/sequence/der_length_sequence.c
@@ -0,0 +1,169 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/**
+  @file der_length_sequence.c
+  ASN.1 DER, length a SEQUENCE, Tom St Denis
+*/
+
+#ifdef LTC_DER
+
+/**
+   Get the length of a DER sequence 
+   @param list   The sequences of items in the SEQUENCE
+   @param inlen  The number of items
+   @param outlen [out] The length required in octets to store it 
+   @return CRYPT_OK on success
+*/
+int der_length_sequence(ltc_asn1_list *list, unsigned long inlen,
+                        unsigned long *outlen) 
+{
+   int           err, type;
+   unsigned long size, x, y, z, i;
+   void          *data;
+
+   LTC_ARGCHK(list    != NULL);
+   LTC_ARGCHK(outlen  != NULL);
+
+   /* get size of output that will be required */
+   y = 0;
+   for (i = 0; i < inlen; i++) {
+       type = list[i].type;
+       size = list[i].size;
+       data = list[i].data;
+
+       if (type == LTC_ASN1_EOL) { 
+          break;
+       }
+
+       switch (type) {
+           case LTC_ASN1_BOOLEAN:
+              if ((err = der_length_boolean(&x)) != CRYPT_OK) {
+                 goto LBL_ERR;
+              }
+              y += x;
+              break;
+          
+           case LTC_ASN1_INTEGER:
+               if ((err = der_length_integer(data, &x)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               y += x;
+               break;
+
+           case LTC_ASN1_SHORT_INTEGER:
+               if ((err = der_length_short_integer(*((unsigned long *)data), &x)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               y += x;
+               break;
+
+           case LTC_ASN1_BIT_STRING:
+               if ((err = der_length_bit_string(size, &x)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               y += x;
+               break;
+
+           case LTC_ASN1_OCTET_STRING:
+               if ((err = der_length_octet_string(size, &x)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               y += x;
+               break;
+
+           case LTC_ASN1_NULL:
+               y += 2;
+               break;
+
+           case LTC_ASN1_OBJECT_IDENTIFIER:
+               if ((err = der_length_object_identifier(data, size, &x)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               y += x;
+               break;
+
+           case LTC_ASN1_IA5_STRING:
+               if ((err = der_length_ia5_string(data, size, &x)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               y += x;
+               break;
+
+           case LTC_ASN1_PRINTABLE_STRING:
+               if ((err = der_length_printable_string(data, size, &x)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               y += x;
+               break;
+
+           case LTC_ASN1_UTCTIME:
+               if ((err = der_length_utctime(data, &x)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               y += x;
+               break;
+
+           case LTC_ASN1_UTF8_STRING:
+               if ((err = der_length_utf8_string(data, size, &x)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               y += x;
+               break;
+
+           case LTC_ASN1_SET:
+           case LTC_ASN1_SETOF:
+           case LTC_ASN1_SEQUENCE:
+               if ((err = der_length_sequence(data, size, &x)) != CRYPT_OK) {
+                  goto LBL_ERR;
+               }
+               y += x;
+               break;
+
+          
+           default:
+               err = CRYPT_INVALID_ARG;
+               goto LBL_ERR;
+       }
+   }
+
+   /* calc header size */
+   z = y;
+   if (y < 128) {
+      y += 2;
+   } else if (y < 256) {
+      /* 0x30 0x81 LL */
+      y += 3;
+   } else if (y < 65536UL) {
+      /* 0x30 0x82 LL LL */
+      y += 4;
+   } else if (y < 16777216UL) {
+      /* 0x30 0x83 LL LL LL */
+      y += 5;
+   } else {
+      err = CRYPT_INVALID_ARG;
+      goto LBL_ERR;
+   }
+
+   /* store size */
+   *outlen = y;
+   err     = CRYPT_OK;
+
+LBL_ERR:
+   return err;
+}
+
+#endif
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/asn1/der/sequence/der_length_sequence.c,v $ */
+/* $Revision: 1.14 $ */
+/* $Date: 2006/12/28 01:27:24 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/asn1/der/sequence/der_sequence_free.c b/crypto/userspace/libtomcrypt/pk/asn1/der/sequence/der_sequence_free.c
new file mode 100644
index 0000000..eed73e7
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/asn1/der/sequence/der_sequence_free.c
@@ -0,0 +1,66 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+#include <linux/slab.h>
+
+/**
+  @file der_sequence_free.c
+  ASN.1 DER, free's a structure allocated by der_decode_sequence_flexi(), Tom St Denis
+*/
+
+#ifdef LTC_DER
+
+/**
+  Free memory allocated by der_decode_sequence_flexi()
+  @param in     The list to free
+*/  
+void der_sequence_free(ltc_asn1_list *in)
+{
+   ltc_asn1_list *l;
+   
+   /* walk to the start of the chain */
+   while (in->prev != NULL || in->parent != NULL) {
+      if (in->parent != NULL) {
+          in = in->parent;
+      } else {
+          in = in->prev;
+      }
+   }
+   
+   /* now walk the list and free stuff */
+   while (in != NULL) {
+      /* is there a child? */
+      if (in->child) {
+         /* disconnect */
+         in->child->parent = NULL;
+         der_sequence_free(in->child);
+      }
+      
+      switch (in->type) { 
+         case LTC_ASN1_SET:
+         case LTC_ASN1_SETOF:
+         case LTC_ASN1_SEQUENCE: break;
+         case LTC_ASN1_INTEGER : if (in->data != NULL) { mp_clear(in->data); XFREE(in->data); } break;
+         default               : if (in->data != NULL) { XFREE(in->data);    }
+      }
+      
+      /* move to next and free current */
+      l = in->next;
+      XFREE(in);
+      in = l;
+   }     
+}
+
+#endif
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/asn1/der/sequence/der_sequence_free.c,v $ */
+/* $Revision: 1.4 $ */
+/* $Date: 2006/12/28 01:27:24 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/asn1/der/set/der_encode_set.c b/crypto/userspace/libtomcrypt/pk/asn1/der/set/der_encode_set.c
new file mode 100644
index 0000000..babb9ea
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/asn1/der/set/der_encode_set.c
@@ -0,0 +1,104 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+  * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+#include <linux/slab.h>
+
+/**
+  @file der_encode_set.c
+  ASN.1 DER, Encode a SET, Tom St Denis
+*/
+
+#ifdef LTC_DER
+
+/* LTC define to ASN.1 TAG */
+static int ltc_to_asn1(int v)
+{
+   switch (v) {
+      case LTC_ASN1_BOOLEAN:                 return 0x01;
+      case LTC_ASN1_INTEGER:
+      case LTC_ASN1_SHORT_INTEGER:           return 0x02;
+      case LTC_ASN1_BIT_STRING:              return 0x03;
+      case LTC_ASN1_OCTET_STRING:            return 0x04;
+      case LTC_ASN1_NULL:                    return 0x05;
+      case LTC_ASN1_OBJECT_IDENTIFIER:       return 0x06;
+      case LTC_ASN1_UTF8_STRING:             return 0x0C;
+      case LTC_ASN1_PRINTABLE_STRING:        return 0x13;
+      case LTC_ASN1_IA5_STRING:              return 0x16;
+      case LTC_ASN1_UTCTIME:                 return 0x17;
+      case LTC_ASN1_SEQUENCE:                return 0x30;
+      case LTC_ASN1_SET:
+      case LTC_ASN1_SETOF:                   return 0x31;
+      default: return -1;
+   }
+}         
+      
+
+static int qsort_helper(const void *a, const void *b)
+{
+   ltc_asn1_list *A = (ltc_asn1_list *)a, *B = (ltc_asn1_list *)b;
+   int            r;
+   
+   r = ltc_to_asn1(A->type) - ltc_to_asn1(B->type);
+   
+   /* for QSORT the order is UNDEFINED if they are "equal" which means it is NOT DETERMINISTIC.  So we force it to be :-) */
+   if (r == 0) {
+      /* their order in the original list now determines the position */
+      return A->used - B->used;
+   } else {
+      return r;
+   }
+}   
+
+/*
+   Encode a SET type
+   @param list      The list of items to encode
+   @param inlen     The number of items in the list
+   @param out       [out] The destination 
+   @param outlen    [in/out] The size of the output
+   @return CRYPT_OK on success
+*/
+int der_encode_set(ltc_asn1_list *list, unsigned long inlen,
+                   unsigned char *out,  unsigned long *outlen)
+{
+   ltc_asn1_list  *copy;
+   unsigned long   x;
+   int             err;
+   
+   /* make copy of list */
+   copy = XCALLOC(inlen, sizeof(*copy));
+   if (copy == NULL) {
+      return CRYPT_MEM;
+   }      
+   
+   /* fill in used member with index so we can fully sort it */
+   for (x = 0; x < inlen; x++) {
+       copy[x]      = list[x];
+       copy[x].used = x;
+   }       
+   
+   /* sort it by the "type" field */
+   XQSORT(copy, inlen, sizeof(*copy), &qsort_helper);   
+   
+   /* call der_encode_sequence_ex() */
+   err = der_encode_sequence_ex(copy, inlen, out, outlen, LTC_ASN1_SET);   
+   
+   /* free list */
+   XFREE(copy);
+   
+   return err;
+}                   
+
+
+#endif
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/asn1/der/set/der_encode_set.c,v $ */
+/* $Revision: 1.12 $ */
+/* $Date: 2006/12/28 01:27:24 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/asn1/der/set/der_encode_setof.c b/crypto/userspace/libtomcrypt/pk/asn1/der/set/der_encode_setof.c
new file mode 100644
index 0000000..2a343f2
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/asn1/der/set/der_encode_setof.c
@@ -0,0 +1,163 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+#include <linux/slab.h>
+
+/**
+  @file der_encode_setof.c
+  ASN.1 DER, Encode SET OF, Tom St Denis
+*/
+
+#ifdef LTC_DER
+
+struct edge {
+   unsigned char *start;
+   unsigned long  size;
+};
+
+static int qsort_helper(const void *a, const void *b)
+{
+   struct edge   *A = (struct edge *)a, *B = (struct edge *)b;
+   int            r;
+   unsigned long  x;
+   
+   /* compare min length */
+   r = XMEMCMP(A->start, B->start, MIN(A->size, B->size));
+   
+   if (r == 0 && A->size != B->size) {
+      if (A->size > B->size) {
+         for (x = B->size; x < A->size; x++) {
+            if (A->start[x]) {
+               return 1;
+            }
+         }
+      } else {
+         for (x = A->size; x < B->size; x++) {
+            if (B->start[x]) {
+               return -1;
+            }
+         }
+      }         
+   }
+   
+   return r;      
+}
+
+/**
+   Encode a SETOF stucture
+   @param list      The list of items to encode
+   @param inlen     The number of items in the list
+   @param out       [out] The destination 
+   @param outlen    [in/out] The size of the output
+   @return CRYPT_OK on success
+*/   
+int der_encode_setof(ltc_asn1_list *list, unsigned long inlen,
+                     unsigned char *out,  unsigned long *outlen)
+{
+   unsigned long  x, y, z, hdrlen;
+   int            err;
+   struct edge   *edges;
+   unsigned char *ptr, *buf;
+   
+   /* check that they're all the same type */
+   for (x = 1; x < inlen; x++) {
+      if (list[x].type != list[x-1].type) {
+         return CRYPT_INVALID_ARG;
+      }
+   }
+
+   /* alloc buffer to store copy of output */
+   buf = XCALLOC(1, *outlen);
+   if (buf == NULL) {
+      return CRYPT_MEM;
+   }      
+                  
+   /* encode list */
+   if ((err = der_encode_sequence_ex(list, inlen, buf, outlen, LTC_ASN1_SETOF)) != CRYPT_OK) {
+       XFREE(buf);
+       return err;
+   }
+   
+   /* allocate edges */
+   edges = XCALLOC(inlen, sizeof(*edges));
+   if (edges == NULL) {
+      XFREE(buf);
+      return CRYPT_MEM;
+   }      
+   
+   /* skip header */
+      ptr = buf + 1;
+
+      /* now skip length data */
+      x = *ptr++;
+      if (x >= 0x80) {
+         ptr += (x & 0x7F);
+      }
+      
+      /* get the size of the static header */
+      hdrlen = ((unsigned long)ptr) - ((unsigned long)buf);
+      
+      
+   /* scan for edges */
+   x = 0;
+   while (ptr < (buf + *outlen)) {
+      /* store start */
+      edges[x].start = ptr;
+      
+      /* skip type */
+      z = 1;
+      
+      /* parse length */
+      y = ptr[z++];
+      if (y < 128) {
+         edges[x].size = y;
+      } else {
+         y &= 0x7F;
+         edges[x].size = 0;
+         while (y--) {
+            edges[x].size = (edges[x].size << 8) | ((unsigned long)ptr[z++]);
+         }
+      }
+      
+      /* skip content */
+      edges[x].size += z;
+      ptr           += edges[x].size;
+      ++x;
+   }      
+      
+   /* sort based on contents (using edges) */
+   XQSORT(edges, inlen, sizeof(*edges), &qsort_helper);
+   
+   /* copy static header */
+   XMEMCPY(out, buf, hdrlen);
+   
+   /* copy+sort using edges+indecies to output from buffer */
+   for (y = hdrlen, x = 0; x < inlen; x++) {
+      XMEMCPY(out+y, edges[x].start, edges[x].size);
+      y += edges[x].size;
+   }      
+   
+#ifdef LTC_CLEAN_STACK
+   zeromem(buf, *outlen);
+#endif      
+   
+   /* free buffers */
+   XFREE(edges);
+   XFREE(buf);
+   
+   return CRYPT_OK;
+}
+
+#endif
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/asn1/der/set/der_encode_setof.c,v $ */
+/* $Revision: 1.12 $ */
+/* $Date: 2006/12/28 01:27:24 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/asn1/der/short_integer/der_decode_short_integer.c b/crypto/userspace/libtomcrypt/pk/asn1/der/short_integer/der_decode_short_integer.c
new file mode 100644
index 0000000..fbb89a4
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/asn1/der/short_integer/der_decode_short_integer.c
@@ -0,0 +1,68 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/**
+  @file der_decode_short_integer.c
+  ASN.1 DER, decode an integer, Tom St Denis
+*/
+
+
+#ifdef LTC_DER
+
+/**
+  Read a short integer
+  @param in       The DER encoded data
+  @param inlen    Size of data
+  @param num      [out] The integer to decode
+  @return CRYPT_OK if successful
+*/
+int der_decode_short_integer(const unsigned char *in, unsigned long inlen, unsigned long *num)
+{
+   unsigned long len, x, y;
+
+   LTC_ARGCHK(num    != NULL);
+   LTC_ARGCHK(in     != NULL);
+
+   /* check length */
+   if (inlen < 2) {
+      return CRYPT_INVALID_PACKET;
+   }
+
+   /* check header */
+   x = 0;
+   if ((in[x++] & 0x1F) != 0x02) {
+      return CRYPT_INVALID_PACKET;
+   }
+
+   /* get the packet len */
+   len = in[x++];
+
+   if (x + len > inlen) {
+      return CRYPT_INVALID_PACKET;
+   }
+
+   /* read number */
+   y = 0;
+   while (len--) {
+      y = (y<<8) | (unsigned long)in[x++];
+   }
+   *num = y;
+
+   return CRYPT_OK;
+
+}
+
+#endif
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/asn1/der/short_integer/der_decode_short_integer.c,v $ */
+/* $Revision: 1.7 $ */
+/* $Date: 2006/12/28 01:27:24 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/asn1/der/short_integer/der_encode_short_integer.c b/crypto/userspace/libtomcrypt/pk/asn1/der/short_integer/der_encode_short_integer.c
new file mode 100644
index 0000000..cd9e6d1
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/asn1/der/short_integer/der_encode_short_integer.c
@@ -0,0 +1,97 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/**
+  @file der_encode_short_integer.c
+  ASN.1 DER, encode an integer, Tom St Denis
+*/
+
+
+#ifdef LTC_DER
+
+/**
+  Store a short integer in the range (0,2^32-1)
+  @param num      The integer to encode
+  @param out      [out] The destination for the DER encoded integers
+  @param outlen   [in/out] The max size and resulting size of the DER encoded integers
+  @return CRYPT_OK if successful
+*/
+int der_encode_short_integer(unsigned long num, unsigned char *out, unsigned long *outlen)
+{  
+   unsigned long len, x, y, z;
+   int           err;
+   
+   LTC_ARGCHK(out    != NULL);
+   LTC_ARGCHK(outlen != NULL);
+
+   /* force to 32 bits */
+   num &= 0xFFFFFFFFUL;
+
+   /* find out how big this will be */
+   if ((err = der_length_short_integer(num, &len)) != CRYPT_OK) {
+      return err;
+   }
+
+   if (*outlen < len) {
+      *outlen = len;
+      return CRYPT_BUFFER_OVERFLOW;
+   }
+
+   /* get len of output */
+   z = 0;
+   y = num;
+   while (y) {
+     ++z;
+     y >>= 8;
+   }
+
+   /* handle zero */
+   if (z == 0) {
+      z = 1;
+   }
+
+   /* see if msb is set */
+   z += (num&(1UL<<((z<<3) - 1))) ? 1 : 0;
+
+   /* adjust the number so the msB is non-zero */
+   for (x = 0; (z <= 4) && (x < (4 - z)); x++) {
+      num <<= 8;
+   }
+
+   /* store header */
+   x = 0;
+   out[x++] = 0x02;
+   out[x++] = (unsigned char)z;
+
+   /* if 31st bit is set output a leading zero and decrement count */
+   if (z == 5) {
+      out[x++] = 0;
+      --z;
+   }
+
+   /* store values */
+   for (y = 0; y < z; y++) {
+      out[x++] = (unsigned char)((num >> 24) & 0xFF);
+      num    <<= 8;
+   }
+
+   /* we good */
+   *outlen = x;
+ 
+   return CRYPT_OK;
+}
+
+#endif
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/asn1/der/short_integer/der_encode_short_integer.c,v $ */
+/* $Revision: 1.8 $ */
+/* $Date: 2006/12/28 01:27:24 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/asn1/der/short_integer/der_length_short_integer.c b/crypto/userspace/libtomcrypt/pk/asn1/der/short_integer/der_length_short_integer.c
new file mode 100644
index 0000000..ec3f8f1
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/asn1/der/short_integer/der_length_short_integer.c
@@ -0,0 +1,70 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/**
+  @file der_length_short_integer.c
+  ASN.1 DER, get length of encoding, Tom St Denis
+*/
+
+
+#ifdef LTC_DER
+/**
+  Gets length of DER encoding of num 
+  @param num    The integer to get the size of 
+  @param outlen [out] The length of the DER encoding for the given integer
+  @return CRYPT_OK if successful
+*/
+int der_length_short_integer(unsigned long num, unsigned long *outlen)
+{
+   unsigned long z, y, len;
+
+   LTC_ARGCHK(outlen  != NULL);
+
+   /* force to 32 bits */
+   num &= 0xFFFFFFFFUL;
+
+   /* get the number of bytes */
+   z = 0;
+   y = num;
+   while (y) {
+     ++z;
+     y >>= 8;
+   }
+   
+   /* handle zero */
+   if (z == 0) {
+      z = 1;
+   }
+
+   /* we need a 0x02 to indicate it's INTEGER */
+   len = 1;
+
+   /* length byte */
+   ++len;
+
+   /* bytes in value */
+   len += z;
+
+   /* see if msb is set */
+   len += (num&(1UL<<((z<<3) - 1))) ? 1 : 0;
+
+   /* return length */
+   *outlen = len; 
+   
+   return CRYPT_OK;
+}
+
+#endif
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/asn1/der/short_integer/der_length_short_integer.c,v $ */
+/* $Revision: 1.6 $ */
+/* $Date: 2006/12/28 01:27:24 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/asn1/der/utctime/der_decode_utctime.c b/crypto/userspace/libtomcrypt/pk/asn1/der/utctime/der_decode_utctime.c
new file mode 100644
index 0000000..54fc204
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/asn1/der/utctime/der_decode_utctime.c
@@ -0,0 +1,127 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/**
+  @file der_decode_utctime.c
+  ASN.1 DER, decode a  UTCTIME, Tom St Denis
+*/
+
+#ifdef LTC_DER
+
+static int char_to_int(unsigned char x)
+{
+   switch (x)  {
+      case '0': return 0;
+      case '1': return 1;
+      case '2': return 2;
+      case '3': return 3;
+      case '4': return 4;
+      case '5': return 5;
+      case '6': return 6;
+      case '7': return 7;
+      case '8': return 8;
+      case '9': return 9;
+   }
+   return 100;
+}
+
+#define DECODE_V(y, max) \
+   y  = char_to_int(buf[x])*10 + char_to_int(buf[x+1]); \
+   if (y >= max) return CRYPT_INVALID_PACKET;           \
+   x += 2;
+
+/**
+  Decodes a UTC time structure in DER format (reads all 6 valid encoding formats)
+  @param in     Input buffer
+  @param inlen  Length of input buffer in octets
+  @param out    [out] Destination of UTC time structure
+  @return CRYPT_OK   if successful
+*/
+int der_decode_utctime(const unsigned char *in, unsigned long *inlen,
+                             ltc_utctime   *out)
+{
+   unsigned char buf[32];
+   unsigned long x;
+   int           y;
+
+   LTC_ARGCHK(in    != NULL);
+   LTC_ARGCHK(inlen != NULL);
+   LTC_ARGCHK(out   != NULL);
+
+   /* check header */
+   if (*inlen < 2UL || (in[1] >= sizeof(buf)) || ((in[1] + 2UL) > *inlen)) {
+      return CRYPT_INVALID_PACKET;
+   }
+
+   /* decode the string */
+   for (x = 0; x < in[1]; x++) {
+       y = der_ia5_value_decode(in[x+2]);
+       if (y == -1) {
+          return CRYPT_INVALID_PACKET;
+       }
+       buf[x] = y;
+   }
+   *inlen = 2 + x;
+
+
+   /* possible encodings are 
+YYMMDDhhmmZ
+YYMMDDhhmm+hh'mm'
+YYMMDDhhmm-hh'mm'
+YYMMDDhhmmssZ
+YYMMDDhhmmss+hh'mm'
+YYMMDDhhmmss-hh'mm'
+
+    So let's do a trivial decode upto [including] mm 
+   */
+
+    x = 0;
+    DECODE_V(out->YY, 100);
+    DECODE_V(out->MM, 13);
+    DECODE_V(out->DD, 32);
+    DECODE_V(out->hh, 24);
+    DECODE_V(out->mm, 60);
+
+    /* clear timezone and seconds info */
+    out->off_dir = out->off_hh = out->off_mm = out->ss = 0;
+
+    /* now is it Z, +, - or 0-9 */
+    if (buf[x] == 'Z') {
+       return CRYPT_OK;
+    } else if (buf[x] == '+' || buf[x] == '-') {
+       out->off_dir = (buf[x++] == '+') ? 0 : 1;
+       DECODE_V(out->off_hh, 24);
+       DECODE_V(out->off_mm, 60);
+       return CRYPT_OK;
+    }
+
+    /* decode seconds */
+    DECODE_V(out->ss, 60);
+
+    /* now is it Z, +, - */
+    if (buf[x] == 'Z') {
+       return CRYPT_OK;
+    } else if (buf[x] == '+' || buf[x] == '-') {
+       out->off_dir = (buf[x++] == '+') ? 0 : 1;
+       DECODE_V(out->off_hh, 24);
+       DECODE_V(out->off_mm, 60);
+       return CRYPT_OK;
+    } else {
+       return CRYPT_INVALID_PACKET;
+    }
+}
+
+#endif
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/asn1/der/utctime/der_decode_utctime.c,v $ */
+/* $Revision: 1.9 $ */
+/* $Date: 2006/12/28 01:27:24 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/asn1/der/utctime/der_encode_utctime.c b/crypto/userspace/libtomcrypt/pk/asn1/der/utctime/der_encode_utctime.c
new file mode 100644
index 0000000..cb32dfa
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/asn1/der/utctime/der_encode_utctime.c
@@ -0,0 +1,83 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/**
+  @file der_encode_utctime.c
+  ASN.1 DER, encode a  UTCTIME, Tom St Denis
+*/
+
+#ifdef LTC_DER
+
+static const char *baseten = "0123456789";
+
+#define STORE_V(y) \
+    out[x++] = der_ia5_char_encode(baseten[(y/10) % 10]); \
+    out[x++] = der_ia5_char_encode(baseten[y % 10]);
+
+/**
+  Encodes a UTC time structure in DER format
+  @param utctime      The UTC time structure to encode
+  @param out          The destination of the DER encoding of the UTC time structure
+  @param outlen       [in/out] The length of the DER encoding
+  @return CRYPT_OK if successful
+*/
+int der_encode_utctime(ltc_utctime *utctime, 
+                       unsigned char *out,   unsigned long *outlen)
+{
+    unsigned long x, tmplen;
+    int           err;
+ 
+    LTC_ARGCHK(utctime != NULL);
+    LTC_ARGCHK(out     != NULL);
+    LTC_ARGCHK(outlen  != NULL);
+
+    if ((err = der_length_utctime(utctime, &tmplen)) != CRYPT_OK) {
+       return err;
+    }
+    if (tmplen > *outlen) {
+        *outlen = tmplen;
+        return CRYPT_BUFFER_OVERFLOW;
+    }
+    
+    /* store header */
+    out[0] = 0x17;
+
+    /* store values */
+    x = 2;
+    STORE_V(utctime->YY);
+    STORE_V(utctime->MM);
+    STORE_V(utctime->DD);
+    STORE_V(utctime->hh);
+    STORE_V(utctime->mm);
+    STORE_V(utctime->ss);
+
+    if (utctime->off_mm || utctime->off_hh) {
+       out[x++] = der_ia5_char_encode(utctime->off_dir ? '-' : '+');
+       STORE_V(utctime->off_hh);
+       STORE_V(utctime->off_mm);
+    } else {
+       out[x++] = der_ia5_char_encode('Z');
+    }
+
+    /* store length */
+    out[1] = (unsigned char)(x - 2);
+   
+    /* all good let's return */
+    *outlen = x;
+    return CRYPT_OK;
+}
+
+#endif
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/asn1/der/utctime/der_encode_utctime.c,v $ */
+/* $Revision: 1.10 $ */
+/* $Date: 2006/12/28 01:27:24 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/asn1/der/utctime/der_length_utctime.c b/crypto/userspace/libtomcrypt/pk/asn1/der/utctime/der_length_utctime.c
new file mode 100644
index 0000000..e5922b0
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/asn1/der/utctime/der_length_utctime.c
@@ -0,0 +1,46 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/**
+  @file der_length_utctime.c
+  ASN.1 DER, get length of UTCTIME, Tom St Denis
+*/
+
+#ifdef LTC_DER
+
+/**
+  Gets length of DER encoding of UTCTIME
+  @param utctime      The UTC time structure to get the size of
+  @param outlen [out] The length of the DER encoding
+  @return CRYPT_OK if successful
+*/
+int der_length_utctime(ltc_utctime *utctime, unsigned long *outlen)
+{
+   LTC_ARGCHK(outlen  != NULL);
+   LTC_ARGCHK(utctime != NULL);
+
+   if (utctime->off_hh == 0 && utctime->off_mm == 0) {
+      /* we encode as YYMMDDhhmmssZ */
+      *outlen = 2 + 13;
+   } else {
+      /* we encode as YYMMDDhhmmss{+|-}hh'mm' */
+      *outlen = 2 + 17;
+   }
+
+   return CRYPT_OK;
+}
+
+#endif
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/asn1/der/utctime/der_length_utctime.c,v $ */
+/* $Revision: 1.5 $ */
+/* $Date: 2006/12/28 01:27:24 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/asn1/der/utf8/der_decode_utf8_string.c b/crypto/userspace/libtomcrypt/pk/asn1/der/utf8/der_decode_utf8_string.c
new file mode 100644
index 0000000..9df7e23
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/asn1/der/utf8/der_decode_utf8_string.c
@@ -0,0 +1,111 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/**
+  @file der_decode_utf8_string.c
+  ASN.1 DER, encode a UTF8 STRING, Tom St Denis
+*/
+
+
+#ifdef LTC_DER
+
+/**
+  Store a UTF8 STRING
+  @param in      The DER encoded UTF8 STRING
+  @param inlen   The size of the DER UTF8 STRING
+  @param out     [out] The array of utf8s stored (one per char)
+  @param outlen  [in/out] The number of utf8s stored
+  @return CRYPT_OK if successful
+*/
+int der_decode_utf8_string(const unsigned char *in,  unsigned long inlen,
+                                       wchar_t *out, unsigned long *outlen)
+{
+   wchar_t       tmp;
+   unsigned long x, y, z, len;
+
+   LTC_ARGCHK(in     != NULL);
+   LTC_ARGCHK(out    != NULL);
+   LTC_ARGCHK(outlen != NULL);
+
+   /* must have header at least */
+   if (inlen < 2) {
+      return CRYPT_INVALID_PACKET;
+   }
+
+   /* check for 0x0C */
+   if ((in[0] & 0x1F) != 0x0C) {
+      return CRYPT_INVALID_PACKET;
+   }
+   x = 1;
+
+   /* decode the length */
+   if (in[x] & 0x80) {
+      /* valid # of bytes in length are 1,2,3 */
+      y = in[x] & 0x7F;
+      if ((y == 0) || (y > 3) || ((x + y) > inlen)) {
+         return CRYPT_INVALID_PACKET;
+      }
+
+      /* read the length in */
+      len = 0;
+      ++x;
+      while (y--) {
+         len = (len << 8) | in[x++];
+      }
+   } else {
+      len = in[x++] & 0x7F;
+   }
+
+   if (len + x > inlen) {
+      return CRYPT_INVALID_PACKET;
+   }
+
+   /* proceed to decode */
+   for (y = 0; x < inlen; ) {
+      /* get first byte */
+      tmp = in[x++];
+ 
+      /* count number of bytes */
+      for (z = 0; (tmp & 0x80) && (z <= 4); z++, tmp = (tmp << 1) & 0xFF);
+      
+      if (z > 4 || (x + (z - 1) > inlen)) {
+         return CRYPT_INVALID_PACKET;
+      }
+
+      /* decode, grab upper bits */
+      tmp >>= z;
+
+      /* grab remaining bytes */
+      if (z > 1) { --z; }
+      while (z-- != 0) {
+         if ((in[x] & 0xC0) != 0x80) {
+            return CRYPT_INVALID_PACKET;
+         }
+         tmp = (tmp << 6) | ((wchar_t)in[x++] & 0x3F);
+      }
+
+      if (y > *outlen) {
+         *outlen = y;
+         return CRYPT_BUFFER_OVERFLOW;
+      }
+      out[y++] = tmp;
+   }
+   *outlen = y;
+
+   return CRYPT_OK;
+}
+ 
+#endif
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/asn1/der/utf8/der_decode_utf8_string.c,v $ */
+/* $Revision: 1.8 $ */
+/* $Date: 2006/12/28 01:27:24 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/asn1/der/utf8/der_encode_utf8_string.c b/crypto/userspace/libtomcrypt/pk/asn1/der/utf8/der_encode_utf8_string.c
new file mode 100644
index 0000000..d1efb09
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/asn1/der/utf8/der_encode_utf8_string.c
@@ -0,0 +1,105 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/**
+  @file der_encode_utf8_string.c
+  ASN.1 DER, encode a UTF8 STRING, Tom St Denis
+*/
+
+
+#ifdef LTC_DER
+
+/**
+  Store an UTF8 STRING
+  @param in       The array of UTF8 to store (one per wchar_t)
+  @param inlen    The number of UTF8 to store
+  @param out      [out] The destination for the DER encoded UTF8 STRING
+  @param outlen   [in/out] The max size and resulting size of the DER UTF8 STRING
+  @return CRYPT_OK if successful
+*/
+int der_encode_utf8_string(const wchar_t *in,  unsigned long inlen,
+                           unsigned char *out, unsigned long *outlen)
+{
+   unsigned long x, y, len;
+
+   LTC_ARGCHK(in     != NULL);
+   LTC_ARGCHK(out    != NULL);
+   LTC_ARGCHK(outlen != NULL);
+
+   /* get the size */
+   for (x = len = 0; x < inlen; x++) {
+       if (in[x] < 0 || in[x] > 0x1FFFF) { 
+          return CRYPT_INVALID_ARG;
+       }
+       len += der_utf8_charsize(in[x]);
+   }
+
+   if (len < 128) {
+      y = 2 + len;
+   } else if (len < 256) {
+      y = 3 + len;
+   } else if (len < 65536UL) {
+      y = 4 + len;
+   } else if (len < 16777216UL) {
+      y = 5 + len;
+   } else {
+      return CRYPT_INVALID_ARG;
+   }
+
+   /* too big? */
+   if (y > *outlen) {
+      *outlen = len;
+      return CRYPT_BUFFER_OVERFLOW;
+   }
+
+   /* encode the header+len */
+   x = 0;
+   out[x++] = 0x0C;
+   if (len < 128) {
+      out[x++] = (unsigned char)len;
+   } else if (len < 256) {
+      out[x++] = 0x81;
+      out[x++] = (unsigned char)len;
+   } else if (len < 65536UL) {
+      out[x++] = 0x82;
+      out[x++] = (unsigned char)((len>>8)&255);
+      out[x++] = (unsigned char)(len&255);
+   } else if (len < 16777216UL) {
+      out[x++] = 0x83;
+      out[x++] = (unsigned char)((len>>16)&255);
+      out[x++] = (unsigned char)((len>>8)&255);
+      out[x++] = (unsigned char)(len&255);
+   } else {
+      return CRYPT_INVALID_ARG;
+   }
+
+   /* store UTF8 */
+   for (y = 0; y < inlen; y++) {
+       switch (der_utf8_charsize(in[y])) {
+          case 1: out[x++] = (unsigned char)in[y]; break;
+          case 2: out[x++] = 0xC0 | ((in[y] >> 6) & 0x1F);  out[x++] = 0x80 | (in[y] & 0x3F); break;
+          case 3: out[x++] = 0xE0 | ((in[y] >> 12) & 0x0F); out[x++] = 0x80 | ((in[y] >> 6) & 0x3F); out[x++] = 0x80 | (in[y] & 0x3F); break;
+          case 4: out[x++] = 0xF0 | ((in[y] >> 18) & 0x07); out[x++] = 0x80 | ((in[y] >> 12) & 0x3F); out[x++] = 0x80 | ((in[y] >> 6) & 0x3F); out[x++] = 0x80 | (in[y] & 0x3F); break;
+       }
+   }
+
+   /* retun length */
+   *outlen = x;
+
+   return CRYPT_OK;
+}
+
+#endif
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/asn1/der/utf8/der_encode_utf8_string.c,v $ */
+/* $Revision: 1.9 $ */
+/* $Date: 2006/12/28 01:27:24 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/asn1/der/utf8/der_length_utf8_string.c b/crypto/userspace/libtomcrypt/pk/asn1/der/utf8/der_length_utf8_string.c
new file mode 100644
index 0000000..920bd00
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/asn1/der/utf8/der_length_utf8_string.c
@@ -0,0 +1,83 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/**
+  @file der_length_utf8_string.c
+  ASN.1 DER, get length of UTF8 STRING, Tom St Denis
+*/
+
+#ifdef LTC_DER
+
+/** Return the size in bytes of a UTF-8 character
+  @param c   The UTF-8 character to measure
+  @return    The size in bytes
+*/
+unsigned long der_utf8_charsize(const wchar_t c)
+{
+   if (c <= 0x7F) {
+      return 1;
+   } else if (c <= 0x7FF) {
+      return 2;
+   } else if (c <= 0xFFFF) {
+      return 3;
+   } else {
+      return 4;
+   }
+}
+
+/**
+  Gets length of DER encoding of UTF8 STRING 
+  @param in       The characters to measure the length of
+  @param noctets  The number of octets in the string to encode
+  @param outlen   [out] The length of the DER encoding for the given string
+  @return CRYPT_OK if successful
+*/
+int der_length_utf8_string(const wchar_t *in, unsigned long noctets, unsigned long *outlen)
+{
+   unsigned long x, len;
+
+   LTC_ARGCHK(in     != NULL);
+   LTC_ARGCHK(outlen != NULL);
+
+   len = 0;
+   for (x = 0; x < noctets; x++) {
+      if (in[x] < 0 || in[x] > 0x10FFFF) {
+         return CRYPT_INVALID_ARG;
+      }
+      len += der_utf8_charsize(in[x]);
+   }
+
+   if (len < 128) {
+      /* 0C LL DD DD DD ... */
+      *outlen = 2 + len;
+   } else if (len < 256) {
+      /* 0C 81 LL DD DD DD ... */
+      *outlen = 3 + len;
+   } else if (len < 65536UL) {
+      /* 0C 82 LL LL DD DD DD ... */
+      *outlen = 4 + len;
+   } else if (len < 16777216UL) {
+      /* 0C 83 LL LL LL DD DD DD ... */
+      *outlen = 5 + len;
+   } else {
+      return CRYPT_INVALID_ARG;
+   }
+
+   return CRYPT_OK;
+}
+
+#endif
+
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/asn1/der/utf8/der_length_utf8_string.c,v $ */
+/* $Revision: 1.6 $ */
+/* $Date: 2006/12/28 01:27:24 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/asn1/der/x509/der_decode_subject_public_key_info.c b/crypto/userspace/libtomcrypt/pk/asn1/der/x509/der_decode_subject_public_key_info.c
new file mode 100644
index 0000000..8a5005f
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/asn1/der/x509/der_decode_subject_public_key_info.c
@@ -0,0 +1,112 @@
+/*
+ * New driver for /dev/crypto device (aka CryptoDev)
+
+ * Copyright (c) 2010 Katholieke Universiteit Leuven
+ *
+ * Author: Nikos Mavrogiannopoulos <nmav@gnutls.org>
+ *
+ * This file is part of linux cryptodev.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ * 
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ * 
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#include "tomcrypt.h"
+#include <linux/slab.h>
+/**
+  @file der_encode_sequence_multi.c
+  ASN.1 DER, encode a Subject Public Key structure --nmav
+*/
+
+#ifdef LTC_DER
+
+/* AlgorithmIdentifier := SEQUENCE {
+ *    algorithm OBJECT IDENTIFIER,
+ *    parameters ANY DEFINED BY algorithm
+ * }
+ * 
+ * SubjectPublicKeyInfo := SEQUENCE {
+ *    algorithm AlgorithmIdentifier,
+ *    subjectPublicKey BIT STRING
+ * }
+ */
+/**
+  Encode a SEQUENCE type using a VA list
+  @param out    [out] Destination for data
+  @param outlen [in/out] Length of buffer and resulting length of output
+  @remark <...> is of the form <type, size, data> (int, unsigned long, void*)
+  @return CRYPT_OK on success
+*/  
+int der_decode_subject_public_key_info(const unsigned char *in, unsigned long inlen,
+        unsigned int algorithm, void* public_key, unsigned long* public_key_len,
+        unsigned long parameters_type, ltc_asn1_list* parameters, unsigned long parameters_len)
+{
+   int err, len;
+   oid_st oid;
+   unsigned char *tmpbuf;
+   unsigned long  tmpoid[16];
+   ltc_asn1_list alg_id[2];
+   ltc_asn1_list subject_pubkey[2];
+
+   LTC_ARGCHK(in    != NULL);
+   LTC_ARGCHK(inlen != 0);
+
+   err = pk_get_oid(algorithm, &oid);
+   if (err != CRYPT_OK) {
+        return err;
+   }
+
+   /* see if the OpenSSL DER format RSA public key will work */
+   tmpbuf = XCALLOC(1, MAX_RSA_SIZE*8);
+   if (tmpbuf == NULL) {
+       err = CRYPT_MEM;
+       goto LBL_ERR;
+   }
+
+   /* this includes the internal hash ID and optional params (NULL in this case) */
+   LTC_SET_ASN1(alg_id, 0, LTC_ASN1_OBJECT_IDENTIFIER, tmpoid, sizeof(tmpoid)/sizeof(tmpoid[0]));   
+   LTC_SET_ASN1(alg_id, 1, parameters_type, parameters, parameters_len);
+
+   /* the actual format of the SSL DER key is odd, it stores a RSAPublicKey in a **BIT** string ... so we have to extract it
+      then proceed to convert bit to octet 
+    */
+   LTC_SET_ASN1(subject_pubkey, 0, LTC_ASN1_SEQUENCE, alg_id, 2);
+   LTC_SET_ASN1(subject_pubkey, 1, LTC_ASN1_BIT_STRING, tmpbuf, MAX_RSA_SIZE*8);
+
+   err=der_decode_sequence(in, inlen, subject_pubkey, 2UL);
+   if (err != CRYPT_OK) {
+           goto LBL_ERR;
+   }
+
+   len = subject_pubkey[1].size/8;
+   if (*public_key_len > len) {
+       memcpy(public_key, subject_pubkey[1].data, len);
+       *public_key_len = len;
+    } else {
+        *public_key_len = len;
+        err = CRYPT_BUFFER_OVERFLOW;
+        goto LBL_ERR;
+    }
+
+    err = CRYPT_OK;
+    
+LBL_ERR:
+
+    XFREE(tmpbuf);
+        
+    return err;
+}
+
+#endif
+
+
diff --git a/crypto/userspace/libtomcrypt/pk/asn1/der/x509/der_encode_subject_public_key_info.c b/crypto/userspace/libtomcrypt/pk/asn1/der/x509/der_encode_subject_public_key_info.c
new file mode 100644
index 0000000..4c7e966
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/asn1/der/x509/der_encode_subject_public_key_info.c
@@ -0,0 +1,83 @@
+/*
+ * New driver for /dev/crypto device (aka CryptoDev)
+
+ * Copyright (c) 2010 Katholieke Universiteit Leuven
+ *
+ * Author: Nikos Mavrogiannopoulos <nmav@gnutls.org>
+ *
+ * This file is part of linux cryptodev.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ * 
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ * 
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#include "tomcrypt.h"
+
+/**
+  @file der_encode_sequence_multi.c
+  ASN.1 DER, encode a Subject Public Key structure --nmav
+*/
+
+#ifdef LTC_DER
+
+/* AlgorithmIdentifier := SEQUENCE {
+ *    algorithm OBJECT IDENTIFIER,
+ *    parameters ANY DEFINED BY algorithm
+ * }
+ * 
+ * SubjectPublicKeyInfo := SEQUENCE {
+ *    algorithm AlgorithmIdentifier,
+ *    subjectPublicKey BIT STRING
+ * }
+ */
+/**
+  Encode a SEQUENCE type using a VA list
+  @param out    [out] Destination for data
+  @param outlen [in/out] Length of buffer and resulting length of output
+  @remark <...> is of the form <type, size, data> (int, unsigned long, void*)
+  @return CRYPT_OK on success
+*/  
+int der_encode_subject_public_key_info(unsigned char *out, unsigned long *outlen, 
+        unsigned int algorithm, void* public_key, unsigned long public_key_len, 
+        unsigned long parameters_type, void* parameters, unsigned long parameters_len)
+{
+   int           err;
+   ltc_asn1_list alg_id[2];
+   oid_st oid;
+
+   LTC_ARGCHK(out    != NULL);
+   LTC_ARGCHK(outlen != NULL);
+   
+   err = pk_get_oid(algorithm, &oid);
+   if (err != CRYPT_OK) {
+        return err;
+   }
+
+   alg_id[0].data = oid.OID;
+   alg_id[0].size = oid.OIDlen;
+   alg_id[0].type = LTC_ASN1_OBJECT_IDENTIFIER;
+
+   alg_id[1].data = parameters;
+   alg_id[1].size = parameters_len;
+   alg_id[1].type = parameters_type;
+
+   return der_encode_sequence_multi(out, outlen, 
+        LTC_ASN1_SEQUENCE, (unsigned long)sizeof(alg_id)/sizeof(alg_id[0]), alg_id, 
+        LTC_ASN1_BIT_STRING, (unsigned long)(public_key_len*8), public_key,
+        LTC_ASN1_EOL,     0UL, NULL);
+
+}
+
+#endif
+
+
diff --git a/crypto/userspace/libtomcrypt/pk/dsa/dsa_export.c b/crypto/userspace/libtomcrypt/pk/dsa/dsa_export.c
new file mode 100644
index 0000000..f2cd714
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/dsa/dsa_export.c
@@ -0,0 +1,99 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+#include <linux/slab.h>
+
+/**
+   @file dsa_export.c
+   DSA implementation, export key, Tom St Denis
+*/
+
+#ifdef LTC_MDSA
+
+/**
+  Export a DSA key to a binary packet
+  @param out    [out] Where to store the packet
+  @param outlen [in/out] The max size and resulting size of the packet
+  @param type   The type of key to export (PK_PRIVATE or PK_PUBLIC)
+  @param key    The key to export
+  @return CRYPT_OK if successful
+*/
+int dsa_export(unsigned char *out, unsigned long *outlen, int type, dsa_key *key)
+{
+   unsigned long zero=0;
+   int err;
+
+   LTC_ARGCHK(out    != NULL);
+   LTC_ARGCHK(outlen != NULL);
+   LTC_ARGCHK(key    != NULL);
+
+   /* can we store the static header?  */
+   if (type == PK_PRIVATE && key->type != PK_PRIVATE) {
+      return CRYPT_PK_TYPE_MISMATCH;
+   }
+
+   if (type != PK_PUBLIC && type != PK_PRIVATE) {
+      return CRYPT_INVALID_ARG;
+   }
+
+   /* This encoding is different from the one in original
+    * libtomcrypt. It uses a compatible encoding with gnutls
+    * and openssl 
+    */
+   if (type == PK_PRIVATE) {
+      return der_encode_sequence_multi(out, outlen,
+                          LTC_ASN1_SHORT_INTEGER, 1UL, &zero, 
+                          LTC_ASN1_INTEGER,      1UL, &key->p,
+                          LTC_ASN1_INTEGER,      1UL, &key->q,
+                          LTC_ASN1_INTEGER,      1UL, &key->g,
+                          LTC_ASN1_INTEGER,      1UL, &key->y,
+                          LTC_ASN1_INTEGER,      1UL, &key->x,
+                          LTC_ASN1_EOL,          0UL, NULL);
+   } else {
+      unsigned long tmplen = (mp_count_bits(&key->y)/8)+8;
+      unsigned char* tmp = XMALLOC(tmplen);
+      ltc_asn1_list int_list[3];
+   
+      if (tmp == NULL) {
+	   return CRYPT_MEM;
+      }
+      
+      err = der_encode_integer(&key->y, tmp, &tmplen);
+      if (err != CRYPT_OK) {
+		  goto error;
+      }
+
+      int_list[0].data = &key->p;
+      int_list[0].size = 1UL;
+      int_list[0].type = LTC_ASN1_INTEGER;
+      int_list[1].data = &key->q;
+      int_list[1].size = 1UL;
+      int_list[1].type = LTC_ASN1_INTEGER;
+      int_list[2].data = &key->g;
+      int_list[2].size = 1UL;
+      int_list[2].type = LTC_ASN1_INTEGER;
+
+      err = der_encode_subject_public_key_info(out, outlen, 
+        PKA_DSA, tmp, tmplen, 
+        LTC_ASN1_SEQUENCE, int_list, sizeof(int_list)/sizeof(int_list[0]));
+      
+error:
+      XFREE(tmp);
+      return err;
+   }
+}
+
+#endif
+
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/dsa/dsa_export.c,v $ */
+/* $Revision: 1.10 $ */
+/* $Date: 2007/05/12 14:32:35 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/dsa/dsa_free.c b/crypto/userspace/libtomcrypt/pk/dsa/dsa_free.c
new file mode 100644
index 0000000..37a330d
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/dsa/dsa_free.c
@@ -0,0 +1,34 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/**
+   @file dsa_free.c
+   DSA implementation, free a DSA key, Tom St Denis
+*/
+
+#ifdef LTC_MDSA
+
+/**
+   Free a DSA key
+   @param key   The key to free from memory
+*/
+void dsa_free(dsa_key *key)
+{
+   LTC_ARGCHKVD(key != NULL);
+   mp_clear_multi(&key->g, &key->q, &key->p, &key->x, &key->y, NULL);
+}
+
+#endif
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/dsa/dsa_free.c,v $ */
+/* $Revision: 1.8 $ */
+/* $Date: 2007/05/12 14:32:35 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/dsa/dsa_import.c b/crypto/userspace/libtomcrypt/pk/dsa/dsa_import.c
new file mode 100644
index 0000000..99001f2
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/dsa/dsa_import.c
@@ -0,0 +1,101 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+#include <linux/slab.h>
+
+/**
+   @file dsa_import.c
+   DSA implementation, import a DSA key, Tom St Denis
+*/
+
+#ifdef LTC_MDSA
+
+/**
+   Import a DSA key 
+   @param in       The binary packet to import from
+   @param inlen    The length of the binary packet
+   @param key      [out] Where to store the imported key
+   @return CRYPT_OK if successful, upon error this function will free all allocated memory
+*/
+int dsa_import(const unsigned char *in, unsigned long inlen, dsa_key *key)
+{
+   int           err;
+   unsigned long zero = 0;
+   unsigned char* tmpbuf = NULL;
+
+   LTC_ARGCHK(in  != NULL);
+   LTC_ARGCHK(key != NULL);
+
+   /* init key */
+   if (mp_init_multi(&key->p, &key->g, &key->q, &key->x, &key->y, NULL) != CRYPT_OK) {
+      return CRYPT_MEM;
+   }
+
+   /* get key type */
+   if ((err = der_decode_sequence_multi(in, inlen,
+                          LTC_ASN1_SHORT_INTEGER, 1UL, &zero, 
+                          LTC_ASN1_INTEGER,      1UL, &key->p,
+                          LTC_ASN1_INTEGER,      1UL, &key->q,
+                          LTC_ASN1_INTEGER,      1UL, &key->g,
+                          LTC_ASN1_INTEGER,      1UL, &key->y,
+                          LTC_ASN1_INTEGER,      1UL, &key->x,
+                          LTC_ASN1_EOL,          0UL, NULL)) == CRYPT_OK) {
+      key->type = PK_PRIVATE;
+   } else { /* public */
+      ltc_asn1_list params[3];
+      unsigned long tmpbuf_len = MAX_RSA_SIZE*8;
+
+      LTC_SET_ASN1(params, 0, LTC_ASN1_INTEGER, &key->p, 1UL);   
+      LTC_SET_ASN1(params, 1, LTC_ASN1_INTEGER, &key->q, 1UL);
+      LTC_SET_ASN1(params, 2, LTC_ASN1_INTEGER, &key->g, 1UL);
+
+      tmpbuf = XCALLOC(1, tmpbuf_len);
+      if (tmpbuf == NULL) {
+          err = CRYPT_MEM;
+          goto LBL_ERR;
+      }
+
+      err = der_decode_subject_public_key_info(in, inlen,
+        PKA_DSA, tmpbuf, &tmpbuf_len,
+        LTC_ASN1_SEQUENCE, params, 3);
+      if (err != CRYPT_OK) {
+         goto LBL_ERR;
+      }
+
+      if ((err=der_decode_integer(tmpbuf, tmpbuf_len, &key->y)) != CRYPT_OK) {
+         goto LBL_ERR;
+      }
+      
+      XFREE(tmpbuf);
+      key->type = PK_PUBLIC;
+  }
+
+  key->qord = mp_unsigned_bin_size(&key->q);
+
+  if (key->qord >= LTC_MDSA_MAX_GROUP || key->qord <= 15 ||
+      (unsigned long)key->qord >= mp_unsigned_bin_size(&key->p) || (mp_unsigned_bin_size(&key->p) - key->qord) >= LTC_MDSA_DELTA) {
+      err = CRYPT_INVALID_PACKET;
+      goto LBL_ERR;
+   }
+
+  return CRYPT_OK;
+
+LBL_ERR:
+   XFREE(tmpbuf);
+   mp_clear_multi(&key->p, &key->g, &key->q, &key->x, &key->y, NULL);
+   return err;
+}
+
+#endif
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/dsa/dsa_import.c,v $ */
+/* $Revision: 1.14 $ */
+/* $Date: 2007/05/12 14:32:35 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/dsa/dsa_make_key.c b/crypto/userspace/libtomcrypt/pk/dsa/dsa_make_key.c
new file mode 100644
index 0000000..1831853
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/dsa/dsa_make_key.c
@@ -0,0 +1,125 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+#include <linux/slab.h>
+
+/**
+   @file dsa_make_key.c
+   DSA implementation, generate a DSA key, Tom St Denis
+*/
+
+#ifdef LTC_MDSA
+
+/**
+  Create a DSA key
+  @param group_size    Size of the multiplicative group (octets)
+  @param modulus_size  Size of the modulus (octets)
+  @param key           [out] Where to store the created key
+  @return CRYPT_OK if successful, upon error this function will free all allocated memory
+*/
+int dsa_make_key(int group_size, int modulus_size, dsa_key *key)
+{
+   mp_int         tmp, tmp2;
+   int            err, res;
+   unsigned char *buf;
+
+   LTC_ARGCHK(key  != NULL);
+
+   /* check size */
+   if (group_size >= LTC_MDSA_MAX_GROUP || group_size <= 15 || 
+       group_size >= modulus_size || (modulus_size - group_size) >= LTC_MDSA_DELTA) {
+      return CRYPT_INVALID_ARG;
+   }
+
+   /* allocate ram */
+   buf = XMALLOC(LTC_MDSA_DELTA);
+   if (buf == NULL) {
+      return CRYPT_MEM;
+   }
+
+   /* init mp_ints  */
+   if ((err = mp_init_multi(&tmp, &tmp2, &key->g, &key->q, &key->p, &key->x, &key->y, NULL)) != CRYPT_OK) {
+      XFREE(buf);
+      return err;
+   }
+
+   /* make our prime q */
+   if ((err = rand_prime(&key->q, group_size)) != CRYPT_OK)                { goto error; }
+
+   /* double q  */
+   if ((err = mp_add(&key->q, &key->q, &tmp)) != CRYPT_OK)                                { goto error; }
+
+   /* now make a random string and multply it against q */
+   get_random_bytes(buf+1, modulus_size - group_size);
+
+   /* force magnitude */
+   buf[0] |= 0xC0;
+
+   /* force even */
+   buf[modulus_size - group_size - 1] &= ~1;
+
+   if ((err = mp_read_unsigned_bin(&tmp2, buf, modulus_size - group_size)) != CRYPT_OK) { goto error; }
+   if ((err = mp_mul(&key->q, &tmp2, &key->p)) != CRYPT_OK)                               { goto error; }
+   if ((err = mp_add_d(&key->p, 1, &key->p)) != CRYPT_OK)                                { goto error; }
+
+   /* now loop until p is prime */
+   for (;;) {
+       if ((err = mp_prime_is_prime(&key->p, 8, &res)) != CRYPT_OK)                     { goto error; }
+       if (res == LTC_MP_YES) break;
+
+       /* add 2q to p and 2 to tmp2 */
+       if ((err = mp_add(&tmp, &key->p, &key->p)) != CRYPT_OK)                            { goto error; }
+       if ((err = mp_add_d(&tmp2, 2, &tmp2)) != CRYPT_OK)                                { goto error; }
+   }
+
+   /* now p = (q * tmp2) + 1 is prime, find a value g for which g^tmp2 != 1 */
+   mp_set(&key->g, 1);
+
+   do {
+      if ((err = mp_add_d(&key->g, 1, &key->g)) != CRYPT_OK)                             { goto error; }
+      if ((err = mp_exptmod(&key->g, &tmp2, &key->p, &tmp)) != CRYPT_OK)                   { goto error; }
+   } while (mp_cmp_d(&tmp, 1) == LTC_MP_EQ);
+
+   /* at this point tmp generates a group of order q mod p */
+   mp_exch(&tmp, &key->g);
+
+   /* so now we have our DH structure, generator g, order q, modulus p 
+      Now we need a random exponent [mod q] and it's power g^x mod p 
+    */
+   do {
+      get_random_bytes(buf, group_size);
+
+      if ((err = mp_read_unsigned_bin(&key->x, buf, group_size)) != CRYPT_OK)           { goto error; }
+   } while (mp_cmp_d(&key->x, 1) != LTC_MP_GT);
+   if ((err = mp_exptmod(&key->g, &key->x, &key->p, &key->y)) != CRYPT_OK)                 { goto error; }
+  
+   key->type = PK_PRIVATE;
+   key->qord = group_size;
+
+#ifdef LTC_CLEAN_STACK
+   zeromem(buf, LTC_MDSA_DELTA);
+#endif
+
+   err = CRYPT_OK;
+   goto done;
+error: 
+    mp_clear_multi(&key->g, &key->q, &key->p, &key->x, &key->y, NULL);
+done: 
+    mp_clear_multi(&tmp, &tmp2, NULL);
+    XFREE(buf);
+    return err;
+}
+
+#endif
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/dsa/dsa_make_key.c,v $ */
+/* $Revision: 1.12 $ */
+/* $Date: 2007/05/12 14:32:35 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/dsa/dsa_sign_hash.c b/crypto/userspace/libtomcrypt/pk/dsa/dsa_sign_hash.c
new file mode 100644
index 0000000..b48d5a5
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/dsa/dsa_sign_hash.c
@@ -0,0 +1,147 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+#include <linux/slab.h>
+
+/**
+   @file dsa_sign_hash.c
+   DSA implementation, sign a hash, Tom St Denis
+*/
+
+#ifdef LTC_MDSA
+
+/**
+  Sign a hash with DSA
+  @param in       The hash to sign
+  @param inlen    The length of the hash to sign
+  @param r        The "r" integer of the signature (caller must initialize with mp_init() first)
+  @param s        The "s" integer of the signature (caller must initialize with mp_init() first)
+  @param key      A private DSA key
+  @return CRYPT_OK if successful
+*/
+int dsa_sign_hash_raw(const unsigned char *in,  unsigned long inlen,
+                                   mp_int_t r,   mp_int_t s,
+                               dsa_key *key)
+{
+   mp_int         k, kinv, tmp;
+   unsigned char *buf;
+   int            err;
+
+   LTC_ARGCHK(in  != NULL);
+   LTC_ARGCHK(r   != NULL);
+   LTC_ARGCHK(s   != NULL);
+   LTC_ARGCHK(key != NULL);
+
+   if (key->type != PK_PRIVATE) {
+      return CRYPT_PK_NOT_PRIVATE;
+   }
+
+   /* check group order size  */
+   if (key->qord >= LTC_MDSA_MAX_GROUP) {
+      return CRYPT_INVALID_ARG;
+   }
+
+   buf = XMALLOC(LTC_MDSA_MAX_GROUP);
+   if (buf == NULL) {
+      return CRYPT_MEM;
+   }
+
+   /* Init our temps */
+   if ((err = mp_init_multi(&k, &kinv, &tmp, NULL)) != CRYPT_OK)                       { goto ERRBUF; }
+
+retry:
+
+   do {
+      /* gen random k */
+      get_random_bytes(buf, key->qord);
+
+      /* read k */
+      if ((err = mp_read_unsigned_bin(&k, buf, key->qord)) != CRYPT_OK)                 { goto error; }
+
+      /* k > 1 ? */
+      if (mp_cmp_d(&k, 1) != LTC_MP_GT)                                                 { goto retry; }
+
+      /* test gcd */
+      if ((err = mp_gcd(&k, &key->q, &tmp)) != CRYPT_OK)                                  { goto error; }
+   } while (mp_cmp_d(&tmp, 1) != LTC_MP_EQ);
+
+   /* now find 1/k mod q */
+   if ((err = mp_invmod(&k, &key->q, &kinv)) != CRYPT_OK)                                 { goto error; }
+
+   /* now find r = g^k mod p mod q */
+   if ((err = mp_exptmod(&key->g, &k, &key->p, r)) != CRYPT_OK)                           { goto error; }
+   if ((err = mp_mod(r, &key->q, r)) != CRYPT_OK)                                       { goto error; }
+
+   if (mp_iszero(r) == LTC_MP_YES)                                                     { goto retry; }
+
+   /* now find s = (in + xr)/k mod q */
+   if ((err = mp_read_unsigned_bin(&tmp, (unsigned char *)in, inlen)) != CRYPT_OK)      { goto error; }
+   if ((err = mp_mul(&key->x, r, s)) != CRYPT_OK)                                       { goto error; }
+   if ((err = mp_add(s, &tmp, s)) != CRYPT_OK)                                          { goto error; }
+   if ((err = mp_mulmod(s, &kinv, &key->q, s)) != CRYPT_OK)                              { goto error; }
+
+   if (mp_iszero(s) == LTC_MP_YES)                                                     { goto retry; }
+
+   err = CRYPT_OK;
+error: 
+   mp_clear_multi(&k, &kinv, &tmp, NULL);
+ERRBUF:
+#ifdef LTC_CLEAN_STACK
+   zeromem(buf, LTC_MDSA_MAX_GROUP);
+#endif
+   XFREE(buf);
+   return err;
+}
+
+/**
+  Sign a hash with DSA
+  @param in       The hash to sign
+  @param inlen    The length of the hash to sign
+  @param out      [out] Where to store the signature
+  @param outlen   [in/out] The max size and resulting size of the signature
+  @param key      A private DSA key
+  @return CRYPT_OK if successful
+*/
+int dsa_sign_hash(const unsigned char *in,  unsigned long inlen,
+                        unsigned char *out, unsigned long *outlen,
+                        dsa_key *key)
+{
+   mp_int        r, s;
+   int           err;
+
+   LTC_ARGCHK(in      != NULL);
+   LTC_ARGCHK(out     != NULL);
+   LTC_ARGCHK(outlen  != NULL);
+   LTC_ARGCHK(key     != NULL);
+
+   if (mp_init_multi(&r, &s, NULL) != CRYPT_OK) {
+      return CRYPT_MEM;
+   }
+
+   if ((err = dsa_sign_hash_raw(in, inlen, &r, &s, key)) != CRYPT_OK) {
+      goto error;
+   }
+
+   err = der_encode_sequence_multi(out, outlen, 
+                             LTC_ASN1_INTEGER, 1UL, &r, 
+                             LTC_ASN1_INTEGER, 1UL, &s, 
+                             LTC_ASN1_EOL,     0UL, NULL);
+
+error:
+   mp_clear_multi(&r, &s, NULL);
+   return err;
+}
+
+#endif
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/dsa/dsa_sign_hash.c,v $ */
+/* $Revision: 1.14 $ */
+/* $Date: 2007/05/12 14:32:35 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/dsa/dsa_verify_hash.c b/crypto/userspace/libtomcrypt/pk/dsa/dsa_verify_hash.c
new file mode 100644
index 0000000..3a82d1b
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/dsa/dsa_verify_hash.c
@@ -0,0 +1,126 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/**
+   @file dsa_verify_hash.c
+   DSA implementation, verify a signature, Tom St Denis
+*/
+
+
+#ifdef LTC_MDSA
+
+/**
+  Verify a DSA signature
+  @param r        DSA "r" parameter
+  @param s        DSA "s" parameter
+  @param hash     The hash that was signed
+  @param hashlen  The length of the hash that was signed
+  @param stat     [out] The result of the signature verification, 1==valid, 0==invalid
+  @param key      The corresponding public DH key
+  @return CRYPT_OK if successful (even if the signature is invalid)
+*/
+int dsa_verify_hash_raw(         mp_int_t r,          mp_int_t s,
+                    const unsigned char *hash, unsigned long hashlen, 
+                                    int *stat,      dsa_key *key)
+{
+   mp_int        w, v, u1, u2;
+   int           err;
+
+   LTC_ARGCHK(r    != NULL);
+   LTC_ARGCHK(s    != NULL);
+   LTC_ARGCHK(stat != NULL);
+   LTC_ARGCHK(key  != NULL);
+
+   /* default to invalid signature */
+   *stat = 0;
+
+   /* init our variables */
+   if ((err = mp_init_multi(&w, &v, &u1, &u2, NULL)) != CRYPT_OK) {
+      return err;
+   }
+
+   /* neither r or s can be null or >q*/
+   if (mp_iszero(r) == LTC_MP_YES || mp_iszero(s) == LTC_MP_YES || mp_cmp(r, &key->q) != LTC_MP_LT || mp_cmp(s, &key->q) != LTC_MP_LT) {
+      err = CRYPT_INVALID_PACKET;
+      goto error;
+   }
+   
+   /* w = 1/s mod q */
+   if ((err = mp_invmod(s, &key->q, &w)) != CRYPT_OK)                                       { goto error; }
+
+   /* u1 = m * w mod q */
+   if ((err = mp_read_unsigned_bin(&u1, (unsigned char *)hash, hashlen)) != CRYPT_OK)      { goto error; }
+   if ((err = mp_mulmod(&u1, &w, &key->q, &u1)) != CRYPT_OK)                                  { goto error; }
+
+   /* u2 = r*w mod q */
+   if ((err = mp_mulmod(r, &w, &key->q, &u2)) != CRYPT_OK)                                   { goto error; } 
+
+   /* v = g^u1 * y^u2 mod p mod q */
+   if ((err = mp_exptmod(&key->g, &u1, &key->p, &u1)) != CRYPT_OK)                            { goto error; }
+   if ((err = mp_exptmod(&key->y, &u2, &key->p, &u2)) != CRYPT_OK)                            { goto error; }
+   if ((err = mp_mulmod(&u1, &u2, &key->p, &v)) != CRYPT_OK)                                  { goto error; }
+   if ((err = mp_mod(&v, &key->q, &v)) != CRYPT_OK)                                          { goto error; }
+
+   /* if r = v then we're set */
+   if (mp_cmp(r, &v) == LTC_MP_EQ) {
+      *stat = 1;
+   }
+
+   err = CRYPT_OK;
+error:
+   mp_clear_multi(&w, &v, &u1, &u2, NULL);
+   return err;
+}
+
+/**
+  Verify a DSA signature
+  @param sig      The signature
+  @param siglen   The length of the signature (octets)
+  @param hash     The hash that was signed
+  @param hashlen  The length of the hash that was signed
+  @param stat     [out] The result of the signature verification, 1==valid, 0==invalid
+  @param key      The corresponding public DH key
+  @return CRYPT_OK if successful (even if the signature is invalid)
+*/
+int dsa_verify_hash(const unsigned char *sig, unsigned long siglen,
+                    const unsigned char *hash, unsigned long hashlen, 
+                    int *stat, dsa_key *key)
+{
+   int    err;
+   mp_int r, s;
+
+   if ((err = mp_init_multi(&r, &s, NULL)) != CRYPT_OK) {
+      return CRYPT_MEM;
+   }
+
+   /* decode the sequence */
+   if ((err = der_decode_sequence_multi(sig, siglen,
+                                  LTC_ASN1_INTEGER, 1UL, &r, 
+                                  LTC_ASN1_INTEGER, 1UL, &s, 
+                                  LTC_ASN1_EOL,     0UL, NULL)) != CRYPT_OK) {
+      goto LBL_ERR;
+   }
+
+   /* do the op */
+   err = dsa_verify_hash_raw(&r, &s, hash, hashlen, stat, key);
+
+LBL_ERR:
+   mp_clear_multi(&r, &s, NULL);
+   return err;
+}
+
+#endif
+
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/dsa/dsa_verify_hash.c,v $ */
+/* $Revision: 1.15 $ */
+/* $Date: 2007/05/12 14:32:35 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/dsa/dsa_verify_key.c b/crypto/userspace/libtomcrypt/pk/dsa/dsa_verify_key.c
new file mode 100644
index 0000000..71635d2
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/dsa/dsa_verify_key.c
@@ -0,0 +1,100 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/**
+   @file dsa_verify_key.c
+   DSA implementation, verify a key, Tom St Denis
+*/
+
+#ifdef LTC_MDSA
+
+/**
+   Verify a DSA key for validity
+   @param key   The key to verify
+   @param stat  [out]  Result of test, 1==valid, 0==invalid
+   @return CRYPT_OK if successful
+*/
+int dsa_verify_key(dsa_key *key, int *stat)
+{
+   mp_int tmp, tmp2;
+   int    res, err;
+
+   LTC_ARGCHK(key  != NULL);
+   LTC_ARGCHK(stat != NULL);
+
+   /* default to an invalid key */
+   *stat = 0;
+
+   /* first make sure key->q and key->p are prime */
+   if ((err = mp_prime_is_prime(&key->q, 8, &res)) != CRYPT_OK) {
+      return err;
+   }
+   if (res == 0) {
+      return CRYPT_OK;
+   }
+
+   if ((err = mp_prime_is_prime(&key->p, 8, &res)) != CRYPT_OK) {
+      return err;
+   }
+   if (res == 0) {
+      return CRYPT_OK;
+   }
+
+   /* now make sure that g is not -1, 0 or 1 and <p */
+   if (mp_cmp_d(&key->g, 0) == LTC_MP_EQ || mp_cmp_d(&key->g, 1) == LTC_MP_EQ) {
+      return CRYPT_OK;
+   }
+   if ((err = mp_init_multi(&tmp, &tmp2, NULL)) != CRYPT_OK)               { return err; }
+   if ((err = mp_sub_d(&key->p, 1, &tmp)) != CRYPT_OK)                       { goto error; }
+   if (mp_cmp(&tmp, &key->g) == LTC_MP_EQ || mp_cmp(&key->g, &key->p) != LTC_MP_LT) {
+      err = CRYPT_OK;
+      goto error;
+   }
+
+   /* 1 < y < p-1 */
+   if (!(mp_cmp_d(&key->y, 1) == LTC_MP_GT && mp_cmp(&key->y, &tmp) == LTC_MP_LT)) {
+      err = CRYPT_OK;
+      goto error;
+   }
+
+   /* now we have to make sure that g^q = 1, and that p-1/q gives 0 remainder */
+   if ((err = mp_div(&tmp, &key->q, &tmp, &tmp2)) != CRYPT_OK)             { goto error; }
+   if (mp_iszero(&tmp2) != LTC_MP_YES) {
+      err = CRYPT_OK;
+      goto error;
+   }
+
+   if ((err = mp_exptmod(&key->g, &key->q, &key->p, &tmp)) != CRYPT_OK)    { goto error; }
+   if (mp_cmp_d(&tmp, 1) != LTC_MP_EQ) {
+      err = CRYPT_OK;
+      goto error;
+   }
+
+   /* now we have to make sure that y^q = 1, this makes sure y \in g^x mod p */
+   if ((err = mp_exptmod(&key->y, &key->q, &key->p, &tmp)) != CRYPT_OK)       { goto error; }
+   if (mp_cmp_d(&tmp, 1) != LTC_MP_EQ) {
+      err = CRYPT_OK;
+      goto error;
+   }
+
+   /* at this point we are out of tests ;-( */
+   err   = CRYPT_OK;
+   *stat = 1;
+error: 
+   mp_clear_multi(&tmp, &tmp2, NULL);
+   return err;
+}
+#endif
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/dsa/dsa_verify_key.c,v $ */
+/* $Revision: 1.8 $ */
+/* $Date: 2007/05/12 14:32:35 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/pkcs1/pkcs_1_i2osp.c b/crypto/userspace/libtomcrypt/pk/pkcs1/pkcs_1_i2osp.c
new file mode 100644
index 0000000..70294a5
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/pkcs1/pkcs_1_i2osp.c
@@ -0,0 +1,51 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/** 
+  @file pkcs_1_i2osp.c
+  Integer to Octet I2OSP, Tom St Denis 
+*/
+
+#ifdef LTC_PKCS_1
+
+/* always stores the same # of bytes, pads with leading zero bytes
+   as required
+ */
+
+/**
+   LTC_PKCS #1 Integer to binary
+   @param n             The integer to store
+   @param modulus_len   The length of the RSA modulus
+   @param out           [out] The destination for the integer
+   @return CRYPT_OK if successful
+*/
+int pkcs_1_i2osp(void *n, unsigned long modulus_len, unsigned char *out)
+{
+   unsigned long size;
+
+   size = mp_unsigned_bin_size(n);
+
+   if (size > modulus_len) {
+      return CRYPT_BUFFER_OVERFLOW;
+   }
+
+   /* store it */
+   zeromem(out, modulus_len);
+   return mp_to_unsigned_bin(n, out+(modulus_len-size));
+}
+
+#endif /* LTC_PKCS_1 */
+
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/pkcs1/pkcs_1_i2osp.c,v $ */
+/* $Revision: 1.7 $ */
+/* $Date: 2007/05/12 14:32:35 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/pkcs1/pkcs_1_mgf1.c b/crypto/userspace/libtomcrypt/pk/pkcs1/pkcs_1_mgf1.c
new file mode 100644
index 0000000..86ba218
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/pkcs1/pkcs_1_mgf1.c
@@ -0,0 +1,91 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+#include <ncr-int.h>
+#include <linux/slab.h>
+
+/**
+  @file pkcs_1_mgf1.c
+  The Mask Generation Function (MGF1) for LTC_PKCS #1, Tom St Denis 
+*/
+
+#ifdef LTC_PKCS_1
+
+/**
+   Perform LTC_PKCS #1 MGF1 (internal)
+   @param seed        The seed for MGF1
+   @param seedlen     The length of the seed
+   @param hash        The desired hash
+   @param mask        [out] The destination
+   @param masklen     The length of the mask desired
+   @return CRYPT_OK if successful
+*/
+int pkcs_1_mgf1(const struct algo_properties_st *hash,
+                const unsigned char *seed, unsigned long seedlen,
+                      unsigned char *mask, unsigned long masklen)
+{
+   unsigned long hLen, x;
+   ulong32       counter;
+   int           err;
+   unsigned char *buf;
+ 
+   LTC_ARGCHK(seed != NULL);
+   LTC_ARGCHK(mask != NULL);
+
+   /* ensure valid hash */
+   if ((err = hash_is_valid(hash)) != CRYPT_OK) {
+      return err;
+   }
+
+   /* get hash output size */
+   hLen = hash->digest_size;
+
+   /* allocate memory */
+   buf = XMALLOC(hLen);
+   if (buf == NULL) {
+      return CRYPT_MEM;
+   }
+
+   /* start counter */
+   counter = 0;
+
+   while (masklen > 0) {
+       /* handle counter */
+       STORE32H(counter, buf);
+       ++counter;
+
+       err = hash_memory_multi(hash, buf, &hLen, seed, seedlen, buf, (unsigned long) 4, NULL, 0);
+       if (err != CRYPT_OK) {
+          goto LBL_ERR;
+       }
+
+       /* store it */
+       for (x = 0; x < hLen && masklen > 0; x++, masklen--) {
+          *mask++ = buf[x];
+       }
+   }
+
+   err = CRYPT_OK;
+LBL_ERR:
+#ifdef LTC_CLEAN_STACK
+   zeromem(buf, hLen);
+#endif
+
+   XFREE(buf);
+
+   return err;
+}
+
+#endif /* LTC_PKCS_1 */
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/pkcs1/pkcs_1_mgf1.c,v $ */
+/* $Revision: 1.8 $ */
+/* $Date: 2007/05/12 14:32:35 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/pkcs1/pkcs_1_oaep_decode.c b/crypto/userspace/libtomcrypt/pk/pkcs1/pkcs_1_oaep_decode.c
new file mode 100644
index 0000000..717d99d
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/pkcs1/pkcs_1_oaep_decode.c
@@ -0,0 +1,192 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+#include <ncr-int.h>
+#include <linux/slab.h>
+
+/**
+  @file pkcs_1_oaep_decode.c
+  OAEP Padding for LTC_PKCS #1, Tom St Denis 
+*/
+
+#ifdef LTC_PKCS_1
+
+/**
+   LTC_PKCS #1 v2.00 OAEP decode
+   @param msg              The encoded data to decode
+   @param msglen           The length of the encoded data (octets)
+   @param lparam           The session or system data (can be NULL)
+   @param lparamlen        The length of the lparam
+   @param modulus_bitlen   The bit length of the RSA modulus
+   @param hash             The desired hash
+   @param out              [out] Destination of decoding
+   @param outlen           [in/out] The max size and resulting size of the decoding
+   @param res              [out] Result of decoding, 1==valid, 0==invalid
+   @return CRYPT_OK if successful (even if invalid)
+*/
+int pkcs_1_oaep_decode(const unsigned char *msg,    unsigned long msglen,
+                       const unsigned char *lparam, unsigned long lparamlen,
+                             unsigned long modulus_bitlen, const struct algo_properties_st *hash,
+                             unsigned char *out,    unsigned long *outlen,
+                             int           *res)
+{
+   unsigned char *DB, *seed, *mask;
+   unsigned long hLen, x, y, modulus_len;
+   int           err;
+
+   LTC_ARGCHK(msg    != NULL);
+   LTC_ARGCHK(out    != NULL);
+   LTC_ARGCHK(outlen != NULL);
+   LTC_ARGCHK(res    != NULL);
+
+   /* default to invalid packet */
+   *res = 0;
+   
+   /* test valid hash */
+   if ((err = hash_is_valid(hash)) != CRYPT_OK) {
+      return err;
+   }
+
+   hLen = hash->digest_size;
+   modulus_len = (modulus_bitlen >> 3) + (modulus_bitlen & 7 ? 1 : 0);
+
+   /* test hash/message size */
+   if ((2*hLen >= (modulus_len - 2)) || (msglen != modulus_len)) {
+      return CRYPT_PK_INVALID_SIZE;
+   }
+
+   /* allocate ram for DB/mask/salt of size modulus_len */
+   DB   = XMALLOC(modulus_len);
+   mask = XMALLOC(modulus_len);
+   seed = XMALLOC(hLen);
+   if (DB == NULL || mask == NULL || seed == NULL) {
+      if (DB != NULL) {
+         XFREE(DB);
+      }
+      if (mask != NULL) {
+         XFREE(mask);
+      }
+      if (seed != NULL) {
+         XFREE(seed);
+      }
+      return CRYPT_MEM;
+   }
+
+   /* ok so it's now in the form
+  
+      0x00  || maskedseed || maskedDB 
+  
+       1    ||   hLen     ||  modulus_len - hLen - 1
+   
+    */
+
+   /* must have leading 0x00 byte */
+   if (msg[0] != 0x00) {
+      err = CRYPT_OK;
+      goto LBL_ERR;
+   }
+
+   /* now read the masked seed */
+   x = 1;
+   XMEMCPY(seed, msg + x, hLen);
+   x += hLen;
+
+   /* now read the masked DB */
+   XMEMCPY(DB, msg + x, modulus_len - hLen - 1);
+   x += modulus_len - hLen - 1;
+
+   /* compute MGF1 of maskedDB (hLen) */ 
+   if ((err = pkcs_1_mgf1(hash, DB, modulus_len - hLen - 1, mask, hLen)) != CRYPT_OK) {
+      goto LBL_ERR;
+   }
+
+   /* XOR against seed */
+   for (y = 0; y < hLen; y++) {
+      seed[y] ^= mask[y];
+   }
+
+   /* compute MGF1 of seed (k - hlen - 1) */
+   if ((err = pkcs_1_mgf1(hash, seed, hLen, mask, modulus_len - hLen - 1)) != CRYPT_OK) {
+      goto LBL_ERR;
+   }
+
+   /* xor against DB */
+   for (y = 0; y < (modulus_len - hLen - 1); y++) {
+       DB[y] ^= mask[y]; 
+   }
+
+   /* now DB == lhash || PS || 0x01 || M, PS == k - mlen - 2hlen - 2 zeroes */
+
+   /* compute lhash and store it in seed [reuse temps!] */
+   x = modulus_len;
+   if (lparam != NULL) {
+      if ((err = hash_memory(hash, lparam, lparamlen, seed, &x)) != CRYPT_OK) {
+         goto LBL_ERR;
+      }
+   } else {
+      /* can't pass hash_memory a NULL so use DB with zero length */
+      if ((err = hash_memory(hash, DB, 0, seed, &x)) != CRYPT_OK) {
+         goto LBL_ERR;
+      }
+   }
+
+   /* compare the lhash'es */
+   if (XMEMCMP(seed, DB, hLen) != 0) {
+      err = CRYPT_OK;
+      goto LBL_ERR;
+   }
+
+   /* now zeroes before a 0x01 */
+   for (x = hLen; x < (modulus_len - hLen - 1) && DB[x] == 0x00; x++) {
+      /* step... */
+   }
+
+   /* error out if wasn't 0x01 */
+   if (x == (modulus_len - hLen - 1) || DB[x] != 0x01) {
+      err = CRYPT_INVALID_PACKET;
+      goto LBL_ERR;
+   }
+
+   /* rest is the message (and skip 0x01) */
+   if ((modulus_len - hLen - 1 - ++x) > *outlen) {
+      *outlen = modulus_len - hLen - 1 - x;
+      err = CRYPT_BUFFER_OVERFLOW;
+      goto LBL_ERR;
+   }
+
+   /* copy message */
+   *outlen = modulus_len - hLen - 1 - x;
+   XMEMCPY(out, DB + x, modulus_len - hLen - 1 - x);
+   x += modulus_len - hLen - 1;
+
+   /* valid packet */
+   *res = 1;
+
+   err = CRYPT_OK;
+LBL_ERR:
+#ifdef LTC_CLEAN_STACK
+   zeromem(DB,   modulus_len);
+   zeromem(seed, hLen);
+   zeromem(mask, modulus_len);
+#endif
+
+   XFREE(seed);
+   XFREE(mask);
+   XFREE(DB);
+
+   return err;
+}
+
+#endif /* LTC_PKCS_1 */
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/pkcs1/pkcs_1_oaep_decode.c,v $ */
+/* $Revision: 1.13 $ */
+/* $Date: 2007/05/12 14:32:35 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/pkcs1/pkcs_1_oaep_encode.c b/crypto/userspace/libtomcrypt/pk/pkcs1/pkcs_1_oaep_encode.c
new file mode 100644
index 0000000..331516f
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/pkcs1/pkcs_1_oaep_encode.c
@@ -0,0 +1,164 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+#include <ncr-int.h>
+#include <linux/slab.h>
+
+/**
+  @file pkcs_1_oaep_encode.c
+  OAEP Padding for LTC_PKCS #1, Tom St Denis 
+*/
+
+#ifdef LTC_PKCS_1
+
+/**
+  LTC_PKCS #1 v2.00 OAEP encode
+  @param msg             The data to encode
+  @param msglen          The length of the data to encode (octets)
+  @param lparam          A session or system parameter (can be NULL)
+  @param lparamlen       The length of the lparam data
+  @param modulus_bitlen  The bit length of the RSA modulus
+  @param hash            The desired hash
+  @param out             [out] The destination for the encoded data
+  @param outlen          [in/out] The max size and resulting size of the encoded data
+  @return CRYPT_OK if successful
+*/
+int pkcs_1_oaep_encode(const unsigned char *msg,    unsigned long msglen,
+                       const unsigned char *lparam, unsigned long lparamlen,
+                             unsigned long modulus_bitlen, const struct algo_properties_st *hash,
+                             unsigned char *out,    unsigned long *outlen)
+{
+   unsigned char *DB, *seed, *mask;
+   unsigned long hLen, x, y, modulus_len;
+   int           err;
+
+   LTC_ARGCHK(msg    != NULL);
+   LTC_ARGCHK(out    != NULL);
+   LTC_ARGCHK(outlen != NULL);
+
+   /* test valid hash */
+   if ((err = hash_is_valid(hash)) != CRYPT_OK) {
+      return err;
+   }
+
+   hLen = hash->digest_size;
+   modulus_len = (modulus_bitlen >> 3) + (modulus_bitlen & 7 ? 1 : 0);
+
+   /* test message size */
+   if ((2*hLen >= (modulus_len - 2)) || (msglen > (modulus_len - 2*hLen - 2))) {
+      return CRYPT_PK_INVALID_SIZE;
+   }
+
+   /* allocate ram for DB/mask/salt of size modulus_len */
+   DB   = XMALLOC(modulus_len);
+   mask = XMALLOC(modulus_len);
+   seed = XMALLOC(hLen);
+   if (DB == NULL || mask == NULL || seed == NULL) {
+      if (DB != NULL) {
+         XFREE(DB);
+      }
+      if (mask != NULL) {
+         XFREE(mask);
+      }
+      if (seed != NULL) {
+         XFREE(seed);
+      }
+      return CRYPT_MEM;
+   }
+
+   /* get lhash */
+   /* DB == lhash || PS || 0x01 || M, PS == k - mlen - 2hlen - 2 zeroes */
+   x = modulus_len;
+   if (lparam != NULL) {
+      if ((err = hash_memory(hash, lparam, lparamlen, DB, &x)) != CRYPT_OK) {
+         goto LBL_ERR;
+      }
+   } else {
+      /* can't pass hash_memory a NULL so use DB with zero length */
+      if ((err = hash_memory(hash, DB, 0, DB, &x)) != CRYPT_OK) {
+         goto LBL_ERR;
+      }
+   }
+
+   /* append PS then 0x01 (to lhash)  */
+   x = hLen;
+   y = modulus_len - msglen - 2*hLen - 2;
+   XMEMSET(DB+x, 0, y);
+   x += y;
+
+   /* 0x01 byte */
+   DB[x++] = 0x01;
+
+   /* message (length = msglen) */
+   XMEMCPY(DB+x, msg, msglen);
+   x += msglen;
+
+   /* now choose a random seed */
+   get_random_bytes(seed, hLen);
+
+   /* compute MGF1 of seed (k - hlen - 1) */
+   if ((err = pkcs_1_mgf1(hash, seed, hLen, mask, modulus_len - hLen - 1)) != CRYPT_OK) {
+      goto LBL_ERR;
+   }
+
+   /* xor against DB */
+   for (y = 0; y < (modulus_len - hLen - 1); y++) {
+       DB[y] ^= mask[y]; 
+   }
+
+   /* compute MGF1 of maskedDB (hLen) */ 
+   if ((err = pkcs_1_mgf1(hash, DB, modulus_len - hLen - 1, mask, hLen)) != CRYPT_OK) {
+      goto LBL_ERR;
+   }
+
+   /* XOR against seed */
+   for (y = 0; y < hLen; y++) {
+      seed[y] ^= mask[y];
+   }
+
+   /* create string of length modulus_len */
+   if (*outlen < modulus_len) {
+      *outlen = modulus_len;
+      err = CRYPT_BUFFER_OVERFLOW;
+      goto LBL_ERR;
+   }
+
+   /* start output which is 0x00 || maskedSeed || maskedDB */
+   x = 0;
+   out[x++] = 0x00;
+   XMEMCPY(out+x, seed, hLen);
+   x += hLen;
+   XMEMCPY(out+x, DB, modulus_len - hLen - 1);
+   x += modulus_len - hLen - 1;
+
+   *outlen = x;
+    
+   err = CRYPT_OK;
+LBL_ERR:
+#ifdef LTC_CLEAN_STACK
+   zeromem(DB,   modulus_len);
+   zeromem(seed, hLen);
+   zeromem(mask, modulus_len);
+#endif
+
+   XFREE(seed);
+   XFREE(mask);
+   XFREE(DB);
+
+   return err;
+}
+
+#endif /* LTC_PKCS_1 */
+
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/pkcs1/pkcs_1_oaep_encode.c,v $ */
+/* $Revision: 1.9 $ */
+/* $Date: 2007/05/12 14:32:35 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/pkcs1/pkcs_1_os2ip.c b/crypto/userspace/libtomcrypt/pk/pkcs1/pkcs_1_os2ip.c
new file mode 100644
index 0000000..513abb6
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/pkcs1/pkcs_1_os2ip.c
@@ -0,0 +1,36 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/** 
+  @file pkcs_1_os2ip.c
+  Octet to Integer OS2IP, Tom St Denis 
+*/
+#ifdef LTC_PKCS_1
+
+/**
+  Read a binary string into an mp_int
+  @param n          [out] The mp_int destination
+  @param in         The binary string to read
+  @param inlen      The length of the binary string
+  @return CRYPT_OK if successful
+*/
+int pkcs_1_os2ip(void *n, unsigned char *in, unsigned long inlen)
+{
+   return mp_read_unsigned_bin(n, in, inlen);
+}
+
+#endif /* LTC_PKCS_1 */
+
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/pkcs1/pkcs_1_os2ip.c,v $ */
+/* $Revision: 1.7 $ */
+/* $Date: 2007/05/12 14:32:35 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/pkcs1/pkcs_1_pss_decode.c b/crypto/userspace/libtomcrypt/pk/pkcs1/pkcs_1_pss_decode.c
new file mode 100644
index 0000000..5d44ce8
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/pkcs1/pkcs_1_pss_decode.c
@@ -0,0 +1,168 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+#include <ncr-int.h>
+#include <linux/slab.h>
+
+/**
+  @file pkcs_1_pss_decode.c
+  LTC_PKCS #1 PSS Signature Padding, Tom St Denis 
+*/
+
+#ifdef LTC_PKCS_1
+
+/**
+   LTC_PKCS #1 v2.00 PSS decode
+   @param  msghash         The hash to verify
+   @param  msghashlen      The length of the hash (octets)
+   @param  sig             The signature data (encoded data)
+   @param  siglen          The length of the signature data (octets)
+   @param  saltlen         The length of the salt used (octets)
+   @param  hash_algo       The desired hash
+   @param  modulus_bitlen  The bit length of the RSA modulus
+   @param  res             [out] The result of the comparison, 1==valid, 0==invalid
+   @return CRYPT_OK if successful (even if the comparison failed)
+*/
+int pkcs_1_pss_decode(const unsigned char *msghash, unsigned long msghashlen,
+                      const unsigned char *sig,     unsigned long siglen,
+                            unsigned long saltlen, const struct algo_properties_st *hash_algo,
+                            unsigned long modulus_bitlen, int    *res)
+{
+   unsigned char *DB, *mask, *salt, *hash;
+   unsigned long x, y, hLen, modulus_len;
+   int           err;
+
+   LTC_ARGCHK(msghash != NULL);
+   LTC_ARGCHK(res     != NULL);
+
+   /* default to invalid */
+   *res = 0;
+
+   /* ensure hash is valid */
+   if ((err = hash_is_valid(hash_algo)) != CRYPT_OK) {
+      return err;
+   }
+
+   hLen = hash_algo->digest_size;
+   modulus_len = (modulus_bitlen>>3) + (modulus_bitlen & 7 ? 1 : 0);
+
+   /* check sizes */
+   if ((saltlen > modulus_len) || 
+       (modulus_len < hLen + saltlen + 2) || (siglen != modulus_len)) {
+      return CRYPT_PK_INVALID_SIZE;
+   }
+
+   /* allocate ram for DB/mask/salt/hash of size modulus_len */
+   DB   = XMALLOC(modulus_len);
+   mask = XMALLOC(modulus_len);
+   salt = XMALLOC(modulus_len);
+   hash = XMALLOC(modulus_len);
+   if (DB == NULL || mask == NULL || salt == NULL || hash == NULL) {
+      if (DB != NULL) {
+         XFREE(DB);
+      }
+      if (mask != NULL) {
+         XFREE(mask);
+      }
+      if (salt != NULL) {
+         XFREE(salt);
+      }
+      if (hash != NULL) {
+         XFREE(hash);
+      }
+      return CRYPT_MEM;
+   }
+
+   /* ensure the 0xBC byte */
+   if (sig[siglen-1] != 0xBC) {
+      err = CRYPT_INVALID_PACKET;
+      goto LBL_ERR;
+   }
+
+   /* copy out the DB */
+   x = 0;
+   XMEMCPY(DB, sig + x, modulus_len - hLen - 1);
+   x += modulus_len - hLen - 1;
+
+   /* copy out the hash */
+   XMEMCPY(hash, sig + x, hLen);
+   x += hLen;
+
+   /* check the MSB */
+   if ((sig[0] & ~(0xFF >> ((modulus_len<<3) - (modulus_bitlen-1)))) != 0) {
+      err = CRYPT_INVALID_PACKET;
+      goto LBL_ERR;
+   }
+
+   /* generate mask of length modulus_len - hLen - 1 from hash */
+   if ((err = pkcs_1_mgf1(hash_algo, hash, hLen, mask, modulus_len - hLen - 1)) != CRYPT_OK) {
+      goto LBL_ERR;
+   }
+
+   /* xor against DB */
+   for (y = 0; y < (modulus_len - hLen - 1); y++) {
+      DB[y] ^= mask[y];
+   }
+   
+   /* now clear the first byte [make sure smaller than modulus] */
+   DB[0] &= 0xFF >> ((modulus_len<<3) - (modulus_bitlen-1));
+
+   /* DB = PS || 0x01 || salt, PS == modulus_len - saltlen - hLen - 2 zero bytes */
+
+   /* check for zeroes and 0x01 */
+   for (x = 0; x < modulus_len - saltlen - hLen - 2; x++) {
+       if (DB[x] != 0x00) {
+          err = CRYPT_INVALID_PACKET;
+          goto LBL_ERR;
+       }
+   }
+
+   /* check for the 0x01 */
+   if (DB[x++] != 0x01) {
+      err = CRYPT_INVALID_PACKET;
+      goto LBL_ERR;
+   }
+
+   zeromem(mask, 8);
+
+   /* M = (eight) 0x00 || msghash || salt, mask = H(M) */
+   err = hash_memory_multi(hash_algo, mask, &hLen, mask, (unsigned long)8, msghash, (unsigned long)msghashlen, DB+x, (unsigned long)saltlen, NULL, 0);
+   if (err != CRYPT_OK) {
+      goto LBL_ERR;
+   }
+
+   /* mask == hash means valid signature */
+   if (XMEMCMP(mask, hash, hLen) == 0) {
+      *res = 1;
+   }
+
+   err = CRYPT_OK;
+LBL_ERR:
+#ifdef LTC_CLEAN_STACK
+   zeromem(DB,   modulus_len);   
+   zeromem(mask, modulus_len);   
+   zeromem(salt, modulus_len);   
+   zeromem(hash, modulus_len);   
+#endif
+
+   XFREE(hash);
+   XFREE(salt);
+   XFREE(mask);
+   XFREE(DB);
+
+   return err;
+}
+
+#endif /* LTC_PKCS_1 */
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/pkcs1/pkcs_1_pss_decode.c,v $ */
+/* $Revision: 1.11 $ */
+/* $Date: 2007/05/12 14:32:35 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/pkcs1/pkcs_1_pss_encode.c b/crypto/userspace/libtomcrypt/pk/pkcs1/pkcs_1_pss_encode.c
new file mode 100644
index 0000000..9416eae
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/pkcs1/pkcs_1_pss_encode.c
@@ -0,0 +1,157 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+#include <ncr-int.h>
+#include <linux/slab.h>
+
+/**
+  @file pkcs_1_pss_encode.c
+  LTC_PKCS #1 PSS Signature Padding, Tom St Denis 
+*/
+
+#ifdef LTC_PKCS_1
+
+/**
+   LTC_PKCS #1 v2.00 Signature Encoding
+   @param msghash          The hash to encode
+   @param msghashlen       The length of the hash (octets)
+   @param saltlen          The length of the salt desired (octets)
+   @param hash_algo        The desired hash
+   @param modulus_bitlen   The bit length of the RSA modulus
+   @param out              [out] The destination of the encoding
+   @param outlen           [in/out] The max size and resulting size of the encoded data
+   @return CRYPT_OK if successful
+*/
+int pkcs_1_pss_encode(const unsigned char *msghash, unsigned long msghashlen,
+                            unsigned long saltlen, const struct algo_properties_st *hash_algo,
+                            unsigned long modulus_bitlen,
+                            unsigned char *out,     unsigned long *outlen)
+{
+   unsigned char *DB, *mask, *salt, *hash;
+   unsigned long x, y, hLen, modulus_len;
+   int           err;
+
+   LTC_ARGCHK(msghash != NULL);
+   LTC_ARGCHK(out     != NULL);
+   LTC_ARGCHK(outlen  != NULL);
+
+   /* ensure hash and PRNG are valid */
+   if ((err = hash_is_valid(hash_algo)) != CRYPT_OK) {
+      return err;
+   }
+
+   hLen = hash_algo->digest_size;
+   modulus_len = (modulus_bitlen>>3) + (modulus_bitlen & 7 ? 1 : 0);
+
+   /* check sizes */
+   if ((saltlen > modulus_len) || (modulus_len < hLen + saltlen + 2)) {
+      return CRYPT_PK_INVALID_SIZE;
+   }
+
+   /* allocate ram for DB/mask/salt/hash of size modulus_len */
+   DB   = XMALLOC(modulus_len);
+   mask = XMALLOC(modulus_len);
+   salt = XMALLOC(modulus_len);
+   hash = XMALLOC(modulus_len);
+   if (DB == NULL || mask == NULL || salt == NULL || hash == NULL) {
+      if (DB != NULL) {
+         XFREE(DB);
+      }
+      if (mask != NULL) {
+         XFREE(mask);
+      }
+      if (salt != NULL) {
+         XFREE(salt);
+      }
+      if (hash != NULL) {
+         XFREE(hash);
+      }
+      return CRYPT_MEM;
+   }
+
+
+   /* generate random salt */
+   if (saltlen > 0) {
+      get_random_bytes(salt, saltlen);
+   }
+   
+   zeromem(DB, 8);
+
+   /* M = (eight) 0x00 || msghash || salt, hash = H(M) */
+   err = hash_memory_multi(hash_algo, hash, &hLen, DB, (unsigned long)8, msghash, (unsigned long)msghashlen, salt, (unsigned long)saltlen, NULL, 0);
+   if (err != CRYPT_OK) {
+      goto LBL_ERR;
+   }
+
+   /* generate DB = PS || 0x01 || salt, PS == modulus_len - saltlen - hLen - 2 zero bytes */
+   x = 0;
+   XMEMSET(DB + x, 0, modulus_len - saltlen - hLen - 2);
+   x += modulus_len - saltlen - hLen - 2;
+   DB[x++] = 0x01;
+   XMEMCPY(DB + x, salt, saltlen);
+   x += saltlen;
+
+   /* generate mask of length modulus_len - hLen - 1 from hash */
+   if ((err = pkcs_1_mgf1(hash_algo, hash, hLen, mask, modulus_len - hLen - 1)) != CRYPT_OK) {
+      goto LBL_ERR;
+   }
+
+   /* xor against DB */
+   for (y = 0; y < (modulus_len - hLen - 1); y++) {
+      DB[y] ^= mask[y];
+   }
+
+   /* output is DB || hash || 0xBC */
+   if (*outlen < modulus_len) {
+      *outlen = modulus_len;
+      err = CRYPT_BUFFER_OVERFLOW;
+      goto LBL_ERR;
+   }
+
+   /* DB len = modulus_len - hLen - 1 */
+   y = 0;
+   XMEMCPY(out + y, DB, modulus_len - hLen - 1);
+   y += modulus_len - hLen - 1;
+
+   /* hash */
+   XMEMCPY(out + y, hash, hLen);
+   y += hLen;
+
+   /* 0xBC */
+   out[y] = 0xBC;
+
+   /* now clear the 8*modulus_len - modulus_bitlen most significant bits */
+   out[0] &= 0xFF >> ((modulus_len<<3) - (modulus_bitlen-1));
+
+   /* store output size */
+   *outlen = modulus_len;
+   err = CRYPT_OK;
+LBL_ERR:
+#ifdef LTC_CLEAN_STACK
+   zeromem(DB,   modulus_len);   
+   zeromem(mask, modulus_len);   
+   zeromem(salt, modulus_len);   
+   zeromem(hash, modulus_len);   
+#endif
+
+   XFREE(hash);
+   XFREE(salt);
+   XFREE(mask);
+   XFREE(DB);
+
+   return err;
+}
+
+#endif /* LTC_PKCS_1 */
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/pkcs1/pkcs_1_pss_encode.c,v $ */
+/* $Revision: 1.9 $ */
+/* $Date: 2007/05/12 14:32:35 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/pkcs1/pkcs_1_v1_5_decode.c b/crypto/userspace/libtomcrypt/pk/pkcs1/pkcs_1_v1_5_decode.c
new file mode 100644
index 0000000..1bb08e3
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/pkcs1/pkcs_1_v1_5_decode.c
@@ -0,0 +1,110 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/** @file pkcs_1_v1_5_decode.c
+ *
+ *  LTC_PKCS #1 v1.5 Padding. (Andreas Lange)
+ */
+
+#ifdef LTC_PKCS_1
+
+/** @brief LTC_PKCS #1 v1.5 decode.
+ *
+ *  @param msg              The encoded data to decode
+ *  @param msglen           The length of the encoded data (octets)
+ *  @param block_type       Block type to use in padding (\sa ltc_pkcs_1_v1_5_blocks)
+ *  @param modulus_bitlen   The bit length of the RSA modulus
+ *  @param out              [out] Destination of decoding
+ *  @param outlen           [in/out] The max size and resulting size of the decoding
+ *  @param is_valid         [out] Boolean whether the padding was valid
+ *
+ *  @return CRYPT_OK if successful (even if invalid)
+ */
+int pkcs_1_v1_5_decode(const unsigned char *msg, 
+                             unsigned long  msglen,
+                                       int  block_type,
+                             unsigned long  modulus_bitlen,
+                             unsigned char *out, 
+                             unsigned long *outlen,
+                                       int *is_valid)
+{
+  unsigned long modulus_len, ps_len, i;
+  int result;
+
+  /* default to invalid packet */
+  *is_valid = 0;
+
+  modulus_len = (modulus_bitlen >> 3) + (modulus_bitlen & 7 ? 1 : 0);
+
+  /* test message size */
+
+  if ((msglen > modulus_len) || (modulus_len < 11)) {
+    return CRYPT_PK_INVALID_SIZE;
+  }
+
+  /* separate encoded message */
+
+  if ((msg[0] != 0x00) || (msg[1] != (unsigned char)block_type)) {
+    result = CRYPT_INVALID_PACKET;
+    goto bail;
+  }
+
+  if (block_type == LTC_LTC_PKCS_1_EME) {
+    for (i = 2; i < modulus_len; i++) {
+      /* separator */
+      if (msg[i] == 0x00) { break; }
+    }
+    ps_len = i++ - 2;
+
+    if ((i >= modulus_len) || (ps_len < 8)) {
+      /* There was no octet with hexadecimal value 0x00 to separate ps from m,
+       * or the length of ps is less than 8 octets.
+       */
+      result = CRYPT_INVALID_PACKET;
+      goto bail;
+    }
+  } else {
+    for (i = 2; i < modulus_len - 1; i++) {
+       if (msg[i] != 0xFF) { break; }
+    }
+
+    /* separator check */
+    if (msg[i] != 0) {
+      /* There was no octet with hexadecimal value 0x00 to separate ps from m. */
+      result = CRYPT_INVALID_PACKET;
+      goto bail;
+    }
+
+    ps_len = i - 2;
+  }
+
+  if (*outlen < (msglen - (2 + ps_len + 1))) {
+    *outlen = msglen - (2 + ps_len + 1);
+    result = CRYPT_BUFFER_OVERFLOW;
+    goto bail;
+  }
+
+  *outlen = (msglen - (2 + ps_len + 1));
+  XMEMCPY(out, &msg[2 + ps_len + 1], *outlen);
+
+  /* valid packet */
+  *is_valid = 1;
+  result    = CRYPT_OK;
+bail:
+  return result;
+} /* pkcs_1_v1_5_decode */
+
+#endif /* #ifdef LTC_PKCS_1 */
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/pkcs1/pkcs_1_v1_5_decode.c,v $ */
+/* $Revision: 1.7 $ */
+/* $Date: 2007/05/12 14:32:35 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/pkcs1/pkcs_1_v1_5_encode.c b/crypto/userspace/libtomcrypt/pk/pkcs1/pkcs_1_v1_5_encode.c
new file mode 100644
index 0000000..048fe69
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/pkcs1/pkcs_1_v1_5_encode.c
@@ -0,0 +1,95 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/*! \file pkcs_1_v1_5_encode.c
+ *
+ *  LTC_PKCS #1 v1.5 Padding (Andreas Lange)
+ */
+
+#ifdef LTC_PKCS_1
+
+/*! \brief LTC_PKCS #1 v1.5 encode.
+ *
+ *  \param msg              The data to encode
+ *  \param msglen           The length of the data to encode (octets)
+ *  \param block_type       Block type to use in padding (\sa ltc_pkcs_1_v1_5_blocks)
+ *  \param modulus_bitlen   The bit length of the RSA modulus
+ *  \param out              [out] The destination for the encoded data
+ *  \param outlen           [in/out] The max size and resulting size of the encoded data
+ *
+ *  \return CRYPT_OK if successful
+ */
+int pkcs_1_v1_5_encode(const unsigned char *msg, 
+                             unsigned long  msglen,
+                                       int  block_type,
+                             unsigned long  modulus_bitlen,
+                             unsigned char *out, 
+                             unsigned long *outlen)
+{
+  unsigned long modulus_len, ps_len, i;
+  unsigned char *ps;
+  int result;
+
+  /* valid block_type? */
+  if ((block_type != LTC_LTC_PKCS_1_EMSA) &&
+      (block_type != LTC_LTC_PKCS_1_EME)) {
+     return CRYPT_PK_INVALID_PADDING;
+  }
+
+  modulus_len = (modulus_bitlen >> 3) + (modulus_bitlen & 7 ? 1 : 0);
+
+  /* test message size */
+  if ((msglen + 11) > modulus_len) {
+    return CRYPT_PK_INVALID_SIZE;
+  }
+
+  if (*outlen < modulus_len) {
+    *outlen = modulus_len;
+    result = CRYPT_BUFFER_OVERFLOW;
+    goto bail;
+  }
+
+  /* generate an octets string PS */
+  ps = &out[2];
+  ps_len = modulus_len - msglen - 3;
+
+  if (block_type == LTC_LTC_PKCS_1_EME) {
+    /* now choose a random ps */
+    get_random_bytes(ps, ps_len);
+
+    /* transform zero bytes (if any) to non-zero random bytes */
+    for (i = 0; i < ps_len; i++) {
+      while (ps[i] == 0) {
+        get_random_bytes(&ps[i], 1);
+      }
+    }
+  } else {
+    XMEMSET(ps, 0xFF, ps_len);
+  }
+
+  /* create string of length modulus_len */
+  out[0]          = 0x00;
+  out[1]          = (unsigned char)block_type;  /* block_type 1 or 2 */
+  out[2 + ps_len] = 0x00;
+  XMEMCPY(&out[2 + ps_len + 1], msg, msglen);
+  *outlen = modulus_len;
+
+  result  = CRYPT_OK;
+bail:
+  return result;
+} /* pkcs_1_v1_5_encode */
+
+#endif /* #ifdef LTC_PKCS_1 */
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/pkcs1/pkcs_1_v1_5_encode.c,v $ */
+/* $Revision: 1.4 $ */
+/* $Date: 2007/05/12 14:32:35 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/rsa/rsa_decrypt_key.c b/crypto/userspace/libtomcrypt/pk/rsa/rsa_decrypt_key.c
new file mode 100644
index 0000000..ba16e32
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/rsa/rsa_decrypt_key.c
@@ -0,0 +1,107 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+#include "ncr-int.h"
+#include <linux/slab.h>
+
+/**
+  @file rsa_decrypt_key.c
+  RSA LTC_PKCS #1 Decryption, Tom St Denis and Andreas Lange
+*/
+
+#ifdef LTC_MRSA
+
+/**
+   LTC_PKCS #1 decrypt then v1.5 or OAEP depad
+   @param in          The ciphertext
+   @param inlen       The length of the ciphertext (octets)
+   @param out         [out] The plaintext
+   @param outlen      [in/out] The max size and resulting size of the plaintext (octets)
+   @param lparam      The system "lparam" value
+   @param lparamlen   The length of the lparam value (octets)
+   @param hash        The desired hash
+   @param padding     Type of padding (LTC_LTC_PKCS_1_OAEP or LTC_LTC_PKCS_1_V1_5)
+   @param stat        [out] Result of the decryption, 1==valid, 0==invalid
+   @param key         The corresponding private RSA key
+   @return CRYPT_OK if succcessul (even if invalid)
+*/
+int rsa_decrypt_key_ex(const unsigned char *in,       unsigned long  inlen,
+                             unsigned char *out,      unsigned long *outlen,
+                       const unsigned char *lparam,   unsigned long  lparamlen,
+                       const struct algo_properties_st *hash, int padding,
+                             int           *stat,     rsa_key       *key)
+{
+  unsigned long modulus_bitlen, modulus_bytelen, x;
+  int           err;
+  unsigned char *tmp;
+
+  LTC_ARGCHK(out    != NULL);
+  LTC_ARGCHK(outlen != NULL);
+  LTC_ARGCHK(key    != NULL);
+  LTC_ARGCHK(stat   != NULL);
+
+  /* default to invalid */
+  *stat = 0;
+
+  /* valid padding? */
+
+  if ((padding != LTC_LTC_PKCS_1_V1_5) &&
+      (padding != LTC_LTC_PKCS_1_OAEP)) {
+    return CRYPT_PK_INVALID_PADDING;
+  }
+
+  if (padding == LTC_LTC_PKCS_1_OAEP) {
+    /* valid hash ? */
+    if ((err = hash_is_valid(hash)) != CRYPT_OK) {
+       return err;
+    }
+  }
+
+  /* get modulus len in bits */
+  modulus_bitlen = mp_count_bits( (&key->N));
+
+  /* outlen must be at least the size of the modulus */
+  modulus_bytelen = mp_unsigned_bin_size( (&key->N));
+  if (modulus_bytelen != inlen) {
+     return CRYPT_INVALID_PACKET;
+  }
+
+  /* allocate ram */
+  tmp = XMALLOC(inlen);
+  if (tmp == NULL) {
+     return CRYPT_MEM;
+  }
+
+  /* rsa decode the packet */
+  x = inlen;
+  if ((err = rsa_exptmod(in, inlen, tmp, &x, PK_PRIVATE, key)) != CRYPT_OK) {
+     XFREE(tmp);
+     return err;
+  }
+
+  if (padding == LTC_LTC_PKCS_1_OAEP) {
+    /* now OAEP decode the packet */
+    err = pkcs_1_oaep_decode(tmp, x, lparam, lparamlen, modulus_bitlen, hash,
+                             out, outlen, stat);
+  } else {
+    /* now LTC_PKCS #1 v1.5 depad the packet */
+    err = pkcs_1_v1_5_decode(tmp, x, LTC_LTC_PKCS_1_EME, modulus_bitlen, out, outlen, stat);
+  }
+
+  XFREE(tmp);
+  return err;
+}
+
+#endif /* LTC_MRSA */
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/rsa/rsa_decrypt_key.c,v $ */
+/* $Revision: 1.10 $ */
+/* $Date: 2007/05/12 14:32:35 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/rsa/rsa_encrypt_key.c b/crypto/userspace/libtomcrypt/pk/rsa/rsa_encrypt_key.c
new file mode 100644
index 0000000..8d3f2db
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/rsa/rsa_encrypt_key.c
@@ -0,0 +1,96 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+#include "ncr-int.h"
+
+/**
+  @file rsa_encrypt_key.c
+  RSA LTC_PKCS #1 encryption, Tom St Denis and Andreas Lange
+*/
+
+#ifdef LTC_MRSA
+
+/**
+    (LTC_PKCS #1 v2.0) OAEP pad then encrypt
+    @param in          The plaintext
+    @param inlen       The length of the plaintext (octets)
+    @param out         [out] The ciphertext
+    @param outlen      [in/out] The max size and resulting size of the ciphertext
+    @param lparam      The system "lparam" for the encryption
+    @param lparamlen   The length of lparam (octets)
+    @param hash        The desired hash
+    @param padding     Type of padding (LTC_LTC_PKCS_1_OAEP or LTC_LTC_PKCS_1_V1_5)
+    @param key         The RSA key to encrypt to
+    @return CRYPT_OK if successful
+*/
+int rsa_encrypt_key_ex(const unsigned char *in,     unsigned long inlen,
+                             unsigned char *out,    unsigned long *outlen,
+                       const unsigned char *lparam, unsigned long lparamlen,
+                       const struct algo_properties_st *hash, int padding, rsa_key *key)
+{
+  unsigned long modulus_bitlen, modulus_bytelen, x;
+  int           err;
+
+  LTC_ARGCHK(in     != NULL);
+  LTC_ARGCHK(out    != NULL);
+  LTC_ARGCHK(outlen != NULL);
+  LTC_ARGCHK(key    != NULL);
+
+  /* valid padding? */
+  if ((padding != LTC_LTC_PKCS_1_V1_5) &&
+      (padding != LTC_LTC_PKCS_1_OAEP)) {
+    return CRYPT_PK_INVALID_PADDING;
+  }
+
+  if (padding == LTC_LTC_PKCS_1_OAEP) {
+    /* valid hash? */
+    if ((err = hash_is_valid(hash)) != CRYPT_OK) {
+       return err;
+    }
+  }
+
+  /* get modulus len in bits */
+  modulus_bitlen = mp_count_bits( (&key->N));
+
+  /* outlen must be at least the size of the modulus */
+  modulus_bytelen = mp_unsigned_bin_size( (&key->N));
+  if (modulus_bytelen > *outlen) {
+     *outlen = modulus_bytelen;
+     return CRYPT_BUFFER_OVERFLOW;
+  }
+
+  if (padding == LTC_LTC_PKCS_1_OAEP) {
+    /* OAEP pad the key */
+    x = *outlen;
+    if ((err = pkcs_1_oaep_encode(in, inlen, lparam,
+                                  lparamlen, modulus_bitlen, hash,
+				  out, &x)) != CRYPT_OK) {
+       return err;
+    }
+  } else {
+    /* LTC_PKCS #1 v1.5 pad the key */
+    x = *outlen;
+    if ((err = pkcs_1_v1_5_encode(in, inlen, LTC_LTC_PKCS_1_EME,
+                                  modulus_bitlen, 
+                                  out, &x)) != CRYPT_OK) {
+      return err;
+    }
+  }
+
+  /* rsa exptmod the OAEP or LTC_PKCS #1 v1.5 pad */
+  return rsa_exptmod(out, x, out, outlen, PK_PUBLIC, key);
+}
+
+#endif /* LTC_MRSA */
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/rsa/rsa_encrypt_key.c,v $ */
+/* $Revision: 1.10 $ */
+/* $Date: 2007/05/12 14:32:35 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/rsa/rsa_export.c b/crypto/userspace/libtomcrypt/pk/rsa/rsa_export.c
new file mode 100644
index 0000000..c5e8ff0
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/rsa/rsa_export.c
@@ -0,0 +1,87 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+#include <ncr-int.h>
+#include <linux/slab.h>
+/**
+  @file rsa_export.c
+  Export RSA LTC_PKCS keys, Tom St Denis
+*/  
+
+#ifdef LTC_MRSA
+
+/**
+    This will export either an RSAPublicKey or RSAPrivateKey [defined in LTC_PKCS #1 v2.1] 
+    @param out       [out] Destination of the packet
+    @param outlen    [in/out] The max size and resulting size of the packet
+    @param type      The type of exported key (PK_PRIVATE or PK_PUBLIC)
+    @param key       The RSA key to export
+    @return CRYPT_OK if successful
+*/    
+int rsa_export(unsigned char *out, unsigned long *outlen, int type, rsa_key *key)
+{
+   unsigned long zero=0;
+   int err;
+   LTC_ARGCHK(out    != NULL);
+   LTC_ARGCHK(outlen != NULL);
+   LTC_ARGCHK(key    != NULL);
+
+   /* type valid? */
+   if (!(key->type == PK_PRIVATE) && (type == PK_PRIVATE)) {
+      return CRYPT_PK_INVALID_TYPE;
+   }
+
+   if (type == PK_PRIVATE) {
+      /* private key */
+      /* output is 
+            Version, n, e, d, p, q, d mod (p-1), d mod (q - 1), 1/q mod p
+       */
+      return der_encode_sequence_multi(out, outlen, 
+                          LTC_ASN1_SHORT_INTEGER, 1UL, &zero, 
+                          LTC_ASN1_INTEGER, 1UL,  &key->N, 
+                          LTC_ASN1_INTEGER, 1UL,  &key->e,
+                          LTC_ASN1_INTEGER, 1UL,  &key->d, 
+                          LTC_ASN1_INTEGER, 1UL,  &key->p, 
+                          LTC_ASN1_INTEGER, 1UL,  &key->q, 
+                          LTC_ASN1_INTEGER, 1UL,  &key->dP,
+                          LTC_ASN1_INTEGER, 1UL,  &key->dQ, 
+                          LTC_ASN1_INTEGER, 1UL,  &key->qP, 
+                          LTC_ASN1_EOL,     0UL, NULL);
+   } else {
+      unsigned long tmplen = (mp_count_bits(&key->N)/8)*2+8;
+      unsigned char* tmp = XMALLOC(tmplen);
+      
+      if (tmp == NULL) {
+	   return CRYPT_MEM;
+      }
+
+      err = der_encode_sequence_multi(tmp, &tmplen, 
+                                 LTC_ASN1_INTEGER, 1UL,  &key->N, 
+                                 LTC_ASN1_INTEGER, 1UL,  &key->e, 
+                                 LTC_ASN1_EOL,     0UL, NULL);
+      if (err != CRYPT_OK) {
+		  goto error;
+      }
+
+      err = der_encode_subject_public_key_info(out, outlen, 
+        PKA_RSA, tmp, tmplen, LTC_ASN1_NULL, NULL, 0);
+      
+error:
+      XFREE(tmp);
+      return err;
+   }
+}
+
+#endif /* LTC_MRSA */
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/rsa/rsa_export.c,v $ */
+/* $Revision: 1.17 $ */
+/* $Date: 2007/05/12 14:32:35 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/rsa/rsa_exptmod.c b/crypto/userspace/libtomcrypt/pk/rsa/rsa_exptmod.c
new file mode 100644
index 0000000..35ebfe3
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/rsa/rsa_exptmod.c
@@ -0,0 +1,147 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ * 
+ * Added RSA blinding --nmav
+ */
+#include "tomcrypt.h"
+
+/**
+  @file rsa_exptmod.c
+  RSA LTC_PKCS exptmod, Tom St Denis
+*/  
+
+#ifdef LTC_MRSA
+
+/** 
+   Compute an RSA modular exponentiation 
+   @param in         The input data to send into RSA
+   @param inlen      The length of the input (octets)
+   @param out        [out] The destination 
+   @param outlen     [in/out] The max size and resulting size of the output
+   @param which      Which exponent to use, e.g. PK_PRIVATE or PK_PUBLIC
+   @param key        The RSA key to use 
+   @return CRYPT_OK if successful
+*/   
+int rsa_exptmod(const unsigned char *in,   unsigned long inlen,
+                      unsigned char *out,  unsigned long *outlen, int which,
+                      rsa_key *key)
+{
+   mp_int        tmp, tmpa, tmpb, rnd, rndi /* inverse of rnd */;
+   unsigned long x;
+   int           err;
+
+   LTC_ARGCHK(in     != NULL);
+   LTC_ARGCHK(out    != NULL);
+   LTC_ARGCHK(outlen != NULL);
+   LTC_ARGCHK(key    != NULL);
+  
+   /* is the key of the right type for the operation? */
+   if (which == PK_PRIVATE && (key->type != PK_PRIVATE)) {
+      return CRYPT_PK_NOT_PRIVATE;
+   }
+
+   /* must be a private or public operation */
+   if (which != PK_PRIVATE && which != PK_PUBLIC) {
+      return CRYPT_PK_INVALID_TYPE;
+   }
+
+   /* init and copy into tmp */
+   if ((err = mp_init_multi(&tmp, &tmpa, &tmpb, &rnd, &rndi, NULL)) != CRYPT_OK) 
+        { return err; }
+   if ((err = mp_read_unsigned_bin(&tmp, (unsigned char *)in, (int)inlen)) != CRYPT_OK)                 
+        { goto error; }
+
+   /* sanity check on the input */
+   if (mp_cmp(&key->N, &tmp) == LTC_MP_LT) {
+      err = CRYPT_PK_INVALID_SIZE;
+      goto error;
+   }
+
+   /* are we using the private exponent and is the key optimized? */
+   if (which == PK_PRIVATE) {
+      /* do blinding */
+      err = mp_rand(&rnd, mp_count_bits(&key->N));
+      if (err != CRYPT_OK) {
+             goto error;
+      }
+        
+      /* rndi = 1/rnd mod N */
+      err = mp_invmod( &rnd, &key->N, &rndi);
+      if (err != CRYPT_OK) {
+             goto error;
+      }
+        
+      /* rnd = rnd^e */
+      err = mp_exptmod( &rnd, &key->e, &key->N, &rnd);
+      if (err != CRYPT_OK) {
+             goto error;
+      }
+
+      /* tmp = tmp*rnd mod N */
+      err = mp_mulmod( &tmp, &rnd, &key->N, &tmp);
+      if (err != CRYPT_OK) {
+             goto error;
+      }
+
+      /* tmpa = tmp^dP mod p */
+      if ((err = mp_exptmod(&tmp, &key->dP, &key->p, &tmpa)) != CRYPT_OK)                               { goto error; }
+
+      /* tmpb = tmp^dQ mod q */
+      if ((err = mp_exptmod(&tmp, &key->dQ, &key->q, &tmpb)) != CRYPT_OK)                               { goto error; }
+
+      /* tmp = (tmpa - tmpb) * qInv (mod p) */
+      if ((err = mp_sub(&tmpa, &tmpb, &tmp)) != CRYPT_OK)                                              { goto error; }
+      if ((err = mp_mulmod(&tmp, &key->qP, &key->p, &tmp)) != CRYPT_OK)                                { goto error; }
+
+      /* tmp = tmpb + q * tmp */
+      if ((err = mp_mul(&tmp, &key->q, &tmp)) != CRYPT_OK)                                             { goto error; }
+      if ((err = mp_add(&tmp, &tmpb, &tmp)) != CRYPT_OK)                                               { goto error; }
+      
+      /* unblind */
+      err = mp_mulmod( &tmp, &rndi, &key->N, &tmp);
+      if (err != CRYPT_OK) {
+             goto error;
+      }
+   } else {
+      /* exptmod it */
+      if ((err = mp_exptmod(&tmp, &key->e, &key->N, &tmp)) != CRYPT_OK)                                { goto error; }
+   }
+
+   /* read it back */
+   x = (unsigned long)mp_unsigned_bin_size(&key->N);
+   if (x > *outlen) {
+      *outlen = x;
+      err = CRYPT_BUFFER_OVERFLOW;
+      goto error;
+   }
+
+   /* this should never happen ... */
+   if (mp_unsigned_bin_size(&tmp) > mp_unsigned_bin_size(&key->N)) {
+      err = CRYPT_ERROR;
+      goto error;
+   }
+   *outlen = x;
+
+   /* convert it */
+   zeromem(out, x);
+   if ((err = mp_to_unsigned_bin(&tmp, out+(x-mp_unsigned_bin_size(&tmp)))) != CRYPT_OK)               { goto error; }
+
+   /* clean up and return */
+   err = CRYPT_OK;
+error:
+   mp_clear_multi(&tmp, &tmpa, &tmpb, &rnd, &rndi, NULL);
+   return err;
+}
+
+#endif
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/rsa/rsa_exptmod.c,v $ */
+/* $Revision: 1.18 $ */
+/* $Date: 2007/05/12 14:32:35 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/rsa/rsa_free.c b/crypto/userspace/libtomcrypt/pk/rsa/rsa_free.c
new file mode 100644
index 0000000..d38b266
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/rsa/rsa_free.c
@@ -0,0 +1,34 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/**
+  @file rsa_free.c
+  Free an RSA key, Tom St Denis
+*/  
+
+#ifdef LTC_MRSA
+
+/**
+  Free an RSA key from memory
+  @param key   The RSA key to free
+*/
+void rsa_free(rsa_key *key)
+{
+   LTC_ARGCHKVD(key != NULL);
+   mp_clear_multi(&key->e, &key->d, &key->N, &key->dQ, &key->dP, &key->qP, &key->p, &key->q, NULL);
+}
+
+#endif
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/rsa/rsa_free.c,v $ */
+/* $Revision: 1.10 $ */
+/* $Date: 2007/05/12 14:32:35 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/rsa/rsa_import.c b/crypto/userspace/libtomcrypt/pk/rsa/rsa_import.c
new file mode 100644
index 0000000..8bd8c47
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/rsa/rsa_import.c
@@ -0,0 +1,128 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+#include <linux/slab.h>
+
+/**
+  @file rsa_import.c
+  Import a LTC_PKCS RSA key, Tom St Denis
+*/  
+
+#ifdef LTC_MRSA
+
+/**
+  Import an RSAPublicKey or RSAPrivateKey [two-prime only, only support >= 1024-bit keys, defined in LTC_PKCS #1 v2.1]
+  @param in      The packet to import from
+  @param inlen   It's length (octets)
+  @param key     [out] Destination for newly imported key
+  @return CRYPT_OK if successful, upon error allocated memory is freed
+*/
+int rsa_import(const unsigned char *in, unsigned long inlen, rsa_key *key)
+{
+   int           err;
+   mp_int        zero;
+   unsigned char *tmpbuf=NULL;
+   unsigned long tmpbuf_len;
+
+   LTC_ARGCHK(in          != NULL);
+   LTC_ARGCHK(key         != NULL);
+
+   /* init key */
+   if ((err = mp_init_multi(&key->e, &key->d, &key->N, &key->dQ, 
+                            &key->dP, &key->qP, &key->p, &key->q, NULL)) != CRYPT_OK) {
+      return err;
+   }
+
+   /* see if the OpenSSL DER format RSA public key will work */
+   tmpbuf_len = MAX_RSA_SIZE * 8;
+   tmpbuf = XCALLOC(1, tmpbuf_len);
+   if (tmpbuf == NULL) {
+       err = CRYPT_MEM;
+       goto LBL_ERR;
+   }
+
+   err = der_decode_subject_public_key_info(in, inlen,
+        PKA_RSA, tmpbuf, &tmpbuf_len,
+        LTC_ASN1_NULL, NULL, 0);
+
+   if (err == CRYPT_OK) { /* SubjectPublicKeyInfo format */
+
+      /* now it should be SEQUENCE { INTEGER, INTEGER } */
+      if ((err = der_decode_sequence_multi(tmpbuf, tmpbuf_len,
+                                           LTC_ASN1_INTEGER, 1UL, &key->N, 
+                                           LTC_ASN1_INTEGER, 1UL, &key->e, 
+                                           LTC_ASN1_EOL,     0UL, NULL)) != CRYPT_OK) {
+         goto LBL_ERR;
+      }
+
+      XFREE(tmpbuf);
+
+      key->type = PK_PUBLIC;
+      return CRYPT_OK;
+   }
+
+   XFREE(tmpbuf);
+
+   /* not SSL public key, try to match against LTC_PKCS #1 standards */
+   if ((err = der_decode_sequence_multi(in, inlen, 
+                                  LTC_ASN1_INTEGER, 1UL, &key->N, 
+                                  LTC_ASN1_EOL,     0UL, NULL)) != CRYPT_OK) {
+      goto LBL_ERR;
+   }
+
+   if (mp_cmp_d(&key->N, 0) == LTC_MP_EQ) {
+      if ((err = mp_init(&zero)) != CRYPT_OK) { 
+         goto LBL_ERR;
+      }
+      /* it's a private key */
+      if ((err = der_decode_sequence_multi(in, inlen, 
+                          LTC_ASN1_INTEGER, 1UL, zero, 
+                          LTC_ASN1_INTEGER, 1UL, &key->N, 
+                          LTC_ASN1_INTEGER, 1UL, &key->e,
+                          LTC_ASN1_INTEGER, 1UL, &key->d, 
+                          LTC_ASN1_INTEGER, 1UL, &key->p, 
+                          LTC_ASN1_INTEGER, 1UL, &key->q, 
+                          LTC_ASN1_INTEGER, 1UL, &key->dP,
+                          LTC_ASN1_INTEGER, 1UL, &key->dQ, 
+                          LTC_ASN1_INTEGER, 1UL, &key->qP, 
+                          LTC_ASN1_EOL,     0UL, NULL)) != CRYPT_OK) {
+         mp_clear(&zero);
+         goto LBL_ERR;
+      }
+      mp_clear(&zero);
+      key->type = PK_PRIVATE;
+   } else if (mp_cmp_d(&key->N, 1) == LTC_MP_EQ) {
+      /* we don't support multi-prime RSA */
+      err = CRYPT_PK_INVALID_TYPE;
+      goto LBL_ERR;
+   } else {
+      /* it's a public key and we lack e */
+      if ((err = der_decode_sequence_multi(in, inlen, 
+                                     LTC_ASN1_INTEGER, 1UL, &key->N, 
+                                     LTC_ASN1_INTEGER, 1UL, &key->e, 
+                                     LTC_ASN1_EOL,     0UL, NULL)) != CRYPT_OK) {
+         goto LBL_ERR;
+      }
+      key->type = PK_PUBLIC;
+   }
+   return CRYPT_OK;
+LBL_ERR:
+   XFREE(tmpbuf);
+   mp_clear_multi(&key->d,  &key->e, &key->N, &key->dQ, &key->dP, &key->qP, &key->p, &key->q, NULL);
+   return err;
+}
+
+#endif /* LTC_MRSA */
+
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/rsa/rsa_import.c,v $ */
+/* $Revision: 1.23 $ */
+/* $Date: 2007/05/12 14:32:35 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/rsa/rsa_make_key.c b/crypto/userspace/libtomcrypt/pk/rsa/rsa_make_key.c
new file mode 100644
index 0000000..6718f09
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/rsa/rsa_make_key.c
@@ -0,0 +1,105 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+
+/**
+  @file rsa_make_key.c
+  RSA key generation, Tom St Denis
+*/  
+
+#ifdef LTC_MRSA
+
+/** 
+   Create an RSA key
+   @param size     The size of the modulus (key size) desired (octets)
+   @param e        The "e" value (public key).  e==65537 is a good choice
+   @param key      [out] Destination of a newly created private key pair
+   @return CRYPT_OK if successful, upon error all allocated ram is freed
+*/
+int rsa_make_key(int size, long e, rsa_key *key)
+{
+   mp_int p, q, tmp1, tmp2, tmp3;
+   int    err;
+
+   LTC_ARGCHK(key         != NULL);
+
+   if ((size < (MIN_RSA_SIZE/8)) || (size > (MAX_RSA_SIZE/8))) {
+      return CRYPT_INVALID_KEYSIZE;
+   }
+
+   if ((e < 3) || ((e & 1) == 0)) {
+      return CRYPT_INVALID_ARG;
+   }
+
+   if ((err = mp_init_multi(&p, &q, &tmp1, &tmp2, &tmp3, NULL)) != CRYPT_OK) {
+      return err;
+   }
+
+   /* make primes p and q (optimization provided by Wayne Scott) */
+   if ((err = mp_set_int(&tmp3, e)) != CRYPT_OK)                      { goto cleanup; }  /* tmp3 = e */
+
+   /* make prime "p" */
+   do {
+       if ((err = rand_prime( &p, size/2)) != CRYPT_OK)  { goto cleanup; }
+       if ((err = mp_sub_d( &p, 1,  &tmp1)) != CRYPT_OK)               { goto cleanup; }  /* tmp1 = p-1 */
+       if ((err = mp_gcd( &tmp1,  &tmp3,  &tmp2)) != CRYPT_OK)          { goto cleanup; }  /* tmp2 = gcd(p-1, e) */
+   } while (mp_cmp_d( &tmp2, 1) != 0);                                                  /* while e divides p-1 */
+
+   /* make prime "q" */
+   do {
+       if ((err = rand_prime( &q, size/2)) != CRYPT_OK)  { goto cleanup; }
+       if ((err = mp_sub_d( &q, 1,  &tmp1)) != CRYPT_OK)               { goto cleanup; } /* tmp1 = q-1 */
+       if ((err = mp_gcd( &tmp1,  &tmp3,  &tmp2)) != CRYPT_OK)          { goto cleanup; } /* tmp2 = gcd(q-1, e) */
+   } while (mp_cmp_d( &tmp2, 1) != 0);                                                 /* while e divides q-1 */
+
+   /* tmp1 = lcm(p-1, q-1) */
+   if ((err = mp_sub_d( &p, 1,  &tmp2)) != CRYPT_OK)                   { goto cleanup; } /* tmp2 = p-1 */
+                                                                                      /* tmp1 = q-1 (previous do/while loop) */
+   if ((err = mp_lcm( &tmp1,  &tmp2,  &tmp1)) != CRYPT_OK)              { goto cleanup; } /* tmp1 = lcm(p-1, q-1) */
+
+   /* make key */
+   if ((err = mp_init_multi(&key->e, &key->d, &key->N, &key->dQ, &key->dP, &key->qP, &key->p, &key->q, NULL)) != CRYPT_OK) {
+      goto cleanup;
+   }
+
+   if ((err = mp_set_int( &key->e, e)) != CRYPT_OK)                     { goto errkey; } /* key->e =  e */
+   if ((err = mp_invmod( &key->e,  &tmp1,  &key->d)) != CRYPT_OK)         { goto errkey; } /* key->d = 1/e mod lcm(p-1,q-1) */
+   if ((err = mp_mul( &p,  &q,  &key->N)) != CRYPT_OK)                    { goto errkey; } /* key->N = pq */
+
+   /* optimize for CRT now */
+   /* find d mod q-1 and d mod p-1 */
+   if ((err = mp_sub_d( &p, 1,  &tmp1)) != CRYPT_OK)                     { goto errkey; } /* tmp1 = q-1 */
+   if ((err = mp_sub_d( &q, 1,  &tmp2)) != CRYPT_OK)                     { goto errkey; } /* tmp2 = p-1 */
+   if ((err = mp_mod( &key->d,  &tmp1,  &key->dP)) != CRYPT_OK)           { goto errkey; } /* dP = d mod p-1 */
+   if ((err = mp_mod( &key->d,  &tmp2,  &key->dQ)) != CRYPT_OK)           { goto errkey; } /* dQ = d mod q-1 */
+   if ((err = mp_invmod( &q,  &p,  &key->qP)) != CRYPT_OK)                { goto errkey; } /* qP = 1/q mod p */
+
+   if ((err = mp_copy( &p,  &key->p)) != CRYPT_OK)                       { goto errkey; }
+   if ((err = mp_copy( &q,  &key->q)) != CRYPT_OK)                       { goto errkey; }
+
+   /* set key type (in this case it's CRT optimized) */
+   key->type = PK_PRIVATE;
+
+   /* return ok and free temps */
+   err       = CRYPT_OK;
+   goto cleanup;
+errkey:
+   mp_clear_multi(&key->d, &key->e, &key->N, &key->dQ, &key->dP, &key->qP, &key->p, &key->q, NULL);
+cleanup:
+   mp_clear_multi(&tmp3, &tmp2, &tmp1, &p, &q, NULL);
+   return err;
+}
+
+#endif
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/rsa/rsa_make_key.c,v $ */
+/* $Revision: 1.16 $ */
+/* $Date: 2007/05/12 14:32:35 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/rsa/rsa_sign_hash.c b/crypto/userspace/libtomcrypt/pk/rsa/rsa_sign_hash.c
new file mode 100644
index 0000000..b3c2f5b
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/rsa/rsa_sign_hash.c
@@ -0,0 +1,130 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+#include "ncr-int.h"
+#include <linux/slab.h>
+
+/**
+  @file rsa_sign_hash.c
+  RSA LTC_PKCS #1 v1.5 and v2 PSS sign hash, Tom St Denis and Andreas Lange
+*/
+
+#ifdef LTC_MRSA
+
+/**
+  LTC_PKCS #1 pad then sign
+  @param in        The hash to sign
+  @param inlen     The length of the hash to sign (octets)
+  @param out       [out] The signature
+  @param outlen    [in/out] The max size and resulting size of the signature
+  @param padding   Type of padding (LTC_LTC_PKCS_1_PSS or LTC_LTC_PKCS_1_V1_5)
+  @param hash      The desired hash
+  @param saltlen   The length of the salt desired (octets)
+  @param key       The private RSA key to use
+  @return CRYPT_OK if successful
+*/
+int rsa_sign_hash_ex(const unsigned char *in,       unsigned long  inlen,
+                           unsigned char *out,      unsigned long *outlen,
+                           int            padding,
+                     const struct algo_properties_st *hash, unsigned long saltlen,
+                           rsa_key *key)
+{
+   unsigned long modulus_bitlen, modulus_bytelen, x, y;
+   int           err;
+
+   LTC_ARGCHK(in       != NULL);
+   LTC_ARGCHK(out      != NULL);
+   LTC_ARGCHK(outlen   != NULL);
+   LTC_ARGCHK(key      != NULL);
+
+   /* valid padding? */
+   if ((padding != LTC_LTC_PKCS_1_V1_5) && (padding != LTC_LTC_PKCS_1_PSS)) {
+     return CRYPT_PK_INVALID_PADDING;
+   }
+
+   if (padding == LTC_LTC_PKCS_1_PSS) {
+     if ((err = hash_is_valid(hash)) != CRYPT_OK) {
+        return err;
+     }
+   }
+
+   /* get modulus len in bits */
+   modulus_bitlen = mp_count_bits((&key->N));
+
+  /* outlen must be at least the size of the modulus */
+  modulus_bytelen = mp_unsigned_bin_size((&key->N));
+  if (modulus_bytelen > *outlen) {
+     *outlen = modulus_bytelen;
+     return CRYPT_BUFFER_OVERFLOW;
+  }
+
+  if (padding == LTC_LTC_PKCS_1_PSS) {
+    /* PSS pad the key */
+    x = *outlen;
+    if ((err = pkcs_1_pss_encode(in, inlen, saltlen, 
+                                 hash, modulus_bitlen, out, &x)) != CRYPT_OK) {
+       return err;
+    }
+  } else {
+    /* LTC_PKCS #1 v1.5 pad the hash */
+    unsigned char *tmpin;
+    ltc_asn1_list digestinfo[2], siginfo[2];
+    oid_st st;
+
+    /* not all hashes have OIDs... so sad */
+    if (hash_get_oid(hash, &st) != CRYPT_OK) {
+       return CRYPT_INVALID_ARG;
+    }
+
+    /* construct the SEQUENCE 
+      SEQUENCE {
+         SEQUENCE {hashoid OID
+                   blah    NULL
+         }
+         hash    OCTET STRING 
+      }
+   */
+    LTC_SET_ASN1(digestinfo, 0, LTC_ASN1_OBJECT_IDENTIFIER, st.OID, st.OIDlen);
+    LTC_SET_ASN1(digestinfo, 1, LTC_ASN1_NULL,              NULL,                          0);
+    LTC_SET_ASN1(siginfo,    0, LTC_ASN1_SEQUENCE,          digestinfo,                    2);
+    LTC_SET_ASN1(siginfo,    1, LTC_ASN1_OCTET_STRING,      in,                            inlen);
+
+    /* allocate memory for the encoding */
+    y = mp_unsigned_bin_size(&key->N);
+    tmpin = XMALLOC(y);
+    if (tmpin == NULL) {
+       return CRYPT_MEM;
+    }
+
+    if ((err = der_encode_sequence(siginfo, 2, tmpin, &y)) != CRYPT_OK) {
+       XFREE(tmpin);
+       return err;
+    }
+
+    x = *outlen;
+    if ((err = pkcs_1_v1_5_encode(tmpin, y, LTC_LTC_PKCS_1_EMSA,
+                                  modulus_bitlen,
+                                  out, &x)) != CRYPT_OK) {
+      XFREE(tmpin);
+      return err;
+    }
+    XFREE(tmpin);
+  }
+
+  /* RSA encode it */
+  return rsa_exptmod(out, x, out, outlen, PK_PRIVATE, key);
+}
+
+#endif /* LTC_MRSA */
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/rsa/rsa_sign_hash.c,v $ */
+/* $Revision: 1.11 $ */
+/* $Date: 2007/05/12 14:32:35 $ */
diff --git a/crypto/userspace/libtomcrypt/pk/rsa/rsa_verify_hash.c b/crypto/userspace/libtomcrypt/pk/rsa/rsa_verify_hash.c
new file mode 100644
index 0000000..b9ef89f
--- /dev/null
+++ b/crypto/userspace/libtomcrypt/pk/rsa/rsa_verify_hash.c
@@ -0,0 +1,170 @@
+/* LibTomCrypt, modular cryptographic library -- Tom St Denis
+ *
+ * LibTomCrypt is a library that provides various cryptographic
+ * algorithms in a highly modular and flexible manner.
+ *
+ * The library is free for all purposes without any express
+ * guarantee it works.
+ *
+ * Tom St Denis, tomstdenis@gmail.com, http://libtom.org
+ */
+#include "tomcrypt.h"
+#include "ncr-int.h"
+#include <linux/slab.h>
+
+/**
+  @file rsa_verify_hash.c
+  RSA LTC_PKCS #1 v1.5 or v2 PSS signature verification, Tom St Denis and Andreas Lange
+*/
+
+#ifdef LTC_MRSA
+
+/**
+  LTC_PKCS #1 de-sign then v1.5 or PSS depad
+  @param sig              The signature data
+  @param siglen           The length of the signature data (octets)
+  @param hash             The hash of the message that was signed
+  @param hashlen          The length of the hash of the message that was signed (octets)
+  @param padding          Type of padding (LTC_LTC_PKCS_1_PSS or LTC_LTC_PKCS_1_V1_5)
+  @param hash_algo        The desired hash
+  @param saltlen          The length of the salt used during signature
+  @param stat             [out] The result of the signature comparison, 1==valid, 0==invalid
+  @param key              The public RSA key corresponding to the key that performed the signature
+  @return CRYPT_OK on success (even if the signature is invalid)
+*/
+int rsa_verify_hash_ex(const unsigned char *sig,      unsigned long siglen,
+                       const unsigned char *hash,     unsigned long hashlen,
+                             int            padding,
+                       const struct algo_properties_st *hash_algo, unsigned long saltlen,
+                             int           *stat,     rsa_key      *key)
+{
+  unsigned long modulus_bitlen, modulus_bytelen, x;
+  int           err;
+  unsigned char *tmpbuf;
+
+  LTC_ARGCHK(hash  != NULL);
+  LTC_ARGCHK(sig   != NULL);
+  LTC_ARGCHK(stat  != NULL);
+  LTC_ARGCHK(key   != NULL);
+
+  /* default to invalid */
+  *stat = 0;
+
+  /* valid padding? */
+
+  if ((padding != LTC_LTC_PKCS_1_V1_5) &&
+      (padding != LTC_LTC_PKCS_1_PSS)) {
+    return CRYPT_PK_INVALID_PADDING;
+  }
+
+  if (padding == LTC_LTC_PKCS_1_PSS) {
+    /* valid hash ? */
+    if ((err = hash_is_valid(hash_algo)) != CRYPT_OK) {
+       return err;
+    }
+  }
+
+  /* get modulus len in bits */
+  modulus_bitlen = mp_count_bits( (&key->N));
+
+  /* outlen must be at least the size of the modulus */
+  modulus_bytelen = mp_unsigned_bin_size( (&key->N));
+  if (modulus_bytelen != siglen) {
+     return CRYPT_INVALID_PACKET;
+  }
+
+  /* allocate temp buffer for decoded sig */
+  tmpbuf = XMALLOC(siglen);
+  if (tmpbuf == NULL) {
+     return CRYPT_MEM;
+  }
+
+  /* RSA decode it  */
+  x = siglen;
+  if ((err = rsa_exptmod(sig, siglen, tmpbuf, &x, PK_PUBLIC, key)) != CRYPT_OK) {
+     XFREE(tmpbuf);
+     return err;
+  }
+
+  /* make sure the output is the right size */
+  if (x != siglen) {
+     XFREE(tmpbuf);
+     return CRYPT_INVALID_PACKET;
+  }
+
+  if (padding == LTC_LTC_PKCS_1_PSS) {
+    /* PSS decode and verify it */
+    err = pkcs_1_pss_decode(hash, hashlen, tmpbuf, x, saltlen, hash_algo, modulus_bitlen, stat);
+  } else {
+    /* LTC_PKCS #1 v1.5 decode it */
+    unsigned char *out;
+    unsigned long outlen, loid[16];
+    int           decoded;
+    ltc_asn1_list digestinfo[2], siginfo[2];
+    oid_st st;
+
+    /* not all hashes have OIDs... so sad */
+    if (hash_get_oid(hash_algo, &st) != CRYPT_OK) {
+       err = CRYPT_INVALID_ARG;
+       goto bail_2;
+    }
+
+    /* allocate temp buffer for decoded hash */
+    outlen = ((modulus_bitlen >> 3) + (modulus_bitlen & 7 ? 1 : 0)) - 3;
+    out    = XMALLOC(outlen);
+    if (out == NULL) {
+      err = CRYPT_MEM;
+      goto bail_2;
+    }
+
+    if ((err = pkcs_1_v1_5_decode(tmpbuf, x, LTC_LTC_PKCS_1_EMSA, modulus_bitlen, out, &outlen, &decoded)) != CRYPT_OK) {
+      XFREE(out);       
+      goto bail_2;
+    }
+
+    /* now we must decode out[0...outlen-1] using ASN.1, test the OID and then test the hash */
+    /* construct the SEQUENCE 
+      SEQUENCE {
+         SEQUENCE {hashoid OID
+                   blah    NULL
+         }
+         hash    OCTET STRING 
+      }
+   */
+    LTC_SET_ASN1(digestinfo, 0, LTC_ASN1_OBJECT_IDENTIFIER, loid, sizeof(loid)/sizeof(loid[0]));
+    LTC_SET_ASN1(digestinfo, 1, LTC_ASN1_NULL,              NULL,                          0);
+    LTC_SET_ASN1(siginfo,    0, LTC_ASN1_SEQUENCE,          digestinfo,                    2);
+    LTC_SET_ASN1(siginfo,    1, LTC_ASN1_OCTET_STRING,      tmpbuf,                        siglen);
+   
+    if ((err = der_decode_sequence(out, outlen, siginfo, 2)) != CRYPT_OK) {
+       XFREE(out);
+       goto bail_2;
+    }
+
+    /* test OID */
+    if ((digestinfo[0].size == st.OIDlen) &&
+        (XMEMCMP(digestinfo[0].data, st.OID, sizeof(unsigned long) * st.OIDlen) == 0) &&
+        (siginfo[1].size == hashlen) &&
+        (XMEMCMP(siginfo[1].data, hash, hashlen) == 0)) {
+       *stat = 1;
+    }
+
+#ifdef LTC_CLEAN_STACK
+    zeromem(out, outlen);
+#endif
+    XFREE(out);
+  }
+
+bail_2:
+#ifdef LTC_CLEAN_STACK
+  zeromem(tmpbuf, siglen);
+#endif
+  XFREE(tmpbuf);
+  return err;
+}
+
+#endif /* LTC_MRSA */
+
+/* $Source: /cvs/libtom/libtomcrypt/src/pk/rsa/rsa_verify_hash.c,v $ */
+/* $Revision: 1.13 $ */
+/* $Date: 2007/05/12 14:32:35 $ */
-- 
1.7.2.1

