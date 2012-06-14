Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417Ab2FNQwG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 12:52:06 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:57645 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932385Ab2FNQwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 12:52:03 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v2 20/23] ARM: LPC32xx: Cleanup board init, remove duplicate clock init
Date: Thu, 14 Jun 2012 18:51:10 +0200
Message-Id: <1339692673-7848-21-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1339692673-7848-1-git-send-email-stigge@antcom.de>
References: <1339692673-7848-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

Remove SSP0, CLCD and DMA clocks that are already migrated to
the clock framework.

Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Signed-off-by: Roland Stigge <stigge@antcom.de>
---
 arch/arm/mach-lpc32xx/phy3250.c |   17 -----------------
 1 file changed, 17 deletions(-)

--- linux-2.6.orig/arch/arm/mach-lpc32xx/phy3250.c
+++ linux-2.6/arch/arm/mach-lpc32xx/phy3250.c
@@ -272,28 +272,11 @@ static void __init lpc3250_machine_init(
 
 	lpc32xx_serial_init();
 
-	/*
-	 * AMBA peripheral clocks need to be enabled prior to AMBA device
-	 * detection or a data fault will occur, so enable the clocks
-	 * here.
-	 */
 	tmp = __raw_readl(LPC32XX_CLKPWR_MS_CTRL);
 	tmp |= LPC32XX_CLKPWR_MSCARD_SDCARD_EN |
 		LPC32XX_CLKPWR_MSCARD_MSDIO_PU_EN;
 	__raw_writel(tmp, LPC32XX_CLKPWR_MS_CTRL);
 
-	tmp = __raw_readl(LPC32XX_CLKPWR_LCDCLK_CTRL);
-	__raw_writel((tmp | LPC32XX_CLKPWR_LCDCTRL_CLK_EN),
-		LPC32XX_CLKPWR_LCDCLK_CTRL);
-
-	tmp = __raw_readl(LPC32XX_CLKPWR_SSP_CLK_CTRL);
-	__raw_writel((tmp | LPC32XX_CLKPWR_SSPCTRL_SSPCLK0_EN),
-		LPC32XX_CLKPWR_SSP_CLK_CTRL);
-
-	tmp = __raw_readl(LPC32XX_CLKPWR_DMA_CLK_CTRL);
-	__raw_writel((tmp | LPC32XX_CLKPWR_DMACLKCTRL_CLK_EN),
-		     LPC32XX_CLKPWR_DMA_CLK_CTRL);
-
 	/* Test clock needed for UDA1380 initial init */
 	__raw_writel(LPC32XX_CLKPWR_TESTCLK2_SEL_MOSC |
 		LPC32XX_CLKPWR_TESTCLK_TESTCLK2_EN,
