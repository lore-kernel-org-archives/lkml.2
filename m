Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647Ab1EPVDg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 17:03:36 -0400
Received: from smtp16.mail.ru ([94.100.176.153]:42309 "EHLO smtp16.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129Ab1EPVDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 17:03:34 -0400
From: Dmitry Artamonow <mad_soft@inbox.ru>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Harald Welte <laforge@gnumonks.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Paul Parsons <lost.distance@yahoo.com>,
        Eric Miao <eric.y.miao@gmail.com>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] pxa/hx4700: add I2C board info for AK4641 codec
Date: Tue, 17 May 2011 01:03:25 +0400
Message-Id: <1305579805-15617-4-git-send-email-mad_soft@inbox.ru>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <1305579805-15617-1-git-send-email-mad_soft@inbox.ru>
References: <1305579805-15617-1-git-send-email-mad_soft@inbox.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philipp Zabel <philipp.zabel@gmail.com>

From: Philipp Zabel <philipp.zabel@gmail.com>

Also rename AK4641 power GPIOs to document the codec chip.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 arch/arm/mach-pxa/hx4700.c              |   18 ++++++++++++++++++
 arch/arm/mach-pxa/include/mach/hx4700.h |    4 ++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-pxa/hx4700.c b/arch/arm/mach-pxa/hx4700.c
index 9cdcca5..71c9e80 100644
--- a/arch/arm/mach-pxa/hx4700.c
+++ b/arch/arm/mach-pxa/hx4700.c
@@ -45,6 +45,7 @@
 #include <mach/hx4700.h>
 #include <mach/irda.h>
 
+#include <sound/ak4641.h>
 #include <video/platform_lcd.h>
 #include <video/w100fb.h>
 
@@ -801,6 +802,22 @@ static struct i2c_board_info __initdata pi2c_board_info[] = {
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
+/*
  * PCMCIA
  */
 
@@ -859,6 +876,7 @@ static void __init hx4700_init(void)
 	pxa_set_ficp_info(&ficp_info);
 	pxa27x_set_i2c_power_info(NULL);
 	pxa_set_i2c_info(NULL);
+	i2c_register_board_info(0, ARRAY_AND_SIZE(i2c_board_info));
 	i2c_register_board_info(1, ARRAY_AND_SIZE(pi2c_board_info));
 	pxa2xx_set_spi_info(2, &pxa_ssp2_master_info);
 	spi_register_board_info(ARRAY_AND_SIZE(tsc2046_board_info));
diff --git a/arch/arm/mach-pxa/include/mach/hx4700.h b/arch/arm/mach-pxa/include/mach/hx4700.h
index 3740844..73cd586 100644
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
1.7.4.rc1

