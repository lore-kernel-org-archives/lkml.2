Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab2DRNiC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 09:38:02 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:34264 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753675Ab2DRNhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 09:37:31 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        thierry.reding@avionic-design.de, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
        axel.lin@gmail.com, broonie@opensource.wolfsonmicro.com,
        marek.vasut@gmail.com, devel@driverdev.osuosl.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, dan.carpenter@oracle.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v3 4/10] ARM: LPC32xx: clock.c dma adjustment
Date: Wed, 18 Apr 2012 15:36:09 +0200
Message-Id: <1334756176-25144-5-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1334756176-25144-1-git-send-email-stigge@antcom.de>
References: <1334756176-25144-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adjusts the DMA clock of the LPC32xx to "pl08xdmac" to be picked up
correctly by the AMBA dmaengine driver.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
 arch/arm/mach-lpc32xx/clock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.orig/arch/arm/mach-lpc32xx/clock.c
+++ linux-2.6/arch/arm/mach-lpc32xx/clock.c
@@ -1109,7 +1109,7 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_INIT(NULL, "timer2_ck", &clk_timer2),
 	CLKDEV_INIT(NULL, "timer3_ck", &clk_timer3),
 	CLKDEV_INIT(NULL, "vfp9_ck", &clk_vfp9),
-	CLKDEV_INIT(NULL, "clk_dmac", &clk_dma),
+	CLKDEV_INIT("pl08xdmac", NULL, &clk_dma),
 	CLKDEV_INIT("pnx4008-watchdog", NULL, &clk_wdt),
 	CLKDEV_INIT(NULL, "uart3_ck", &clk_uart3),
 	CLKDEV_INIT(NULL, "uart4_ck", &clk_uart4),
