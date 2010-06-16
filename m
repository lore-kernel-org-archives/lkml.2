Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab0FPFR7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 01:17:59 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61036 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831Ab0FPFR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 01:17:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DkUVl0gmp0/HT7HdSu4iVaHyHBugyRNkSjy/Sy+D3/1oCCf627WuusEoPOOPVe8a0r
         ItMEn4VX7mAc2O7QwrOGXZ8cDz9b/cQHwjeLHz/f/MitmZZsiq/45Phq04WrIateo3Fu
         1Ge0jWNJHrPjwTOyvSB19Tdy6y3QojfYRFLbY=
From: Gustavo Silva <silvagustavosilva@gmail.com>
To: gregkh@suse.de, abbotti@mev.co.uk
Cc: wfp5p@virginia.edu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org,
       Gustavo Silva <silvagustavo@users.sourceforge.net>
Subject: [PATCH] Staging: comedi: drivers: fix coding style issues in pcl816.c
Date: Wed, 16 Jun 2010 00:17:52 -0500
Message-Id: <1276665472-8616-1-git-send-email-silvagustavo@users.sourceforge.net>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the pcl816.c file that fixes up the following
issues:

ERROR: code indent should use tabs where possible		   x  2
WARNING: line over 80 characters				   x 34
WARNING: please, no space before tabs				   x  1
WARNING: braces {} are not necessary for single statement blocks   x  6
WARNING: printk() should include KERN_ facility level		   x 15
WARNING: braces {} are not necessary for any arm of this statement x  1

Signed-off-by: Gustavo Silva <silvagustavo@users.sourceforge.net>
---
 drivers/staging/comedi/drivers/pcl816.c |  223 +++++++++++++++++++------------
 1 files changed, 140 insertions(+), 83 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl816.c b/drivers/staging/comedi/drivers/pcl816.c
index 71c2a3a..4bfdda7 100644
--- a/drivers/staging/comedi/drivers/pcl816.c
+++ b/drivers/staging/comedi/drivers/pcl816.c
@@ -2,7 +2,7 @@
    comedi/drivers/pcl816.c
 
    Author:  Juan Grigera <juan@grigera.com.ar>
-            based on pcl818 by Michal Dobes <dobes@tesnet.cz> and bits of pcl812
+	    based on pcl818 by Michal Dobes <dobes@tesnet.cz> and bits of pcl812
 
    hardware driver for Advantech cards:
     card:   PCL-816, PCL814B
@@ -28,7 +28,7 @@ Configuration Options:
   [1] - IRQ	(0=disable, 2, 3, 4, 5, 6, 7)
   [2] - DMA	(0=disable, 1, 3)
   [3] - 0, 10=10MHz clock for 8254
-            1= 1MHz clock for 8254
+	    1= 1MHz clock for 8254
 
 */
 
@@ -85,7 +85,7 @@ Configuration Options:
 #define INT_TYPE_AI3_DMA_RTC 10
 
 /* RTC stuff... */
-#define RTC_IRQ 	8
+#define RTC_IRQ		8
 #define RTC_IO_EXTENT	0x10
 #endif
 
