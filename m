Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142Ab1L3EG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 23:06:26 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40035 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999Ab1L3EGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 23:06:23 -0500
Message-ID: <1325217971.4022.1.camel@phoenix>
Subject: [PATCH v2] pxa/hx4700: add platform device and I2C info for AK4641
 codec
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Philipp Zabel <philipp.zabel@gmail.com>,
        Dmitry Artamonow <mad_soft@inbox.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Date: Fri, 30 Dec 2011 12:06:11 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The audio on hx4700 needs this to properly work.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Marek Vasut <marek.vasut@gmail.com>
---
v2: Avoid rename AK4641 power GPIOs.

 arch/arm/mach-pxa/hx4700.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-pxa/hx4700.c b/arch/arm/mach-pxa/hx4700.c
index fb9b62d..208eef1 100644
--- a/arch/arm/mach-pxa/hx4700.c
+++ b/arch/arm/mach-pxa/hx4700.c
@@ -45,6 +45,7 @@
 #include <mach/hx4700.h>
 #include <mach/irda.h>
 
+#include <sound/ak4641.h>
 #include <video/platform_lcd.h>
 #include <video/w100fb.h>
 
@@ -765,6 +766,28 @@ static struct i2c_board_info __initdata pi2c_board_info[] = {
 };
 
 /*
+ * Asahi Kasei AK4641 on I2C
+ */
+
+static struct ak4641_platform_data ak4641_info = {
+	.gpio_power = GPIO27_HX4700_CODEC_ON,
+	.gpio_npdn  = GPIO109_HX4700_CODEC_nPDN,
+};
+
+static struct i2c_board_info i2c_board_info[] __initdata = {
+	{
+		I2C_BOARD_INFO("ak4641", 0x12),
+		.platform_data = &ak4641_info,
+	},
+};
+
+static struct platform_device audio = {
+	.name	= "hx4700-audio",
+	.id	= -1,
+};
+
+
+/*
  * PCMCIA
  */
 
@@ -790,6 +813,7 @@ static struct platform_device *devices[] __initdata = {
 	&gpio_vbus,
 	&power_supply,
 	&strataflash,
+	&audio,
 	&pcmcia,
 };
 
@@ -827,6 +851,7 @@ static void __init hx4700_init(void)
 	pxa_set_ficp_info(&ficp_info);
 	pxa27x_set_i2c_power_info(NULL);
 	pxa_set_i2c_info(NULL);
+	i2c_register_board_info(0, ARRAY_AND_SIZE(i2c_board_info));
 	i2c_register_board_info(1, ARRAY_AND_SIZE(pi2c_board_info));
 	pxa2xx_set_spi_info(2, &pxa_ssp2_master_info);
 	spi_register_board_info(ARRAY_AND_SIZE(tsc2046_board_info));
-- 
1.7.5.4



