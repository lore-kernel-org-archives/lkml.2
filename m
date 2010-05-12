Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab0ELBig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 21:38:36 -0400
Received: from smtp-out-074.synserver.de ([212.40.180.74]:1040 "HELO
	smtp-out-072.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1752201Ab0ELBif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 21:38:35 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 May 2010 21:38:34 EDT
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 7659
From: Lars-Peter Clausen <lars@metafoo.de>
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
       Ben Dooks <ben-linux@fluff.org>
Subject: [PATCH 1/3] gta02: Remove usage of pcf50633 gpio api
Date: Wed, 12 May 2010 03:31:14 +0200
Message-Id: <1273627876-26922-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1273627876-26922-1-git-send-email-lars@metafoo.de>
References: <1273627876-26922-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the only user of the pcf50633 gpio api. Since the custom interface is
going to be replaced with gpiolib all users need to be removed or replaced.
It is safe to remove it in this case since it is used to turn a gpio off for
which there is no matching enable function call.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ben Dooks <ben-linux@fluff.org>

---
 arch/arm/mach-s3c2440/Kconfig      |    1 -
 arch/arm/mach-s3c2440/mach-gta02.c |   12 ++----------
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-s3c2440/Kconfig b/arch/arm/mach-s3c2440/Kconfig
index 9d102b9..16e7066 100644
--- a/arch/arm/mach-s3c2440/Kconfig
+++ b/arch/arm/mach-s3c2440/Kconfig
@@ -95,7 +95,6 @@ config MACH_NEO1973_GTA02
 	bool "Openmoko GTA02 / Freerunner phone"
 	select CPU_S3C2442
 	select MFD_PCF50633
-	select PCF50633_GPIO
 	select I2C
 	select POWER_SUPPLY
 	select MACH_NEO1973
diff --git a/arch/arm/mach-s3c2440/mach-gta02.c b/arch/arm/mach-s3c2440/mach-gta02.c
index 120a26f..1c7d36d 100644
--- a/arch/arm/mach-s3c2440/mach-gta02.c
+++ b/arch/arm/mach-s3c2440/mach-gta02.c
@@ -54,7 +54,6 @@
 #include <linux/mfd/pcf50633/core.h>
 #include <linux/mfd/pcf50633/mbc.h>
 #include <linux/mfd/pcf50633/adc.h>
-#include <linux/mfd/pcf50633/gpio.h>
 #include <linux/mfd/pcf50633/pmic.h>
 #include <linux/mfd/pcf50633/backlight.h>
 
@@ -167,16 +166,9 @@ gta02_configure_pmu_for_charger(struct pcf50633 *pcf, void *unused, int res)
 	int  ma;
 
 	/* Interpret charger type */
-	if (res < ((ADC_NOM_CHG_DETECT_USB + ADC_NOM_CHG_DETECT_1A) / 2)) {
-
-		/*
-		 * Sanity - stop GPO driving out now that we have a 1A charger
-		 * GPO controls USB Host power generation on GTA02
-		 */
-		pcf50633_gpio_set(pcf, PCF50633_GPO, 0);
-
+	if (res < ((ADC_NOM_CHG_DETECT_USB + ADC_NOM_CHG_DETECT_1A) / 2))
 		ma = 1000;
-	} else
+	else
 		ma = 100;
 
 	pcf50633_mbc_usb_curlim_set(pcf, ma);
-- 
1.5.6.5

