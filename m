Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab0DUFem (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 01:34:42 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56354 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab0DUFel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 01:34:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=B8YnGE0V2lPnhy7ECnUkPE+0f0UiVtoP5gZv8oOoMgj97QsiGqSW/yx3Xh73O5jGyq
         BD58ajbbLveyPvmx12rmnhPvEjnpio59lE8TmRea5wmy09BQ2rE32Vv18mYTW3HiRCQq
         ERrg8eY31Ds/sd21Brq8qy2qmJcAvTIxWA4Jw=
From: Gustavo Silva <silvagustavosilva@gmail.com>
To: gregkh@suse.de, abbotti@mev.co.uk
Cc: fmhess@users.sourceforge.net, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org,
       Gustavo Silva <silvagustavo@users.sourceforge.net>
Subject: [PATCH] Staging: comedi: drivers: fix coding style issues in das16.c
Date: Wed, 21 Apr 2010 00:34:35 -0500
Message-Id: <1271828075-11093-1-git-send-email-silvagustavo@users.sourceforge.net>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the das16.c file that fixes up the following issues
found by the checkpatch.pl tool.

WARNING: line over 80 characters x 23
ERROR: spaces required around that '?' (ctx:VxV) x 2
ERROR: spaces required around that ':' (ctx:VxV) x 2
WARNING: printk() should include KERN_ facility level x 17
WARNING: braces {} are not necessary for single statement blocks x 8

Signed-off-by: Gustavo Silva <silvagustavo@users.sourceforge.net>
---
 drivers/staging/comedi/drivers/das16.c |  159 ++++++++++++++++++--------------
 1 files changed, 90 insertions(+), 69 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das16.c b/drivers/staging/comedi/drivers/das16.c
index f2aadda..ccee4f1 100644
--- a/drivers/staging/comedi/drivers/das16.c
+++ b/drivers/staging/comedi/drivers/das16.c
@@ -74,7 +74,8 @@ Keithley Manuals:
 	4922.PDF (das-1400)
 	4923.PDF (das1200, 1400, 1600)
 
-Computer boards manuals also available from their website www.measurementcomputing.com
+Computer boards manuals also available from their website
+www.measurementcomputing.com
 
 */
 
@@ -92,7 +93,8 @@ Computer boards manuals also available from their website www.measurementcomputi
 /* #define DEBUG */
 
 #ifdef DEBUG
-#define DEBUG_PRINT(format, args...) printk("das16: " format, ## args)
+#define DEBUG_PRINT(format, args...)	\
+	printk(KERN_DEBUG "das16: " format, ## args)
 #else
 #define DEBUG_PRINT(format, args...)
 #endif
@@ -186,15 +188,16 @@ Computer boards manuals also available from their website www.measurementcomputi
 
 */
 
-static const int sample_size = 2;	/*  size in bytes of a sample from board */
+/*  size in bytes of a sample from board */
+static const int sample_size = 2;
 
 #define DAS16_TRIG		0
 #define DAS16_AI_LSB		0
 #define DAS16_AI_MSB		1
 #define DAS16_MUX		2
 #define DAS16_DIO		3
-#define DAS16_AO_LSB(x)	((x)?6:4)
-#define DAS16_AO_MSB(x)	((x)?7:5)
+#define DAS16_AO_LSB(x)	((x) ? 6 : 4)
+#define DAS16_AO_MSB(x)	((x) ? 7 : 5)
 #define DAS16_STATUS		8
 #define   BUSY			(1<<7)
 #define   UNIPOLAR			(1<<6)
@@ -271,7 +274,7 @@ static const struct comedi_lrange range_das1x02_unip = { 4, {
 };
 
 static const struct comedi_lrange range_das16jr = { 9, {
-							/*  also used by 16/330 */
+						/*  also used by 16/330 */
 							BIP_RANGE(10),
 							BIP_RANGE(5),
 							BIP_RANGE(2.5),
@@ -547,7 +550,8 @@ static const struct das16_board das16_boards[] = {
 	 .id = 0x20,
 	 },
 	{
-	 .name = "das-1401",	/*  4919.pdf and 4922.pdf (keithley user's manual) */
+	/*  4919.pdf and 4922.pdf (keithley user's manual) */
+	 .name = "das-1401",
 	 .ai = das16_ai_rinsn,
 	 .ai_nbits = 12,
 	 .ai_speed = 10000,
@@ -558,10 +562,11 @@ static const struct das16_board das16_boards[] = {
 	 .i8255_offset = 0x0,
 	 .i8254_offset = 0x0c,
 	 .size = 0x408,
-	 .id = 0xc0		/*  4919.pdf says id bits are 0xe0, 4922.pdf says 0xc0 */
+	 .id = 0xc0   /*  4919.pdf says id bits are 0xe0, 4922.pdf says 0xc0 */
 	 },
 	{
-	 .name = "das-1402",	/*  4919.pdf and 4922.pdf (keithley user's manual) */
+	/*  4919.pdf and 4922.pdf (keithley user's manual) */
+	 .name = "das-1402",
 	 .ai = das16_ai_rinsn,
 	 .ai_nbits = 12,
 	 .ai_speed = 10000,
@@ -572,7 +577,7 @@ static const struct das16_board das16_boards[] = {
 	 .i8255_offset = 0x0,
 	 .i8254_offset = 0x0c,
 	 .size = 0x408,
-	 .id = 0xc0		/*  4919.pdf says id bits are 0xe0, 4922.pdf says 0xc0 */
+	 .id = 0xc0   /*  4919.pdf says id bits are 0xe0, 4922.pdf says 0xc0 */
 	 },
 	{
 	 .name = "das-1601",	/*  4919.pdf */
@@ -704,7 +709,8 @@ static const struct das16_board das16_boards[] = {
 	 .name = "das16/jr/ctr5",	/*  ? */
 	 },
 	{
-	 .name = "cio-das16/m1/16",	/*  cio-das16_m1_16.pdf, this board is a bit quirky, no dma */
+	/*  cio-das16_m1_16.pdf, this board is a bit quirky, no dma */
+	 .name = "cio-das16/m1/16",
 	 },
 #endif
 };
@@ -736,14 +742,19 @@ struct das16_private_struct {
 	unsigned int clockbase;	/*  master clock speed in ns */
 	volatile unsigned int control_state;	/*  dma, interrupt and trigger control bits */
 	volatile unsigned long adc_byte_count;	/*  number of bytes remaining */
-	unsigned int divisor1;	/*  divisor dividing master clock to get conversion frequency */
-	unsigned int divisor2;	/*  divisor dividing master clock to get conversion frequency */
+	/*  divisor dividing master clock to get conversion frequency */
+	unsigned int divisor1;
+	/*  divisor dividing master clock to get conversion frequency */
+	unsigned int divisor2;
 	unsigned int dma_chan;	/*  dma channel */
 	uint16_t *dma_buffer[2];
 	dma_addr_t dma_buffer_addr[2];
 	unsigned int current_buffer;
 	volatile unsigned int dma_transfer_size;	/*  target number of bytes to transfer per dma shot */
-	/*  user-defined analog input and output ranges defined from config options */
+	/**
+	 * user-defined analog input and output ranges
+	 * defined from config options
+	 */
 	struct comedi_lrange *user_ai_range_table;
 	struct comedi_lrange *user_ao_range_table;
 
@@ -798,7 +809,10 @@ static int das16_cmd_test(struct comedi_device *dev, struct comedi_subdevice *s,
 	if (err)
 		return 1;
 
-	/* step 2: make sure trigger sources are unique and mutually compatible */
+	/**
+	 * step 2: make sure trigger sources are unique and
+	 * mutually compatible
+	 */
 	if (cmd->scan_begin_src != TRIG_TIMER &&
 	    cmd->scan_begin_src != TRIG_EXT &&
 	    cmd->scan_begin_src != TRIG_FOLLOW)
@@ -893,12 +907,15 @@ static int das16_cmd_test(struct comedi_device *dev, struct comedi_subdevice *s,
 			if (CR_CHAN(cmd->chanlist[i]) !=
 			    (start_chan + i) % s->n_chan) {
 				comedi_error(dev,
-					     "entries in chanlist must be consecutive channels, counting upwards\n");
+						"entries in chanlist must be "
+						"consecutive channels, "
+						"counting upwards\n");
 				err++;
 			}
 			if (CR_RANGE(cmd->chanlist[i]) != gain) {
 				comedi_error(dev,
-					     "entries in chanlist must all have the same gain\n");
+						"entries in chanlist must all "
+						"have the same gain\n");
 				err++;
 			}
 		}
@@ -920,12 +937,13 @@ static int das16_cmd_exec(struct comedi_device *dev, struct comedi_subdevice *s)
 	if (devpriv->dma_chan == 0 || (dev->irq == 0
 				       && devpriv->timer_mode == 0)) {
 		comedi_error(dev,
-			     "irq (or use of 'timer mode') dma required to execute comedi_cmd");
+				"irq (or use of 'timer mode') dma required to "
+							"execute comedi_cmd");
 		return -1;
 	}
 	if (cmd->flags & TRIG_RT) {
-		comedi_error(dev,
-			     "isa dma transfers cannot be performed with TRIG_RT, aborting");
+		comedi_error(dev, "isa dma transfers cannot be performed with "
+							"TRIG_RT, aborting");
 		return -1;
 	}
 
@@ -933,16 +951,17 @@ static int das16_cmd_exec(struct comedi_device *dev, struct comedi_subdevice *s)
 	    cmd->stop_arg * cmd->chanlist_len * sizeof(uint16_t);
 
 	/*  disable conversions for das1600 mode */
-	if (thisboard->size > 0x400) {
+	if (thisboard->size > 0x400)
 		outb(DAS1600_CONV_DISABLE, dev->iobase + DAS1600_CONV);
-	}
+
 	/*  set scan limits */
 	byte = CR_CHAN(cmd->chanlist[0]);
 	byte |= CR_CHAN(cmd->chanlist[cmd->chanlist_len - 1]) << 4;
 	outb(byte, dev->iobase + DAS16_MUX);
 
 	/* set gain (this is also burst rate register but according to
-	 * computer boards manual, burst rate does nothing, even on keithley cards) */
+	 * computer boards manual, burst rate does nothing, even on
+	 * keithley cards) */
 	if (thisboard->ai_pg != das16_pg_none) {
 		range = CR_RANGE(cmd->chanlist[0]);
 		outb((das16_gainlists[thisboard->ai_pg])[range],
@@ -1005,9 +1024,9 @@ static int das16_cmd_exec(struct comedi_device *dev, struct comedi_subdevice *s)
 	outb(devpriv->control_state, dev->iobase + DAS16_CONTROL);
 
 	/* Enable conversions if using das1600 mode */
-	if (thisboard->size > 0x400) {
+	if (thisboard->size > 0x400)
 		outb(0, dev->iobase + DAS1600_CONV);
-	}
+
 
 	return 0;
 }
@@ -1030,9 +1049,9 @@ static int das16_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
 	}
 
 	/* disable burst mode */
-	if (thisboard->size > 0x400) {
+	if (thisboard->size > 0x400)
 		outb(0, dev->iobase + DAS1600_BURST);
-	}
+
 
 	spin_unlock_irqrestore(&dev->spinlock, flags);
 
@@ -1085,11 +1104,11 @@ static int das16_ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 		}
 		msb = inb(dev->iobase + DAS16_AI_MSB);
 		lsb = inb(dev->iobase + DAS16_AI_LSB);
-		if (thisboard->ai_nbits == 12) {
+		if (thisboard->ai_nbits == 12)
 			data[n] = ((lsb >> 4) & 0xf) | (msb << 4);
-		} else {
+		else
 			data[n] = lsb | (msb << 8);
-		}
+
 	}
 
 	return n;
@@ -1207,8 +1226,8 @@ static int disable_dma_on_even(struct comedi_device *dev)
 		residue = get_dma_residue(devpriv->dma_chan);
 	}
 	if (i == disable_limit) {
-		comedi_error(dev,
-			     "failed to get an even dma transfer, could be trouble.");
+		comedi_error(dev, "failed to get an even dma transfer, "
+							"could be trouble.");
 	}
 	return residue;
 }
@@ -1254,7 +1273,8 @@ static void das16_interrupt(struct comedi_device *dev)
 	} else
 		num_bytes = devpriv->dma_transfer_size - residue;
 
