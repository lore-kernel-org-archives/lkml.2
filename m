Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab2GMIKS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 04:10:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:27318 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755030Ab2GMIJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 04:09:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="176839182"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, linux-kernel@vger.kernel.org,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 2/3] dw_dmac: use 'u32' for LLI structure members, not dma_addr_t
Date: Fri, 13 Jul 2012 11:09:33 +0300
Message-Id: <1342166974-4490-2-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1342166974-4490-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1342166974-4490-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use 'u32' for the LLI structure members, which are defined by hardware to be
32-bit. dma_addr_t is much more vague about its actual size.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c      |    7 ++-----
 drivers/dma/dw_dmac_regs.h |    6 +++---
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index db56ef4..3d061c6 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -416,11 +416,8 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
 static inline void dwc_dump_lli(struct dw_dma_chan *dwc, struct dw_lli *lli)
 {
 	dev_printk(KERN_CRIT, chan2dev(&dwc->chan),
-			"  desc: s0x%llx d0x%llx l0x%llx c0x%x:%x\n",
-			(unsigned long long)lli->sar,
-			(unsigned long long)lli->dar,
-			(unsigned long long)lli->llp,
-			lli->ctlhi, lli->ctllo);
+			"  desc: s0x%x d0x%x l0x%x c0x%x:%x\n",
+			lli->sar, lli->dar, lli->llp, lli->ctlhi, lli->ctllo);
 }
 
 static void dwc_handle_error(struct dw_dma *dw, struct dw_dma_chan *dwc)
diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
index e248481..50830be 100644
--- a/drivers/dma/dw_dmac_regs.h
+++ b/drivers/dma/dw_dmac_regs.h
@@ -219,9 +219,9 @@ static inline struct dw_dma *to_dw_dma(struct dma_device *ddev)
 /* LLI == Linked List Item; a.k.a. DMA block descriptor */
 struct dw_lli {
 	/* values that are not changed by hardware */
-	dma_addr_t	sar;
-	dma_addr_t	dar;
-	dma_addr_t	llp;		/* chain to next lli */
+	u32		sar;
+	u32		dar;
+	u32		llp;		/* chain to next lli */
 	u32		ctllo;
 	/* values that may get written back: */
 	u32		ctlhi;
-- 
1.7.10.4

