Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab2FNBKE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 21:10:04 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:51864 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826Ab2FNBKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 21:10:02 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-160.messagelabs.com!1339636198!9375770!3
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: ni_atmio16d: remove the function tracing debug
Date: Wed, 13 Jun 2012 18:09:51 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206131809.51532.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These printk's are #ifdef'ed out with an undefined symbol anyway.
Just remove them.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_atmio16d.c |   24 ++----------------------
 1 files changed, 2 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_atmio16d.c b/drivers/staging/comedi/drivers/ni_atmio16d.c
index 95bee84..87992c9 100644
--- a/drivers/staging/comedi/drivers/ni_atmio16d.c
+++ b/drivers/staging/comedi/drivers/ni_atmio16d.c
@@ -236,10 +236,6 @@ static irqreturn_t atmio16d_interrupt(int irq, void *d)
 	struct comedi_device *dev = d;
 	struct comedi_subdevice *s = dev->subdevices + 0;
 
-#ifdef DEBUG1
-	printk(KERN_DEBUG "atmio16d_interrupt!\n");
-#endif
-
 	comedi_buf_put(s->async, inw(dev->iobase + AD_FIFO_REG));
 
 	comedi_event(dev, s);
@@ -251,9 +247,7 @@ static int atmio16d_ai_cmdtest(struct comedi_device *dev,
 			       struct comedi_cmd *cmd)
 {
 	int err = 0, tmp;
-#ifdef DEBUG1
-	printk(KERN_DEBUG "atmio16d_ai_cmdtest\n");
-#endif
+
 	/* make sure triggers are valid */
 	tmp = cmd->start_src;
 	cmd->start_src &= TRIG_NOW;
@@ -355,9 +349,7 @@ static int atmio16d_ai_cmd(struct comedi_device *dev,
 	unsigned int timer, base_clock;
 	unsigned int sample_count, tmp, chan, gain;
 	int i;
-#ifdef DEBUG1
-	printk(KERN_DEBUG "atmio16d_ai_cmd\n");
-#endif
+
 	/* This is slowly becoming a working command interface. *
 	 * It is still uber-experimental */
 
@@ -517,9 +509,6 @@ static int atmio16d_ai_insn_read(struct comedi_device *dev,
 	int gain;
 	int status;
 
-#ifdef DEBUG1
-	printk(KERN_DEBUG "atmio16d_ai_insn_read\n");
-#endif
 	chan = CR_CHAN(insn->chanspec);
 	gain = CR_RANGE(insn->chanspec);
 
@@ -538,9 +527,6 @@ static int atmio16d_ai_insn_read(struct comedi_device *dev,
 		for (t = 0; t < ATMIO16D_TIMEOUT; t++) {
 			/* check conversion status */
 			status = inw(dev->iobase + STAT_REG);
-#ifdef DEBUG1
-			printk(KERN_DEBUG "status=%x\n", status);
-#endif
 			if (status & STAT_AD_CONVAVAIL) {
 				/* read the data now */
 				data[i] = inw(dev->iobase + AD_FIFO_REG);
@@ -572,9 +558,6 @@ static int atmio16d_ao_insn_read(struct comedi_device *dev,
 				 struct comedi_insn *insn, unsigned int *data)
 {
 	int i;
-#ifdef DEBUG1
-	printk(KERN_DEBUG "atmio16d_ao_insn_read\n");
-#endif
 
 	for (i = 0; i < insn->n; i++)
 		data[i] = devpriv->ao_readback[CR_CHAN(insn->chanspec)];
@@ -588,9 +571,6 @@ static int atmio16d_ao_insn_write(struct comedi_device *dev,
 	int i;
 	int chan;
 	int d;
-#ifdef DEBUG1
-	printk(KERN_DEBUG "atmio16d_ao_insn_write\n");
-#endif
 
 	chan = CR_CHAN(insn->chanspec);
 
-- 
1.7.7

