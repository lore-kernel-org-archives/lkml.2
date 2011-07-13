Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab1GMOZG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 10:25:06 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47826 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab1GMOZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 10:25:04 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 2/3] Staging: comedi: fix warning: line over 80 character issue in das1800.c
Date: Wed, 13 Jul 2011 20:07:43 +0530
Message-Id: <1310567863-27860-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH 2/3]Staging: comedi: fix warning: line over 80 character issue in das1800.c>
References: <[PATCH 2/3]Staging: comedi: fix warning: line over 80 character issue in das1800.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the das1800.c file that fixes up a  warning: line over 80 character found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/das1800.c |   55 ++++++++++++++++++++---------
 1 files changed, 38 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das1800.c b/drivers/staging/comedi/drivers/das1800.c
index 639979b..ae07deb 100644
--- a/drivers/staging/comedi/drivers/das1800.c
+++ b/drivers/staging/comedi/drivers/das1800.c
@@ -678,7 +678,9 @@ static int das1800_attach(struct comedi_device *dev,
 	dev->board_ptr = das1800_boards + board;
 	dev->board_name = thisboard->name;
 
-	/*  if it is an 'ao' board with fancy analog out then we need extra io ports */
+	/* if it is an 'ao' board with fancy analog out
+	 * then we need extra io ports
+	 */
 	if (thisboard->ao_ability == 2) {
 		iobase2 = iobase + IOBASE2;
 		if (!request_region(iobase2, DAS1800_SIZE,
@@ -837,8 +839,8 @@ static int das1800_probe(struct comedi_device *dev)
 {
 	int id;
 	int board;
-
-	id = (inb(dev->iobase + DAS1800_DIGITAL) >> 4) & 0xf;	/* get id bits */
+	/* get id bits */
+	id = (inb(dev->iobase + DAS1800_DIGITAL) >> 4) & 0xf;
 	board = ((struct das1800_board *)dev->board_ptr) - das1800_boards;
 
 	switch (id) {
@@ -969,7 +971,9 @@ static void das1800_ai_handler(struct comedi_device *dev)
 	outb(ADC, dev->iobase + DAS1800_SELECT);
 	/*  dma buffer full */
 	if (devpriv->irq_dma_bits & DMA_ENABLED) {
-		/*  look for data from dma transfer even if dma terminal count hasn't happened yet */
+		/* look for data from dma transfer even if dma
+		 * terminal count hasn't happened yet
+		 */
 		das1800_handle_dma(dev, s, status);
 	} else if (status & FHF) {	/*  if fifo half full */
 		das1800_handle_fifo_half_full(dev, s);
@@ -993,7 +997,9 @@ static void das1800_ai_handler(struct comedi_device *dev)
 	if (status & CT0TC) {
 		/*  clear CT0TC interrupt bit */
 		outb(CLEAR_INTR_MASK & ~CT0TC, dev->iobase + DAS1800_STATUS);
-		/*  make sure we get all remaining data from board before quitting */
+		/* make sure we get all remaining data
+		 * from board before quitting
+		 */
 		if (devpriv->irq_dma_bits & DMA_ENABLED)
 			das1800_flush_dma(dev, s);
 		else
@@ -1058,7 +1064,9 @@ static void munge_data(struct comedi_device *dev, uint16_t * array,
 	unsigned int i;
 	int unipolar;
 
-	/* see if card is using a unipolar or bipolar range so we can munge data correctly */
+	/* see if card is using a unipolar or bipolar range
+	 * so we can munge data correctly
+	 */
 	unipolar = inb(dev->iobase + DAS1800_CONTROL_C) & UB;
 
 	/* convert to unsigned type if we are in a bipolar mode */
@@ -1099,8 +1107,9 @@ static void das1800_flush_dma_channel(struct comedi_device *dev,
 	return;
 }
 
-/* flushes remaining data from board when external trigger has stopped acquisition
- * and we are using dma transfers */
+/* flushes remaining data from board when external trigger
+ * has stopped acquisition and we are using dma transfers
+ */
 static void das1800_flush_dma(struct comedi_device *dev,
 			      struct comedi_subdevice *s)
 {
@@ -1178,9 +1187,12 @@ static void das1800_handle_fifo_not_empty(struct comedi_device *dev,
 
 static int das1800_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
 {
-	outb(0x0, dev->iobase + DAS1800_STATUS);	/* disable conversions */
-	outb(0x0, dev->iobase + DAS1800_CONTROL_B);	/* disable interrupts and dma */
-	outb(0x0, dev->iobase + DAS1800_CONTROL_A);	/* disable and clear fifo and stop triggering */
+	/* disable conversions */
+	outb(0x0, dev->iobase + DAS1800_STATUS);
+	/* disable interrupts and dma */
+	outb(0x0, dev->iobase + DAS1800_CONTROL_B);
+	/* disable and clear fifo and stop triggering */
+	outb(0x0, dev->iobase + DAS1800_CONTROL_A);
 	if (devpriv->dma0)
 		disable_dma(devpriv->dma0);
 	if (devpriv->dma1)
@@ -1229,7 +1241,9 @@ static int das1800_ai_do_cmdtest(struct comedi_device *dev,
 	if (err)
 		return 1;
 
-	/* step 2: make sure trigger sources are unique and mutually compatible */
+	/* step 2: make sure trigger sources are
+	 * unique and mutually compatible
+	 */
 
 	/*  uniqueness check */
 	if (cmd->start_src != TRIG_NOW && cmd->start_src != TRIG_EXT)
@@ -1319,7 +1333,9 @@ static int das1800_ai_do_cmdtest(struct comedi_device *dev,
 				err++;
 
 			if (cmd->scan_begin_src == TRIG_TIMER) {
-				/*  if scans are timed faster than conversion rate allows */
+				/* if scans are timed faster than
+				 * conversion rate allows
+				 */
 				if (cmd->convert_arg * cmd->chanlist_len >
 				    cmd->scan_begin_arg) {
 					cmd->scan_begin_arg =
@@ -1328,7 +1344,9 @@ static int das1800_ai_do_cmdtest(struct comedi_device *dev,
 					err++;
 				}
 				tmp_arg = cmd->scan_begin_arg;
-				/* calculate counter values that give desired timing */
+				/* calculate counter values that
+				 * give desired timing
+				 */
 				i8253_cascade_ns_to_timer_2div(TIMER_BASE,
 							       &(devpriv->
 								 divisor1),
@@ -1524,14 +1542,17 @@ static void program_chanlist(struct comedi_device *dev, struct comedi_cmd cmd)
 {
 	int i, n, chan_range;
 	unsigned long irq_flags;
-	const int range_mask = 0x3;	/* masks unipolar/bipolar bit off range */
+	/* masks unipolar/bipolar bit off range */
+	const int range_mask = 0x3;
 	const int range_bitshift = 8;
 
 	n = cmd.chanlist_len;
 	/*  spinlock protects indirect addressing */
 	spin_lock_irqsave(&dev->spinlock, irq_flags);
-	outb(QRAM, dev->iobase + DAS1800_SELECT);	/* select QRAM for baseAddress + 0x0 */
-	outb(n - 1, dev->iobase + DAS1800_QRAM_ADDRESS);	/*set QRAM address start */
+	/* select QRAM for baseAddress + 0x0 */
+	outb(QRAM, dev->iobase + DAS1800_SELECT);
+	/*set QRAM address start */
+	outb(n - 1, dev->iobase + DAS1800_QRAM_ADDRESS);
 	/* make channel / gain list */
 	for (i = 0; i < n; i++) {
 		chan_range =
-- 
1.6.5.2

