Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab1HOFlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 01:41:44 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36458 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab1HOFln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 01:41:43 -0400
Subject: [PATCH] [ARM] davinci: gpio: eliminate unused variable warnings
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@ti.com>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Aug 2011 13:41:33 +0800
Message-ID: <1313386893.25484.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 5093aec872e5be7a55d8dd2b639e8a3818dc19db
"arm: davinci: Cleanup irq chip code", 
the variable 'mask' and 'g' are not being used in gpio_irq_type.

This patch eliminate below unused variable warnings:

  CC      arch/arm/mach-davinci/gpio.o
arch/arm/mach-davinci/gpio.c: In function 'gpio_irq_type':
arch/arm/mach-davinci/gpio.c:234: warning: unused variable 'mask'
arch/arm/mach-davinci/gpio.c:233: warning: unused variable 'g'

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 arch/arm/mach-davinci/gpio.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-davinci/gpio.c b/arch/arm/mach-davinci/gpio.c
index a8066e8..df0d595 100644
--- a/arch/arm/mach-davinci/gpio.c
+++ b/arch/arm/mach-davinci/gpio.c
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



