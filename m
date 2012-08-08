Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197Ab2HHMzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 08:55:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64708 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189Ab2HHMzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 08:55:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4/6] ARM: s3c24xx: use new PWM driver
Date: Wed,  8 Aug 2012 14:54:51 +0200
Message-Id: <1344430493-5304-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1344430493-5304-1-git-send-email-arnd@arndb.de>
References: <1344430493-5304-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:POko7GIRep7E2oYi05Tlpyq7QEAQ1SVA6agmasVvt6i
 C4fmIIcAIq+OONOQgOk4lOlMRrpIABAAiGtZfGKh0Dq712On01
 +5a9X6ufNvOXyvOBjECyWKULYxeUPKEkJMPlJar4PQPgJ2NJQv
 KKcqUiMD9k8Gl+uSg2mjt6kIK4lEHqnuREkdqWR7g7ed5aZrW2
 1zzhmWMrdDAbhE3CZWyFg3dUNitmNw65Yy44knS2hkenA1oEKc
 hi8ZW31TjhEUccJuBNnVEpw59n1zPZN9ei/c/Cr1KPIpuK1vEp
 3vlEaewZvP25/nJ3oC1M3nz70PaRyraqIqeu701jvnA1J1R0Kg
 i4J6FRytptMi4R4r5MjkigZVPKqnywy3MC8UWltV8S1xVuEE2f
 V3UeE/gVLlYzw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The samsung PWM driver has moved to the new PWM subsystem, which
changed the Kconfig symbol for that driver, but the rx1950 and
gta02 boards still uses the old one.

Without this patch, building s3c2410_defconfig results in:

arch/arm/mach-s3c24xx/built-in.o: In function `rx1950_lcd_power':
arch/arm/mach-s3c24xx/mach-rx1950.c:430: undefined reference to `pwm_config'
arch/arm/mach-s3c24xx/mach-rx1950.c:431: undefined reference to `pwm_disable'
arch/arm/mach-s3c24xx/mach-rx1950.c:437: undefined reference to `pwm_config'
arch/arm/mach-s3c24xx/mach-rx1950.c:438: undefined reference to `pwm_enable'
arch/arm/mach-s3c24xx/built-in.o: In function `rx1950_backlight_exit':
arch/arm/mach-s3c24xx/mach-rx1950.c:504: undefined reference to `pwm_free'
arch/arm/mach-s3c24xx/built-in.o: In function `rx1950_backlight_init':
arch/arm/mach-s3c24xx/mach-rx1950.c:487: undefined reference to `pwm_request'

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-s3c24xx/Kconfig |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-s3c24xx/Kconfig b/arch/arm/mach-s3c24xx/Kconfig
index e249611..422133a 100644
--- a/arch/arm/mach-s3c24xx/Kconfig
+++ b/arch/arm/mach-s3c24xx/Kconfig
@@ -483,7 +483,8 @@ config MACH_NEO1973_GTA02
 	select I2C
 	select POWER_SUPPLY
 	select MACH_NEO1973
-	select S3C2410_PWM
+	select PWM
+	select PWM_SAMSUNG
 	select S3C_DEV_USB_HOST
 	help
 	   Say Y here if you are using the Openmoko GTA02 / Freerunner GSM Phone
@@ -493,7 +494,8 @@ config MACH_RX1950
 	select S3C24XX_DCLK
 	select PM_H1940 if PM
 	select I2C
-	select S3C2410_PWM
+	select PWM
+	select PWM_SAMSUNG
 	select S3C_DEV_NAND
 	select S3C2410_IOTIMING if S3C2440_CPUFREQ
 	select S3C2440_XTAL_16934400
-- 
1.7.10

