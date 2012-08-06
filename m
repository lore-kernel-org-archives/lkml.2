Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab2HFN6I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 09:58:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64026 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867Ab2HFN6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 09:58:06 -0400
From: Dongjin Kim <tobetter@gmail.com>
Cc: Dongjin Kim <dongjin.kim@agreeyamobility.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: EXYNOS: Add gpio functions for Exynos4412
Date: Mon,  6 Aug 2012 22:57:38 +0900
Message-Id: <1344261462-14183-1-git-send-email-dongjin.kim@agreeyamobility.net>
X-Mailer: git-send-email 1.7.9.5
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GPIO functions are not registered for Exynos4412 yet,
therefore exynos4_gpiolib_init() is added to initialize Exynos4412 SoC.

Change-Id: I5945d94c6fbfc309ccf882eba067864a338c04ca
Signed-off-by: Dongjin Kim <dongjin.kim@agreeyamobility.net>
---
 drivers/gpio/gpio-samsung.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
index 92f7b2b..6b312a9 100644
--- a/drivers/gpio/gpio-samsung.c
+++ b/drivers/gpio/gpio-samsung.c
@@ -2727,7 +2727,7 @@ static __init void exynos_gpiolib_attach_ofnode(struct samsung_gpio_chip *chip,
 
 static __init void exynos4_gpiolib_init(void)
 {
-#ifdef CONFIG_CPU_EXYNOS4210
+#ifdef CONFIG_ARCH_EXYNOS4
 	struct samsung_gpio_chip *chip;
 	int i, nr_chips;
 	void __iomem *gpio_base1, *gpio_base2, *gpio_base3;
@@ -2816,7 +2816,7 @@ err_ioremap2:
 	iounmap(gpio_base1);
 err_ioremap1:
 	return;
-#endif	/* CONFIG_CPU_EXYNOS4210 */
+#endif	/* CONFIG_ARCH_EXYNOS4 */
 }
 
 static __init void exynos5_gpiolib_init(void)
@@ -3014,6 +3014,8 @@ static __init int samsung_gpiolib_init(void)
 		exynos4_gpiolib_init();
 	} else if (soc_is_exynos5250()) {
 		exynos5_gpiolib_init();
+	} else if (soc_is_exynos4212() || soc_is_exynos4412()) {
+		exynos4_gpiolib_init();
 	} else {
 		WARN(1, "Unknown SoC in gpio-samsung, no GPIOs added\n");
 		return -ENODEV;
-- 
1.7.9.5

