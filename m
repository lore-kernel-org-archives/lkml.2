Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965478Ab2CBW5v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 17:57:51 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55145 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965043Ab2CBW5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 17:57:50 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of glikely@secretlab.ca designates 10.68.129.137 as permitted sender) smtp.mail=glikely@secretlab.ca
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] gpio: constify the data parameter to gpiochip_find()
Date: Fri,  2 Mar 2012 15:57:46 -0700
Message-Id: <1330729066-26938-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/gpio/gpiolib.c     |    5 +++--
 drivers/of/gpio.c          |    2 +-
 include/asm-generic/gpio.h |    4 ++--
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index d773540..e633a2a 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1152,8 +1152,9 @@ EXPORT_SYMBOL_GPL(gpiochip_remove);
  * non-zero, this function will return to the caller and not iterate over any
  * more gpio_chips.
  */
-struct gpio_chip *gpiochip_find(void *data,
-				int (*match)(struct gpio_chip *chip, void *data))
+struct gpio_chip *gpiochip_find(const void *data,
+				int (*match)(struct gpio_chip *chip,
+					     const void *data))
 {
 	struct gpio_chip *chip = NULL;
 	unsigned long flags;
diff --git a/drivers/of/gpio.c b/drivers/of/gpio.c
index e034b38..bba8121 100644
--- a/drivers/of/gpio.c
+++ b/drivers/of/gpio.c
@@ -229,7 +229,7 @@ void of_gpiochip_remove(struct gpio_chip *chip)
 }
 
 /* Private function for resolving node pointer to gpio_chip */
-static int of_gpiochip_is_match(struct gpio_chip *chip, void *data)
+static int of_gpiochip_is_match(struct gpio_chip *chip, const void *data)
 {
 	return chip->of_node == data;
 }
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 1ff4e22..5f52690 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -142,9 +142,9 @@ extern int __must_check gpiochip_reserve(int start, int ngpio);
 /* add/remove chips */
 extern int gpiochip_add(struct gpio_chip *chip);
 extern int __must_check gpiochip_remove(struct gpio_chip *chip);
-extern struct gpio_chip *gpiochip_find(void *data,
+extern struct gpio_chip *gpiochip_find(const void *data,
 					int (*match)(struct gpio_chip *chip,
-						     void *data));
+						     const void *data));
 
 
 /* Always use the library code for GPIO management calls,
-- 
1.7.9

