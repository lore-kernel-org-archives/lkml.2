Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab2ITMVq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 08:21:46 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49890 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637Ab2ITMNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 08:13:05 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olof.johansson@gmail.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 02/32] ARM: ux500: Clean-up temporary Device Tree enablement helpers
Date: Thu, 20 Sep 2012 14:12:20 +0200
Message-Id: <1348143170-2130-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348143170-2130-1-git-send-email-lee.jones@linaro.org>
References: <1348143170-2130-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we remove some of the extra overhead we introduced to make
DT:ing the Snowball platform easier.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/cpu-db8500.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index db3c52d..38b7f9c 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -138,10 +138,6 @@ static struct platform_device *platform_devs[] __initdata = {
 	&db8500_prcmu_device,
 };
 
-static struct platform_device *of_platform_devs[] __initdata = {
-	&u8500_dma40_device,
-};
-
 static resource_size_t __initdata db8500_gpio_base[] = {
 	U8500_GPIOBANK0_BASE,
 	U8500_GPIOBANK1_BASE,
@@ -235,7 +231,6 @@ struct device * __init u8500_init_devices(struct ab8500_platform_data *ab8500)
 struct device * __init u8500_of_init_devices(void)
 {
 	struct device *parent;
-	int i;
 
 	parent = db8500_soc_device_init();
 
@@ -244,8 +239,7 @@ struct device * __init u8500_of_init_devices(void)
 	platform_device_register_data(parent,
 		"cpufreq-u8500", -1, NULL, 0);
 
-	for (i = 0; i < ARRAY_SIZE(of_platform_devs); i++)
-		of_platform_devs[i]->dev.parent = parent;
+	u8500_dma40_device.dev.parent = parent;
 
 	/*
 	 * Devices to be DT:ed:
@@ -253,7 +247,7 @@ struct device * __init u8500_of_init_devices(void)
 	 *   db8500_pmu_device   = done
 	 *   db8500_prcmu_device = done
 	 */
-	platform_add_devices(of_platform_devs, ARRAY_SIZE(of_platform_devs));
+	platform_device_register(&u8500_dma40_device);
 
 	return parent;
 }
-- 
1.7.9.5

