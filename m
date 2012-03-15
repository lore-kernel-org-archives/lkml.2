Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734Ab2COIBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 04:01:49 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:45455 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755619Ab2COIBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 04:01:45 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch/unicore32/kernel/dma.c: eliminated unneeded free_irq
Date: Thu, 15 Mar 2012 09:01:38 +0100
Message-Id: <1331798498-13606-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The device remains functional if the second request_irq fails, so the first
one should not be freed.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
diff --git a/arch/unicore32/kernel/dma.c b/arch/unicore32/kernel/dma.c
index ae441bc..6184ff2 100644
--- a/arch/unicore32/kernel/dma.c
+++ b/arch/unicore32/kernel/dma.c
@@ -172,8 +172,9 @@ int __init puv3_init_dma(void)
 
 	ret = request_irq(IRQ_DMAERR, dma_err_handler, 0, "DMAERR", NULL);
 	if (ret) {
+		/* the device remains function if this fails, so don't free
+		   the previously allocated irq */
 		printk(KERN_CRIT "Can't register IRQ for DMAERR\n");
-		free_irq(IRQ_DMA, "DMA");
 		return ret;
 	}
 
