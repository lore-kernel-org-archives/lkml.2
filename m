Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab2FXNro (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 09:47:44 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:36514 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755597Ab2FXNrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 09:47:42 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        rinivas.bakki@nxp.com, aletes.xgr@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 2/7] ARM: LPC32xx: Add further bits to MMC init
Date: Sun, 24 Jun 2012 15:47:12 +0200
Message-Id: <1340545637-5449-3-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1340545637-5449-1-git-send-email-stigge@antcom.de>
References: <1340545637-5449-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes sure certain MMC bits are cleared as they should for
initialization.

Signed-off-by: Roland Stigge <stigge@antcom.de>
Acked-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

---
 arch/arm/mach-lpc32xx/clock.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- linux-2.6.orig/arch/arm/mach-lpc32xx/clock.c
+++ linux-2.6/arch/arm/mach-lpc32xx/clock.c
@@ -813,7 +813,11 @@ static int mmc_onoff_enable(struct clk *
 
 	tmp = __raw_readl(LPC32XX_CLKPWR_MS_CTRL) &
 		~(LPC32XX_CLKPWR_MSCARD_SDCARD_EN |
-		  LPC32XX_CLKPWR_MSCARD_MSDIO_PU_EN);
+		  LPC32XX_CLKPWR_MSCARD_MSDIO_PU_EN |
+		  LPC32XX_CLKPWR_MSCARD_MSDIO_PIN_DIS |
+		  LPC32XX_CLKPWR_MSCARD_MSDIO0_DIS |
+		  LPC32XX_CLKPWR_MSCARD_MSDIO1_DIS |
+		  LPC32XX_CLKPWR_MSCARD_MSDIO23_DIS);
 
 	/* If rate is 0, disable clock */
 	if (enable != 0)
