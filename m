Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab2FNBW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 21:22:28 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:7562 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921Ab2FNBWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 21:22:25 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-131.messagelabs.com!1339636943!4576028!3
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: pcl812: remove PCL812_EXTDEBUG define and related code
Date: Wed, 13 Jun 2012 18:22:07 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206131822.09694.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCL812_EXTDEBUG define enables a bunch of function tracing debug
messages as well as a dump of the comedi_cmd info during the cmdtest.
There are better ways to do the function tracing and the cmdtest
dump shouldn't be in the driver. Just remove all of it.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/pcl812.c |  100 +-----------------------------
 1 files changed, 4 insertions(+), 96 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl812.c b/drivers/staging/comedi/drivers/pcl812.c
index 511c901..b0eb2ab 100644
--- a/drivers/staging/comedi/drivers/pcl812.c
+++ b/drivers/staging/comedi/drivers/pcl812.c
@@ -119,9 +119,6 @@
 
 #include "8253.h"
 
-/* if this is defined then a lot of messages is printed */
-#undef PCL812_EXTDEBUG
-
 /* hardware types of the cards */
 #define boardPCL812PG	      0	/* and ACL-8112PG */
 #define boardPCL813B	      1
@@ -534,24 +531,6 @@ static int pcl812_do_insn_bits(struct comedi_device *dev,
 	return 2;
 }
 
-#ifdef PCL812_EXTDEBUG
-/*
-==============================================================================
-*/
-static void pcl812_cmdtest_out(int e, struct comedi_cmd *cmd)
-{
-	printk(KERN_INFO "pcl812 e=%d startsrc=%x scansrc=%x convsrc=%x\n", e,
-	       cmd->start_src, cmd->scan_begin_src, cmd->convert_src);
-	printk(KERN_INFO "pcl812 e=%d startarg=%d scanarg=%d convarg=%d\n", e,
-	       cmd->start_arg, cmd->scan_begin_arg, cmd->convert_arg);
-	printk(KERN_INFO "pcl812 e=%d stopsrc=%x scanend=%x\n", e,
-	       cmd->stop_src, cmd->scan_end_src);
-	printk(KERN_INFO "pcl812 e=%d stoparg=%d scanendarg=%d "
-	       "chanlistlen=%d\n", e, cmd->stop_arg, cmd->scan_end_arg,
-	       cmd->chanlist_len);
-}
-#endif
-
 /*
 ==============================================================================
 */
@@ -562,10 +541,6 @@ static int pcl812_ai_cmdtest(struct comedi_device *dev,
 	int err = 0;
 	int tmp, divisor1, divisor2;
 
-#ifdef PCL812_EXTDEBUG
-	printk("pcl812 EDBG: BGN: pcl812_ai_cmdtest(...)\n");
-	pcl812_cmdtest_out(-1, cmd);
-#endif
 	/* step 1: make sure trigger sources are trivially valid */
 
 	tmp = cmd->start_src;
@@ -597,15 +572,8 @@ static int pcl812_ai_cmdtest(struct comedi_device *dev,
 	if (!cmd->stop_src || tmp != cmd->stop_src)
 		err++;
 
-	if (err) {
-#ifdef PCL812_EXTDEBUG
-		pcl812_cmdtest_out(1, cmd);
-		printk
-		    ("pcl812 EDBG: BGN: pcl812_ai_cmdtest(...) err=%d ret=1\n",
-		     err);
-#endif
+	if (err)
 		return 1;
-	}
 
 	/*
 	 * step 2: make sure trigger sources are
@@ -615,15 +583,8 @@ static int pcl812_ai_cmdtest(struct comedi_device *dev,
 	if (cmd->stop_src != TRIG_NONE && cmd->stop_src != TRIG_COUNT)
 		err++;
 
-	if (err) {
-#ifdef PCL812_EXTDEBUG
-		pcl812_cmdtest_out(2, cmd);
-		printk
-		    ("pcl812 EDBG: BGN: pcl812_ai_cmdtest(...) err=%d ret=2\n",
-		     err);
-#endif
+	if (err)
 		return 2;
-	}
 
 	/* step 3: make sure arguments are trivially compatible */
 
@@ -673,15 +634,8 @@ static int pcl812_ai_cmdtest(struct comedi_device *dev,
 		}
 	}
 
-	if (err) {
-#ifdef PCL812_EXTDEBUG
-		pcl812_cmdtest_out(3, cmd);
-		printk
-		    ("pcl812 EDBG: BGN: pcl812_ai_cmdtest(...) err=%d ret=3\n",
-		     err);
-#endif
+	if (err)
 		return 3;
-	}
 
 	/* step 4: fix up any arguments */
 
@@ -696,14 +650,8 @@ static int pcl812_ai_cmdtest(struct comedi_device *dev,
 			err++;
 	}
 
-	if (err) {
-#ifdef PCL812_EXTDEBUG
-		printk
-		    ("pcl812 EDBG: BGN: pcl812_ai_cmdtest(...) err=%d ret=4\n",
-		     err);
-#endif
+	if (err)
 		return 4;
-	}
 
 	return 0;
 }
@@ -717,10 +665,6 @@ static int pcl812_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	unsigned int divisor1 = 0, divisor2 = 0, i, dma_flags, bytes;
 	struct comedi_cmd *cmd = &s->async->cmd;
 
-#ifdef PCL812_EXTDEBUG
-	printk(KERN_DEBUG "pcl812 EDBG: BGN: pcl812_ai_cmd(...)\n");
-#endif
-
 	if (cmd->start_src != TRIG_NOW)
 		return -EINVAL;
 	if (cmd->scan_begin_src != TRIG_FOLLOW)
