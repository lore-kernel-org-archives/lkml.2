Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442Ab2FNQwc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 12:52:32 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:55587 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932403Ab2FNQwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 12:52:05 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v2 21/23] ARM: LPC32xx: Move uart6 irda disable to serial.c
Date: Thu, 14 Jun 2012 18:51:11 +0200
Message-Id: <1339692673-7848-22-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1339692673-7848-1-git-send-email-stigge@antcom.de>
References: <1339692673-7848-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

Move the irda configuration to serial.c where other special cases are
handled

Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Signed-off-by: Roland Stigge <stigge@antcom.de>
---
 arch/arm/mach-lpc32xx/phy3250.c |    5 -----
 arch/arm/mach-lpc32xx/serial.c  |    5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

--- linux-2.6.orig/arch/arm/mach-lpc32xx/phy3250.c
+++ linux-2.6/arch/arm/mach-lpc32xx/phy3250.c
@@ -260,11 +260,6 @@ static void __init lpc3250_machine_init(
 		LPC32XX_CLKPWR_I2CCLK_I2C2HI_DRIVE;
 	__raw_writel(tmp, LPC32XX_CLKPWR_I2C_CLK_CTRL);
 
-	/* Disable IrDA pulsing support on UART6 */
-	tmp = __raw_readl(LPC32XX_UARTCTL_CTRL);
-	tmp |= LPC32XX_UART_UART6_IRDAMOD_BYPASS;
-	__raw_writel(tmp, LPC32XX_UARTCTL_CTRL);
-
 	/* Enable DMA for I2S1 channel */
 	tmp = __raw_readl(LPC32XX_CLKPWR_I2S_CLK_CTRL);
 	tmp = LPC32XX_CLKPWR_I2SCTRL_I2S1_USE_DMA;
--- linux-2.6.orig/arch/arm/mach-lpc32xx/serial.c
+++ linux-2.6/arch/arm/mach-lpc32xx/serial.c
@@ -118,6 +118,11 @@ void __init lpc32xx_serial_init(void)
 		__raw_writel(0, LPC32XX_UART_IIR_FCR(puart));
 	}
 
+	/* Disable IrDA pulsing support on UART6 */
+	tmp = __raw_readl(LPC32XX_UARTCTL_CTRL);
+	tmp |= LPC32XX_UART_UART6_IRDAMOD_BYPASS;
+	__raw_writel(tmp, LPC32XX_UARTCTL_CTRL);
+
 	/* Disable UART5->USB transparent mode or USB won't work */
 	tmp = __raw_readl(LPC32XX_UARTCTL_CTRL);
 	tmp &= ~LPC32XX_UART_U5_ROUTE_TO_USB;
