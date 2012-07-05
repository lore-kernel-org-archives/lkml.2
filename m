Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932908Ab2GENHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:07:47 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:55658 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756477Ab2GENGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:06:48 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 8/9] ARM: ux500: Clean-up temporary Device Tree enablement helpers
Date: Thu,  5 Jul 2012 14:06:11 +0100
Message-Id: <1341493572-29735-9-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341493572-29735-1-git-send-email-lee.jones@linaro.org>
References: <1341493572-29735-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we remove some of the extra overhead we introduced to make
DT:ing the Snowball platform easier. Unfortunately we can't
remove everything. We are forced to leave cpufreq and DMA behind
until they have been successfully Device Tree enabled.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/cpu-db8500.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index c8dd94f..d7a28c0 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -137,10 +137,6 @@ static struct platform_device *platform_devs[] __initdata = {
 	&db8500_prcmu_device,
 };
 
-static struct platform_device *of_platform_devs[] __initdata = {
-	&u8500_dma40_device,
-};
-
 static resource_size_t __initdata db8500_gpio_base[] = {
 	U8500_GPIOBANK0_BASE,
 	U8500_GPIOBANK1_BASE,
@@ -232,7 +228,6 @@ struct device * __init u8500_init_devices(void)
 struct device * __init u8500_of_init_devices(void)
 {
 	struct device *parent;
-	int i;
 
 	parent = db8500_soc_device_init();
 
@@ -241,8 +236,7 @@ struct device * __init u8500_of_init_devices(void)
 	platform_device_register_data(parent,
 		"cpufreq-u8500", -1, NULL, 0);
 
-	for (i = 0; i < ARRAY_SIZE(of_platform_devs); i++)
-		of_platform_devs[i]->dev.parent = parent;
+	u8500_dma40_device.dev.parent = parent;
 
 	/*
 	 * Devices to be DT:ed:
@@ -250,7 +244,7 @@ struct device * __init u8500_of_init_devices(void)
 	 *   db8500_pmu_device   = done
 	 *   db8500_prcmu_device = done
 	 */
-	platform_add_devices(of_platform_devs, ARRAY_SIZE(of_platform_devs));
+	platform_device_register(&u8500_dma40_device);
 
 	return parent;
 }
-- 
1.7.9.5

