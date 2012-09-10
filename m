Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539Ab2IJL7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 07:59:20 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:45298 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab2IJL7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 07:59:19 -0400
X-AuditID: cbfee61a-b7fba6d000007d5f-6a-504dd6106f45
From: Jingoo Han <jg1.han@samsung.com>
To: "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Linus Walleij'" <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] gpio: samsung: use pr_* instead of printk
Date: Mon, 10 Sep 2012 20:59:11 +0900
Message-id: <002f01cd8f4b$b1100a30$13301e90$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2PS7D9uTpuD7DZR028eY/Axy3aBg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsVy+t9jAV2Ba74BBlM/sVtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MXZc5Cto5K56fPc7ewLiZvYuRk0NCwETiwua5zBC2mMSFe+vZ
	uhi5OIQEFjFKrDnUygrhzGaSmHbuNCtIFZuAmsSXL4fBukUEYiRuT7jE0sXIwcEs4CJxdJoI
	SFhYwEpixqRFYCUsAqoSq27fBGvlFbCVmHr+PxOELSjxY/I9FhCbWUBLYv3O40wQtrzE5jVv
	mUFGSgioSzz6qwuxSU9i4+VjUOUiEvtevGOcwCgwC8mkWUgmzUIyaRaSlgWMLKsYRVMLkguK
	k9JzDfWKE3OLS/PS9ZLzczcxgoPymdQOxpUNFocYBTgYlXh4H5r5BgixJpYVV+YeYpTgYFYS
	4f2zFyjEm5JYWZValB9fVJqTWnyIUZqDRUmc1+mcXYCQQHpiSWp2ampBahFMlomDU6qBUcFr
	0v8vChZ/HNgz7j/Y4iZ/e4rPMm3OXe9YfxbaiNpNV5jNaNm85rFQs0vkg/bvjS4FnOeP2Dw7
	xD1xyj3GLzsfPZOP5iu/UGJp6yy7V/7vUUPPLa4Pd3hNmZxbum9O2nPuOLOYuY+Y5fl25IjO
	uHFoL9+37Sq3zxvtlgibcOyJkvRBZYkbM5VYijMSDbWYi4oTAS/ycN9GAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses pr_* instead of printk.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/gpio/gpio-samsung.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
index ba126cc..e38d990 100644
--- a/drivers/gpio/gpio-samsung.c
+++ b/drivers/gpio/gpio-samsung.c
@@ -45,7 +45,7 @@
 #ifndef DEBUG_GPIO
 #define gpio_dbg(x...) do { } while (0)
 #else
-#define gpio_dbg(x...) printk(KERN_DEBUG x)
+#define gpio_dbg(x...) pr_debug(x)
 #endif
 
 int samsung_gpio_setpull_updown(struct samsung_gpio_chip *chip,
@@ -926,10 +926,10 @@ static void __init samsung_gpiolib_add(struct samsung_gpio_chip *chip)
 #ifdef CONFIG_PM
 	if (chip->pm != NULL) {
 		if (!chip->pm->save || !chip->pm->resume)
-			printk(KERN_ERR "gpio: %s has missing PM functions\n",
+			pr_err("gpio: %s has missing PM functions\n",
 			       gc->label);
 	} else
-		printk(KERN_ERR "gpio: %s has no PM function\n", gc->label);
+		pr_err("gpio: %s has no PM function\n", gc->label);
 #endif
 
 	/* gpiochip_add() prints own failure message on error. */
-- 
1.7.1


