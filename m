Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685Ab0E2JGA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 05:06:00 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:55339 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab0E2JF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 05:05:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=ptoaJzMzG5QyO6mS4PZ12SQtDl/4L4nCE7H31JuwvNxQ2SwBwPG05CjN4+K+FnwDS/
         36Rp/oLOTbAX0RtM1ayX5qvG3GfBSMb4aznFt0P8z+AH7/pvAn9hTRhT0/9xCLn62T4v
         3M80zCwzsKaFdFlN2KdB5krv+nXea+renOr60=
From: Maurice Dawson <mauricedawson2699@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu, stewart_r@aliencamel.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: comedi: fix over 80 character coding style issues in ni_labpc.c
Date: Sat, 29 May 2010 10:05:44 +0100
Message-Id: <1275123944-1886-1-git-send-email-mauricedawson2699@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the ni_labpc.c file that fixes most over 80 character warnings found by the checkpatch.pl tool. Two lines, 4 and 1035 have not been changed because readability is better and no information is hidden

Signed-off-by: Maurice Dawson <mauricedawson2699@gmail.com>
---
 drivers/staging/comedi/drivers/ni_labpc.c |   81 ++++++++++++++++++++---------
 1 files changed, 57 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
index 67c8a53..bf063ad 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -738,7 +738,8 @@ static int labpc_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		break;
 	case pcmcia_bustype:
 		printk
-		    (" this driver does not support pcmcia cards, use ni_labpc_cs.o\n");
+		    ("this driver does not support pcmcia cards, "
+							"use ni_labpc_cs.o\n");
 		return -EINVAL;
 		break;
 	default:
@@ -866,8 +867,9 @@ static int labpc_ai_chanlist_invalid(const struct comedi_device *dev,
 
 	if (mode == MODE_SINGLE_CHAN_INTERVAL) {
 		if (cmd->chanlist_len > 0xff) {
-			comedi_error(dev,
-				     "ni_labpc: chanlist too long for single channel interval mode\n");
+			comedi_error(dev, "ni_labpc: chanlist too long "
+							"for single channel "
+							"interval mode\n");
 			return 1;
 		}
 	}
@@ -881,23 +883,29 @@ static int labpc_ai_chanlist_invalid(const struct comedi_device *dev,
 		switch (mode) {
 		case MODE_SINGLE_CHAN_INTERVAL:
 			if (CR_CHAN(cmd->chanlist[i]) != channel) {
-				comedi_error(dev,
-					     "channel scanning order specified in chanlist is not supported by hardware.\n");
+				comedi_error(dev, "channel scanning order "
+							"specified in chanlist "
+							"is not supported "
+							"by hardware.\n");
 				return 1;
 			}
 			break;
 		case MODE_MULT_CHAN_UP:
 			if (CR_CHAN(cmd->chanlist[i]) != i) {
-				comedi_error(dev,
-					     "channel scanning order specified in chanlist is not supported by hardware.\n");
+				comedi_error(dev, "channel scanning order "
+							"specified in chanlist "
+							"is not supported "
+							"by hardware.\n");
 				return 1;
 			}
 			break;
 		case MODE_MULT_CHAN_DOWN:
 			if (CR_CHAN(cmd->chanlist[i]) !=
 			    cmd->chanlist_len - i - 1) {
-				comedi_error(dev,
-					     "channel scanning order specified in chanlist is not supported by hardware.\n");
+				comedi_error(dev, "channel scanning order "
+							"specified in chanlist "
+							"is not supported "
+							"by hardware.\n");
 				return 1;
 			}
 			break;
@@ -908,14 +916,14 @@ static int labpc_ai_chanlist_invalid(const struct comedi_device *dev,
 		}
 
 		if (CR_RANGE(cmd->chanlist[i]) != range) {
-			comedi_error(dev,
-				     "entries in chanlist must all have the same range\n");
+			comedi_error(dev, "entries in chanlist must all have "
+							"the same range\n");
 			return 1;
 		}
 
 		if (CR_AREF(cmd->chanlist[i]) != aref) {
-			comedi_error(dev,
-				     "entries in chanlist must all have the same reference\n");
+			comedi_error(dev, "entries in chanlist must all have "
+							"the same reference\n");
 			return 1;
 		}
 	}
@@ -1096,7 +1104,10 @@ static int labpc_ai_cmdtest(struct comedi_device *dev,
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
@@ -1154,25 +1165,36 @@ static int labpc_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 
 	/*  setup hardware conversion counter */
 	if (cmd->stop_src == TRIG_EXT) {
-		/*  load counter a1 with count of 3 (pc+ manual says this is minimum allowed) using mode 0 */
+		/*
+		 * load counter a1 with count of 3
+		 * (pc+ manual says this is minimum allowed)
+		 * using mode 0
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
@@ -1259,7 +1281,8 @@ static int labpc_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	devpriv->write_byte(INTERVAL_LOAD_BITS,
 			    dev->iobase + INTERVAL_LOAD_REG);
 
-	if (cmd->convert_src == TRIG_TIMER || cmd->scan_begin_src == TRIG_TIMER) {
+	if (cmd->convert_src == TRIG_TIMER ||
+					cmd->scan_begin_src == TRIG_TIMER) {
 		/*  set up pacing */
 		labpc_adc_timing(dev, cmd);
 		/*  load counter b0 in mode 3 */
@@ -1619,7 +1642,10 @@ static int labpc_ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 		devpriv->command4_bits |= ADC_DIFF_BIT;
 	devpriv->write_byte(devpriv->command4_bits, dev->iobase + COMMAND4_REG);
 
-	/* initialize pacer counter output to make sure it doesn't cause any problems */
+	/*
+	 * initialize pacer counter output
+	 * to make sure it doesn't cause any problems
+	 */
 	devpriv->write_byte(INIT_A0_BITS, dev->iobase + COUNTER_A_CONTROL_REG);
 
 	labpc_clear_adc_fifo(dev);
@@ -1733,8 +1759,9 @@ static int labpc_eeprom_write_insn(struct comedi_device *dev,
 
 	/*  only allow writes to user area of eeprom */
 	if (channel < 16 || channel > 127) {
-		printk
-		    ("eeprom writes are only allowed to channels 16 through 127 (the pointer and user areas)");
+		printk(kERN_ERR "eeprom writes are only allowed to "
+						"channels 16 through 127 "
+						"(the pointer and user areas)");
 		return -EINVAL;
 	}
 
@@ -1844,7 +1871,10 @@ static void labpc_adc_timing(struct comedi_device *dev, struct comedi_cmd *cmd)
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
@@ -1855,7 +1885,10 @@ static void labpc_adc_timing(struct comedi_device *dev, struct comedi_cmd *cmd)
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

