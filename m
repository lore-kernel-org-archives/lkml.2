Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576Ab0E1Pdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 11:33:50 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:60719 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756739Ab0E1Pdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 11:33:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=DNonx3NofVTeRqBuMAZxK5Lw2fOox5gTzIewV0IVh4qbFdSl8MoGbWI91YjzUc/lQY
         a5JqO0X/YC3ZIPiMQ/kLa+i9ezJyKeZeg+cpmSvyP7itw8hH6Ccr3YqyciDj2cF2gekJ
         Oz9f2waLJoMVQ8pFaVsOdA2Xi6jeBVQ/IAEKI=
From: John Sheehan <john.d.sheehan@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu, roel.kluin@gmail.com, jkosina@suse.cz,
       john.d.sheehan@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Staging: comedi: fix code warnings in s626.c
Date: Fri, 28 May 2010 16:33:25 +0100
Message-Id: <1275060805-18489-1-git-send-email-john.d.sheehan@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Sheehan <john.d.sheehan@gmail.com>

A patch for s626.c to fix some of the warnings
reported by the checkpatch.pl tool, namely,
printk() should include KERN_ facility level
unnecessary whitespace before a quoted newline

Signed-off-by: John Sheehan <john.d.sheehan@gmail.com>
---
 drivers/staging/comedi/drivers/s626.c |   38 ++++++++++++++++----------------
 1 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index 83e1bb1..b63325c 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -543,13 +543,13 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	devpriv->pdev = pdev;
 
 	if (pdev == NULL) {
-		printk("s626_attach: Board not present!!!\n");
+		printk(KERN_ERR "s626_attach: Board not present!!!\n");
 		return -ENODEV;
 	}
 
 	result = comedi_pci_enable(pdev, "s626");
 	if (result < 0) {
-		printk("s626_attach: comedi_pci_enable fails\n");
+		printk(KERN_ERR "s626_attach: comedi_pci_enable fails\n");
 		return -ENODEV;
 	}
 	devpriv->got_regions = 1;
@@ -558,7 +558,7 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	devpriv->base_addr = ioremap(resourceStart, SIZEOF_ADDRESS_SPACE);
 	if (devpriv->base_addr == NULL) {
-		printk("s626_attach: IOREMAP failed\n");
+		printk(KERN_ERR "s626_attach: IOREMAP failed\n");
 		return -ENODEV;
 	}
 
@@ -579,7 +579,7 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		    pci_alloc_consistent(devpriv->pdev, DMABUF_SIZE, &appdma);
 
 		if (devpriv->ANABuf.LogicalBase == NULL) {
-			printk("s626_attach: DMA Memory mapping error\n");
+			printk(KERN_ERR "s626_attach: DMA Memory mapping error\n");
 			return -ENOMEM;
 		}
 
@@ -596,7 +596,7 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		    pci_alloc_consistent(devpriv->pdev, DMABUF_SIZE, &appdma);
 
 		if (devpriv->RPSBuf.LogicalBase == NULL) {
-			printk("s626_attach: DMA Memory mapping error\n");
+			printk(KERN_ERR "s626_attach: DMA Memory mapping error\n");
 			return -ENOMEM;
 		}
 
@@ -622,18 +622,18 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	/* set up interrupt handler */
 	if (dev->irq == 0) {
-		printk(" unknown irq (bad)\n");
+		printk(KERN_ERR " unknown irq (bad)\n");
 	} else {
 		ret = request_irq(dev->irq, s626_irq_handler, IRQF_SHARED,
 				  "s626", dev);
 
 		if (ret < 0) {
-			printk(" irq not available\n");
+			printk(KERN_ERR " irq not available\n");
 			dev->irq = 0;
 		}
 	}
 
-	DEBUG("s626_attach: -- it opts  %d,%d -- \n",
+	DEBUG("s626_attach: -- it opts  %d,%d --\n",
 	      it->options[0], it->options[1]);
 
 	s = dev->subdevices + 0;
@@ -1515,7 +1515,7 @@ void ResetADC(struct comedi_device *dev, uint8_t * ppl)
 			break;	/*  Exit poll list processing loop. */
 		}
 	}
