Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448Ab2FNQwp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 12:52:45 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:31010 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932398Ab2FNQwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 12:52:05 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v2 23/23] ARM: LPC32xx: Remove duplicate usb host clock init
Date: Thu, 14 Jun 2012 18:51:13 +0200
Message-Id: <1339692673-7848-24-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1339692673-7848-1-git-send-email-stigge@antcom.de>
References: <1339692673-7848-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

Remove usb host clock init from phy3250.c. Fix clock.c usb host and also
enable the usb i2c clock as well.

Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Signed-off-by: Roland Stigge <stigge@antcom.de>
---
 arch/arm/mach-lpc32xx/clock.c   |    3 ++-
 arch/arm/mach-lpc32xx/phy3250.c |    6 ------
 2 files changed, 2 insertions(+), 7 deletions(-)

--- linux-2.6.orig/arch/arm/mach-lpc32xx/clock.c
+++ linux-2.6/arch/arm/mach-lpc32xx/clock.c
@@ -743,7 +743,8 @@ static struct clk clk_usbd = {
 	.parent		= &clk_usbpll,
 	.enable		= local_onoff_enable,
 	.enable_reg	= LPC32XX_CLKPWR_USB_CTRL,
-	.enable_mask	= LPC32XX_CLKPWR_USBCTRL_HCLK_EN,
+	.enable_mask	= LPC32XX_CLKPWR_USBCTRL_HCLK_EN |
+			  LPC32XX_CLKPWR_USBCTRL_USBI2C_EN,
 	.get_rate	= local_return_parent_rate,
 };
 
--- linux-2.6.orig/arch/arm/mach-lpc32xx/phy3250.c
+++ linux-2.6/arch/arm/mach-lpc32xx/phy3250.c
@@ -248,12 +248,6 @@ static void __init lpc3250_machine_init(
 	tmp |= LPC32XX_CLKPWR_LCDCTRL_LCDTYPE_TFT16;
 	__raw_writel(tmp, LPC32XX_CLKPWR_LCDCLK_CTRL);
 
-	/* Set up USB power */
-	tmp = __raw_readl(LPC32XX_CLKPWR_USB_CTRL);
-	tmp |= LPC32XX_CLKPWR_USBCTRL_HCLK_EN |
-		LPC32XX_CLKPWR_USBCTRL_USBI2C_EN;
-	__raw_writel(tmp, LPC32XX_CLKPWR_USB_CTRL);
-
 	/* Set up I2C pull levels */
 	tmp = __raw_readl(LPC32XX_CLKPWR_I2C_CLK_CTRL);
 	tmp |= LPC32XX_CLKPWR_I2CCLK_USBI2CHI_DRIVE |
