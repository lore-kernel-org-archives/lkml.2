Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934594Ab1CYLMl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 07:12:41 -0400
Received: from www.linutronix.de ([62.245.132.108]:38596 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934566Ab1CYLMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 07:12:36 -0400
Message-Id: <20110325111218.440617746@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 11:12:32 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [patch 09/10] mfd: Cleanup irq namespace
References: <20110325110939.701487744@linutronix.de>
Content-Disposition: inline; filename=mfd-namespace.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Converted with coccinelle.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/mfd/88pm860x-core.c |    8 ++++----
 drivers/mfd/ab3550-core.c   |   12 ++++++------
 drivers/mfd/ab8500-core.c   |   12 ++++++------
 drivers/mfd/asic3.c         |   22 +++++++++++-----------
 drivers/mfd/ezx-pcap.c      |   20 ++++++++++----------
 drivers/mfd/htc-egpio.c     |   18 +++++++++---------
 drivers/mfd/htc-i2cpld.c    |    8 ++++----
 drivers/mfd/jz4740-adc.c    |   16 ++++++++--------
 drivers/mfd/max8925-core.c  |    8 ++++----
 drivers/mfd/max8998-irq.c   |    8 ++++----
 drivers/mfd/max8998.c       |    4 ++--
 drivers/mfd/stmpe.c         |   12 ++++++------
 drivers/mfd/t7l66xb.c       |   22 +++++++++++-----------
 drivers/mfd/tc3589x.c       |   12 ++++++------
 drivers/mfd/tc6393xb.c      |   22 +++++++++++-----------
 drivers/mfd/tps6586x.c      |    6 +++---
 drivers/mfd/twl4030-irq.c   |   20 ++++++++++----------
 drivers/mfd/twl6030-irq.c   |    8 ++++----
 drivers/mfd/wm831x-irq.c    |    8 ++++----
 drivers/mfd/wm8350-irq.c    |    8 ++++----
 drivers/mfd/wm8994-irq.c    |    8 ++++----
 21 files changed, 131 insertions(+), 131 deletions(-)

Index: linux-2.6-tip/drivers/mfd/88pm860x-core.c
===================================================================
--- linux-2.6-tip.orig/drivers/mfd/88pm860x-core.c
+++ linux-2.6-tip/drivers/mfd/88pm860x-core.c
@@ -562,14 +562,14 @@ static int __devinit device_irq_init(str
 	/* register IRQ by genirq */
 	for (i = 0; i < ARRAY_SIZE(pm860x_irqs); i++) {
 		__irq = i + chip->irq_base;
-		set_irq_chip_data(__irq, chip);
-		set_irq_chip_and_handler(__irq, &pm860x_irq_chip,
+		irq_set_chip_data(__irq, chip);
+		irq_set_chip_and_handler(__irq, &pm860x_irq_chip,
 					 handle_edge_irq);
-		set_irq_nested_thread(__irq, 1);
+		irq_set_nested_thread(__irq, 1);
 #ifdef CONFIG_ARM
 		set_irq_flags(__irq, IRQF_VALID);
 #else
-		set_irq_noprobe(__irq);
+		irq_set_noprobe(__irq);
 #endif
 	}
 
Index: linux-2.6-tip/drivers/mfd/ab3550-core.c
===================================================================
--- linux-2.6-tip.orig/drivers/mfd/ab3550-core.c
+++ linux-2.6-tip/drivers/mfd/ab3550-core.c
@@ -668,7 +668,7 @@ static int ab3550_startup_irq_enabled(st
 	struct ab3550_platform_data *plf_data;
 	bool val;
 
-	ab = get_irq_chip_data(irq);
+	ab = irq_get_chip_data(irq);
 	plf_data = ab->i2c_client[0]->dev.platform_data;
 	irq -= plf_data->irq.base;
 	val = ((ab->startup_events[irq / 8] & BIT(irq % 8)) != 0);
@@ -1296,14 +1296,14 @@ static int __init ab3550_probe(struct i2
 		unsigned int irq;
 
 		irq = ab3550_plf_data->irq.base + i;
-		set_irq_chip_data(irq, ab);
-		set_irq_chip_and_handler(irq, &ab3550_irq_chip,
-			handle_simple_irq);
-		set_irq_nested_thread(irq, 1);
+		irq_set_chip_data(irq, ab);
+		irq_set_chip_and_handler(irq, &ab3550_irq_chip,
+					 handle_simple_irq);
+		irq_set_nested_thread(irq, 1);
 #ifdef CONFIG_ARM
 		set_irq_flags(irq, IRQF_VALID);
 #else
-		set_irq_noprobe(irq);
+		irq_set_noprobe(irq);
 #endif
 	}
 
Index: linux-2.6-tip/drivers/mfd/ab8500-core.c
===================================================================
--- linux-2.6-tip.orig/drivers/mfd/ab8500-core.c
+++ linux-2.6-tip/drivers/mfd/ab8500-core.c
@@ -333,14 +333,14 @@ static int ab8500_irq_init(struct ab8500
 	int irq;
 
 	for (irq = base; irq < base + AB8500_NR_IRQS; irq++) {
-		set_irq_chip_data(irq, ab8500);
-		set_irq_chip_and_handler(irq, &ab8500_irq_chip,
+		irq_set_chip_data(irq, ab8500);
+		irq_set_chip_and_handler(irq, &ab8500_irq_chip,
 					 handle_simple_irq);
-		set_irq_nested_thread(irq, 1);
+		irq_set_nested_thread(irq, 1);
 #ifdef CONFIG_ARM
 		set_irq_flags(irq, IRQF_VALID);
 #else
-		set_irq_noprobe(irq);
+		irq_set_noprobe(irq);
 #endif
 	}
 
@@ -356,8 +356,8 @@ static void ab8500_irq_remove(struct ab8
 #ifdef CONFIG_ARM
 		set_irq_flags(irq, 0);
 #endif
-		set_irq_chip_and_handler(irq, NULL, NULL);
-		set_irq_chip_data(irq, NULL);
+		irq_set_chip_and_handler(irq, NULL, NULL);
+		irq_set_chip_data(irq, NULL);
 	}
 }
 
Index: linux-2.6-tip/drivers/mfd/asic3.c
===================================================================
--- linux-2.6-tip.orig/drivers/mfd/asic3.c
+++ linux-2.6-tip/drivers/mfd/asic3.c
@@ -388,21 +388,21 @@ static int __init asic3_irq_probe(struct
 
 	for (irq = irq_base; irq < irq_base + ASIC3_NR_IRQS; irq++) {
 		if (irq < asic->irq_base + ASIC3_NUM_GPIOS)
-			set_irq_chip(irq, &asic3_gpio_irq_chip);
+			irq_set_chip(irq, &asic3_gpio_irq_chip);
 		else
-			set_irq_chip(irq, &asic3_irq_chip);
+			irq_set_chip(irq, &asic3_irq_chip);
 
-		set_irq_chip_data(irq, asic);
-		set_irq_handler(irq, handle_level_irq);
+		irq_set_chip_data(irq, asic);
+		irq_set_handler(irq, handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 	}
 
 	asic3_write_register(asic, ASIC3_OFFSET(INTR, INT_MASK),
 			     ASIC3_INTMASK_GINTMASK);
 
-	set_irq_chained_handler(asic->irq_nr, asic3_irq_demux);
-	set_irq_type(asic->irq_nr, IRQ_TYPE_EDGE_RISING);
-	set_irq_data(asic->irq_nr, asic);
+	irq_set_chained_handler(asic->irq_nr, asic3_irq_demux);
+	irq_set_irq_type(asic->irq_nr, IRQ_TYPE_EDGE_RISING);
+	irq_set_handler_data(asic->irq_nr, asic);
 
 	return 0;
 }
@@ -416,11 +416,11 @@ static void asic3_irq_remove(struct plat
 
 	for (irq = irq_base; irq < irq_base + ASIC3_NR_IRQS; irq++) {
 		set_irq_flags(irq, 0);
-		set_irq_handler(irq, NULL);
-		set_irq_chip(irq, NULL);
-		set_irq_chip_data(irq, NULL);
+		irq_set_handler(irq, NULL);
+		irq_set_chip(irq, NULL);
+		irq_set_chip_data(irq, NULL);
 	}
-	set_irq_chained_handler(asic->irq_nr, NULL);
+	irq_set_chained_handler(asic->irq_nr, NULL);
 }
 
 /* GPIOs */
Index: linux-2.6-tip/drivers/mfd/ezx-pcap.c
===================================================================
--- linux-2.6-tip.orig/drivers/mfd/ezx-pcap.c
+++ linux-2.6-tip/drivers/mfd/ezx-pcap.c
@@ -207,7 +207,7 @@ static void pcap_isr_work(struct work_st
 
 static void pcap_irq_handler(unsigned int irq, struct irq_desc *desc)
 {
-	struct pcap_chip *pcap = get_irq_data(irq);
+	struct pcap_chip *pcap = irq_get_handler_data(irq);
 
 	desc->irq_data.chip->irq_ack(&desc->irq_data);
 	queue_work(pcap->workqueue, &pcap->isr_work);
@@ -411,7 +411,7 @@ static int __devexit ezx_pcap_remove(str
 
 	/* cleanup irqchip */
 	for (i = pcap->irq_base; i < (pcap->irq_base + PCAP_NIRQS); i++)
-		set_irq_chip_and_handler(i, NULL, NULL);
+		irq_set_chip_and_handler(i, NULL, NULL);
 
 	destroy_workqueue(pcap->workqueue);
 
@@ -468,12 +468,12 @@ static int __devinit ezx_pcap_probe(stru
 
 	/* setup irq chip */
 	for (i = pcap->irq_base; i < (pcap->irq_base + PCAP_NIRQS); i++) {
-		set_irq_chip_and_handler(i, &pcap_irq_chip, handle_simple_irq);
-		set_irq_chip_data(i, pcap);
+		irq_set_chip_and_handler(i, &pcap_irq_chip, handle_simple_irq);
+		irq_set_chip_data(i, pcap);
 #ifdef CONFIG_ARM
 		set_irq_flags(i, IRQF_VALID);
 #else
-		set_irq_noprobe(i);
+		irq_set_noprobe(i);
 #endif
 	}
 
@@ -482,10 +482,10 @@ static int __devinit ezx_pcap_probe(stru
 	ezx_pcap_write(pcap, PCAP_REG_ISR, PCAP_CLEAR_INTERRUPT_REGISTER);
 	pcap->msr = PCAP_MASK_ALL_INTERRUPT;
 
-	set_irq_type(spi->irq, IRQ_TYPE_EDGE_RISING);
-	set_irq_data(spi->irq, pcap);
-	set_irq_chained_handler(spi->irq, pcap_irq_handler);
-	set_irq_wake(spi->irq, 1);
+	irq_set_irq_type(spi->irq, IRQ_TYPE_EDGE_RISING);
+	irq_set_handler_data(spi->irq, pcap);
+	irq_set_chained_handler(spi->irq, pcap_irq_handler);
+	irq_set_irq_wake(spi->irq, 1);
 
 	/* ADC */
 	adc_irq = pcap_to_irq(pcap, (pdata->config & PCAP_SECOND_PORT) ?
@@ -514,7 +514,7 @@ remove_subdevs:
 	free_irq(adc_irq, pcap);
 free_irqchip:
 	for (i = pcap->irq_base; i < (pcap->irq_base + PCAP_NIRQS); i++)
-		set_irq_chip_and_handler(i, NULL, NULL);
+		irq_set_chip_and_handler(i, NULL, NULL);
 /* destroy_workqueue: */
 	destroy_workqueue(pcap->workqueue);
 free_pcap:
Index: linux-2.6-tip/drivers/mfd/htc-egpio.c
===================================================================
--- linux-2.6-tip.orig/drivers/mfd/htc-egpio.c
+++ linux-2.6-tip/drivers/mfd/htc-egpio.c
@@ -344,14 +344,14 @@ static int __init egpio_probe(struct pla
 			ei->ack_write = 0;
 		irq_end = ei->irq_start + ei->nirqs;
 		for (irq = ei->irq_start; irq < irq_end; irq++) {
-			set_irq_chip(irq, &egpio_muxed_chip);
-			set_irq_chip_data(irq, ei);
-			set_irq_handler(irq, handle_simple_irq);
+			irq_set_chip(irq, &egpio_muxed_chip);
+			irq_set_chip_data(irq, ei);
+			irq_set_handler(irq, handle_simple_irq);
 			set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 		}
-		set_irq_type(ei->chained_irq, IRQ_TYPE_EDGE_RISING);
-		set_irq_data(ei->chained_irq, ei);
-		set_irq_chained_handler(ei->chained_irq, egpio_handler);
+		irq_set_irq_type(ei->chained_irq, IRQ_TYPE_EDGE_RISING);
+		irq_set_handler_data(ei->chained_irq, ei);
+		irq_set_chained_handler(ei->chained_irq, egpio_handler);
 		ack_irqs(ei);
 
 		device_init_wakeup(&pdev->dev, 1);
@@ -373,11 +373,11 @@ static int __exit egpio_remove(struct pl
 	if (ei->chained_irq) {
 		irq_end = ei->irq_start + ei->nirqs;
 		for (irq = ei->irq_start; irq < irq_end; irq++) {
-			set_irq_chip(irq, NULL);
-			set_irq_handler(irq, NULL);
+			irq_set_chip(irq, NULL);
+			irq_set_handler(irq, NULL);
 			set_irq_flags(irq, 0);
 		}
-		set_irq_chained_handler(ei->chained_irq, NULL);
+		irq_set_chained_handler(ei->chained_irq, NULL);
 		device_init_wakeup(&pdev->dev, 0);
 	}
 	iounmap(ei->base_addr);
Index: linux-2.6-tip/drivers/mfd/htc-i2cpld.c
===================================================================
--- linux-2.6-tip.orig/drivers/mfd/htc-i2cpld.c
+++ linux-2.6-tip/drivers/mfd/htc-i2cpld.c
@@ -348,13 +348,13 @@ static int __devinit htcpld_setup_chip_i
 	/* Setup irq handlers */
 	irq_end = chip->irq_start + chip->nirqs;
 	for (irq = chip->irq_start; irq < irq_end; irq++) {
-		set_irq_chip(irq, &htcpld_muxed_chip);
-		set_irq_chip_data(irq, chip);
-		set_irq_handler(irq, handle_simple_irq);
+		irq_set_chip(irq, &htcpld_muxed_chip);
+		irq_set_chip_data(irq, chip);
+		irq_set_handler(irq, handle_simple_irq);
 #ifdef CONFIG_ARM
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 #else
-		set_irq_probe(irq);
+		irq_set_probe(irq);
 #endif
 	}
 
Index: linux-2.6-tip/drivers/mfd/jz4740-adc.c
===================================================================
--- linux-2.6-tip.orig/drivers/mfd/jz4740-adc.c
+++ linux-2.6-tip/drivers/mfd/jz4740-adc.c
@@ -112,7 +112,7 @@ static struct irq_chip jz4740_adc_irq_ch
 
 static void jz4740_adc_irq_demux(unsigned int irq, struct irq_desc *desc)
 {
-	struct jz4740_adc *adc = get_irq_desc_data(desc);
+	struct jz4740_adc *adc = irq_desc_get_handler_data(desc);
 	uint8_t status;
 	unsigned int i;
 
@@ -314,13 +314,13 @@ static int __devinit jz4740_adc_probe(st
 	platform_set_drvdata(pdev, adc);
 
 	for (irq = adc->irq_base; irq < adc->irq_base + 5; ++irq) {
-		set_irq_chip_data(irq, adc);
-		set_irq_chip_and_handler(irq, &jz4740_adc_irq_chip,
-		    handle_level_irq);
+		irq_set_chip_data(irq, adc);
+		irq_set_chip_and_handler(irq, &jz4740_adc_irq_chip,
+					 handle_level_irq);
 	}
 
-	set_irq_data(adc->irq, adc);
-	set_irq_chained_handler(adc->irq, jz4740_adc_irq_demux);
+	irq_set_handler_data(adc->irq, adc);
+	irq_set_chained_handler(adc->irq, jz4740_adc_irq_demux);
 
 	writeb(0x00, adc->base + JZ_REG_ADC_ENABLE);
 	writeb(0xff, adc->base + JZ_REG_ADC_CTRL);
@@ -351,8 +351,8 @@ static int __devexit jz4740_adc_remove(s
 
 	mfd_remove_devices(&pdev->dev);
 
-	set_irq_data(adc->irq, NULL);
-	set_irq_chained_handler(adc->irq, NULL);
+	irq_set_handler_data(adc->irq, NULL);
+	irq_set_chained_handler(adc->irq, NULL);
 
 	iounmap(adc->base);
 	release_mem_region(adc->mem->start, resource_size(adc->mem));
Index: linux-2.6-tip/drivers/mfd/max8925-core.c
===================================================================
--- linux-2.6-tip.orig/drivers/mfd/max8925-core.c
+++ linux-2.6-tip/drivers/mfd/max8925-core.c
@@ -547,14 +547,14 @@ static int max8925_irq_init(struct max89
 	/* register with genirq */
 	for (i = 0; i < ARRAY_SIZE(max8925_irqs); i++) {
 		__irq = i + chip->irq_base;
-		set_irq_chip_data(__irq, chip);
-		set_irq_chip_and_handler(__irq, &max8925_irq_chip,
+		irq_set_chip_data(__irq, chip);
+		irq_set_chip_and_handler(__irq, &max8925_irq_chip,
 					 handle_edge_irq);
-		set_irq_nested_thread(__irq, 1);
+		irq_set_nested_thread(__irq, 1);
 #ifdef CONFIG_ARM
 		set_irq_flags(__irq, IRQF_VALID);
 #else
-		set_irq_noprobe(__irq);
+		irq_set_noprobe(__irq);
 #endif
 	}
 	if (!irq) {
Index: linux-2.6-tip/drivers/mfd/max8998-irq.c
===================================================================
--- linux-2.6-tip.orig/drivers/mfd/max8998-irq.c
+++ linux-2.6-tip/drivers/mfd/max8998-irq.c
@@ -224,14 +224,14 @@ int max8998_irq_init(struct max8998_dev 
 	/* register with genirq */
 	for (i = 0; i < MAX8998_IRQ_NR; i++) {
 		cur_irq = i + max8998->irq_base;
-		set_irq_chip_data(cur_irq, max8998);
-		set_irq_chip_and_handler(cur_irq, &max8998_irq_chip,
+		irq_set_chip_data(cur_irq, max8998);
+		irq_set_chip_and_handler(cur_irq, &max8998_irq_chip,
 					 handle_edge_irq);
-		set_irq_nested_thread(cur_irq, 1);
+		irq_set_nested_thread(cur_irq, 1);
 #ifdef CONFIG_ARM
 		set_irq_flags(cur_irq, IRQF_VALID);
 #else
-		set_irq_noprobe(cur_irq);
+		irq_set_noprobe(cur_irq);
 #endif
 	}
 
Index: linux-2.6-tip/drivers/mfd/max8998.c
===================================================================
--- linux-2.6-tip.orig/drivers/mfd/max8998.c
+++ linux-2.6-tip/drivers/mfd/max8998.c
@@ -209,7 +209,7 @@ static int max8998_suspend(struct device
 	struct max8998_dev *max8998 = i2c_get_clientdata(i2c);
 
 	if (max8998->wakeup)
-		set_irq_wake(max8998->irq, 1);
+		irq_set_irq_wake(max8998->irq, 1);
 	return 0;
 }
 
@@ -219,7 +219,7 @@ static int max8998_resume(struct device 
 	struct max8998_dev *max8998 = i2c_get_clientdata(i2c);
 
 	if (max8998->wakeup)
-		set_irq_wake(max8998->irq, 0);
+		irq_set_irq_wake(max8998->irq, 0);
 	/*
 	 * In LP3974, if IRQ registers are not "read & clear"
 	 * when it's set during sleep, the interrupt becomes
Index: linux-2.6-tip/drivers/mfd/stmpe.c
===================================================================
--- linux-2.6-tip.orig/drivers/mfd/stmpe.c
+++ linux-2.6-tip/drivers/mfd/stmpe.c
@@ -762,14 +762,14 @@ static int __devinit stmpe_irq_init(stru
 	int irq;
 
 	for (irq = base; irq < base + num_irqs; irq++) {
-		set_irq_chip_data(irq, stmpe);
-		set_irq_chip_and_handler(irq, &stmpe_irq_chip,
+		irq_set_chip_data(irq, stmpe);
+		irq_set_chip_and_handler(irq, &stmpe_irq_chip,
 					 handle_edge_irq);
-		set_irq_nested_thread(irq, 1);
+		irq_set_nested_thread(irq, 1);
 #ifdef CONFIG_ARM
 		set_irq_flags(irq, IRQF_VALID);
 #else
-		set_irq_noprobe(irq);
+		irq_set_noprobe(irq);
 #endif
 	}
 
@@ -786,8 +786,8 @@ static void stmpe_irq_remove(struct stmp
 #ifdef CONFIG_ARM
 		set_irq_flags(irq, 0);
 #endif
-		set_irq_chip_and_handler(irq, NULL, NULL);
-		set_irq_chip_data(irq, NULL);
+		irq_set_chip_and_handler(irq, NULL, NULL);
+		irq_set_chip_data(irq, NULL);
 	}
 }
 
Index: linux-2.6-tip/drivers/mfd/t7l66xb.c
===================================================================
--- linux-2.6-tip.orig/drivers/mfd/t7l66xb.c
+++ linux-2.6-tip/drivers/mfd/t7l66xb.c
@@ -186,7 +186,7 @@ static struct mfd_cell t7l66xb_cells[] =
 /* Handle the T7L66XB interrupt mux */
 static void t7l66xb_irq(unsigned int irq, struct irq_desc *desc)
 {
-	struct t7l66xb *t7l66xb = get_irq_data(irq);
+	struct t7l66xb *t7l66xb = irq_get_handler_data(irq);
 	unsigned int isr;
 	unsigned int i, irq_base;
 
@@ -243,17 +243,17 @@ static void t7l66xb_attach_irq(struct pl
 	irq_base = t7l66xb->irq_base;
 
 	for (irq = irq_base; irq < irq_base + T7L66XB_NR_IRQS; irq++) {
-		set_irq_chip(irq, &t7l66xb_chip);
-		set_irq_chip_data(irq, t7l66xb);
-		set_irq_handler(irq, handle_level_irq);
+		irq_set_chip(irq, &t7l66xb_chip);
+		irq_set_chip_data(irq, t7l66xb);
+		irq_set_handler(irq, handle_level_irq);
 #ifdef CONFIG_ARM
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 #endif
 	}
 
-	set_irq_type(t7l66xb->irq, IRQ_TYPE_EDGE_FALLING);
-	set_irq_data(t7l66xb->irq, t7l66xb);
-	set_irq_chained_handler(t7l66xb->irq, t7l66xb_irq);
+	irq_set_irq_type(t7l66xb->irq, IRQ_TYPE_EDGE_FALLING);
+	irq_set_handler_data(t7l66xb->irq, t7l66xb);
+	irq_set_chained_handler(t7l66xb->irq, t7l66xb_irq);
 }
 
 static void t7l66xb_detach_irq(struct platform_device *dev)
@@ -263,15 +263,15 @@ static void t7l66xb_detach_irq(struct pl
 
 	irq_base = t7l66xb->irq_base;
 
-	set_irq_chained_handler(t7l66xb->irq, NULL);
-	set_irq_data(t7l66xb->irq, NULL);
+	irq_set_chained_handler(t7l66xb->irq, NULL);
+	irq_set_handler_data(t7l66xb->irq, NULL);
 
 	for (irq = irq_base; irq < irq_base + T7L66XB_NR_IRQS; irq++) {
 #ifdef CONFIG_ARM
 		set_irq_flags(irq, 0);
 #endif
-		set_irq_chip(irq, NULL);
-		set_irq_chip_data(irq, NULL);
+		irq_set_chip(irq, NULL);
+		irq_set_chip_data(irq, NULL);
 	}
 }
 
Index: linux-2.6-tip/drivers/mfd/tc3589x.c
===================================================================
--- linux-2.6-tip.orig/drivers/mfd/tc3589x.c
+++ linux-2.6-tip/drivers/mfd/tc3589x.c
@@ -192,14 +192,14 @@ static int tc3589x_irq_init(struct tc358
 	int irq;
 
 	for (irq = base; irq < base + TC3589x_NR_INTERNAL_IRQS; irq++) {
-		set_irq_chip_data(irq, tc3589x);
-		set_irq_chip_and_handler(irq, &dummy_irq_chip,
+		irq_set_chip_data(irq, tc3589x);
+		irq_set_chip_and_handler(irq, &dummy_irq_chip,
 					 handle_edge_irq);
-		set_irq_nested_thread(irq, 1);
+		irq_set_nested_thread(irq, 1);
 #ifdef CONFIG_ARM
 		set_irq_flags(irq, IRQF_VALID);
 #else
-		set_irq_noprobe(irq);
+		irq_set_noprobe(irq);
 #endif
 	}
 
@@ -215,8 +215,8 @@ static void tc3589x_irq_remove(struct tc
 #ifdef CONFIG_ARM
 		set_irq_flags(irq, 0);
 #endif
-		set_irq_chip_and_handler(irq, NULL, NULL);
-		set_irq_chip_data(irq, NULL);
+		irq_set_chip_and_handler(irq, NULL, NULL);
+		irq_set_chip_data(irq, NULL);
 	}
 }
 
Index: linux-2.6-tip/drivers/mfd/tc6393xb.c
===================================================================
--- linux-2.6-tip.orig/drivers/mfd/tc6393xb.c
+++ linux-2.6-tip/drivers/mfd/tc6393xb.c
@@ -513,7 +513,7 @@ static int tc6393xb_register_gpio(struct
 static void
 tc6393xb_irq(unsigned int irq, struct irq_desc *desc)
 {
-	struct tc6393xb *tc6393xb = get_irq_data(irq);
+	struct tc6393xb *tc6393xb = irq_get_handler_data(irq);
 	unsigned int isr;
 	unsigned int i, irq_base;
 
@@ -572,15 +572,15 @@ static void tc6393xb_attach_irq(struct p
 	irq_base = tc6393xb->irq_base;
 
 	for (irq = irq_base; irq < irq_base + TC6393XB_NR_IRQS; irq++) {
-		set_irq_chip(irq, &tc6393xb_chip);
-		set_irq_chip_data(irq, tc6393xb);
-		set_irq_handler(irq, handle_edge_irq);
+		irq_set_chip(irq, &tc6393xb_chip);
+		irq_set_chip_data(irq, tc6393xb);
+		irq_set_handler(irq, handle_edge_irq);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 	}
 
-	set_irq_type(tc6393xb->irq, IRQ_TYPE_EDGE_FALLING);
-	set_irq_data(tc6393xb->irq, tc6393xb);
-	set_irq_chained_handler(tc6393xb->irq, tc6393xb_irq);
+	irq_set_irq_type(tc6393xb->irq, IRQ_TYPE_EDGE_FALLING);
+	irq_set_handler_data(tc6393xb->irq, tc6393xb);
+	irq_set_chained_handler(tc6393xb->irq, tc6393xb_irq);
 }
 
 static void tc6393xb_detach_irq(struct platform_device *dev)
@@ -588,15 +588,15 @@ static void tc6393xb_detach_irq(struct p
 	struct tc6393xb *tc6393xb = platform_get_drvdata(dev);
 	unsigned int irq, irq_base;
 
-	set_irq_chained_handler(tc6393xb->irq, NULL);
-	set_irq_data(tc6393xb->irq, NULL);
+	irq_set_chained_handler(tc6393xb->irq, NULL);
+	irq_set_handler_data(tc6393xb->irq, NULL);
 
 	irq_base = tc6393xb->irq_base;
 
 	for (irq = irq_base; irq < irq_base + TC6393XB_NR_IRQS; irq++) {
 		set_irq_flags(irq, 0);
-		set_irq_chip(irq, NULL);
-		set_irq_chip_data(irq, NULL);
+		irq_set_chip(irq, NULL);
+		irq_set_chip_data(irq, NULL);
 	}
 }
 
Index: linux-2.6-tip/drivers/mfd/tps6586x.c
===================================================================
--- linux-2.6-tip.orig/drivers/mfd/tps6586x.c
+++ linux-2.6-tip/drivers/mfd/tps6586x.c
@@ -426,10 +426,10 @@ static int __devinit tps6586x_irq_init(s
 
 	for (i = 0; i < ARRAY_SIZE(tps6586x_irqs); i++) {
 		int __irq = i + tps6586x->irq_base;
-		set_irq_chip_data(__irq, tps6586x);
-		set_irq_chip_and_handler(__irq, &tps6586x->irq_chip,
+		irq_set_chip_data(__irq, tps6586x);
+		irq_set_chip_and_handler(__irq, &tps6586x->irq_chip,
 					 handle_simple_irq);
-		set_irq_nested_thread(__irq, 1);
+		irq_set_nested_thread(__irq, 1);
 #ifdef CONFIG_ARM
 		set_irq_flags(__irq, IRQF_VALID);
 #endif
Index: linux-2.6-tip/drivers/mfd/twl4030-irq.c
===================================================================
--- linux-2.6-tip.orig/drivers/mfd/twl4030-irq.c
+++ linux-2.6-tip/drivers/mfd/twl4030-irq.c
@@ -454,7 +454,7 @@ static inline void activate_irq(int irq)
 	set_irq_flags(irq, IRQF_VALID);
 #else
 	/* same effect on other architectures */
-	set_irq_noprobe(irq);
+	irq_set_noprobe(irq);
 #endif
 }
 
@@ -650,7 +650,7 @@ static inline int sih_read_isr(const str
  */
 static void handle_twl4030_sih(unsigned irq, struct irq_desc *desc)
 {
-	struct sih_agent *agent = get_irq_data(irq);
+	struct sih_agent *agent = irq_get_handler_data(irq);
 	const struct sih *sih = agent->sih;
 	int isr;
 
@@ -724,9 +724,9 @@ int twl4030_sih_setup(int module)
 	for (i = 0; i < sih->bits; i++) {
 		irq = irq_base + i;
 
-		set_irq_chip_and_handler(irq, &twl4030_sih_irq_chip,
-				handle_edge_irq);
-		set_irq_chip_data(irq, agent);
+		irq_set_chip_and_handler(irq, &twl4030_sih_irq_chip,
+					 handle_edge_irq);
+		irq_set_chip_data(irq, agent);
 		activate_irq(irq);
 	}
 
@@ -735,8 +735,8 @@ int twl4030_sih_setup(int module)
 
 	/* replace generic PIH handler (handle_simple_irq) */
 	irq = sih_mod + twl4030_irq_base;
-	set_irq_data(irq, agent);
-	set_irq_chained_handler(irq, handle_twl4030_sih);
+	irq_set_handler_data(irq, agent);
+	irq_set_chained_handler(irq, handle_twl4030_sih);
 
 	pr_info("twl4030: %s (irq %d) chaining IRQs %d..%d\n", sih->name,
 			irq, irq_base, twl4030_irq_next - 1);
@@ -785,8 +785,8 @@ int twl4030_init_irq(int irq_num, unsign
 	twl4030_sih_irq_chip.irq_ack = dummy_irq_chip.irq_ack;
 
 	for (i = irq_base; i < irq_end; i++) {
-		set_irq_chip_and_handler(i, &twl4030_irq_chip,
-				handle_simple_irq);
+		irq_set_chip_and_handler(i, &twl4030_irq_chip,
+					 handle_simple_irq);
 		activate_irq(i);
 	}
 	twl4030_irq_next = i;
@@ -826,7 +826,7 @@ fail_rqirq:
 	/* clean up twl4030_sih_setup */
 fail:
 	for (i = irq_base; i < irq_end; i++)
-		set_irq_chip_and_handler(i, NULL, NULL);
+		irq_set_chip_and_handler(i, NULL, NULL);
 	destroy_workqueue(wq);
 	wq = NULL;
 	return status;
Index: linux-2.6-tip/drivers/mfd/twl6030-irq.c
===================================================================
--- linux-2.6-tip.orig/drivers/mfd/twl6030-irq.c
+++ linux-2.6-tip/drivers/mfd/twl6030-irq.c
@@ -183,7 +183,7 @@ static inline void activate_irq(int irq)
 	set_irq_flags(irq, IRQF_VALID);
 #else
 	/* same effect on other architectures */
-	set_irq_noprobe(irq);
+	irq_set_noprobe(irq);
 #endif
 }
 
@@ -320,8 +320,8 @@ int twl6030_init_irq(int irq_num, unsign
 	twl6030_irq_chip.irq_set_type = NULL;
 
 	for (i = irq_base; i < irq_end; i++) {
-		set_irq_chip_and_handler(i, &twl6030_irq_chip,
-				handle_simple_irq);
+		irq_set_chip_and_handler(i, &twl6030_irq_chip,
+					 handle_simple_irq);
 		activate_irq(i);
 	}
 
@@ -350,7 +350,7 @@ fail_irq:
 
 fail_kthread:
 	for (i = irq_base; i < irq_end; i++)
-		set_irq_chip_and_handler(i, NULL, NULL);
+		irq_set_chip_and_handler(i, NULL, NULL);
 	return status;
 }
 
Index: linux-2.6-tip/drivers/mfd/wm831x-irq.c
===================================================================
--- linux-2.6-tip.orig/drivers/mfd/wm831x-irq.c
+++ linux-2.6-tip/drivers/mfd/wm831x-irq.c
@@ -535,17 +535,17 @@ int wm831x_irq_init(struct wm831x *wm831
 	for (cur_irq = wm831x->irq_base;
 	     cur_irq < ARRAY_SIZE(wm831x_irqs) + wm831x->irq_base;
 	     cur_irq++) {
-		set_irq_chip_data(cur_irq, wm831x);
-		set_irq_chip_and_handler(cur_irq, &wm831x_irq_chip,
+		irq_set_chip_data(cur_irq, wm831x);
+		irq_set_chip_and_handler(cur_irq, &wm831x_irq_chip,
 					 handle_edge_irq);
-		set_irq_nested_thread(cur_irq, 1);
+		irq_set_nested_thread(cur_irq, 1);
 
 		/* ARM needs us to explicitly flag the IRQ as valid
 		 * and will set them noprobe when we do so. */
 #ifdef CONFIG_ARM
 		set_irq_flags(cur_irq, IRQF_VALID);
 #else
-		set_irq_noprobe(cur_irq);
+		irq_set_noprobe(cur_irq);
 #endif
 	}
 
Index: linux-2.6-tip/drivers/mfd/wm8350-irq.c
===================================================================
--- linux-2.6-tip.orig/drivers/mfd/wm8350-irq.c
+++ linux-2.6-tip/drivers/mfd/wm8350-irq.c
@@ -518,17 +518,17 @@ int wm8350_irq_init(struct wm8350 *wm835
 	for (cur_irq = wm8350->irq_base;
 	     cur_irq < ARRAY_SIZE(wm8350_irqs) + wm8350->irq_base;
 	     cur_irq++) {
-		set_irq_chip_data(cur_irq, wm8350);
-		set_irq_chip_and_handler(cur_irq, &wm8350_irq_chip,
+		irq_set_chip_data(cur_irq, wm8350);
+		irq_set_chip_and_handler(cur_irq, &wm8350_irq_chip,
 					 handle_edge_irq);
-		set_irq_nested_thread(cur_irq, 1);
+		irq_set_nested_thread(cur_irq, 1);
 
 		/* ARM needs us to explicitly flag the IRQ as valid
 		 * and will set them noprobe when we do so. */
 #ifdef CONFIG_ARM
 		set_irq_flags(cur_irq, IRQF_VALID);
 #else
-		set_irq_noprobe(cur_irq);
+		irq_set_noprobe(cur_irq);
 #endif
 	}
 
Index: linux-2.6-tip/drivers/mfd/wm8994-irq.c
===================================================================
--- linux-2.6-tip.orig/drivers/mfd/wm8994-irq.c
+++ linux-2.6-tip/drivers/mfd/wm8994-irq.c
@@ -276,17 +276,17 @@ int wm8994_irq_init(struct wm8994 *wm899
 	for (cur_irq = wm8994->irq_base;
 	     cur_irq < ARRAY_SIZE(wm8994_irqs) + wm8994->irq_base;
 	     cur_irq++) {
-		set_irq_chip_data(cur_irq, wm8994);
-		set_irq_chip_and_handler(cur_irq, &wm8994_irq_chip,
+		irq_set_chip_data(cur_irq, wm8994);
+		irq_set_chip_and_handler(cur_irq, &wm8994_irq_chip,
 					 handle_edge_irq);
-		set_irq_nested_thread(cur_irq, 1);
+		irq_set_nested_thread(cur_irq, 1);
 
 		/* ARM needs us to explicitly flag the IRQ as valid
 		 * and will set them noprobe when we do so. */
 #ifdef CONFIG_ARM
 		set_irq_flags(cur_irq, IRQF_VALID);
 #else
-		set_irq_noprobe(cur_irq);
+		irq_set_noprobe(cur_irq);
 #endif
 	}
 


