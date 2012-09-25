Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab2IYMOg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 08:14:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:42151 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755275Ab2IYMNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 08:13:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,481,1344236400"; 
   d="scan'208";a="212645270"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv1 4/6] avr32: at32ap700x: rename DMA controller
Date: Tue, 25 Sep 2012 15:13:08 +0300
Message-Id: <1348575190-11761-5-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1348575190-11761-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1348575190-11761-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

There are no functional changes.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 arch/avr32/mach-at32ap/at32ap700x.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
index b323d8d..8ec75b0 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -603,19 +603,19 @@ static void __init genclk_init_parent(struct clk *clk)
 	clk->parent = parent;
 }
 
-static struct dw_dma_platform_data dw_dmac0_data = {
+static struct dw_dma_platform_data at32_dmac0_data = {
 	.nr_channels	= 3,
 	.block_size	= 4095U,
 	.nr_masters	= 2,
 	.data_width	= { 2, 2, 0, 0 },
 };
 
-static struct resource dw_dmac0_resource[] = {
+static struct resource at32_dmac0_resource[] = {
 	PBMEM(0xff200000),
 	IRQ(2),
 };
-DEFINE_DEV_DATA(dw_dmac, 0);
-DEV_CLK(hclk, dw_dmac0, hsb, 10);
+DEFINE_DEV_DATA(at32_dmac, 0);
+DEV_CLK(hclk, at32_dmac0, hsb, 10);
 
 /* --------------------------------------------------------------------
  *  System peripherals
@@ -831,7 +831,7 @@ static int __init system_device_init(void)
 	platform_device_register(&at32_eic0_device);
 	platform_device_register(&smc0_device);
 	platform_device_register(&pdc_device);
-	platform_device_register(&dw_dmac0_device);
+	platform_device_register(&at32_dmac0_device);
 
 	platform_device_register(&at32_tcb0_device);
 	platform_device_register(&at32_tcb1_device);
@@ -1353,7 +1353,7 @@ at32_add_device_mci(unsigned int id, struct mci_platform_data *data)
 	if (!slave)
 		goto fail;
 
-	slave->sdata.dma_dev = &dw_dmac0_device.dev;
+	slave->sdata.dma_dev = &at32_dmac0_device.dev;
 	slave->sdata.cfg_hi = (DWC_CFGH_SRC_PER(0)
 				| DWC_CFGH_DST_PER(1));
 	slave->sdata.cfg_lo &= ~(DWC_CFGL_HS_DST_POL
@@ -2047,7 +2047,7 @@ at32_add_device_ac97c(unsigned int id, struct ac97c_platform_data *data,
 
 	/* Check if DMA slave interface for capture should be configured. */
 	if (flags & AC97C_CAPTURE) {
-		rx_dws->dma_dev = &dw_dmac0_device.dev;
+		rx_dws->dma_dev = &at32_dmac0_device.dev;
 		rx_dws->cfg_hi = DWC_CFGH_SRC_PER(3);
 		rx_dws->cfg_lo &= ~(DWC_CFGL_HS_DST_POL | DWC_CFGL_HS_SRC_POL);
 		rx_dws->src_master = 0;
@@ -2056,7 +2056,7 @@ at32_add_device_ac97c(unsigned int id, struct ac97c_platform_data *data,
 
 	/* Check if DMA slave interface for playback should be configured. */
 	if (flags & AC97C_PLAYBACK) {
-		tx_dws->dma_dev = &dw_dmac0_device.dev;
+		tx_dws->dma_dev = &at32_dmac0_device.dev;
 		tx_dws->cfg_hi = DWC_CFGH_DST_PER(4);
 		tx_dws->cfg_lo &= ~(DWC_CFGL_HS_DST_POL | DWC_CFGL_HS_SRC_POL);
 		tx_dws->src_master = 0;
@@ -2129,7 +2129,7 @@ at32_add_device_abdac(unsigned int id, struct atmel_abdac_pdata *data)
 
 	dws = &data->dws;
 
-	dws->dma_dev = &dw_dmac0_device.dev;
+	dws->dma_dev = &at32_dmac0_device.dev;
 	dws->cfg_hi = DWC_CFGH_DST_PER(2);
 	dws->cfg_lo &= ~(DWC_CFGL_HS_DST_POL | DWC_CFGL_HS_SRC_POL);
 	dws->src_master = 0;
@@ -2219,7 +2219,7 @@ static __initdata struct clk *init_clocks[] = {
 	&smc0_mck,
 	&pdc_hclk,
 	&pdc_pclk,
-	&dw_dmac0_hclk,
+	&at32_dmac0_hclk,
 	&pico_clk,
 	&pio0_mck,
 	&pio1_mck,
-- 
1.7.10.4

