Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab1H2OQs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 10:16:48 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:38930 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619Ab1H2OQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 10:16:43 -0400
From: Raishankarkm <ravi.shankar@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankarkm <ravi.shankar@greenturtles.in>
Subject: [PATCH 3/3] Staging: comedi: fix line over 80 character issue in das1800.c
Date: Mon, 29 Aug 2011 19:46:24 +0530
Message-Id: <1314627384-14268-1-git-send-email-ravi.shankar@greenturtles.in>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <[PATCH]Staging: comedi: fix line over 80 charcter in das1800.c>
References: <[PATCH]Staging: comedi: fix line over 80 charcter in das1800.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankarkm <ravi.shankar@greenturtles.in>

This is a patch to the das1800.c file that fixes up a line over 80 character warning found by the checkpatch.pl tool

Signed-off-by: Ravishankarkm <ravi.shankar@greenturtles.in>
---
 drivers/staging/comedi/drivers/das1800.c |   33 ++++++++++++++++++++----------
 1 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das1800.c b/drivers/staging/comedi/drivers/das1800.c
index e548a03..8d19853 100644
--- a/drivers/staging/comedi/drivers/das1800.c
+++ b/drivers/staging/comedi/drivers/das1800.c
@@ -1623,11 +1623,15 @@ static int das1800_ai_rinsn(struct comedi_device *dev,
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
@@ -1666,14 +1670,17 @@ static int das1800_ao_winsn(struct comedi_device *dev,
 
 	/*   card expects two's complement data */
 	output = data[0] - (1 << (thisboard->resolution - 1));
-	/*  if the write is to the 'update' channel, we need to remember its value */
+	/* if the write is to the 'update' channel,
+	 * we need to remember its value */
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
+	 * to update all dac channels */
 	if (chan != update_chan) {
 		outb(DAC(update_chan), dev->iobase + DAS1800_SELECT);	/* select 'update' channel for baseAddress + 0x0 */
 		outw(devpriv->ao_update_bits, dev->iobase + DAS1800_DAC);
@@ -1764,12 +1771,15 @@ static unsigned int burst_convert_arg(unsigned int convert_arg, int round_mode)
 	return micro_sec * 1000;
 }
 
-/* utility function that suggests a dma transfer size based on the conversion period 'ns' */
+/* utility function that suggests a dma transfer size based on
+ * the conversion period 'ns' */
 static unsigned int suggest_transfer_size(struct comedi_cmd *cmd)
 {
 	unsigned int size = DMA_BUF_SIZE;
-	static const int sample_size = 2;	/*  size in bytes of one sample from board */
-	unsigned int fill_time = 300000000;	/*  target time in nanoseconds for filling dma buffer */
+	static const int sample_size = 2;	/*  size in bytes of one sample
+						 *  from board */
+	unsigned int fill_time = 300000000;	/* target time in nanoseconds
+						 * for filling dma buffer */
 	unsigned int max_size;	/*  maximum size we will allow for a transfer */
 
 	/*  make dma buffer fill in 0.3 seconds for timed modes */
@@ -1789,7 +1799,8 @@ static unsigned int suggest_transfer_size(struct comedi_cmd *cmd)
 
 	/*  set a minimum and maximum size allowed */
 	max_size = DMA_BUF_SIZE;
-	/*  if we are taking limited number of conversions, limit transfer size to that */
+	/* if we are taking limited number of conversions, limit transfer size
+	 * to that */
 	if (cmd->stop_src == TRIG_COUNT &&
 	    cmd->stop_arg * cmd->chanlist_len * sample_size < max_size)
 		max_size = cmd->stop_arg * cmd->chanlist_len * sample_size;
-- 
1.7.6

