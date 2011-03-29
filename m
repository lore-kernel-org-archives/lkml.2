Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab1C2WYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 18:24:43 -0400
Received: from mail.perches.com ([173.55.12.10]:4375 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754893Ab1C2WWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 18:22:33 -0400
From: Joe Perches <joe@perches.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 14/23] intel_pmic_gpio: Convert printks to pr_<level>
Date: Tue, 29 Mar 2011 15:21:45 -0700
Message-Id: <204a05bd3958bead074a97b78edca73c58ddae45.1301436234.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.2.g597a6.dirty
In-Reply-To: <cover.1301436234.git.joe@perches.com>
References: <cover.1301436234.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add #define pr_fmt(fmt) "%s: " fmt, __func__
to prefix function name to each output message.
Convert printks to pr_<level>.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/platform/x86/intel_pmic_gpio.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/platform/x86/intel_pmic_gpio.c b/drivers/platform/x86/intel_pmic_gpio.c
index 61433d4..40b5283 100644
--- a/drivers/platform/x86/intel_pmic_gpio.c
+++ b/drivers/platform/x86/intel_pmic_gpio.c
@@ -19,6 +19,8 @@
  * Moorestown platform PMIC chip
  */
 
+#define pr_fmt(fmt) "%s: " fmt, __func__
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
@@ -77,8 +79,7 @@ struct pmic_gpio {
 static int pmic_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
 {
 	if (offset > 8) {
-		printk(KERN_ERR
-			"%s: only pin 0-7 support input\n", __func__);
+		pr_err("only pin 0-7 support input\n");
 		return -1;/* we only have 8 GPIO can use as input */
 	}
 	return intel_scu_ipc_update_register(GPIO0 + offset,
@@ -103,8 +104,7 @@ static int pmic_gpio_direction_output(struct gpio_chip *chip,
 				value ? 1 << (offset - 16) : 0,
 				1 << (offset - 16));
 	else {
-		printk(KERN_ERR
-			"%s: invalid PMIC GPIO pin %d!\n", __func__, offset);
+		pr_err("invalid PMIC GPIO pin %d!\n", offset);
 		WARN_ON(1);
 	}
 
@@ -225,7 +225,7 @@ static int __devinit platform_pmic_gpio_probe(struct platform_device *pdev)
 	/* setting up SRAM mapping for GPIOINT register */
 	pg->gpiointr = ioremap_nocache(pdata->gpiointr, 8);
 	if (!pg->gpiointr) {
-		printk(KERN_ERR "%s: Can not map GPIOINT.\n", __func__);
+		pr_err("Can not map GPIOINT\n");
 		retval = -EINVAL;
 		goto err2;
 	}
@@ -246,13 +246,13 @@ static int __devinit platform_pmic_gpio_probe(struct platform_device *pdev)
 	pg->chip.dev = dev;
 	retval = gpiochip_add(&pg->chip);
 	if (retval) {
-		printk(KERN_ERR "%s: Can not add pmic gpio chip.\n", __func__);
+		pr_err("Can not add pmic gpio chip\n");
 		goto err;
 	}
 
 	retval = request_irq(pg->irq, pmic_irq_handler, 0, "pmic", pg);
 	if (retval) {
-		printk(KERN_WARNING "pmic: Interrupt request failed\n");
+		pr_warn("Interrupt request failed\n");
 		goto err;
 	}
 
-- 
1.7.4.2.g597a6.dirty

