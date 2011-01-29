Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab1A2P0e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 10:26:34 -0500
Received: from smtp-out-140.synserver.de ([212.40.185.140]:1061 "HELO
	smtp-out-140.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752515Ab1A2P0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 10:26:33 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Jan 2011 10:26:32 EST
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 6485
From: Lars-Peter Clausen <lars@metafoo.de>
To: David Brownell <david-b@pacbell.net>
Cc: Eric Miao <eric.y.miao@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] gpio: Make gpio_{request,free}_array gpio array parameter const
Date: Sat, 29 Jan 2011 16:21:21 +0100
Message-Id: <1296314481-28028-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gpio_{request,free}_array should not (and do not) modify the passed gpio array,
so make the parameter const.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/gpio/gpiolib.c     |    4 ++--
 include/asm-generic/gpio.h |    4 ++--
 include/linux/gpio.h       |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 649550e..27016c4 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1293,7 +1293,7 @@ EXPORT_SYMBOL_GPL(gpio_request_one);
  * @array:	array of the 'struct gpio'
  * @num:	how many GPIOs in the array
  */
-int gpio_request_array(struct gpio *array, size_t num)
+int gpio_request_array(const struct gpio *array, size_t num)
 {
 	int i, err;
 
@@ -1316,7 +1316,7 @@ EXPORT_SYMBOL_GPL(gpio_request_array);
  * @array:	array of the 'struct gpio'
  * @num:	how many GPIOs in the array
  */
-void gpio_free_array(struct gpio *array, size_t num)
+void gpio_free_array(const struct gpio *array, size_t num)
 {
 	while (num--)
 		gpio_free((array++)->gpio);
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index ff5c660..05119e7 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -193,8 +193,8 @@ struct gpio {
 };
 
 extern int gpio_request_one(unsigned gpio, unsigned long flags, const char *label);
-extern int gpio_request_array(struct gpio *array, size_t num);
-extern void gpio_free_array(struct gpio *array, size_t num);
+extern int gpio_request_array(const struct gpio *array, size_t num);
+extern void gpio_free_array(const struct gpio *array, size_t num);
 
 #ifdef CONFIG_GPIO_SYSFS
 
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index 32720ba..b2b610f 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -41,7 +41,7 @@ static inline int gpio_request_one(unsigned gpio,
 	return -ENOSYS;
 }
 
-static inline int gpio_request_array(struct gpio *array, size_t num)
+static inline int gpio_request_array(const struct gpio *array, size_t num)
 {
 	return -ENOSYS;
 }
@@ -54,7 +54,7 @@ static inline void gpio_free(unsigned gpio)
 	WARN_ON(1);
 }
 
-static inline void gpio_free_array(struct gpio *array, size_t num)
+static inline void gpio_free_array(const struct gpio *array, size_t num)
 {
 	might_sleep();
 
-- 
1.7.2.3

