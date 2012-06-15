Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757Ab2FOHGf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 03:06:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:45072 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754122Ab2FOHFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 03:05:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="153567555"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Viresh Kumar <viresh.kumar@st.com>, Vinod Koul <vinod.koul@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 7/9] dw_dmac: disable BLOCK interrupts
Date: Fri, 15 Jun 2012 10:05:11 +0300
Message-Id: <1339743913-6236-8-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1339743913-6236-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1339743913-6236-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just to be sure we are in known state we disable the BLOCK interupts.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index cffe630..b2586bd 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -575,6 +575,7 @@ static irqreturn_t dw_dma_interrupt(int irq, void *dev_id)
 
 		/* Try to recover */
 		channel_clear_bit(dw, MASK.XFER, (1 << 8) - 1);
+		channel_clear_bit(dw, MASK.BLOCK, (1 << 8) - 1);
 		channel_clear_bit(dw, MASK.SRC_TRAN, (1 << 8) - 1);
 		channel_clear_bit(dw, MASK.DST_TRAN, (1 << 8) - 1);
 		channel_clear_bit(dw, MASK.ERROR, (1 << 8) - 1);
@@ -1376,6 +1377,7 @@ static void dw_dma_off(struct dw_dma *dw)
 	dma_writel(dw, CFG, 0);
 
 	channel_clear_bit(dw, MASK.XFER, dw->all_chan_mask);
+	channel_clear_bit(dw, MASK.BLOCK, dw->all_chan_mask);
 	channel_clear_bit(dw, MASK.SRC_TRAN, dw->all_chan_mask);
 	channel_clear_bit(dw, MASK.DST_TRAN, dw->all_chan_mask);
 	channel_clear_bit(dw, MASK.ERROR, dw->all_chan_mask);
@@ -1478,6 +1480,7 @@ static int __init dw_probe(struct platform_device *pdev)
 
 	/* Clear/disable all interrupts on all channels. */
 	dma_writel(dw, CLEAR.XFER, dw->all_chan_mask);
+	dma_writel(dw, CLEAR.BLOCK, dw->all_chan_mask);
 	dma_writel(dw, CLEAR.SRC_TRAN, dw->all_chan_mask);
 	dma_writel(dw, CLEAR.DST_TRAN, dw->all_chan_mask);
 	dma_writel(dw, CLEAR.ERROR, dw->all_chan_mask);
-- 
1.7.10

