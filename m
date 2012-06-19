Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab2FSKgF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 06:36:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:49021 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752989Ab2FSKec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 06:34:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="159441817"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv2 05/10] dw_dmac: use __func__ constant in the debug prints
Date: Tue, 19 Jun 2012 13:34:05 +0300
Message-Id: <1340102050-12697-6-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1340102050-12697-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1339743913-6236-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1340102050-12697-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 763730a..e2ea243 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -346,7 +346,7 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
 		return;
 	}
 
-	dev_vdbg(chan2dev(&dwc->chan), "scan_descriptors: llp=0x%llx\n",
+	dev_vdbg(chan2dev(&dwc->chan), "%s: llp=0x%llx\n", __func__,
 			(unsigned long long)llp);
 
 	list_for_each_entry_safe(desc, _desc, &dwc->active_list, desc_node) {
@@ -533,7 +533,7 @@ static void dw_dma_tasklet(unsigned long data)
 	status_xfer = dma_readl(dw, RAW.XFER);
 	status_err = dma_readl(dw, RAW.ERROR);
 
-	dev_vdbg(dw->dma.dev, "tasklet: status_err=%x\n", status_err);
+	dev_vdbg(dw->dma.dev, "%s: status_err=%x\n", __func__, status_err);
 
 	for (i = 0; i < dw->dma.chancnt; i++) {
 		dwc = &dw->chan[i];
@@ -557,7 +557,7 @@ static irqreturn_t dw_dma_interrupt(int irq, void *dev_id)
 	struct dw_dma *dw = dev_id;
 	u32 status;
 
-	dev_vdbg(dw->dma.dev, "interrupt: status=0x%x\n",
+	dev_vdbg(dw->dma.dev, "%s: status=0x%x\n", __func__,
 			dma_readl(dw, STATUS_INT));
 
 	/*
@@ -603,12 +603,12 @@ static dma_cookie_t dwc_tx_submit(struct dma_async_tx_descriptor *tx)
 	 * for DMA. But this is hard to do in a race-free manner.
 	 */
 	if (list_empty(&dwc->active_list)) {
-		dev_vdbg(chan2dev(tx->chan), "tx_submit: started %u\n",
+		dev_vdbg(chan2dev(tx->chan), "%s: started %u\n", __func__,
 				desc->txd.cookie);
 		list_add_tail(&desc->desc_node, &dwc->active_list);
 		dwc_dostart(dwc, dwc_first_active(dwc));
 	} else {
-		dev_vdbg(chan2dev(tx->chan), "tx_submit: queued %u\n",
+		dev_vdbg(chan2dev(tx->chan), "%s: queued %u\n", __func__,
 				desc->txd.cookie);
 
 		list_add_tail(&desc->desc_node, &dwc->queue);
@@ -634,12 +634,12 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 	u32			ctllo;
 
 	dev_vdbg(chan2dev(chan),
-			"prep_dma_memcpy d0x%llx s0x%llx l0x%zx f0x%lx\n",
+			"%s: d0x%llx s0x%llx l0x%zx f0x%lx\n", __func__,
 			(unsigned long long)dest, (unsigned long long)src,
 			len, flags);
 
 	if (unlikely(!len)) {
-		dev_dbg(chan2dev(chan), "prep_dma_memcpy: length is zero!\n");
+		dev_dbg(chan2dev(chan), "%s: length is zero!\n", __func__);
 		return NULL;
 	}
 
@@ -728,7 +728,7 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 	struct scatterlist	*sg;
 	size_t			total_len = 0;
 
-	dev_vdbg(chan2dev(chan), "prep_dma_slave\n");
+	dev_vdbg(chan2dev(chan), "%s\n", __func__);
 
 	if (unlikely(!dws || !sg_len))
 		return NULL;
@@ -1022,7 +1022,7 @@ static int dwc_alloc_chan_resources(struct dma_chan *chan)
 	int			i;
 	unsigned long		flags;
 
-	dev_vdbg(chan2dev(chan), "alloc_chan_resources\n");
+	dev_vdbg(chan2dev(chan), "%s\n", __func__);
 
 	/* ASSERT:  channel is idle */
 	if (dma_readl(dw, CH_EN) & dwc->mask) {
@@ -1065,8 +1065,7 @@ static int dwc_alloc_chan_resources(struct dma_chan *chan)
 
 	spin_unlock_irqrestore(&dwc->lock, flags);
 
-	dev_dbg(chan2dev(chan),
-		"alloc_chan_resources allocated %d descriptors\n", i);
+	dev_dbg(chan2dev(chan), "%s: allocated %d descriptors\n", __func__, i);
 
 	return i;
 }
@@ -1079,7 +1078,7 @@ static void dwc_free_chan_resources(struct dma_chan *chan)
 	unsigned long		flags;
 	LIST_HEAD(list);
 
-	dev_dbg(chan2dev(chan), "free_chan_resources (descs allocated=%u)\n",
+	dev_dbg(chan2dev(chan), "%s: descs allocated=%u\n", __func__,
 			dwc->descs_allocated);
 
 	/* ASSERT:  channel is idle */
@@ -1105,7 +1104,7 @@ static void dwc_free_chan_resources(struct dma_chan *chan)
 		kfree(desc);
 	}
 
-	dev_vdbg(chan2dev(chan), "free_chan_resources done\n");
+	dev_vdbg(chan2dev(chan), "%s: done\n", __func__);
 }
 
 /* --------------------- Cyclic DMA API extensions -------------------- */
@@ -1342,7 +1341,7 @@ void dw_dma_cyclic_free(struct dma_chan *chan)
 	int			i;
 	unsigned long		flags;
 
-	dev_dbg(chan2dev(&dwc->chan), "cyclic free\n");
+	dev_dbg(chan2dev(&dwc->chan), "%s\n", __func__);
 
 	if (!cdesc)
 		return;
-- 
1.7.10

