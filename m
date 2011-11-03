Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab1KCVVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 17:21:39 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:60995 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab1KCVVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 17:21:38 -0400
From: Thomas Weber <weber@corscience.de>
To: Tony Lindgren <tony@atomide.com>
Cc: Thomas Weber <weber@corscience.de>, Russell King <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [RFC/PATCH] ARM: OMAP2+: Add chip_select to ads7846 init
Date: Thu,  3 Nov 2011 23:23:19 +0100
Message-Id: <1320358999-11016-1-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the chip_select as parameter to
omap_ads7846_init.
All existing omap2-boards use chip select 0 on
different spi busses. I work on bringing a board
mainline where the ads7846 is connected to
chip select 1. This patch prepares the omap_ads7846_init
function for this board.

Signed-off-by: Thomas Weber <weber@corscience.de>
---
 arch/arm/mach-omap2/board-3430sdp.c        |    2 +-
 arch/arm/mach-omap2/board-cm-t35.c         |    2 +-
 arch/arm/mach-omap2/board-devkit8000.c     |    2 +-
 arch/arm/mach-omap2/board-ldp.c            |    2 +-
 arch/arm/mach-omap2/board-omap3evm.c       |    2 +-
 arch/arm/mach-omap2/board-omap3pandora.c   |    2 +-
 arch/arm/mach-omap2/board-omap3stalker.c   |    2 +-
 arch/arm/mach-omap2/board-omap3touchbook.c |    2 +-
 arch/arm/mach-omap2/board-overo.c          |    2 +-
 arch/arm/mach-omap2/common-board-devices.c |   13 ++++++++-----
 arch/arm/mach-omap2/common-board-devices.h |    3 ++-
 11 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/arch/arm/mach-omap2/board-3430sdp.c b/arch/arm/mach-omap2/board-3430sdp.c
index 77142c1..dec6407 100644
--- a/arch/arm/mach-omap2/board-3430sdp.c
+++ b/arch/arm/mach-omap2/board-3430sdp.c
@@ -710,7 +710,7 @@ static void __init omap_3430sdp_init(void)
 		gpio_pendown = SDP3430_TS_GPIO_IRQ_SDPV2;
 	else
 		gpio_pendown = SDP3430_TS_GPIO_IRQ_SDPV1;
-	omap_ads7846_init(1, gpio_pendown, 310, NULL);
+	omap_ads7846_init(1, 0, gpio_pendown, 310, NULL);
 	board_serial_init();
 	omap_sdrc_init(hyb18m512160af6_sdrc_params, NULL);
 	usb_musb_init(NULL);
diff --git a/arch/arm/mach-omap2/board-cm-t35.c b/arch/arm/mach-omap2/board-cm-t35.c
index bd1bcac..3c82640 100644
--- a/arch/arm/mach-omap2/board-cm-t35.c
+++ b/arch/arm/mach-omap2/board-cm-t35.c
@@ -606,7 +606,7 @@ static void __init cm_t3x_common_init(void)
 	omap_sdrc_init(mt46h32m32lf6_sdrc_params,
 			     mt46h32m32lf6_sdrc_params);
 	cm_t35_init_i2c();
-	omap_ads7846_init(1, CM_T35_GPIO_PENDOWN, 0, NULL);
+	omap_ads7846_init(1, 0, CM_T35_GPIO_PENDOWN, 0, NULL);
 	cm_t35_init_ethernet();
 	cm_t35_init_led();
 	cm_t35_init_display();
diff --git a/arch/arm/mach-omap2/board-devkit8000.c b/arch/arm/mach-omap2/board-devkit8000.c
index 90154e4..669ada3 100644
--- a/arch/arm/mach-omap2/board-devkit8000.c
+++ b/arch/arm/mach-omap2/board-devkit8000.c
@@ -642,7 +642,7 @@ static void __init devkit8000_init(void)
 
 	omap_display_init(&devkit8000_dss_data);
 
-	omap_ads7846_init(2, OMAP3_DEVKIT_TS_GPIO, 0, NULL);
+	omap_ads7846_init(2, 0, OMAP3_DEVKIT_TS_GPIO, 0, NULL);
 
 	usb_musb_init(NULL);
 	usbhs_init(&usbhs_bdata);
