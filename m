Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab0HBQDA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 12:03:00 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:64532 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753924Ab0HBQC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 12:02:58 -0400
Date: Mon, 2 Aug 2010 18:02:55 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Mike Frysinger <vapier@gentoo.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Barry Song <barry.song@analog.com>,
        Sonic Zhang <sonic.zhang@analog.com>, Cliff Cai <cliff.cai@analog.com>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 5/6] arch/blackfin: Remove dead CONFIG_ADF702X
Message-ID: <1bdd2af4056783afe300100b2a067d111ba4e7ca.1280764206.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1280764206.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1280764206.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ADF702X doesn't exist in Kconfig, therefore removing all references to
it from the source.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 arch/blackfin/mach-bf537/boards/stamp.c |   59 -------------------------------
 1 files changed, 0 insertions(+), 59 deletions(-)

diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index 09c6b46..ebce0d8 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -824,53 +824,6 @@ static struct bfin5xx_spi_chip enc28j60_spi_chip_info = {
 };
 #endif
 
-#if defined(CONFIG_ADF702X) || defined(CONFIG_ADF702X_MODULE)
-static struct bfin5xx_spi_chip adf7021_spi_chip_info = {
-	.bits_per_word = 16,
-	.cs_gpio = GPIO_PF10,
-};
-
-#include <linux/spi/adf702x.h>
-#define TXREG 0x0160A470
-static const u32 adf7021_regs[] = {
-	0x09608FA0,
-	0x00575011,
-	0x00A7F092,
-	0x2B141563,
-	0x81F29E94,
-	0x00003155,
-	0x050A4F66,
-	0x00000007,
-	0x00000008,
-	0x000231E9,
-	0x3296354A,
-	0x891A2B3B,
-	0x00000D9C,
-	0x0000000D,
-	0x0000000E,
-	0x0000000F,
-};
-
-static struct adf702x_platform_data adf7021_platform_data = {
-	.regs_base = (void *)SPORT1_TCR1,
-	.dma_ch_rx = CH_SPORT1_RX,
-	.dma_ch_tx = CH_SPORT1_TX,
-	.irq_sport_err = IRQ_SPORT1_ERROR,
-	.gpio_int_rfs = GPIO_PF8,
-	.pin_req = {P_SPORT1_DTPRI, P_SPORT1_RFS, P_SPORT1_DRPRI,
-			P_SPORT1_RSCLK, P_SPORT1_TSCLK, 0},
-	.adf702x_model = MODEL_ADF7021,
-	.adf702x_regs = adf7021_regs,
-	.tx_reg = TXREG,
-};
-static inline void adf702x_mac_init(void)
-{
-	random_ether_addr(adf7021_platform_data.mac_addr);
-}
-#else
-static inline void adf702x_mac_init(void) {}
-#endif
-
 #if defined(CONFIG_TOUCHSCREEN_ADS7846) || defined(CONFIG_TOUCHSCREEN_ADS7846_MODULE)
 #include <linux/spi/ads7846.h>
 static struct bfin5xx_spi_chip ad7873_spi_chip_info = {
@@ -1116,17 +1069,6 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 		.mode = SPI_MODE_3,
 	},
 #endif
-#if defined(CONFIG_ADF702X) || defined(CONFIG_ADF702X_MODULE)
-	{
-		.modalias = "adf702x",
-		.max_speed_hz = 16000000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = 0,	/* GPIO controlled SSEL */
-		.controller_data = &adf7021_spi_chip_info,
-		.platform_data = &adf7021_platform_data,
-		.mode = SPI_MODE_0,
-	},
-#endif
 #if defined(CONFIG_TOUCHSCREEN_ADS7846) || defined(CONFIG_TOUCHSCREEN_ADS7846_MODULE)
 	{
 		.modalias = "ads7846",
@@ -2279,7 +2221,6 @@ static int __init stamp_init(void)
 {
 	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	bfin_plat_nand_init();
-	adf702x_mac_init();
 	platform_add_devices(stamp_devices, ARRAY_SIZE(stamp_devices));
 	i2c_register_board_info(0, bfin_i2c_board_info,
 				ARRAY_SIZE(bfin_i2c_board_info));
-- 
1.7.0.4

