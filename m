Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab1KJXVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 18:21:41 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:35337 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab1KJXVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 18:21:40 -0500
Subject: [PATCH] ARM: mach-s3c2440: drop selects of bogus Kconfig symbols
From: Paul Bolle <pebolle@tiscali.nl>
To: Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Nov 2011 00:21:25 +0100
Message-ID: <1320967285.27598.91.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no Kconfig symbols named MACH_NEO1973 and S3C2410_PWM. The
three select statements for these symbols are nops. Drop these.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested by running "make ARCH=arm menuconfig" for both machines (with
defaults from some x86 config file, as there are no defconfigs for these
machines). Nothing related to these Kconfig symbols showed up in the
generated config files. From that it follows that dropping these select
statements changes nothing.

 arch/arm/mach-s3c2440/Kconfig |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-s3c2440/Kconfig b/arch/arm/mach-s3c2440/Kconfig
index e505701..70a12b3 100644
--- a/arch/arm/mach-s3c2440/Kconfig
+++ b/arch/arm/mach-s3c2440/Kconfig
@@ -93,8 +93,6 @@ config MACH_NEO1973_GTA02
 	select PCF50633_GPIO
 	select I2C
 	select POWER_SUPPLY
-	select MACH_NEO1973
-	select S3C2410_PWM
 	select S3C_DEV_USB_HOST
 	help
 	   Say Y here if you are using the Openmoko GTA02 / Freerunner GSM Phone
@@ -192,7 +190,6 @@ config MACH_RX1950
 	select S3C24XX_DCLK
 	select PM_H1940 if PM
 	select I2C
-	select S3C2410_PWM
 	select S3C_DEV_NAND
 	select S3C2410_IOTIMING if S3C2440_CPUFREQ
 	select S3C2440_XTAL_16934400
-- 
1.7.4.4



