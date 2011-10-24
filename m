Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636Ab1JXNYO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 09:24:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44593 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932369Ab1JXNYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 09:24:13 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] gpiolib: Ensure struct gpio is always defined
Date: Mon, 24 Oct 2011 15:24:10 +0200
Message-Id: <1319462650-23696-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently struct gpio is only defined when using gpiolib which makes the
stub gpio_request_array() much less useful in drivers than is ideal as
they can't work with struct gpio.  Since there are no other definitions
in kernel instead make the define always available no matter if gpiolib
is selectable or selected, ensuring that drivers can always use the
type.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

flob
---
 include/asm-generic/gpio.h |   12 ------------
 include/linux/gpio.h       |   22 ++++++++++++----------
 2 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index d494001..d0b6423 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -170,18 +170,6 @@ extern int __gpio_cansleep(unsigned gpio);
 
 extern int __gpio_to_irq(unsigned gpio);
 
-/**
- * struct gpio - a structure describing a GPIO with configuration
- * @gpio:	the GPIO number
- * @flags:	GPIO configuration as specified by GPIOF_*
- * @label:	a literal description string of this GPIO
- */
-struct gpio {
-	unsigned	gpio;
-	unsigned long	flags;
-	const char	*label;
-};
-
 extern int gpio_request_one(unsigned gpio, unsigned long flags, const char *label);
 extern int gpio_request_array(const struct gpio *array, size_t num);
 extern void gpio_free_array(const struct gpio *array, size_t num);
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index 17b5a0d..38ac48b 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -14,6 +14,18 @@
 #define GPIOF_OUT_INIT_LOW	(GPIOF_DIR_OUT | GPIOF_INIT_LOW)
 #define GPIOF_OUT_INIT_HIGH	(GPIOF_DIR_OUT | GPIOF_INIT_HIGH)
 
+/**
+ * struct gpio - a structure describing a GPIO with configuration
+ * @gpio:	the GPIO number
+ * @flags:	GPIO configuration as specified by GPIOF_*
+ * @label:	a literal description string of this GPIO
+ */
+struct gpio {
+	unsigned	gpio;
+	unsigned long	flags;
+	const char	*label;
+};
+
 #ifdef CONFIG_GENERIC_GPIO
 #include <asm/gpio.h>
 
@@ -24,18 +36,8 @@
 #include <linux/errno.h>
 
 struct device;
-struct gpio;
 struct gpio_chip;
 
-/*
- * Some platforms don't support the GPIO programming interface.
- *
- * In case some driver uses it anyway (it should normally have
- * depended on GENERIC_GPIO), these routines help the compiler
- * optimize out much GPIO-related code ... or trigger a runtime
- * warning when something is wrongly called.
- */
-
 static inline bool gpio_is_valid(int number)
 {
 	return false;
-- 
1.7.6.3

