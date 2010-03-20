Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab0CTSP0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 14:15:26 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:35114 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab0CTSPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 14:15:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=N9v45e6VnDJcG95DF+JKHTgNpYoNWst3BMcEbajTboUHDJMLPyh/daLH3IfVIBTjqN
         QLMFQkyOl4Kfv/k5MnmIAUl0r7q+6Hfhqw7KEJAM8CGxaNS15q7YKvmolbFTXmrhokpZ
         MrdU6uSfNbDjQ7AfpYZd/6jnyymkqghs7ST8g=
From: Jason Wong <tsanghan@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Jason Wong <tsanghan@gmail.com>
Subject: [PATCH 1/9] Staging: comedi: amplc_pci224: fixed multiple brace coding style issue
Date: Sun, 21 Mar 2010 02:14:02 +0800
Message-Id: <1269108850-1414-2-git-send-email-tsanghan@gmail.com>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <Jason Wong <tsanghan@gmail.com>
References: <Jason Wong <tsanghan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed multiple coding style issue.

Signed-off-by: Jason Wong <tsanghan@gmail.com>
---
 drivers/staging/comedi/drivers/amplc_pci224.c |  114 ++++++++++++------------
 1 files changed, 57 insertions(+), 57 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci224.c b/drivers/staging/comedi/drivers/amplc_pci224.c
index b41e5e5..7bc824b 100644
--- a/drivers/staging/comedi/drivers/amplc_pci224.c
+++ b/drivers/staging/comedi/drivers/amplc_pci224.c
@@ -495,9 +495,9 @@ pci224_ao_insn_write(struct comedi_device *dev, struct comedi_subdevice *s,
 
 	/* Writing a list of values to an AO channel is probably not
 	 * very useful, but that's how the interface is defined. */
-	for (i = 0; i < insn->n; i++) {
+	for (i = 0; i < insn->n; i++)
 		pci224_ao_set_data(dev, chan, range, data[i]);
-	}
+
 	return i;
 }
 
@@ -518,9 +518,9 @@ pci224_ao_insn_read(struct comedi_device *dev, struct comedi_subdevice *s,
 
 	chan = CR_CHAN(insn->chanspec);
 
-	for (i = 0; i < insn->n; i++) {
+	for (i = 0; i < insn->n; i++)
 		data[i] = devpriv->ao_readback[chan];
-	}
+
 
 	return i;
 }
