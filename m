Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab0FZQC5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 12:02:57 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49086 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab0FZQCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 12:02:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=L1axrh94XYUZY+021RokKlriKDhoE3VXGCnPedbQprkg7htTNdkon46xngl6AGOWay
         etLEVOv1/lWSJpi5bZa+867AwKbECiBgY1ITUScEKHAx47T5Msl+TJJsL0BNLkqM6B9D
         ZqTOnf67ZnPJ9udXmh3hc1Mamb+m3vOyPjEwk=
From: Maurice Dawson <mauricedawson2699@gmail.com>
To: gregkh@suse.de, stewart_r@aliencamel.com, mithlesh@linsyssoft.com,
       u.kleine-koenig@pengutronix.de, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: comedi: fix over 80 character coding style issue in ni_labpc.c
Date: Sat, 26 Jun 2010 17:02:25 +0100
Message-Id: <1277568145-2214-1-git-send-email-mauricedawson2699@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the ni_labpc.c file that fixes up 80 character warnings found by the checkpatch.pl tool

Signed-off-by: Maurice Dawson <mauricedawson2699@gmail.com>
---
 drivers/staging/comedi/drivers/ni_labpc.c |   38 ++++++++++++++++++++++------
 1 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
index 67c8a53..60c03b8 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -1096,7 +1096,10 @@ static int labpc_ai_cmdtest(struct comedi_device *dev,
 			err++;
 		}
 		break;
-		/*  TRIG_EXT doesn't care since it doesn't trigger off a numbered channel */
+		/*
+		 * TRIG_EXT doesn't care since it doesn't
+		 * trigger off a numbered channel
+		 */
 	default:
 		break;
 	}
@@ -1154,25 +1157,35 @@ static int labpc_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 
 	/*  setup hardware conversion counter */
 	if (cmd->stop_src == TRIG_EXT) {
-		/*  load counter a1 with count of 3 (pc+ manual says this is minimum allowed) using mode 0 */
+		/*
+		 * load counter a1 with count of 3
+		 * (pc+ manual says this is minimum allowed) using mode 0
+		 */
 		ret = labpc_counter_load(dev, dev->iobase + COUNTER_A_BASE_REG,
 					 1, 3, 0);
 		if (ret < 0) {
 			comedi_error(dev, "error loading counter a1");
 			return -1;
 		}
-	} else			/*  otherwise, just put a1 in mode 0 with no count to set its output low */
+	} else			/*
+				 * otherwise, just put a1 in mode 0
+				 * with no count to set its output low
+				 */
 		devpriv->write_byte(INIT_A1_BITS,
 				    dev->iobase + COUNTER_A_CONTROL_REG);
 
 	/*  figure out what method we will use to transfer data */
 	if (devpriv->dma_chan &&	/*  need a dma channel allocated */
-	    /*  dma unsafe at RT priority, and too much setup time for TRIG_WAKE_EOS for */
+		/*
+		 * dma unsafe at RT priority,
+		 * and too much setup time for TRIG_WAKE_EOS for
+		 */
 	    (cmd->flags & (TRIG_WAKE_EOS | TRIG_RT)) == 0 &&
 	    /*  only available on the isa boards */
 	    thisboard->bustype == isa_bustype) {
 		xfer = isa_dma_transfer;
-	} else if (thisboard->register_layout == labpc_1200_layout &&	/*  pc-plus has no fifo-half full interrupt */
+		/* pc-plus has no fifo-half full interrupt */
+	} else if (thisboard->register_layout == labpc_1200_layout &&
 		   /*  wake-end-of-scan should interrupt on fifo not empty */
 		   (cmd->flags & TRIG_WAKE_EOS) == 0 &&
 		   /*  make sure we are taking more than just a few points */
@@ -1619,7 +1632,10 @@ static int labpc_ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 		devpriv->command4_bits |= ADC_DIFF_BIT;
 	devpriv->write_byte(devpriv->command4_bits, dev->iobase + COMMAND4_REG);
 
-	/* initialize pacer counter output to make sure it doesn't cause any problems */
+	/*
+	 * initialize pacer counter output to make sure it doesn't
+	 * cause any problems
+	 */
 	devpriv->write_byte(INIT_A0_BITS, dev->iobase + COUNTER_A_CONTROL_REG);
 
 	labpc_clear_adc_fifo(dev);
@@ -1844,7 +1860,10 @@ static void labpc_adc_timing(struct comedi_device *dev, struct comedi_cmd *cmd)
 		unsigned int scan_period;
 
 		scan_period = labpc_ai_scan_period(cmd);
-		/* calculate cascaded counter values that give desired scan timing */
+		/*
+		 * calculate cascaded counter values
+		 * that give desired scan timing
+		 */
 		i8253_cascade_ns_to_timer_2div(LABPC_TIMER_BASE,
 					       &(devpriv->divisor_b1),
 					       &(devpriv->divisor_b0),
@@ -1855,7 +1874,10 @@ static void labpc_adc_timing(struct comedi_device *dev, struct comedi_cmd *cmd)
 		unsigned int convert_period;
 
 		convert_period = labpc_ai_convert_period(cmd);
-		/* calculate cascaded counter values that give desired conversion timing */
+		/*
+		 * calculate cascaded counter values
+		 * that give desired conversion timing
+		 */
 		i8253_cascade_ns_to_timer_2div(LABPC_TIMER_BASE,
 					       &(devpriv->divisor_a0),
 					       &(devpriv->divisor_b0),
-- 
1.7.0.4