-	DEBUG("ResetADC: ADC items %d \n", devpriv->AdcItems);
+	DEBUG("ResetADC: ADC items %d\n", devpriv->AdcItems);
 
 	/* VERSION 2.01 CHANGE: DELAY CHANGED FROM 250NS to 2US.  Allow the
 	 * ADC to stabilize for 2 microseconds before starting the final
@@ -1576,7 +1576,7 @@ static int s626_ai_insn_config(struct comedi_device *dev,
 /*   register uint8_t	i; */
 /*   register int32_t	*readaddr; */
 
-/*   DEBUG("as626_ai_rinsn: ai_rinsn enter \n");  */
+/*   DEBUG("as626_ai_rinsn: ai_rinsn enter\n");  */
 
 /*   Trigger ADC scan loop start by setting RPS Signal 0. */
 /*   MC_ENABLE( P_MC2, MC2_ADC_RPS ); */
@@ -1593,11 +1593,11 @@ static int s626_ai_insn_config(struct comedi_device *dev,
 /*  Convert ADC data to 16-bit integer values and copy to application buffer. */
 /*   for ( i = 0; i < devpriv->AdcItems; i++ ) { */
 /*     *data = s626_ai_reg_to_uint( *readaddr++ ); */
-/*     DEBUG("s626_ai_rinsn: data %d \n",*data); */
+/*     DEBUG("s626_ai_rinsn: data %d\n",*data); */
 /*     data++; */
 /*   } */
 
-/*   DEBUG("s626_ai_rinsn: ai_rinsn escape \n"); */
+/*   DEBUG("s626_ai_rinsn: ai_rinsn escape\n"); */
 /*   return i; */
 /* } */
 
@@ -1747,7 +1747,7 @@ static int s626_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	DEBUG("s626_ai_cmd: entering command function\n");
 
 	if (devpriv->ai_cmd_running) {
-		printk("s626_ai_cmd: Another ai_cmd is running %d\n",
+		printk(KERN_ERR "s626_ai_cmd: Another ai_cmd is running %d\n",
 		       dev->minor);
 		return -EBUSY;
 	}
@@ -2151,7 +2151,7 @@ static void s626_dio_init(struct comedi_device *dev)
 		DEBIwrite(dev, diopriv->WRDOut, 0);	/*  Program all outputs */
 		/*  to inactive state. */
 	}
-	DEBUG("s626_dio_init: DIO initialized \n");
+	DEBUG("s626_dio_init: DIO initialized\n");
 }
 
 /* DIO devices are slightly special.  Although it is possible to
@@ -2350,7 +2350,7 @@ static int s626_enc_insn_read(struct comedi_device *dev,
 	int n;
 	struct enc_private *k = &encpriv[CR_CHAN(insn->chanspec)];
 
-	DEBUG("s626_enc_insn_read: encoder read channel %d \n",
+	DEBUG("s626_enc_insn_read: encoder read channel %d\n",
 	      CR_CHAN(insn->chanspec));
 
 	for (n = 0; n < insn->n; n++)
@@ -2368,7 +2368,7 @@ static int s626_enc_insn_write(struct comedi_device *dev,
 
 	struct enc_private *k = &encpriv[CR_CHAN(insn->chanspec)];
 
-	DEBUG("s626_enc_insn_write: encoder write channel %d \n",
+	DEBUG("s626_enc_insn_write: encoder write channel %d\n",
 	      CR_CHAN(insn->chanspec));
 
 	/*  Set the preload register */
@@ -3110,12 +3110,12 @@ static uint16_t GetEnable_B(struct comedi_device *dev, struct enc_private *k)
 static void SetLatchSource(struct comedi_device *dev, struct enc_private *k,
 			   uint16_t value)
 {
-	DEBUG("SetLatchSource: SetLatchSource enter 3550 \n");
+	DEBUG("SetLatchSource: SetLatchSource enter 3550\n");
 	DEBIreplace(dev, k->MyCRB,
 		    (uint16_t) (~(CRBMSK_INTCTRL | CRBMSK_LATCHSRC)),
 		    (uint16_t) (value << CRBBIT_LATCHSRC));
 
-	DEBUG("SetLatchSource: SetLatchSource exit \n");
+	DEBUG("SetLatchSource: SetLatchSource exit\n");
 }
 
 /*
@@ -3328,6 +3328,6 @@ static void CountersInit(struct comedi_device *dev)
 		k->ResetCapFlags(dev, k);
 		k->SetEnable(dev, k, CLKENAB_ALWAYS);
 	}
-	DEBUG("CountersInit: counters initialized \n");
+	DEBUG("CountersInit: counters initialized\n");
 
 }
-- 
1.7.0.4

