Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab1JJN7m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 09:59:42 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63581 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151Ab1JJN7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 09:59:40 -0400
From: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 1/2] Staging: comedi: fix warning issue in das16m1.c
Date: Mon, 10 Oct 2011 19:28:52 +0530
Message-Id: <1318255133-6986-1-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the das16m1.c file that fixes up a brace
coding style, printk and line over 80 character warning found
by the checkpatch.pl tool

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/das16m1.c |   84 +++++++++++++++++-------------
 1 files changed, 47 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das16m1.c b/drivers/staging/comedi/drivers/das16m1.c
index a5ce3b2..6cff4f8 100644
--- a/drivers/staging/comedi/drivers/das16m1.c
+++ b/drivers/staging/comedi/drivers/das16m1.c
@@ -52,8 +52,8 @@ list has 2 or more channels in it, then two conditions must be satisfied:
 (2) - the list must have an even number of entries.
 
 Options:
-        [0] - base io address
-        [1] - irq (optional, but you probably want it)
+	[0] - base io address
+	[1] - irq (optional, but you probably want it)
 
 irq can be omitted, although the cmd interface will not work without it.
 */
@@ -185,15 +185,17 @@ static struct comedi_driver driver_das16m1 = {
 
 struct das16m1_private_struct {
 	unsigned int control_state;
-	volatile unsigned int adc_count;	/*  number of samples completed */
+	unsigned int adc_count;	/*  number of samples completed */
 	/* initial value in lower half of hardware conversion counter,
 	 * needed to keep track of whether new count has been loaded into
 	 * counter yet (loaded by first sample conversion) */
 	u16 initial_hw_count;
 	short ai_buffer[FIFO_SIZE];
 	unsigned int do_bits;	/*  saves status of digital output bits */
-	unsigned int divisor1;	/*  divides master clock to obtain conversion speed */
-	unsigned int divisor2;	/*  divides master clock to obtain conversion speed */
+	/* divides master clock to obtain conversion speed */
+	unsigned int divisor1;
+	/* divides master clock to obtain conversion speed */
+	unsigned int divisor2;
 };
 #define devpriv ((struct das16m1_private_struct *)(dev->private))
 #define thisboard ((const struct das16m1_board *)(dev->board_ptr))
@@ -250,7 +252,9 @@ static int das16m1_cmd_test(struct comedi_device *dev,
 	if (err)
 		return 1;
 
-	/* step 2: make sure trigger sources are unique and mutually compatible */
+	/*
+	 * step 2: make sure trigger sources are unique and mutually compatible
+	 */
 	if (cmd->stop_src != TRIG_COUNT && cmd->stop_src != TRIG_NONE)
 		err++;
 	if (cmd->start_src != TRIG_NOW && cmd->start_src != TRIG_EXT)
@@ -320,7 +324,10 @@ static int das16m1_cmd_test(struct comedi_device *dev,
 	/*  check chanlist against board's peculiarities */
 	if (cmd->chanlist && cmd->chanlist_len > 1) {
 		for (i = 0; i < cmd->chanlist_len; i++) {
-			/*  even/odd channels must go into even/odd queue addresses */
+			/*
+			 * even/odd channels must go into even/odd queue
+			 * addresses
+			 */
 			if ((i % 2) != (CR_CHAN(cmd->chanlist[i]) % 2)) {
 				comedi_error(dev, "bad chanlist:\n"
 					     " even/odd channels must go have even/odd chanlist indices");
@@ -384,20 +391,18 @@ static int das16m1_cmd_exec(struct comedi_device *dev,
 	byte = 0;
 	/* if we are using external start trigger (also board dislikes having
 	 * both start and conversion triggers external simultaneously) */
-	if (cmd->start_src == TRIG_EXT && cmd->convert_src != TRIG_EXT) {
+	if (cmd->start_src == TRIG_EXT && cmd->convert_src != TRIG_EXT)
 		byte |= EXT_TRIG_BIT;
-	}
 	outb(byte, dev->iobase + DAS16M1_CS);
 	/* clear interrupt bit */
 	outb(0, dev->iobase + DAS16M1_CLEAR_INTR);
 
 	/* enable interrupts and internal pacer */
 	devpriv->control_state &= ~PACER_MASK;
-	if (cmd->convert_src == TRIG_TIMER) {
+	if (cmd->convert_src == TRIG_TIMER)
 		devpriv->control_state |= INT_PACER;
-	} else {
+	else
 		devpriv->control_state |= EXT_PACER;
-	}
 	devpriv->control_state |= INTE;
 	outb(devpriv->control_state, dev->iobase + DAS16M1_INTR_CONTROL);
 
@@ -531,9 +536,8 @@ static void munge_sample_array(short *array, unsigned int num_elements)
 {
 	unsigned int i;
 
-	for (i = 0; i < num_elements; i++) {
+	for (i = 0; i < num_elements; i++)
 		array[i] = munge_sample(array[i]);
-	}
 }
 
 static void das16m1_handler(struct comedi_device *dev, unsigned int status)
@@ -553,15 +557,20 @@ static void das16m1_handler(struct comedi_device *dev, unsigned int status)
 	hw_counter = i8254_read(dev->iobase + DAS16M1_8254_FIRST, 0, 1);
 	/* make sure hardware counter reading is not bogus due to initial value
 	 * not having been loaded yet */
-	if (devpriv->adc_count == 0 && hw_counter == devpriv->initial_hw_count) {
+	if (devpriv->adc_count == 0 && hw_counter ==
+			devpriv->initial_hw_count) {
 		num_samples = 0;
 	} else {
-		/* The calculation of num_samples looks odd, but it uses the following facts.
-		 * 16 bit hardware counter is initialized with value of zero (which really
-		 * means 0x1000).  The counter decrements by one on each conversion
-		 * (when the counter decrements from zero it goes to 0xffff).  num_samples
-		 * is a 16 bit variable, so it will roll over in a similar fashion to the
-		 * hardware counter.  Work it out, and this is what you get. */
+		/*
+		 * The calculation of num_samples looks odd, but it uses the
+		 * following facts. 16 bit hardware counter is initialized with
+		 * value of zero (which really means 0x1000).  The counter
+		 * decrements by one on each conversion (when the counter
+		 * decrements from zero it goes to 0xffff).  num_samples
+		 * is a 16 bit variable, so it will roll over in a similar
+		 * fashion to the hardware counter.  Work it out, and this
+		 * is what you get.
+		 */
 		num_samples = -hw_counter - devpriv->adc_count;
 	}
 	/*  check if we only need some of the points */
@@ -579,7 +588,8 @@ static void das16m1_handler(struct comedi_device *dev, unsigned int status)
 	devpriv->adc_count += num_samples;
 
 	if (cmd->stop_src == TRIG_COUNT) {
-		if (devpriv->adc_count >= cmd->stop_arg * cmd->chanlist_len) {	/* end of acquisition */
+		/* end of acquisition */
+		if (devpriv->adc_count >= cmd->stop_arg * cmd->chanlist_len) {
 			das16m1_cancel(dev, s);
 			async->events |= COMEDI_CB_EOA;
 		}
@@ -668,7 +678,7 @@ static int das16m1_attach(struct comedi_device *dev,
 
 	iobase = it->options[0];
 
-	printk("comedi%d: das16m1:", dev->minor);
+	pr_debug("comedi%d: das16m1:\n", dev->minor);
 
 	ret = alloc_private(dev, sizeof(struct das16m1_private_struct));
 	if (ret < 0)
@@ -676,17 +686,17 @@ static int das16m1_attach(struct comedi_device *dev,
 
 	dev->board_name = thisboard->name;
 
-	printk(" io 0x%lx-0x%lx 0x%lx-0x%lx",
-	       iobase, iobase + DAS16M1_SIZE,
-	       iobase + DAS16M1_82C55, iobase + DAS16M1_82C55 + DAS16M1_SIZE2);
+	pr_debug("io 0x%lx-0x%lx 0x%lx-0x%lx\n", iobase, iobase + DAS16M1_SIZE,
+		 iobase + DAS16M1_82C55,
+		 iobase + DAS16M1_82C55 + DAS16M1_SIZE2);
 	if (!request_region(iobase, DAS16M1_SIZE, driver_das16m1.driver_name)) {
-		printk(" I/O port conflict\n");
+		pr_err("I/O port conflict\n");
 		return -EIO;
 	}
 	if (!request_region(iobase + DAS16M1_82C55, DAS16M1_SIZE2,
 			    driver_das16m1.driver_name)) {
 		release_region(iobase, DAS16M1_SIZE);
-		printk(" I/O port conflict\n");
+		pr_err("I/O port conflict\n");
 		return -EIO;
 	}
 	dev->iobase = iobase;
@@ -697,17 +707,14 @@ static int das16m1_attach(struct comedi_device *dev,
 	if (das16m1_irq_bits(irq) >= 0) {
 		ret = request_irq(irq, das16m1_interrupt, 0,
 				  driver_das16m1.driver_name, dev);
-		if (ret < 0) {
-			printk(", irq unavailable\n");
+		if (ret < 0)
 			return ret;
-		}
 		dev->irq = irq;
-		printk(", irq %u\n", irq);
 	} else if (irq == 0) {
-		printk(", no irq\n");
+		pr_debug("no irq\n");
 	} else {
-		printk(", invalid irq\n"
-		       " valid irqs are 2, 3, 5, 7, 10, 11, 12, or 15\n");
+		pr_err("invalid irq\n"
+		       "valid irqs are 2, 3, 5, 7, 10, 11, 12, or 15\n");
 		return -EINVAL;
 	}
 
@@ -753,7 +760,10 @@ static int das16m1_attach(struct comedi_device *dev,
 	/* 8255 */
 	subdev_8255_init(dev, s, NULL, dev->iobase + DAS16M1_82C55);
 
-	/*  disable upper half of hardware conversion counter so it doesn't mess with us */
+	/*
+	 * disable upper half of hardware conversion counter so it
+	 * doesn't mess with us
+	 */
 	outb(TOTAL_CLEAR, dev->iobase + DAS16M1_8254_FIRST_CNTRL);
 
 	/*  initialize digital output lines */
@@ -771,7 +781,7 @@ static int das16m1_attach(struct comedi_device *dev,
 
 static int das16m1_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: das16m1: remove\n", dev->minor);
+	pr_debug("comedi%d: das16m1: remove\n", dev->minor);
 
 /* das16m1_reset(dev); */
 
-- 
1.7.6.4

