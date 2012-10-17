Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab2JQBwe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 21:52:34 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:23132 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755952Ab2JQBwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 21:52:32 -0400
X-AuditID: cbfee61a-b7f976d000001eb9-26-507e0f5fa3e1
From: Jingoo Han <jg1.han@samsung.com>
To: "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Linus Walleij'" <linus.walleij@linaro.org>
Cc: "'Kukjin Kim'" <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, "'Ryan Mallon'" <rmallon@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH V3] gpio: samsung: use pr_* instead of printk
Date: Wed, 17 Oct 2012 10:52:31 +0900
Message-id: <002801cdac0a$11e4f340$35aed9c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2sChHMQwSjY9qSSRmfcoung56Ilw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJLMWRmVeSWpSXmKPExsVy+t9jAd14/roAg93flSwu75rDZjHj/D4m
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDJ6dl9gK/goUjH/dUwDY5dgFyMnh4SAicT8vp+MELaY
	xIV769m6GLk4hAQWMUq0XO1ihXB+MUrcOb2VGaSKTUBN4suXw+wgtohAjMTtCZdYQIqYBbYw
	SnRN6mQBSQgL2ErcO3aCqYuRg4NFQFXi5JowkDAvUHjDvvtsELagxI/J98DKmQW0JDZva2KF
	sOUlNq95ywzSKiGgLvHory7EKj2Ja5ffsEGUiEjse/GOcQKjwCwkk2YhmTQLyaRZSFoWMLKs
	YhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAgO0GdSOxhXNlgcYhTgYFTi4f0wuzZAiDWxrLgy
	9xCjBAezkgiveSNQiDclsbIqtSg/vqg0J7X4EKM0B4uSOG+zR0qAkEB6YklqdmpqQWoRTJaJ
	g1OqgbGGzf8Tm7Xp49cJZjWXJOa7HLr6U9SP5coL9Yj/is96JntFqPLMb/i1h1/Fc1lqZMNj
	VYYl3nNKZFn9FswqNbRnq7/72MF1d8DNw6/ep+ibJ/nsq5JN+bBex/LwV6kQO/bQpg06debm
	i453ZbtejubOzOeMvCwzTeBFOq+E+Rr28jaH5sjZSizFGYmGWsxFxYkAHfI/kEwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses pr_* instead of printk. Also, gpio_dbg
is replaced with pr_debug.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
---
Change since v2:
- remove Ryan Mallon's signed-off-by

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


