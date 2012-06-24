Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab2FXNs7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 09:48:59 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:57014 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756051Ab2FXNrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 09:47:45 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        rinivas.bakki@nxp.com, aletes.xgr@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 7/7] ARM: LPC32xx: Remove USB and I2C init from phy3250.c
Date: Sun, 24 Jun 2012 15:47:17 +0200
Message-Id: <1340545637-5449-8-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1340545637-5449-1-git-send-email-stigge@antcom.de>
References: <1340545637-5449-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

USB and I2C initialization can be removed safely from the board specific
phy3250.c, now that initialization moved to the generalized clock.c.

Signed-off-by: Roland Stigge <stigge@antcom.de>
Tested-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

---
 arch/arm/mach-lpc32xx/phy3250.c |   12 ------------
 1 file changed, 12 deletions(-)

--- linux-2.6.orig/arch/arm/mach-lpc32xx/phy3250.c
+++ linux-2.6/arch/arm/mach-lpc32xx/phy3250.c
@@ -248,18 +248,6 @@ static void __init lpc3250_machine_init(
 	tmp |= LPC32XX_CLKPWR_LCDCTRL_LCDTYPE_TFT16;
 	__raw_writel(tmp, LPC32XX_CLKPWR_LCDCLK_CTRL);
 
-	/* Set up USB power */
-	tmp = __raw_readl(LPC32XX_CLKPWR_USB_CTRL);
-	tmp |= LPC32XX_CLKPWR_USBCTRL_HCLK_EN |
-		LPC32XX_CLKPWR_USBCTRL_USBI2C_EN;
-	__raw_writel(tmp, LPC32XX_CLKPWR_USB_CTRL);
-
-	/* Set up I2C pull levels */
-	tmp = __raw_readl(LPC32XX_CLKPWR_I2C_CLK_CTRL);
-	tmp |= LPC32XX_CLKPWR_I2CCLK_USBI2CHI_DRIVE |
-		LPC32XX_CLKPWR_I2CCLK_I2C2HI_DRIVE;
-	__raw_writel(tmp, LPC32XX_CLKPWR_I2C_CLK_CTRL);
-
 	lpc32xx_serial_init();
 
 	/* Test clock needed for UDA1380 initial init */
