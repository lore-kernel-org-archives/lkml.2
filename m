Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759858Ab2CUSNg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 14:13:36 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:24107 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759725Ab2CUSNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 14:13:34 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-127.messagelabs.com!1332353602!1140348!40
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] gpio: ep93xx: Remove unused inline function and useless pr_err message
Date: Wed, 21 Mar 2012 11:13:27 -0700
User-Agent: KMail/1.9.9
CC: <grant.likely@secretlab.ca>, <linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201203211113.28122.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor removal of an unused inline function and a useless pr_err message.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@stericsson.com>

---

diff --git a/drivers/gpio/gpio-ep93xx.c b/drivers/gpio/gpio-ep93xx.c
index 4ca5642..776b772 100644
--- a/drivers/gpio/gpio-ep93xx.c
+++ b/drivers/gpio/gpio-ep93xx.c
@@ -12,8 +12,6 @@
  *  published by the Free Software Foundation.
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
@@ -65,11 +63,6 @@ static void ep93xx_gpio_update_int_params(unsigned port)
 		EP93XX_GPIO_REG(int_en_register_offset[port]));
 }
 
-static inline void ep93xx_gpio_int_mask(unsigned line)
-{
-	gpio_int_unmasked[line >> 3] &= ~(1 << (line & 7));
-}
-
 static void ep93xx_gpio_int_debounce(unsigned int irq, bool enable)
 {
 	int line = irq_to_gpio(irq);
@@ -212,7 +205,6 @@ static int ep93xx_gpio_irq_type(struct irq_data *d, unsigned int type)
 		handler = handle_edge_irq;
 		break;
 	default:
-		pr_err("failed to set irq type %d for gpio %d\n", type, gpio);
 		return -EINVAL;
 	}
 
