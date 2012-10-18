Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151Ab2JROfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 10:35:19 -0400
Received: from mga03.intel.com ([143.182.124.21]:5217 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752931Ab2JROeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 10:34:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,607,1344236400"; 
   d="scan'208";a="206091408"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>,
        balbi@ti.com
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv3 3/6] dw_dmac: change dev_printk() to corresponding macros
Date: Thu, 18 Oct 2012 17:34:09 +0300
Message-Id: <1350570852-10398-4-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1350570852-10398-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1350570852-10398-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change printk(KERN_INFO ..., dev_name(...), ...) to dev_info() as well.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index c27c125..d4ddf48 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -456,9 +456,8 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
 
 static inline void dwc_dump_lli(struct dw_dma_chan *dwc, struct dw_lli *lli)
 {
-	dev_printk(KERN_CRIT, chan2dev(&dwc->chan),
-			"  desc: s0x%x d0x%x l0x%x c0x%x:%x\n",
-			lli->sar, lli->dar, lli->llp, lli->ctlhi, lli->ctllo);
+	dev_crit(chan2dev(&dwc->chan), "  desc: s0x%x d0x%x l0x%x c0x%x:%x\n",
+		 lli->sar, lli->dar, lli->llp, lli->ctlhi, lli->ctllo);
 }
 
 static void dwc_handle_error(struct dw_dma *dw, struct dw_dma_chan *dwc)
@@ -492,10 +491,8 @@ static void dwc_handle_error(struct dw_dma *dw, struct dw_dma_chan *dwc)
 	 * controller flagged an error instead of scribbling over
 	 * random memory locations.
 	 */
-	dev_printk(KERN_CRIT, chan2dev(&dwc->chan),
-			"Bad descriptor submitted for DMA!\n");
-	dev_printk(KERN_CRIT, chan2dev(&dwc->chan),
-			"  cookie: %d\n", bad_desc->txd.cookie);
+	dev_crit(chan2dev(&dwc->chan), "Bad descriptor submitted for DMA!\n");
+	dev_crit(chan2dev(&dwc->chan), "  cookie: %d\n", bad_desc->txd.cookie);
 	dwc_dump_lli(dwc, &bad_desc->lli);
 	list_for_each_entry(child, &bad_desc->tx_list, desc_node)
 		dwc_dump_lli(dwc, &child->lli);
@@ -1625,8 +1622,8 @@ static int __devinit dw_probe(struct platform_device *pdev)
 
 	dma_writel(dw, CFG, DW_CFG_DMA_EN);
 
-	printk(KERN_INFO "%s: DesignWare DMA Controller, %d channels\n",
-			dev_name(&pdev->dev), nr_channels);
+	dev_info(&pdev->dev, "DesignWare DMA Controller, %d channels\n",
+		 nr_channels);
 
 	dma_async_device_register(&dw->dma);
 
-- 
1.7.10.4

