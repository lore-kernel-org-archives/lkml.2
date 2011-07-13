Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab1GMPCz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 11:02:55 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37807 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723Ab1GMPCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 11:02:54 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 3/3] Staging: comedi: fix warning: line over 80 character issue in das1800.c
Date: Wed, 13 Jul 2011 20:45:26 +0530
Message-Id: <1310570126-31365-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH 3/3]Staging: comedi: fix warning: line over 80 character issue in das1800.c>
References: <[PATCH 3/3]Staging: comedi: fix warning: line over 80 character issue in das1800.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the das1800.c file that fixes up a  warning:line over 80 character found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/das1800.c |   56 +++++++++++++++++++++---------
 1 files changed, 39 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das1800.c b/drivers/staging/comedi/drivers/das1800.c
index ae07deb..9bb6b33 100644
--- a/drivers/staging/comedi/drivers/das1800.c
+++ b/drivers/staging/comedi/drivers/das1800.c
@@ -1617,13 +1617,17 @@ static int das1800_ai_do_cmd(struct comedi_device *dev,
 	outb(control_c, dev->iobase + DAS1800_CONTROL_C);
 	/*  set conversion rate and length for burst mode */
 	if (control_c & BMDE) {
-		/*  program conversion period with number of microseconds minus 1 */
+		/* program conversion period with number
+		 * of microseconds minus 1
+		 */
 		outb(cmd.convert_arg / 1000 - 1,
 		     dev->iobase + DAS1800_BURST_RATE);
 		outb(cmd.chanlist_len - 1, dev->iobase + DAS1800_BURST_LENGTH);
 	}
-	outb(devpriv->irq_dma_bits, dev->iobase + DAS1800_CONTROL_B);	/*  enable irq/dma */
-	outb(control_a, dev->iobase + DAS1800_CONTROL_A);	/* enable fifo and triggering */
+	/* enable irq/dma */
+	outb(devpriv->irq_dma_bits, dev->iobase + DAS1800_CONTROL_B);
+	/* enable fifo and triggering */
+	outb(control_a, dev->iobase + DAS1800_CONTROL_A);
 	outb(CVEN, dev->iobase + DAS1800_STATUS);	/* enable conversions */
 
 	return 0;
@@ -1652,7 +1656,8 @@ static int das1800_ai_rinsn(struct comedi_device *dev,
 	if (CR_RANGE(insn->chanspec) & UNIPOLAR)
 		conv_flags |= UB;
 
-	outb(conv_flags, dev->iobase + DAS1800_CONTROL_C);	/* software conversion enabled */
+	/* software conversion enabled */
+	outb(conv_flags, dev->iobase + DAS1800_CONTROL_C);
 	outb(CVEN, dev->iobase + DAS1800_STATUS);	/* enable conversions */
 	outb(0x0, dev->iobase + DAS1800_CONTROL_A);	/* reset fifo */
 	outb(FFEN, dev->iobase + DAS1800_CONTROL_A);
@@ -1662,11 +1667,15 @@ static int das1800_ai_rinsn(struct comedi_device *dev,
 	range = CR_RANGE(insn->chanspec) & 0x3;
 	chan_range = chan | (range << 8);
 	spin_lock_irqsave(&dev->spinlock, irq_flags);
-	outb(QRAM, dev->iobase + DAS1800_SELECT);	/* select QRAM for baseAddress + 0x0 */
-	outb(0x0, dev->iobase + DAS1800_QRAM_ADDRESS);	/* set QRAM address start */
+	/* select QRAM for baseAddress + 0x0 */
+	outb(QRAM, dev->iobase + DAS1800_SELECT);
+	/* set QRAM address start */
+	outb(0x0, dev->iobase + DAS1800_QRAM_ADDRESS);
 	outw(chan_range, dev->iobase + DAS1800_QRAM);
-	outb(0x0, dev->iobase + DAS1800_QRAM_ADDRESS);	/*finish write to QRAM */
-	outb(ADC, dev->iobase + DAS1800_SELECT);	/* select ADC for baseAddress + 0x0 */
+	/*finish write to QRAM */
+	outb(0x0, dev->iobase + DAS1800_QRAM_ADDRESS);
+	/* select ADC for baseAddress + 0x0 */
+	outb(ADC, dev->iobase + DAS1800_SELECT);
 
 	for (n = 0; n < insn->n; n++) {
 		/* trigger conversion */
@@ -1705,16 +1714,22 @@ static int das1800_ao_winsn(struct comedi_device *dev,
 
 	/*   card expects two's complement data */
 	output = data[0] - (1 << (thisboard->resolution - 1));
-	/*  if the write is to the 'update' channel, we need to remember its value */
+	/*  if the write is to the 'update' channel, we
+	 * need to remember its value
+	 */
 	if (chan == update_chan)
 		devpriv->ao_update_bits = output;
 	/*  write to channel */
 	spin_lock_irqsave(&dev->spinlock, irq_flags);
-	outb(DAC(chan), dev->iobase + DAS1800_SELECT);	/* select dac channel for baseAddress + 0x0 */
+	/* select dac channel for baseAddress + 0x0 */
+	outb(DAC(chan), dev->iobase + DAS1800_SELECT);
 	outw(output, dev->iobase + DAS1800_DAC);
-	/*  now we need to write to 'update' channel to update all dac channels */
+	/* now we need to write to 'update' channel
+	 * to update all dac channels
+	 */
 	if (chan != update_chan) {
-		outb(DAC(update_chan), dev->iobase + DAS1800_SELECT);	/* select 'update' channel for baseAddress + 0x0 */
+		/* select 'update' channel for baseAddress + 0x0 */
+		outb(DAC(update_chan), dev->iobase + DAS1800_SELECT);
 		outw(devpriv->ao_update_bits, dev->iobase + DAS1800_DAC);
 	}
 	spin_unlock_irqrestore(&dev->spinlock, irq_flags);
@@ -1803,13 +1818,18 @@ static unsigned int burst_convert_arg(unsigned int convert_arg, int round_mode)
 	return micro_sec * 1000;
 }
 
-/* utility function that suggests a dma transfer size based on the conversion period 'ns' */
+/* utility function that suggests a dma transfer size based on the
+ * conversion period 'ns'
+ */
 static unsigned int suggest_transfer_size(struct comedi_cmd *cmd)
 {
 	unsigned int size = DMA_BUF_SIZE;
-	static const int sample_size = 2;	/*  size in bytes of one sample from board */
-	unsigned int fill_time = 300000000;	/*  target time in nanoseconds for filling dma buffer */
-	unsigned int max_size;	/*  maximum size we will allow for a transfer */
+	/* size in bytes of one sample from board */
+	static const int sample_size = 2;
+	/* target time in nanoseconds for filling dma buffer */
+	unsigned int fill_time = 300000000;
+	/* maximum size we will allow for a transfer */
+	unsigned int max_size;
 
 	/*  make dma buffer fill in 0.3 seconds for timed modes */
 	switch (cmd->scan_begin_src) {
@@ -1828,7 +1848,9 @@ static unsigned int suggest_transfer_size(struct comedi_cmd *cmd)
 
 	/*  set a minimum and maximum size allowed */
 	max_size = DMA_BUF_SIZE;
-	/*  if we are taking limited number of conversions, limit transfer size to that */
+	/* if we are taking limited number of conversions,
+	 * limit transfer size to that
+	 */
 	if (cmd->stop_src == TRIG_COUNT &&
 	    cmd->stop_arg * cmd->chanlist_len * sample_size < max_size)
 		max_size = cmd->stop_arg * cmd->chanlist_len * sample_size;
-- 
1.6.5.2

