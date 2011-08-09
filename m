Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750957Ab1HIAjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 20:39:10 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:47278 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab1HIAjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 20:39:08 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-209.messagelabs.com!1312850345!13057298!16
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.180]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] gpio: ep93xx: remove usless pr_err message
Date: Mon, 8 Aug 2011 17:38:44 -0700
User-Agent: KMail/1.9.9
CC: <rmallon@gmail.com>, <grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201108081738.44996.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the IRQ_TYPE_* options are handled so the pr_err message is
not really necessary, remove it.

Also, since this was the only pr_* use in the file, remove the pr_fmt.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>

---

diff --git a/drivers/gpio/gpio-ep93xx.c b/drivers/gpio/gpio-ep93xx.c
index 468b27d..b229a29 100644
--- a/drivers/gpio/gpio-ep93xx.c
+++ b/drivers/gpio/gpio-ep93xx.c
@@ -12,8 +12,6 @@
  *  published by the Free Software Foundation.
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
@@ -209,7 +207,6 @@ static int ep93xx_gpio_irq_type(struct irq_data *d, unsigned int type)
 		handler = handle_edge_irq;
 		break;
 	default:
-		pr_err("failed to set irq type %d for gpio %d\n", type, gpio);
 		return -EINVAL;
 	}
 
