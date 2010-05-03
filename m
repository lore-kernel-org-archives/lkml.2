Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493Ab0ECKzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 06:55:18 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42257 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757466Ab0ECKzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 06:55:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=AnG2mS49sePpr6B3WgdBoGeCQY5fosobV8zLE1xULDR0WBfc/xbB557X5xZG+KWB/x
         xQJxPllgq6iun3bs7gLdD1ZMvzYMZWutZqKMTGcEOku0YtgnBU+3QNNn3JRvMWtBnxZ4
         zfNDxYs340bSIpQINdKNHrZwmYZuvpyfLoeds=
From: Iain Churcher <iain.linux.coding@googlemail.com>
To: iain.linux.coding@googlemail.com, gregkh@suse.de, wfp5p@virginia.edu,
       jkosina@suse.cz, mithlesh@linsyssoft.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: comedi: Fix all checkpatch.pl issues in dt2811.c Patch resolves all checkpatch.pl isues in dt2811.c
Date: Mon,  3 May 2010 11:54:53 +0100
Message-Id: <1272884093-4486-1-git-send-email-iain.linux.coding@googlemail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Iain Churcher <iain.linux.coding@googlemail.com>
---
 drivers/staging/comedi/drivers/dt2811.c |  191 ++++++++++++-------------------
 1 files changed, 76 insertions(+), 115 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dt2811.c b/drivers/staging/comedi/drivers/dt2811.c
index 51ef695..ea9bfb7 100644
--- a/drivers/staging/comedi/drivers/dt2811.c
+++ b/drivers/staging/comedi/drivers/dt2811.c
@@ -34,13 +34,13 @@ Configuration options:
   [0] - I/O port base address
   [1] - IRQ, although this is currently unused
   [2] - A/D reference
-          0 = signle-ended
-          1 = differential
+	  0 = signle-ended
+	  1 = differential
 	  2 = pseudo-differential (common reference)
   [3] - A/D range
-          0 = [-5,5]
-	  1 = [-2.5,2.5]
-	  2 = [0,5]
+	  0 = [-5, 5]
+	  1 = [-2.5, 2.5]
+	  2 = [0, 5]
   [4] - D/A 0 range (same choices)
   [4] - D/A 1 range (same choices)
 */
@@ -52,96 +52,58 @@ Configuration options:
 
 static const char *driver_name = "dt2811";
 
