Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165Ab2JGOCS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 10:02:18 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:39322 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab2JGOCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 10:02:10 -0400
MIME-Version: 1.0
Date: Sun, 7 Oct 2012 22:02:09 +0800
Message-ID: <CAPgLHd8Brw7dEffrj+xAM60ssgi3pJyMTGX+icPR7ZrZKz-vOQ@mail.gmail.com>
Subject: [PATCH] clk: fix return value check in sirfsoc_of_clk_init()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: mturquette@ti.com
Cc: yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function clk_register() returns ERR_PTR()
and never returns NULL. The NULL test in the return value check
should be replaced with IS_ERR().

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/clk/clk-prima2.c | 84 ++++++++++++++++++++++++------------------------
 1 file changed, 42 insertions(+), 42 deletions(-)

diff --git a/drivers/clk/clk-prima2.c b/drivers/clk/clk-prima2.c
index 517874f..a203ecc 100644
--- a/drivers/clk/clk-prima2.c
+++ b/drivers/clk/clk-prima2.c
@@ -1054,118 +1054,118 @@ void __init sirfsoc_of_clk_init(void)
 	/* These are always available (RTC and 26MHz OSC)*/
 	clk = clk_register_fixed_rate(NULL, "rtc", NULL,
 		CLK_IS_ROOT, 32768);
-	BUG_ON(!clk);
+	BUG_ON(IS_ERR(clk));
 	clk = clk_register_fixed_rate(NULL, "osc", NULL,
 		CLK_IS_ROOT, 26000000);
-	BUG_ON(!clk);
+	BUG_ON(IS_ERR(clk));
 
 	clk = clk_register(NULL, &clk_pll1.hw);
-	BUG_ON(!clk);
+	BUG_ON(IS_ERR(clk));
 	clk = clk_register(NULL, &clk_pll2.hw);
-	BUG_ON(!clk);
+	BUG_ON(IS_ERR(clk));
 	clk = clk_register(NULL, &clk_pll3.hw);
-	BUG_ON(!clk);
+	BUG_ON(IS_ERR(clk));
 	clk = clk_register(NULL, &clk_mem.hw);
-	BUG_ON(!clk);
+	BUG_ON(IS_ERR(clk));
 	clk = clk_register(NULL, &clk_sys.hw);
-	BUG_ON(!clk);
+	BUG_ON(IS_ERR(clk));
 	clk = clk_register(NULL, &clk_security.hw);
-	BUG_ON(!clk);
+	BUG_ON(IS_ERR(clk));
 	clk_register_clkdev(clk, NULL, "b8030000.security");
 	clk = clk_register(NULL, &clk_dsp.hw);
-	BUG_ON(!clk);
+	BUG_ON(IS_ERR(clk));
 	clk = clk_register(NULL, &clk_gps.hw);
-	BUG_ON(!clk);
+	BUG_ON(IS_ERR(clk));
 	clk_register_clkdev(clk, NULL, "a8010000.gps");
 	clk = clk_register(NULL, &clk_mf.hw);
-	BUG_ON(!clk);
+	BUG_ON(IS_ERR(clk));
 	clk = clk_register(NULL, &clk_io.hw);
-	BUG_ON(!clk);
+	BUG_ON(IS_ERR(clk));
 	clk_register_clkdev(clk, NULL, "io");
 	clk = clk_register(NULL, &clk_cpu.hw);
-	BUG_ON(!clk);
+	BUG_ON(IS_ERR(clk));
 	clk_register_clkdev(clk, NULL, "cpu");
 	clk = clk_register(NULL, &clk_uart0.hw);
-	BUG_ON(!clk);
+	BUG_ON(IS_ERR(clk));
 	clk_register_clkdev(clk, NULL, "b0050000.uart");
 	clk = clk_register(NULL, &clk_uart1.hw);
-	BUG_ON(!clk);
+	BUG_ON(IS_ERR(clk));
 	clk_register_clkdev(clk, NULL, "b0060000.uart");
 	clk = clk_register(NULL, &clk_uart2.hw);
-	BUG_ON(!clk);
+	BUG_ON(IS_ERR(clk));
 	clk_register_clkdev(clk, NULL, "b0070000.uart");
 	clk = clk_register(NULL, &clk_tsc.hw);
-	BUG_ON(!clk);
+	BUG_ON(IS_ERR(clk));
 	clk_register_clkdev(clk, NULL, "b0110000.tsc");
 	clk = clk_register(NULL, &clk_i2c0.hw);
-	BUG_ON(!clk);
+	BUG_ON(IS_ERR(clk));
 	clk_register_clkdev(clk, NULL, "b00e0000.i2c");
 	clk = clk_register(NULL, &clk_i2c1.hw);
-	BUG_ON(!clk);
+	BUG_ON(IS_ERR(clk));
 	clk_register_clkdev(clk, NULL, "b00f0000.i2c");
 	clk = clk_register(NULL, &clk_spi0.hw);
