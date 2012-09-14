Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab2INChC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 22:37:02 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:49661 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab2INChA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 22:37:00 -0400
MIME-Version: 1.0
Date: Fri, 14 Sep 2012 10:36:59 +0800
Message-ID: <CAPgLHd93SqsiFmE7y356VwBJtaac0APE__vk+8dBZnaOyt4org@mail.gmail.com>
Subject: [PATCH] gpio: pxa: using for_each_set_bit to simplify the code
From: Wei Yongjun <weiyj.lk@gmail.com>
To: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        rob.herring@calxeda.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using for_each_set_bit() to simplify the code.

spatch with a semantic match is used to found this.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/gpio/gpio-pxa.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-pxa.c b/drivers/gpio/gpio-pxa.c
index 9cac88a..a9e1a74 100644
--- a/drivers/gpio/gpio-pxa.c
+++ b/drivers/gpio/gpio-pxa.c
@@ -413,12 +413,10 @@ static void pxa_gpio_demux_handler(unsigned int irq, struct irq_desc *desc)
 			gedr = gedr & c->irq_mask;
 			writel_relaxed(gedr, c->regbase + GEDR_OFFSET);
 
-			n = find_first_bit(&gedr, BITS_PER_LONG);
-			while (n < BITS_PER_LONG) {
+			for_each_set_bit(n, &gedr, BITS_PER_LONG) {
 				loop = 1;
 
 				generic_handle_irq(gpio_to_irq(gpio_base + n));
-				n = find_next_bit(&gedr, BITS_PER_LONG, n + 1);
 			}
 		}
 	} while (loop);


