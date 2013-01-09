Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933946Ab3AIUku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:40:50 -0500
Received: from mail.kernel.org ([198.145.19.201]:43565 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933904Ab3AIUkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:40:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 080/123] sparc64: Set CRYPTO_TFM_REQ_MAY_SLEEP consistently in AES code.
Date: Wed,  9 Jan 2013 12:35:19 -0800
Message-Id: <20130109201508.868544845@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit b35d282ef7345320b594d48d8d70caedfa962a01 ]

We use the FPU and therefore cannot sleep during the crypto
loops.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/crypto/aes_glue.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/sparc/crypto/aes_glue.c
+++ b/arch/sparc/crypto/aes_glue.c
@@ -222,6 +222,7 @@ static int ecb_encrypt(struct blkcipher_
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	ctx->ops->load_encrypt_keys(&ctx->key[0]);
 	while ((nbytes = walk.nbytes)) {
@@ -251,6 +252,7 @@ static int ecb_decrypt(struct blkcipher_
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	ctx->ops->load_decrypt_keys(&ctx->key[0]);
 	key_end = &ctx->key[ctx->expanded_key_length / sizeof(u64)];
@@ -280,6 +282,7 @@ static int cbc_encrypt(struct blkcipher_
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	ctx->ops->load_encrypt_keys(&ctx->key[0]);
 	while ((nbytes = walk.nbytes)) {
@@ -309,6 +312,7 @@ static int cbc_decrypt(struct blkcipher_
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	ctx->ops->load_decrypt_keys(&ctx->key[0]);
 	key_end = &ctx->key[ctx->expanded_key_length / sizeof(u64)];


