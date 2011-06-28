Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757716Ab1F1MaT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 08:30:19 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:42976 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757443Ab1F1M2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 08:28:20 -0400
From: Matthew Skolaut <tech2077@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Matthew Skolaut <tech2077@gmail.com>
Subject: [PATCH] Staging: comedi: das1800: fixed multiple brace coding style issues and pointer declaration style errors
Date: Tue, 28 Jun 2011 07:28:11 -0500
Message-Id: <1309264091-31297-1-git-send-email-tech2077@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issues

Signed-off-by: Matthew Skolaut <tech2077@gmail.com>
---
 drivers/staging/comedi/drivers/das1800.c |   27 +++++++++++----------------
 1 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das1800.c b/drivers/staging/comedi/drivers/das1800.c
index 60c2b12..9b827f9 100644
--- a/drivers/staging/comedi/drivers/das1800.c
+++ b/drivers/staging/comedi/drivers/das1800.c
@@ -198,7 +198,7 @@ static void das1800_flush_dma(struct comedi_device *dev,
 			      struct comedi_subdevice *s);
 static void das1800_flush_dma_channel(struct comedi_device *dev,
 				      struct comedi_subdevice *s,
-				      unsigned int channel, uint16_t * buffer);
+				      unsigned int channel, uint16_t *buffer);
 static void das1800_handle_fifo_half_full(struct comedi_device *dev,
 					  struct comedi_subdevice *s);
 static void das1800_handle_fifo_not_empty(struct comedi_device *dev,
@@ -1050,9 +1050,8 @@ static void munge_data(struct comedi_device *dev, uint16_t * array,
 
 	/* convert to unsigned type if we are in a bipolar mode */
 	if (!unipolar) {
-		for (i = 0; i < num_elements; i++) {
+		for (i = 0; i < num_elements; i++)
 			array[i] = munge_bipolar_sample(dev, array[i]);
-		}
 	}
 }
 
@@ -1060,7 +1059,7 @@ static void munge_data(struct comedi_device *dev, uint16_t * array,
  * Assumes dma lock is held */
 static void das1800_flush_dma_channel(struct comedi_device *dev,
 				      struct comedi_subdevice *s,
-				      unsigned int channel, uint16_t * buffer)
+				      unsigned int channel, uint16_t *buffer)
 {
 	unsigned int num_bytes, num_samples;
 	struct comedi_cmd *cmd = &s->async->cmd;
@@ -1153,7 +1152,8 @@ static void das1800_handle_fifo_not_empty(struct comedi_device *dev,
 			break;
 		dpnt = inw(dev->iobase + DAS1800_FIFO);
 		/* convert to unsigned type if we are in a bipolar mode */
-		if (!unipolar) ;
+		if (!unipolar)
+			;
 		dpnt = munge_bipolar_sample(dev, dpnt);
 		cfc_write_to_buffer(s, dpnt);
 		if (cmd->stop_src == TRIG_COUNT)
@@ -1364,9 +1364,8 @@ static int control_a_bits(struct comedi_cmd cmd)
 	int control_a;
 
 	control_a = FFEN;	/* enable fifo */
-	if (cmd.stop_src == TRIG_EXT) {
+	if (cmd.stop_src == TRIG_EXT)
 		control_a |= ATEN;
-	}
 	switch (cmd.start_src) {
 	case TRIG_EXT:
 		control_a |= TGEN | CGSL;
@@ -1443,9 +1442,8 @@ static int setup_counters(struct comedi_device *dev, struct comedi_cmd cmd)
 						       &(cmd.convert_arg),
 						       cmd.
 						       flags & TRIG_ROUND_MASK);
-			if (das1800_set_frequency(dev) < 0) {
+			if (das1800_set_frequency(dev) < 0)
 				return -1;
-			}
 		}
 		break;
 	case TRIG_TIMER:	/*  in burst mode */
@@ -1454,9 +1452,8 @@ static int setup_counters(struct comedi_device *dev, struct comedi_cmd cmd)
 					       &(devpriv->divisor2),
 					       &(cmd.scan_begin_arg),
 					       cmd.flags & TRIG_ROUND_MASK);
-		if (das1800_set_frequency(dev) < 0) {
+		if (das1800_set_frequency(dev) < 0)
 			return -1;
-		}
 		break;
 	default:
 		break;
@@ -1553,11 +1550,10 @@ static int das1800_ai_do_cmd(struct comedi_device *dev,
 
 	/* disable dma on TRIG_WAKE_EOS, or TRIG_RT
 	 * (because dma in handler is unsafe at hard real-time priority) */
-	if (cmd.flags & (TRIG_WAKE_EOS | TRIG_RT)) {
+	if (cmd.flags & (TRIG_WAKE_EOS | TRIG_RT))
 		devpriv->irq_dma_bits &= ~DMA_ENABLED;
-	} else {
+	else
 		devpriv->irq_dma_bits |= devpriv->dma_bits;
-	}
 	/*  interrupt on end of conversion for TRIG_WAKE_EOS */
 	if (cmd.flags & TRIG_WAKE_EOS) {
 		/*  interrupt fifo not empty */
@@ -1567,9 +1563,8 @@ static int das1800_ai_do_cmd(struct comedi_device *dev,
 		devpriv->irq_dma_bits |= FIMD;
 	}
 	/*  determine how many conversions we need */
-	if (cmd.stop_src == TRIG_COUNT) {
+	if (cmd.stop_src == TRIG_COUNT)
 		devpriv->count = cmd.stop_arg * cmd.chanlist_len;
-	}
 
 	das1800_cancel(dev, s);
 
-- 
1.7.1

