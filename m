Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab1FMN1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 09:27:37 -0400
Received: from smtp-out-074.synserver.de ([212.40.185.74]:1058 "HELO
	smtp-out-072.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1752120Ab1FMN1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 09:27:35 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 27841
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, device-drivers-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 3/3] Blackfin: bf537: Stamp: Register adau1701 codec and ASoC machine driver
Date: Mon, 13 Jun 2011 15:26:22 +0200
Message-Id: <1307971582-13532-3-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1307971582-13532-1-git-send-email-lars@metafoo.de>
References: <1307971582-13532-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 arch/blackfin/mach-bf537/boards/stamp.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index 76db1d4..95a8260 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -2390,6 +2390,11 @@ static struct i2c_board_info __initdata bfin_i2c_board_info[] = {
 		I2C_BOARD_INFO("adau1361", 0x38),
 	},
 #endif
+#if defined(CONFIG_SND_SOC_ADAU1701) || defined(CONFIG_SND_SOC_ADAU1701_MODULE)
+	{
+		I2C_BOARD_INFO("adau1701", 0x34),
+	},
+#endif
 #if defined(CONFIG_AD525X_DPOT) || defined(CONFIG_AD525X_DPOT_MODULE)
 	{
 		I2C_BOARD_INFO("ad5258", 0x18),
@@ -2760,6 +2765,13 @@ static struct platform_device iio_gpio_trigger = {
 };
 #endif
 
+#if defined(CONFIG_SND_SOC_BFIN_EVAL_ADAU1701) || \
+	defined(CONFIG_SND_SOC_BFIN_EVAL_ADAU1701_MODULE)
+static struct platform_device bf5xx_adau1701_device = {
+	.name = "bfin-eval-adau1701",
+};
+#endif
+
 static struct platform_device *stamp_devices[] __initdata = {
 
 	&bfin_dpmc,
@@ -2914,6 +2926,11 @@ static struct platform_device *stamp_devices[] __initdata = {
 	defined(CONFIG_IIO_GPIO_TRIGGER_MODULE)
 	&iio_gpio_trigger,
 #endif
+
+#if defined(CONFIG_SND_SOC_BFIN_EVAL_ADAU1701) || \
+	defined(CONFIG_SND_SOC_BFIN_EVAL_ADAU1701_MODULE)
+	&bf5xx_adau1701_device,
+#endif
 };
 
 static int __init stamp_init(void)
-- 
1.7.2.5

