Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab1GNPC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 11:02:28 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50195 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab1GNPC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 11:02:27 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 1/1] Staging: comedi: fix warning issue in adv_pci1710.c
Date: Thu, 14 Jul 2011 20:45:00 +0530
Message-Id: <1310656500-14807-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH 1/1]Staging: comedi:fix line over 80 character issue in adv_pci1710.c>
References: <[PATCH 1/1]Staging: comedi:fix line over 80 character issue in adv_pci1710.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the adv_pci1710.c file that fixes up a  warning: line over 80 character found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/adv_pci1710.c |   51 +++++++++++++++++---------
 1 files changed, 33 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index da2b75b..fd71cc6 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -805,7 +805,8 @@ static irqreturn_t interrupt_service_pci1710(int irq, void *d)
 	if (!dev->attached)	/*  is device attached? */
 		return IRQ_NONE;	/*  no, exit */
 
-	if (!(inw(dev->iobase + PCI171x_STATUS) & Status_IRQ))	/*  is this interrupt from our board? */
+	/* is this interrupt from our board? */
+	if (!(inw(dev->iobase + PCI171x_STATUS) & Status_IRQ))
 		return IRQ_NONE;	/*  no, exit */
 
 	DPRINTK("adv_pci1710 EDBG: interrupt_service_pci1710() ST: %4x\n",
@@ -814,7 +815,8 @@ static irqreturn_t interrupt_service_pci1710(int irq, void *d)
 	if (devpriv->ai_et) {	/*  Switch from initial TRIG_EXT to TRIG_xxx. */
 		devpriv->ai_et = 0;
 		devpriv->CntrlReg &= Control_CNT0;
-		devpriv->CntrlReg |= Control_SW;	/*  set software trigger */
+		/* set software trigger */
+		devpriv->CntrlReg |= Control_SW;
 		outw(devpriv->CntrlReg, dev->iobase + PCI171x_CONTROL);
 		devpriv->CntrlReg = devpriv->ai_et_CntrlReg;
 		outb(0, dev->iobase + PCI171x_CLRFIFO);
@@ -1161,12 +1163,15 @@ static int check_channel_list(struct comedi_device *dev,
 	}
 
 	if (n_chan > 1) {
-		chansegment[0] = chanlist[0];	/*  first channel is every time ok */
-		for (i = 1, seglen = 1; i < n_chan; i++, seglen++) {	/*  build part of chanlist */
+		/* first channel is every time ok */
+		chansegment[0] = chanlist[0];
+		for (i = 1, seglen = 1; i < n_chan; i++, seglen++) {
+			/* build part of chanlist */
 			/*  printk("%d. %d %d\n",i,CR_CHAN(chanlist[i]),CR_RANGE(chanlist[i])); */
 			if (chanlist[0] == chanlist[i])
-				break;	/*  we detect loop, this must by finish */
-			if (CR_CHAN(chanlist[i]) & 1)	/*  odd channel cann't by differencial */
+				/* we detect loop, this must by finish */
+				break;
+			/* odd channel cann't by differencial */
+			if (CR_CHAN(chanlist[i]) & 1)
 				if (CR_AREF(chanlist[i]) == AREF_DIFF) {
 					comedi_error(dev,
 						     "Odd channel can't be differential input!\n");
@@ -1183,7 +1188,8 @@ static int check_channel_list(struct comedi_device *dev,
 				     CR_CHAN(chanlist[0]));
 				return 0;
 			}
-			chansegment[i] = chanlist[i];	/*  well, this is next correct channel in list */
+			/* well, this is next correct channel in list */
+			chansegment[i] = chanlist[i];
 		}
 
 		for (i = 0, segpos = 0; i < n_chan; i++) {	/*  check whole chanlist */
@@ -1221,11 +1227,13 @@ static void setup_channel_list(struct comedi_device *dev,
 	DPRINTK("SegLen: %d\n", seglen);
 	for (i = 0; i < seglen; i++) {	/*  store range list to card */
 		chanprog = muxonechan[CR_CHAN(chanlist[i])];
-		outw(chanprog, dev->iobase + PCI171x_MUX);	/* select channel */
+		/* select channel */
+		outw(chanprog, dev->iobase + PCI171x_MUX);
 		range = this_board->rangecode_ai[CR_RANGE(chanlist[i])];
 		if (CR_AREF(chanlist[i]) == AREF_DIFF)
 			range |= 0x0020;
-		outw(range, dev->iobase + PCI171x_RANGE);	/* select gain */
+		/* select gain */
+		outw(range, dev->iobase + PCI171x_RANGE);
 #ifdef PCI171x_PARANOIDCHECK
 		devpriv->act_chanlist[i] =
 		    (CR_CHAN(chanlist[i]) << 12) & 0xf000;
@@ -1242,7 +1250,8 @@ static void setup_channel_list(struct comedi_device *dev,
 
 	devpriv->ai_et_MuxVal =
 	    CR_CHAN(chanlist[0]) | (CR_CHAN(chanlist[seglen - 1]) << 8);
-	outw(devpriv->ai_et_MuxVal, dev->iobase + PCI171x_MUX);	/* select channel interval to scan */
+	/* select channel interval to scan */
+	outw(devpriv->ai_et_MuxVal, dev->iobase + PCI171x_MUX);
 	DPRINTK("MUX: %4x L%4x.H%4x\n",
 		CR_CHAN(chanlist[0]) | (CR_CHAN(chanlist[seglen - 1]) << 8),
 		CR_CHAN(chanlist[0]), CR_CHAN(chanlist[seglen - 1]));
@@ -1280,8 +1289,8 @@ static int pci171x_ai_cancel(struct comedi_device *dev,
 	default:
 		devpriv->CntrlReg &= Control_CNT0;
 		devpriv->CntrlReg |= Control_SW;
-
-		outw(devpriv->CntrlReg, dev->iobase + PCI171x_CONTROL);	/*  reset any operations */
+		/* reset any operations */
+		outw(devpriv->CntrlReg, dev->iobase + PCI171x_CONTROL);
 		start_pacer(dev, -1, 0, 0);
 		outb(0, dev->iobase + PCI171x_CLRFIFO);
 		outb(0, dev->iobase + PCI171x_CLRINT);
@@ -1305,15 +1314,18 @@ static int pci171x_reset(struct comedi_device *dev)
 {
 	DPRINTK("adv_pci1710 EDBG: BGN: pci171x_reset(...)\n");
 	outw(0x30, dev->iobase + PCI171x_CNTCTRL);
-	devpriv->CntrlReg = Control_SW | Control_CNT0;	/*  Software trigger, CNT0=external */
-	outw(devpriv->CntrlReg, dev->iobase + PCI171x_CONTROL);	/*  reset any operations */
+	/* Software trigger, CNT0=external */
+	devpriv->CntrlReg = Control_SW | Control_CNT0;
+	/* reset any operations */
+	outw(devpriv->CntrlReg, dev->iobase + PCI171x_CONTROL);
 	outb(0, dev->iobase + PCI171x_CLRFIFO);	/*  clear FIFO */
 	outb(0, dev->iobase + PCI171x_CLRINT);	/*  clear INT request */
 	start_pacer(dev, -1, 0, 0);	/*  stop 8254 */
 	devpriv->da_ranges = 0;
 	if (this_board->n_aochan) {
 		outb(devpriv->da_ranges, dev->iobase + PCI171x_DAREF);	/*  set DACs to 0..5V */
-		outw(0, dev->iobase + PCI171x_DA1);	/*  set DA outputs to 0V */
+		/* set DA outputs to 0V */
+		outw(0, dev->iobase + PCI171x_DA1);
 		devpriv->ao_data[0] = 0x0000;
 		if (this_board->n_aochan > 1) {
 			outw(0, dev->iobase + PCI171x_DA2);
@@ -1334,9 +1346,11 @@ static int pci171x_reset(struct comedi_device *dev)
 static int pci1720_reset(struct comedi_device *dev)
 {
 	DPRINTK("adv_pci1710 EDBG: BGN: pci1720_reset(...)\n");
-	outb(Syncont_SC0, dev->iobase + PCI1720_SYNCONT);	/*  set synchronous output mode */
+	/* set synchronous output mode */
+	outb(Syncont_SC0, dev->iobase + PCI1720_SYNCONT);
 	devpriv->da_ranges = 0xAA;
-	outb(devpriv->da_ranges, dev->iobase + PCI1720_RANGE);	/*  set all ranges to +/-5V */
+	/* set all ranges to +/-5V */
+	outb(devpriv->da_ranges, dev->iobase + PCI1720_RANGE);
 	outw(0x0800, dev->iobase + PCI1720_DA0);	/*  set outputs to 0V */
 	outw(0x0800, dev->iobase + PCI1720_DA1);
 	outw(0x0800, dev->iobase + PCI1720_DA2);
@@ -1429,7 +1443,8 @@ static int pci1710_attach(struct comedi_device *dev,
 			    "failed to enable PCI device and request regions!";
 			continue;
 		}
-		/*  fixup board_ptr in case we were using the dummy entry with the driver name */
+		/* fixup board_ptr in case we were using the dummy
+		 * entry with the driver name */
 		dev->board_ptr = &boardtypes[board_index];
 		break;
 	}
-- 
1.6.5.2

