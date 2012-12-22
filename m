Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750939Ab2LVFx5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 00:53:57 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:41550 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab2LVFxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 00:53:54 -0500
Message-ID: <1356155625.6843.0.camel@phoenix>
Subject: [PATCH] dma: intel_mid: Remove return statements at the end of all
 void functions
From: Axel Lin <axel.lin@ingics.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>, linux-kernel@vger.kernel.org
Date: Sat, 22 Dec 2012 13:53:45 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/dma/intel_mid_dma.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
index bc764af..1a83d1d 100644
--- a/drivers/dma/intel_mid_dma.c
+++ b/drivers/dma/intel_mid_dma.c
@@ -133,7 +133,6 @@ static void dmac1_mask_periphral_intr(struct middma_device *mid)
 		pimr |= mid->pimr_mask;
 		writel(pimr, mid->mask_reg + LNW_PERIPHRAL_MASK);
 	}
-	return;
 }
 
 /**
@@ -154,7 +153,6 @@ static void dmac1_unmask_periphral_intr(struct intel_mid_dma_chan *midc)
 		pimr &= ~mid->pimr_mask;
 		writel(pimr, mid->mask_reg + LNW_PERIPHRAL_MASK);
 	}
-	return;
 }
 
 /**
@@ -172,7 +170,6 @@ static void enable_dma_interrupt(struct intel_mid_dma_chan *midc)
 	/*en ch interrupts*/
 	iowrite32(UNMASK_INTR_REG(midc->ch_id), midc->dma_base + MASK_TFR);
 	iowrite32(UNMASK_INTR_REG(midc->ch_id), midc->dma_base + MASK_ERR);
-	return;
 }
 
 /**
@@ -189,7 +186,6 @@ static void disable_dma_interrupt(struct intel_mid_dma_chan *midc)
 	iowrite32(MASK_INTR_REG(midc->ch_id), midc->dma_base + MASK_BLOCK);
 	iowrite32(MASK_INTR_REG(midc->ch_id), midc->dma_base + MASK_TFR);
 	iowrite32(MASK_INTR_REG(midc->ch_id), midc->dma_base + MASK_ERR);
-	return;
 }
 
 /*****************************************************************************
@@ -341,8 +337,7 @@ static void midc_scan_descriptors(struct middma_device *mid,
 		if (desc->status == DMA_IN_PROGRESS)
 			midc_descriptor_complete(midc, desc);
 	}
-	return;
-	}
+}
 /**
  * midc_lli_fill_sg -		Helper function to convert
  *				SG list to Linked List Items.
@@ -992,7 +987,6 @@ static void dma_tasklet(unsigned long data)
 		spin_unlock_bh(&midc->lock);
 	}
 	pr_debug("MDMA:Exiting takslet...\n");
-	return;
 }
 
 static void dma_tasklet1(unsigned long data)
@@ -1214,7 +1208,6 @@ static void middma_shutdown(struct pci_dev *pdev)
 	if (device->dma_base)
 		iounmap(device->dma_base);
 	free_irq(pdev->irq, device);
-	return;
 }
 
 /**
-- 
1.7.9.5



