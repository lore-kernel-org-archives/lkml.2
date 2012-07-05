Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932919Ab2GENHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:07:49 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:48465 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513Ab2GENGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:06:47 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 6/9] ARM: ux500: Remove PMU platform registration when booting with DT
Date: Thu,  5 Jul 2012 14:06:09 +0100
Message-Id: <1341493572-29735-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341493572-29735-1-git-send-email-lee.jones@linaro.org>
References: <1341493572-29735-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PMU registration is successfully completed by Device Tree now, so
there is no longer a requirement to register it from platform code.
This patch removes platform registration during a DT boot.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/cpu-db8500.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index a12bd9e..c8dd94f 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -139,7 +139,6 @@ static struct platform_device *platform_devs[] __initdata = {
 
 static struct platform_device *of_platform_devs[] __initdata = {
 	&u8500_dma40_device,
-	&db8500_pmu_device,
 };
 
 static resource_size_t __initdata db8500_gpio_base[] = {
@@ -248,7 +247,7 @@ struct device * __init u8500_of_init_devices(void)
 	/*
 	 * Devices to be DT:ed:
 	 *   u8500_dma40_device  = todo
-	 *   db8500_pmu_device   = todo
+	 *   db8500_pmu_device   = done
 	 *   db8500_prcmu_device = done
 	 */
 	platform_add_devices(of_platform_devs, ARRAY_SIZE(of_platform_devs));
-- 
1.7.9.5