-	if (cmd->stop_src == TRIG_COUNT && num_bytes >= devpriv->adc_byte_count) {
+	if (cmd->stop_src == TRIG_COUNT &&
+					num_bytes >= devpriv->adc_byte_count) {
 		num_bytes = devpriv->adc_byte_count;
 		async->events |= COMEDI_CB_EOA;
 	}
@@ -1275,9 +1295,9 @@ static void das16_interrupt(struct comedi_device *dev)
 		set_dma_count(devpriv->dma_chan, devpriv->dma_transfer_size);
 		enable_dma(devpriv->dma_chan);
 		/* reenable conversions for das1600 mode, (stupid hardware) */
-		if (thisboard->size > 0x400 && devpriv->timer_mode == 0) {
+		if (thisboard->size > 0x400 && devpriv->timer_mode == 0)
 			outb(0x00, dev->iobase + DAS1600_CONV);
-		}
+
 	}
 	release_dma_lock(dma_flags);
 
@@ -1330,25 +1350,25 @@ static int das16_probe(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	status = inb(dev->iobase + DAS16_STATUS);
 
-	if ((status & UNIPOLAR)) {
+	if ((status & UNIPOLAR))
 		devpriv->ai_unipolar = 1;
-	} else {
+	else
 		devpriv->ai_unipolar = 0;
-	}
 
-	if ((status & DAS16_MUXBIT)) {
+
+	if ((status & DAS16_MUXBIT))
 		devpriv->ai_singleended = 1;
-	} else {
+	else
 		devpriv->ai_singleended = 0;
-	}
+
 
 	/* diobits indicates boards */
 
 	diobits = inb(dev->iobase + DAS16_DIO) & 0xf0;
 
-	printk(" id bits are 0x%02x\n", diobits);
+	printk(KERN_INFO " id bits are 0x%02x\n", diobits);
 	if (thisboard->id != diobits) {
-		printk(" requested board's id bits are 0x%x (ignore)\n",
+		printk(KERN_INFO " requested board's id bits are 0x%x (ignore)\n",
 		       thisboard->id);
 	}
 
@@ -1363,10 +1383,10 @@ static int das1600_mode_detect(struct comedi_device *dev)
 
 	if (status & DAS1600_CLK_10MHZ) {
 		devpriv->clockbase = 100;
-		printk(" 10MHz pacer clock\n");
+		printk(KERN_INFO " 10MHz pacer clock\n");
 	} else {
 		devpriv->clockbase = 1000;
-		printk(" 1MHz pacer clock\n");
+		printk(KERN_INFO " 1MHz pacer clock\n");
 	}
 
 	reg_dump(dev);
@@ -1406,14 +1426,15 @@ static int das16_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (timer_mode)
 		irq = 0;
 
-	printk("comedi%d: das16:", dev->minor);
+	printk(KERN_INFO "comedi%d: das16:", dev->minor);
 
 	/*  check that clock setting is valid */
 	if (it->options[3]) {
 		if (it->options[3] != 0 &&
 		    it->options[3] != 1 && it->options[3] != 10) {
 			printk
-			    ("\n Invalid option.  Master clock must be set to 1 or 10 (MHz)\n");
+			    ("\n Invalid option.  Master clock must be set "
+							"to 1 or 10 (MHz)\n");
 			return -EINVAL;
 		}
 	}
@@ -1425,23 +1446,23 @@ static int das16_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (thisboard->size < 0x400) {
 		printk(" 0x%04lx-0x%04lx\n", iobase, iobase + thisboard->size);
 		if (!request_region(iobase, thisboard->size, "das16")) {
-			printk(" I/O port conflict\n");
+			printk(KERN_ERR " I/O port conflict\n");
 			return -EIO;
 		}
 	} else {
-		printk(" 0x%04lx-0x%04lx 0x%04lx-0x%04lx\n",
+		printk(KERN_INFO " 0x%04lx-0x%04lx 0x%04lx-0x%04lx\n",
 		       iobase, iobase + 0x0f,
 		       iobase + 0x400,
 		       iobase + 0x400 + (thisboard->size & 0x3ff));
 		if (!request_region(iobase, 0x10, "das16")) {
-			printk(" I/O port conflict:  0x%04lx-0x%04lx\n",
+			printk(KERN_ERR " I/O port conflict:  0x%04lx-0x%04lx\n",
 			       iobase, iobase + 0x0f);
 			return -EIO;
 		}
 		if (!request_region(iobase + 0x400, thisboard->size & 0x3ff,
 				    "das16")) {
 			release_region(iobase, 0x10);
-			printk(" I/O port conflict:  0x%04lx-0x%04lx\n",
+			printk(KERN_ERR " I/O port conflict:  0x%04lx-0x%04lx\n",
 			       iobase + 0x400,
 			       iobase + 0x400 + (thisboard->size & 0x3ff));
 			return -EIO;
@@ -1452,7 +1473,7 @@ static int das16_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	/*  probe id bits to make sure they are consistent */
 	if (das16_probe(dev, it)) {
-		printk(" id bits do not match selected board, aborting\n");
+		printk(KERN_ERR " id bits do not match selected board, aborting\n");
 		return -EINVAL;
 	}
 	dev->board_name = thisboard->name;
@@ -1474,7 +1495,7 @@ static int das16_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		if (ret < 0)
 			return ret;
 		dev->irq = irq;
-		printk(" ( irq = %u )", irq);
+		printk(KERN_INFO " ( irq = %u )", irq);
 	} else if (irq == 0) {
 		printk(" ( no irq )");
 	} else {
@@ -1488,16 +1509,15 @@ static int das16_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		/*  allocate dma buffers */
 		int i;
 		for (i = 0; i < 2; i++) {
-			devpriv->dma_buffer[i] = pci_alloc_consistent(NULL,
-								      DAS16_DMA_SIZE,
-								      &devpriv->
-								      dma_buffer_addr
-								      [i]);
+			devpriv->dma_buffer[i] = pci_alloc_consistent(
+						NULL, DAS16_DMA_SIZE,
+						&devpriv->dma_buffer_addr[i]);
+
 			if (devpriv->dma_buffer[i] == NULL)
 				return -ENOMEM;
 		}
 		if (request_dma(dma_chan, "das16")) {
-			printk(" failed to allocate dma channel %i\n",
+			printk(KERN_ERR " failed to allocate dma channel %i\n",
 			       dma_chan);
 			return -EINVAL;
 		}
@@ -1506,11 +1526,11 @@ static int das16_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		disable_dma(devpriv->dma_chan);
 		set_dma_mode(devpriv->dma_chan, DMA_MODE_READ);
 		release_dma_lock(flags);
-		printk(" ( dma = %u)\n", dma_chan);
+		printk(KERN_INFO " ( dma = %u)\n", dma_chan);
 	} else if (dma_chan == 0) {
-		printk(" ( no dma )\n");
+		printk(KERN_INFO " ( no dma )\n");
 	} else {
-		printk(" invalid dma channel\n");
+		printk(KERN_ERR " invalid dma channel\n");
 		return -EINVAL;
 	}
 
@@ -1569,7 +1589,7 @@ static int das16_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 			s->subdev_flags |= SDF_DIFF;
 		}
 		s->maxdata = (1 << thisboard->ai_nbits) - 1;
-		if (devpriv->user_ai_range_table) {	/*  user defined ai range */
+		if (devpriv->user_ai_range_table) { /*  user defined ai range */
 			s->range_table = devpriv->user_ai_range_table;
 		} else if (devpriv->ai_unipolar) {
 			s->range_table = das16_ai_uni_lranges[thisboard->ai_pg];
@@ -1592,11 +1612,12 @@ static int das16_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		s->subdev_flags = SDF_WRITABLE;
 		s->n_chan = 2;
 		s->maxdata = (1 << thisboard->ao_nbits) - 1;
-		if (devpriv->user_ao_range_table) {	/*  user defined ao range */
+		/*  user defined ao range */
+		if (devpriv->user_ao_range_table)
 			s->range_table = devpriv->user_ao_range_table;
-		} else {
+		else
 			s->range_table = &range_unknown;
-		}
+
 		s->insn_write = thisboard->ao;
 	} else {
 		s->type = COMEDI_SUBD_UNUSED;
@@ -1656,7 +1677,7 @@ static int das16_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static int das16_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: das16: remove\n", dev->minor);
+	printk(KERN_INFO "comedi%d: das16: remove\n", dev->minor);
 
 	das16_reset(dev);
 
@@ -1750,8 +1771,8 @@ static void das16_ai_munge(struct comedi_device *dev,
 
 	for (i = 0; i < num_samples; i++) {
 		data[i] = le16_to_cpu(data[i]);
-		if (thisboard->ai_nbits == 12) {
+		if (thisboard->ai_nbits == 12)
 			data[i] = (data[i] >> 4) & 0xfff;
-		}
+
 	}
 }
-- 
1.5.4.3