@@ -543,9 +543,9 @@ static void pci224_ao_stop(struct comedi_device *dev,
 {
 	unsigned long flags;
 
-	if (!test_and_clear_bit(AO_CMD_STARTED, &devpriv->state)) {
+	if (!test_and_clear_bit(AO_CMD_STARTED, &devpriv->state))
 		return;
-	}
+
 
 	spin_lock_irqsave(&devpriv->ao_spinlock, flags);
 	/* Kill the interrupts. */
@@ -596,11 +596,11 @@ static void pci224_ao_start(struct comedi_device *dev,
 	} else {
 		/* Enable interrupts. */
 		spin_lock_irqsave(&devpriv->ao_spinlock, flags);
-		if (cmd->stop_src == TRIG_EXT) {
+		if (cmd->stop_src == TRIG_EXT)
 			devpriv->intsce = PCI224_INTR_EXT | PCI224_INTR_DAC;
-		} else {
+		else
 			devpriv->intsce = PCI224_INTR_DAC;
-		}
+
 		outb(devpriv->intsce, devpriv->iobase1 + PCI224_INT_SCE);
 		spin_unlock_irqrestore(&devpriv->ao_spinlock, flags);
 	}
@@ -629,9 +629,9 @@ static void pci224_ao_handle_fifo(struct comedi_device *dev,
 	num_scans = comedi_buf_read_n_available(s->async) / bytes_per_scan;
 	if (!devpriv->ao_stop_continuous) {
 		/* Fixed number of scans. */
-		if (num_scans > devpriv->ao_stop_count) {
+		if (num_scans > devpriv->ao_stop_count)
 			num_scans = devpriv->ao_stop_count;
-		}
+
 	}
 
 	/* Determine how much room is in the FIFO (in samples). */
@@ -668,13 +668,13 @@ static void pci224_ao_handle_fifo(struct comedi_device *dev,
 		}
 	}
 	/* Determine how many new scans can be put in the FIFO. */
-	if (cmd->chanlist_len) {
+	if (cmd->chanlist_len)
 		room /= cmd->chanlist_len;
-	}
+
 	/* Determine how many scans to process. */
-	if (num_scans > room) {
+	if (num_scans > room)
 		num_scans = room;
-	}
+
 	/* Process scans. */
 	for (n = 0; n < num_scans; n++) {
 		cfc_read_array_from_buffer(s, &devpriv->ao_scan_vals[0],
@@ -717,19 +717,19 @@ static void pci224_ao_handle_fifo(struct comedi_device *dev,
 			trig = PCI224_DACCON_TRIG_Z2CT0;
 		} else {
 			/* cmd->scan_begin_src == TRIG_EXT */
-			if (cmd->scan_begin_arg & CR_INVERT) {
+			if (cmd->scan_begin_arg & CR_INVERT)
 				trig = PCI224_DACCON_TRIG_EXTN;
-			} else {
+			else
 				trig = PCI224_DACCON_TRIG_EXTP;
-			}
+
 		}
 		devpriv->daccon = COMBINE(devpriv->daccon, trig,
 					  PCI224_DACCON_TRIG_MASK);
 		outw(devpriv->daccon, dev->iobase + PCI224_DACCON);
 	}
-	if (s->async->events) {
+	if (s->async->events)
 		comedi_event(dev, s);
-	}
+
 }
 
 /*
@@ -854,9 +854,9 @@ pci224_ao_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
 			err++;
 		}
 		tmp = cmd->chanlist_len * CONVERT_PERIOD;
-		if (tmp < MIN_SCAN_PERIOD) {
+		if (tmp < MIN_SCAN_PERIOD)
 			tmp = MIN_SCAN_PERIOD;
-		}
+
 		if (cmd->scan_begin_arg < tmp) {
 			cmd->scan_begin_arg = tmp;
 			err++;
@@ -965,9 +965,9 @@ pci224_ao_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
 			devpriv->cached_div1 = div1;
 			devpriv->cached_div2 = div2;
 		}
-		if (tmp != cmd->scan_begin_arg) {
+		if (tmp != cmd->scan_begin_arg)
 			err++;
-		}
+
 	}
 
 	if (err)
@@ -993,13 +993,13 @@ pci224_ao_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
 		tmp = 0;
 		for (n = 0; n < cmd->chanlist_len; n++) {
 			ch = CR_CHAN(cmd->chanlist[n]);
-			if (tmp & (1U << ch)) {
+			if (tmp & (1U << ch))
 				errors |= dupchan_err;
-			}
+
 			tmp |= (1U << ch);
-			if (CR_RANGE(cmd->chanlist[n]) != range) {
+			if (CR_RANGE(cmd->chanlist[n]) != range)
 				errors |= range_err;
-			}
+
 		}
 		if (errors) {
 			if (errors & dupchan_err) {
@@ -1037,9 +1037,9 @@ static int pci224_ao_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	unsigned long flags;
 
 	/* Cannot handle null/empty chanlist. */
-	if (cmd->chanlist == NULL || cmd->chanlist_len == 0) {
+	if (cmd->chanlist == NULL || cmd->chanlist_len == 0)
 		return -EINVAL;
-	}
+
 
 	/* Determine which channels are enabled and their load order.  */
 	devpriv->ao_enab = 0;
@@ -1049,9 +1049,9 @@ static int pci224_ao_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		devpriv->ao_enab |= 1U << ch;
 		rank = 0;
 		for (j = 0; j < cmd->chanlist_len; j++) {
-			if (CR_CHAN(cmd->chanlist[j]) < ch) {
+			if (CR_CHAN(cmd->chanlist[j]) < ch)
 				rank++;
-			}
+
 		}
 		devpriv->ao_scan_order[rank] = i;
 	}
@@ -1220,9 +1220,9 @@ pci224_ao_munge(struct comedi_device *dev, struct comedi_subdevice *s,
 		offset = 32768;
 	}
 	/* Munge the data. */
-	for (i = 0; i < length; i++) {
+	for (i = 0; i < length; i++)
 		array[i] = (array[i] << shift) - offset;
-	}
+
 }
 
 /*
@@ -1253,15 +1253,15 @@ static irqreturn_t pci224_interrupt(int irq, void *d)
 			cmd = &s->async->cmd;
 			if (valid_intstat & PCI224_INTR_EXT) {
 				devpriv->intsce &= ~PCI224_INTR_EXT;
-				if (cmd->start_src == TRIG_EXT) {
+				if (cmd->start_src == TRIG_EXT)
 					pci224_ao_start(dev, s);
-				} else if (cmd->stop_src == TRIG_EXT) {
+				else if (cmd->stop_src == TRIG_EXT)
 					pci224_ao_stop(dev, s);
-				}
+
 			}
-			if (valid_intstat & PCI224_INTR_DAC) {
+			if (valid_intstat & PCI224_INTR_DAC)
 				pci224_ao_handle_fifo(dev, s);
-			}
+
 		}
 		/* Reenable interrupt sources. */
 		spin_lock_irqsave(&devpriv->ao_spinlock, flags);
