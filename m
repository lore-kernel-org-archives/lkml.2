Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab0J3VPO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 17:15:14 -0400
Received: from mail.perches.com ([173.55.12.10]:3730 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038Ab0J3VJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 17:09:31 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 12/39] drivers/gpio: Update WARN uses
Date: Sat, 30 Oct 2010 14:08:29 -0700
Message-Id: <4b4588606b88a398e278fcd72181043a68f67939.1288471898.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1288471897.git.joe@perches.com>
References: <cover.1288471897.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Align arguments.
Remove a trailing space before a newline from pr_err

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/gpio/gpiolib.c      |    4 ++--
 drivers/gpio/it8761e_gpio.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 21da9c1..cef8b3a 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -96,9 +96,9 @@ static int gpio_ensure_requested(struct gpio_desc *desc, unsigned offset)
 	const int gpio = chip->base + offset;
 
 	if (WARN(test_and_set_bit(FLAG_REQUESTED, &desc->flags) == 0,
-			"autorequest GPIO-%d\n", gpio)) {
+		 "autorequest GPIO-%d\n", gpio)) {
 		if (!try_module_get(chip->owner)) {
-			pr_err("GPIO-%d: module can't be gotten \n", gpio);
+			pr_err("GPIO-%d: module can't be gotten\n", gpio);
 			clear_bit(FLAG_REQUESTED, &desc->flags);
 			/* lose */
 			return -EIO;
diff --git a/drivers/gpio/it8761e_gpio.c b/drivers/gpio/it8761e_gpio.c
index 48fc43c..9109074 100644
--- a/drivers/gpio/it8761e_gpio.c
+++ b/drivers/gpio/it8761e_gpio.c
@@ -220,7 +220,7 @@ static void __exit it8761e_gpio_exit(void)
 		int ret = gpiochip_remove(&it8761e_gpio_chip);
 
 		WARN(ret, "%s(): gpiochip_remove() failed, ret=%d\n",
-				__func__, ret);
+		     __func__, ret);
 
 		release_region(gpio_ba, GPIO_IOSIZE);
 		gpio_ba = 0;
-- 
1.7.3.1.g432b3.dirty

