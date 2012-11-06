Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab2KFPRK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 10:17:10 -0500
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:36304 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752283Ab2KFPRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 10:17:06 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3/5] gpiolib: remove duplicate pin range code
Date: Tue, 6 Nov 2012 16:16:54 +0100
Message-ID: <1352215014-30305-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Commit 69e1601bca88809dc118abd1becb02c15a02ec71
"gpiolib: provide provision to register pin ranges"

Introduced both of_gpiochip_remove_pin_range() and
gpiochip_remove_pin_ranges(). But the contents are exactly
the same so remove the OF one and rely on the range deletion
in the core.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/gpiolib-of.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index 220caa5..67403e4 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -254,19 +254,8 @@ static void of_gpiochip_add_pin_range(struct gpio_chip *chip)
 	} while (index++);
 }
 
-static void of_gpiochip_remove_pin_range(struct gpio_chip *chip)
-{
-	struct gpio_pin_range *pin_range, *tmp;
-
-	list_for_each_entry_safe(pin_range, tmp, &chip->pin_ranges, node) {
-		list_del(&pin_range->node);
-		pinctrl_remove_gpio_range(pin_range->pctldev,
-				&pin_range->range);
-	}
-}
 #else
 static void of_gpiochip_add_pin_range(struct gpio_chip *chip) {}
-static void of_gpiochip_remove_pin_range(struct gpio_chip *chip) {}
 #endif
 
 void of_gpiochip_add(struct gpio_chip *chip)
@@ -288,7 +277,7 @@ void of_gpiochip_add(struct gpio_chip *chip)
 
 void of_gpiochip_remove(struct gpio_chip *chip)
 {
-	of_gpiochip_remove_pin_range(chip);
+	gpiochip_remove_pin_ranges(chip);
 
 	if (chip->of_node)
 		of_node_put(chip->of_node);
-- 
1.7.11.3