diff --git a/arch/arm/mach-omap2/board-ldp.c b/arch/arm/mach-omap2/board-ldp.c
index e179da0..0c19262 100644
--- a/arch/arm/mach-omap2/board-ldp.c
+++ b/arch/arm/mach-omap2/board-ldp.c
@@ -417,7 +417,7 @@ static void __init omap_ldp_init(void)
 	ldp_init_smsc911x();
 	omap_i2c_init();
 	platform_add_devices(ldp_devices, ARRAY_SIZE(ldp_devices));
-	omap_ads7846_init(1, 54, 310, NULL);
+	omap_ads7846_init(1, 0, 54, 310, NULL);
 	omap_serial_init();
 	omap_sdrc_init(NULL, NULL);
 	usb_musb_init(NULL);
diff --git a/arch/arm/mach-omap2/board-omap3evm.c b/arch/arm/mach-omap2/board-omap3evm.c
index 2d24e28..57fd2d4 100644
--- a/arch/arm/mach-omap2/board-omap3evm.c
+++ b/arch/arm/mach-omap2/board-omap3evm.c
@@ -661,7 +661,7 @@ static void __init omap3_evm_init(void)
 	}
 	usb_musb_init(&musb_board_data);
 	usbhs_init(&usbhs_bdata);
-	omap_ads7846_init(1, OMAP3_EVM_TS_GPIO, 310, NULL);
+	omap_ads7846_init(1, 0, OMAP3_EVM_TS_GPIO, 310, NULL);
 	omap3evm_init_smsc911x();
 	omap3_evm_display_init();
 
diff --git a/arch/arm/mach-omap2/board-omap3pandora.c b/arch/arm/mach-omap2/board-omap3pandora.c
index f7811f4..9606a51 100644
--- a/arch/arm/mach-omap2/board-omap3pandora.c
+++ b/arch/arm/mach-omap2/board-omap3pandora.c
@@ -590,7 +590,7 @@ static void __init omap3pandora_init(void)
 				  mt46h32m32lf6_sdrc_params);
 	spi_register_board_info(omap3pandora_spi_board_info,
 			ARRAY_SIZE(omap3pandora_spi_board_info));
-	omap_ads7846_init(1, OMAP3_PANDORA_TS_GPIO, 0, NULL);
+	omap_ads7846_init(1, 0, OMAP3_PANDORA_TS_GPIO, 0, NULL);
 	usbhs_init(&usbhs_bdata);
 	usb_musb_init(NULL);
 	gpmc_nand_init(&pandora_nand_data);
diff --git a/arch/arm/mach-omap2/board-omap3stalker.c b/arch/arm/mach-omap2/board-omap3stalker.c
index ddb7d66..808e8e6 100644
--- a/arch/arm/mach-omap2/board-omap3stalker.c
+++ b/arch/arm/mach-omap2/board-omap3stalker.c
@@ -436,7 +436,7 @@ static void __init omap3_stalker_init(void)
 	omap_sdrc_init(mt46h32m32lf6_sdrc_params, NULL);
 	usb_musb_init(NULL);
 	usbhs_init(&usbhs_bdata);
-	omap_ads7846_init(1, OMAP3_STALKER_TS_GPIO, 310, NULL);
+	omap_ads7846_init(1, 0, OMAP3_STALKER_TS_GPIO, 310, NULL);
 
 	omap_mux_init_gpio(21, OMAP_PIN_OUTPUT);
 	omap_mux_init_gpio(18, OMAP_PIN_INPUT_PULLUP);
diff --git a/arch/arm/mach-omap2/board-omap3touchbook.c b/arch/arm/mach-omap2/board-omap3touchbook.c
index a2d0d19..3821e9a 100644
--- a/arch/arm/mach-omap2/board-omap3touchbook.c
+++ b/arch/arm/mach-omap2/board-omap3touchbook.c
@@ -363,7 +363,7 @@ static void __init omap3_touchbook_init(void)
 	gpio_request_one(176, GPIOF_OUT_INIT_HIGH, "DVI_nPD");
 
 	/* Touchscreen and accelerometer */
