Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab1GKOmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 10:42:39 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33829 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab1GKOmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 10:42:38 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 15/15] Staging: comedi: fix line over 80 character issue in pcl818.c
Date: Mon, 11 Jul 2011 20:25:18 +0530
Message-Id: <1310396118-3138-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH 14/14]Staging: comedi: fix line over 80 character warning issue in pcl818.c>
References: <[PATCH 14/14]Staging: comedi: fix line over 80 character warning issue in pcl818.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the pcl818.c file that fixes up a line over 80 character warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/pcl818.c |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index 4fa6d08..e3e70cb 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -366,12 +366,16 @@ struct pcl818_private {
 	int i8253_osc_base;	/*  1/frequency of on board oscilator in ns */
 	int irq_free;		/*  1=have allocated IRQ */
 	int irq_blocked;	/*  1=IRQ now uses any subdev */
-	int irq_was_now_closed;	/*  when IRQ finish, there's stored int818_mode for last interrupt */
-	int ai_mode;		/*  who now uses IRQ - 1=AI1 int, 2=AI1 dma, 3=AI3 int, 4AI3 dma */
-	struct comedi_subdevice *last_int_sub;	/*  ptr to subdevice which now finish */
+	/* when IRQ finish, there's stored int818_mode for last interrupt */
+	int irq_was_now_closed;
+	/* who now uses IRQ - 1=AI1 int, 2=AI1 dma, 3=AI3 int, 4AI3 dma */
+	int ai_mode;
+	/* ptr to subdevice which now finish */
+	struct comedi_subdevice *last_int_sub;
 	int ai_act_scan;	/*  how many scans we finished */
 	int ai_act_chan;	/*  actual position in actual scan */
-	unsigned int act_chanlist[16];	/*  MUX setting for actual AI operations */
+	/* MUX setting for actual AI operations */
+	unsigned int act_chanlist[16];
 	unsigned int act_chanlist_len;	/*  how long is actual MUX list */
 	unsigned int act_chanlist_pos;	/*  actual position in MUX list */
 	unsigned int ai_scans;	/*  len of scanlist */
@@ -570,7 +574,6 @@ conv_finish:
 	low = inb(dev->iobase + PCL818_AD_LO);
 	comedi_buf_put(s->async, ((inb(dev->iobase + PCL818_AD_HI) << 4) | (low >> 4)));	/*  get one sample */
 	outb(0, dev->iobase + PCL818_CLRINT);	/* clear INT request */
-
 	if ((low & 0xf) != devpriv->act_chanlist[devpriv->act_chanlist_pos]) {	/*  dropout! */
 		printk
 		    ("comedi: A/D mode1/3 IRQ - channel dropout %x!=%x !\n",
@@ -652,7 +655,8 @@ static irqreturn_t interrupt_pcl818_ai_mode13_dma(int irq, void *d)
 			return IRQ_HANDLED;
 		}
 
-		comedi_buf_put(s->async, ptr[bufptr++] >> 4);	/*  get one sample */
+		/* get one sample */
+		comedi_buf_put(s->async, ptr[bufptr++] >> 4);
 
 		devpriv->act_chanlist_pos++;
 		if (devpriv->act_chanlist_pos >= devpriv->act_chanlist_len)
@@ -709,9 +713,11 @@ static irqreturn_t interrupt_pcl818_ai_mode13_dma_rtc(int irq, void *d)
 
 		if (top1 != top2)
 			return IRQ_HANDLED;
-		top1 = devpriv->hwdmasize[0] - top1;	/*  where is now DMA in buffer */
+		/* where is now DMA in buffer */
+		top1 = devpriv->hwdmasize[0] - top1;
 		top1 >>= 1;
-		ofs_dats = top1 - devpriv->last_top_dma;	/*  new samples from last call */
+		/* new samples from last call */
+		ofs_dats = top1 - devpriv->last_top_dma;
 		if (ofs_dats < 0)
 			ofs_dats = (devpriv->dmasamplsize) + ofs_dats;
 		if (!ofs_dats)
-- 
1.6.5.2

