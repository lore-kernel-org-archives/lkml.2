Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933944Ab3AIU7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:59:00 -0500
Received: from mail.kernel.org ([198.145.19.201]:43607 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933905Ab3AIUkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:40:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 082/123] sparc64: Set CRYPTO_TFM_REQ_MAY_SLEEP consistently in DES code.
Date: Wed,  9 Jan 2013 12:35:21 -0800
Message-Id: <20130109201509.145404071@linuxfoundation.org>
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

[ Upstream commit b3a37947074fa0a488d6c7ede58125b2278ab4e8 ]

We use the FPU and therefore cannot sleep during the crypto
loops.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/crypto/des_glue.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/sparc/crypto/des_glue.c
+++ b/arch/sparc/crypto/des_glue.c
@@ -100,6 +100,7 @@ static int __ecb_crypt(struct blkcipher_
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	if (encrypt)
 		des_sparc64_load_keys(&ctx->encrypt_expkey[0]);
@@ -147,6 +148,7 @@ static int cbc_encrypt(struct blkcipher_
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	des_sparc64_load_keys(&ctx->encrypt_expkey[0]);
 	while ((nbytes = walk.nbytes)) {
@@ -177,6 +179,7 @@ static int cbc_decrypt(struct blkcipher_
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	des_sparc64_load_keys(&ctx->decrypt_expkey[0]);
 	while ((nbytes = walk.nbytes)) {
@@ -266,6 +269,7 @@ static int __ecb3_crypt(struct blkcipher
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	if (encrypt)
 		K = &ctx->encrypt_expkey[0];
@@ -317,6 +321,7 @@ static int cbc3_encrypt(struct blkcipher
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	K = &ctx->encrypt_expkey[0];
 	des3_ede_sparc64_load_keys(K);
@@ -352,6 +357,7 @@ static int cbc3_decrypt(struct blkcipher
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	K = &ctx->decrypt_expkey[0];
 	des3_ede_sparc64_load_keys(K);


