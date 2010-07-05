Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab0GEIPJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 04:15:09 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:49156 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945Ab0GEIPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 04:15:06 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/Mok+AungxL8b1soPi63nT
Date: Mon, 5 Jul 2010 11:14:55 +0300
From: Tony Lindgren <tony@atomide.com>
To: Christoph Egger <siccegge@cs.fau.de>
Cc: Russell King <linux@arm.linux.org.uk>,
       Ladislav Michl <ladis@linux-mips.org>, Kalle Valo <kalle.valo@iki.fi>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Paul Walmsley <paul@pwsan.com>,
       Santosh Shilimkar <santosh.shilimkar@ti.com>,
       linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org, vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 05/33] Removing dead OMAP_IR
Message-ID: <20100705081453.GD15951@atomide.com>
References: <cover.1277911345.git.siccegge@cs.fau.de>
 <b7209c2cb666c73a3affbb44c2637a4f2086af08.1277911346.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
In-Reply-To: <b7209c2cb666c73a3affbb44c2637a4f2086af08.1277911346.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* Christoph Egger <siccegge@cs.fau.de> [100630 18:49]:
> OMAP_IR doesn't exist in Kconfig, therefore removing all references
> for it from the source code.

Thanks I've updated this for the new mux code for board-h4.c and applied it.
Updated patch below.

Regards,

Tony

--6TrnltStXW4iwmi0
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline; filename="irda.patch"

>From e2bed14099b0d15514d3e542742fa9310d9bf52c Mon Sep 17 00:00:00 2001
From: Christoph Egger <siccegge@cs.fau.de>
Date: Wed, 30 Jun 2010 15:55:22 +0000
Subject: [PATCH] Removing dead OMAP_IR

OMAP_IR doesn't exist in Kconfig, therefore removing all references
for it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
[tony@atomide.com: updated for new mux code]
Signed-off-by: Tony Lindgren <tony@atomide.com>

diff --git a/arch/arm/mach-omap1/board-h2.c b/arch/arm/mach-omap1/board-h2.c
index ee46974..2efa427 100644
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
@@ -450,15 +441,6 @@ static void __init h2_init(void)
 	omap_cfg_reg(E19_1610_KBR4);
 	omap_cfg_reg(N19_1610_KBR5);
 
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
index 2d9ff0f..9044dcf 100644
--- a/arch/arm/mach-omap2/board-h4.c
+++ b/arch/arm/mach-omap2/board-h4.c
@@ -356,10 +356,6 @@ static void __init omap_h4_init(void)
 	 * You have to mux them off in device drivers later on
 	 * if not needed.
 	 */
-#if defined(CONFIG_OMAP_IR) || defined(CONFIG_OMAP_IR_MODULE)
-	omap_mux_init_signal("uart3_tx_irtx.uart3_tx_irtx", 0);
-	omap_mux_init_signal("uart3_rx_irrx.uart3_rx_irrx", 0);
-#endif
 
 #if defined(CONFIG_KEYBOARD_OMAP) || defined(CONFIG_KEYBOARD_OMAP_MODULE)
 	omap_mux_init_gpio(88, OMAP_PULL_ENA | OMAP_PULL_UP);

--6TrnltStXW4iwmi0--
