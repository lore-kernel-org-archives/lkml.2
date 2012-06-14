Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364Ab2FNQv7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 12:51:59 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:41243 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932251Ab2FNQvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 12:51:55 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v2 18/23] ARM: LPC32xx: Remove spi chipselect request from board init
Date: Thu, 14 Jun 2012 18:51:08 +0200
Message-Id: <1339692673-7848-19-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1339692673-7848-1-git-send-email-stigge@antcom.de>
References: <1339692673-7848-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

The lpc32xx spi0 chipselect will be requested directly from the
pl022 driver

Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Signed-off-by: Roland Stigge <stigge@antcom.de>
---
 arch/arm/mach-lpc32xx/phy3250.c |    7 -------
 1 file changed, 7 deletions(-)

--- linux-2.6.orig/arch/arm/mach-lpc32xx/phy3250.c
+++ linux-2.6/arch/arm/mach-lpc32xx/phy3250.c
@@ -359,13 +359,6 @@ static void __init lpc3250_machine_init(
 			     lpc32xx_auxdata_lookup, NULL);
 
 	/* Register GPIOs used on this board */
-	if (gpio_request(SPI0_CS_GPIO, "spi0 cs"))
-		printk(KERN_ERR "Error requesting gpio %u",
-			SPI0_CS_GPIO);
-	else if (gpio_direction_output(SPI0_CS_GPIO, 1))
-		printk(KERN_ERR "Error setting gpio %u to output",
-			SPI0_CS_GPIO);
-
 	if (gpio_request(MMC_PWR_ENABLE_GPIO, "mmc_power_en"))
 		pr_err("Error requesting gpio %u", MMC_PWR_ENABLE_GPIO);
 	else if (gpio_direction_output(MMC_PWR_ENABLE_GPIO, 1))
