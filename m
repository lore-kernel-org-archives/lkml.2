Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab1FWHJ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 03:09:59 -0400
Received: from smtp-out-003.synserver.de ([212.40.185.3]:1220 "HELO
	smtp-out-224.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1754028Ab1FWHJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 03:09:57 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 24626
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, device-drivers-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 3/3] Blackfin: bf537: Stamp: Register adav801 codec and ASoC machine driver
Date: Thu, 23 Jun 2011 08:00:18 +0200
Message-Id: <1308808818-26775-3-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1308808818-26775-1-git-send-email-lars@metafoo.de>
References: <1308808818-26775-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is already an entry in the spi device table for the codec, but the
modalias was wrong. Also the config symbol name for the codec is wrong, so this
is fixed as well.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 arch/blackfin/mach-bf537/boards/stamp.c |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index 5d30566..198018e 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -1000,9 +1000,9 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 #endif
 
-#if defined(CONFIG_SND_BF5XX_SOC_ADAV80X) || defined(CONFIG_SND_BF5XX_SOC_ADAV80X_MODULE)
+#if defined(CONFIG_SND_SOC_ADAV80X) || defined(CONFIG_SND_SOC_ADV80X_MODULE)
 	{
-		.modalias = "adav80x",
+		.modalias = "adav801",
 		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 0,
 		.chip_select = 1,
@@ -2118,7 +2118,7 @@ static struct i2c_board_info __initdata bfin_i2c_board_info[] = {
 	},
 #endif
 
-#if defined(CONFIG_SND_BF5XX_SOC_ADAV80X) || defined(CONFIG_SND_BF5XX_SOC_ADAV80X_MODULE)
+#if defined(CONFIG_SND_SOC_ADAV80X) || defined(CONFIG_SND_SOC_ADAV80X_MODULE)
 	{
 		I2C_BOARD_INFO("adav803", 0x10),
 	},
@@ -2553,6 +2553,14 @@ static struct platform_device bfin_ad73311_codec_device = {
 };
 #endif
 
+#if defined(CONFIG_SND_SOC_BFIN_EVAL_ADAV80X) || \
+	defined(CONFIG_SND_SOC_BFIN_EVAL_ADAV80X_MODULE)
+static struct platform_device bfin_eval_adav801_device = {
+	.name = "bfin-eval-adav801",
+	.id = -1,
+};
+#endif
+
 #if defined(CONFIG_SND_BF5XX_SOC_I2S) || defined(CONFIG_SND_BF5XX_SOC_I2S_MODULE)
 static struct platform_device bfin_i2s = {
 	.name = "bfin-i2s",
@@ -2833,6 +2841,11 @@ static struct platform_device *stamp_devices[] __initdata = {
 	defined(CONFIG_SND_SOC_BFIN_EVAL_ADAU1701_MODULE)
 	&bf5xx_adau1701_device,
 #endif
+
+#if defined(CONFIG_SND_SOC_BFIN_EVAL_ADAV80X) || \
+	defined(CONFIG_SND_SOC_BFIN_EVAL_ADAV80X_MODULE)
+	&bfin_eval_adav801_device,
+#endif
 };
 
 static int __init net2272_init(void)
-- 
1.7.2.5

