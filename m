Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab1JJKz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 06:55:57 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:37323 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113Ab1JJKz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 06:55:56 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, herbert@gondor.hengli.com.au,
        davem@davemloft.net, Richard Weinberger <richard@nod.at>
Subject: [PATCH] crypto: Make hifn_795x build depend on !ARCH_DMA_ADDR_T_64BIT
Date: Mon, 10 Oct 2011 12:55:41 +0200
Message-Id: <1318244141-10879-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hifn_795x works only on 32 bit, remove the detection while loading
the module and catch non-32 bit systems at build time.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/crypto/Kconfig     |    1 +
 drivers/crypto/hifn_795x.c |    6 ++----
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index e0b25de..fdbb726 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -200,6 +200,7 @@ config CRYPTO_DEV_HIFN_795X
 	select CRYPTO_BLKCIPHER
 	select HW_RANDOM if CRYPTO_DEV_HIFN_795X_RNG
 	depends on PCI
+	depends on !ARCH_DMA_ADDR_T_64BIT
 	help
 	  This option allows you to have support for HIFN 795x crypto adapters.
 
diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index a84250a..fe765f4 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -2744,10 +2744,8 @@ static int __init hifn_init(void)
 	unsigned int freq;
 	int err;
 
-	if (sizeof(dma_addr_t) > 4) {
-		printk(KERN_INFO "HIFN supports only 32-bit addresses.\n");
-		return -EINVAL;
-	}
+	/* HIFN supports only 32-bit addresses */
+	BUILD_BUG_ON(sizeof(dma_addr_t) != 4);
 
 	if (strncmp(hifn_pll_ref, "ext", 3) &&
 	    strncmp(hifn_pll_ref, "pci", 3)) {
-- 
1.7.7