@@ -1380,23 +1380,23 @@ static int pci224_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	/* Allocate readback buffer for AO channels. */
 	devpriv->ao_readback = kmalloc(sizeof(devpriv->ao_readback[0]) *
 				       thisboard->ao_chans, GFP_KERNEL);
-	if (!devpriv->ao_readback) {
+	if (!devpriv->ao_readback)
 		return -ENOMEM;
-	}
+
 
 	/* Allocate buffer to hold values for AO channel scan. */
 	devpriv->ao_scan_vals = kmalloc(sizeof(devpriv->ao_scan_vals[0]) *
 					thisboard->ao_chans, GFP_KERNEL);
-	if (!devpriv->ao_scan_vals) {
+	if (!devpriv->ao_scan_vals)
 		return -ENOMEM;
-	}
+
 
 	/* Allocate buffer to hold AO channel scan order. */
 	devpriv->ao_scan_order = kmalloc(sizeof(devpriv->ao_scan_order[0]) *
 					 thisboard->ao_chans, GFP_KERNEL);
-	if (!devpriv->ao_scan_order) {
+	if (!devpriv->ao_scan_order)
 		return -ENOMEM;
-	}
+
 
 	/* Disable interrupt sources. */
 	devpriv->intsce = 0;
@@ -1444,9 +1444,9 @@ static int pci224_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		s->range_table_list = range_table_list =
 		    kmalloc(sizeof(struct comedi_lrange *) * s->n_chan,
 			    GFP_KERNEL);
-		if (!s->range_table_list) {
+		if (!s->range_table_list)
 			return -ENOMEM;
-		}
+
 		for (n = 2; n < 3 + s->n_chan; n++) {
 			if (it->options[n] < 0 || it->options[n] > 1) {
 				printk(KERN_WARNING "comedi%d: %s: warning! "
@@ -1458,11 +1458,11 @@ static int pci224_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		for (n = 0; n < s->n_chan; n++) {
 			if (n < COMEDI_NDEVCONFOPTS - 3 &&
 			    it->options[3 + n] == 1) {
-				if (it->options[2] == 1) {
+				if (it->options[2] == 1)
 					range_table_list[n] = &range_pci234_ext;
-				} else {
+				else
 					range_table_list[n] = &range_bipolar5;
-				}
+
 			} else {
 				if (it->options[2] == 1) {
 					range_table_list[n] =
@@ -1505,11 +1505,11 @@ static int pci224_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	printk(KERN_INFO "comedi%d: %s ", dev->minor, dev->board_name);
 	printk("(pci %s) ", pci_name(pci_dev));
-	if (irq) {
+	if (irq)
 		printk("(irq %u%s) ", irq, (dev->irq ? "" : " UNAVAILABLE"));
-	} else {
+	else
 		printk("(no irq) ");
-	}
+
 
 	printk("attached\n");
 
@@ -1528,9 +1528,9 @@ static int pci224_detach(struct comedi_device *dev)
 {
 	printk(KERN_DEBUG "comedi%d: %s: detach\n", dev->minor, DRIVER_NAME);
 
-	if (dev->irq) {
+	if (dev->irq)
 		free_irq(dev->irq, dev);
-	}
+
 	if (dev->subdevices) {
 		struct comedi_subdevice *s;
 
@@ -1543,9 +1543,9 @@ static int pci224_detach(struct comedi_device *dev)
 		kfree(devpriv->ao_scan_vals);
 		kfree(devpriv->ao_scan_order);
 		if (devpriv->pci_dev) {
-			if (dev->iobase) {
+			if (dev->iobase)
 				comedi_pci_disable(devpriv->pci_dev);
-			}
+
 			pci_dev_put(devpriv->pci_dev);
 		}
 	}
-- 
1.7.0.2

