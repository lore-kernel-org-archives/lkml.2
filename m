Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab1CQTdI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 15:33:08 -0400
Received: from www.tglx.de ([62.245.132.106]:44815 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754065Ab1CQTdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 15:33:06 -0400
Message-Id: <20110317192449.640499013@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 17 Mar 2011 19:32:52 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, Feng Tang <feng.tang@intel.com>,
        Alek Du <alek.du@intel.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [patch 3/5] gpio: langwell: Convert irq name space
References: <20110317192247.722047296@linutronix.de>
Content-Disposition: inline; filename=gpio-langwell-convert-irq-namespace.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the new irq function names.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Alek Du <alek.du@intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>

---
 drivers/gpio/langwell_gpio.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6-tip/drivers/gpio/langwell_gpio.c
===================================================================
--- linux-2.6-tip.orig/drivers/gpio/langwell_gpio.c
+++ linux-2.6-tip/drivers/gpio/langwell_gpio.c
@@ -276,12 +276,12 @@ static int __devinit lnw_gpio_probe(stru
 		dev_err(&pdev->dev, "langwell gpiochip_add error %d\n", retval);
 		goto err5;
 	}
-	set_irq_data(pdev->irq, lnw);
-	set_irq_chained_handler(pdev->irq, lnw_irq_handler);
+	irq_set_handler_data(pdev->irq, lnw);
+	irq_set_chained_handler(pdev->irq, lnw_irq_handler);
 	for (i = 0; i < lnw->chip.ngpio; i++) {
-		set_irq_chip_and_handler_name(i + lnw->irq_base, &lnw_irqchip,
-					handle_simple_irq, "demux");
-		set_irq_chip_data(i + lnw->irq_base, lnw);
+		irq_set_chip_and_handler_name(i + lnw->irq_base, &lnw_irqchip,
+					      handle_simple_irq, "demux");
+		irq_set_chip_data(i + lnw->irq_base, lnw);
 	}
 
 	spin_lock_init(&lnw->lock);


