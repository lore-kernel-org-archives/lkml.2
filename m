Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab2HGKAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 06:00:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49629 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973Ab2HGKAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 06:00:34 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, s.hauer@pengutronix.de, patches@linaro.org
Subject: [PATCH] ARM: SAMSUNG: Fix compilation error with s3c2410_defconfig
Date: Tue,  7 Aug 2012 15:29:06 +0530
Message-Id: <1344333546-16995-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 2663e766c56a "ARM Samsung: Move s3c pwm driver to pwm framework"
moved Samsung PWM driver to drivers/pwm and the config option to select
this driver has changed.

This patch fixes following build-error with s3c2410_defconfig.
arch/arm/mach-s3c24xx/mach-rx1950.c:430: undefined reference to `pwm_config'

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 arch/arm/mach-s3c24xx/Kconfig |    4 ++--
 arch/arm/plat-samsung/Kconfig |    3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-s3c24xx/Kconfig b/arch/arm/mach-s3c24xx/Kconfig
index e249611..d56b0f7 100644
--- a/arch/arm/mach-s3c24xx/Kconfig
+++ b/arch/arm/mach-s3c24xx/Kconfig
@@ -483,7 +483,7 @@ config MACH_NEO1973_GTA02
 	select I2C
 	select POWER_SUPPLY
 	select MACH_NEO1973
-	select S3C2410_PWM
+	select S3C24XX_PWM
 	select S3C_DEV_USB_HOST
 	help
 	   Say Y here if you are using the Openmoko GTA02 / Freerunner GSM Phone
@@ -493,7 +493,7 @@ config MACH_RX1950
 	select S3C24XX_DCLK
 	select PM_H1940 if PM
 	select I2C
-	select S3C2410_PWM
+	select S3C24XX_PWM
 	select S3C_DEV_NAND
 	select S3C2410_IOTIMING if S3C2440_CPUFREQ
 	select S3C2440_XTAL_16934400
diff --git a/arch/arm/plat-samsung/Kconfig b/arch/arm/plat-samsung/Kconfig
index 7aca31c..9c3b90c 100644
--- a/arch/arm/plat-samsung/Kconfig
+++ b/arch/arm/plat-samsung/Kconfig
@@ -403,7 +403,8 @@ config S5P_DEV_USB_EHCI
 
 config S3C24XX_PWM
 	bool "PWM device support"
-	select HAVE_PWM
+	select PWM
+	select PWM_SAMSUNG
 	help
 	  Support for exporting the PWM timer blocks via the pwm device
 	  system
-- 
1.7.4.1

