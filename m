Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934027Ab3AIU6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:58:17 -0500
Received: from mail.kernel.org ([198.145.19.201]:43625 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932526Ab3AIUko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:40:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 083/123] sparc64: Set CRYPTO_TFM_REQ_MAY_SLEEP consistently in CAMELLIA code.
Date: Wed,  9 Jan 2013 12:35:22 -0800
Message-Id: <20130109201509.274230227@linuxfoundation.org>
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

[ Upstream commit 62ba63dc892cf836ecb9ce4fdb7644d45c95070b ]

We use the FPU and therefore cannot sleep during the crypto
loops.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/crypto/camellia_glue.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/sparc/crypto/camellia_glue.c
+++ b/arch/sparc/crypto/camellia_glue.c
@@ -98,6 +98,7 @@ static int __ecb_crypt(struct blkcipher_
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	if (encrypt)
 		key = &ctx->encrypt_key[0];
@@ -160,6 +161,7 @@ static int cbc_encrypt(struct blkcipher_
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	key = &ctx->encrypt_key[0];
 	camellia_sparc64_load_keys(key, ctx->key_len);
@@ -198,6 +200,7 @@ static int cbc_decrypt(struct blkcipher_
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	key = &ctx->decrypt_key[0];
 	camellia_sparc64_load_keys(key, ctx->key_len);


