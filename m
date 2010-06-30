Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374Ab0F3Pz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 11:55:27 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:39544 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756403Ab0F3PzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 11:55:25 -0400
Date: Wed, 30 Jun 2010 17:55:22 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
       Ladislav Michl <ladis@linux-mips.org>, Kalle Valo <kalle.valo@iki.fi>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Paul Walmsley <paul@pwsan.com>,
       Santosh Shilimkar <santosh.shilimkar@ti.com>,
       linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH 05/33] Removing dead OMAP_IR
Message-ID: <b7209c2cb666c73a3affbb44c2637a4f2086af08.1277911346.git.siccegge@cs.fau.de>
References: <cover.1277911345.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1277911345.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OMAP_IR doesn't exist in Kconfig, therefore removing all references
for it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 arch/arm/mach-omap1/board-h2.c |   18 ------------------
 arch/arm/mach-omap2/board-h4.c |    4 ----
 2 files changed, 0 insertions(+), 22 deletions(-)

diff --git a/arch/arm/mach-omap1/board-h2.c b/arch/arm/mach-omap1/board-h2.c
index d1100e4..d7640d3 100644
--- a/arch/arm/mach-omap1/board-h2.c
+++ b/arch/arm/mach-omap1/board-h2.c
@@ -292,15 +292,6 @@ static struct platform_device h2_kp_device = {
 
 #define H2_IRDA_FIRSEL_GPIO_PIN	17
 
-#if defined(CONFIG_OMAP_IR) || defined(CONFIG_OMAP_IR_MODULE)
-static int h2_transceiver_mode(struct device *dev, int state)
-{
-	/* SIR when low, else MIR/FIR when HIGH */
-	gpio_set_value(H2_IRDA_FIRSEL_GPIO_PIN, !(state & IR_SIRMODE));
-	return 0;
-}
-#endif
-
 static struct omap_irda_config h2_irda_data = {
 	.transceiver_cap	= IR_SIRMODE | IR_MIRMODE | IR_FIRMODE,
 	.rx_channel		= OMAP_DMA_UART3_RX,
@@ -437,15 +428,6 @@ static void __init h2_init(void)
 	/* omap_cfg_reg(U19_ARMIO1); */		/* CD */
 	omap_cfg_reg(BALLOUT_V8_ARMIO3);	/* WP */
 
-	/* Irda */
-#if defined(CONFIG_OMAP_IR) || defined(CONFIG_OMAP_IR_MODULE)
-	omap_writel(omap_readl(FUNC_MUX_CTRL_A) | 7, FUNC_MUX_CTRL_A);
-	if (gpio_request(H2_IRDA_FIRSEL_GPIO_PIN, "IRDA mode") < 0)
-		BUG();
-	gpio_direction_output(H2_IRDA_FIRSEL_GPIO_PIN, 0);
-	h2_irda_data.transceiver_mode = h2_transceiver_mode;
-#endif
-
 	platform_add_devices(h2_devices, ARRAY_SIZE(h2_devices));
 	omap_board_config = h2_config;
 	omap_board_config_size = ARRAY_SIZE(h2_config);
diff --git a/arch/arm/mach-omap2/board-h4.c b/arch/arm/mach-omap2/board-h4.c
index 0665f2c..ce4292b 100644
--- a/arch/arm/mach-omap2/board-h4.c
+++ b/arch/arm/mach-omap2/board-h4.c
@@ -345,10 +345,6 @@ static void __init omap_h4_init(void)
 	 * You have to mux them off in device drivers later on
 	 * if not needed.
 	 */
-#if defined(CONFIG_OMAP_IR) || defined(CONFIG_OMAP_IR_MODULE)
-	omap_cfg_reg(K15_24XX_UART3_TX);
-	omap_cfg_reg(K14_24XX_UART3_RX);
-#endif
 
 #if defined(CONFIG_KEYBOARD_OMAP) || defined(CONFIG_KEYBOARD_OMAP_MODULE)
 	if (omap_has_menelaus()) {
-- 
1.7.0.4

