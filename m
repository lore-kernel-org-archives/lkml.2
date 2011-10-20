Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491Ab1JTGWD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 02:22:03 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64400 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932477Ab1JTGV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 02:21:59 -0400
From: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 19/24] Staging: comedi: fix warning issue in contec_pci_dio.c
Date: Thu, 20 Oct 2011 11:49:05 +0530
Message-Id: <1319091550-2558-19-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1319091550-2558-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1319091550-2558-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed code bracing style and line over 80 character warning issue.
Converted printks to dev_printk.
Removed unnecessary printk statements.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/das16m1.c |   71 +++++++++++++++--------------
 1 files changed, 37 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das16m1.c b/drivers/staging/comedi/drivers/das16m1.c
index a5ce3b2..19a655a 100644
--- a/drivers/staging/comedi/drivers/das16m1.c
+++ b/drivers/staging/comedi/drivers/das16m1.c
@@ -250,7 +250,9 @@ static int das16m1_cmd_test(struct comedi_device *dev,
 	if (err)
 		return 1;
 
-	/* step 2: make sure trigger sources are unique and mutually compatible */
+	/*
+	 * step 2: make sure trigger sources are unique and mutually compatible
+	 */
 	if (cmd->stop_src != TRIG_COUNT && cmd->stop_src != TRIG_NONE)
 		err++;
 	if (cmd->start_src != TRIG_NOW && cmd->start_src != TRIG_EXT)
@@ -320,7 +322,10 @@ static int das16m1_cmd_test(struct comedi_device *dev,
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
@@ -384,20 +389,18 @@ static int das16m1_cmd_exec(struct comedi_device *dev,
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
 
@@ -531,9 +534,8 @@ static void munge_sample_array(short *array, unsigned int num_elements)
 {
 	unsigned int i;
 
-	for (i = 0; i < num_elements; i++) {
+	for (i = 0; i < num_elements; i++)
 		array[i] = munge_sample(array[i]);
-	}
 }
 
 static void das16m1_handler(struct comedi_device *dev, unsigned int status)
@@ -556,12 +558,16 @@ static void das16m1_handler(struct comedi_device *dev, unsigned int status)
 	if (devpriv->adc_count == 0 && hw_counter == devpriv->initial_hw_count) {
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
+		 * following facts. 16 bit hardware counter is initialized
+		 * with value of zero (which really means 0x1000).  The
+		 * counter decrements by one on each conversion (when the
+		 * counter decrements from zero it goes to 0xffff).
+		 * num_samples is a 16 bit variable, so it will roll over
+		 * in a similar fashion to the hardware counter. Work it
+		 * out, and this is what you get.
+		 */
 		num_samples = -hw_counter - devpriv->adc_count;
 	}
 	/*  check if we only need some of the points */
@@ -579,7 +585,8 @@ static void das16m1_handler(struct comedi_device *dev, unsigned int status)
 	devpriv->adc_count += num_samples;
 
 	if (cmd->stop_src == TRIG_COUNT) {
-		if (devpriv->adc_count >= cmd->stop_arg * cmd->chanlist_len) {	/* end of acquisition */
+		/* end of acquisition */
+		if (devpriv->adc_count >= cmd->stop_arg * cmd->chanlist_len) {
 			das16m1_cancel(dev, s);
 			async->events |= COMEDI_CB_EOA;
 		}
@@ -668,25 +675,23 @@ static int das16m1_attach(struct comedi_device *dev,
 
 	iobase = it->options[0];
 
-	printk("comedi%d: das16m1:", dev->minor);
-
 	ret = alloc_private(dev, sizeof(struct das16m1_private_struct));
 	if (ret < 0)
 		return ret;
 
 	dev->board_name = thisboard->name;
 
-	printk(" io 0x%lx-0x%lx 0x%lx-0x%lx",
-	       iobase, iobase + DAS16M1_SIZE,
-	       iobase + DAS16M1_82C55, iobase + DAS16M1_82C55 + DAS16M1_SIZE2);
+	dev_dbg(dev->hw_dev, "io 0x%lx-0x%lx 0x%lx-0x%lx\n",
+		iobase, iobase + DAS16M1_SIZE,
+		iobase + DAS16M1_82C55, iobase + DAS16M1_82C55 + DAS16M1_SIZE2);
 	if (!request_region(iobase, DAS16M1_SIZE, driver_das16m1.driver_name)) {
-		printk(" I/O port conflict\n");
+		dev_err(dev->hw_dev, "I/O port conflict\n");
 		return -EIO;
 	}
 	if (!request_region(iobase + DAS16M1_82C55, DAS16M1_SIZE2,
 			    driver_das16m1.driver_name)) {
 		release_region(iobase, DAS16M1_SIZE);
-		printk(" I/O port conflict\n");
+		dev_err(dev->hw_dev, "I/O port conflict\n");
 		return -EIO;
 	}
 	dev->iobase = iobase;
@@ -696,18 +701,14 @@ static int das16m1_attach(struct comedi_device *dev,
 	/*  make sure it is valid */
 	if (das16m1_irq_bits(irq) >= 0) {
 		ret = request_irq(irq, das16m1_interrupt, 0,
-				  driver_das16m1.driver_name, dev);
-		if (ret < 0) {
-			printk(", irq unavailable\n");
+				driver_das16m1.driver_name, dev);
+		if (ret < 0)
 			return ret;
-		}
 		dev->irq = irq;
-		printk(", irq %u\n", irq);
+		dev_dbg(dev->hw_dev, "irq %u\n", irq);
 	} else if (irq == 0) {
-		printk(", no irq\n");
-	} else {
-		printk(", invalid irq\n"
-		       " valid irqs are 2, 3, 5, 7, 10, 11, 12, or 15\n");
+		dev_err(dev->hw_dev, "invalid irq\n"
+			" valid irqs are 2, 3, 5, 7, 10, 11, 12, or 15\n");
 		return -EINVAL;
 	}
 
@@ -753,7 +754,10 @@ static int das16m1_attach(struct comedi_device *dev,
 	/* 8255 */
 	subdev_8255_init(dev, s, NULL, dev->iobase + DAS16M1_82C55);
 
-	/*  disable upper half of hardware conversion counter so it doesn't mess with us */
+	/*
+	 * disable upper half of hardware conversion counter so it doesn't
+	 * mess with us
+	 */
 	outb(TOTAL_CLEAR, dev->iobase + DAS16M1_8254_FIRST_CNTRL);
 
 	/*  initialize digital output lines */
@@ -771,7 +775,6 @@ static int das16m1_attach(struct comedi_device *dev,
 
 static int das16m1_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: das16m1: remove\n", dev->minor);
 
 /* das16m1_reset(dev); */
 
-- 
1.7.6.4

