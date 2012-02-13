Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab2BMOoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 09:44:09 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:61767 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540Ab2BMOoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 09:44:04 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com
Cc: tglx@linutronix.de, devicetree-discuss@lists.ozlabs.org,
        avictor.za@gmail.com, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>, rmallon@gmail.com
Subject: [PATCH 2/9] ARM: at91/snapper9260: move gpio_to_irq out of structure initialization
Date: Mon, 13 Feb 2012 15:43:02 +0100
Message-Id: <e0557a2864e52e017a0e931c6c64fd341ae21559.1329139662.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329144189-4535-1-git-send-email-nicolas.ferre@atmel.com>
References: <1329144189-4535-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <2fd1ebedc5ad5ac7aeb15c590c4400212a3b06cf.1329139662.git.nicolas.ferre@atmel.com>
References: <2fd1ebedc5ad5ac7aeb15c590c4400212a3b06cf.1329139662.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gpio_to_irq() implementation will be moved from a macro to a
plain function: we cannot use it in a structure initialization
anymore.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: rmallon@gmail.com
---
 arch/arm/mach-at91/board-snapper9260.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-at91/board-snapper9260.c b/arch/arm/mach-at91/board-snapper9260.c
index 4770db0..3c2e3fc 100644
--- a/arch/arm/mach-at91/board-snapper9260.c
+++ b/arch/arm/mach-at91/board-snapper9260.c
@@ -145,11 +145,11 @@ static struct i2c_board_info __initdata snapper9260_i2c_devices[] = {
 		/* Audio codec */
 		I2C_BOARD_INFO("tlv320aic23", 0x1a),
 	},
-	{
+};
+
+static struct i2c_board_info __initdata snapper9260_i2c_isl1208 = {
 		/* RTC */
 		I2C_BOARD_INFO("isl1208", 0x6f),
-		.irq = gpio_to_irq(AT91_PIN_PA31),
-	},
 };
 
 static void __init snapper9260_add_device_nand(void)
@@ -163,6 +163,10 @@ static void __init snapper9260_board_init(void)
 {
 	at91_add_device_i2c(snapper9260_i2c_devices,
 			    ARRAY_SIZE(snapper9260_i2c_devices));
+
+	snapper9260_i2c_isl1208.irq = gpio_to_irq(AT91_PIN_PA31);
+	i2c_register_board_info(0, &snapper9260_i2c_isl1208, 1);
+
 	at91_add_device_serial();
 	at91_add_device_usbh(&snapper9260_usbh_data);
 	at91_add_device_udc(&snapper9260_udc_data);
-- 
1.7.9

