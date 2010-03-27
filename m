Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050Ab0C0Bto (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 21:49:44 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57985 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab0C0Btk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 21:49:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=aDoocxgCaTw1HmQlbnEHNJqILY7F3CaiTK3TLZbhVOjJZxpSe6uJqWODU8P9keuq9H
         0u8pk3NqN7JXsEl+bGy0hOBlOzqY195PYSFdV9yfbc/TTYDa20QDqhAWSvgX3UwwRQQH
         LhUb/7ZLoqhoJFCNw7GbQpR/ZilSc8AwxDFlY=
From: Jason Wong <tsanghan@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Jason Wong <tsanghan@gmail.com>
Subject: [PATCH 2/9] Staging: comedi: amplc_pci230: fix brace coding style issue
Date: Sat, 27 Mar 2010 09:48:36 +0800
Message-Id: <1269654523-2682-3-git-send-email-tsanghan@gmail.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <Jason Wong <tsanghan@gmail.com>
References: <Jason Wong <tsanghan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed multiple brace coding style issue.

Signed-off-by: Jason Wong <tsanghan@gmail.com>
---
 drivers/staging/comedi/drivers/amplc_pci230.c |  132 ++++++++++++------------
 1 files changed, 66 insertions(+), 66 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 091a1a5..7fffd96 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -669,9 +669,9 @@ static short pci230_ai_read(struct comedi_device *dev)
 
 	/* If a bipolar range was specified, mangle it (twos
 	 * complement->straight binary). */
-	if (devpriv->ai_bipolar) {
+	if (devpriv->ai_bipolar)
 		data ^= 1 << (thisboard->ai_bits - 1);
-	}
+
 	return data;
 }
 
