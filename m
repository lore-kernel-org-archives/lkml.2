Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab2EAG0D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 02:26:03 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53700 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727Ab2EAGZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 02:25:58 -0400
From: Ravishankar Karkala Mallikarjunayya <ravishankarkm32@gmail.com>
To: gregkh@linuxfoundation.org, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 5/5] Staging: comedi: fix line over 80 character issue in rtd520.c
Date: Tue,  1 May 2012 11:55:10 +0530
Message-Id: <1335853510-29545-6-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1335853510-29545-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1335853510-29545-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the rtd520.c file that fixes up a line
over 80 character warning found by the checkpatch.pl tool.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/rtd520.c |   62 +++++++++++++++++++++----------
 1 files changed, 42 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 1384419..0134ecf 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -377,8 +377,11 @@ struct rtdPrivate {
 	u8 utcCtrl[4];		/* crtl mode for 3 utc + read back */
 	u8 dioStatus;		/* could be read back (dio0Ctrl) */
 #ifdef USE_DMA
-	/* Always DMA 1/2 FIFO.  Buffer (dmaBuff?) is (at least) twice that size.
-	   After transferring, interrupt processes 1/2 FIFO and passes to comedi */
+	/*
+	 * Always DMA 1/2 FIFO.  Buffer (dmaBuff?) is (at least) twice that
+	 * size.  After transferring, interrupt processes 1/2 FIFO and
+	 * passes to comedi
+	 */
 	s16 dma0Offset;		/* current processing offset (0, 1/2) */
 	uint16_t *dma0Buff[DMA_CHAIN_COUNT];	/* DMA buffers (for ADC) */
 	dma_addr_t dma0BuffPhysAddr[DMA_CHAIN_COUNT];	/* physical addresses */
@@ -581,7 +584,8 @@ struct rtdPrivate {
 
 /* User output N source select (write only) */
 #define RtdUsrOutSource(dev, n, v) \
-	writel(v, devpriv->las0+((n <= 0) ? LAS0_UOUT0_SELECT : LAS0_UOUT1_SELECT))
+	writel(v, devpriv->las0+((n <= 0) ? LAS0_UOUT0_SELECT : \
+				LAS0_UOUT1_SELECT))
 
 /* Digital IO */
 #define RtdDio0Read(dev) \
@@ -608,7 +612,8 @@ struct rtdPrivate {
 /* Write one data value (sign + 12bit + marker bits) */
 /* Note: matches what DMA would put.  Actual value << 3 */
 #define RtdDacFifoPut(dev, n, v) \
-	writew((v), devpriv->las1 + (((n) == 0) ? LAS1_DAC1_FIFO : LAS1_DAC2_FIFO))
+	writew((v), devpriv->las1 + (((n) == 0) ? LAS1_DAC1_FIFO : \
+				LAS1_DAC2_FIFO))
 
 /* Start single DAC conversion */
 #define RtdDacUpdate(dev, n) \
@@ -625,7 +630,8 @@ struct rtdPrivate {
 
 /* Reset DAC FIFO */
 #define RtdDacClearFifo(dev, n) \
-	writel(0, devpriv->las0+(((n) == 0) ? LAS0_DAC1_RESET : LAS0_DAC2_RESET))
+	writel(0, devpriv->las0+(((n) == 0) ? LAS0_DAC1_RESET : \
+				LAS0_DAC2_RESET))
 
 /* Set source for DMA 0 (write only, shadow?) */
 #define RtdDma0Source(dev, n) \
@@ -737,7 +743,10 @@ static int rtd_ai_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
 			  struct comedi_cmd *cmd);
 static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s);
 static int rtd_ai_cancel(struct comedi_device *dev, struct comedi_subdevice *s);
-/* static int rtd_ai_poll (struct comedi_device *dev,struct comedi_subdevice *s); */
+/*
+ * static int rtd_ai_poll(struct comedi_device *dev,
+ *			  struct comedi_subdevice *s);
+ */
 static int rtd_ns_to_timer(unsigned int *ns, int roundMode);
 static irqreturn_t rtd_interrupt(int irq, void *d);
 static int rtd520_probe_fifo_depth(struct comedi_device *dev);
@@ -857,7 +866,9 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 			DPRINTK("rtd520: PCI latency = %d\n", pci_latency);
 		}
 
-		/* Undocumented EPLD version (doesn't match RTD driver results) */
+		/*
+		 * Undocumented EPLD version (doesn't match RTD driver results)
+		 */
 		/*DPRINTK ("rtd520: Reading epld from %p\n",
 		   devpriv->las0+0);
 		   epld_version = readl (devpriv->las0+0);
@@ -970,9 +981,11 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 #ifdef USE_DMA
 	if (dev->irq > 0) {
 		printk("( DMA buff=%d )\n", DMA_CHAIN_COUNT);
-		/* The PLX9080 has 2 DMA controllers, but there could be 4 sources:
-		   ADC, digital, DAC1, and DAC2.  Since only the ADC supports cmd mode
-		   right now, this isn't an issue (yet) */
+		/*
+		 * The PLX9080 has 2 DMA controllers, but there could be
+		 * 4 sources: ADC, digital, DAC1, and DAC2.  Since only the
+		 * ADC supports cmd mode right now, this isn't an issue (yet)
+		 */
 		devpriv->dma0Offset = 0;
 
 		for (index = 0; index < DMA_CHAIN_COUNT; index++) {
@@ -988,10 +1001,14 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 			}
 			/*DPRINTK ("buff[%d] @ %p virtual, %x PCI\n",
 			   index,
-			   devpriv->dma0Buff[index], devpriv->dma0BuffPhysAddr[index]); */
+			   devpriv->dma0Buff[index],
+			   devpriv->dma0BuffPhysAddr[index]); */
 		}
 
