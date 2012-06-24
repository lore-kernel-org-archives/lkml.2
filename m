Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab2FXNrp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 09:47:45 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:34465 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755763Ab2FXNrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 09:47:42 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        rinivas.bakki@nxp.com, aletes.xgr@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 1/7] ARM: LPC32xx: Init MMC via clock
Date: Sun, 24 Jun 2012 15:47:11 +0200
Message-Id: <1340545637-5449-2-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1340545637-5449-1-git-send-email-stigge@antcom.de>
References: <1340545637-5449-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves MMC/SD controller initialization from the board specific file
phy3250.c to clock.c.

Signed-off-by: Roland Stigge <stigge@antcom.de>
Acked-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

---
 arch/arm/mach-lpc32xx/clock.c   |    6 ++++--
 arch/arm/mach-lpc32xx/phy3250.c |    5 -----
 2 files changed, 4 insertions(+), 7 deletions(-)

--- linux-2.6.orig/arch/arm/mach-lpc32xx/clock.c
+++ linux-2.6/arch/arm/mach-lpc32xx/clock.c
@@ -812,11 +812,13 @@ static int mmc_onoff_enable(struct clk *
 	u32 tmp;
 
 	tmp = __raw_readl(LPC32XX_CLKPWR_MS_CTRL) &
-		~LPC32XX_CLKPWR_MSCARD_SDCARD_EN;
+		~(LPC32XX_CLKPWR_MSCARD_SDCARD_EN |
+		  LPC32XX_CLKPWR_MSCARD_MSDIO_PU_EN);
 
 	/* If rate is 0, disable clock */
 	if (enable != 0)
-		tmp |= LPC32XX_CLKPWR_MSCARD_SDCARD_EN;
+		tmp |= LPC32XX_CLKPWR_MSCARD_SDCARD_EN |
+			LPC32XX_CLKPWR_MSCARD_MSDIO_PU_EN;
 
 	__raw_writel(tmp, LPC32XX_CLKPWR_MS_CTRL);
 
--- linux-2.6.orig/arch/arm/mach-lpc32xx/phy3250.c
+++ linux-2.6/arch/arm/mach-lpc32xx/phy3250.c
@@ -262,11 +262,6 @@ static void __init lpc3250_machine_init(
 
 	lpc32xx_serial_init();
 
-	tmp = __raw_readl(LPC32XX_CLKPWR_MS_CTRL);
-	tmp |= LPC32XX_CLKPWR_MSCARD_SDCARD_EN |
-		LPC32XX_CLKPWR_MSCARD_MSDIO_PU_EN;
-	__raw_writel(tmp, LPC32XX_CLKPWR_MS_CTRL);
-
 	/* Test clock needed for UDA1380 initial init */
 	__raw_writel(LPC32XX_CLKPWR_TESTCLK2_SEL_MOSC |
 		LPC32XX_CLKPWR_TESTCLK_TESTCLK2_EN,
