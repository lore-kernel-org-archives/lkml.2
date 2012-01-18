Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab2ARJNU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 04:13:20 -0500
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:41698 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757157Ab2ARJNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 04:13:14 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Cc: <cjb@laptop.org>, <rmk+kernel@arm.linux.org.uk>,
        <linus.walleij@linaro.org>, <ulf.hansson@stericsson.com>,
        <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <egtvedt@samfundet.no>, <hskinnemoen@gmail.com>,
        <kernel@pengutronix.de>, <perex@perex.cz>,
        <linux-arm-kernel@lists.infradead.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <bhavna.yadav@st.com>,
        <vincenzo.frascino@st.com>, <mirko.gardi@st.com>
Subject: [PATCH V2 12/12] dmaengine/dw_dmac: Remove unused fields in struct dw_dma_slave
Date: Wed, 18 Jan 2012 14:41:59 +0530
Message-ID: <7396f5349b6056ff588c524d7a8bf4c11120e457.1326876464.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.8.110.g4cb5d
In-Reply-To: <cover.1326876464.git.viresh.kumar@st.com>
References: <cover.1326876464.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/dw_dmac_regs.h |   12 ++++++++++++
 include/linux/dw_dmac.h    |   38 --------------------------------------
 2 files changed, 12 insertions(+), 38 deletions(-)

diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
index 2005d30..eec0481 100644
--- a/drivers/dma/dw_dmac_regs.h
+++ b/drivers/dma/dw_dmac_regs.h
@@ -13,6 +13,18 @@
 
 #define DW_DMA_MAX_NR_CHANNELS	8
 
+/* flow controller */
+enum dw_dma_fc {
+	DW_DMA_FC_D_M2M,
+	DW_DMA_FC_D_M2P,
+	DW_DMA_FC_D_P2M,
+	DW_DMA_FC_D_P2P,
+	DW_DMA_FC_P_P2M,
+	DW_DMA_FC_SP_P2P,
+	DW_DMA_FC_P_M2P,
+	DW_DMA_FC_DP_P2P,
+};
+
 /*
  * Redefine this macro to handle differences between 32- and 64-bit
  * addressing, big vs. little endian, etc.
diff --git a/include/linux/dw_dmac.h b/include/linux/dw_dmac.h
index f2c64f9..2412e02 100644
--- a/include/linux/dw_dmac.h
+++ b/include/linux/dw_dmac.h
@@ -31,18 +31,6 @@ struct dw_dma_platform_data {
 	unsigned char	chan_priority;
 };
 
-/**
- * enum dw_dma_slave_width - DMA slave register access width.
- * @DMA_SLAVE_WIDTH_8BIT: Do 8-bit slave register accesses
- * @DMA_SLAVE_WIDTH_16BIT: Do 16-bit slave register accesses
- * @DMA_SLAVE_WIDTH_32BIT: Do 32-bit slave register accesses
- */
-enum dw_dma_slave_width {
-	DW_DMA_SLAVE_WIDTH_8BIT,
-	DW_DMA_SLAVE_WIDTH_16BIT,
-	DW_DMA_SLAVE_WIDTH_32BIT,
-};
-
 /* bursts size */
 enum dw_dma_msize {
 	DW_DMA_MSIZE_1,
@@ -55,47 +43,21 @@ enum dw_dma_msize {
 	DW_DMA_MSIZE_256,
 };
 
-/* flow controller */
-enum dw_dma_fc {
-	DW_DMA_FC_D_M2M,
-	DW_DMA_FC_D_M2P,
-	DW_DMA_FC_D_P2M,
-	DW_DMA_FC_D_P2P,
-	DW_DMA_FC_P_P2M,
-	DW_DMA_FC_SP_P2P,
-	DW_DMA_FC_P_M2P,
-	DW_DMA_FC_DP_P2P,
-};
-
 /**
  * struct dw_dma_slave - Controller-specific information about a slave
  *
  * @dma_dev: required DMA master device
- * @tx_reg: physical address of data register used for
- *	memory-to-peripheral transfers
- * @rx_reg: physical address of data register used for
- *	peripheral-to-memory transfers
- * @reg_width: peripheral register width
  * @cfg_hi: Platform-specific initializer for the CFG_HI register
  * @cfg_lo: Platform-specific initializer for the CFG_LO register
  * @src_master: src master for transfers on allocated channel.
  * @dst_master: dest master for transfers on allocated channel.
- * @src_msize: src burst size.
- * @dst_msize: dest burst size.
- * @fc: flow controller for DMA transfer
  */
 struct dw_dma_slave {
 	struct device		*dma_dev;
-	dma_addr_t		tx_reg;
-	dma_addr_t		rx_reg;
-	enum dw_dma_slave_width	reg_width;
 	u32			cfg_hi;
 	u32			cfg_lo;
 	u8			src_master;
 	u8			dst_master;
-	u8			src_msize;
-	u8			dst_msize;
-	u8			fc;
 };
 
 /* Platform-configurable bits in CFG_HI */
-- 
1.7.8.110.g4cb5d