-		/* setup DMA descriptor ring (use cpu_to_le32 for byte ordering?) */
+		/*
+		 * setup DMA descriptor ring (use cpu_to_le32 for byte
+		 * ordering?)
+		 */
 		devpriv->dma0Chain =
 		    pci_alloc_consistent(devpriv->pci_dev,
 					 sizeof(struct plx_dma_desc) *
@@ -1278,7 +1295,8 @@ static int rtd520_probe_fifo_depth(struct comedi_device *dev)
 		}
 	}
 	if (i == limit) {
-		printk(KERN_INFO "\ncomedi: %s: failed to probe fifo size.\n", DRV_NAME);
+		printk(KERN_INFO "\ncomedi: %s: failed to probe fifo size.\n",
+		       DRV_NAME);
 		return -EIO;
 	}
 	RtdAdcClearFifo(dev);
@@ -1378,9 +1396,10 @@ static int ai_read_n(struct comedi_device *dev, struct comedi_subdevice *s,
 		d = RtdAdcFifoGet(dev);	/* get 2s comp value */
 
 		d = d >> 3;	/* low 3 bits are marker lines */
-		if (CHAN_ARRAY_TEST(devpriv->chanBipolar, s->async->cur_chan))
-			sample = d + 2048;	/* convert to comedi unsigned data */
-		else
+		if (CHAN_ARRAY_TEST(devpriv->chanBipolar, s->async->cur_chan)) {
+			/* convert to comedi unsigned data */
+			sample = d + 2048;
+		} else
 			sample = d;
 
 		if (!comedi_buf_put(s->async, sample))
@@ -1406,9 +1425,10 @@ static int ai_read_dregs(struct comedi_device *dev, struct comedi_subdevice *s)
 		}
 
 		d = d >> 3;	/* low 3 bits are marker lines */
-		if (CHAN_ARRAY_TEST(devpriv->chanBipolar, s->async->cur_chan))
-			sample = d + 2048;	/* convert to comedi unsigned data */
-		else
+		if (CHAN_ARRAY_TEST(devpriv->chanBipolar, s->async->cur_chan)) {
+			/* convert to comedi unsigned data */
+			sample = d + 2048;
+		} else
 			sample = d;
 
 		if (!comedi_buf_put(s->async, sample))
@@ -1525,7 +1545,9 @@ static int ai_process_dma(struct comedi_device *dev, struct comedi_subdevice *s)
 	comedi_buf_memcpy_to(s->async, 0, dp, n);
 	comedi_buf_write_free(s->async, n);
 
-	/* always at least 1 scan -- 1/2 FIFO is larger than our max scan list */
+	/*
+	 * always at least 1 scan -- 1/2 FIFO is larger than our max scan list
+	 */
 	s->async->events |= COMEDI_CB_BLOCK | COMEDI_CB_EOS;
 
 	if (++devpriv->dma0Offset >= DMA_CHAIN_COUNT) {	/* next buffer */
-- 
1.7.0.4

