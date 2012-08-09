Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165Ab2HILbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 07:31:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44108 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071Ab2HILbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 07:31:50 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: thierry.reding@avionic-design.de, kgene.kim@samsung.com,
        jg1.han@samsung.com, patches@linaro.org
Subject: [PATCH v2] ARM: EXYNOS: Use generic pwm driver in Origen board
Date: Thu,  9 Aug 2012 16:59:53 +0530
Message-Id: <1344511793-25130-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
Changes in v2:
	- Remove creation of s3c24xx-pwm platform device as it is already
	created in samsung_bl_set().

 arch/arm/mach-exynos/mach-origen.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-exynos/mach-origen.c b/arch/arm/mach-exynos/mach-origen.c
index dcb96ef..c2dbb22 100644
--- a/arch/arm/mach-exynos/mach-origen.c
+++ b/arch/arm/mach-exynos/mach-origen.c
@@ -15,6 +15,7 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/input.h>
+#include <linux/pwm.h>
 #include <linux/pwm_backlight.h>
 #include <linux/gpio_keys.h>
 #include <linux/i2c.h>
@@ -614,6 +615,10 @@ static struct platform_device origen_lcd_hv070wsa = {
 	.dev.platform_data	= &origen_lcd_hv070wsa_data,
 };
 
+static struct pwm_lookup origen_pwm_lookup[] = {
+	PWM_LOOKUP("s3c24xx-pwm.0", 0, "pwm-backlight.0", NULL),
+};
+
 #ifdef CONFIG_DRM_EXYNOS
 static struct exynos_drm_fimd_pdata drm_fimd_pdata = {
 	.panel	= {
@@ -792,6 +797,7 @@ static void __init origen_machine_init(void)
 
 	platform_add_devices(origen_devices, ARRAY_SIZE(origen_devices));
 
+	pwm_add_table(origen_pwm_lookup, ARRAY_SIZE(origen_pwm_lookup));
 	samsung_bl_set(&origen_bl_gpio_info, &origen_bl_data);
 
 	origen_bt_setup();
-- 
1.7.4.1

