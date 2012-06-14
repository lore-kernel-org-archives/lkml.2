Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260Ab2FNQvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 12:51:46 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:43446 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932132Ab2FNQvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 12:51:33 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v2 02/23] ARM: LPC32xx: Clock initialization for NAND controllers
Date: Thu, 14 Jun 2012 18:50:52 +0200
Message-Id: <1339692673-7848-3-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1339692673-7848-1-git-send-email-stigge@antcom.de>
References: <1339692673-7848-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds clock initialization for the MLC NAND controller of the LPC32xx
SoC and adjusts it for the SLC controller.

Signed-off-by: Roland Stigge <stigge@antcom.de>
---

 arch/arm/mach-lpc32xx/clock.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- linux-2.6.orig/arch/arm/mach-lpc32xx/clock.c
+++ linux-2.6/arch/arm/mach-lpc32xx/clock.c
@@ -691,10 +691,21 @@ static struct clk clk_nand = {
 	.parent		= &clk_hclk,
 	.enable		= local_onoff_enable,
 	.enable_reg	= LPC32XX_CLKPWR_NAND_CLK_CTRL,
-	.enable_mask	= LPC32XX_CLKPWR_NANDCLK_SLCCLK_EN,
+	.enable_mask	= LPC32XX_CLKPWR_NANDCLK_SLCCLK_EN |
+			  LPC32XX_CLKPWR_NANDCLK_SEL_SLC,
 	.get_rate	= local_return_parent_rate,
 };
 
+static struct clk clk_nand_mlc = {
+	.parent         = &clk_hclk,
+	.enable         = local_onoff_enable,
+	.enable_reg     = LPC32XX_CLKPWR_NAND_CLK_CTRL,
+	.enable_mask    = LPC32XX_CLKPWR_NANDCLK_MLCCLK_EN |
+			  LPC32XX_CLKPWR_NANDCLK_DMA_INT |
+			  LPC32XX_CLKPWR_NANDCLK_INTSEL_MLC,
+	.get_rate       = local_return_parent_rate,
+};
+
 static struct clk clk_i2s0 = {
 	.parent		= &clk_hclk,
 	.enable		= local_onoff_enable,
@@ -1121,7 +1132,8 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_INIT("dev:ssp0", NULL, &clk_ssp0),
 	CLKDEV_INIT("dev:ssp1", NULL, &clk_ssp1),
 	CLKDEV_INIT("lpc32xx_keys.0", NULL, &clk_kscan),
-	CLKDEV_INIT("lpc32xx-nand.0", "nand_ck", &clk_nand),
+	CLKDEV_INIT("20020000.flash", NULL, &clk_nand),
+	CLKDEV_INIT("200a8000.flash", NULL, &clk_nand_mlc),
 	CLKDEV_INIT("40048000.adc", NULL, &clk_adc),
 	CLKDEV_INIT(NULL, "i2s0_ck", &clk_i2s0),
 	CLKDEV_INIT(NULL, "i2s1_ck", &clk_i2s1),
