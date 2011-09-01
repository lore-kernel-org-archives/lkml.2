Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757740Ab1IAOsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 10:48:22 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63807 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757723Ab1IAOsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 10:48:18 -0400
Subject: [PATCH] gpio: davinci: eliminate unused variable warnings
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Nori Sekhar <nsekhar@ti.com>, Hilman Kevin <khilman@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        davinci-linux-open-source@linux.davincidsp.com
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Sep 2011 22:48:08 +0800
Message-ID: <1314888488.11908.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 5093aec872e5be7a55d8dd2b639e8a3818dc19db
"arm: davinci: Cleanup irq chip code", the variable 'mask' and 'g'
are not being used.

This patch eliminates below unused variable warnings:

  CC      drivers/gpio/gpio-davinci.o
drivers/gpio/gpio-davinci.c: In function 'gpio_irq_type':
drivers/gpio/gpio-davinci.c:234: warning: unused variable 'mask'
drivers/gpio/gpio-davinci.c:233: warning: unused variable 'g'

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/gpio/gpio-davinci.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
index a8066e8..df0d595 100644
--- a/drivers/gpio/gpio-davinci.c
+++ b/drivers/gpio/gpio-davinci.c
@@ -230,9 +230,6 @@ static void gpio_irq_enable(struct irq_data *d)
 
 static int gpio_irq_type(struct irq_data *d, unsigned trigger)
 {
-	struct davinci_gpio_regs __iomem *g = irq2regs(d->irq);
-	u32 mask = (u32) irq_data_get_irq_handler_data(d);
-
 	if (trigger & ~(IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING))
 		return -EINVAL;
 
-- 
1.7.4.1