-static const struct comedi_lrange range_dt2811_pgh_ai_5_unipolar = { 4, {
-									 RANGE
-									 (0, 5),
-									 RANGE
-									 (0,
-									  2.5),
-									 RANGE
-									 (0,
-									  1.25),
-									 RANGE
-									 (0,
-									  0.625)
-									 }
+static const struct comedi_lrange range_dt2811_pgh_ai_5_unipolar = {
+	4, {
+		RANGE(0, 5),
+		RANGE(0, 2.5),
+		RANGE(0, 1.25),
+		RANGE(0, 0.625)
+	}
 };
 
-static const struct comedi_lrange range_dt2811_pgh_ai_2_5_bipolar = { 4, {
-									  RANGE
-									  (-2.5,
-									   2.5),
-									  RANGE
-									  (-1.25,
-									   1.25),
-									  RANGE
-									  (-0.625,
-									   0.625),
-									  RANGE
-									  (-0.3125,
-									   0.3125)
-									  }
+static const struct comedi_lrange range_dt2811_pgh_ai_2_5_bipolar = {
+	4, {
+		RANGE(-2.5, 2.5),
+		RANGE(-1.25, 1.25),
+		RANGE(-0.625, 0.625),
+		RANGE(-0.3125, 0.3125)
+	}
 };
 
-static const struct comedi_lrange range_dt2811_pgh_ai_5_bipolar = { 4, {
-									RANGE
-									(-5, 5),
-									RANGE
-									(-2.5,
-									 2.5),
-									RANGE
-									(-1.25,
-									 1.25),
-									RANGE
-									(-0.625,
-									 0.625)
-									}
+static const struct comedi_lrange range_dt2811_pgh_ai_5_bipolar = {
+	4, {
+		RANGE(-5, 5),
+		RANGE(-2.5, 2.5),
+		RANGE(-1.25, 1.25),
+		RANGE(-0.625, 0.625)
+	}
 };
 
-static const struct comedi_lrange range_dt2811_pgl_ai_5_unipolar = { 4, {
-									 RANGE
-									 (0, 5),
-									 RANGE
-									 (0,
-									  0.5),
-									 RANGE
-									 (0,
-									  0.05),
-									 RANGE
-									 (0,
-									  0.01)
-									 }
+static const struct comedi_lrange range_dt2811_pgl_ai_5_unipolar = {
+	4, {
+		RANGE(0, 5),
+		RANGE(0, 0.5),
+		RANGE(0, 0.05),
+		RANGE(0, 0.01)
+	}
 };
 
-static const struct comedi_lrange range_dt2811_pgl_ai_2_5_bipolar = { 4, {
-									  RANGE
-									  (-2.5,
-									   2.5),
-									  RANGE
-									  (-0.25,
-									   0.25),
-									  RANGE
-									  (-0.025,
-									   0.025),
-									  RANGE
-									  (-0.005,
-									   0.005)
-									  }
+static const struct comedi_lrange range_dt2811_pgl_ai_2_5_bipolar = {
+	4, {
+		RANGE(-2.5, 2.5),
+		RANGE(-0.25, 0.25),
+		RANGE(-0.025, 0.025),
+		RANGE(-0.005, 0.005)
+	}
 };
 
-static const struct comedi_lrange range_dt2811_pgl_ai_5_bipolar = { 4, {
-									RANGE
-									(-5, 5),
-									RANGE
-									(-0.5,
-									 0.5),
-									RANGE
-									(-0.05,
-									 0.05),
-									RANGE
-									(-0.01,
-									 0.01)
-									}
+static const struct comedi_lrange range_dt2811_pgl_ai_5_bipolar = {
+	4, {
+		RANGE(-5, 5),
+		RANGE(-0.5, 0.5),
+		RANGE(-0.05, 0.05),
+		RANGE(-0.01, 0.01)
+	}
 };
 
 /*
@@ -348,21 +310,21 @@ static irqreturn_t dt2811_interrupt(int irq, void *d)
   options[0]   Board base address
   options[1]   IRQ
   options[2]   Input configuration
-                 0 == single-ended
-                 1 == differential
-                 2 == pseudo-differential
+		 0 == single-ended
+		 1 == differential
+		 2 == pseudo-differential
   options[3]   Analog input range configuration
-                 0 == bipolar 5  (-5V -- +5V)
-                 1 == bipolar 2.5V  (-2.5V -- +2.5V)
-                 2 == unipolar 5V  (0V -- +5V)
+		 0 == bipolar 5  (-5V -- +5V)
+		 1 == bipolar 2.5V  (-2.5V -- +2.5V)
+		 2 == unipolar 5V  (0V -- +5V)
   options[4]   Analog output 0 range configuration
-                 0 == bipolar 5  (-5V -- +5V)
-                 1 == bipolar 2.5V  (-2.5V -- +2.5V)
-                 2 == unipolar 5V  (0V -- +5V)
+		 0 == bipolar 5  (-5V -- +5V)
+		 1 == bipolar 2.5V  (-2.5V -- +2.5V)
+		 2 == unipolar 5V  (0V -- +5V)
   options[5]   Analog output 1 range configuration
-                 0 == bipolar 5  (-5V -- +5V)
-                 1 == bipolar 2.5V  (-2.5V -- +2.5V)
-                 2 == unipolar 5V  (0V -- +5V)
+		 0 == bipolar 5  (-5V -- +5V)
+		 1 == bipolar 2.5V  (-2.5V -- +2.5V)
+		 2 == unipolar 5V  (0V -- +5V)
 */
 
 static int dt2811_attach(struct comedi_device *dev, struct comedi_devconfig *it)
@@ -377,10 +339,10 @@ static int dt2811_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	iobase = it->options[0];
 
-	printk("comedi%d: dt2811: base=0x%04lx\n", dev->minor, iobase);
+	printk(KERN_INFO "comedi%d: dt2811:base=0x%04lx\n", dev->minor, iobase);
 
 	if (!request_region(iobase, DT2811_SIZE, driver_name)) {
-		printk("I/O port conflict\n");
+		printk(KERN_ERR "I/O port conflict\n");
 		return -EIO;
 	}
 
@@ -410,25 +372,25 @@ static int dt2811_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		irq = probe_irq_off(irqs);
 		restore_flags(flags);
 
-		/*outb(DT2811_CLRERROR|DT2811_INTENB,dev->iobase+DT2811_ADCSR); */
+		/*outb(DT2811_CLRERROR|DT2811_INTENB,
+			dev->iobase+DT2811_ADCSR);*/
 
-		if (inb(dev->iobase + DT2811_ADCSR) & DT2811_ADERROR) {
-			printk("error probing irq (bad) \n");
-		}
+		if (inb(dev->iobase + DT2811_ADCSR) & DT2811_ADERROR)
+			printk(KERN_ERR "error probing irq (bad)\n");
 		dev->irq = 0;
 		if (irq > 0) {
 			i = inb(dev->iobase + DT2811_ADDATLO);
 			i = inb(dev->iobase + DT2811_ADDATHI);
-			printk("(irq = %d)\n", irq);
+			printk(KERN_INFO "(irq = %d)\n", irq);
 			ret = request_irq(irq, dt2811_interrupt, 0,
 					  driver_name, dev);
 			if (ret < 0)
 				return -EIO;
 			dev->irq = irq;
 		} else if (irq == 0) {
-			printk("(no irq)\n");
+			printk(KERN_INFO "(no irq)\n");
 		} else {
-			printk("( multiple irq's -- this is bad! )\n");
+			printk(KERN_ERR "( multiple irq's -- this is bad! )\n");
 		}
 	}
 #endif
@@ -540,14 +502,12 @@ static int dt2811_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static int dt2811_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: dt2811: remove\n", dev->minor);
+	printk(KERN_INFO "comedi%d: dt2811: remove\n", dev->minor);
 
-	if (dev->irq) {
+	if (dev->irq)
 		free_irq(dev->irq, dev);
-	}
-	if (dev->iobase) {
+	if (dev->iobase)
 		release_region(dev->iobase, DT2811_SIZE);
-	}
 
 	return 0;
 }
@@ -579,7 +539,7 @@ static int dt2811_ai_insn(struct comedi_device *dev, struct comedi_subdevice *s,
 #if 0
 /* Wow.  This is code from the Comedi stone age.  But it hasn't been
  * replaced, so I'll let it stay. */
-int dt2811_adtrig(kdev_t minor, comedi_adtrig * adtrig)
+int dt2811_adtrig(kdev_t minor, comedi_adtrig *adtrig)
 {
 	struct comedi_device *dev = comedi_devices + minor;
 
@@ -589,8 +549,10 @@ int dt2811_adtrig(kdev_t minor, comedi_adtrig * adtrig)
 	switch (dev->i_admode) {
 	case COMEDI_MDEMAND:
 		dev->ntrig = adtrig->n - 1;
+		/* not neccessary */
 		/*printk("dt2811: AD soft trigger\n"); */
-		/*outb(DT2811_CLRERROR|DT2811_INTENB,dev->iobase+DT2811_ADCSR); *//* not neccessary */
+		/*outb(DT2811_CLRERROR|DT2811_INTENB,
+			dev->iobase+DT2811_ADCSR); */
 		outb(dev->curadchan, dev->iobase + DT2811_ADGCR);
 		do_gettimeofday(&trigtime);
 		break;
@@ -630,9 +592,8 @@ static int dt2811_ao_insn_read(struct comedi_device *dev,
 
 	chan = CR_CHAN(insn->chanspec);
 
-	for (i = 0; i < insn->n; i++) {
+	for (i = 0; i < insn->n; i++)
 		data[i] = devpriv->ao_readback[chan];
-	}
 
 	return i;
 }
-- 
1.7.0.4

