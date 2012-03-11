Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab2CKMmb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 08:42:31 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:54759 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab2CKMl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 08:41:57 -0400
X-AuditID: cbfee61b-b7c62ae000000989-80-4f5c9d94e9a2
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linus.walleij@linaro.org, kgene.kim@samsung.com, patches@linaro.org
Subject: [PATCH 4/5] ARM: Exynos: Enable pinctrl driver support for Origen board
Date: Sun, 11 Mar 2012 18:16:04 +0530
Message-id: <1331469965-28846-5-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
In-reply-to: <1331469965-28846-1-git-send-email-thomas.abraham@linaro.org>
References: <1331469965-28846-1-git-send-email-thomas.abraham@linaro.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the pinctrl platform devices for static registration and add
default pin maps.

Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
---
 arch/arm/mach-exynos/mach-origen.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-exynos/mach-origen.c b/arch/arm/mach-exynos/mach-origen.c
index 02c242e..4e39a9b 100644
--- a/arch/arm/mach-exynos/mach-origen.c
+++ b/arch/arm/mach-exynos/mach-origen.c
@@ -21,6 +21,8 @@
 #include <linux/mfd/max8997.h>
 #include <linux/lcd.h>
 #include <linux/rfkill-gpio.h>
+#include <linux/pinctrl/consumer.h>
+#include <linux/pinctrl/machine.h>
 
 #include <asm/mach/arch.h>
 #include <asm/hardware/gic.h>
@@ -41,6 +43,7 @@
 #include <plat/pd.h>
 #include <plat/fb.h>
 #include <plat/mfc.h>
+#include <plat/pinctrl.h>
 
 #include <mach/ohci.h>
 #include <mach/map.h>
@@ -622,6 +625,9 @@ static struct platform_device origen_device_bluetooth = {
 };
 
 static struct platform_device *origen_devices[] __initdata = {
+	&exynos4_pinctrl0,
+	&exynos4_pinctrl1,
+	&exynos4_pinctrl2,
 	&s3c_device_hsmmc2,
 	&s3c_device_hsmmc0,
 	&s3c_device_i2c0,
@@ -697,6 +703,7 @@ static void __init origen_reserve(void)
 
 static void __init origen_machine_init(void)
 {
+	exynos4210_pinctrl_register_def_mappings();
 	origen_power_init();
 
 	s3c_i2c0_set_platdata(NULL);
-- 
1.6.6.rc2

