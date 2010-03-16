Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935356Ab0CPJnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 05:43:32 -0400
Received: from av6-1-sn3.vrr.skanova.net ([81.228.9.179]:47988 "EHLO
	av6-1-sn3.vrr.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827Ab0CPJnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 05:43:31 -0400
Subject: [PATCH] mfd: Add in XIIC to some configurations of timberdale
From: Richard =?ISO-8859-1?Q?R=F6jfors?= 
	<richard.rojfors@pelagicore.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Mar 2010 10:43:28 +0100
Message-ID: <1268732608.2020.10.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds in the Xilinx I2C bus driver to some of the
configurations of the timberdale MFD.

It provides the I2C devices to the XIIC via platform data in a
similar way as done to the ocores driver.

Signed-off-by: Richard Röjfors <richard.rojfors@pelagicore.com>
---
diff --git a/drivers/mfd/timberdale.c b/drivers/mfd/timberdale.c
index 1ed44d2..1d52349 100644
--- a/drivers/mfd/timberdale.c
+++ b/drivers/mfd/timberdale.c
@@ -30,6 +30,7 @@
 
 #include <linux/i2c.h>
 #include <linux/i2c-ocores.h>
+#include <linux/i2c-xiic.h>
 #include <linux/i2c/tsc2007.h>
 
 #include <linux/spi/spi.h>
@@ -68,6 +69,12 @@ static struct i2c_board_info timberdale_i2c_board_info[] = {
 	},
 };
 
+static __devinitdata struct xiic_i2c_platform_data
+timberdale_xiic_platform_data = {
+	.devices = timberdale_i2c_board_info,
+	.num_devices = ARRAY_SIZE(timberdale_i2c_board_info)
+};
+
 static __devinitdata struct ocores_i2c_platform_data
 timberdale_ocores_platform_data = {
 	.regstep = 4,
@@ -76,6 +83,19 @@ timberdale_ocores_platform_data = {
 	.num_devices = ARRAY_SIZE(timberdale_i2c_board_info)
 };
 
+const static __devinitconst struct resource timberdale_xiic_resources[] = {
+	{
+		.start	= XIICOFFSET,
+		.end	= XIICEND,
+		.flags	= IORESOURCE_MEM,
+	},
+	{
+		.start	= IRQ_TIMBERDALE_I2C,
+		.end	= IRQ_TIMBERDALE_I2C,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
 const static __devinitconst struct resource timberdale_ocores_resources[] = {
 	{
 		.start	= OCORESOFFSET,
@@ -269,6 +289,13 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg0[] = {
 		.resources = timberdale_uart_resources,
 	},
 	{
+		.name = "xiic-i2c",
+		.num_resources = ARRAY_SIZE(timberdale_xiic_resources),
+		.resources = timberdale_xiic_resources,
+		.platform_data = &timberdale_xiic_platform_data,
+		.data_size = sizeof(timberdale_xiic_platform_data),
+	},
+	{
 		.name = "timb-gpio",
 		.num_resources = ARRAY_SIZE(timberdale_gpio_resources),
 		.resources = timberdale_gpio_resources,
@@ -313,6 +340,13 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg1[] = {
 		.resources = timberdale_uartlite_resources,
 	},
 	{
+		.name = "xiic-i2c",
+		.num_resources = ARRAY_SIZE(timberdale_xiic_resources),
+		.resources = timberdale_xiic_resources,
+		.platform_data = &timberdale_xiic_platform_data,
+		.data_size = sizeof(timberdale_xiic_platform_data),
+	},
+	{
 		.name = "timb-gpio",
 		.num_resources = ARRAY_SIZE(timberdale_gpio_resources),
 		.resources = timberdale_gpio_resources,
@@ -357,6 +391,13 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg2[] = {
 		.resources = timberdale_uart_resources,
 	},
 	{
+		.name = "xiic-i2c",
+		.num_resources = ARRAY_SIZE(timberdale_xiic_resources),
+		.resources = timberdale_xiic_resources,
+		.platform_data = &timberdale_xiic_platform_data,
+		.data_size = sizeof(timberdale_xiic_platform_data),
+	},
+	{
 		.name = "timb-gpio",
 		.num_resources = ARRAY_SIZE(timberdale_gpio_resources),
 		.resources = timberdale_gpio_resources,

