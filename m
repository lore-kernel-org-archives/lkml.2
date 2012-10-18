Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479Ab2JROex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 10:34:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:11550 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158Ab2JROeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 10:34:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,608,1344236400"; 
   d="scan'208";a="229254058"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>,
        balbi@ti.com
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv3 6/6] dw_dmac: introduce to_dw_desc() macro
Date: Thu, 18 Oct 2012 17:34:12 +0300
Message-Id: <1350570852-10398-7-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1350570852-10398-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1350570852-10398-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The to_dw_desc() macro helps to retrieve the dw_desc node from the
corresponding list_head structure.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c      |    6 ++----
 drivers/dma/dw_dmac_regs.h |    2 ++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 826ff8d..cb89c2a 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -93,7 +93,7 @@ static struct device *chan2parent(struct dma_chan *chan)
 
 static struct dw_desc *dwc_first_active(struct dw_dma_chan *dwc)
 {
-	return list_entry(dwc->active_list.next, struct dw_desc, desc_node);
+	return to_dw_desc(dwc->active_list.next);
 }
 
 static struct dw_desc *dwc_desc_get(struct dw_dma_chan *dwc)
@@ -600,9 +600,7 @@ static void dw_dma_tasklet(unsigned long data)
 			if (test_bit(DW_DMA_IS_SOFT_LLP, &dwc->flags)) {
 				if (dwc->tx_node_active != dwc->tx_list) {
 					struct dw_desc *desc =
-						list_entry(dwc->tx_node_active,
-							   struct dw_desc,
-							   desc_node);
+						to_dw_desc(dwc->tx_node_active);
 
 					dma_writel(dw, CLEAR.XFER, dwc->mask);
 
diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
index ff39fa6..de90a1b 100644
--- a/drivers/dma/dw_dmac_regs.h
+++ b/drivers/dma/dw_dmac_regs.h
@@ -287,6 +287,8 @@ struct dw_desc {
 	size_t				len;
 };
 
+#define to_dw_desc(h)	list_entry(h, struct dw_desc, desc_node)
+
 static inline struct dw_desc *
 txd_to_dw_desc(struct dma_async_tx_descriptor *txd)
 {
-- 
1.7.10.4

