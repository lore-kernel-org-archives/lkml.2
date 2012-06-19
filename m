Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab2FSKeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 06:34:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:43518 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754129Ab2FSKee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 06:34:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="155363486"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv2 07/10] dw_dmac: disable BLOCK interrupts
Date: Tue, 19 Jun 2012 13:34:07 +0300
Message-Id: <1340102050-12697-8-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1340102050-12697-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1339743913-6236-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1340102050-12697-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just to be sure we are in known state we disable the BLOCK interupts.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 23a409b..42cffe8 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1439,6 +1439,9 @@ static int __init dw_probe(struct platform_device *pdev)
 	/* force dma off, just in case */
 	dw_dma_off(dw);
 
+	/* disable BLOCK interrupts as well */
+	channel_clear_bit(dw, MASK.BLOCK, dw->all_chan_mask);
+
 	err = request_irq(irq, dw_dma_interrupt, 0, "dw_dmac", dw);
 	if (err)
 		goto err_irq;
@@ -1478,6 +1481,7 @@ static int __init dw_probe(struct platform_device *pdev)
 
 	/* Clear all interrupts on all channels. */
 	dma_writel(dw, CLEAR.XFER, dw->all_chan_mask);
+	dma_writel(dw, CLEAR.BLOCK, dw->all_chan_mask);
 	dma_writel(dw, CLEAR.SRC_TRAN, dw->all_chan_mask);
 	dma_writel(dw, CLEAR.DST_TRAN, dw->all_chan_mask);
 	dma_writel(dw, CLEAR.ERROR, dw->all_chan_mask);
-- 
1.7.10

