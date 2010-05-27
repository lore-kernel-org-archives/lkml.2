Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427Ab0E0PpY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 11:45:24 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:44965 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077Ab0E0PpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 11:45:22 -0400
From: Dinh.Nguyen@freescale.com
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, s.hauer@pengutronix.de,
       valentin.longchamp@epfl.ch, daniel@caiaq.de, grant.likely@secretlab.ca,
       xiao-lizhang@freescale.com, Dinh Nguyen <Dinh.Nguyen@freescale.com>
Subject: [PATCHv3 2.6.34 2/2] mx5: Register i2c on Freescale MX51 Babbage HW
Date: Thu, 27 May 2010 10:45:05 -0500
Message-Id: <1274975105-8884-2-git-send-email-Dinh.Nguyen@freescale.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1274975105-8884-1-git-send-email-Dinh.Nguyen@freescale.com>
References: <1274975105-8884-1-git-send-email-Dinh.Nguyen@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <Dinh.Nguyen@freescale.com>

Add device registration and setup IOMUX pins in the mx51_babbage
board feil.

Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
---
 arch/arm/mach-mx5/board-mx51_babbage.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-mx5/board-mx51_babbage.c b/arch/arm/mach-mx5/board-mx51_babbage.c
index ed885f9..19cde68 100644
--- a/arch/arm/mach-mx5/board-mx51_babbage.c
+++ b/arch/arm/mach-mx5/board-mx51_babbage.c
@@ -12,6 +12,7 @@
 
 #include <linux/init.h>
 #include <linux/platform_device.h>
+#include <linux/i2c.h>
 #include <linux/gpio.h>
 #include <linux/delay.h>
 #include <linux/io.h>
@@ -21,6 +22,7 @@
 #include <mach/hardware.h>
 #include <mach/imx-uart.h>
 #include <mach/iomux-mx51.h>
+#include <mach/i2c.h>
 #include <mach/mxc_ehci.h>
 
 #include <asm/irq.h>
@@ -64,6 +66,18 @@ static struct pad_desc mx51babbage_pads[] = {
 	MX51_PAD_EIM_D27__UART3_RTS,
 	MX51_PAD_EIM_D24__UART3_CTS,
 
+	/* I2C1 */
+	MX51_PAD_EIM_D16__I2C1_SDA,
+	MX51_PAD_EIM_D19__I2C1_SCL,
+
+	/* I2C2 */
+	MX51_PAD_KEY_COL4__I2C2_SCL,
+	MX51_PAD_KEY_COL5__I2C2_SDA,
+
+	/* HSI2C */
+	MX51_PAD_I2C1_CLK__HSI2C_CLK,
+	MX51_PAD_I2C1_DAT__HSI2C_DAT,
+
 	/* USB HOST1 */
 	MX51_PAD_USBH1_CLK__USBH1_CLK,
 	MX51_PAD_USBH1_DIR__USBH1_DIR,
@@ -99,6 +113,14 @@ static inline void mxc_init_imx_uart(void)
 }
 #endif /* SERIAL_IMX */
 
+static struct imxi2c_platform_data babbage_i2c_data = {
+	.bitrate = 100000,
+};
+
+static struct imxi2c_platform_data babbage_hsi2c_data = {
+	.bitrate = 400000,
+};
+
 static int gpio_usbh1_active(void)
 {
 	struct pad_desc usbh1stp_gpio = MX51_PAD_USBH1_STP__GPIO_1_27;
@@ -230,6 +252,10 @@ static void __init mxc_board_init(void)
 	mxc_init_imx_uart();
 	platform_add_devices(devices, ARRAY_SIZE(devices));
 
+	mxc_register_device(&mxc_i2c_device0, &babbage_i2c_data);
+	mxc_register_device(&mxc_i2c_device1, &babbage_i2c_data);
+	mxc_register_device(&mxc_hsi2c_device, &babbage_hsi2c_data);
+
 	if (otg_mode_host)
 		mxc_register_device(&mxc_usbdr_host_device, &dr_utmi_config);
 	else {
-- 
1.6.0.4

