Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab0LMEDw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 23:03:52 -0500
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:41357 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754519Ab0LMEDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 23:03:50 -0500
From: Sundar Iyer <sundar.iyer@stericsson.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: <linux-kernel@vger.kernel.org>, Sundar Iyer <sundar.iyer@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH v2 1/8] mach-ux500: deprecate spi support for ab8500
Date: Mon, 13 Dec 2010 09:33:11 +0530
Message-ID: <1292212998-13066-2-git-send-email-sundar.iyer@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
In-Reply-To: <1292212998-13066-1-git-send-email-sundar.iyer@stericsson.com>
References: <1292212998-13066-1-git-send-email-sundar.iyer@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Sundar Iyer <sundar.iyer@stericsson.com>
---
 arch/arm/mach-ux500/board-mop500.c |   36 +-----------------------------------
 1 files changed, 1 insertions(+), 35 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 5545711..cfcfcd3 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -76,22 +76,6 @@ static pin_cfg_t mop500_pins[] = {
 	GPIO217_GPIO,		/* GPIO_EXP_INT */
 };
 
-static void ab4500_spi_cs_control(u32 command)
-{
-	/* set the FRM signal, which is CS  - TODO */
-}
-
-struct pl022_config_chip ab4500_chip_info = {
-	.com_mode = INTERRUPT_TRANSFER,
-	.iface = SSP_INTERFACE_MOTOROLA_SPI,
-	/* we can act as master only */
-	.hierarchy = SSP_MASTER,
-	.slave_tx_disable = 0,
-	.rx_lev_trig = SSP_RX_1_OR_MORE_ELEM,
-	.tx_lev_trig = SSP_TX_1_OR_MORE_EMPTY_LOC,
-	.cs_control = ab4500_spi_cs_control,
-};
-
 static struct ab8500_platform_data ab8500_platdata = {
 	.irq_base	= MOP500_AB8500_IRQ_BASE,
 };
@@ -114,19 +98,6 @@ struct platform_device ab8500_device = {
 	.resource = ab8500_resources,
 };
 
-static struct spi_board_info ab8500_spi_devices[] = {
-	{
-		.modalias = "ab8500-spi",
-		.controller_data = &ab4500_chip_info,
-		.platform_data = &ab8500_platdata,
-		.max_speed_hz = 12000000,
-		.bus_num = 0,
-		.chip_select = 0,
-		.mode = SPI_MODE_3,
-		.irq = IRQ_DB8500_AB8500,
-	},
-};
-
 static struct pl022_ssp_controller ssp0_platform_data = {
 	.bus_id = 0,
 	/* pl022 not yet supports dma */
@@ -339,12 +310,7 @@ static void __init u8500_init_machine(void)
 	mop500_spi_init();
 	mop500_uart_init();
 
-	/* If HW is early drop (ED) or V1.0 then use SPI to access AB8500 */
-	if (cpu_is_u8500ed() || cpu_is_u8500v10())
-		spi_register_board_info(ab8500_spi_devices,
-			ARRAY_SIZE(ab8500_spi_devices));
-	else /* If HW is v.1.1 or later use I2C to access AB8500 */
-		platform_device_register(&ab8500_device);
+	platform_device_register(&ab8500_device);
 
 	i2c_register_board_info(0, mop500_i2c0_devices,
 				ARRAY_SIZE(mop500_i2c0_devices));
-- 
1.7.2.dirty

