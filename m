Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621Ab2IKHWD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 03:22:03 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:8614 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab2IKHWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 03:22:01 -0400
X-AuditID: cbfee61b-b7f586d000007adc-10-504ee6971b25
From: Jingoo Han <jg1.han@samsung.com>
To: "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Linus Walleij'" <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, "'Ryan Mallon'" <rmallon@gmail.com>,
        "'Felipe Balbi'" <balbi@ti.com>, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH v2] gpio: samsung: use pr_* instead of printk
Date: Tue, 11 Sep 2012 16:21:58 +0900
Message-id: <002b01cd8fee$2195b460$64c11d20$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2P7iFFTiN7S2tyTde6A/7ZUCStqw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t9jAd3pz/wCDB6el7a4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZv+5uYizYIFLReuIlYwPjVYEuRk4OCQETia7Vs1khbDGJC/fW
	s3UxcnEICSxilPje8pIFwpnNJPF04zewKjYBNYkvXw6zg9giAjEStydcAitiFuhglLh4aDMz
	SEJYwFZi09teNhCbRUBVYsnKk2DNvEDxW+8XsUPYghI/Jt9jAbGZBbQk1u88zgRhy0tsXvMW
	aA4H0EnqEo/+6oKYIgJ6Es3bOCEqRCT2vXjHOIFRYBaSQbOQDJqFZNAsJC0LGFlWMYqmFiQX
	FCel5xrpFSfmFpfmpesl5+duYgQH5jPpHYyrGiwOMQpwMCrx8N6I9gsQYk0sK67MPcQowcGs
	JMLrNwsoxJuSWFmVWpQfX1Sak1p8iFGag0VJnNfpnF2AkEB6YklqdmpqQWoRTJaJg1OqgdH2
	ltvePWdWHpyeYs546cXOd/NTljLx8ArvjDihvLH56Zri2F3vTgRnb/Xv+yl8dueLUkW7nBsC
	/+wmWbHf//poW85KnknKZbonPcwYu290iR+vclkSeDgna+PnSU8YtzBsn3KA6daDewtdlCpr
	LveyKGhJnHndrnLNJeHAxHlRS1cvjTvL8CFLiaU4I9FQi7moOBEAjiiCuEgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses pr_* instead of printk. Also, gpio_dbg
is replaced with pr_debug.

Signed-off-by: Ryan Mallon <rmallon@gmail.com>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/gpio/gpio-samsung.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
index a006f0d..5c5ccdf 100644
--- a/drivers/gpio/gpio-samsung.c
+++ b/drivers/gpio/gpio-samsung.c
@@ -42,12 +42,6 @@
 #include <plat/gpio-fns.h>
 #include <plat/pm.h>
 
-#ifndef DEBUG_GPIO
-#define gpio_dbg(x...) do { } while (0)
-#else
-#define gpio_dbg(x...) printk(KERN_DEBUG x)
-#endif
-
 int samsung_gpio_setpull_updown(struct samsung_gpio_chip *chip,
 				unsigned int off, samsung_gpio_pull_t pull)
 {
@@ -599,7 +593,7 @@ static int samsung_gpiolib_4bit_input(struct gpio_chip *chip,
 	con &= ~(0xf << con_4bit_shift(offset));
 	__raw_writel(con, base + GPIOCON_OFF);
 
-	gpio_dbg("%s: %p: CON now %08lx\n", __func__, base, con);
+	pr_debug("%s: %p: CON now %08lx\n", __func__, base, con);
 
 	return 0;
 }
@@ -627,7 +621,7 @@ static int samsung_gpiolib_4bit_output(struct gpio_chip *chip,
 	__raw_writel(con, base + GPIOCON_OFF);
 	__raw_writel(dat, base + GPIODAT_OFF);
 
-	gpio_dbg("%s: %p: CON %08lx, DAT %08lx\n", __func__, base, con, dat);
+	pr_debug("%s: %p: CON %08lx, DAT %08lx\n", __func__, base, con, dat);
 
 	return 0;
 }
@@ -671,7 +665,7 @@ static int samsung_gpiolib_4bit2_input(struct gpio_chip *chip,
 	con &= ~(0xf << con_4bit_shift(offset));
 	__raw_writel(con, regcon);
 
-	gpio_dbg("%s: %p: CON %08lx\n", __func__, base, con);
+	pr_debug("%s: %p: CON %08lx\n", __func__, base, con);
 
 	return 0;
 }
@@ -706,7 +700,7 @@ static int samsung_gpiolib_4bit2_output(struct gpio_chip *chip,
 	__raw_writel(con, regcon);
 	__raw_writel(dat, base + GPIODAT_OFF);
 
-	gpio_dbg("%s: %p: CON %08lx, DAT %08lx\n", __func__, base, con, dat);
+	pr_debug("%s: %p: CON %08lx, DAT %08lx\n", __func__, base, con, dat);
 
 	return 0;
 }
@@ -926,10 +920,10 @@ static void __init samsung_gpiolib_add(struct samsung_gpio_chip *chip)
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


