Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524Ab2FNQvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 12:51:48 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:43430 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932120Ab2FNQvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 12:51:32 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v2 03/23] ARM: LPC32xx: Remove SLC controller initialization from platform init
Date: Thu, 14 Jun 2012 18:50:53 +0200
Message-Id: <1339692673-7848-4-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1339692673-7848-1-git-send-email-stigge@antcom.de>
References: <1339692673-7848-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we now support two MTD NAND controllers (MLC and SLC) for LPC32xx via DT,
we don't initialize the SLC controller statically anymore, but do it via the
clock setup (see previous patch).

Signed-off-by: Roland Stigge <stigge@antcom.de>
Tested-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

---
 arch/arm/mach-lpc32xx/phy3250.c |    4 ----
 1 file changed, 4 deletions(-)

--- linux-2.6.orig/arch/arm/mach-lpc32xx/phy3250.c
+++ linux-2.6/arch/arm/mach-lpc32xx/phy3250.c
@@ -241,10 +241,6 @@ static void __init lpc3250_machine_init(
 {
 	u32 tmp;
 
-	/* Setup SLC NAND controller muxing */
-	__raw_writel(LPC32XX_CLKPWR_NANDCLK_SEL_SLC,
-		LPC32XX_CLKPWR_NAND_CLK_CTRL);
-
 	/* Setup LCD muxing to RGB565 */
 	tmp = __raw_readl(LPC32XX_CLKPWR_LCDCLK_CTRL) &
 		~(LPC32XX_CLKPWR_LCDCTRL_LCDTYPE_MSK |
