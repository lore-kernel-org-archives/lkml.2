Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761360Ab2EKX6m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 19:58:42 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:50069 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761178Ab2EKX6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 19:58:38 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-131.messagelabs.com!1336780716!12344172!1
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] gpiolib: quiet gpiochip_add boot message noise
Date: Fri, 11 May 2012 16:58:33 -0700
User-Agent: KMail/1.9.9
CC: <grant.likely@secretlab.ca>, <linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205111658.33327.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pr_info message in gpiochip_add gets displayed for every
gpiochip registered. When first bringing up a system this
information could be helpful but for normal use it's just a
bunch of noise. Change the message to a pr_debug.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@stericsson.com>

---

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 566d012..f7972d2 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1093,7 +1093,7 @@ unlock:
 	if (status)
 		goto fail;
 
-	pr_info("gpiochip_add: registered GPIOs %d to %d on device: %s\n",
+	pr_debug("gpiochip_add: registered GPIOs %d to %d on device: %s\n",
 		chip->base, chip->base + chip->ngpio - 1,
 		chip->label ? : "generic");
 
