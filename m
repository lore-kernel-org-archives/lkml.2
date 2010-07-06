Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab0GFS0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 14:26:14 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33250 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab0GFS0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 14:26:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=D6AHRWA8/c6BkF7Xsgsw4YUv8Y9/gzwwnS1kB8iE62pLvS2+XoA9ZCvl2iIsy1JiJn
         7XM48UzYQ2AFiiC3LIHk/TEsC31SysDAtzkgUus4s/v/Smo2Uy8sbsrO1cPoFTHDvFao
         E7+A3LeWD9zwCBkdmgTgbH2WvtVnERHx4mwqc=
From: Mark <reodge@gmail.com>
To: gregkh@suse.de
Cc: Mark <reodge@gmail.com>, Arun Thomas <arun.thomas@gmail.com>,
       Andrea Gelmini <andrea.gelmini@gelma.net>,
       Jiri Kosina <jkosina@suse.cz>,
       Mithlesh Thukral <mithlesh@linsyssoft.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: comedi: Cleanup on dmm32at.c from checkpatch.pl
Date: Tue,  6 Jul 2010 18:23:15 +0100
Message-Id: <1278436995-28347-1-git-send-email-reodge@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up some style issues in dmm32at.c as found by checkpatch.pl

Signed-off-by: Mark Rankilor <reodge@gmail.com>
---
 drivers/staging/comedi/drivers/dmm32at.c |   45 ++++++++++++++++-------------
 1 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dmm32at.c b/drivers/staging/comedi/drivers/dmm32at.c