@@ -844,13 +788,6 @@ static int pcl812_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		set_dma_count(devpriv->dma, devpriv->dmabytestomove[0]);
 		release_dma_lock(dma_flags);
 		enable_dma(devpriv->dma);
-#ifdef PCL812_EXTDEBUG
-		printk
-		    ("pcl812 EDBG:   DMA %d PTR 0x%0x/0x%0x LEN %u/%u EOS %d\n",
-		     devpriv->dma, devpriv->hwdmaptr[0],
-		     devpriv->hwdmaptr[1], devpriv->dmabytestomove[0],
-		     devpriv->dmabytestomove[1], devpriv->ai_eos);
-#endif
 	}
 
 	switch (cmd->convert_src) {
@@ -864,10 +801,6 @@ static int pcl812_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	else							/*  let's go! */
 		outb(devpriv->mode_reg_int | 6, dev->iobase + PCL812_MODE);
 
-#ifdef PCL812_EXTDEBUG
-	printk(KERN_DEBUG "pcl812 EDBG: END: pcl812_ai_cmd(...)\n");
-#endif
-
 	return 0;
 }
 
@@ -987,9 +920,6 @@ static irqreturn_t interrupt_pcl812_ai_dma(int irq, void *d)
 	int len, bufptr;
 	short *ptr;
 
-#ifdef PCL812_EXTDEBUG
-	printk(KERN_DEBUG "pcl812 EDBG: BGN: interrupt_pcl812_ai_dma(...)\n");
-#endif
 	ptr = (short *)devpriv->dmabuf[devpriv->next_dma_buf];
 	len = (devpriv->dmabytestomove[devpriv->next_dma_buf] >> 1) -
 	    devpriv->ai_poll_ptr;
@@ -1022,9 +952,6 @@ static irqreturn_t interrupt_pcl812_ai_dma(int irq, void *d)
 
 	transfer_from_dma_buf(dev, s, ptr, bufptr, len);
 
-#ifdef PCL812_EXTDEBUG
-	printk(KERN_DEBUG "pcl812 EDBG: END: interrupt_pcl812_ai_dma(...)\n");
-#endif
 	return IRQ_HANDLED;
 }
 
@@ -1141,10 +1068,6 @@ static void setup_range_channel(struct comedi_device *dev,
 static void start_pacer(struct comedi_device *dev, int mode,
 			unsigned int divisor1, unsigned int divisor2)
 {
-#ifdef PCL812_EXTDEBUG
-	printk(KERN_DEBUG "pcl812 EDBG: BGN: start_pacer(%d,%u,%u)\n", mode,
-	       divisor1, divisor2);
-#endif
 	outb(0xb4, dev->iobase + PCL812_CTRCTL);
 	outb(0x74, dev->iobase + PCL812_CTRCTL);
 	udelay(1);
@@ -1155,9 +1078,6 @@ static void start_pacer(struct comedi_device *dev, int mode,
 		outb(divisor1 & 0xff, dev->iobase + PCL812_CTR1);
 		outb((divisor1 >> 8) & 0xff, dev->iobase + PCL812_CTR1);
 	}
-#ifdef PCL812_EXTDEBUG
-	printk(KERN_DEBUG "pcl812 EDBG: END: start_pacer(...)\n");
-#endif
 }
 
 /*
@@ -1187,9 +1107,6 @@ static void free_resources(struct comedi_device *dev)
 static int pcl812_ai_cancel(struct comedi_device *dev,
 			    struct comedi_subdevice *s)
 {
-#ifdef PCL812_EXTDEBUG
-	printk(KERN_DEBUG "pcl812 EDBG: BGN: pcl812_ai_cancel(...)\n");
-#endif
 	if (devpriv->ai_dma)
 		disable_dma(devpriv->dma);
 	outb(0, dev->iobase + PCL812_CLRINT);	/* clear INT request */
@@ -1197,9 +1114,6 @@ static int pcl812_ai_cancel(struct comedi_device *dev,
 	outb(devpriv->mode_reg_int | 0, dev->iobase + PCL812_MODE);
 	start_pacer(dev, -1, 0, 0);	/*  stop 8254 */
 	outb(0, dev->iobase + PCL812_CLRINT);	/* clear INT request */
-#ifdef PCL812_EXTDEBUG
-	printk(KERN_DEBUG "pcl812 EDBG: END: pcl812_ai_cancel(...)\n");
-#endif
 	return 0;
 }
 
@@ -1210,9 +1124,6 @@ static void pcl812_reset(struct comedi_device *dev)
 {
 	const struct pcl812_board *board = comedi_board(dev);
 
-#ifdef PCL812_EXTDEBUG
-	printk(KERN_DEBUG "pcl812 EDBG: BGN: pcl812_reset(...)\n");
-#endif
 	outb(0, dev->iobase + PCL812_MUX);
 	outb(0 + devpriv->range_correction, dev->iobase + PCL812_GAIN);
 	devpriv->old_chan_reg = -1;	/*  invalidate chain/gain memory */
@@ -1242,9 +1153,6 @@ static void pcl812_reset(struct comedi_device *dev)
 		break;
 	}
 	udelay(5);
-#ifdef PCL812_EXTDEBUG
-	printk(KERN_DEBUG "pcl812 EDBG: END: pcl812_reset(...)\n");
-#endif
 }
 
 static int pcl812_attach(struct comedi_device *dev, struct comedi_devconfig *it)
-- 
1.7.7