@@ -253,7 +253,8 @@ static int pcl816_ai_insn_read(struct comedi_device *dev,
 
 	/*  Set the input channel */
 	outb(CR_CHAN(insn->chanspec) & 0xf, dev->iobase + PCL816_MUX);
-	outb(CR_RANGE(insn->chanspec), dev->iobase + PCL816_RANGE);	/* select gain */
+	/* select gain */
+	outb(CR_RANGE(insn->chanspec), dev->iobase + PCL816_RANGE);
 
 	for (n = 0; n < insn->n; n++) {
 
@@ -268,8 +269,8 @@ static int pcl816_ai_insn_read(struct comedi_device *dev,
 				    ((inb(dev->iobase +
 					  PCL816_AD_HI) << 8) |
 				     (inb(dev->iobase + PCL816_AD_LO)));
-
-				outb(0, dev->iobase + PCL816_CLRINT);	/* clear INT (conversion end) flag */
+				/* clear INT (conversion end) flag */
+				outb(0, dev->iobase + PCL816_CLRINT);
 				break;
 			}
 			udelay(1);
@@ -278,7 +279,8 @@ static int pcl816_ai_insn_read(struct comedi_device *dev,
 		if (!timeout) {
 			comedi_error(dev, "A/D insn timeout\n");
 			data[0] = 0;
-			outb(0, dev->iobase + PCL816_CLRINT);	/* clear INT (conversion end) flag */
+			/* clear INT (conversion end) flag */
+			outb(0, dev->iobase + PCL816_CLRINT);
 			return -EIO;
 		}
 
@@ -332,7 +334,8 @@ static irqreturn_t interrupt_pcl816_ai_mode13_int(int irq, void *d)
 	}
 
 	if (!devpriv->ai_neverending)
-		if (devpriv->ai_act_scan >= devpriv->ai_scans) {	/* all data sampled */
+					/* all data sampled */
+		if (devpriv->ai_act_scan >= devpriv->ai_scans) {
 			/* all data sampled */
 			pcl816_ai_cancel(dev, s);
 			s->async->events |= COMEDI_CB_EOA;
@@ -369,7 +372,8 @@ static void transfer_from_dma_buf(struct comedi_device *dev,
 		}
 
 		if (!devpriv->ai_neverending)
-			if (devpriv->ai_act_scan >= devpriv->ai_scans) {	/*  all data sampled */
+						/*  all data sampled */
+			if (devpriv->ai_act_scan >= devpriv->ai_scans) {
 				pcl816_ai_cancel(dev, s);
 				s->async->events |= COMEDI_CB_EOA;
 				s->async->events |= COMEDI_CB_BLOCK;
@@ -391,7 +395,8 @@ static irqreturn_t interrupt_pcl816_ai_mode13_dma(int irq, void *d)
 	disable_dma(devpriv->dma);
 	this_dma_buf = devpriv->next_dma_buf;
 
-	if ((devpriv->dma_runs_to_end > -1) || devpriv->ai_neverending) {	/*  switch dma bufs */
+	/*  switch dma bufs */
+	if ((devpriv->dma_runs_to_end > -1) || devpriv->ai_neverending) {
 
 		devpriv->next_dma_buf = 1 - devpriv->next_dma_buf;
 		set_dma_mode(devpriv->dma, DMA_MODE_READ);
@@ -467,14 +472,14 @@ static irqreturn_t interrupt_pcl816(int irq, void *d)
 */
 static void pcl816_cmdtest_out(int e, struct comedi_cmd *cmd)
 {
-	printk("pcl816 e=%d startsrc=%x scansrc=%x convsrc=%x\n", e,
+	printk(KERN_INFO "pcl816 e=%d startsrc=%x scansrc=%x convsrc=%x\n", e,
 	       cmd->start_src, cmd->scan_begin_src, cmd->convert_src);
-	printk("pcl816 e=%d startarg=%d scanarg=%d convarg=%d\n", e,
+	printk(KERN_INFO "pcl816 e=%d startarg=%d scanarg=%d convarg=%d\n", e,
 	       cmd->start_arg, cmd->scan_begin_arg, cmd->convert_arg);
-	printk("pcl816 e=%d stopsrc=%x scanend=%x\n", e, cmd->stop_src,
-	       cmd->scan_end_src);
-	printk("pcl816 e=%d stoparg=%d scanendarg=%d chanlistlen=%d\n", e,
-	       cmd->stop_arg, cmd->scan_end_arg, cmd->chanlist_len);
+	printk(KERN_INFO "pcl816 e=%d stopsrc=%x scanend=%x\n", e,
+	       cmd->stop_src, cmd->scan_end_src);
+	printk(KERN_INFO "pcl816 e=%d stoparg=%d scanendarg=%d chanlistlen=%d\n",
+	       e, cmd->stop_arg, cmd->scan_end_arg, cmd->chanlist_len);
 }
 
 /*
@@ -486,8 +491,9 @@ static int pcl816_ai_cmdtest(struct comedi_device *dev,
 	int err = 0;
 	int tmp, divisor1 = 0, divisor2 = 0;
 
-	DEBUG(printk("pcl816 pcl812_ai_cmdtest\n"); pcl816_cmdtest_out(-1, cmd);
-	    );
+	DEBUG(printk(KERN_INFO "pcl816 pcl812_ai_cmdtest\n");
+	      pcl816_cmdtest_out(-1, cmd);
+	     );
 
 	/* step 1: make sure trigger sources are trivially valid */
 	tmp = cmd->start_src;
@@ -515,11 +521,14 @@ static int pcl816_ai_cmdtest(struct comedi_device *dev,
 	if (!cmd->stop_src || tmp != cmd->stop_src)
 		err++;
 
-	if (err) {
+	if (err)
 		return 1;
-	}
 
-	/* step 2: make sure trigger sources are unique and mutually compatible */
+
+	/*
+	 * step 2: make sure trigger sources
+	 * are unique and mutually compatible
+	 */
 
 	if (cmd->start_src != TRIG_NOW) {
 		cmd->start_src = TRIG_NOW;
@@ -544,9 +553,9 @@ static int pcl816_ai_cmdtest(struct comedi_device *dev,
 	if (cmd->stop_src != TRIG_NONE && cmd->stop_src != TRIG_COUNT)
 		err++;
 
-	if (err) {
+	if (err)
 		return 2;
-	}
+
 
 	/* step 3: make sure arguments are trivially compatible */
 	if (cmd->start_arg != 0) {
@@ -586,9 +595,9 @@ static int pcl816_ai_cmdtest(struct comedi_device *dev,
 		}
 	}
 
-	if (err) {
+	if (err)
 		return 3;
-	}
+
 
 	/* step 4: fix up any arguments */
 	if (cmd->convert_src == TRIG_TIMER) {
@@ -603,9 +612,9 @@ static int pcl816_ai_cmdtest(struct comedi_device *dev,
 			err++;
 	}
 
-	if (err) {
+	if (err)
 		return 4;
-	}
+
 
 	/* step 5: complain about special chanlist considerations */
 
@@ -643,7 +652,9 @@ static int pcl816_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		i8253_cascade_ns_to_timer(this_board->i8254_osc_base, &divisor1,
 					  &divisor2, &cmd->convert_arg,
 					  cmd->flags & TRIG_ROUND_MASK);
-		if (divisor1 == 1) {	/*  PCL816 crash if any divisor is set to 1 */
+
+		/*  PCL816 crash if any divisor is set to 1 */
+		if (divisor1 == 1) {
 			divisor1 = 2;
 			divisor2 /= 2;
 		}
@@ -676,8 +687,10 @@ static int pcl816_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		devpriv->ai_neverending = 1;
 	}
 
-	if ((cmd->flags & TRIG_WAKE_EOS)) {	/*  don't we want wake up every scan? */
-		printk("pl816: You wankt WAKE_EOS but I dont want handle it");
+	/*  don't we want wake up every scan? */
+	if ((cmd->flags & TRIG_WAKE_EOS)) {
+		printk(KERN_INFO
+		       "pl816: You wankt WAKE_EOS but I dont want handle it");
 		/*               devpriv->ai_eos=1; */
 		/* if (devpriv->ai_n_chan==1) */
 		/*       devpriv->dma=0; // DMA is useless for this situation */
@@ -686,9 +699,17 @@ static int pcl816_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	if (devpriv->dma) {
 		bytes = devpriv->hwdmasize[0];
 		if (!devpriv->ai_neverending) {
-			bytes = s->async->cmd.chanlist_len * s->async->cmd.chanlist_len * sizeof(short);	/*  how many */
-			devpriv->dma_runs_to_end = bytes / devpriv->hwdmasize[0];	/*  how many DMA pages we must fill */
-			devpriv->last_dma_run = bytes % devpriv->hwdmasize[0];	/* on last dma transfer must be moved */
+			/*  how many */
+			bytes = s->async->cmd.chanlist_len *
+			s->async->cmd.chanlist_len *
+			sizeof(short);
+
+			/*  how many DMA pages we must fill */
+			devpriv->dma_runs_to_end = bytes /
+			devpriv->hwdmasize[0];
+
+			/* on last dma transfer must be moved */
+			devpriv->last_dma_run = bytes % devpriv->hwdmasize[0];
 			devpriv->dma_runs_to_end--;
 			if (devpriv->dma_runs_to_end >= 0)
 				bytes = devpriv->hwdmasize[0];
@@ -711,14 +732,22 @@ static int pcl816_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	switch (cmd->convert_src) {
 	case TRIG_TIMER:
 		devpriv->int816_mode = INT_TYPE_AI1_DMA;
-		outb(0x32, dev->iobase + PCL816_CONTROL);	/*  Pacer+IRQ+DMA */
-		outb(dmairq, dev->iobase + PCL816_STATUS);	/*  write irq and DMA to card */
+
+		/*  Pacer+IRQ+DMA */
+		outb(0x32, dev->iobase + PCL816_CONTROL);
+
+		/*  write irq and DMA to card */
+		outb(dmairq, dev->iobase + PCL816_STATUS);
 		break;
 
 	default:
 		devpriv->int816_mode = INT_TYPE_AI3_DMA;
-		outb(0x34, dev->iobase + PCL816_CONTROL);	/*  Ext trig+IRQ+DMA */
-		outb(dmairq, dev->iobase + PCL816_STATUS);	/*  write irq to card */
+
+		/*  Ext trig+IRQ+DMA */
+		outb(0x34, dev->iobase + PCL816_CONTROL);
+
+		/*  write irq to card */
+		outb(dmairq, dev->iobase + PCL816_STATUS);
 		break;
 	}
 
@@ -747,7 +776,8 @@ static int pcl816_ai_poll(struct comedi_device *dev, struct comedi_subdevice *s)
 		return 0;
 	}
 
-	top1 = devpriv->hwdmasize[0] - top1;	/*  where is now DMA in buffer */
+	/*  where is now DMA in buffer */
+	top1 = devpriv->hwdmasize[0] - top1;
 	top1 >>= 1;		/*  sample position */
 	top2 = top1 - devpriv->ai_poll_ptr;
 	if (top2 < 1) {		/*  no new samples */
@@ -787,16 +817,23 @@ static int pcl816_ai_cancel(struct comedi_device *dev,
 			disable_dma(devpriv->dma);
 		case INT_TYPE_AI1_INT:
 		case INT_TYPE_AI3_INT:
-			outb(inb(dev->iobase + PCL816_CONTROL) & 0x73, dev->iobase + PCL816_CONTROL);	/* Stop A/D */
+			outb(inb(dev->iobase + PCL816_CONTROL) & 0x73,
+			     dev->iobase + PCL816_CONTROL);	/* Stop A/D */
 			udelay(1);
 			outb(0, dev->iobase + PCL816_CONTROL);	/* Stop A/D */
-			outb(0xb0, dev->iobase + PCL816_CTRCTL);	/* Stop pacer */
+
+			/* Stop pacer */
+			outb(0xb0, dev->iobase + PCL816_CTRCTL);
 			outb(0x70, dev->iobase + PCL816_CTRCTL);
 			outb(0, dev->iobase + PCL816_AD_LO);
 			inb(dev->iobase + PCL816_AD_LO);
 			inb(dev->iobase + PCL816_AD_HI);
-			outb(0, dev->iobase + PCL816_CLRINT);	/* clear INT request */
-			outb(0, dev->iobase + PCL816_CONTROL);	/* Stop A/D */
+
+			/* clear INT request */
+			outb(0, dev->iobase + PCL816_CLRINT);
+
+			/* Stop A/D */
+			outb(0, dev->iobase + PCL816_CONTROL);
 			devpriv->irq_blocked = 0;
 			devpriv->irq_was_now_closed = devpriv->int816_mode;
 			devpriv->int816_mode = 0;
@@ -866,8 +903,11 @@ start_pacer(struct comedi_device *dev, int mode, unsigned int divisor1,
 	outb(0xff, dev->iobase + PCL816_CTR0);
 	outb(0x00, dev->iobase + PCL816_CTR0);
 	udelay(1);
-	outb(0xb4, dev->iobase + PCL816_CTRCTL);	/*  set counter 2 as mode 3 */
-	outb(0x74, dev->iobase + PCL816_CTRCTL);	/*  set counter 1 as mode 3 */
+
+	/*  set counter 2 as mode 3 */
+	outb(0xb4, dev->iobase + PCL816_CTRCTL);
+	/*  set counter 1 as mode 3 */
+	outb(0x74, dev->iobase + PCL816_CTRCTL);
 	udelay(1);
 
 	if (mode == 1) {
@@ -903,41 +943,51 @@ check_channel_list(struct comedi_device *dev,
 	}
 
 	if (chanlen > 1) {
-		chansegment[0] = chanlist[0];	/*  first channel is everytime ok */
+		/*  first channel is everytime ok */
+		chansegment[0] = chanlist[0];
 		for (i = 1, seglen = 1; i < chanlen; i++, seglen++) {
 			/*  build part of chanlist */
-			DEBUG(printk("%d. %d %d\n", i, CR_CHAN(chanlist[i]),
+			DEBUG(printk(KERN_INFO "%d. %d %d\n", i,
+				     CR_CHAN(chanlist[i]),
 				     CR_RANGE(chanlist[i]));)
+
+			/*  we detect loop, this must by finish */
 			    if (chanlist[0] == chanlist[i])
-				break;	/*  we detect loop, this must by finish */
+				break;
 			nowmustbechan =
 			    (CR_CHAN(chansegment[i - 1]) + 1) % chanlen;
 			if (nowmustbechan != CR_CHAN(chanlist[i])) {
 				/*  channel list isn't continous :-( */
-				printk
-				    ("comedi%d: pcl816: channel list must be continous! chanlist[%i]=%d but must be %d or %d!\n",
-				     dev->minor, i, CR_CHAN(chanlist[i]),
-				     nowmustbechan, CR_CHAN(chanlist[0]));
+				printk(KERN_WARNING
+				       "comedi%d: pcl816: channel list must "
+				       "be continous! chanlist[%i]=%d but "
+				       "must be %d or %d!\n", dev->minor,
+				       i, CR_CHAN(chanlist[i]), nowmustbechan,
+				       CR_CHAN(chanlist[0]));
 				return 0;
 			}
-			chansegment[i] = chanlist[i];	/*  well, this is next correct channel in list */
+			/*  well, this is next correct channel in list */
+			chansegment[i] = chanlist[i];
 		}
 
-		for (i = 0, segpos = 0; i < chanlen; i++) {	/*  check whole chanlist */
+		/*  check whole chanlist */
+		for (i = 0, segpos = 0; i < chanlen; i++) {
 			DEBUG(printk("%d %d=%d %d\n",
 				     CR_CHAN(chansegment[i % seglen]),
 				     CR_RANGE(chansegment[i % seglen]),
 				     CR_CHAN(chanlist[i]),
 				     CR_RANGE(chanlist[i]));)
 			    if (chanlist[i] != chansegment[i % seglen]) {
-				printk
-				    ("comedi%d: pcl816: bad channel or range number! chanlist[%i]=%d,%d,%d and not %d,%d,%d!\n",
-				     dev->minor, i, CR_CHAN(chansegment[i]),
-				     CR_RANGE(chansegment[i]),
-				     CR_AREF(chansegment[i]),
-				     CR_CHAN(chanlist[i % seglen]),
-				     CR_RANGE(chanlist[i % seglen]),
-				     CR_AREF(chansegment[i % seglen]));
+				printk(KERN_WARNING
+				       "comedi%d: pcl816: bad channel or range"
+				       " number! chanlist[%i]=%d,%d,%d and not"
+				       " %d,%d,%d!\n", dev->minor, i,
+				       CR_CHAN(chansegment[i]),
+				       CR_RANGE(chansegment[i]),
+				       CR_AREF(chansegment[i]),
+				       CR_CHAN(chanlist[i % seglen]),
+				       CR_RANGE(chanlist[i % seglen]),
+				       CR_AREF(chansegment[i % seglen]));
 				return 0;	/*  chan/gain list is strange */
 			}
 		}
@@ -965,12 +1015,15 @@ setup_channel_list(struct comedi_device *dev,
 	for (i = 0; i < seglen; i++) {	/*  store range list to card */
 		devpriv->ai_act_chanlist[i] = CR_CHAN(chanlist[i]);
 		outb(CR_CHAN(chanlist[0]) & 0xf, dev->iobase + PCL816_MUX);
-		outb(CR_RANGE(chanlist[0]), dev->iobase + PCL816_RANGE);	/* select gain */
+		/* select gain */
+		outb(CR_RANGE(chanlist[0]), dev->iobase + PCL816_RANGE);
 	}
 
 	udelay(1);
-
-	outb(devpriv->ai_act_chanlist[0] | (devpriv->ai_act_chanlist[seglen - 1] << 4), dev->iobase + PCL816_MUX);	/* select channel interval to scan */
+	/* select channel interval to scan */
+	outb(devpriv->ai_act_chanlist[0] |
+	     (devpriv->ai_act_chanlist[seglen - 1] << 4),
+	     dev->iobase + PCL816_MUX);
 }
 
 #ifdef unused
@@ -998,11 +1051,11 @@ static int set_rtc_irq_bit(unsigned char bit)
 	save_flags(flags);
 	cli();
 	val = CMOS_READ(RTC_CONTROL);
-	if (bit) {
+	if (bit)
 		val |= RTC_PIE;
-	} else {
+	else
 		val &= ~RTC_PIE;
-	}
+
 	CMOS_WRITE(val, RTC_CONTROL);
 	CMOS_READ(RTC_INTR_FLAGS);
 	restore_flags(flags);
@@ -1072,7 +1125,7 @@ static int pcl816_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	dev->iobase = iobase;
 
 	if (pcl816_check(iobase)) {
-		printk(", I cann't detect board. FAIL!\n");
+		printk(KERN_ERR ", I cann't detect board. FAIL!\n");
 		return -EIO;
 	}
 
@@ -1090,30 +1143,29 @@ static int pcl816_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		if (irq) {	/* we want to use IRQ */
 			if (((1 << irq) & this_board->IRQbits) == 0) {
 				printk
-				    (", IRQ %u is out of allowed range, DISABLING IT",
-				     irq);
+				    (", IRQ %u is out of allowed range, "
+				     "DISABLING IT", irq);
 				irq = 0;	/* Bad IRQ */
 			} else {
 				if (request_irq
 				    (irq, interrupt_pcl816, 0, "pcl816", dev)) {
 					printk
-					    (", unable to allocate IRQ %u, DISABLING IT",
-					     irq);
+					    (", unable to allocate IRQ %u, "
+					     "DISABLING IT", irq);
 					irq = 0;	/* Can't use IRQ */
 				} else {
-					printk(", irq=%u", irq);
+					printk(KERN_INFO ", irq=%u", irq);
 				}
 			}
 		}
 	}
 
 	dev->irq = irq;
-	if (irq) {
+	if (irq)	/* 1=we have allocated irq */
 		devpriv->irq_free = 1;
-	} /* 1=we have allocated irq */
-	else {
+	else
 		devpriv->irq_free = 0;
-	}
+
 	devpriv->irq_blocked = 0;	/* number of subdevice which use IRQ */
 	devpriv->int816_mode = 0;	/* mode of irq */
 
@@ -1170,18 +1222,22 @@ no_rtc:
 		}
 		ret = request_dma(dma, "pcl816");
 		if (ret) {
-			printk(", unable to allocate DMA %u, FAIL!\n", dma);
+			printk(KERN_ERR
+			       ", unable to allocate DMA %u, FAIL!\n", dma);
 			return -EBUSY;	/* DMA isn't free */
 		}
 
 		devpriv->dma = dma;
-		printk(", dma=%u", dma);
+		printk(KERN_INFO ", dma=%u", dma);
 		pages = 2;	/* we need 16KB */
 		devpriv->dmabuf[0] = __get_dma_pages(GFP_KERNEL, pages);
 
 		if (!devpriv->dmabuf[0]) {
 			printk(", unable to allocate DMA buffer, FAIL!\n");
-			/* maybe experiment with try_to_free_pages() will help .... */
+			/*
+			 * maybe experiment with try_to_free_pages()
+			 * will help ....
+			 */
 			return -EBUSY;	/* no buffer :-( */
 		}
 		devpriv->dmapages[0] = pages;
@@ -1192,8 +1248,9 @@ no_rtc:
 		if (devpriv->dma_rtc == 0) {	/*  we must do duble buff :-( */
 			devpriv->dmabuf[1] = __get_dma_pages(GFP_KERNEL, pages);
 			if (!devpriv->dmabuf[1]) {
-				printk
-				    (", unable to allocate DMA buffer, FAIL!\n");
+				printk(KERN_ERR
+				       ", unable to allocate DMA buffer, "
+				       "FAIL!\n");
 				return -EBUSY;
 			}
 			devpriv->dmapages[1] = pages;
@@ -1277,7 +1334,7 @@ case COMEDI_SUBD_DO:
  */
 static int pcl816_detach(struct comedi_device *dev)
 {
-	DEBUG(printk("comedi%d: pcl816: remove\n", dev->minor);)
+	DEBUG(printk(KERN_INFO "comedi%d: pcl816: remove\n", dev->minor);)
 	    free_resources(dev);
 #ifdef unused
 	if (devpriv->dma_rtc)
-- 
1.5.4.3

