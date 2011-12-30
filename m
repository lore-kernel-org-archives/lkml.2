Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab1L3CfO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 21:35:14 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45303 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918Ab1L3CfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 21:35:12 -0500
Message-ID: <1325212494.2569.1.camel@phoenix>
Subject: [PATCH RESEND] pxa/hx4700: add platform device and I2C info for
 AK4641 codec
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Philipp Zabel <philipp.zabel@gmail.com>,
        Dmitry Artamonow <mad_soft@inbox.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Date: Fri, 30 Dec 2011 10:34:54 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also rename AK4641 power GPIOs to document the codec chip.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
This patch was sent by Dmitry Artamonow on https://lkml.org/lkml/2011/5/18/222
and was resent on https://lkml.org/lkml/2011/9/12/100
The audio on hx4700 needs this patch to properly work.

 arch/arm/mach-pxa/hx4700.c              |   25 +++++++++++++++++++++++++
 arch/arm/mach-pxa/include/mach/hx4700.h |    4 ++--
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-pxa/hx4700.c b/arch/arm/mach-pxa/hx4700.c
index fb9b62d..1e2b627 100644
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
+	.gpio_power = GPIO27_HX4700_AK4641_POWER,
+	.gpio_npdn  = GPIO109_HX4700_AK4641_nPDN,
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
diff --git a/arch/arm/mach-pxa/include/mach/hx4700.h b/arch/arm/mach-pxa/include/mach/hx4700.h
index 8bc0291..f0f6015 100644
--- a/arch/arm/mach-pxa/include/mach/hx4700.h
+++ b/arch/arm/mach-pxa/include/mach/hx4700.h
@@ -29,7 +29,7 @@
 #define GPIO14_HX4700_nWLAN_IRQ			14
 #define GPIO18_HX4700_RDY			18
 #define GPIO22_HX4700_LCD_RL			22
-#define GPIO27_HX4700_CODEC_ON			27
+#define GPIO27_HX4700_AK4641_POWER		27
 #define GPIO32_HX4700_RS232_ON			32
 #define GPIO52_HX4700_CPU_nBATT_FAULT		52
 #define GPIO58_HX4700_TSC2046_nPENIRQ		58
@@ -67,7 +67,7 @@
 #define GPIO105_HX4700_nIR_ON			105
 #define GPIO106_HX4700_CPU_BT_nRESET		106
 #define GPIO107_HX4700_SPK_nSD			107
-#define GPIO109_HX4700_CODEC_nPDN		109
+#define GPIO109_HX4700_AK4641_nPDN		109
 #define GPIO110_HX4700_LCD_LVDD_3V3_ON		110
 #define GPIO111_HX4700_LCD_AVDD_3V3_ON		111
 #define GPIO112_HX4700_LCD_N2V7_7V3_ON		112
-- 
1.7.5.4



