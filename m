Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab2DQRJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 13:09:25 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:35312 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752000Ab2DQRJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 13:09:23 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        thierry.reding@avionic-design.de, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
        axel.lin@gmail.com, broonie@opensource.wolfsonmicro.com,
        marek.vasut@gmail.com, devel@driverdev.osuosl.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v2 3/8] ARM: LPC32xx: clock.c update
Date: Tue, 17 Apr 2012 19:08:22 +0200
Message-Id: <1334682507-15055-4-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1334682507-15055-1-git-send-email-stigge@antcom.de>
References: <1334682507-15055-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Besides switching to the default macro CLKDEV_INIT() for clock registration,
this patch actually updates the clock registrations of pl08xdmac.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---

Applies to v3.4-rc3

--- linux-2.6.orig/arch/arm/mach-lpc32xx/clock.c
+++ linux-2.6/arch/arm/mach-lpc32xx/clock.c
@@ -1095,49 +1095,42 @@ struct clk *clk_get_parent(struct clk *c
 }
 EXPORT_SYMBOL(clk_get_parent);
 
-#define _REGISTER_CLOCK(d, n, c) \
-	{ \
-		.dev_id = (d), \
-		.con_id = (n), \
-		.clk = &(c), \
-	},
-
 static struct clk_lookup lookups[] = {
-	_REGISTER_CLOCK(NULL, "osc_32KHz", osc_32KHz)
-	_REGISTER_CLOCK(NULL, "osc_pll397", osc_pll397)
-	_REGISTER_CLOCK(NULL, "osc_main", osc_main)
-	_REGISTER_CLOCK(NULL, "sys_ck", clk_sys)
-	_REGISTER_CLOCK(NULL, "arm_pll_ck", clk_armpll)
-	_REGISTER_CLOCK(NULL, "ck_pll5", clk_usbpll)
-	_REGISTER_CLOCK(NULL, "hclk_ck", clk_hclk)
-	_REGISTER_CLOCK(NULL, "pclk_ck", clk_pclk)
-	_REGISTER_CLOCK(NULL, "timer0_ck", clk_timer0)
-	_REGISTER_CLOCK(NULL, "timer1_ck", clk_timer1)
-	_REGISTER_CLOCK(NULL, "timer2_ck", clk_timer2)
-	_REGISTER_CLOCK(NULL, "timer3_ck", clk_timer3)
-	_REGISTER_CLOCK(NULL, "vfp9_ck", clk_vfp9)
-	_REGISTER_CLOCK(NULL, "clk_dmac", clk_dma)
-	_REGISTER_CLOCK("pnx4008-watchdog", NULL, clk_wdt)
-	_REGISTER_CLOCK(NULL, "uart3_ck", clk_uart3)
-	_REGISTER_CLOCK(NULL, "uart4_ck", clk_uart4)
-	_REGISTER_CLOCK(NULL, "uart5_ck", clk_uart5)
-	_REGISTER_CLOCK(NULL, "uart6_ck", clk_uart6)
-	_REGISTER_CLOCK("pnx-i2c.0", NULL, clk_i2c0)
-	_REGISTER_CLOCK("pnx-i2c.1", NULL, clk_i2c1)
-	_REGISTER_CLOCK("pnx-i2c.2", NULL, clk_i2c2)
-	_REGISTER_CLOCK("dev:ssp0", NULL, clk_ssp0)
-	_REGISTER_CLOCK("dev:ssp1", NULL, clk_ssp1)
-	_REGISTER_CLOCK("lpc32xx_keys.0", NULL, clk_kscan)
-	_REGISTER_CLOCK("lpc32xx-nand.0", "nand_ck", clk_nand)
-	_REGISTER_CLOCK("lpc32xx-adc", NULL, clk_adc)
-	_REGISTER_CLOCK(NULL, "i2s0_ck", clk_i2s0)
-	_REGISTER_CLOCK(NULL, "i2s1_ck", clk_i2s1)
-	_REGISTER_CLOCK("ts-lpc32xx", NULL, clk_tsc)
-	_REGISTER_CLOCK("dev:mmc0", NULL, clk_mmc)
-	_REGISTER_CLOCK("lpc-eth.0", NULL, clk_net)
-	_REGISTER_CLOCK("dev:clcd", NULL, clk_lcd)
-	_REGISTER_CLOCK("lpc32xx_udc", "ck_usbd", clk_usbd)
-	_REGISTER_CLOCK("lpc32xx_rtc", NULL, clk_rtc)
+	CLKDEV_INIT(NULL, "osc_32KHz", &osc_32KHz),
+	CLKDEV_INIT(NULL, "osc_pll397", &osc_pll397),
+	CLKDEV_INIT(NULL, "osc_main", &osc_main),
+	CLKDEV_INIT(NULL, "sys_ck", &clk_sys),
+	CLKDEV_INIT(NULL, "arm_pll_ck", &clk_armpll),
+	CLKDEV_INIT(NULL, "ck_pll5", &clk_usbpll),
+	CLKDEV_INIT(NULL, "hclk_ck", &clk_hclk),
+	CLKDEV_INIT(NULL, "pclk_ck", &clk_pclk),
+	CLKDEV_INIT(NULL, "timer0_ck", &clk_timer0),
+	CLKDEV_INIT(NULL, "timer1_ck", &clk_timer1),
+	CLKDEV_INIT(NULL, "timer2_ck", &clk_timer2),
+	CLKDEV_INIT(NULL, "timer3_ck", &clk_timer3),
+	CLKDEV_INIT(NULL, "vfp9_ck", &clk_vfp9),
+	CLKDEV_INIT("pl08xdmac", NULL, &clk_dma),
+	CLKDEV_INIT("pnx4008-watchdog", NULL, &clk_wdt),
+	CLKDEV_INIT(NULL, "uart3_ck", &clk_uart3),
+	CLKDEV_INIT(NULL, "uart4_ck", &clk_uart4),
+	CLKDEV_INIT(NULL, "uart5_ck", &clk_uart5),
+	CLKDEV_INIT(NULL, "uart6_ck", &clk_uart6),
+	CLKDEV_INIT("pnx-i2c.0", NULL, &clk_i2c0),
+	CLKDEV_INIT("pnx-i2c.1", NULL, &clk_i2c1),
+	CLKDEV_INIT("pnx-i2c.2", NULL, &clk_i2c2),
+	CLKDEV_INIT("dev:ssp0", NULL, &clk_ssp0),
+	CLKDEV_INIT("dev:ssp1", NULL, &clk_ssp1),
+	CLKDEV_INIT("lpc32xx_keys.0", NULL, &clk_kscan),
+	CLKDEV_INIT("lpc32xx-nand.0", "nand_ck", &clk_nand),
+	CLKDEV_INIT("lpc32xx-adc", NULL, &clk_adc),
+	CLKDEV_INIT(NULL, "i2s0_ck", &clk_i2s0),
+	CLKDEV_INIT(NULL, "i2s1_ck", &clk_i2s1),
+	CLKDEV_INIT("ts-lpc32xx", NULL, &clk_tsc),
+	CLKDEV_INIT("dev:mmc0", NULL, &clk_mmc),
+	CLKDEV_INIT("lpc-eth.0", NULL, &clk_net),
+	CLKDEV_INIT("dev:clcd", NULL, &clk_lcd),
+	CLKDEV_INIT("lpc32xx_udc", "ck_usbd", &clk_usbd),
+	CLKDEV_INIT("lpc32xx_rtc", NULL, &clk_rtc),
 };
 
 static int __init clk_init(void)

