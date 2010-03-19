Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab0CSN5o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 09:57:44 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:34250 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486Ab0CSN5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 09:57:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=bLSZ/wXOJxfks8P76ZQo8nBGM5rOL+Wx1jjLTaul43BUVqyPjfL9zKjFJCJQ9iwn8M
         /eM6CcZ8FN2uuK8Q7HT3plo2NPPpBkqWYqzhwvl+NnRGxO4lIMMDXLzhVgUj6zvgY8d0
         H9cj77EO9E7x0R9/Shxybh4z9WAXmfPVIodkc=
From: Maurice Dawson <mauricedawson2699@googlemail.com>
To: gregkh@suse.de, wfp5p@virginia.edu, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org
Subject: [PATCH 19/19] Staging: comedi: fix brace coding style issue in adl_pci9118.c
Date: Fri, 19 Mar 2010 13:57:31 +0000
Message-Id: <1269007051-3187-1-git-send-email-mauricedawson2699@googlemail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the adl_pci9118.c file that fixes up all brace warnings found by the checkpatch.pl tool

Signed-off-by: Maurice Dawson <mauricedawson2699@googlemail.com>
---
 drivers/staging/comedi/drivers/adl_pci9118.c |   62 ++++++++++++--------------
 1 files changed, 28 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index 2c39430..066695a 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -57,7 +57,7 @@ Configuration options:
 		long delay is requested in ns and sign polarity of the hold
 		(in this case external multiplexor can serve only 128 channels)
   [5] - 0=stop measure on all hardware errors
-	2| = ignore ADOR - A/D Overrun status
+	2 | = ignore ADOR - A/D Overrun status
 	8|=ignore Bover - A/D Burst Mode Overrun status
 	256|=ignore nFull - A/D FIFO Full status
 
@@ -495,11 +495,10 @@ static int pci9118_insn_write_ao(struct comedi_device *dev,
 	int n, chanreg, ch;
 
 	ch = CR_CHAN(insn->chanspec);
-	if (ch) {
+	if (ch)
 		chanreg = PCI9118_DA2;
-	} else {
+	else
 		chanreg = PCI9118_DA1;
-	}
 
 	for (n = 0; n < insn->n; n++) {
 		outl(data[n], dev->iobase + chanreg);
@@ -662,11 +661,10 @@ static void pci9118_ai_munge(struct comedi_device *dev,
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
 	}
 }
 
@@ -930,20 +928,20 @@ static int pci9118_ai_cmdtest(struct comedi_device *dev,
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
 
@@ -1538,12 +1536,12 @@ static int pci9118_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	}
 
 	/* use sample&hold signal? */
-	if (cmd->convert_src == TRIG_NOW) {
+	if (cmd->convert_src == TRIG_NOW)
 		devpriv->usessh = 1;
-	} /* yes */
-	else {
+	/* yes */
+	else
 		devpriv->usessh = 0;
-	}			/*  no */
+				/*  no */
 
 	DPRINTK("1 neverending=%d scans=%u usessh=%d ai_startstop=0x%2x\n",
 		devpriv->ai_neverending, devpriv->ai_scans, devpriv->usessh,
@@ -1560,9 +1558,8 @@ static int pci9118_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		devpriv->usedma = 1;
 		if ((cmd->flags & TRIG_WAKE_EOS) &&
 		    (devpriv->ai_n_scanlen == 1)) {
-			if (cmd->convert_src == TRIG_NOW) {
+			if (cmd->convert_src == TRIG_NOW)
 				devpriv->ai_add_back = 1;
-			}
 			if (cmd->convert_src == TRIG_TIMER) {
 				devpriv->usedma = 0;
 					/*
@@ -1657,11 +1654,11 @@ static int pci9118_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		(cmd->scan_begin_src == TRIG_INT)) &&
 		(cmd->convert_src == TRIG_TIMER)) {
 					/* both timer is used for one time */
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
@@ -1908,9 +1905,9 @@ static int setup_channel_list(struct comedi_device *dev,
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
@@ -2175,11 +2172,10 @@ static int pci9118_attach(struct comedi_device *dev,
 
 	opt_bus = it->options[0];
 	opt_slot = it->options[1];
-	if (it->options[3] & 1) {
+	if (it->options[3] & 1)
 		master = 0;	/* user don't want use bus master */
-	} else {
+	else
 		master = 1;
-	}
 
 	ret = alloc_private(dev, sizeof(struct pci9118_private));
 	if (ret < 0) {
@@ -2222,9 +2218,8 @@ static int pci9118_attach(struct comedi_device *dev,
 		return -EIO;
 	}
 
-	if (master) {
+	if (master)
 		pci_set_master(pcidev);
-	}
 
 	pci_bus = pcidev->bus->number;
 	pci_slot = PCI_SLOT(pcidev->devfn);
@@ -2335,11 +2330,11 @@ static int pci9118_attach(struct comedi_device *dev,
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
@@ -2411,9 +2406,8 @@ static int pci9118_detach(struct comedi_device *dev)
 		if (dev->irq)
 			free_irq(dev->irq, dev);
 		if (devpriv->pcidev) {
-			if (dev->iobase) {
+			if (dev->iobase)
 				comedi_pci_disable(devpriv->pcidev);
-			}
 			pci_dev_put(devpriv->pcidev);
 		}
 		if (devpriv->dmabuf_virt[0])
-- 
1.6.3.3

