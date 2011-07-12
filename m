Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625Ab1GLEZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 00:25:45 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60690 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab1GLEZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 00:25:44 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 16/16] Staging: comedi: fix line over 80 character issue in pcl818.c
Date: Tue, 12 Jul 2011 10:08:26 +0530
Message-Id: <1310445506-3906-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH 15/15]Staging: comedi: fix line over 80 character issue in pcl818.c>
References: <[PATCH 15/15]Staging: comedi: fix line over 80 character issue in pcl818.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the pcl818.c file that fixes up a line over 80 character warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/pcl818.c |   40 ++++++++++++++++++++-----------
 1 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index e3e70cb..1cd4558 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -721,7 +721,8 @@ static irqreturn_t interrupt_pcl818_ai_mode13_dma_rtc(int irq, void *d)
 		if (ofs_dats < 0)
 			ofs_dats = (devpriv->dmasamplsize) + ofs_dats;
 		if (!ofs_dats)
-			return IRQ_HANDLED;	/*  exit=no new samples from last call */
+			/* exit=no new samples from last call */
+			return IRQ_HANDLED;
 		/*  obsluz data */
 		i = devpriv->last_top_dma - 1;
 		i &= (devpriv->dmasamplsize - 1);
@@ -800,7 +801,8 @@ static irqreturn_t interrupt_pcl818_ai_mode13_fifo(int irq, void *d)
 	struct comedi_subdevice *s = dev->subdevices + 0;
 	int i, len, lo;
 
-	outb(0, dev->iobase + PCL818_FI_INTCLR);	/*  clear fifo int request */
+	/* clear fifo int request */
+	outb(0, dev->iobase + PCL818_FI_INTCLR);
 
 	lo = inb(dev->iobase + PCL818_FI_STATUS);
 
@@ -944,8 +946,10 @@ static void pcl818_ai_mode13dma_int(int mode, struct comedi_device *dev,
 	bytes = devpriv->hwdmasize[0];
 	if (!devpriv->neverending_ai) {
 		bytes = devpriv->ai_n_chan * devpriv->ai_scans * sizeof(short);	/*  how many */
-		devpriv->dma_runs_to_end = bytes / devpriv->hwdmasize[0];	/*  how many DMA pages we must fiil */
-		devpriv->last_dma_run = bytes % devpriv->hwdmasize[0];	/* on last dma transfer must be moved */
+		/* how many DMA pages we must fiil */
+		devpriv->dma_runs_to_end = bytes / devpriv->hwdmasize[0];
+		/* on last dma transfer must be moved */
+		devpriv->last_dma_run = bytes % devpriv->hwdmasize[0];
 		devpriv->dma_runs_to_end--;
 		if (devpriv->dma_runs_to_end >= 0)
 			bytes = devpriv->hwdmasize[0];
@@ -962,10 +966,12 @@ static void pcl818_ai_mode13dma_int(int mode, struct comedi_device *dev,
 
 	if (mode == 1) {
 		devpriv->ai_mode = INT_TYPE_AI1_DMA;
-		outb(0x87 | (dev->irq << 4), dev->iobase + PCL818_CONTROL);	/* Pacer+IRQ+DMA */
+		/* Pacer+IRQ+DMA */
+		outb(0x87 | (dev->irq << 4), dev->iobase + PCL818_CONTROL);
 	} else {
 		devpriv->ai_mode = INT_TYPE_AI3_DMA;
-		outb(0x86 | (dev->irq << 4), dev->iobase + PCL818_CONTROL);	/* Ext trig+IRQ+DMA */
+		/* Ext trig+IRQ+DMA */
+		outb(0x86 | (dev->irq << 4), dev->iobase + PCL818_CONTROL);
 	};
 }
 
@@ -1003,10 +1009,12 @@ static void pcl818_ai_mode13dma_rtc(int mode, struct comedi_device *dev,
 
 	if (mode == 1) {
 		devpriv->int818_mode = INT_TYPE_AI1_DMA_RTC;
-		outb(0x07 | (dev->irq << 4), dev->iobase + PCL818_CONTROL);	/* Pacer+DMA */
+		/* Pacer+DMA */
+		outb(0x07 | (dev->irq << 4), dev->iobase + PCL818_CONTROL);
 	} else {
 		devpriv->int818_mode = INT_TYPE_AI3_DMA_RTC;
-		outb(0x06 | (dev->irq << 4), dev->iobase + PCL818_CONTROL);	/* Ext trig+DMA */
+		/* Ext trig+DMA */
+		outb(0x06 | (dev->irq << 4), dev->iobase + PCL818_CONTROL);
 	};
 }
 #endif
@@ -1051,7 +1059,8 @@ static int pcl818_ai_cmd_mode(int mode, struct comedi_device *dev,
 	devpriv->dma_runs_to_end = 0;
 
 	if ((devpriv->ai_scans == 0) || (devpriv->ai_scans == -1))
-		devpriv->neverending_ai = 1;	/* well, user want neverending */
+		/* well, user want neverending */
+		devpriv->neverending_ai = 1;
 
 	if (mode == 1) {
 		i8253_cascade_ns_to_timer(devpriv->i8253_osc_base, &divisor1,
-- 
1.6.5.2