index 9573223..693728e 100644
--- a/drivers/staging/comedi/drivers/dmm32at.c
+++ b/drivers/staging/comedi/drivers/dmm32at.c
@@ -299,12 +299,14 @@ static int dmm32at_attach(struct comedi_device *dev,
 	iobase = it->options[0];
 	irq = it->options[1];
 
-	printk("comedi%d: dmm32at: attaching\n", dev->minor);
-	printk("dmm32at: probing at address 0x%04lx, irq %u\n", iobase, irq);
+	printk(KERN_INFO "comedi%d: dmm32at: attaching\n", dev->minor);
+	printk(KERN_DEBUG "dmm32at: probing at address 0x%04lx, irq %u\n",
+	       iobase, irq);
 
 	/* register address space */
 	if (!request_region(iobase, DMM32AT_MEMSIZE, thisboard->name)) {
-		printk("I/O port conflict\n");
+		printk(KERN_ERR "comedi%d: dmm32at: I/O port conflict\n",
+		       dev->minor);
 		return -EIO;
 	}
 	dev->iobase = iobase;
@@ -342,14 +344,15 @@ static int dmm32at_attach(struct comedi_device *dev,
 	intstat = dmm_inb(dev, DMM32AT_INTCLOCK);
 	airback = dmm_inb(dev, DMM32AT_AIRBACK);
 
-	printk("dmm32at: lo=0x%02x hi=0x%02x fifostat=0x%02x\n",
+	printk(KERN_DEBUG "dmm32at: lo=0x%02x hi=0x%02x fifostat=0x%02x\n",
 	       ailo, aihi, fifostat);
-	printk("dmm32at: aistat=0x%02x intstat=0x%02x airback=0x%02x\n",
+	printk(KERN_DEBUG
+	       "dmm32at: aistat=0x%02x intstat=0x%02x airback=0x%02x\n",
 	       aistat, intstat, airback);
 
 	if ((ailo != 0x00) || (aihi != 0x1f) || (fifostat != 0x80) ||
 	    (aistat != 0x60 || (intstat != 0x00) || airback != 0x0c)) {
-		printk("dmmat32: board detection failed\n");
+		printk(KERN_ERR "dmmat32: board detection failed\n");
 		return -EIO;
 	}
 
@@ -357,7 +360,7 @@ static int dmm32at_attach(struct comedi_device *dev,
 	if (irq) {
 		ret = request_irq(irq, dmm32at_isr, 0, thisboard->name, dev);
 		if (ret < 0) {
-			printk("irq conflict\n");
+			printk(KERN_ERR "dmm32at: irq conflict\n");
 			return ret;
 		}
 		dev->irq = irq;
@@ -441,7 +444,7 @@ static int dmm32at_attach(struct comedi_device *dev,
 	}
 
 	/* success */
-	printk("comedi%d: dmm32at: attached\n", dev->minor);
+	printk(KERN_INFO "comedi%d: dmm32at: attached\n", dev->minor);
 
 	return 1;
 
@@ -457,7 +460,7 @@ static int dmm32at_attach(struct comedi_device *dev,
  */
 static int dmm32at_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: dmm32at: remove\n", dev->minor);
+	printk(KERN_INFO "comedi%d: dmm32at: remove\n", dev->minor);
 	if (dev->irq)
 		free_irq(dev->irq, dev);
 	if (dev->iobase)
@@ -505,7 +508,7 @@ static int dmm32at_ai_rinsn(struct comedi_device *dev,
 			break;
 	}
 	if (i == 40000) {
-		printk("timeout\n");
+		printk(KERN_WARNING "dmm32at: timeout\n");
 		return -ETIMEDOUT;
 	}
 
@@ -520,7 +523,7 @@ static int dmm32at_ai_rinsn(struct comedi_device *dev,
 				break;
 		}
 		if (i == 40000) {
-			printk("timeout\n");
+			printk(KERN_WARNING "dmm32at: timeout\n");
 			return -ETIMEDOUT;
 		}
 
@@ -590,7 +593,8 @@ static int dmm32at_ai_cmdtest(struct comedi_device *dev,
 	if (err)
 		return 1;
 
-	/* step 2: make sure trigger sources are unique and mutually compatible */
+	/* step 2: make sure trigger sources are unique and mutually
+	 * compatible */
 
 	/* note that mutual compatibility is not an issue here */
 	if (cmd->scan_begin_src != TRIG_TIMER &&
@@ -763,7 +767,8 @@ static int dmm32at_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	if (cmd->stop_src == TRIG_COUNT)
 		devpriv->ai_scans_left = cmd->stop_arg;
 	else {			/* TRIG_NONE */
-		devpriv->ai_scans_left = 0xffffffff;	/* indicates TRIG_NONE to isr */
+		devpriv->ai_scans_left = 0xffffffff; /* indicates TRIG_NONE to
+						      * isr */
 	}
 
 	/* wait for circuit to settle */
@@ -773,7 +778,7 @@ static int dmm32at_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 			break;
 	}
 	if (i == 40000) {
-		printk("timeout\n");
+		printk(KERN_WARNING "dmm32at: timeout\n");
 		return -ETIMEDOUT;
 	}
 
@@ -786,13 +791,13 @@ static int dmm32at_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		dmm_outb(dev, DMM32AT_CONV, 0xff);
 	}
 
-/* 	printk("dmmat32 in command\n"); */
+/*	printk("dmmat32 in command\n"); */
 
-/* 	for(i=0;i<cmd->chanlist_len;i++) */
-/* 		comedi_buf_put(s->async,i*100); */
+/*	for(i=0;i<cmd->chanlist_len;i++) */
+/*		comedi_buf_put(s->async,i*100); */
 
-/* 	s->async->events |= COMEDI_CB_EOA; */
-/* 	comedi_event(dev, s); */
+/*	s->async->events |= COMEDI_CB_EOA; */
+/*	comedi_event(dev, s); */
 
 	return 0;
 
@@ -900,7 +905,7 @@ static int dmm32at_ao_winsn(struct comedi_device *dev,
 				break;
 		}
 		if (i == 40000) {
-			printk("timeout\n");
+			printk(KERN_WARNING "dmm32at: timeout\n");
 			return -ETIMEDOUT;
 		}
 		/* dummy read to update trigger the output */
-- 
1.7.1

