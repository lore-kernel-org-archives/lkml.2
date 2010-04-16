Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758580Ab0DPQ2X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 12:28:23 -0400
Received: from av9-1-sn3.vrr.skanova.net ([81.228.9.185]:42010 "EHLO
	av9-1-sn3.vrr.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758549Ab0DPQ2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 12:28:20 -0400
Subject: [PATCH 2/2] mfd: Add timberdale video-in driver to timberdale
From: Richard =?ISO-8859-1?Q?R=F6jfors?= 
	<richard.rojfors@pelagicore.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Douglas Schilling Landgraf <dougsland@gmail.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       "Williams, Dan J" <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Apr 2010 18:28:17 +0200
Message-ID: <1271435297.11641.46.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch defines platform data for the video-in driver
and adds it to all configurations of timberdale.

Signed-off-by: Richard Röjfors <richard.rojfors@pelagicore.com>
---
diff --git a/drivers/mfd/timberdale.c b/drivers/mfd/timberdale.c
index 2d4691a..49aa733 100644
--- a/drivers/mfd/timberdale.c
+++ b/drivers/mfd/timberdale.c
@@ -40,6 +40,7 @@
 #include <linux/spi/mc33880.h>
 
 #include <media/timb_radio.h>
+#include <media/timb_video.h>
 
 #include <linux/timb_dma.h>
 
@@ -238,6 +239,22 @@ const static __devinitconst struct resource timberdale_uartlite_resources[] = {
 	},
 };
 
+static __devinitdata struct i2c_board_info timberdale_adv7180_i2c_board_info = {
+	/* Requires jumper JP9 to be off */
+	I2C_BOARD_INFO("adv7180", 0x42 >> 1),
+	.irq = IRQ_TIMBERDALE_ADV7180
+};
+
+static __devinitdata struct timb_video_platform_data
+	timberdale_video_platform_data = {
+	.dma_channel = DMA_VIDEO_RX,
+	.i2c_adapter = 0,
+	.encoder = {
+		.module_name = "adv7180",
+		.info = &timberdale_adv7180_i2c_board_info
+	}
+};
+
 const static __devinitconst struct resource timberdale_radio_resources[] = {
 	{
 		.start	= RDSOFFSET,
@@ -272,6 +289,18 @@ static __devinitdata struct timb_radio_platform_data
 	}
 };
 
+const static __devinitconst struct resource timberdale_video_resources[] = {
+	{
+		.start	= LOGIWOFFSET,
+		.end	= LOGIWEND,
+		.flags	= IORESOURCE_MEM,
+	},
+	/*
+	note that the "frame buffer" is located in DMA area
+	starting at 0x1200000
+	*/
+};
+
 static __devinitdata struct timb_dma_platform_data timb_dma_platform_data = {
 	.nr_channels = 10,
 	.channels = {
@@ -372,6 +401,13 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg0[] = {
 		.data_size = sizeof(timberdale_gpio_platform_data),
 	},
 	{
+		.name = "timb-video",
+		.num_resources = ARRAY_SIZE(timberdale_video_resources),
+		.resources = timberdale_video_resources,
+		.platform_data = &timberdale_video_platform_data,
+		.data_size = sizeof(timberdale_video_platform_data),
+	},
+	{
 		.name = "timb-radio",
 		.num_resources = ARRAY_SIZE(timberdale_radio_resources),
 		.resources = timberdale_radio_resources,
@@ -430,6 +466,13 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg1[] = {
 		.resources = timberdale_mlogicore_resources,
 	},
 	{
+		.name = "timb-video",
+		.num_resources = ARRAY_SIZE(timberdale_video_resources),
+		.resources = timberdale_video_resources,
+		.platform_data = &timberdale_video_platform_data,
+		.data_size = sizeof(timberdale_video_platform_data),
+	},
+	{
 		.name = "timb-radio",
 		.num_resources = ARRAY_SIZE(timberdale_radio_resources),
 		.resources = timberdale_radio_resources,
@@ -478,6 +521,13 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg2[] = {
 		.data_size = sizeof(timberdale_gpio_platform_data),
 	},
 	{
+		.name = "timb-video",
+		.num_resources = ARRAY_SIZE(timberdale_video_resources),
+		.resources = timberdale_video_resources,
+		.platform_data = &timberdale_video_platform_data,
+		.data_size = sizeof(timberdale_video_platform_data),
+	},
+	{
 		.name = "timb-radio",
 		.num_resources = ARRAY_SIZE(timberdale_radio_resources),
 		.resources = timberdale_radio_resources,
@@ -521,6 +571,13 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg3[] = {
 		.data_size = sizeof(timberdale_gpio_platform_data),
 	},
 	{
+		.name = "timb-video",
+		.num_resources = ARRAY_SIZE(timberdale_video_resources),
+		.resources = timberdale_video_resources,
+		.platform_data = &timberdale_video_platform_data,
+		.data_size = sizeof(timberdale_video_platform_data),
+	},
+	{
 		.name = "timb-radio",
 		.num_resources = ARRAY_SIZE(timberdale_radio_resources),
 		.resources = timberdale_radio_resources,


