Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab2BQSqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 13:46:08 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55161 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752566Ab2BQSqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 13:46:07 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] gpiolib: Add comments explaining the _cansleep() WARN_ON()s
Date: Fri, 17 Feb 2012 10:46:00 -0800
Message-Id: <1329504360-13770-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've seen users getting very confused by the WARN_ON()s for can_sleep
GPIOs in the atomic-safe paths, the discoverability of the non-atomic
version of the API seems to be hampered by the fact that it's defined
in a header file not the .c file where the warnings are.

Add a couple of comments next to the warnings to help people on their
way.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/gpio/gpiolib.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 17fdf4b..10ce33d 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1560,6 +1560,7 @@ int __gpio_get_value(unsigned gpio)
 	int value;
 
 	chip = gpio_to_chip(gpio);
+	/* Should be using gpio_get_value_cansleep() */
 	WARN_ON(chip->can_sleep);
 	value = chip->get ? chip->get(chip, gpio - chip->base) : 0;
 	trace_gpio_value(gpio, 1, value);
@@ -1581,6 +1582,7 @@ void __gpio_set_value(unsigned gpio, int value)
 	struct gpio_chip	*chip;
 
 	chip = gpio_to_chip(gpio);
+	/* Should be using gpio_set_value_cansleep() */
 	WARN_ON(chip->can_sleep);
 	trace_gpio_value(gpio, 0, value);
 	chip->set(chip, gpio - chip->base, value);
-- 
1.7.9.rc1

