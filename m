Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab2DUJiD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 05:38:03 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:47735 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751768Ab2DUJfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 05:35:20 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, thierry.reding@avionic-design.de, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
        axel.lin@gmail.com, broonie@opensource.wolfsonmicro.com,
        marek.vasut@gmail.com, devel@driverdev.osuosl.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v5 4/10] ARM: LPC32xx: clock.c registration adjustment
Date: Sat, 21 Apr 2012 11:34:22 +0200
Message-Id: <1335000868-21974-5-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1335000868-21974-1-git-send-email-stigge@antcom.de>
References: <1335000868-21974-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adjusts the clocks of the LPC32xx SoC to be picked up correctly by
the respective drivers.

* AMBA dmaengine
* watchdog
* I2C
* TSC
* MMC
* Ethernet
* ADC
* USB Device

(All except the pl08xdmac AMBA dmaengine via DT generated device name)

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
 arch/arm/mach-lpc32xx/clock.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- linux-2.6.orig/arch/arm/mach-lpc32xx/clock.c
+++ linux-2.6/arch/arm/mach-lpc32xx/clock.c
@@ -1109,27 +1109,27 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_INIT(NULL, "timer2_ck", &clk_timer2),
 	CLKDEV_INIT(NULL, "timer3_ck", &clk_timer3),
 	CLKDEV_INIT(NULL, "vfp9_ck", &clk_vfp9),
-	CLKDEV_INIT(NULL, "clk_dmac", &clk_dma),
-	CLKDEV_INIT("pnx4008-watchdog", NULL, &clk_wdt),
+	CLKDEV_INIT("pl08xdmac", NULL, &clk_dma),
+	CLKDEV_INIT("4003c000.watchdog", NULL, &clk_wdt),
 	CLKDEV_INIT(NULL, "uart3_ck", &clk_uart3),
 	CLKDEV_INIT(NULL, "uart4_ck", &clk_uart4),
 	CLKDEV_INIT(NULL, "uart5_ck", &clk_uart5),
 	CLKDEV_INIT(NULL, "uart6_ck", &clk_uart6),
-	CLKDEV_INIT("pnx-i2c.0", NULL, &clk_i2c0),
-	CLKDEV_INIT("pnx-i2c.1", NULL, &clk_i2c1),
-	CLKDEV_INIT("pnx-i2c.2", NULL, &clk_i2c2),
+	CLKDEV_INIT("400a0000.i2c", NULL, &clk_i2c0),
+	CLKDEV_INIT("400a8000.i2c", NULL, &clk_i2c1),
+	CLKDEV_INIT("31020300.i2c", NULL, &clk_i2c2),
 	CLKDEV_INIT("dev:ssp0", NULL, &clk_ssp0),
 	CLKDEV_INIT("dev:ssp1", NULL, &clk_ssp1),
 	CLKDEV_INIT("lpc32xx_keys.0", NULL, &clk_kscan),
 	CLKDEV_INIT("lpc32xx-nand.0", "nand_ck", &clk_nand),
-	CLKDEV_INIT("lpc32xx-adc", NULL, &clk_adc),
+	CLKDEV_INIT("40048000.adc", NULL, &clk_adc),
 	CLKDEV_INIT(NULL, "i2s0_ck", &clk_i2s0),
 	CLKDEV_INIT(NULL, "i2s1_ck", &clk_i2s1),
-	CLKDEV_INIT("ts-lpc32xx", NULL, &clk_tsc),
-	CLKDEV_INIT("dev:mmc0", NULL, &clk_mmc),
-	CLKDEV_INIT("lpc-eth.0", NULL, &clk_net),
+	CLKDEV_INIT("40048000.tsc", NULL, &clk_tsc),
+	CLKDEV_INIT("20098000.sd", NULL, &clk_mmc),
+	CLKDEV_INIT("31060000.ethernet", NULL, &clk_net),
 	CLKDEV_INIT("dev:clcd", NULL, &clk_lcd),
-	CLKDEV_INIT("lpc32xx_udc", "ck_usbd", &clk_usbd),
+	CLKDEV_INIT("31020000.usbd", "ck_usbd", &clk_usbd),
 	CLKDEV_INIT("lpc32xx_rtc", NULL, &clk_rtc),
 };
 