-	BUG_ON(!clk);
+	BUG_ON(IS_ERR(clk));
 	clk_register_clkdev(clk, NULL, "b00d0000.spi");
 	clk = clk_register(NULL, &clk_spi1.hw);
-	BUG_ON(!clk);
+	BUG_ON(IS_ERR(clk));
 	clk_register_clkdev(clk, NULL, "b0170000.spi");
 	clk = clk_register(NULL, &clk_pwmc.hw);
-	BUG_ON(!clk);
+	BUG_ON(IS_ERR(clk));
 	clk_register_clkdev(clk, NULL, "b0130000.pwm");
 	clk = clk_register(NULL, &clk_efuse.hw);
-	BUG_ON(!clk);
+	BUG_ON(IS_ERR(clk));
 	clk_register_clkdev(clk, NULL, "b0140000.efusesys");
 	clk = clk_register(NULL, &clk_pulse.hw);
-	BUG_ON(!clk);
+	BUG_ON(IS_ERR(clk));
 	clk_register_clkdev(clk, NULL, "b0150000.pulsec");
 	clk = clk_register(NULL, &clk_dmac0.hw);
-	BUG_ON(!clk);
+	BUG_ON(IS_ERR(clk));
 	clk_register_clkdev(clk, NULL, "b00b0000.dma-controller");
 	clk = clk_register(NULL, &clk_dmac1.hw);
-	BUG_ON(!clk);
+	BUG_ON(IS_ERR(clk));
 	clk_register_clkdev(clk, NULL, "b0160000.dma-controller");
 	clk = clk_register(NULL, &clk_nand.hw);
-	BUG_ON(!clk);
+	BUG_ON(IS_ERR(clk));
 	clk_register_clkdev(clk, NULL, "b0030000.nand");
 	clk = clk_register(NULL, &clk_audio.hw);
-	BUG_ON(!clk);
+	BUG_ON(IS_ERR(clk));
 	clk_register_clkdev(clk, NULL, "b0040000.audio");
 	clk = clk_register(NULL, &clk_usp0.hw);
-	BUG_ON(!clk);
+	BUG_ON(IS_ERR(clk));
 	clk_register_clkdev(clk, NULL, "b0080000.usp");
 	clk = clk_register(NULL, &clk_usp1.hw);
-	BUG_ON(!clk);
+	BUG_ON(IS_ERR(clk));
 	clk_register_clkdev(clk, NULL, "b0090000.usp");
 	clk = clk_register(NULL, &clk_usp2.hw);
-	BUG_ON(!clk);
+	BUG_ON(IS_ERR(clk));
 	clk_register_clkdev(clk, NULL, "b00a0000.usp");
 	clk = clk_register(NULL, &clk_vip.hw);
-	BUG_ON(!clk);
+	BUG_ON(IS_ERR(clk));
 	clk_register_clkdev(clk, NULL, "b00c0000.vip");
 	clk = clk_register(NULL, &clk_gfx.hw);
-	BUG_ON(!clk);
+	BUG_ON(IS_ERR(clk));
 	clk_register_clkdev(clk, NULL, "98000000.graphics");
 	clk = clk_register(NULL, &clk_mm.hw);
-	BUG_ON(!clk);
+	BUG_ON(IS_ERR(clk));
 	clk_register_clkdev(clk, NULL, "a0000000.multimedia");
 	clk = clk_register(NULL, &clk_lcd.hw);
-	BUG_ON(!clk);
+	BUG_ON(IS_ERR(clk));
 	clk_register_clkdev(clk, NULL, "90010000.display");
 	clk = clk_register(NULL, &clk_vpp.hw);
-	BUG_ON(!clk);
+	BUG_ON(IS_ERR(clk));
 	clk_register_clkdev(clk, NULL, "90020000.vpp");
 	clk = clk_register(NULL, &clk_mmc01.hw);
-	BUG_ON(!clk);
+	BUG_ON(IS_ERR(clk));
 	clk = clk_register(NULL, &clk_mmc23.hw);
-	BUG_ON(!clk);
+	BUG_ON(IS_ERR(clk));
 	clk = clk_register(NULL, &clk_mmc45.hw);
-	BUG_ON(!clk);
+	BUG_ON(IS_ERR(clk));
 	clk = clk_register(NULL, &usb_pll_clk_hw);
-	BUG_ON(!clk);
+	BUG_ON(IS_ERR(clk));
 	clk = clk_register(NULL, &clk_usb0.hw);
-	BUG_ON(!clk);
+	BUG_ON(IS_ERR(clk));
 	clk_register_clkdev(clk, NULL, "b00e0000.usb");
 	clk = clk_register(NULL, &clk_usb1.hw);
-	BUG_ON(!clk);
+	BUG_ON(IS_ERR(clk));
 	clk_register_clkdev(clk, NULL, "b00f0000.usb");
 }

