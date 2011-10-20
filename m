Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab1JTGUQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 02:20:16 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63718 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768Ab1JTGUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 02:20:12 -0400
From: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 03/24] Staging: comedi: fix warning issue in pcl818.c
Date: Thu, 20 Oct 2011 11:48:49 +0530
Message-Id: <1319091550-2558-3-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1319091550-2558-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1319091550-2558-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the pcl818.c file that fixes up a warning
found by the checkpatch.pl tool.
Fix brace coding style and NULL initilization issue.
Converted printks to dev_printk.
Removed unnecessary printk statements.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/pcl818.c |  110 ++++++++++++-------------------
 1 files changed, 43 insertions(+), 67 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index b45a9bd..65eff4f 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -252,8 +252,8 @@ static int pcl818_attach(struct comedi_device *dev,
 static int pcl818_detach(struct comedi_device *dev);
 
 #ifdef unused
-static int RTC_lock = 0;	/* RTC lock */
-static int RTC_timer_lock = 0;	/* RTC int lock */
+static int RTC_lock;	/* RTC lock */
+static int RTC_timer_lock;	/* RTC int lock */
 #endif
 
 struct pcl818_board {
@@ -463,10 +463,8 @@ static int pcl818_ao_insn_read(struct comedi_device *dev,
 	int n;
 	int chan = CR_CHAN(insn->chanspec);
 
-	for (n = 0; n < insn->n; n++) {
+	for (n = 0; n < insn->n; n++)
 		data[n] = devpriv->ao_readback[chan];
-	}
-
 	return n;
 }
 
@@ -571,9 +569,8 @@ conv_finish:
 		return IRQ_HANDLED;
 	}
 	devpriv->act_chanlist_pos++;
-	if (devpriv->act_chanlist_pos >= devpriv->act_chanlist_len) {
+	if (devpriv->act_chanlist_pos >= devpriv->act_chanlist_len)
 		devpriv->act_chanlist_pos = 0;
-	}
 	s->async->cur_chan++;
 	if (s->async->cur_chan >= devpriv->ai_n_chan) {
 		/*  printk("E"); */
@@ -620,7 +617,7 @@ static irqreturn_t interrupt_pcl818_ai_mode13_dma(int irq, void *d)
 		release_dma_lock(flags);
 		enable_dma(devpriv->dma);
 	}
-	printk("comedi: A/D mode1/3 IRQ \n");
+	printk("comedi: A/D mode1/3 IRQ\n");
 
 	devpriv->dma_runs_to_end--;
 	outb(0, dev->iobase + PCL818_CLRINT);	/* clear INT request */
@@ -645,9 +642,8 @@ static irqreturn_t interrupt_pcl818_ai_mode13_dma(int irq, void *d)
 		comedi_buf_put(s->async, ptr[bufptr++] >> 4);	/*  get one sample */
 
 		devpriv->act_chanlist_pos++;
-		if (devpriv->act_chanlist_pos >= devpriv->act_chanlist_len) {
+		if (devpriv->act_chanlist_pos >= devpriv->act_chanlist_len)
 			devpriv->act_chanlist_pos = 0;
-		}
 		s->async->cur_chan++;
 		if (s->async->cur_chan >= devpriv->ai_n_chan) {
 			s->async->cur_chan = 0;
@@ -805,11 +801,10 @@ static irqreturn_t interrupt_pcl818_ai_mode13_fifo(int irq, void *d)
 		return IRQ_HANDLED;
 	}
 
-	if (lo & 2) {
+	if (lo & 2)
 		len = 512;
-	} else {
+	else
 		len = 0;
-	}
 
 	for (i = 0; i < len; i++) {
 		lo = inb(dev->iobase + PCL818_FI_DATALO);
@@ -827,9 +822,8 @@ static irqreturn_t interrupt_pcl818_ai_mode13_fifo(int irq, void *d)
 		comedi_buf_put(s->async, (lo >> 4) | (inb(dev->iobase + PCL818_FI_DATAHI) << 4));	/*  get one sample */
 
 		devpriv->act_chanlist_pos++;
-		if (devpriv->act_chanlist_pos >= devpriv->act_chanlist_len) {
+		if (devpriv->act_chanlist_pos >= devpriv->act_chanlist_len)
 			devpriv->act_chanlist_pos = 0;
-		}
 		s->async->cur_chan++;
 		if (s->async->cur_chan >= devpriv->ai_n_chan) {
 			s->async->cur_chan = 0;
@@ -1309,11 +1303,9 @@ static void setup_channel_list(struct comedi_device *dev,
 */
 static int check_single_ended(unsigned int port)
 {
-	if (inb(port + PCL818_STATUS) & 0x20) {
+	if (inb(port + PCL818_STATUS) & 0x20)
 		return 1;
-	} else {
-		return 0;
-	}
+	return 0;
 }
 
 /*
@@ -1352,9 +1344,8 @@ static int ai_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
 	if (!cmd->stop_src || tmp != cmd->stop_src)
 		err++;
 
-	if (err) {
+	if (err)
 		return 1;
-	}
 
 	/* step 2: make sure trigger sources are unique and mutually compatible */
 
@@ -1377,9 +1368,8 @@ static int ai_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
 	if (cmd->stop_src != TRIG_NONE && cmd->stop_src != TRIG_COUNT)
 		err++;
 
-	if (err) {
+	if (err)
 		return 2;
-	}
 
 	/* step 3: make sure arguments are trivially compatible */
 
@@ -1421,9 +1411,8 @@ static int ai_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
 		}
 	}
 
-	if (err) {
+	if (err)
 		return 3;
-	}
 
 	/* step 4: fix up any arguments */
 
@@ -1438,9 +1427,8 @@ static int ai_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
 			err++;
 	}
 
-	if (err) {
+	if (err)
 		return 4;
-	}
 
 	/* step 5: complain about special chanlist considerations */
 
@@ -1461,7 +1449,7 @@ static int ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	struct comedi_cmd *cmd = &s->async->cmd;
 	int retval;
 
-	printk("pcl818_ai_cmd()\n");
+	dev_dbg(dev->hw_dev, "pcl818_ai_cmd()\n");
 	devpriv->ai_n_chan = cmd->chanlist_len;
 	devpriv->ai_chanlist = cmd->chanlist;
 	devpriv->ai_flags = cmd->flags;
@@ -1470,17 +1458,16 @@ static int ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	devpriv->ai_timer1 = 0;
 	devpriv->ai_timer2 = 0;
 
-	if (cmd->stop_src == TRIG_COUNT) {
+	if (cmd->stop_src == TRIG_COUNT)
 		devpriv->ai_scans = cmd->stop_arg;
-	} else {
+	else
 		devpriv->ai_scans = 0;
-	}
 
 	if (cmd->scan_begin_src == TRIG_FOLLOW) {	/*  mode 1, 3 */
 		if (cmd->convert_src == TRIG_TIMER) {	/*  mode 1 */
 			devpriv->ai_timer1 = cmd->convert_arg;
 			retval = pcl818_ai_cmd_mode(1, dev, s);
-			printk("pcl818_ai_cmd() end\n");
+			dev_dbg(dev->hw_dev, "pcl818_ai_cmd() end\n");
 			return retval;
 		}
 		if (cmd->convert_src == TRIG_EXT) {	/*  mode 3 */
@@ -1499,7 +1486,7 @@ static int pcl818_ai_cancel(struct comedi_device *dev,
 			    struct comedi_subdevice *s)
 {
 	if (devpriv->irq_blocked > 0) {
-		printk("pcl818_ai_cancel()\n");
+		dev_dbg(dev->hw_dev, "pcl818_ai_cancel()\n");
 		devpriv->irq_was_now_closed = 1;
 
 		switch (devpriv->ai_mode) {
@@ -1549,7 +1536,7 @@ static int pcl818_ai_cancel(struct comedi_device *dev,
 	}
 
 end:
-	printk("pcl818_ai_cancel() end\n");
+	dev_dbg(dev->hw_dev, "pcl818_ai_cancel() end\n");
 	return 0;
 }
 
@@ -1633,11 +1620,10 @@ static int set_rtc_irq_bit(unsigned char bit)
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
 	CMOS_WRITE(val, RTC_CONTROL);
 	CMOS_READ(RTC_INTR_FLAGS);
 	restore_flags(flags);
@@ -1754,22 +1740,20 @@ static int pcl818_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	/* claim our I/O space */
 	iobase = it->options[0];
-	printk("comedi%d: pcl818:  board=%s, ioport=0x%03lx",
-	       dev->minor, this_board->name, iobase);
 	devpriv->io_range = this_board->io_range;
 	if ((this_board->fifo) && (it->options[2] == -1)) {	/*  we've board with FIFO and we want to use FIFO */
 		devpriv->io_range = PCLx1xFIFO_RANGE;
 		devpriv->usefifo = 1;
 	}
 	if (!request_region(iobase, devpriv->io_range, "pcl818")) {
-		printk("I/O port conflict\n");
+		dev_err(dev->hw_dev, "I/O port conflict\n");
 		return -EIO;
 	}
 
 	dev->iobase = iobase;
 
 	if (pcl818_check(iobase)) {
-		printk(", I can't detect board. FAIL!\n");
+		dev_err(dev->hw_dev, "I can't detect board. FAIL!\n");
 		return -EIO;
 	}
 
@@ -1781,31 +1765,27 @@ static int pcl818_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		irq = it->options[1];
 		if (irq) {	/* we want to use IRQ */
 			if (((1 << irq) & this_board->IRQbits) == 0) {
-				printk
-				    (", IRQ %u is out of allowed range, DISABLING IT",
-				     irq);
+				dev_dbg(dev->hw_dev, "IRQ %u is out of allowed range, DISABLING IT\n",
+					irq);
 				irq = 0;	/* Bad IRQ */
 			} else {
 				if (request_irq
 				    (irq, interrupt_pcl818, 0, "pcl818", dev)) {
-					printk
-					    (", unable to allocate IRQ %u, DISABLING IT",
-					     irq);
+					dev_dbg(dev->hw_dev, "unable to allocate IRQ %u, DISABLING IT\n",
+						irq);
 					irq = 0;	/* Can't use IRQ */
 				} else {
-					printk(", irq=%u", irq);
+					dev_dbg(dev->hw_dev, "irq=%u\n", irq);
 				}
 			}
 		}
 	}
 
 	dev->irq = irq;
-	if (irq) {
-		devpriv->irq_free = 1;
-	} /* 1=we have allocated irq */
-	else {
+	if (irq)
+		devpriv->irq_free = 1;  /* 1=we have allocated irq */
+	else
 		devpriv->irq_free = 0;
-	}
 	devpriv->irq_blocked = 0;	/* number of subdevice which use IRQ */
 	devpriv->ai_mode = 0;	/* mode of irq */
 
@@ -1825,7 +1805,7 @@ static int pcl818_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 				 "pcl818 DMA (RTC)", dev)) {
 			devpriv->dma_rtc = 1;
 			devpriv->rtc_irq = RTC_IRQ;
-			printk(", dma_irq=%u", devpriv->rtc_irq);
+			dev_dbg(dev->hw_dev, "dma_irq=%u\n", devpriv->rtc_irq);
 		} else {
 			RTC_lock--;
 			if (RTC_lock == 0) {
@@ -1850,20 +1830,20 @@ no_rtc:
 		if (dma < 1)
 			goto no_dma;	/* DMA disabled */
 		if (((1 << dma) & this_board->DMAbits) == 0) {
-			printk(", DMA is out of allowed range, FAIL!\n");
+			dev_err(dev->hw_dev, "DMA is out of allowed range, FAIL!\n");
 			return -EINVAL;	/* Bad DMA */
 		}
 		ret = request_dma(dma, "pcl818");
 		if (ret) {
-			printk(", unable to allocate DMA %u, FAIL!\n", dma);
+			dev_warn(dev->hw_dev, "unable to allocate DMA %u, FAIL!\n", dma);
 			return -EBUSY;	/* DMA isn't free */
 		}
 		devpriv->dma = dma;
-		printk(", dma=%u", dma);
+		dev_dbg(dev->hw_dev, "dma=%u\n", dma);
 		pages = 2;	/* we need 16KB */
 		devpriv->dmabuf[0] = __get_dma_pages(GFP_KERNEL, pages);
 		if (!devpriv->dmabuf[0]) {
-			printk(", unable to allocate DMA buffer, FAIL!\n");
+			dev_warn(dev->hw_dev, "unable to allocate DMA buffer, FAIL!\n");
 			/* maybe experiment with try_to_free_pages() will help .... */
 			return -EBUSY;	/* no buffer :-( */
 		}
@@ -1874,8 +1854,7 @@ no_rtc:
 		if (devpriv->dma_rtc == 0) {	/*  we must do duble buff :-( */
 			devpriv->dmabuf[1] = __get_dma_pages(GFP_KERNEL, pages);
 			if (!devpriv->dmabuf[1]) {
-				printk
-				    (", unable to allocate DMA buffer, FAIL!\n");
+				dev_warn(dev->hw_dev, "unable to allocate DMA buffer, FAIL!\n");
 				return -EBUSY;
 			}
 			devpriv->dmapages[1] = pages;
@@ -1901,11 +1880,11 @@ no_dma:
 		if (check_single_ended(dev->iobase)) {
 			s->n_chan = this_board->n_aichan_se;
 			s->subdev_flags |= SDF_COMMON | SDF_GROUND;
-			printk(", %dchans S.E. DAC", s->n_chan);
+			dev_dbg(dev->hw_dev, "%dchans S.E. DAC", s->n_chan);
 		} else {
 			s->n_chan = this_board->n_aichan_diff;
 			s->subdev_flags |= SDF_DIFF;
-			printk(", %dchans DIFF DAC", s->n_chan);
+			dev_dbg(dev->hw_dev, "%dchans DIFF DAC", s->n_chan);
 		}
 		s->maxdata = this_board->ai_maxdata;
 		s->len_chanlist = s->n_chan;
@@ -2017,11 +1996,10 @@ no_dma:
 	}
 
 	/* select 1/10MHz oscilator */
-	if ((it->options[3] == 0) || (it->options[3] == 10)) {
+	if ((it->options[3] == 0) || (it->options[3] == 10))
 		devpriv->i8253_osc_base = 100;
-	} else {
+	else
 		devpriv->i8253_osc_base = 1000;
-	}
 
 	/* max sampling speed */
 	devpriv->ns_min = this_board->ns_min;
@@ -2033,8 +2011,6 @@ no_dma:
 
 	pcl818_reset(dev);
 
-	printk("\n");
-
 	return 0;
 }
 
-- 
1.7.6.4

