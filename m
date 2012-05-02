Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab2EBLrQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 07:47:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43179 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752226Ab2EBLrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 07:47:15 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] gpiolib: Add !CONFIG_GPIOLIB definitions of devm_ functions
Date: Wed,  2 May 2012 12:46:45 +0100
Message-Id: <1335959206-8138-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the managed gpio_request() and gpio_free() are not stubbed out
for configurations not using gpiolib - do that to aid use in drivers.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

I thought you'd applied this but it's not showing up in -next.

 include/linux/gpio.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index d1890d46..8e0fe1b 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -66,6 +66,12 @@ static inline int devm_gpio_request(struct device *dev, unsigned gpio,
 	return -ENOSYS;
 }
 
+static inline int devm_gpio_request(struct device *dev, unsigned gpio,
+				    const char *label)
+{
+	return -ENOSYS;
+}
+
 static inline int gpio_request_one(unsigned gpio,
 					unsigned long flags, const char *label)
 {
@@ -93,6 +99,14 @@ static inline void devm_gpio_free(struct device *dev, unsigned gpio)
 	WARN_ON(1);
 }
 
+static inline void devm_gpio_free(struct device *dev, unsigned gpio)
+{
+	might_sleep();
+
+	/* GPIO can never have been requested */
+	WARN_ON(1);
+}
+
 static inline void gpio_free_array(const struct gpio *array, size_t num)
 {
 	might_sleep();
-- 
1.7.10

