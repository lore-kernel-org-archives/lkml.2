Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437Ab2KFPRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 10:17:00 -0500
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:41196 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752238Ab2KFPQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 10:16:58 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/5] gpiolib-of: staticize the pin range calls
Date: Tue, 6 Nov 2012 16:16:43 +0100
Message-ID: <1352215003-30268-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Commit 69e1601bca88809dc118abd1becb02c15a02ec71
"gpiolib: provide provision to register pin ranges"

Declared the of_gpiochip_[add|remove]_pin_range() global
while they should be static as they are only ever used in
this file. Let's convert them to static.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/gpiolib-of.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index a5b90c8..220caa5 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -218,7 +218,7 @@ err0:
 EXPORT_SYMBOL(of_mm_gpiochip_add);
 
 #ifdef CONFIG_PINCTRL
-void of_gpiochip_add_pin_range(struct gpio_chip *chip)
+static void of_gpiochip_add_pin_range(struct gpio_chip *chip)
 {
 	struct device_node *np = chip->of_node;
 	struct gpio_pin_range *pin_range;
@@ -254,7 +254,7 @@ void of_gpiochip_add_pin_range(struct gpio_chip *chip)
 	} while (index++);
 }
 
-void of_gpiochip_remove_pin_range(struct gpio_chip *chip)
+static void of_gpiochip_remove_pin_range(struct gpio_chip *chip)
 {
 	struct gpio_pin_range *pin_range, *tmp;
 
@@ -265,8 +265,8 @@ void of_gpiochip_remove_pin_range(struct gpio_chip *chip)
 	}
 }
 #else
-void of_gpiochip_add_pin_range(struct gpio_chip *chip) {}
-void of_gpiochip_remove_pin_range(struct gpio_chip *chip) {}
+static void of_gpiochip_add_pin_range(struct gpio_chip *chip) {}
+static void of_gpiochip_remove_pin_range(struct gpio_chip *chip) {}
 #endif
 
 void of_gpiochip_add(struct gpio_chip *chip)
-- 
1.7.11.3

