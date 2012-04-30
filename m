Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab2D3HCJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 03:02:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56098 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab2D3HCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 03:02:07 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        patches@linaro.org, sachin.kamat@linaro.org
Subject: [PATCH] gpio/exynos: Fix compiler warnings when non-exynos machines are selected
Date: Mon, 30 Apr 2012 12:22:48 +0530
Message-Id: <1335768768-10231-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following compiler warnings:

drivers/gpio/gpio-samsung.c: In function ‘samsung_gpiolib_init’:
drivers/gpio/gpio-samsung.c:2980:1: warning: label ‘err_ioremap1’ defined but not used [-Wunused-label]
drivers/gpio/gpio-samsung.c:2978:1: warning: label ‘err_ioremap2’ defined but not used [-Wunused-label]
drivers/gpio/gpio-samsung.c:2976:1: warning: label ‘err_ioremap3’ defined but not used [-Wunused-label]
drivers/gpio/gpio-samsung.c:2974:1: warning: label ‘err_ioremap4’ defined but not used [-Wunused-label]
drivers/gpio/gpio-samsung.c:2722:55: warning: unused variable ‘gpio_base4’ [-Wunused-variable]

drivers/gpio/gpio-samsung.c:455:32: warning: ‘exynos_gpio_cfg’ defined but not used [-Wunused-variable]
drivers/gpio/gpio-samsung.c:2126:33: warning: ‘exynos4_gpios_1’ defined but not used [-Wunused-variable]
drivers/gpio/gpio-samsung.c:2228:33: warning: ‘exynos4_gpios_2’ defined but not used [-Wunused-variable]
drivers/gpio/gpio-samsung.c:2373:33: warning: ‘exynos4_gpios_3’ defined but not used [-Wunused-variable]

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/gpio/gpio-samsung.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
index 19d6fc0..e991d91 100644
--- a/drivers/gpio/gpio-samsung.c
+++ b/drivers/gpio/gpio-samsung.c
@@ -452,12 +452,14 @@ static struct samsung_gpio_cfg s3c24xx_gpiocfg_banka = {
 };
 #endif
 
+#if defined(CONFIG_ARCH_EXYNOS4) || defined(CONFIG_ARCH_EXYNOS5)
 static struct samsung_gpio_cfg exynos_gpio_cfg = {
 	.set_pull	= exynos_gpio_setpull,
 	.get_pull	= exynos_gpio_getpull,
 	.set_config	= samsung_gpio_setcfg_4bit,
 	.get_config	= samsung_gpio_getcfg_4bit,
 };
+#endif
 
 #if defined(CONFIG_CPU_S5P6440) || defined(CONFIG_CPU_S5P6450)
 static struct samsung_gpio_cfg s5p64x0_gpio_cfg_rbank = {
@@ -2123,8 +2125,8 @@ static struct samsung_gpio_chip s5pv210_gpios_4bit[] = {
  * uses the above macro and depends on the banks being listed in order here.
  */
 
-static struct samsung_gpio_chip exynos4_gpios_1[] = {
 #ifdef CONFIG_ARCH_EXYNOS4
+static struct samsung_gpio_chip exynos4_gpios_1[] = {
 	{
 		.chip	= {
 			.base	= EXYNOS4_GPA0(0),
@@ -2222,11 +2224,11 @@ static struct samsung_gpio_chip exynos4_gpios_1[] = {
 			.label	= "GPF3",
 		},
 	},
-#endif
 };
+#endif
 
-static struct samsung_gpio_chip exynos4_gpios_2[] = {
 #ifdef CONFIG_ARCH_EXYNOS4
+static struct samsung_gpio_chip exynos4_gpios_2[] = {
 	{
 		.chip	= {
 			.base	= EXYNOS4_GPJ0(0),
@@ -2367,11 +2369,11 @@ static struct samsung_gpio_chip exynos4_gpios_2[] = {
 			.to_irq	= samsung_gpiolib_to_irq,
 		},
 	},
-#endif
 };
+#endif
 
-static struct samsung_gpio_chip exynos4_gpios_3[] = {
 #ifdef CONFIG_ARCH_EXYNOS4
+static struct samsung_gpio_chip exynos4_gpios_3[] = {
 	{
 		.chip	= {
 			.base	= EXYNOS4_GPZ(0),
@@ -2379,8 +2381,8 @@ static struct samsung_gpio_chip exynos4_gpios_3[] = {
 			.label	= "GPZ",
 		},
 	},
-#endif
 };
+#endif
 
 #ifdef CONFIG_ARCH_EXYNOS5
 static struct samsung_gpio_chip exynos5_gpios_1[] = {
@@ -2719,7 +2721,9 @@ static __init int samsung_gpiolib_init(void)
 {
 	struct samsung_gpio_chip *chip;
 	int i, nr_chips;
+#if defined(CONFIG_CPU_EXYNOS4210) || defined(CONFIG_SOC_EXYNOS5250)
 	void __iomem *gpio_base1, *gpio_base2, *gpio_base3, *gpio_base4;
+#endif
 	int group = 0;
 
 	samsung_gpiolib_set_cfg(samsung_gpio_cfgs, ARRAY_SIZE(samsung_gpio_cfgs));
@@ -2971,6 +2975,7 @@ static __init int samsung_gpiolib_init(void)
 
 	return 0;
 
+#if defined(CONFIG_CPU_EXYNOS4210) || defined(CONFIG_SOC_EXYNOS5250)
 err_ioremap4:
 	iounmap(gpio_base3);
 err_ioremap3:
@@ -2979,6 +2984,7 @@ err_ioremap2:
 	iounmap(gpio_base1);
 err_ioremap1:
 	return -ENOMEM;
+#endif
 }
 core_initcall(samsung_gpiolib_init);
 
-- 
1.7.4.1