@@ -680,9 +680,9 @@ static inline unsigned short pci230_ao_mangle_datum(struct comedi_device *dev,
 {
 	/* If a bipolar range was specified, mangle it (straight binary->twos
 	 * complement). */
-	if (devpriv->ao_bipolar) {
+	if (devpriv->ao_bipolar)
 		datum ^= 1 << (thisboard->ao_bits - 1);
-	}
+
 
 	/* PCI230 is 12 bit - stored in upper bits of 16 bit register (lower
 	 * four bits reserved for expansion). */
@@ -734,9 +734,9 @@ static int pci230_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	/* Allocate the private structure area using alloc_private().
 	 * Macro defined in comedidev.h - memsets struct fields to 0. */
-	if ((alloc_private(dev, sizeof(struct pci230_private))) < 0) {
+	if ((alloc_private(dev, sizeof(struct pci230_private))) < 0)
 		return -ENOMEM;
-	}
+
 	spin_lock_init(&devpriv->isr_spinlock);
 	spin_lock_init(&devpriv->res_spinlock);
 	spin_lock_init(&devpriv->ai_stop_spinlock);
@@ -991,9 +991,9 @@ static int pci230_detach(struct comedi_device *dev)
 
 	if (devpriv) {
 		if (devpriv->pci_dev) {
-			if (dev->iobase) {
+			if (dev->iobase)
 				comedi_pci_disable(devpriv->pci_dev);
-			}
+
 			pci_dev_put(devpriv->pci_dev);
 		}
 	}
@@ -1055,9 +1055,9 @@ static void put_resources(struct comedi_device *dev, unsigned int res_mask,
 	     && (res_mask != 0); b <<= 1, i++) {
 		if ((res_mask & b) != 0) {
 			res_mask &= ~b;
-			if (devpriv->res_owner[i] == owner) {
+			if (devpriv->res_owner[i] == owner)
 				devpriv->res_owner[i] = OWNER_NONE;
-			}
+
 		}
 	}
 	spin_unlock_irqrestore(&devpriv->res_spinlock, irqflags);
@@ -1132,11 +1132,11 @@ static int pci230_ai_rinsn(struct comedi_device *dev,
 	}
 	devpriv->adcg = (devpriv->adcg & ~(3 << gainshift))
 	    | (pci230_ai_gain[range] << gainshift);
-	if (devpriv->ai_bipolar) {
+	if (devpriv->ai_bipolar)
 		adccon |= PCI230_ADC_IR_BIP;
-	} else {
+	else
 		adccon |= PCI230_ADC_IR_UNI;
-	}
+
 
 	/* Enable only this channel in the scan list - otherwise by default
 	 * we'll get one sample from each channel. */
@@ -1408,13 +1408,13 @@ static int pci230_ao_cmdtest(struct comedi_device *dev,
 			chan = CR_CHAN(cmd->chanlist[n]);
 			range = CR_RANGE(cmd->chanlist[n]);
 			/* Channel numbers must strictly increase. */
-			if (chan < prev_chan) {
+			if (chan < prev_chan)
 				errors |= seq_err;
-			}
+
 			/* Ranges must be the same. */
-			if (range != first_range) {
+			if (range != first_range)
 				errors |= range_err;
-			}
+
 			prev_chan = chan;
 		}
 		if (errors != 0) {
@@ -1583,9 +1583,9 @@ static int pci230_ao_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 
 	if (cmd->scan_begin_src == TRIG_TIMER) {
 		/* Claim Z2-CT1. */
-		if (!get_one_resource(dev, RES_Z2CT1, OWNER_AOCMD)) {
+		if (!get_one_resource(dev, RES_Z2CT1, OWNER_AOCMD))
 			return -EBUSY;
-		}
+
 	}
 
 	/* Get number of scans required. */
@@ -1609,9 +1609,9 @@ static int pci230_ao_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		unsigned int i;
 
 		dacen = 0;
-		for (i = 0; i < cmd->chanlist_len; i++) {
+		for (i = 0; i < cmd->chanlist_len; i++)
 			dacen |= 1 << CR_CHAN(cmd->chanlist[i]);
-		}
+
 		/* Set channel scan list. */
 		outw(dacen, dev->iobase + PCI230P2_DACEN);
 		/*
@@ -1656,9 +1656,9 @@ static int pci230_ai_check_scan_period(struct comedi_cmd *cmd)
 	int err = 0;
 
 	chanlist_len = cmd->chanlist_len;
-	if (cmd->chanlist_len == 0) {
+	if (cmd->chanlist_len == 0)
 		chanlist_len = 1;
-	}
+
 	min_scan_period = chanlist_len * cmd->convert_arg;
 	if ((min_scan_period < chanlist_len)
 	    || (min_scan_period < cmd->convert_arg)) {
@@ -1777,11 +1777,11 @@ static int pci230_ai_cmdtest(struct comedi_device *dev,
 			 * single-ended or pseudo-differential. */
 			if (cmd->chanlist && (cmd->chanlist_len > 0)) {
 				/* Peek analogue reference of first channel. */
-				if (CR_AREF(cmd->chanlist[0]) == AREF_DIFF) {
+				if (CR_AREF(cmd->chanlist[0]) == AREF_DIFF)
 					max_speed_ai = MAX_SPEED_AI_DIFF;
-				} else {
+				else
 					max_speed_ai = MAX_SPEED_AI_SE;
-				}
+
 			} else {
 				/* No channel list.  Assume single-ended. */
 				max_speed_ai = MAX_SPEED_AI_SE;
@@ -1871,9 +1871,9 @@ static int pci230_ai_cmdtest(struct comedi_device *dev,
 		}
 	} else if (cmd->scan_begin_src == TRIG_TIMER) {
 		/* N.B. cmd->convert_arg is also TRIG_TIMER */
-		if (!pci230_ai_check_scan_period(cmd)) {
+		if (!pci230_ai_check_scan_period(cmd))
 			err++;
-		}
+
 	} else {
 		if (cmd->scan_begin_arg != 0) {
 			cmd->scan_begin_arg = 0;
@@ -1961,13 +1961,13 @@ static int pci230_ai_cmdtest(struct comedi_device *dev,
 					errors |= seq_err;
 				}
 				/* Channels must have same AREF. */
-				if (aref != prev_aref) {
+				if (aref != prev_aref)
 					errors |= aref_err;
-				}
+
 				/* Channel ranges must have same polarity. */
-				if (polarity != prev_polarity) {
+				if (polarity != prev_polarity)
 					errors |= polarity_err;
-				}
+
 				/* Single-ended channel pairs must have same
 				 * range.  */
 				if ((aref != AREF_DIFF)
@@ -1987,9 +1987,9 @@ static int pci230_ai_cmdtest(struct comedi_device *dev,
 		}
 		/* If channel list is a repeating subsequence, need a whole
 		 * number of repeats. */
-		if ((n % subseq_len) != 0) {
+		if ((n % subseq_len) != 0)
 			errors |= seq_err;
-		}
+
 		if ((devpriv->hwver > 0) && (devpriv->hwver < 4)) {
 			/*
 			 * Buggy PCI230+ or PCI260+ requires channel 0 to be
@@ -2228,9 +2228,9 @@ static void pci230_ai_start(struct comedi_device *dev,
 		devpriv->adccon = (devpriv->adccon & ~PCI230_ADC_TRIG_MASK)
 		    | conv;
 		outw(devpriv->adccon, dev->iobase + PCI230_ADCCON);
-		if (cmd->convert_src == TRIG_INT) {
+		if (cmd->convert_src == TRIG_INT)
 			async->inttrig = pci230_ai_inttrig_convert;
-		}
+
 		/* Update FIFO interrupt trigger level, which is currently
 		 * set to "full".  */
 		pci230_ai_update_fifo_trigger_level(dev, s);
@@ -2345,9 +2345,9 @@ static int pci230_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		}
 	}
 	/* Claim resources. */
-	if (!get_resources(dev, res_mask, OWNER_AICMD)) {
+	if (!get_resources(dev, res_mask, OWNER_AICMD))
 		return -EBUSY;
-	}
+
 
 	/* Get number of scans required. */
 	if (cmd->stop_src == TRIG_COUNT) {
@@ -2392,11 +2392,11 @@ static int pci230_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 
 	range = CR_RANGE(cmd->chanlist[0]);
 	devpriv->ai_bipolar = pci230_ai_bipolar[range];
-	if (devpriv->ai_bipolar) {
+	if (devpriv->ai_bipolar)
 		adccon |= PCI230_ADC_IR_BIP;
-	} else {
+	else
 		adccon |= PCI230_ADC_IR_UNI;
-	}
+
 	for (i = 0; i < cmd->chanlist_len; i++) {
 		unsigned int gainshift;
 
@@ -2543,9 +2543,9 @@ static unsigned int pci230_choose_clk_count(uint64_t ns, unsigned int *count,
 
 	for (clk_src = CLK_10MHZ;; clk_src++) {
 		cnt = divide_ns(ns, pci230_timebase[clk_src], round_mode);
-		if ((cnt <= 65536) || (clk_src == CLK_1KHZ)) {
+		if ((cnt <= 65536) || (clk_src == CLK_1KHZ))
 			break;
-		}
+
 	}
 	*count = cnt;
 	return clk_src;
@@ -2575,9 +2575,9 @@ static void pci230_ct_setup_ns_mode(struct comedi_device *dev, unsigned int ct,
 	/* Program clock source. */
 	outb(CLK_CONFIG(ct, clk_src), devpriv->iobase1 + PCI230_ZCLK_SCE);
 	/* Set initial count. */
-	if (count >= 65536) {
+	if (count >= 65536)
 		count = 0;
-	}
+
 	i8254_write(devpriv->iobase1 + PCI230_Z2_CT_BASE, 0, ct, count);
 }
 
@@ -2599,9 +2599,9 @@ static irqreturn_t pci230_interrupt(int irq, void *d)
 	/* Read interrupt status/enable register. */
 	status_int = inb(devpriv->iobase1 + PCI230_INT_STAT);
 
-	if (status_int == PCI230_INT_DISABLE) {
+	if (status_int == PCI230_INT_DISABLE)
 		return IRQ_NONE;
-	}
+
 
 	spin_lock_irqsave(&devpriv->isr_spinlock, irqflags);
 	valid_status_int = devpriv->int_en & status_int;
@@ -2660,9 +2660,9 @@ static void pci230_handle_ao_nofifo(struct comedi_device *dev,
 	struct comedi_async *async = s->async;
 	struct comedi_cmd *cmd = &async->cmd;
 
-	if (!devpriv->ao_continuous && (devpriv->ao_scan_count == 0)) {
+	if (!devpriv->ao_continuous && (devpriv->ao_scan_count == 0))
 		return;
-	}
+
 
 	for (i = 0; i < cmd->chanlist_len; i++) {
 		/* Read sample from Comedi's circular buffer. */
@@ -2711,9 +2711,9 @@ static int pci230_handle_ao_fifo(struct comedi_device *dev,
 	num_scans = comedi_buf_read_n_available(async) / bytes_per_scan;
 	if (!devpriv->ao_continuous) {
 		/* Fixed number of scans. */
-		if (num_scans > devpriv->ao_scan_count) {
+		if (num_scans > devpriv->ao_scan_count)
 			num_scans = devpriv->ao_scan_count;
-		}
+
 		if (devpriv->ao_scan_count == 0) {
 			/* End of acquisition. */
 			events |= COMEDI_CB_EOA;
@@ -2736,21 +2736,21 @@ static int pci230_handle_ao_fifo(struct comedi_device *dev,
 	}
 	if (events == 0) {
 		/* Determine how much room is in the FIFO (in samples). */
-		if ((dacstat & PCI230P2_DAC_FIFO_FULL) != 0) {
+		if ((dacstat & PCI230P2_DAC_FIFO_FULL) != 0)
 			room = PCI230P2_DAC_FIFOROOM_FULL;
-		} else if ((dacstat & PCI230P2_DAC_FIFO_HALF) != 0) {
+		else if ((dacstat & PCI230P2_DAC_FIFO_HALF) != 0)
 			room = PCI230P2_DAC_FIFOROOM_HALFTOFULL;
-		} else if ((dacstat & PCI230P2_DAC_FIFO_EMPTY) != 0) {
+		else if ((dacstat & PCI230P2_DAC_FIFO_EMPTY) != 0)
 			room = PCI230P2_DAC_FIFOROOM_EMPTY;
-		} else {
+		else
 			room = PCI230P2_DAC_FIFOROOM_ONETOHALF;
-		}
+
 		/* Convert room to number of scans that can be added. */
 		room /= cmd->chanlist_len;
 		/* Determine number of scans to process. */
-		if (num_scans > room) {
+		if (num_scans > room)
 			num_scans = room;
-		}
+
 		/* Process scans. */
 		for (n = 0; n < num_scans; n++) {
 			for (i = 0; i < cmd->chanlist_len; i++) {
@@ -2817,14 +2817,14 @@ static void pci230_handle_ai(struct comedi_device *dev,
 	} else {
 		todo = (devpriv->ai_scan_count * scanlen)
 		    - devpriv->ai_scan_pos;
-		if (todo > PCI230_ADC_FIFOLEVEL_HALFFULL) {
+		if (todo > PCI230_ADC_FIFOLEVEL_HALFFULL)
 			todo = PCI230_ADC_FIFOLEVEL_HALFFULL;
-		}
+
 	}
 
-	if (todo == 0) {
+	if (todo == 0)
 		return;
-	}
+
 
 	fifoamount = 0;
 	for (i = 0; i < todo; i++) {
@@ -2906,9 +2906,9 @@ static void pci230_ao_stop(struct comedi_device *dev,
 	spin_lock_irqsave(&devpriv->ao_stop_spinlock, irqflags);
 	started = test_and_clear_bit(AO_CMD_STARTED, &devpriv->state);
 	spin_unlock_irqrestore(&devpriv->ao_stop_spinlock, irqflags);
-	if (!started) {
+	if (!started)
 		return;
-	}
+
 
 	cmd = &s->async->cmd;
 	if (cmd->scan_begin_src == TRIG_TIMER) {
@@ -2968,9 +2968,9 @@ static void pci230_ai_stop(struct comedi_device *dev,
 	spin_lock_irqsave(&devpriv->ai_stop_spinlock, irqflags);
 	started = test_and_clear_bit(AI_CMD_STARTED, &devpriv->state);
 	spin_unlock_irqrestore(&devpriv->ai_stop_spinlock, irqflags);
-	if (!started) {
+	if (!started)
 		return;
-	}
+
 
 	cmd = &s->async->cmd;
 	if (cmd->convert_src == TRIG_TIMER) {
-- 
1.7.0.3

