Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab2HSC76 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 22:59:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:30195 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358Ab2HSC50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="182422064"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>, herbert@gondor.hengli.com.au
Subject: [PATCH 35/74] lto, crypto, aes: mark AES tables __visible
Date: Sat, 18 Aug 2012 19:56:31 -0700
Message-Id: <1345345030-22211-36-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Various tables in aes_generic are accessed by assembler code.
Mark them __visible for LTO

Cc: herbert@gondor.apana.org.au
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 crypto/aes_generic.c |    8 ++++----
 include/crypto/aes.h |    8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/crypto/aes_generic.c b/crypto/aes_generic.c
index a68c73d..1cf1f89 100644
--- a/crypto/aes_generic.c
+++ b/crypto/aes_generic.c
@@ -62,7 +62,7 @@ static inline u8 byte(const u32 x, const unsigned n)
 
 static const u32 rco_tab[10] = { 1, 2, 4, 8, 16, 32, 64, 128, 27, 54 };
 
-const u32 crypto_ft_tab[4][256] = {
+__visible const u32 crypto_ft_tab[4][256] = {
 	{
 		0xa56363c6, 0x847c7cf8, 0x997777ee, 0x8d7b7bf6,
 		0x0df2f2ff, 0xbd6b6bd6, 0xb16f6fde, 0x54c5c591,
@@ -326,7 +326,7 @@ const u32 crypto_ft_tab[4][256] = {
 	}
 };
 
-const u32 crypto_fl_tab[4][256] = {
+__visible const u32 crypto_fl_tab[4][256] = {
 	{
 		0x00000063, 0x0000007c, 0x00000077, 0x0000007b,
 		0x000000f2, 0x0000006b, 0x0000006f, 0x000000c5,
@@ -590,7 +590,7 @@ const u32 crypto_fl_tab[4][256] = {
 	}
 };
 
-const u32 crypto_it_tab[4][256] = {
+__visible const u32 crypto_it_tab[4][256] = {
 	{
 		0x50a7f451, 0x5365417e, 0xc3a4171a, 0x965e273a,
 		0xcb6bab3b, 0xf1459d1f, 0xab58faac, 0x9303e34b,
@@ -854,7 +854,7 @@ const u32 crypto_it_tab[4][256] = {
 	}
 };
 
-const u32 crypto_il_tab[4][256] = {
+__visible const u32 crypto_il_tab[4][256] = {
 	{
 		0x00000052, 0x00000009, 0x0000006a, 0x000000d5,
 		0x00000030, 0x00000036, 0x000000a5, 0x00000038,
diff --git a/include/crypto/aes.h b/include/crypto/aes.h
index 7524ba3..f30d38d 100644
--- a/include/crypto/aes.h
+++ b/include/crypto/aes.h
@@ -27,10 +27,10 @@ struct crypto_aes_ctx {
 	u32 key_length;
 };
 
-extern const u32 crypto_ft_tab[4][256];
-extern const u32 crypto_fl_tab[4][256];
-extern const u32 crypto_it_tab[4][256];
-extern const u32 crypto_il_tab[4][256];
+extern __visible const u32 crypto_ft_tab[4][256];
+extern __visible const u32 crypto_fl_tab[4][256];
+extern __visible const u32 crypto_it_tab[4][256];
+extern __visible const u32 crypto_il_tab[4][256];
 
 int crypto_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 		unsigned int key_len);
-- 
1.7.7.6

