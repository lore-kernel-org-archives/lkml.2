Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab2DDPOz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 11:14:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41778 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756354Ab2DDPOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 11:14:53 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] gpiolib: Add !CONFIG_GPIOLIB definitions of devm_ functions
Date: Wed,  4 Apr 2012 16:14:48 +0100
Message-Id: <1333552489-27694-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the managed gpio_request() and gpio_free() are not stubbed out
for configurations not using gpiolib - do that to aid use in drivers.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/gpio.h |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index f8b46af..ceb8eef 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -89,6 +89,12 @@ static inline int gpio_request(unsigned gpio, const char *label)
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
@@ -108,6 +114,14 @@ static inline void gpio_free(unsigned gpio)
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
1.7.9.1

