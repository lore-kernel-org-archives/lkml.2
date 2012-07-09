Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757Ab2GISuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 14:50:54 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36153 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab2GISux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 14:50:53 -0400
Message-ID: <4FFB2809.3020005@linaro.org>
Date: Mon, 09 Jul 2012 20:50:49 +0200
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: linus.walleij@stericsson.com, STEricsson_nomadik_linux@list.st.com,
        arnd@arndb.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 8/9] ARM: ux500: Clean-up temporary Device Tree enablement
 helpers
References: <1341493572-29735-1-git-send-email-lee.jones@linaro.org> <1341493572-29735-9-git-send-email-lee.jones@linaro.org> <4FF6A2DF.5030407@linaro.org> <CACRpkdZJAiBvatPGpKZP4mgUb-M-pPY34LVaj7ANkRaX9C4fJQ@mail.gmail.com>
In-Reply-To: <CACRpkdZJAiBvatPGpKZP4mgUb-M-pPY34LVaj7ANkRaX9C4fJQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Better?

>From 9ef8a52c00dedbd63b6eecc086f8bd688d2cb66a Mon Sep 17 00:00:00 2001
From: Lee Jones <lee.jones@linaro.org>
Date: Wed, 27 Jun 2012 08:42:08 +0100
Subject: [PATCH 1/1] ARM: ux500: Clean-up temporary Device Tree enablement
 helpers

Here we remove some of the extra overhead we introduced to make
DT:ing the Snowball platform easier.

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
