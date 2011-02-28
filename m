Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751163Ab1B1FJB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 00:09:01 -0500
Received: from mga11.intel.com ([192.55.52.93]:64630 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802Ab1B1FI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 00:08:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,238,1297065600"; 
   d="scan'208";a="891819111"
From: Mark Allyn <mark.a.allyn@intel.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com, mark.a.allyn@intel.com,
        alan@linux.intel.com
Subject: RFC: [PATCH 3/5] staging: sep: add sep_crypto.h header
Date: Sun, 27 Feb 2011 21:11:32 -0800
Message-Id: <1298869892-4357-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>
---
 drivers/staging/sep/sep_crypto.h |  315 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 315 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/sep/sep_crypto.h

diff --git a/drivers/staging/sep/sep_crypto.h b/drivers/staging/sep/sep_crypto.h
new file mode 100644
index 0000000..10a9425
--- /dev/null
+++ b/drivers/staging/sep/sep_crypto.h
@@ -0,0 +1,315 @@
+/*
+ *
+ *  sep_crypto.h - Crypto interface structures
+ *
+ *  Copyright(c) 2009,2011 Intel Corporation. All rights reserved.
+ *  Contributions(c) 2009,2010 Discretix. All rights reserved.
+ *
+ *  This program is free software; you can redistribute it and/or modify it
+ *  under the terms of the GNU General Public License as published by the Free
+ *  Software Foundation; version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful, but WITHOUT
+ *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ *  more details.
+ *
+ *  You should have received a copy of the GNU General Public License along with
+ *  this program; if not, write to the Free Software Foundation, Inc., 59
+ *  Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ *
+ *  CONTACTS:
+ *
+ *  Mark Allyn		mark.a.allyn@intel.com
+ *  Jayant Mangalampalli jayant.mangalampalli@intel.com
+ *
+ *  CHANGES:
+ *
+ *  2009.06.26	Initial publish
+ *  2011.02.22  Enable Kernel Crypto
+ *
+ */
+
+/* Constants for SEP (from vendor) */
+#define SEP_START_MSG_TOKEN	0x02558808
+
+#define SEP_DES_IV_SIZE_WORDS	2
+#define SEP_DES_IV_SIZE_BYTES	(SEP_DES_IV_SIZE_WORDS * \
+	sizeof(u32))
+#define SEP_DES_KEY_SIZE_WORDS	2
+#define SEP_DES_KEY_SIZE_BYTES	(SEP_DES_KEY_SIZE_WORDS * \
+	sizeof(u32))
+#define SEP_DES_BLOCK_SIZE	8
+#define SEP_DES_DUMMY_SIZE	16
+
+#define SEP_DES_INIT_OPCODE	0x10
+#define SEP_DES_BLOCK_OPCODE	0x11
+
+#define SEP_AES_BLOCK_SIZE_WORDS 4
+#define SEP_AES_BLOCK_SIZE_BYTES \
+	(SEP_AES_BLOCK_SIZE_WORDS * sizeof(u32))
+
+#define SEP_AES_DUMMY_BLOCK_SIZE 16
+#define SEP_AES_IV_SIZE_WORDS	SEP_AES_BLOCK_SIZE_WORDS
+#define SEP_AES_IV_SIZE_BYTES \
+	(SEP_AES_IV_SIZE_WORDS * sizeof(u32))
+
+#define SEP_AES_KEY_128_SIZE	16
+#define SEP_AES_KEY_192_SIZE	24
+#define SEP_AES_KEY_256_SIZE	32
+#define SEP_AES_KEY_512_SIZE	64
+#define SEP_AES_MAX_KEY_SIZE_WORDS	16
+#define SEP_AES_MAX_KEY_SIZE_BYTES \
+	(SEP_AES_MAX_KEY_SIZE_WORDS * sizeof(u32))
+
+#define SEP_AES_WRAP_MIN_SIZE	8
+#define SEP_AES_WRAP_MAX_SIZE	0x10000000
+
+#define SEP_AES_WRAP_BLOCK_SIZE_WORDS	2
+#define SEP_AES_WRAP_BLOCK_SIZE_BYTES \
+	(SEP_AES_WRAP_BLOCK_SIZE_WORDS * sizeof(u32))
+
+#define SEP_AES_SECRET_RKEK1		0x1
+#define SEP_AES_SECRET_RKEK2		0x2
+
+#define SEP_AES_INIT_OPCODE		0x2
+#define SEP_AES_BLOCK_OPCODE		0x3
+#define SEP_AES_FINISH_OPCODE		0x4
+#define SEP_AES_WRAP_OPCODE		0x6
+#define SEP_AES_UNWRAP_OPCODE		0x7
+#define SEP_AES_XTS_FINISH_OPCODE	0x8
+
+#define SEP_HASH_RESULT_SIZE_WORDS	16
+#define SEP_MD5_DIGEST_SIZE_WORDS	4
+#define SEP_MD5_DIGEST_SIZE_BYTES \
+	(SEP_MD5_DIGEST_SIZE_WORDS * sizeof(u32))
+#define SEP_SHA1_DIGEST_SIZE_WORDS	5
+#define SEP_SHA1_DIGEST_SIZE_BYTES \
+	(SEP_SHA1_DIGEST_SIZE_WORDS * sizeof(u32))
+#define SEP_SHA224_DIGEST_SIZE_WORDS	7
+#define SEP_SHA224_DIGEST_SIZE_BYTES \
+	(SEP_SHA224_DIGEST_SIZE_WORDS * sizeof(u32))
+#define SEP_SHA256_DIGEST_SIZE_WORDS	8
+#define SEP_SHA256_DIGEST_SIZE_BYTES \
+	(SEP_SHA256_DIGEST_SIZE_WORDS * sizeof(u32))
+#define SEP_SHA384_DIGEST_SIZE_WORDS	12
+#define SEP_SHA384_DIGEST_SIZE_BYTES \
+	(SEP_SHA384_DIGEST_SIZE_WORDS * sizeof(u32))
+#define SEP_SHA512_DIGEST_SIZE_WORDS	16
+#define SEP_SHA512_DIGEST_SIZE_BYTES \
+	(SEP_SHA512_DIGEST_SIZE_WORDS * sizeof(u32))
+#define SEP_HASH_BLOCK_SIZE_WORDS	16
+#define SEP_HASH_BLOCK_SIZE_BYTES \
+	(SEP_HASH_BLOCK_SIZE_WORDS * sizeof(u32))
+#define SEP_SHA2_BLOCK_SIZE_WORDS	32
+#define SEP_SHA2_BLOCK_SIZE_BYTES \
+	(SEP_SHA2_BLOCK_SIZE_WORDS * sizeof(u32))
+
+#define SEP_HASH_INIT_OPCODE		0x20
+#define SEP_HASH_UPDATE_OPCODE		0x21
+#define SEP_HASH_FINISH_OPCODE		0x22
+#define SEP_HASH_SINGLE_OPCODE		0x23
+
+#define SEP_HOST_ERROR		0x0b000000
+#define SEP_OK			0x0
+#define SEP_INVALID_START	(SEP_HOST_ERROR + 0x3)
+#define SEP_WRONG_OPCODE	(SEP_HOST_ERROR + 0x1)
+
+/* Macros */
+#ifndef __LITTLE_ENDIAN
+#define CHG_ENDIAN(val) \
+	(((val) >> 24) | \
+	(((val) & 0x00FF0000) >> 8) | \
+	(((val) & 0x0000FF00) << 8) | \
+	(((val) & 0x000000FF) << 24))
+#else
+#define CHG_ENDIAN(val) val
+#endif
+/* Enums for SEP (from vendor) */
+enum des_numkey {
+	DES_KEY_1 = 1,
+	DES_KEY_2 = 2,
+	DES_KEY_3 = 3,
+	SEP_NUMKEY_OPTIONS,
+	SEP_NUMKEY_LAST = 0x7fffffff,
+};
+
+enum des_enc_mode {
+	SEP_DES_ENCRYPT = 0,
+	SEP_DES_DECRYPT = 1,
+	SEP_DES_ENC_OPTIONS,
+	SEP_DES_ENC_LAST = 0x7fffffff,
+};
+
+enum des_op_mode {
+	SEP_DES_ECB = 0,
+	SEP_DES_CBC = 1,
+	SEP_OP_OPTIONS,
+	SEP_OP_LAST = 0x7fffffff,
+};
+
+enum aes_keysize {
+	AES_128 = 0,
+	AES_192 = 1,
+	AES_256 = 2,
+	AES_512 = 3,
+	AES_SIZE_OPTIONS,
+	AEA_SIZE_LAST = 0x7FFFFFFF,
+};
+
+enum aes_enc_mode {
+	SEP_AES_ENCRYPT = 0,
+	SEP_AES_DECRYPT = 1,
+	SEP_AES_ENC_OPTIONS,
+	SEP_AES_ENC_LAST = 0x7FFFFFFF,
+};
+
+enum aes_op_mode {
+	SEP_AES_ECB = 0,
+	SEP_AES_CBC = 1,
+	SEP_AES_MAC = 2,
+	SEP_AES_CTR = 3,
+	SEP_AES_XCBC = 4,
+	SEP_AES_CMAC = 5,
+	SEP_AES_XTS = 6,
+	SEP_AES_OP_OPTIONS,
+	SEP_AES_OP_LAST = 0x7FFFFFFF,
+};
+
+enum hash_op_mode {
+	SEP_HASH_SHA1 = 0,
+	SEP_HASH_SHA224 = 1,
+	SEP_HASH_SHA256 = 2,
+	SEP_HASH_SHA384 = 3,
+	SEP_HASH_SHA512 = 4,
+	SEP_HASH_MD5 = 5,
+	SEP_HASH_OPTIONS,
+	SEP_HASH_LAST_MODE = 0x7FFFFFFF,
+};
+
+/* Structures for SEP (from vendor) */
+struct sep_des_internal_key {
+	u32 key1[SEP_DES_KEY_SIZE_WORDS];
+	u32 key2[SEP_DES_KEY_SIZE_WORDS];
+	u32 key3[SEP_DES_KEY_SIZE_WORDS];
+};
+
+struct sep_des_internal_context {
+	u32 iv_context[SEP_DES_IV_SIZE_WORDS];
+	struct sep_des_internal_key context_key;
+	enum des_numkey nbr_keys;
+	enum des_enc_mode encryption;
+	enum des_op_mode operation;
+	u8 dummy_block[SEP_DES_DUMMY_SIZE];
+};
+
+struct sep_des_private_context {
+	u32 valid_tag;
+	u32 iv;
+	u8 ctx_buf[sizeof(struct sep_des_internal_context)];
+};
+
+/* This is the structure passed to SEP via msg area */
+struct sep_des_key {
+	u32 key1[SEP_DES_KEY_SIZE_WORDS];
+	u32 key2[SEP_DES_KEY_SIZE_WORDS];
+	u32 key3[SEP_DES_KEY_SIZE_WORDS];
+	u32 pad[SEP_DES_KEY_SIZE_WORDS];
+};
+
+struct sep_aes_internal_context {
+	u32 aes_ctx_iv[SEP_AES_IV_SIZE_WORDS];
+	u32 aes_ctx_key[SEP_AES_MAX_KEY_SIZE_WORDS / 2];
+	enum aes_keysize keysize;
+	enum aes_enc_mode encmode;
+	enum aes_op_mode opmode;
+	u8 secret_key;
+	u32 no_add_blocks;
+	u32 last_block_size;
+	u32 last_block[SEP_AES_BLOCK_SIZE_WORDS];
+	u32 prev_iv[SEP_AES_BLOCK_SIZE_WORDS];
+	u32 remaining_size;
+	union {
+		struct {
+			u32 dkey1[SEP_AES_BLOCK_SIZE_WORDS];
+			u32 dkey2[SEP_AES_BLOCK_SIZE_WORDS];
+			u32 dkey3[SEP_AES_BLOCK_SIZE_WORDS];
+		} cmac_data;
+		struct {
+			u32 xts_key[SEP_AES_MAX_KEY_SIZE_WORDS / 2];
+			u32 temp1[SEP_AES_BLOCK_SIZE_WORDS];
+			u32 temp2[SEP_AES_BLOCK_SIZE_WORDS];
+		} xtx_data;
+	} s_data;
+	u8 dummy_block[SEP_AES_DUMMY_BLOCK_SIZE];
+};
+
+struct sep_aes_private_context {
+	u32 valid_tag;
+	u32 aes_iv;
+	u32 op_mode;
+	u8 cbuff[sizeof(struct sep_aes_internal_context)];
+};
+
+struct sep_hash_internal_context {
+	u32 hash_result[SEP_HASH_RESULT_SIZE_WORDS];
+	enum hash_op_mode hash_opmode;
+	u32 previous_data[SEP_SHA2_BLOCK_SIZE_WORDS];
+	u16 prev_update_bytes;
+	u32 total_proc_128bit[4];
+	u16 op_mode_block_size;
+	u8 dummy_aes_block[SEP_AES_DUMMY_BLOCK_SIZE];
+};
+
+struct sep_hash_private_context {
+	u32 valid_tag;
+	u32 iv;
+	u8 internal_context[sizeof(struct sep_hash_internal_context)];
+};
+
+/* Context structures for crypto API */
+struct sep_block_ctx {
+	struct sep_device *sep;
+	u32 done;
+	unsigned char iv[100];
+	enum des_enc_mode des_encmode;
+	enum des_op_mode des_opmode;
+	enum aes_enc_mode aes_encmode;
+	enum aes_op_mode aes_opmode;
+	size_t data_length;
+	size_t ivlen;
+	struct ablkcipher_walk walk;
+	struct sep_des_private_context des_private_ctx;
+	struct sep_aes_private_context aes_private_ctx;
+	};
+
+struct sep_hash_ctx {
+	u32 done;
+	unsigned char *buf;
+	size_t buflen;
+	unsigned char *dgst;
+	int digest_size_words;
+	int digest_size_bytes;
+	int block_size_words;
+	int block_size_bytes;
+	struct scatterlist *sg;
+	enum hash_op_mode hash_opmode;
+	struct sep_hash_private_context hash_private_ctx;
+	};
+
+struct sep_system_ctx {
+	struct sep_device *sep_used;
+	union key_t {
+		struct sep_des_key des;
+		u32 aes[SEP_AES_MAX_KEY_SIZE_WORDS];
+	} key;
+	size_t keylen;
+	enum des_numkey des_nbr_keys;
+	enum aes_keysize aes_key_size;
+	u32 key_sent; /* Indicate if key is sent to sep */
+	u32 last_block; /* Indicate that this is the final block */
+	};
+
+/* Functions */
+int sep_crypto_setup(void);
+void sep_crypto_takedown(void);
-- 
1.6.3.3

