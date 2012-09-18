Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508Ab2IRNBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 09:01:17 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:60985 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754754Ab2IRNBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 09:01:03 -0400
From: Roland Stigge <stigge@antcom.de>
To: linux-arm-kernel@lists.infradead.org, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, arnd@arndb.de,
        devicetree-discuss@lists.ozlabs.org, aletes.xgr@gmail.com,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 2/2] ARM: LPC32xx: Platform update for devicetree completion of spi-pl022
Date: Tue, 18 Sep 2012 15:00:28 +0200
Message-Id: <1347973228-29839-2-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347973228-29839-1-git-send-email-stigge@antcom.de>
References: <1347973228-29839-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

spi-pl022 got a further update to its devicetree support, completing properties
such that no platform data is necessary anymore. This patch adjusts phy3250.c
accordingly: The supplied platform data is deleted. However, OF_DEV_AUXDATA()
are still necessary due to device naming ("dev:ssp0").

Signed-off-by: Roland Stigge <stigge@antcom.de>

--
I will do a git pull request for arm-soc.git when the respective change in
spi-pl022.c is merged.

--- linux-2.6.orig/arch/arm/mach-lpc32xx/phy3250.c
+++ linux-2.6/arch/arm/mach-lpc32xx/phy3250.c
@@ -27,7 +27,6 @@
 #include <linux/gpio.h>
 #include <linux/amba/bus.h>
 #include <linux/amba/clcd.h>
-#include <linux/amba/pl022.h>
 #include <linux/amba/pl08x.h>
 #include <linux/amba/mmci.h>
 #include <linux/of.h>
@@ -156,21 +155,6 @@ static struct clcd_board lpc32xx_clcd_da
 	.remove		= lpc32xx_clcd_remove,
 };
 
-/*
- * AMBA SSP (SPI)
- */
-static struct pl022_ssp_controller lpc32xx_ssp0_data = {
-	.bus_id			= 0,
-	.num_chipselect		= 1,
-	.enable_dma		= 0,
-};
-
-static struct pl022_ssp_controller lpc32xx_ssp1_data = {
-	.bus_id			= 1,
-	.num_chipselect		= 1,
-	.enable_dma		= 0,
-};
-
 static struct pl08x_channel_data pl08x_slave_channels[] = {
 	{
 		.bus_id = "nand-slc",
@@ -232,8 +216,8 @@ static struct lpc32xx_mlc_platform_data
 };
 
 static const struct of_dev_auxdata lpc32xx_auxdata_lookup[] __initconst = {
-	OF_DEV_AUXDATA("arm,pl022", 0x20084000, "dev:ssp0", &lpc32xx_ssp0_data),
-	OF_DEV_AUXDATA("arm,pl022", 0x2008C000, "dev:ssp1", &lpc32xx_ssp1_data),
+	OF_DEV_AUXDATA("arm,pl022", 0x20084000, "dev:ssp0", NULL),
+	OF_DEV_AUXDATA("arm,pl022", 0x2008C000, "dev:ssp1", NULL),
 	OF_DEV_AUXDATA("arm,pl110", 0x31040000, "dev:clcd", &lpc32xx_clcd_data),
 	OF_DEV_AUXDATA("arm,pl080", 0x31000000, "pl08xdmac", &pl08x_pd),
 	OF_DEV_AUXDATA("arm,pl18x", 0x20098000, "20098000.sd",
