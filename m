Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab2AIJlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 04:41:21 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:36972 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227Ab2AIJlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 04:41:00 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: kernel-janitors@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 3/4] drivers/crypto/ixp4xx_crypto.c: convert GFP_KERNEL to GFP_ATOMIC
Date: Mon,  9 Jan 2012 10:40:49 +0100
Message-Id: <1326102050-30265-3-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia.lawall@lip6.fr>

The function is called with locks held and thus should not use GFP_KERNEL.

The semantic patch that makes this report is available
in scripts/coccinelle/locks/call_kern.cocci.

More information about semantic patching is available at
http://coccinelle.lip6.fr/

Signed-off-by: Julia Lawall <julia.lawall@lip6.fr>

---
 drivers/crypto/ixp4xx_crypto.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 4c20c5b..bc349cc 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -265,7 +265,7 @@ static int setup_crypt_desc(void)
 	BUILD_BUG_ON(sizeof(struct crypt_ctl) != 64);
 	crypt_virt = dma_alloc_coherent(dev,
 			NPE_QLEN * sizeof(struct crypt_ctl),
-			&crypt_phys, GFP_KERNEL);
+			&crypt_phys, GFP_ATOMIC);
 	if (!crypt_virt)
 		return -ENOMEM;
 	memset(crypt_virt, 0, NPE_QLEN * sizeof(struct crypt_ctl));

