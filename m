Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247Ab1CXV1t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 17:27:49 -0400
Received: from www.linutronix.de ([62.245.132.108]:39947 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757212Ab1CXV1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 17:27:39 -0400
Message-Id: <20110324212509.118888535@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 24 Mar 2011 21:27:37 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Subject: [patch 3/3] gpio: Fold irq_set_chip/irq_set_handler to
	irq_set_chip_and_handler
References: <20110324212330.292903803@linutronix.de>
Content-Disposition: inline; filename=gpio-fold.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Converted with coccinelle.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/gpio/pl061.c  |    4 ++--
 drivers/gpio/sx150x.c |    3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

Index: linux-2.6-tip/drivers/gpio/pl061.c
===================================================================
--- linux-2.6-tip.orig/drivers/gpio/pl061.c
+++ linux-2.6-tip/drivers/gpio/pl061.c
@@ -315,8 +315,8 @@ static int pl061_probe(struct amba_devic
 		else
 			pl061_direction_input(&chip->gc, i);
 
-		irq_set_chip(i + chip->irq_base, &pl061_irqchip);
-		irq_set_handler(i + chip->irq_base, handle_simple_irq);
+		irq_set_chip_and_handler(i + chip->irq_base, &pl061_irqchip,
+					 handle_simple_irq);
 		set_irq_flags(i+chip->irq_base, IRQF_VALID);
 		irq_set_chip_data(i + chip->irq_base, chip);
 	}
Index: linux-2.6-tip/drivers/gpio/sx150x.c
===================================================================
--- linux-2.6-tip.orig/drivers/gpio/sx150x.c
+++ linux-2.6-tip/drivers/gpio/sx150x.c
@@ -583,8 +583,7 @@ static void sx150x_remove_irq_chip(struc
 
 	for (n = 0; n < chip->dev_cfg->ngpios; ++n) {
 		irq = chip->irq_base + n;
-		irq_set_handler(irq, NULL);
-		irq_set_chip(irq, NULL);
+		irq_set_chip_and_handler(irq, NULL, NULL);
 	}
 }
 


