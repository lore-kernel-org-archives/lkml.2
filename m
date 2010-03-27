Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab0C0BvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 21:51:09 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:64967 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab0C0Btr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 21:49:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ojrJU1xROmpanfzBP4EzvhpyCmH0iVeApfySjlT9h2m79fNaBNc4RabNQuYRjX6eWQ
         XUeSZMH5YUMR3gAXiitM9gahcDEm/Vid2l7q8JunkUwKRWvyqxJEQUwAa8YTkua0d+Cz
         0UD0fXcVzzGP/ozMaKDiOQcuYK+TMt9gP3S1E=
From: Jason Wong <tsanghan@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Jason Wong <tsanghan@gmail.com>
Subject: [PATCH 4/9] Staging: comedi: adl_pci9118: fixed multiple brace coding style issue
Date: Sat, 27 Mar 2010 09:48:38 +0800
Message-Id: <1269654523-2682-5-git-send-email-tsanghan@gmail.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <Jason Wong <tsanghan@gmail.com>
References: <Jason Wong <tsanghan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed multiple coding style issue.

Signed-off-by: Jason Wong <tsanghan@gmail.com>
---
 drivers/staging/comedi/drivers/adl_pci9118.c |   98 +++++++++++++-------------
 1 files changed, 49 insertions(+), 49 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index 9934a3c..ab083aa 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -393,11 +393,11 @@ static int pci9118_insn_write_ao(struct comedi_device *dev,
 	int n, chanreg, ch;
 
 	ch = CR_CHAN(insn->chanspec);
-	if (ch) {
+	if (ch)
 		chanreg = PCI9118_DA2;
-	} else {
+	else
 		chanreg = PCI9118_DA1;
-	}
+
 
 	for (n = 0; n < insn->n; n++) {
 		outl(data[n], dev->iobase + chanreg);
@@ -560,11 +560,11 @@ static void pci9118_ai_munge(struct comedi_device *dev,
 	for (i = 0; i < num_samples; i++) {
 		if (devpriv->usedma)
 			array[i] = be16_to_cpu(array[i]);
-		if (devpriv->ai16bits) {
+		if (devpriv->ai16bits)
 			array[i] ^= 0x8000;
-		} else {
+		else
 			array[i] = (array[i] >> 4) & 0x0fff;
-		}
+
 	}
 }
 
@@ -790,20 +790,20 @@ static int pci9118_ai_cmdtest(struct comedi_device *dev,
 		err++;
 
 	tmp = cmd->scan_begin_src;
-	if (devpriv->master) {
+	if (devpriv->master)
 		cmd->scan_begin_src &= TRIG_TIMER | TRIG_EXT | TRIG_FOLLOW;
-	} else {
+	else
 		cmd->scan_begin_src &= TRIG_FOLLOW;
-	}
+
 	if (!cmd->scan_begin_src || tmp != cmd->scan_begin_src)
 		err++;
 
 	tmp = cmd->convert_src;
-	if (devpriv->master) {
+	if (devpriv->master)
 		cmd->convert_src &= TRIG_TIMER | TRIG_EXT | TRIG_NOW;
-	} else {
+	else
 		cmd->convert_src &= TRIG_TIMER | TRIG_EXT;
-	}
+
 	if (!cmd->convert_src || tmp != cmd->convert_src)
 		err++;
 
@@ -1043,12 +1043,12 @@ static int Compute_and_setup_dma(struct comedi_device *dev)
 	DPRINTK("1 dmalen0=%d dmalen1=%d ai_data_len=%d\n", dmalen0, dmalen1,
 		devpriv->ai_data_len);
 	/*  isn't output buff smaller that our DMA buff? */
-	if (dmalen0 > (devpriv->ai_data_len)) {
+	if (dmalen0 > (devpriv->ai_data_len))
 		dmalen0 = devpriv->ai_data_len & ~3L;	/*  allign to 32bit down */
-	}
-	if (dmalen1 > (devpriv->ai_data_len)) {
+
+	if (dmalen1 > (devpriv->ai_data_len))
 		dmalen1 = devpriv->ai_data_len & ~3L;	/*  allign to 32bit down */
-	}
+
 	DPRINTK("2 dmalen0=%d dmalen1=%d \n", dmalen0, dmalen1);
 
 	/*  we want wake up every scan? */
@@ -1294,9 +1294,9 @@ static int pci9118_ai_docmd_dma(struct comedi_device *dev,
 		return -EIO;
 	};
 
-	if (devpriv->ai12_startstop) {
+	if (devpriv->ai12_startstop)
 		pci9118_exttrg_add(dev, EXTTRG_AI);	/*  activate EXT trigger */
-	}
+
 
 	devpriv->int_ai_func = interrupt_pci9118_ai_dma;	/* transfer function */
 
@@ -1369,12 +1369,12 @@ static int pci9118_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	}
 
 	/*  use sample&hold signal? */
-	if (cmd->convert_src == TRIG_NOW) {
+	if (cmd->convert_src == TRIG_NOW)
 		devpriv->usessh = 1;
-	} /*  yes */
-	else {
+	/*  yes */
+	else
 		devpriv->usessh = 0;
-	}			/*  no */
+	/*  no */
 
 	DPRINTK("1 neverending=%d scans=%u usessh=%d ai_startstop=0x%2x\n",
 		devpriv->ai_neverending, devpriv->ai_scans, devpriv->usessh,
@@ -1388,12 +1388,12 @@ static int pci9118_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		devpriv->usedma = 1;
 		if ((cmd->flags & TRIG_WAKE_EOS) &&
 		    (devpriv->ai_n_scanlen == 1)) {
-			if (cmd->convert_src == TRIG_NOW) {
+			if (cmd->convert_src == TRIG_NOW)
 				devpriv->ai_add_back = 1;
-			}
-			if (cmd->convert_src == TRIG_TIMER) {
+
+			if (cmd->convert_src == TRIG_TIMER)
 				devpriv->usedma = 0;	/*  use INT transfer if scanlist have only one channel */
-			}
+
 		}
 		if ((cmd->flags & TRIG_WAKE_EOS) &&
 		    (devpriv->ai_n_scanlen & 1) &&
@@ -1456,11 +1456,11 @@ static int pci9118_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	/*  compute timers settings */
 	/*  simplest way, fr=4Mhz/(tim1*tim2), channel manipulation without timers effect */
 	if (((cmd->scan_begin_src == TRIG_FOLLOW) || (cmd->scan_begin_src == TRIG_EXT) || (cmd->scan_begin_src == TRIG_INT)) && (cmd->convert_src == TRIG_TIMER)) {	/*  both timer is used for one time */
-		if (cmd->scan_begin_src == TRIG_EXT) {
+		if (cmd->scan_begin_src == TRIG_EXT)
 			devpriv->ai_do = 4;
-		} else {
+		else
 			devpriv->ai_do = 1;
-		}
+
 		pci9118_calc_divisors(devpriv->ai_do, dev, s,
 				      &cmd->scan_begin_arg, &cmd->convert_arg,
 				      devpriv->ai_flags,
@@ -1597,17 +1597,17 @@ static int setup_channel_list(struct comedi_device *dev,
 
 	/*  All is ok, so we can setup channel/range list */
 
-	if (!bipolar) {
+	if (!bipolar)
 		devpriv->AdControlReg |= AdControl_UniP;	/*  set unibipolar */
-	} else {
+	else
 		devpriv->AdControlReg &= ((~AdControl_UniP) & 0xff);	/*  enable bipolar */
-	}
 
-	if (differencial) {
+
+	if (differencial)
 		devpriv->AdControlReg |= AdControl_Diff;	/*  enable diff inputs */
-	} else {
+	else
 		devpriv->AdControlReg &= ((~AdControl_Diff) & 0xff);	/*  set single ended inputs */
-	}
+
 
 	outl(devpriv->AdControlReg, dev->iobase + PCI9118_ADCNTRL);	/*  setup mode */
 
@@ -1673,9 +1673,9 @@ static int setup_channel_list(struct comedi_device *dev,
 	}
 #ifdef PCI9118_EXTDEBUG
 	DPRINTK("CHL: ");
-	for (i = 0; i <= (useeos * n_chan); i++) {
+	for (i = 0; i <= (useeos * n_chan); i++)
 		DPRINTK("%04x ", devpriv->chanlist[i]);
-	}
+
 	DPRINTK("\n ");
 #endif
 #endif
@@ -1897,11 +1897,11 @@ static int pci9118_attach(struct comedi_device *dev,
 
 	opt_bus = it->options[0];
 	opt_slot = it->options[1];
-	if (it->options[3] & 1) {
+	if (it->options[3] & 1)
 		master = 0;	/*  user don't want use bus master */
-	} else {
+	else
 		master = 1;
-	}
+
 
 	ret = alloc_private(dev, sizeof(struct pci9118_private));
 	if (ret < 0) {
@@ -1944,9 +1944,9 @@ static int pci9118_attach(struct comedi_device *dev,
 		return -EIO;
 	}
 
-	if (master) {
+	if (master)
 		pci_set_master(pcidev);
-	}
+
 
 	pci_bus = pcidev->bus->number;
 	pci_slot = PCI_SLOT(pcidev->devfn);
@@ -2025,9 +2025,9 @@ static int pci9118_attach(struct comedi_device *dev,
 		if (devpriv->usemux > 256)
 			devpriv->usemux = 256;	/*  max 256 channels! */
 		if (it->options[4] > 0)
-			if (devpriv->usemux > 128) {
+			if (devpriv->usemux > 128)
 				devpriv->usemux = 128;	/*  max 128 channels with softare S&H! */
-			}
+
 		printk(", ext. mux %d channels", devpriv->usemux);
 	}
 
@@ -2054,11 +2054,11 @@ static int pci9118_attach(struct comedi_device *dev,
 	dev->read_subdev = s;
 	s->type = COMEDI_SUBD_AI;
 	s->subdev_flags = SDF_READABLE | SDF_COMMON | SDF_GROUND | SDF_DIFF;
-	if (devpriv->usemux) {
+	if (devpriv->usemux)
 		s->n_chan = devpriv->usemux;
-	} else {
+	else
 		s->n_chan = this_board->n_aichan;
-	}
+
 	s->maxdata = this_board->ai_maxdata;
 	s->len_chanlist = this_board->n_aichanlist;
 	s->range_table = this_board->rangelist_ai;
@@ -2129,9 +2129,9 @@ static int pci9118_detach(struct comedi_device *dev)
 		if (dev->irq)
 			free_irq(dev->irq, dev);
 		if (devpriv->pcidev) {
-			if (dev->iobase) {
+			if (dev->iobase)
 				comedi_pci_disable(devpriv->pcidev);
-			}
+
 			pci_dev_put(devpriv->pcidev);
 		}
 		if (devpriv->dmabuf_virt[0])
-- 
1.7.0.3

