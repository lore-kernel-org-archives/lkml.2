Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab2JPIZn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 04:25:43 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:60320 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab2JPIZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 04:25:40 -0400
X-AuditID: cbfee61a-b7f976d000001eb9-a2-507d1a02d7eb
From: Jingoo Han <jg1.han@samsung.com>
To: "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Linus Walleij'" <linus.walleij@linaro.org>
Cc: "'Kukjin Kim'" <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, "'Ryan Mallon'" <rmallon@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH V2 RESEND] gpio: samsung: use pr_* instead of printk
Date: Tue, 16 Oct 2012 17:25:38 +0900
Message-id: <008901cdab77$d2538800$76fa9800$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2rd9Ig09RtgTocSM2ekGzwM/mnqQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJLMWRmVeSWpSXmKPExsVy+t9jAV0mqdoAg1+P+C0u75rDZjHj/D4m
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDLmzJrKWvBcpGLr+1b2BsZ2wS5GDg4JAROJ7Yv4uhg5
	gUwxiQv31rN1MXJxCAksYpS4t/wblPOLUWLrihXMIFVsAmoSX74cZgexRQRiJG5PuMQCUsQs
	sIVRomtSJwtIQljAReLZhx5WEJtFQFXi6Jq7TCDbeAVsJWa8NQMJ8woISvyYfA+snFlAS2L9
	zuNMELa8xOY1b5khjlOXePRXF2KVnsS5KRegSkQk9r14xziBUWAWkkmzkEyahWTSLCQtCxhZ
	VjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEB+gzqR2MKxssDjEKcDAq8fBmONcECLEmlhVX
	5h5ilOBgVhLh9ZgIFOJNSaysSi3Kjy8qzUktPsQozcGiJM7b7JESICSQnliSmp2aWpBaBJNl
	4uCUamDMEl3wIEA8cp3fMj57OS4dV6+Tem3XzG0fqoiX3JGb3LNcwixm19ybp5gsjmxYuWXy
	kZzl4b8vrrE8MrPiboWz1LLmfzvEJt4uv8K37d0+9fCany3KiRvqtT0NN0fnsVnETvoWyr3w
	VWT2ncQJbLJhH51+fQx0uWG6/cfv+KK2X9fyL30XUkpTYinOSDTUYi4qTgQA9Ep2nkwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses pr_* instead of printk. Also, gpio_dbg
is replaced with pr_debug.

Signed-off-by: Ryan Mallon <rmallon@gmail.com>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
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


