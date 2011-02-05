Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575Ab1BEKqs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 05:46:48 -0500
Received: from www.tglx.de ([62.245.132.106]:32874 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916Ab1BEKqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 05:46:47 -0500
Message-Id: <20110205104221.241860207@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sat, 05 Feb 2011 10:46:30 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Feng Tang <feng.tang@intel.com>, Matthew Garrett <mjg@redhat.com>,
        Alan Cox <alan@linux.intel.com>, Alek Du <alek.du@intel.com>
Subject: [patch 2/3] platform-drivers: x86: Convert pmic to new irq_chip
	functions
References: <20110205104025.559237313@linutronix.de>
Content-Disposition: inline;
	filename=platform-drivers-x86-convert-to-new-irq-chip-functions.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Old functions will go away soon. Remove the stray semicolons while at
it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Alek Du <alek.du@intel.com>
---
 drivers/platform/x86/intel_pmic_gpio.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

Index: linux-2.6/drivers/platform/x86/intel_pmic_gpio.c
===================================================================
--- linux-2.6.orig/drivers/platform/x86/intel_pmic_gpio.c
+++ linux-2.6/drivers/platform/x86/intel_pmic_gpio.c
@@ -190,10 +190,10 @@ static void pmic_gpio_set(struct gpio_ch
 			1 << (offset - 16));
 }
 
-static int pmic_irq_type(unsigned irq, unsigned type)
+static int pmic_irq_type(struct irq_data *data, unsigned type)
 {
-	struct pmic_gpio *pg = get_irq_chip_data(irq);
-	u32 gpio = irq - pg->irq_base;
+	struct pmic_gpio *pg = irq_data_get_irq_chip_data(data);
+	u32 gpio = data->irq - pg->irq_base;
 	unsigned long flags;
 
 	if (gpio >= pg->chip.ngpio)
@@ -207,8 +207,6 @@ static int pmic_irq_type(unsigned irq, u
 	return 0;
 }
 
-
-
 static int pmic_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 {
 	struct pmic_gpio *pg = container_of(chip, struct pmic_gpio, chip);
@@ -217,19 +215,15 @@ static int pmic_gpio_to_irq(struct gpio_
 }
 
 /* the gpiointr register is read-clear, so just do nothing. */
-static void pmic_irq_unmask(unsigned irq)
-{
-};
+static void pmic_irq_unmask(struct irq_data *data) { }
 
-static void pmic_irq_mask(unsigned irq)
-{
-};
+static void pmic_irq_mask(struct irq_data *data) { }
 
 static struct irq_chip pmic_irqchip = {
 	.name		= "PMIC-GPIO",
-	.mask		= pmic_irq_mask,
-	.unmask		= pmic_irq_unmask,
-	.set_type	= pmic_irq_type,
+	.irq_mask	= pmic_irq_mask,
+	.irq_unmask	= pmic_irq_unmask,
+	.irq_set_type	= pmic_irq_type,
 };
 
 static void pmic_irq_handler(unsigned irq, struct irq_desc *desc)


