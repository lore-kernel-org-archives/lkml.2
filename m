Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504Ab1JNFrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 01:47:19 -0400
Received: from mga14.intel.com ([143.182.124.37]:19902 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932429Ab1JNFrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 01:47:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,344,1315206000"; 
   d="scan'208";a="62486989"
From: Vinod Koul <vinod.koul@intel.com>
To: dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, jaswinder.singh@linaro.org,
        21cnbao@gmail.com, rmk@arm.linux.org.uk,
        Vinod Koul <vinod.koul@linux.intel.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Viresh Kumar <viresh.kumar@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Mika Westerberg <mika.westerberg@iki.fi>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        Li Yang <leoli@freescale.com>, Zhang Wei <zw@zh-kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Shawn Guo <shawn.guo@freescale.com>, Yong Wang <yong.y.wang@intel.com>,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>,
        Boojin Kim <boojin.kim@samsung.com>, Barry Song <Baohua.Song@csr.com>
Subject: [PATCH 02/10] dmaengine: move drivers to dma_transfer_direction
Date: Fri, 14 Oct 2011 11:08:17 +0530
Message-Id: <1318570705-17595-3-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
References: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vinod Koul <vinod.koul@linux.intel.com>

Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
Cc: Jassi Brar <jaswinder.singh@linaro.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Viresh Kumar <viresh.kumar@st.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Mika Westerberg <mika.westerberg@iki.fi>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Li Yang <leoli@freescale.com>
Cc: Zhang Wei <zw@zh-kernel.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Shawn Guo <shawn.guo@freescale.com>
Cc: Yong Wang <yong.y.wang@intel.com>
Cc: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Cc: Boojin Kim <boojin.kim@samsung.com>
Cc: Barry Song <Baohua.Song@csr.com>
---
 arch/arm/mach-ep93xx/include/mach/dma.h        |    6 ++--
 arch/arm/plat-nomadik/include/plat/ste_dma40.h |    4 +-
 drivers/dma/amba-pl08x.c                       |   24 +++++++++++-----------
 drivers/dma/at_hdmac.c                         |   22 ++++++++++----------
 drivers/dma/coh901318.c                        |   12 +++++-----
 drivers/dma/coh901318_lli.c                    |   23 ++++++++++-----------
 drivers/dma/coh901318_lli.h                    |    4 +-
 drivers/dma/dw_dmac.c                          |   14 ++++++------
 drivers/dma/ep93xx_dma.c                       |   22 ++++++++++----------
 drivers/dma/fsldma.c                           |    4 +-
 drivers/dma/imx-dma.c                          |   10 ++++----
 drivers/dma/imx-sdma.c                         |   10 ++++----
 drivers/dma/intel_mid_dma.c                    |   14 ++++++------
 drivers/dma/intel_mid_dma_regs.h               |    2 +-
 drivers/dma/ipu/ipu_idmac.c                    |    4 +-
 drivers/dma/mxs-dma.c                          |    8 +++---
 drivers/dma/pch_dma.c                          |   12 +++++-----
 drivers/dma/pl330.c                            |   18 ++++++++--------
 drivers/dma/shdma.c                            |   25 +++++++++++------------
 drivers/dma/ste_dma40.c                        |   26 ++++++++++++------------
 drivers/dma/timb_dma.c                         |   18 ++++++++--------
 drivers/dma/txx9dmac.c                         |   12 +++++-----
 include/linux/amba/pl08x.h                     |    4 +-
 include/linux/dw_dmac.h                        |    2 +-
 include/linux/sh_dma.h                         |    2 +-
 25 files changed, 150 insertions(+), 152 deletions(-)

diff --git a/arch/arm/mach-ep93xx/include/mach/dma.h b/arch/arm/mach-ep93xx/include/mach/dma.h
index 46d4d87..ba4767b 100644
--- a/arch/arm/mach-ep93xx/include/mach/dma.h
+++ b/arch/arm/mach-ep93xx/include/mach/dma.h
@@ -37,7 +37,7 @@
  */
 struct ep93xx_dma_data {
 	int				port;
-	enum dma_data_direction		direction;
+	enum dma_transfer_direction	direction;
 	const char			*name;
 };
 
@@ -80,14 +80,14 @@ static inline bool ep93xx_dma_chan_is_m2p(struct dma_chan *chan)
  * channel supports given DMA direction. Only M2P channels have such
  * limitation, for M2M channels the direction is configurable.
  */
-static inline enum dma_data_direction
+static inline enum dma_transfer_direction
 ep93xx_dma_chan_direction(struct dma_chan *chan)
 {
 	if (!ep93xx_dma_chan_is_m2p(chan))
 		return DMA_NONE;
 
 	/* even channels are for TX, odd for RX */
-	return (chan->chan_id % 2 == 0) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
+	return (chan->chan_id % 2 == 0) ? MEM_TO_DEV : DEV_TO_MEM;
 }
 
 #endif /* __ASM_ARCH_DMA_H */
diff --git a/arch/arm/plat-nomadik/include/plat/ste_dma40.h b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
index 685c787..38b041a 100644
--- a/arch/arm/plat-nomadik/include/plat/ste_dma40.h
+++ b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
@@ -187,7 +187,7 @@ static inline struct
 dma_async_tx_descriptor *stedma40_slave_mem(struct dma_chan *chan,
 					    dma_addr_t addr,
 					    unsigned int size,
-					    enum dma_data_direction direction,
+					    enum dma_transfer_direction direction,
 					    unsigned long flags)
 {
 	struct scatterlist sg;
@@ -209,7 +209,7 @@ static inline struct
 dma_async_tx_descriptor *stedma40_slave_mem(struct dma_chan *chan,
 					    dma_addr_t addr,
 					    unsigned int size,
-					    enum dma_data_direction direction,
+					    enum dma_transfer_direction direction,
 					    unsigned long flags)
 {
 	return NULL;
diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index b7cbd1a..36cb9af 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -882,9 +882,9 @@ static int prep_phy_channel(struct pl08x_dma_chan *plchan,
 		ch->signal = ret;
 
 		/* Assign the flow control signal to this channel */
-		if (txd->direction == DMA_TO_DEVICE)
+		if (txd->direction == MEM_TO_DEV)
 			txd->ccfg |= ch->signal << PL080_CONFIG_DST_SEL_SHIFT;
-		else if (txd->direction == DMA_FROM_DEVICE)
+		else if (txd->direction == DEV_TO_MEM)
 			txd->ccfg |= ch->signal << PL080_CONFIG_SRC_SEL_SHIFT;
 	}
 
@@ -1102,10 +1102,10 @@ static int dma_set_runtime_config(struct dma_chan *chan,
 
 	/* Transfer direction */
 	plchan->runtime_direction = config->direction;
-	if (config->direction == DMA_TO_DEVICE) {
+	if (config->direction == MEM_TO_DEV) {
 		addr_width = config->dst_addr_width;
 		maxburst = config->dst_maxburst;
-	} else if (config->direction == DMA_FROM_DEVICE) {
+	} else if (config->direction == DEV_TO_MEM) {
 		addr_width = config->src_addr_width;
 		maxburst = config->src_maxburst;
 	} else {
@@ -1136,7 +1136,7 @@ static int dma_set_runtime_config(struct dma_chan *chan,
 	cctl |= burst << PL080_CONTROL_SB_SIZE_SHIFT;
 	cctl |= burst << PL080_CONTROL_DB_SIZE_SHIFT;
 
-	if (plchan->runtime_direction == DMA_FROM_DEVICE) {
+	if (plchan->runtime_direction == DEV_TO_MEM) {
 		plchan->src_addr = config->src_addr;
 		plchan->src_cctl = pl08x_cctl(cctl) | PL080_CONTROL_DST_INCR |
 			pl08x_select_bus(plchan->cd->periph_buses,
@@ -1152,7 +1152,7 @@ static int dma_set_runtime_config(struct dma_chan *chan,
 		"configured channel %s (%s) for %s, data width %d, "
 		"maxburst %d words, LE, CCTL=0x%08x\n",
 		dma_chan_name(chan), plchan->name,
-		(config->direction == DMA_FROM_DEVICE) ? "RX" : "TX",
+		(config->direction == DEV_TO_MEM) ? "RX" : "TX",
 		addr_width,
 		maxburst,
 		cctl);
@@ -1322,7 +1322,7 @@ static struct dma_async_tx_descriptor *pl08x_prep_dma_memcpy(
 
 static struct dma_async_tx_descriptor *pl08x_prep_slave_sg(
 		struct dma_chan *chan, struct scatterlist *sgl,
-		unsigned int sg_len, enum dma_data_direction direction,
+		unsigned int sg_len, enum dma_transfer_direction direction,
 		unsigned long flags)
 {
 	struct pl08x_dma_chan *plchan = to_pl08x_chan(chan);
@@ -1354,10 +1354,10 @@ static struct dma_async_tx_descriptor *pl08x_prep_slave_sg(
 	 */
 	txd->direction = direction;
 
-	if (direction == DMA_TO_DEVICE) {
+	if (direction == MEM_TO_DEV) {
 		txd->cctl = plchan->dst_cctl;
 		slave_addr = plchan->dst_addr;
-	} else if (direction == DMA_FROM_DEVICE) {
+	} else if (direction == DEV_TO_MEM) {
 		txd->cctl = plchan->src_cctl;
 		slave_addr = plchan->src_addr;
 	} else {
@@ -1368,10 +1368,10 @@ static struct dma_async_tx_descriptor *pl08x_prep_slave_sg(
 	}
 
 	if (plchan->cd->device_fc)
-		tmp = (direction == DMA_TO_DEVICE) ? PL080_FLOW_MEM2PER_PER :
+		tmp = (direction == MEM_TO_DEV) ? PL080_FLOW_MEM2PER_PER :
 			PL080_FLOW_PER2MEM_PER;
 	else
-		tmp = (direction == DMA_TO_DEVICE) ? PL080_FLOW_MEM2PER :
+		tmp = (direction == MEM_TO_DEV) ? PL080_FLOW_MEM2PER :
 			PL080_FLOW_PER2MEM;
 
 	txd->ccfg |= tmp << PL080_CONFIG_FLOW_CONTROL_SHIFT;
@@ -1387,7 +1387,7 @@ static struct dma_async_tx_descriptor *pl08x_prep_slave_sg(
 		list_add_tail(&dsg->node, &txd->dsg_list);
 
 		dsg->len = sg_dma_len(sg);
-		if (direction == DMA_TO_DEVICE) {
+		if (direction == MEM_TO_DEV) {
 			dsg->src_addr = sg_phys(sg);
 			dsg->dst_addr = slave_addr;
 		} else {
diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index fcfa0a8..7968a81 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -660,7 +660,7 @@ err_desc_get:
  */
 static struct dma_async_tx_descriptor *
 atc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
-		unsigned int sg_len, enum dma_data_direction direction,
+		unsigned int sg_len, enum dma_transfer_direction direction,
 		unsigned long flags)
 {
 	struct at_dma_chan	*atchan = to_at_dma_chan(chan);
@@ -678,7 +678,7 @@ atc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 
 	dev_vdbg(chan2dev(chan), "prep_slave_sg (%d): %s f0x%lx\n",
 			sg_len,
-			direction == DMA_TO_DEVICE ? "TO DEVICE" : "FROM DEVICE",
+			direction == MEM_TO_DEV ? "TO DEVICE" : "FROM DEVICE",
 			flags);
 
 	if (unlikely(!atslave || !sg_len)) {
@@ -692,7 +692,7 @@ atc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 	ctrlb = ATC_IEN;
 
 	switch (direction) {
-	case DMA_TO_DEVICE:
+	case MEM_TO_DEV:
 		ctrla |=  ATC_DST_WIDTH(reg_width);
 		ctrlb |=  ATC_DST_ADDR_MODE_FIXED
 			| ATC_SRC_ADDR_MODE_INCR
@@ -725,7 +725,7 @@ atc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 			total_len += len;
 		}
 		break;
-	case DMA_FROM_DEVICE:
+	case DEV_TO_MEM:
 		ctrla |=  ATC_SRC_WIDTH(reg_width);
 		ctrlb |=  ATC_DST_ADDR_MODE_INCR
 			| ATC_SRC_ADDR_MODE_FIXED
@@ -787,7 +787,7 @@ err_desc_get:
  */
 static int
 atc_dma_cyclic_check_values(unsigned int reg_width, dma_addr_t buf_addr,
-		size_t period_len, enum dma_data_direction direction)
+		size_t period_len, enum dma_transfer_direction direction)
 {
 	if (period_len > (ATC_BTSIZE_MAX << reg_width))
 		goto err_out;
@@ -795,7 +795,7 @@ atc_dma_cyclic_check_values(unsigned int reg_width, dma_addr_t buf_addr,
 		goto err_out;
 	if (unlikely(buf_addr & ((1 << reg_width) - 1)))
 		goto err_out;
-	if (unlikely(!(direction & (DMA_TO_DEVICE | DMA_FROM_DEVICE))))
+	if (unlikely(!(direction & (DEV_TO_MEM | MEM_TO_DEV))))
 		goto err_out;
 
 	return 0;
@@ -810,7 +810,7 @@ err_out:
 static int
 atc_dma_cyclic_fill_desc(struct at_dma_slave *atslave, struct at_desc *desc,
 		unsigned int period_index, dma_addr_t buf_addr,
-		size_t period_len, enum dma_data_direction direction)
+		size_t period_len, enum dma_transfer_direction direction)
 {
 	u32		ctrla;
 	unsigned int	reg_width = atslave->reg_width;
@@ -822,7 +822,7 @@ atc_dma_cyclic_fill_desc(struct at_dma_slave *atslave, struct at_desc *desc,
 		| period_len >> reg_width;
 
 	switch (direction) {
-	case DMA_TO_DEVICE:
+	case MEM_TO_DEV:
 		desc->lli.saddr = buf_addr + (period_len * period_index);
 		desc->lli.daddr = atslave->tx_reg;
 		desc->lli.ctrla = ctrla;
@@ -833,7 +833,7 @@ atc_dma_cyclic_fill_desc(struct at_dma_slave *atslave, struct at_desc *desc,
 				| ATC_DIF(AT_DMA_PER_IF);
 		break;
 
-	case DMA_FROM_DEVICE:
+	case DEV_TO_MEM:
 		desc->lli.saddr = atslave->rx_reg;
 		desc->lli.daddr = buf_addr + (period_len * period_index);
 		desc->lli.ctrla = ctrla;
@@ -861,7 +861,7 @@ atc_dma_cyclic_fill_desc(struct at_dma_slave *atslave, struct at_desc *desc,
  */
 static struct dma_async_tx_descriptor *
 atc_prep_dma_cyclic(struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
-		size_t period_len, enum dma_data_direction direction)
+		size_t period_len, enum dma_transfer_direction direction)
 {
 	struct at_dma_chan	*atchan = to_at_dma_chan(chan);
 	struct at_dma_slave	*atslave = chan->private;
@@ -872,7 +872,7 @@ atc_prep_dma_cyclic(struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
 	unsigned int		i;
 
 	dev_vdbg(chan2dev(chan), "prep_dma_cyclic: %s buf@0x%08x - %d (%d/%d)\n",
-			direction == DMA_TO_DEVICE ? "TO DEVICE" : "FROM DEVICE",
+			direction == MEM_TO_DEV ? "TO DEVICE" : "FROM DEVICE",
 			buf_addr,
 			periods, buf_len, period_len);
 
diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index 4234f41..ca4d6c1 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -39,7 +39,7 @@ struct coh901318_desc {
 	struct scatterlist *sg;
 	unsigned int sg_len;
 	struct coh901318_lli *lli;
-	enum dma_data_direction dir;
+	enum dma_transfer_direction dir;
 	unsigned long flags;
 	u32 head_config;
 	u32 head_ctrl;
@@ -1034,7 +1034,7 @@ coh901318_prep_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 
 static struct dma_async_tx_descriptor *
 coh901318_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
-			unsigned int sg_len, enum dma_data_direction direction,
+			unsigned int sg_len, enum dma_transfer_direction direction,
 			unsigned long flags)
 {
 	struct coh901318_chan *cohc = to_coh901318_chan(chan);
@@ -1077,7 +1077,7 @@ coh901318_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 	ctrl_last |= cohc->runtime_ctrl;
 	ctrl |= cohc->runtime_ctrl;
 
-	if (direction == DMA_TO_DEVICE) {
+	if (direction == MEM_TO_DEV) {
 		u32 tx_flags = COH901318_CX_CTRL_PRDD_SOURCE |
 			COH901318_CX_CTRL_SRC_ADDR_INC_ENABLE;
 
@@ -1085,7 +1085,7 @@ coh901318_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 		ctrl_chained |= tx_flags;
 		ctrl_last |= tx_flags;
 		ctrl |= tx_flags;
-	} else if (direction == DMA_FROM_DEVICE) {
+	} else if (direction == DEV_TO_MEM) {
 		u32 rx_flags = COH901318_CX_CTRL_PRDD_DEST |
 			COH901318_CX_CTRL_DST_ADDR_INC_ENABLE;
 
@@ -1274,11 +1274,11 @@ static void coh901318_dma_set_runtimeconfig(struct dma_chan *chan,
 	int i = 0;
 
 	/* We only support mem to per or per to mem transfers */
-	if (config->direction == DMA_FROM_DEVICE) {
+	if (config->direction == DEV_TO_MEM) {
 		addr = config->src_addr;
 		addr_width = config->src_addr_width;
 		maxburst = config->src_maxburst;
-	} else if (config->direction == DMA_TO_DEVICE) {
+	} else if (config->direction == MEM_TO_DEV) {
 		addr = config->dst_addr;
 		addr_width = config->dst_addr_width;
 		maxburst = config->dst_maxburst;
diff --git a/drivers/dma/coh901318_lli.c b/drivers/dma/coh901318_lli.c
index 9f7e0e6..c895bd8 100644
--- a/drivers/dma/coh901318_lli.c
+++ b/drivers/dma/coh901318_lli.c
@@ -7,11 +7,10 @@
  * Author: Per Friden <per.friden@stericsson.com>
  */
 
-#include <linux/dma-mapping.h>
 #include <linux/spinlock.h>
-#include <linux/dmapool.h>
 #include <linux/memory.h>
 #include <linux/gfp.h>
+#include <linux/dmapool.h>
 #include <mach/coh901318.h>
 
 #include "coh901318_lli.h"
@@ -177,18 +176,18 @@ coh901318_lli_fill_single(struct coh901318_pool *pool,
 			  struct coh901318_lli *lli,
 			  dma_addr_t buf, unsigned int size,
 			  dma_addr_t dev_addr, u32 ctrl_chained, u32 ctrl_eom,
-			  enum dma_data_direction dir)
+			  enum dma_transfer_direction dir)
 {
 	int s = size;
 	dma_addr_t src;
 	dma_addr_t dst;
 
 
-	if (dir == DMA_TO_DEVICE) {
+	if (dir == MEM_TO_DEV) {
 		src = buf;
 		dst = dev_addr;
 
-	} else if (dir == DMA_FROM_DEVICE) {
+	} else if (dir == DEV_TO_MEM) {
 
 		src = dev_addr;
 		dst = buf;
@@ -215,9 +214,9 @@ coh901318_lli_fill_single(struct coh901318_pool *pool,
 
 		lli = coh901318_lli_next(lli);
 
-		if (dir == DMA_TO_DEVICE)
+		if (dir == MEM_TO_DEV)
 			src += block_size;
-		else if (dir == DMA_FROM_DEVICE)
+		else if (dir == DEV_TO_MEM)
 			dst += block_size;
 	}
 
@@ -234,7 +233,7 @@ coh901318_lli_fill_sg(struct coh901318_pool *pool,
 		      struct scatterlist *sgl, unsigned int nents,
 		      dma_addr_t dev_addr, u32 ctrl_chained, u32 ctrl,
 		      u32 ctrl_last,
-		      enum dma_data_direction dir, u32 ctrl_irq_mask)
+		      enum dma_transfer_direction dir, u32 ctrl_irq_mask)
 {
 	int i;
 	struct scatterlist *sg;
@@ -249,9 +248,9 @@ coh901318_lli_fill_sg(struct coh901318_pool *pool,
 
 	spin_lock(&pool->lock);
 
-	if (dir == DMA_TO_DEVICE)
+	if (dir == MEM_TO_DEV)
 		dst = dev_addr;
-	else if (dir == DMA_FROM_DEVICE)
+	else if (dir == DEV_TO_MEM)
 		src = dev_addr;
 	else
 		goto err;
@@ -269,7 +268,7 @@ coh901318_lli_fill_sg(struct coh901318_pool *pool,
 			ctrl_sg = ctrl ? ctrl : ctrl_last;
 
 
-		if (dir == DMA_TO_DEVICE)
+		if (dir == MEM_TO_DEV)
 			/* increment source address */
 			src = sg_phys(sg);
 		else
@@ -293,7 +292,7 @@ coh901318_lli_fill_sg(struct coh901318_pool *pool,
 			lli->src_addr = src;
 			lli->dst_addr = dst;
 
-			if (dir == DMA_FROM_DEVICE)
+			if (dir == DEV_TO_MEM)
 				dst += elem_size;
 			else
 				src += elem_size;
diff --git a/drivers/dma/coh901318_lli.h b/drivers/dma/coh901318_lli.h
index 7a5c809..abff371 100644
--- a/drivers/dma/coh901318_lli.h
+++ b/drivers/dma/coh901318_lli.h
@@ -97,7 +97,7 @@ coh901318_lli_fill_single(struct coh901318_pool *pool,
 			  struct coh901318_lli *lli,
 			  dma_addr_t buf, unsigned int size,
 			  dma_addr_t dev_addr, u32 ctrl_chained, u32 ctrl_last,
-			  enum dma_data_direction dir);
+			  enum dma_transfer_direction dir);
 
 /**
  * coh901318_lli_fill_single() - Prepares the lli:s for dma scatter list transfer
@@ -119,6 +119,6 @@ coh901318_lli_fill_sg(struct coh901318_pool *pool,
 		      struct scatterlist *sg, unsigned int nents,
 		      dma_addr_t dev_addr, u32 ctrl_chained,
 		      u32 ctrl, u32 ctrl_last,
-		      enum dma_data_direction dir, u32 ctrl_irq_mask);
+		      enum dma_transfer_direction dir, u32 ctrl_irq_mask);
 
 #endif /* COH901318_LLI_H */
diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 9bfd6d3..ff05382 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -696,7 +696,7 @@ err_desc_get:
 
 static struct dma_async_tx_descriptor *
 dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
-		unsigned int sg_len, enum dma_data_direction direction,
+		unsigned int sg_len, enum dma_transfer_direction direction,
 		unsigned long flags)
 {
 	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
@@ -720,7 +720,7 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 	prev = first = NULL;
 
 	switch (direction) {
-	case DMA_TO_DEVICE:
+	case MEM_TO_DEV:
 		ctllo = (DWC_DEFAULT_CTLLO(chan->private)
 				| DWC_CTLL_DST_WIDTH(reg_width)
 				| DWC_CTLL_DST_FIX
@@ -777,7 +777,7 @@ slave_sg_todev_fill_desc:
 				goto slave_sg_todev_fill_desc;
 		}
 		break;
-	case DMA_FROM_DEVICE:
+	case DEV_TO_MEM:
 		ctllo = (DWC_DEFAULT_CTLLO(chan->private)
 				| DWC_CTLL_SRC_WIDTH(reg_width)
 				| DWC_CTLL_DST_INC
@@ -1165,7 +1165,7 @@ EXPORT_SYMBOL(dw_dma_cyclic_stop);
  */
 struct dw_cyclic_desc *dw_dma_cyclic_prep(struct dma_chan *chan,
 		dma_addr_t buf_addr, size_t buf_len, size_t period_len,
-		enum dma_data_direction direction)
+		enum dma_transfer_direction direction)
 {
 	struct dw_dma_chan		*dwc = to_dw_dma_chan(chan);
 	struct dw_cyclic_desc		*cdesc;
@@ -1206,7 +1206,7 @@ struct dw_cyclic_desc *dw_dma_cyclic_prep(struct dma_chan *chan,
 		goto out_err;
 	if (unlikely(buf_addr & ((1 << reg_width) - 1)))
 		goto out_err;
-	if (unlikely(!(direction & (DMA_TO_DEVICE | DMA_FROM_DEVICE))))
+	if (unlikely(!(direction & (MEM_TO_DEV | DEV_TO_MEM))))
 		goto out_err;
 
 	retval = ERR_PTR(-ENOMEM);
@@ -1228,7 +1228,7 @@ struct dw_cyclic_desc *dw_dma_cyclic_prep(struct dma_chan *chan,
 			goto out_err_desc_get;
 
 		switch (direction) {
-		case DMA_TO_DEVICE:
+		case MEM_TO_DEV:
 			desc->lli.dar = dws->tx_reg;
 			desc->lli.sar = buf_addr + (period_len * i);
 			desc->lli.ctllo = (DWC_DEFAULT_CTLLO(chan->private)
@@ -1239,7 +1239,7 @@ struct dw_cyclic_desc *dw_dma_cyclic_prep(struct dma_chan *chan,
 					| DWC_CTLL_FC(dws->fc)
 					| DWC_CTLL_INT_EN);
 			break;
-		case DMA_FROM_DEVICE:
+		case DEV_TO_MEM:
 			desc->lli.dar = buf_addr + (period_len * i);
 			desc->lli.sar = dws->rx_reg;
 			desc->lli.ctllo = (DWC_DEFAULT_CTLLO(chan->private)
diff --git a/drivers/dma/ep93xx_dma.c b/drivers/dma/ep93xx_dma.c
index 5d7a49b..42c4698 100644
--- a/drivers/dma/ep93xx_dma.c
+++ b/drivers/dma/ep93xx_dma.c
@@ -329,7 +329,7 @@ static void m2p_fill_desc(struct ep93xx_dma_chan *edmac)
 	struct ep93xx_dma_desc *desc = ep93xx_dma_get_active(edmac);
 	u32 bus_addr;
 
-	if (ep93xx_dma_chan_direction(&edmac->chan) == DMA_TO_DEVICE)
+	if (ep93xx_dma_chan_direction(&edmac->chan) == MEM_TO_DEV)
 		bus_addr = desc->src_addr;
 	else
 		bus_addr = desc->dst_addr;
@@ -442,7 +442,7 @@ static int m2m_hw_setup(struct ep93xx_dma_chan *edmac)
 		control = (5 << M2M_CONTROL_PWSC_SHIFT);
 		control |= M2M_CONTROL_NO_HDSK;
 
-		if (data->direction == DMA_TO_DEVICE) {
+		if (data->direction == MEM_TO_DEV) {
 			control |= M2M_CONTROL_DAH;
 			control |= M2M_CONTROL_TM_TX;
 			control |= M2M_CONTROL_RSS_SSPTX;
@@ -462,7 +462,7 @@ static int m2m_hw_setup(struct ep93xx_dma_chan *edmac)
 		control |= M2M_CONTROL_RSS_IDE;
 		control |= M2M_CONTROL_PW_16;
 
-		if (data->direction == DMA_TO_DEVICE) {
+		if (data->direction == MEM_TO_DEV) {
 			/* Worst case from the UG */
 			control = (3 << M2M_CONTROL_PWSC_SHIFT);
 			control |= M2M_CONTROL_DAH;
@@ -802,8 +802,8 @@ static int ep93xx_dma_alloc_chan_resources(struct dma_chan *chan)
 			switch (data->port) {
 			case EP93XX_DMA_SSP:
 			case EP93XX_DMA_IDE:
-				if (data->direction != DMA_TO_DEVICE &&
-				    data->direction != DMA_FROM_DEVICE)
+				if (data->direction != MEM_TO_DEV &&
+				    data->direction != DEV_TO_MEM)
 					return -EINVAL;
 				break;
 			default:
@@ -951,7 +951,7 @@ fail:
  */
 static struct dma_async_tx_descriptor *
 ep93xx_dma_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
-			 unsigned int sg_len, enum dma_data_direction dir,
+			 unsigned int sg_len, enum dma_transfer_direction dir,
 			 unsigned long flags)
 {
 	struct ep93xx_dma_chan *edmac = to_ep93xx_dma_chan(chan);
@@ -987,7 +987,7 @@ ep93xx_dma_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 			goto fail;
 		}
 
-		if (dir == DMA_TO_DEVICE) {
+		if (dir == MEM_TO_DEV) {
 			desc->src_addr = sg_dma_address(sg);
 			desc->dst_addr = edmac->runtime_addr;
 		} else {
@@ -1031,7 +1031,7 @@ fail:
 static struct dma_async_tx_descriptor *
 ep93xx_dma_prep_dma_cyclic(struct dma_chan *chan, dma_addr_t dma_addr,
 			   size_t buf_len, size_t period_len,
-			   enum dma_data_direction dir)
+			   enum dma_transfer_direction dir)
 {
 	struct ep93xx_dma_chan *edmac = to_ep93xx_dma_chan(chan);
 	struct ep93xx_dma_desc *desc, *first;
@@ -1064,7 +1064,7 @@ ep93xx_dma_prep_dma_cyclic(struct dma_chan *chan, dma_addr_t dma_addr,
 			goto fail;
 		}
 
-		if (dir == DMA_TO_DEVICE) {
+		if (dir == MEM_TO_DEV) {
 			desc->src_addr = dma_addr + offset;
 			desc->dst_addr = edmac->runtime_addr;
 		} else {
@@ -1132,12 +1132,12 @@ static int ep93xx_dma_slave_config(struct ep93xx_dma_chan *edmac,
 		return -EINVAL;
 
 	switch (config->direction) {
-	case DMA_FROM_DEVICE:
+	case DEV_TO_MEM:
 		width = config->src_addr_width;
 		addr = config->src_addr;
 		break;
 
-	case DMA_TO_DEVICE:
+	case MEM_TO_DEV:
 		width = config->dst_addr_width;
 		addr = config->dst_addr;
 		break;
diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 8a78154..fc980f0 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -772,7 +772,7 @@ fail:
  */
 static struct dma_async_tx_descriptor *fsl_dma_prep_slave_sg(
 	struct dma_chan *dchan, struct scatterlist *sgl, unsigned int sg_len,
-	enum dma_data_direction direction, unsigned long flags)
+	enum dma_transfer_direction direction, unsigned long flags)
 {
 	/*
 	 * This operation is not supported on the Freescale DMA controller
@@ -819,7 +819,7 @@ static int fsl_dma_device_control(struct dma_chan *dchan,
 			return -ENXIO;
 
 		/* we set the controller burst size depending on direction */
-		if (config->direction == DMA_TO_DEVICE)
+		if (config->direction == MEM_TO_DEV)
 			size = config->dst_addr_width * config->dst_maxburst;
 		else
 			size = config->src_addr_width * config->src_maxburst;
diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index d746899..a47c312 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -106,7 +106,7 @@ static int imxdma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 		imx_dma_disable(imxdmac->imxdma_channel);
 		return 0;
 	case DMA_SLAVE_CONFIG:
-		if (dmaengine_cfg->direction == DMA_FROM_DEVICE) {
+		if (dmaengine_cfg->direction == DEV_TO_MEM) {
 			imxdmac->per_address = dmaengine_cfg->src_addr;
 			imxdmac->watermark_level = dmaengine_cfg->src_maxburst;
 			imxdmac->word_size = dmaengine_cfg->src_addr_width;
@@ -223,7 +223,7 @@ static void imxdma_free_chan_resources(struct dma_chan *chan)
 
 static struct dma_async_tx_descriptor *imxdma_prep_slave_sg(
 		struct dma_chan *chan, struct scatterlist *sgl,
-		unsigned int sg_len, enum dma_data_direction direction,
+		unsigned int sg_len, enum dma_transfer_direction direction,
 		unsigned long flags)
 {
 	struct imxdma_channel *imxdmac = to_imxdma_chan(chan);
@@ -240,7 +240,7 @@ static struct dma_async_tx_descriptor *imxdma_prep_slave_sg(
 		dma_length += sg->length;
 	}
 
-	if (direction == DMA_FROM_DEVICE)
+	if (direction == DEV_TO_MEM)
 		dmamode = DMA_MODE_READ;
 	else
 		dmamode = DMA_MODE_WRITE;
@@ -270,7 +270,7 @@ static struct dma_async_tx_descriptor *imxdma_prep_slave_sg(
 
 static struct dma_async_tx_descriptor *imxdma_prep_dma_cyclic(
 		struct dma_chan *chan, dma_addr_t dma_addr, size_t buf_len,
-		size_t period_len, enum dma_data_direction direction)
+		size_t period_len, enum dma_transfer_direction direction)
 {
 	struct imxdma_channel *imxdmac = to_imxdma_chan(chan);
 	struct imxdma_engine *imxdma = imxdmac->imxdma;
@@ -316,7 +316,7 @@ static struct dma_async_tx_descriptor *imxdma_prep_dma_cyclic(
 	imxdmac->sg_list[periods].page_link =
 		((unsigned long)imxdmac->sg_list | 0x01) & ~0x02;
 
-	if (direction == DMA_FROM_DEVICE)
+	if (direction == DEV_TO_MEM)
 		dmamode = DMA_MODE_READ;
 	else
 		dmamode = DMA_MODE_WRITE;
diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index eab1fe7..ae0c9a0 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -246,7 +246,7 @@ struct sdma_engine;
 struct sdma_channel {
 	struct sdma_engine		*sdma;
 	unsigned int			channel;
-	enum dma_data_direction		direction;
+	enum dma_transfer_direction		direction;
 	enum sdma_peripheral_type	peripheral_type;
 	unsigned int			event_id0;
 	unsigned int			event_id1;
@@ -649,7 +649,7 @@ static int sdma_load_context(struct sdma_channel *sdmac)
 	struct sdma_buffer_descriptor *bd0 = sdma->channel[0].bd;
 	int ret;
 
-	if (sdmac->direction == DMA_FROM_DEVICE) {
+	if (sdmac->direction == DEV_TO_MEM) {
 		load_address = sdmac->pc_from_device;
 	} else {
 		load_address = sdmac->pc_to_device;
@@ -910,7 +910,7 @@ static void sdma_free_chan_resources(struct dma_chan *chan)
 
 static struct dma_async_tx_descriptor *sdma_prep_slave_sg(
 		struct dma_chan *chan, struct scatterlist *sgl,
-		unsigned int sg_len, enum dma_data_direction direction,
+		unsigned int sg_len, enum dma_transfer_direction direction,
 		unsigned long flags)
 {
 	struct sdma_channel *sdmac = to_sdma_chan(chan);
@@ -1007,7 +1007,7 @@ err_out:
 
 static struct dma_async_tx_descriptor *sdma_prep_dma_cyclic(
 		struct dma_chan *chan, dma_addr_t dma_addr, size_t buf_len,
-		size_t period_len, enum dma_data_direction direction)
+		size_t period_len, enum dma_transfer_direction direction)
 {
 	struct sdma_channel *sdmac = to_sdma_chan(chan);
 	struct sdma_engine *sdma = sdmac->sdma;
@@ -1092,7 +1092,7 @@ static int sdma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 		sdma_disable_channel(sdmac);
 		return 0;
 	case DMA_SLAVE_CONFIG:
-		if (dmaengine_cfg->direction == DMA_FROM_DEVICE) {
+		if (dmaengine_cfg->direction == DEV_TO_MEM) {
 			sdmac->per_address = dmaengine_cfg->src_addr;
 			sdmac->watermark_level = dmaengine_cfg->src_maxburst;
 			sdmac->word_size = dmaengine_cfg->src_addr_width;
diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
index cf74a66..e4f34c4 100644
--- a/drivers/dma/intel_mid_dma.c
+++ b/drivers/dma/intel_mid_dma.c
@@ -396,10 +396,10 @@ static int midc_lli_fill_sg(struct intel_mid_dma_chan *midc,
 							midc->dma->block_size);
 		/*Populate SAR and DAR values*/
 		sg_phy_addr = sg_phys(sg);
-		if (desc->dirn ==  DMA_TO_DEVICE) {
+		if (desc->dirn ==  MEM_TO_DEV) {
 			lli_bloc_desc->sar  = sg_phy_addr;
 			lli_bloc_desc->dar  = mids->dma_slave.dst_addr;
-		} else if (desc->dirn ==  DMA_FROM_DEVICE) {
+		} else if (desc->dirn ==  DEV_TO_MEM) {
 			lli_bloc_desc->sar  = mids->dma_slave.src_addr;
 			lli_bloc_desc->dar  = sg_phy_addr;
 		}
@@ -633,13 +633,13 @@ static struct dma_async_tx_descriptor *intel_mid_dma_prep_memcpy(
 		if (midc->dma->pimr_mask) {
 			cfg_hi.cfgx.protctl = 0x0; /*default value*/
 			cfg_hi.cfgx.fifo_mode = 1;
-			if (mids->dma_slave.direction == DMA_TO_DEVICE) {
+			if (mids->dma_slave.direction == MEM_TO_DEV) {
 				cfg_hi.cfgx.src_per = 0;
 				if (mids->device_instance == 0)
 					cfg_hi.cfgx.dst_per = 3;
 				if (mids->device_instance == 1)
 					cfg_hi.cfgx.dst_per = 1;
-			} else if (mids->dma_slave.direction == DMA_FROM_DEVICE) {
+			} else if (mids->dma_slave.direction == DEV_TO_MEM) {
 				if (mids->device_instance == 0)
 					cfg_hi.cfgx.src_per = 2;
 				if (mids->device_instance == 1)
@@ -683,11 +683,11 @@ static struct dma_async_tx_descriptor *intel_mid_dma_prep_memcpy(
 		ctl_lo.ctlx.sinc = 0;
 		ctl_lo.ctlx.dinc = 0;
 	} else {
-		if (mids->dma_slave.direction == DMA_TO_DEVICE) {
+		if (mids->dma_slave.direction == MEM_TO_DEV) {
 			ctl_lo.ctlx.sinc = 0;
 			ctl_lo.ctlx.dinc = 2;
 			ctl_lo.ctlx.tt_fc = 1;
-		} else if (mids->dma_slave.direction == DMA_FROM_DEVICE) {
+		} else if (mids->dma_slave.direction == DEV_TO_MEM) {
 			ctl_lo.ctlx.sinc = 2;
 			ctl_lo.ctlx.dinc = 0;
 			ctl_lo.ctlx.tt_fc = 2;
@@ -733,7 +733,7 @@ err_desc_get:
  */
 static struct dma_async_tx_descriptor *intel_mid_dma_prep_slave_sg(
 			struct dma_chan *chan, struct scatterlist *sgl,
-			unsigned int sg_len, enum dma_data_direction direction,
+			unsigned int sg_len, enum dma_transfer_direction direction,
 			unsigned long flags)
 {
 	struct intel_mid_dma_chan *midc = NULL;
diff --git a/drivers/dma/intel_mid_dma_regs.h b/drivers/dma/intel_mid_dma_regs.h
index aea5ee8..c6de919 100644
--- a/drivers/dma/intel_mid_dma_regs.h
+++ b/drivers/dma/intel_mid_dma_regs.h
@@ -262,7 +262,7 @@ struct intel_mid_dma_desc {
 	unsigned int			lli_length;
 	unsigned int			current_lli;
 	dma_addr_t			next;
-	enum dma_data_direction		dirn;
+	enum dma_transfer_direction		dirn;
 	enum dma_status			status;
 	enum dma_slave_buswidth		width; /*width of DMA txn*/
 	enum intel_mid_dma_mode		cfg_mode; /*mode configuration*/
diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
index 6815905..8bb6556 100644
--- a/drivers/dma/ipu/ipu_idmac.c
+++ b/drivers/dma/ipu/ipu_idmac.c
@@ -1362,7 +1362,7 @@ static void ipu_gc_tasklet(unsigned long arg)
 /* Allocate and initialise a transfer descriptor. */
 static struct dma_async_tx_descriptor *idmac_prep_slave_sg(struct dma_chan *chan,
 		struct scatterlist *sgl, unsigned int sg_len,
-		enum dma_data_direction direction, unsigned long tx_flags)
+		enum dma_transfer_direction direction, unsigned long tx_flags)
 {
 	struct idmac_channel *ichan = to_idmac_chan(chan);
 	struct idmac_tx_desc *desc = NULL;
@@ -1374,7 +1374,7 @@ static struct dma_async_tx_descriptor *idmac_prep_slave_sg(struct dma_chan *chan
 	    chan->chan_id != IDMAC_IC_7)
 		return NULL;
 
-	if (direction != DMA_FROM_DEVICE && direction != DMA_TO_DEVICE) {
+	if (direction != DEV_TO_MEM && direction != MEM_TO_DEV) {
 		dev_err(chan->device->dev, "Invalid DMA direction %d!\n", direction);
 		return NULL;
 	}
diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
index b4588bd..be3c613 100644
--- a/drivers/dma/mxs-dma.c
+++ b/drivers/dma/mxs-dma.c
@@ -377,7 +377,7 @@ static void mxs_dma_free_chan_resources(struct dma_chan *chan)
 
 static struct dma_async_tx_descriptor *mxs_dma_prep_slave_sg(
 		struct dma_chan *chan, struct scatterlist *sgl,
-		unsigned int sg_len, enum dma_data_direction direction,
+		unsigned int sg_len, enum dma_transfer_direction direction,
 		unsigned long append)
 {
 	struct mxs_dma_chan *mxs_chan = to_mxs_dma_chan(chan);
@@ -450,7 +450,7 @@ static struct dma_async_tx_descriptor *mxs_dma_prep_slave_sg(
 			ccw->bits |= CCW_CHAIN;
 			ccw->bits |= CCW_HALT_ON_TERM;
 			ccw->bits |= CCW_TERM_FLUSH;
-			ccw->bits |= BF_CCW(direction == DMA_FROM_DEVICE ?
+			ccw->bits |= BF_CCW(direction == DEV_TO_MEM ?
 					MXS_DMA_CMD_WRITE : MXS_DMA_CMD_READ,
 					COMMAND);
 
@@ -472,7 +472,7 @@ err_out:
 
 static struct dma_async_tx_descriptor *mxs_dma_prep_dma_cyclic(
 		struct dma_chan *chan, dma_addr_t dma_addr, size_t buf_len,
-		size_t period_len, enum dma_data_direction direction)
+		size_t period_len, enum dma_transfer_direction direction)
 {
 	struct mxs_dma_chan *mxs_chan = to_mxs_dma_chan(chan);
 	struct mxs_dma_engine *mxs_dma = mxs_chan->mxs_dma;
@@ -515,7 +515,7 @@ static struct dma_async_tx_descriptor *mxs_dma_prep_dma_cyclic(
 		ccw->bits |= CCW_IRQ;
 		ccw->bits |= CCW_HALT_ON_TERM;
 		ccw->bits |= CCW_TERM_FLUSH;
-		ccw->bits |= BF_CCW(direction == DMA_FROM_DEVICE ?
+		ccw->bits |= BF_CCW(direction == DEV_TO_MEM ?
 				MXS_DMA_CMD_WRITE : MXS_DMA_CMD_READ, COMMAND);
 
 		dma_addr += period_len;
diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
index a6d0e3d..cd35e59 100644
--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -99,7 +99,7 @@ struct pch_dma_desc {
 struct pch_dma_chan {
 	struct dma_chan		chan;
 	void __iomem *membase;
-	enum dma_data_direction	dir;
+	enum dma_transfer_direction dir;
 	struct tasklet_struct	tasklet;
 	unsigned long		err_status;
 
@@ -224,7 +224,7 @@ static void pdc_set_dir(struct dma_chan *chan)
 		mask_ctl = DMA_MASK_CTL0_MODE & ~(DMA_CTL0_MODE_MASK_BITS <<
 				       (DMA_CTL0_BITS_PER_CH * chan->chan_id));
 		val &= mask_mode;
-		if (pd_chan->dir == DMA_TO_DEVICE)
+		if (pd_chan->dir == MEM_TO_DEV)
 			val |= 0x1 << (DMA_CTL0_BITS_PER_CH * chan->chan_id +
 				       DMA_CTL0_DIR_SHIFT_BITS);
 		else
@@ -242,7 +242,7 @@ static void pdc_set_dir(struct dma_chan *chan)
 		mask_ctl = DMA_MASK_CTL2_MODE & ~(DMA_CTL0_MODE_MASK_BITS <<
 						 (DMA_CTL0_BITS_PER_CH * ch));
 		val &= mask_mode;
-		if (pd_chan->dir == DMA_TO_DEVICE)
+		if (pd_chan->dir == MEM_TO_DEV)
 			val |= 0x1 << (DMA_CTL0_BITS_PER_CH * ch +
 				       DMA_CTL0_DIR_SHIFT_BITS);
 		else
@@ -607,7 +607,7 @@ static void pd_issue_pending(struct dma_chan *chan)
 
 static struct dma_async_tx_descriptor *pd_prep_slave_sg(struct dma_chan *chan,
 			struct scatterlist *sgl, unsigned int sg_len,
-			enum dma_data_direction direction, unsigned long flags)
+			enum dma_transfer_direction direction, unsigned long flags)
 {
 	struct pch_dma_chan *pd_chan = to_pd_chan(chan);
 	struct pch_dma_slave *pd_slave = chan->private;
@@ -623,9 +623,9 @@ static struct dma_async_tx_descriptor *pd_prep_slave_sg(struct dma_chan *chan,
 		return NULL;
 	}
 
-	if (direction == DMA_FROM_DEVICE)
+	if (direction == DEV_TO_MEM)
 		reg = pd_slave->rx_reg;
-	else if (direction == DMA_TO_DEVICE)
+	else if (direction == MEM_TO_DEV)
 		reg = pd_slave->tx_reg;
 	else
 		return NULL;
diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 5710414..91e8d1f 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -320,14 +320,14 @@ static int pl330_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd, unsigned
 	case DMA_SLAVE_CONFIG:
 		slave_config = (struct dma_slave_config *)arg;
 
-		if (slave_config->direction == DMA_TO_DEVICE) {
+		if (slave_config->direction == MEM_TO_DEV) {
 			if (slave_config->dst_addr)
 				pch->fifo_addr = slave_config->dst_addr;
 			if (slave_config->dst_addr_width)
 				pch->burst_sz = __ffs(slave_config->dst_addr_width);
 			if (slave_config->dst_maxburst)
 				pch->burst_len = slave_config->dst_maxburst;
-		} else if (slave_config->direction == DMA_FROM_DEVICE) {
+		} else if (slave_config->direction == DEV_TO_MEM) {
 			if (slave_config->src_addr)
 				pch->fifo_addr = slave_config->src_addr;
 			if (slave_config->src_addr_width)
@@ -597,7 +597,7 @@ static inline int get_burst_len(struct dma_pl330_desc *desc, size_t len)
 
 static struct dma_async_tx_descriptor *pl330_prep_dma_cyclic(
 		struct dma_chan *chan, dma_addr_t dma_addr, size_t len,
-		size_t period_len, enum dma_data_direction direction)
+		size_t period_len, enum dma_transfer_direction direction)
 {
 	struct dma_pl330_desc *desc;
 	struct dma_pl330_chan *pch = to_pchan(chan);
@@ -612,13 +612,13 @@ static struct dma_async_tx_descriptor *pl330_prep_dma_cyclic(
 	}
 
 	switch (direction) {
-	case DMA_TO_DEVICE:
+	case MEM_TO_DEV:
 		desc->rqcfg.src_inc = 1;
 		desc->rqcfg.dst_inc = 0;
 		src = dma_addr;
 		dst = pch->fifo_addr;
 		break;
-	case DMA_FROM_DEVICE:
+	case DEV_TO_MEM:
 		desc->rqcfg.src_inc = 0;
 		desc->rqcfg.dst_inc = 1;
 		src = pch->fifo_addr;
@@ -687,7 +687,7 @@ pl330_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dst,
 
 static struct dma_async_tx_descriptor *
 pl330_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
-		unsigned int sg_len, enum dma_data_direction direction,
+		unsigned int sg_len, enum dma_transfer_direction direction,
 		unsigned long flg)
 {
 	struct dma_pl330_desc *first, *desc = NULL;
@@ -702,9 +702,9 @@ pl330_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 		return NULL;
 
 	/* Make sure the direction is consistent */
-	if ((direction == DMA_TO_DEVICE &&
+	if ((direction == MEM_TO_DEV &&
 				peri->rqtype != MEMTODEV) ||
-			(direction == DMA_FROM_DEVICE &&
+			(direction == DEV_TO_MEM &&
 				peri->rqtype != DEVTOMEM)) {
 		dev_err(pch->dmac->pif.dev, "%s:%d Invalid Direction\n",
 				__func__, __LINE__);
@@ -747,7 +747,7 @@ pl330_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 		else
 			list_add_tail(&desc->node, &first->node);
 
-		if (direction == DMA_TO_DEVICE) {
+		if (direction == MEM_TO_DEV) {
 			desc->rqcfg.src_inc = 1;
 			desc->rqcfg.dst_inc = 0;
 			fill_px(&desc->px,
diff --git a/drivers/dma/shdma.c b/drivers/dma/shdma.c
index 81809c2..cab7d3e 100644
--- a/drivers/dma/shdma.c
+++ b/drivers/dma/shdma.c
@@ -23,7 +23,6 @@
 #include <linux/interrupt.h>
 #include <linux/dmaengine.h>
 #include <linux/delay.h>
-#include <linux/dma-mapping.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/sh_dma.h>
@@ -479,19 +478,19 @@ static void sh_dmae_free_chan_resources(struct dma_chan *chan)
  * @sh_chan:	DMA channel
  * @flags:	DMA transfer flags
  * @dest:	destination DMA address, incremented when direction equals
- *		DMA_FROM_DEVICE or DMA_BIDIRECTIONAL
+ *		DEV_TO_MEM
  * @src:	source DMA address, incremented when direction equals
- *		DMA_TO_DEVICE or DMA_BIDIRECTIONAL
+ *		MEM_TO_DEV
  * @len:	DMA transfer length
  * @first:	if NULL, set to the current descriptor and cookie set to -EBUSY
  * @direction:	needed for slave DMA to decide which address to keep constant,
- *		equals DMA_BIDIRECTIONAL for MEMCPY
+ *		equals MEM_TO_MEM for MEMCPY
  * Returns 0 or an error
  * Locks: called with desc_lock held
  */
 static struct sh_desc *sh_dmae_add_desc(struct sh_dmae_chan *sh_chan,
 	unsigned long flags, dma_addr_t *dest, dma_addr_t *src, size_t *len,
-	struct sh_desc **first, enum dma_data_direction direction)
+	struct sh_desc **first, enum dma_transfer_direction direction)
 {
 	struct sh_desc *new;
 	size_t copy_size;
@@ -531,9 +530,9 @@ static struct sh_desc *sh_dmae_add_desc(struct sh_dmae_chan *sh_chan,
 	new->direction = direction;
 
 	*len -= copy_size;
-	if (direction == DMA_BIDIRECTIONAL || direction == DMA_TO_DEVICE)
+	if (direction == MEM_TO_MEM || direction == MEM_TO_DEV)
 		*src += copy_size;
-	if (direction == DMA_BIDIRECTIONAL || direction == DMA_FROM_DEVICE)
+	if (direction == MEM_TO_MEM || direction == DEV_TO_MEM)
 		*dest += copy_size;
 
 	return new;
@@ -546,12 +545,12 @@ static struct sh_desc *sh_dmae_add_desc(struct sh_dmae_chan *sh_chan,
  * converted to scatter-gather to guarantee consistent locking and a correct
  * list manipulation. For slave DMA direction carries the usual meaning, and,
  * logically, the SG list is RAM and the addr variable contains slave address,
- * e.g., the FIFO I/O register. For MEMCPY direction equals DMA_BIDIRECTIONAL
+ * e.g., the FIFO I/O register. For MEMCPY direction equals MEM_TO_MEM
  * and the SG list contains only one element and points at the source buffer.
  */
 static struct dma_async_tx_descriptor *sh_dmae_prep_sg(struct sh_dmae_chan *sh_chan,
 	struct scatterlist *sgl, unsigned int sg_len, dma_addr_t *addr,
-	enum dma_data_direction direction, unsigned long flags)
+	enum dma_transfer_direction direction, unsigned long flags)
 {
 	struct scatterlist *sg;
 	struct sh_desc *first = NULL, *new = NULL /* compiler... */;
@@ -592,7 +591,7 @@ static struct dma_async_tx_descriptor *sh_dmae_prep_sg(struct sh_dmae_chan *sh_c
 			dev_dbg(sh_chan->dev, "Add SG #%d@%p[%d], dma %llx\n",
 				i, sg, len, (unsigned long long)sg_addr);
 
-			if (direction == DMA_FROM_DEVICE)
+			if (direction == DEV_TO_MEM)
 				new = sh_dmae_add_desc(sh_chan, flags,
 						&sg_addr, addr, &len, &first,
 						direction);
@@ -646,13 +645,13 @@ static struct dma_async_tx_descriptor *sh_dmae_prep_memcpy(
 	sg_dma_address(&sg) = dma_src;
 	sg_dma_len(&sg) = len;
 
-	return sh_dmae_prep_sg(sh_chan, &sg, 1, &dma_dest, DMA_BIDIRECTIONAL,
+	return sh_dmae_prep_sg(sh_chan, &sg, 1, &dma_dest, MEM_TO_MEM,
 			       flags);
 }
 
 static struct dma_async_tx_descriptor *sh_dmae_prep_slave_sg(
 	struct dma_chan *chan, struct scatterlist *sgl, unsigned int sg_len,
-	enum dma_data_direction direction, unsigned long flags)
+	enum dma_transfer_direction direction, unsigned long flags)
 {
 	struct sh_dmae_slave *param;
 	struct sh_dmae_chan *sh_chan;
@@ -996,7 +995,7 @@ static void dmae_do_tasklet(unsigned long data)
 	spin_lock_irq(&sh_chan->desc_lock);
 	list_for_each_entry(desc, &sh_chan->ld_queue, node) {
 		if (desc->mark == DESC_SUBMITTED &&
-		    ((desc->direction == DMA_FROM_DEVICE &&
+		    ((desc->direction == DEV_TO_MEM &&
 		      (desc->hw.dar + desc->hw.tcr) == dar_buf) ||
 		     (desc->hw.sar + desc->hw.tcr) == sar_buf)) {
 			dev_dbg(sh_chan->dev, "done #%d@%p dst %u\n",
diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 467e4dc..1e600e2 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -216,7 +216,7 @@ struct d40_chan {
 	struct d40_log_lli_full		*lcpa;
 	/* Runtime reconfiguration */
 	dma_addr_t			runtime_addr;
-	enum dma_data_direction		runtime_direction;
+	enum dma_transfer_direction	runtime_direction;
 };
 
 /**
@@ -1854,7 +1854,7 @@ err:
 }
 
 static dma_addr_t
-d40_get_dev_addr(struct d40_chan *chan, enum dma_data_direction direction)
+d40_get_dev_addr(struct d40_chan *chan, enum dma_transfer_direction direction)
 {
 	struct stedma40_platform_data *plat = chan->base->plat_data;
 	struct stedma40_chan_cfg *cfg = &chan->dma_cfg;
@@ -1863,9 +1863,9 @@ d40_get_dev_addr(struct d40_chan *chan, enum dma_data_direction direction)
 	if (chan->runtime_addr)
 		return chan->runtime_addr;
 
-	if (direction == DMA_FROM_DEVICE)
+	if (direction == DEV_TO_MEM)
 		addr = plat->dev_rx[cfg->src_dev_type];
-	else if (direction == DMA_TO_DEVICE)
+	else if (direction == MEM_TO_DEV)
 		addr = plat->dev_tx[cfg->dst_dev_type];
 
 	return addr;
@@ -1874,7 +1874,7 @@ d40_get_dev_addr(struct d40_chan *chan, enum dma_data_direction direction)
 static struct dma_async_tx_descriptor *
 d40_prep_sg(struct dma_chan *dchan, struct scatterlist *sg_src,
 	    struct scatterlist *sg_dst, unsigned int sg_len,
-	    enum dma_data_direction direction, unsigned long dma_flags)
+	    enum dma_transfer_direction direction, unsigned long dma_flags)
 {
 	struct d40_chan *chan = container_of(dchan, struct d40_chan, chan);
 	dma_addr_t src_dev_addr = 0;
@@ -1901,9 +1901,9 @@ d40_prep_sg(struct dma_chan *dchan, struct scatterlist *sg_src,
 	if (direction != DMA_NONE) {
 		dma_addr_t dev_addr = d40_get_dev_addr(chan, direction);
 
-		if (direction == DMA_FROM_DEVICE)
+		if (direction == DEV_TO_MEM)
 			src_dev_addr = dev_addr;
-		else if (direction == DMA_TO_DEVICE)
+		else if (direction == MEM_TO_DEV)
 			dst_dev_addr = dev_addr;
 	}
 
@@ -2107,10 +2107,10 @@ d40_prep_memcpy_sg(struct dma_chan *chan,
 static struct dma_async_tx_descriptor *d40_prep_slave_sg(struct dma_chan *chan,
 							 struct scatterlist *sgl,
 							 unsigned int sg_len,
-							 enum dma_data_direction direction,
+							 enum dma_transfer_direction direction,
 							 unsigned long dma_flags)
 {
-	if (direction != DMA_FROM_DEVICE && direction != DMA_TO_DEVICE)
+	if (direction != DEV_TO_MEM && direction != MEM_TO_DEV)
 		return NULL;
 
 	return d40_prep_sg(chan, sgl, sgl, sg_len, direction, dma_flags);
@@ -2119,7 +2119,7 @@ static struct dma_async_tx_descriptor *d40_prep_slave_sg(struct dma_chan *chan,
 static struct dma_async_tx_descriptor *
 dma40_prep_dma_cyclic(struct dma_chan *chan, dma_addr_t dma_addr,
 		     size_t buf_len, size_t period_len,
-		     enum dma_data_direction direction)
+		     enum dma_transfer_direction direction)
 {
 	unsigned int periods = buf_len / period_len;
 	struct dma_async_tx_descriptor *txd;
@@ -2268,7 +2268,7 @@ static int d40_set_runtime_config(struct dma_chan *chan,
 	dst_addr_width = config->dst_addr_width;
 	dst_maxburst = config->dst_maxburst;
 
-	if (config->direction == DMA_FROM_DEVICE) {
+	if (config->direction == DEV_TO_MEM) {
 		dma_addr_t dev_addr_rx =
 			d40c->base->plat_data->dev_rx[cfg->src_dev_type];
 
@@ -2291,7 +2291,7 @@ static int d40_set_runtime_config(struct dma_chan *chan,
 		if (dst_maxburst == 0)
 			dst_maxburst = src_maxburst;
 
-	} else if (config->direction == DMA_TO_DEVICE) {
+	} else if (config->direction == MEM_TO_DEV) {
 		dma_addr_t dev_addr_tx =
 			d40c->base->plat_data->dev_tx[cfg->dst_dev_type];
 
@@ -2356,7 +2356,7 @@ static int d40_set_runtime_config(struct dma_chan *chan,
 		"configured channel %s for %s, data width %d/%d, "
 		"maxburst %d/%d elements, LE, no flow control\n",
 		dma_chan_name(chan),
-		(config->direction == DMA_FROM_DEVICE) ? "RX" : "TX",
+		(config->direction == DEV_TO_MEM) ? "RX" : "TX",
 		src_addr_width, dst_addr_width,
 		src_maxburst, dst_maxburst);
 
diff --git a/drivers/dma/timb_dma.c b/drivers/dma/timb_dma.c
index a4a398f..764ae74 100644
--- a/drivers/dma/timb_dma.c
+++ b/drivers/dma/timb_dma.c
@@ -90,7 +90,7 @@ struct timb_dma_chan {
 	struct list_head	queue;
 	struct list_head	free_list;
 	unsigned int		bytes_per_line;
-	enum dma_data_direction	direction;
+	enum dma_transfer_direction	direction;
 	unsigned int		descs; /* Descriptors to allocate */
 	unsigned int		desc_elems; /* number of elems per descriptor */
 };
@@ -235,7 +235,7 @@ static void __td_start_dma(struct timb_dma_chan *td_chan)
 		"td_chan: %p, chan: %d, membase: %p\n",
 		td_chan, td_chan->chan.chan_id, td_chan->membase);
 
-	if (td_chan->direction == DMA_FROM_DEVICE) {
+	if (td_chan->direction == DEV_TO_MEM) {
 
 		/* descriptor address */
 		iowrite32(0, td_chan->membase + TIMBDMA_OFFS_RX_DHAR);
@@ -278,7 +278,7 @@ static void __td_finish(struct timb_dma_chan *td_chan)
 		txd->cookie);
 
 	/* make sure to stop the transfer */
-	if (td_chan->direction == DMA_FROM_DEVICE)
+	if (td_chan->direction == DEV_TO_MEM)
 		iowrite32(0, td_chan->membase + TIMBDMA_OFFS_RX_ER);
 /* Currently no support for stopping DMA transfers
 	else
@@ -398,7 +398,7 @@ static struct timb_dma_desc *td_alloc_init_desc(struct timb_dma_chan *td_chan)
 	td_desc->txd.flags = DMA_CTRL_ACK;
 
 	td_desc->txd.phys = dma_map_single(chan2dmadev(chan),
-		td_desc->desc_list, td_desc->desc_list_len, DMA_TO_DEVICE);
+		td_desc->desc_list, td_desc->desc_list_len, MEM_TO_DEV);
 
 	err = dma_mapping_error(chan2dmadev(chan), td_desc->txd.phys);
 	if (err) {
@@ -419,7 +419,7 @@ static void td_free_desc(struct timb_dma_desc *td_desc)
 {
 	dev_dbg(chan2dev(td_desc->txd.chan), "Freeing desc: %p\n", td_desc);
 	dma_unmap_single(chan2dmadev(td_desc->txd.chan), td_desc->txd.phys,
-		td_desc->desc_list_len, DMA_TO_DEVICE);
+		td_desc->desc_list_len, MEM_TO_DEV);
 
 	kfree(td_desc->desc_list);
 	kfree(td_desc);
@@ -558,7 +558,7 @@ static void td_issue_pending(struct dma_chan *chan)
 
 static struct dma_async_tx_descriptor *td_prep_slave_sg(struct dma_chan *chan,
 	struct scatterlist *sgl, unsigned int sg_len,
-	enum dma_data_direction direction, unsigned long flags)
+	enum dma_transfer_direction direction, unsigned long flags)
 {
 	struct timb_dma_chan *td_chan =
 		container_of(chan, struct timb_dma_chan, chan);
@@ -606,7 +606,7 @@ static struct dma_async_tx_descriptor *td_prep_slave_sg(struct dma_chan *chan,
 	}
 
 	dma_sync_single_for_device(chan2dmadev(chan), td_desc->txd.phys,
-		td_desc->desc_list_len, DMA_TO_DEVICE);
+		td_desc->desc_list_len, MEM_TO_DEV);
 
 	return &td_desc->txd;
 }
@@ -775,8 +775,8 @@ static int __devinit td_probe(struct platform_device *pdev)
 		td_chan->descs = pchan->descriptors;
 		td_chan->desc_elems = pchan->descriptor_elements;
 		td_chan->bytes_per_line = pchan->bytes_per_line;
-		td_chan->direction = pchan->rx ? DMA_FROM_DEVICE :
-			DMA_TO_DEVICE;
+		td_chan->direction = pchan->rx ? DEV_TO_MEM :
+			MEM_TO_DEV;
 
 		td_chan->membase = td->membase +
 			(i / 2) * TIMBDMA_INSTANCE_OFFSET +
diff --git a/drivers/dma/txx9dmac.c b/drivers/dma/txx9dmac.c
index cbd83e3..ce6e772 100644
--- a/drivers/dma/txx9dmac.c
+++ b/drivers/dma/txx9dmac.c
@@ -845,7 +845,7 @@ txx9dmac_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 
 static struct dma_async_tx_descriptor *
 txx9dmac_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
-		unsigned int sg_len, enum dma_data_direction direction,
+		unsigned int sg_len, enum dma_transfer_direction direction,
 		unsigned long flags)
 {
 	struct txx9dmac_chan *dc = to_txx9dmac_chan(chan);
@@ -860,9 +860,9 @@ txx9dmac_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 
 	BUG_ON(!ds || !ds->reg_width);
 	if (ds->tx_reg)
-		BUG_ON(direction != DMA_TO_DEVICE);
+		BUG_ON(direction != MEM_TO_DEV);
 	else
-		BUG_ON(direction != DMA_FROM_DEVICE);
+		BUG_ON(direction != DEV_TO_MEM);
 	if (unlikely(!sg_len))
 		return NULL;
 
@@ -882,7 +882,7 @@ txx9dmac_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 		mem = sg_dma_address(sg);
 
 		if (__is_dmac64(ddev)) {
-			if (direction == DMA_TO_DEVICE) {
+			if (direction == MEM_TO_DEV) {
 				desc->hwdesc.SAR = mem;
 				desc->hwdesc.DAR = ds->tx_reg;
 			} else {
@@ -891,7 +891,7 @@ txx9dmac_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 			}
 			desc->hwdesc.CNTR = sg_dma_len(sg);
 		} else {
-			if (direction == DMA_TO_DEVICE) {
+			if (direction == MEM_TO_DEV) {
 				desc->hwdesc32.SAR = mem;
 				desc->hwdesc32.DAR = ds->tx_reg;
 			} else {
@@ -900,7 +900,7 @@ txx9dmac_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 			}
 			desc->hwdesc32.CNTR = sg_dma_len(sg);
 		}
-		if (direction == DMA_TO_DEVICE) {
+		if (direction == MEM_TO_DEV) {
 			sai = ds->reg_width;
 			dai = 0;
 		} else {
diff --git a/include/linux/amba/pl08x.h b/include/linux/amba/pl08x.h
index 9eabffb..033f6aa 100644
--- a/include/linux/amba/pl08x.h
+++ b/include/linux/amba/pl08x.h
@@ -134,7 +134,7 @@ struct pl08x_txd {
 	struct dma_async_tx_descriptor tx;
 	struct list_head node;
 	struct list_head dsg_list;
-	enum dma_data_direction	direction;
+	enum dma_transfer_direction direction;
 	dma_addr_t llis_bus;
 	struct pl08x_lli *llis_va;
 	/* Default cctl value for LLIs */
@@ -197,7 +197,7 @@ struct pl08x_dma_chan {
 	dma_addr_t dst_addr;
 	u32 src_cctl;
 	u32 dst_cctl;
-	enum dma_data_direction	runtime_direction;
+	enum dma_transfer_direction runtime_direction;
 	dma_cookie_t lc;
 	struct list_head pend_list;
 	struct pl08x_txd *at;
diff --git a/include/linux/dw_dmac.h b/include/linux/dw_dmac.h
index 4bfe0a2..f2c64f9 100644
--- a/include/linux/dw_dmac.h
+++ b/include/linux/dw_dmac.h
@@ -127,7 +127,7 @@ struct dw_cyclic_desc {
 
 struct dw_cyclic_desc *dw_dma_cyclic_prep(struct dma_chan *chan,
 		dma_addr_t buf_addr, size_t buf_len, size_t period_len,
-		enum dma_data_direction direction);
+		enum dma_transfer_direction direction);
 void dw_dma_cyclic_free(struct dma_chan *chan);
 int dw_dma_cyclic_start(struct dma_chan *chan);
 void dw_dma_cyclic_stop(struct dma_chan *chan);
diff --git a/include/linux/sh_dma.h b/include/linux/sh_dma.h
index cb2dd11..62ef693 100644
--- a/include/linux/sh_dma.h
+++ b/include/linux/sh_dma.h
@@ -30,7 +30,7 @@ struct sh_desc {
 	struct sh_dmae_regs hw;
 	struct list_head node;
 	struct dma_async_tx_descriptor async_tx;
-	enum dma_data_direction direction;
+	enum dma_transfer_direction direction;
 	dma_cookie_t cookie;
 	size_t partial;
 	int chunks;
-- 
1.7.0.4

