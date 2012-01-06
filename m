Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682Ab2AFL4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 06:56:40 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62863 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758648Ab2AFL4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 06:56:39 -0500
Message-ID: <1325850987.2773.2.camel@phoenix>
Subject: [RFC][PATCH] ARM: NUC900: Rename nuc900-audio platform device to
 nuc900-ac97
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Wan ZongShun <mcuos.com@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org
Date: Fri, 06 Jan 2012 19:56:27 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change ensures the platform device name matches nuc900-ac97 platform
driver name.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
Hi ZongShun,
I don't have this hardware, I'd appreciate if you can test this patch.
This patch is against linux-next 20120103.
Thanks,
Axel
 arch/arm/mach-w90x900/clksel.c |    2 +-
 arch/arm/mach-w90x900/cpu.c    |    2 +-
 arch/arm/mach-w90x900/dev.c    |    6 +++---
 arch/arm/mach-w90x900/mfp.c    |    2 +-
 sound/soc/nuc900/nuc900-ac97.c |    2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-w90x900/clksel.c b/arch/arm/mach-w90x900/clksel.c
index 3de4a52..06d867dc 100644
--- a/arch/arm/mach-w90x900/clksel.c
+++ b/arch/arm/mach-w90x900/clksel.c
@@ -48,7 +48,7 @@ static void clock_source_select(const char *dev_id, unsigned int clkval)
 		offset = ATAOFFSET;
 	else if (strcmp(dev_id, "nuc900-lcd") == 0)
 		offset = LCDOFFSET;
-	else if (strcmp(dev_id, "nuc900-audio") == 0)
+	else if (strcmp(dev_id, "nuc900-ac97") == 0)
 		offset = AUDOFFSET;
 	else
 		offset = CPUOFFSET;
diff --git a/arch/arm/mach-w90x900/cpu.c b/arch/arm/mach-w90x900/cpu.c
index 604e1db..9a06619 100644
--- a/arch/arm/mach-w90x900/cpu.c
+++ b/arch/arm/mach-w90x900/cpu.c
@@ -79,7 +79,7 @@ static DEFINE_CLK(timer4, 23);
 
 static struct clk_lookup nuc900_clkregs[] = {
 	DEF_CLKLOOK(&clk_lcd, "nuc900-lcd", NULL),
-	DEF_CLKLOOK(&clk_audio, "nuc900-audio", NULL),
+	DEF_CLKLOOK(&clk_audio, "nuc900-ac97", NULL),
 	DEF_CLKLOOK(&clk_fmi, "nuc900-fmi", NULL),
 	DEF_CLKLOOK(&clk_ms, "nuc900-fmi", "MS"),
 	DEF_CLKLOOK(&clk_sd, "nuc900-fmi", "SD"),
diff --git a/arch/arm/mach-w90x900/dev.c b/arch/arm/mach-w90x900/dev.c
index 5b0c38a..78110be 100644
--- a/arch/arm/mach-w90x900/dev.c
+++ b/arch/arm/mach-w90x900/dev.c
@@ -501,8 +501,8 @@ static struct resource nuc900_ac97_resource[] = {
 
 };
 
-struct platform_device nuc900_device_audio = {
-	.name		= "nuc900-audio",
+struct platform_device nuc900_device_ac97 = {
+	.name		= "nuc900-ac97",
 	.id		= -1,
 	.num_resources	= ARRAY_SIZE(nuc900_ac97_resource),
 	.resource	= nuc900_ac97_resource,
@@ -523,7 +523,7 @@ static struct platform_device *nuc900_public_dev[] __initdata = {
 	&nuc900_device_emc,
 	&nuc900_device_spi,
 	&nuc900_device_wdt,
-	&nuc900_device_audio,
+	&nuc900_device_ac97,
 };
 
 /* Provide adding specific CPU platform devices API */
diff --git a/arch/arm/mach-w90x900/mfp.c b/arch/arm/mach-w90x900/mfp.c
index 9dd7461..c58d142 100644
--- a/arch/arm/mach-w90x900/mfp.c
+++ b/arch/arm/mach-w90x900/mfp.c
@@ -155,7 +155,7 @@ void mfp_set_groupg(struct device *dev, const char *subname)
 	} else if (strcmp(dev_id, "nuc900-i2c1") == 0) {
 		mfpen &= ~(GPIOG2TO3);
 		mfpen |= ENI2C1;/*enable i2c1*/
-	} else if (strcmp(dev_id, "nuc900-audio") == 0) {
+	} else if (strcmp(dev_id, "nuc900-ac97") == 0) {
 		mfpen &= ~(GPIOG22TO23);
 		mfpen |= ENAC97;/*enable AC97*/
 	} else if (strcmp(dev_id, "nuc900-mmc-port1") == 0) {
diff --git a/sound/soc/nuc900/nuc900-ac97.c b/sound/soc/nuc900/nuc900-ac97.c
index 45d11dd..946020a 100644
--- a/sound/soc/nuc900/nuc900-ac97.c
+++ b/sound/soc/nuc900/nuc900-ac97.c
@@ -366,7 +366,7 @@ static int __devinit nuc900_ac97_drvprobe(struct platform_device *pdev)
 		goto out3;
 
 	/* enbale ac97 multifunction pin */
-	mfp_set_groupg(nuc900_audio->dev, "nuc900-audio");
+	mfp_set_groupg(nuc900_audio->dev, NULL);
 
 	return 0;
 
-- 
1.7.5.4



