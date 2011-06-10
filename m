Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402Ab1FJItp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 04:49:45 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:52406 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751227Ab1FJItl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 04:49:41 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/2] gpio: expose gpio_to_chip()
Date: Fri, 10 Jun 2011 10:49:12 +0200
Message-ID: <1307695752-28051-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This makes the gpio_to_chip() function available to drivers. The
usecase is when you want to add a few chip-specific operations
apart from the ones exposed in struct gpio_chip.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/gpiolib.c     |    2 +-
 include/asm-generic/gpio.h |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index a971e3d..dc315e9 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -114,7 +114,7 @@ static int gpio_ensure_requested(struct gpio_desc *desc, unsigned offset)
 }
 
 /* caller holds gpio_lock *OR* gpio is marked as requested */
-static inline struct gpio_chip *gpio_to_chip(unsigned gpio)
+struct gpio_chip *gpio_to_chip(unsigned gpio)
 {
 	return gpio_desc[gpio].chip;
 }
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index fcdcb5d..dd8c815 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -132,6 +132,7 @@ struct gpio_chip {
 #endif
 };
 
+extern struct gpio_chip *gpio_to_chip(unsigned gpio);
 extern const char *gpiochip_is_requested(struct gpio_chip *chip,
 			unsigned offset);
 extern int __must_check gpiochip_reserve(int start, int ngpio);
-- 
1.7.3.2

