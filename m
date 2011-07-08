Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab1GHMKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 08:10:23 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61480 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab1GHMKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 08:10:22 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 4/4] Staging: comedi: fix warning: line over 80 character issue in rtd520.c
Date: Fri,  8 Jul 2011 17:52:46 +0530
Message-Id: <1310127766-22975-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH]Staging: comedi: fix line over 80 character warning issue in rtd520.c>
References: <[PATCH]Staging: comedi: fix line over 80 character warning issue in rtd520.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the rtd520.c file that fixes up a  warning: line over 80 character found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/rtd520.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index dd00b4a..d31abfb 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -1581,7 +1581,7 @@ static irqreturn_t rtd_interrupt(int irq,	/* interrupt number (ignored) */
 			}
 
 			/*DPRINTK ("rtd520: DMA transfer: %ld to go, istatus %x\n",
-			   devpriv->aiCount, istatus); */
+			  devpriv->aiCount, istatus); */
 			RtdDma0Control(dev,
 				       (devpriv->
 					dma0Control & ~PLX_DMA_START_BIT)
@@ -1592,7 +1592,8 @@ static irqreturn_t rtd_interrupt(int irq,	/* interrupt number (ignored) */
 			}
 			comedi_event(dev, s);
 		} else {
-			/*DPRINTK ("rtd520: No DMA ready: istatus %x\n", istatus); */
+			/*DPRINTK ("rtd520: No DMA ready: istatus %x\n",
+			  istatus); */
 		}
 	}
 	/* Fall through and check for other interrupt sources */
@@ -1604,9 +1605,10 @@ static irqreturn_t rtd_interrupt(int irq,	/* interrupt number (ignored) */
 		return IRQ_HANDLED;
 
 	if (status & IRQM_ADC_ABOUT_CNT) {	/* sample count -> read FIFO */
-		/* since the priority interrupt controller may have queued a sample
-		   counter interrupt, even though we have already finished,
-		   we must handle the possibility that there is no data here */
+		/* since the priority interrupt controller may have queued a
+		   sample counter interrupt, even though we have already
+		   finished, we must handle the possibility that there is no
+		   data here */
 		if (!(fifoStatus & FS_ADC_HEMPTY)) {	/* 0 -> 1/2 full */
 			/*DPRINTK("rtd520: Sample int, reading 1/2FIFO.  fifo_status 0x%x\n",
 			   (fifoStatus ^ 0x6666) & 0x7777); */
@@ -1701,7 +1703,8 @@ transferDone:
 
 	fifoStatus = RtdFifoStatus(dev);	/* DEBUG */
 	DPRINTK
-	    ("rtd520: Acquisition complete. %ld ints, intStat=%x, overStat=%x\n",
+	    ("rtd520: Acquisition complete. %ld ints, intStat=%x, overStat=%x\n"
+,
 	     devpriv->intCount, status,
 	     0xffff & RtdInterruptOverrunStatus(dev));
 
@@ -1714,7 +1717,8 @@ transferDone:
 */
 static int rtd_ai_poll(struct comedi_device *dev, struct comedi_subdevice *s)
 {
-	/* TODO: This needs to mask interrupts, read_dregs, and then re-enable */
+	/* TODO: This needs to mask interrupts, read_dregs, and
+	 * then re - enable */
 	/* Not sure what to do if DMA is active */
 	return s->async->buf_write_count - s->async->buf_read_count;
 }
-- 
1.6.5.2

