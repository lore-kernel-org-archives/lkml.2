Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379Ab2FNQwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 12:52:00 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:35089 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932348Ab2FNQv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 12:51:56 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v2 19/23] ARM: LPC32xx: Remove spi chip definitions
Date: Thu, 14 Jun 2012 18:51:09 +0200
Message-Id: <1339692673-7848-20-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1339692673-7848-1-git-send-email-stigge@antcom.de>
References: <1339692673-7848-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

Leave chipselect and spi devices binding to the devicetree

Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Signed-off-by: Roland Stigge <stigge@antcom.de>
---
 arch/arm/mach-lpc32xx/phy3250.c |   56 ----------------------------------------
 1 file changed, 56 deletions(-)

--- linux-2.6.orig/arch/arm/mach-lpc32xx/phy3250.c
+++ linux-2.6/arch/arm/mach-lpc32xx/phy3250.c
@@ -162,24 +162,6 @@ static struct clcd_board lpc32xx_clcd_da
 /*
  * AMBA SSP (SPI)
  */
-static void phy3250_spi_cs_set(u32 control)
-{
-	gpio_set_value(SPI0_CS_GPIO, (int) control);
-}
-
-static struct pl022_config_chip spi0_chip_info = {
-	.com_mode		= INTERRUPT_TRANSFER,
-	.iface			= SSP_INTERFACE_MOTOROLA_SPI,
-	.hierarchy		= SSP_MASTER,
-	.slave_tx_disable	= 0,
-	.rx_lev_trig		= SSP_RX_4_OR_MORE_ELEM,
-	.tx_lev_trig		= SSP_TX_4_OR_MORE_EMPTY_LOC,
-	.ctrl_len		= SSP_BITS_8,
-	.wait_state		= SSP_MWIRE_WAIT_ZERO,
-	.duplex			= SSP_MICROWIRE_CHANNEL_FULL_DUPLEX,
-	.cs_control		= phy3250_spi_cs_set,
-};
-
 static struct pl022_ssp_controller lpc32xx_ssp0_data = {
 	.bus_id			= 0,
 	.num_chipselect		= 1,
@@ -192,44 +174,6 @@ static struct pl022_ssp_controller lpc32
 	.enable_dma		= 0,
 };
 
-/* AT25 driver registration */
-static int __init phy3250_spi_board_register(void)
-{
-#if defined(CONFIG_SPI_SPIDEV) || defined(CONFIG_SPI_SPIDEV_MODULE)
-	static struct spi_board_info info[] = {
-		{
-			.modalias = "spidev",
-			.max_speed_hz = 5000000,
-			.bus_num = 0,
-			.chip_select = 0,
-			.controller_data = &spi0_chip_info,
-		},
-	};
-
-#else
-	static struct spi_eeprom eeprom = {
-		.name = "at25256a",
-		.byte_len = 0x8000,
-		.page_size = 64,
-		.flags = EE_ADDR2,
-	};
-
-	static struct spi_board_info info[] = {
-		{
-			.modalias = "at25",
-			.max_speed_hz = 5000000,
-			.bus_num = 0,
-			.chip_select = 0,
-			.mode = SPI_MODE_0,
-			.platform_data = &eeprom,
-			.controller_data = &spi0_chip_info,
-		},
-	};
-#endif
-	return spi_register_board_info(info, ARRAY_SIZE(info));
-}
-arch_initcall(phy3250_spi_board_register);
-
 static struct pl08x_channel_data pl08x_slave_channels[] = {
 	{
 		.bus_id = "nand-slc",
