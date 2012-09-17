Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab2IQHko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 03:40:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:38054 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999Ab2IQHjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 03:39:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,433,1344236400"; 
   d="scan'208";a="222918059"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        spear-devel@list.st.com, linux-kernel@vger.kernel.org,
        Hein Tibosch <hein_tibosch@yahoo.es>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 2/7] dw_dmac: fill optional encoded parameters in register structure
Date: Mon, 17 Sep 2012 10:39:32 +0300
Message-Id: <1347867577-13170-3-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a block of the registers that are optional. However, if enabled they
contain useful information about the controller hardware configuration. We will
use this piece of data to autoconfigure the driver.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac_regs.h |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
index f6d92d7..4633d39 100644
--- a/drivers/dma/dw_dmac_regs.h
+++ b/drivers/dma/dw_dmac_regs.h
@@ -82,9 +82,28 @@ struct dw_dma_regs {
 	DW_REG(ID);
 	DW_REG(TEST);
 
+	/* reserved */
+	DW_REG(__reserved0);
+	DW_REG(__reserved1);
+
 	/* optional encoded params, 0x3c8..0x3f7 */
+	u32	__reserved;
+
+	/* per-channel configuration registers */
+	u32	DWC_PARAMS[DW_DMA_MAX_NR_CHANNELS];
+	u32	MULTI_BLK_TYPE;
+	u32	MAX_BLK_SIZE;
+
+	/* top-level parameters */
+	u32	DW_PARAMS;
 };
 
+#define dma_raw_readl(addr, name) \
+	readl((addr) + offsetof(struct dw_dma_regs, name))
+
+#define dma_raw_writel(addr, name, val) \
+	writel((val), (addr) + offsetof(struct dw_dma_regs, name))
+
 /* Bitfields in CTL_LO */
 #define DWC_CTLL_INT_EN		(1 << 0)	/* irqs enabled? */
 #define DWC_CTLL_DST_WIDTH(n)	((n)<<1)	/* bytes per element */
-- 
1.7.10.4