-	omap_ads7846_init(4, OMAP3_TS_GPIO, 310, &ads7846_pdata);
+	omap_ads7846_init(4, 0, OMAP3_TS_GPIO, 310, &ads7846_pdata);
 	usb_musb_init(NULL);
 	usbhs_init(&usbhs_bdata);
 	omap_nand_flash_init(NAND_BUSWIDTH_16, omap3touchbook_nand_partitions,
diff --git a/arch/arm/mach-omap2/board-overo.c b/arch/arm/mach-omap2/board-overo.c
index 4cf7aea..3323e11 100644
--- a/arch/arm/mach-omap2/board-overo.c
+++ b/arch/arm/mach-omap2/board-overo.c
@@ -105,7 +105,7 @@ static struct platform_device vads7846_device = {
 
 static void __init overo_ads7846_init(void)
 {
-	omap_ads7846_init(1, OVERO_GPIO_PENDOWN, 0, NULL);
+	omap_ads7846_init(1, 0, OVERO_GPIO_PENDOWN, 0, NULL);
 	platform_device_register(&vads7846_device);
 }
 
diff --git a/arch/arm/mach-omap2/common-board-devices.c b/arch/arm/mach-omap2/common-board-devices.c
index bcb0c58..a02cca6 100644
--- a/arch/arm/mach-omap2/common-board-devices.c
+++ b/arch/arm/mach-omap2/common-board-devices.c
@@ -51,14 +51,15 @@ static struct ads7846_platform_data ads7846_config = {
 static struct spi_board_info ads7846_spi_board_info __initdata = {
 	.modalias		= "ads7846",
 	.bus_num		= -EINVAL,
-	.chip_select		= 0,
+	.chip_select		= -EINVAL,
 	.max_speed_hz		= 1500000,
 	.controller_data	= &ads7846_mcspi_config,
 	.irq			= -EINVAL,
 	.platform_data		= &ads7846_config,
 };
 
-void __init omap_ads7846_init(int bus_num, int gpio_pendown, int gpio_debounce,
+void __init omap_ads7846_init(int bus_num, int chip_select,
+			      int gpio_pendown, int gpio_debounce,
 			      struct ads7846_platform_data *board_pdata)
 {
 	struct spi_board_info *spi_bi = &ads7846_spi_board_info;
@@ -78,8 +79,9 @@ void __init omap_ads7846_init(int bus_num, int gpio_pendown, int gpio_debounce,
 
 	ads7846_config.gpio_pendown = gpio_pendown;
 
-	spi_bi->bus_num	= bus_num;
-	spi_bi->irq	= OMAP_GPIO_IRQ(gpio_pendown);
+	spi_bi->bus_num	    = bus_num;
+	spi_bi->chip_select = chip_select;
+	spi_bi->irq	    = OMAP_GPIO_IRQ(gpio_pendown);
 
 	if (board_pdata)
 		spi_bi->platform_data = board_pdata;
@@ -87,7 +89,8 @@ void __init omap_ads7846_init(int bus_num, int gpio_pendown, int gpio_debounce,
 	spi_register_board_info(&ads7846_spi_board_info, 1);
 }
 #else
-void __init omap_ads7846_init(int bus_num, int gpio_pendown, int gpio_debounce,
+void __init omap_ads7846_init(int bus_num,  int chip_select,
+			      int gpio_pendown, int gpio_debounce,
 			      struct ads7846_platform_data *board_pdata)
 {
 }
diff --git a/arch/arm/mach-omap2/common-board-devices.h b/arch/arm/mach-omap2/common-board-devices.h
index a0b4a428..784be17 100644
--- a/arch/arm/mach-omap2/common-board-devices.h
+++ b/arch/arm/mach-omap2/common-board-devices.h
@@ -8,7 +8,8 @@
 struct mtd_partition;
 struct ads7846_platform_data;
 
-void omap_ads7846_init(int bus_num, int gpio_pendown, int gpio_debounce,
+void omap_ads7846_init(int bus_num, int chip_select,
+		       int gpio_pendown, int gpio_debounce,
 		       struct ads7846_platform_data *board_pdata);
 void omap_nand_flash_init(int opts, struct mtd_partition *parts, int n_parts);
 
-- 
1.7.7.1

