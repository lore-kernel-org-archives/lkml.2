Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047Ab1JSMGM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 08:06:12 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41656 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894Ab1JSMGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 08:06:09 -0400
From: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 24/24] Staging: comedi: fix code cleanup in daqboard2000.c
Date: Wed, 19 Oct 2011 17:34:58 +0530
Message-Id: <1319025898-10864-4-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1319025898-10864-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1319025898-10864-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the daqboard2000.c file that fixes up a
warning found by the checkpatch.pl tool.
Converted function name to "%s", __func__.
Converted printks to dev_printk.
Fixed brace coding style issue.
Removed unnecessary printk statements.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/daqboard2000.c |   74 +++++++++----------------
 1 files changed, 26 insertions(+), 48 deletions(-)

diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/staging/comedi/drivers/daqboard2000.c
index 82be77d..43a2007 100644
--- a/drivers/staging/comedi/drivers/daqboard2000.c
+++ b/drivers/staging/comedi/drivers/daqboard2000.c
@@ -430,16 +430,14 @@ static int daqboard2000_ai_insn_read(struct comedi_device *dev,
 		/* Enable reading from the scanlist FIFO */
 		fpga->acqControl = DAQBOARD2000_SeqStartScanList;
 		for (timeout = 0; timeout < 20; timeout++) {
-			if (fpga->acqControl & DAQBOARD2000_AcqConfigPipeFull) {
+			if (fpga->acqControl & DAQBOARD2000_AcqConfigPipeFull)
 				break;
-			}
 			/* udelay(2); */
 		}
 		fpga->acqControl = DAQBOARD2000_AdcPacerEnable;
 		for (timeout = 0; timeout < 20; timeout++) {
-			if (fpga->acqControl & DAQBOARD2000_AcqLogicScanning) {
+			if (fpga->acqControl & DAQBOARD2000_AcqLogicScanning)
 				break;
-			}
 			/* udelay(2); */
 		}
 		for (timeout = 0; timeout < 20; timeout++) {
@@ -465,9 +463,8 @@ static int daqboard2000_ao_insn_read(struct comedi_device *dev,
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
 
-	for (i = 0; i < insn->n; i++) {
+	for (i = 0; i < insn->n; i++)
 		data[i] = devpriv->ao_readback[chan];
-	}
 
 	return i;
 }
@@ -490,9 +487,8 @@ static int daqboard2000_ao_insn_write(struct comedi_device *dev,
 		/* fpga->dacControl = (chan + 2) * 0x0010 | 0x0001; udelay(1000); */
 		fpga->dacSetting[chan] = data[i];
 		for (timeout = 0; timeout < 20; timeout++) {
-			if ((fpga->dacControl & ((chan + 1) * 0x0010)) == 0) {
+			if ((fpga->dacControl & ((chan + 1) * 0x0010)) == 0)
 				break;
-			}
 			/* udelay(2); */
 		}
 		devpriv->ao_readback[chan] = data[i];
@@ -507,7 +503,7 @@ static int daqboard2000_ao_insn_write(struct comedi_device *dev,
 
 static void daqboard2000_resetLocalBus(struct comedi_device *dev)
 {
-	printk("daqboard2000_resetLocalBus\n");
+	dev_dbg(dev->hw_dev, "%s\n", __func__);
 	writel(DAQBOARD2000_SECRLocalBusHi, devpriv->plx + 0x6c);
 	udelay(10000);
 	writel(DAQBOARD2000_SECRLocalBusLo, devpriv->plx + 0x6c);
@@ -516,7 +512,7 @@ static void daqboard2000_resetLocalBus(struct comedi_device *dev)
 
 static void daqboard2000_reloadPLX(struct comedi_device *dev)
 {
-	printk("daqboard2000_reloadPLX\n");
+	dev_dbg(dev->hw_dev, "%s\n", __func__);
 	writel(DAQBOARD2000_SECRReloadLo, devpriv->plx + 0x6c);
 	udelay(10000);
 	writel(DAQBOARD2000_SECRReloadHi, devpriv->plx + 0x6c);
@@ -527,7 +523,7 @@ static void daqboard2000_reloadPLX(struct comedi_device *dev)
 
 static void daqboard2000_pulseProgPin(struct comedi_device *dev)
 {
-	printk("daqboard2000_pulseProgPin 1\n");
+	dev_dbg(dev->hw_dev, "%s\n", __func__);
 	writel(DAQBOARD2000_SECRProgPinHi, devpriv->plx + 0x6c);
 	udelay(10000);
 	writel(DAQBOARD2000_SECRProgPinLo, devpriv->plx + 0x6c);
@@ -578,17 +574,12 @@ static int initialize_daqboard2000(struct comedi_device *dev,
 	/* Check to make sure the serial eeprom is present on the board */
 	secr = readl(devpriv->plx + 0x6c);
 	if (!(secr & DAQBOARD2000_EEPROM_PRESENT)) {
-#ifdef DEBUG_EEPROM
-		printk("no serial eeprom\n");
-#endif
+		dev_dbg(dev->hw_dev, "no serial eeprom\n");
 		return -EIO;
 	}
 
 	for (retry = 0; retry < 3; retry++) {
-#ifdef DEBUG_EEPROM
-		printk("Programming EEPROM try %x\n", retry);
-#endif
-
+		dev_dbg(dev->hw_dev, "Programming EEPROM try %x\n", retry);
 		daqboard2000_resetLocalBus(dev);
 		daqboard2000_reloadPLX(dev);
 		daqboard2000_pulseProgPin(dev);
@@ -596,23 +587,19 @@ static int initialize_daqboard2000(struct comedi_device *dev,
 			for (i = 0; i < len; i++) {
 				if (cpld_array[i] == 0xff
 				    && cpld_array[i + 1] == 0x20) {
-#ifdef DEBUG_EEPROM
-					printk("Preamble found at %d\n", i);
-#endif
+					dev_dbg(dev->hw_dev, "Preamble found at %d\n",
+						i);
 					break;
 				}
 			}
 			for (; i < len; i += 2) {
 				int data =
 				    (cpld_array[i] << 8) + cpld_array[i + 1];
-				if (!daqboard2000_writeCPLD(dev, data)) {
+				if (!daqboard2000_writeCPLD(dev, data))
 					break;
-				}
 			}
 			if (i >= len) {
-#ifdef DEBUG_EEPROM
-				printk("Programmed\n");
-#endif
+				dev_dbg(dev->hw_dev, "Programmed\n");
 				daqboard2000_resetLocalBus(dev);
 				daqboard2000_reloadPLX(dev);
 				result = 0;
@@ -658,9 +645,8 @@ static void daqboard2000_activateReferenceDacs(struct comedi_device *dev)
 	/*  Set the + reference dac value in the FPGA */
 	fpga->refDacs = 0x80 | DAQBOARD2000_PosRefDacSelect;
 	for (timeout = 0; timeout < 20; timeout++) {
-		if ((fpga->dacControl & DAQBOARD2000_RefBusy) == 0) {
+		if ((fpga->dacControl & DAQBOARD2000_RefBusy) == 0)
 			break;
-		}
 		udelay(2);
 	}
 /*  printk("DAQBOARD2000_PosRefDacSelect %d\n", timeout);*/
@@ -668,9 +654,8 @@ static void daqboard2000_activateReferenceDacs(struct comedi_device *dev)
 	/*  Set the - reference dac value in the FPGA */
 	fpga->refDacs = 0x80 | DAQBOARD2000_NegRefDacSelect;
 	for (timeout = 0; timeout < 20; timeout++) {
-		if ((fpga->dacControl & DAQBOARD2000_RefBusy) == 0) {
+		if ((fpga->dacControl & DAQBOARD2000_RefBusy) == 0)
 			break;
-		}
 		udelay(2);
 	}
 /*  printk("DAQBOARD2000_NegRefDacSelect %d\n", timeout);*/
@@ -737,15 +722,12 @@ static int daqboard2000_attach(struct comedi_device *dev,
 	unsigned int aux_len;
 	int bus, slot;
 
-	printk("comedi%d: daqboard2000:", dev->minor);
-
 	bus = it->options[0];
 	slot = it->options[1];
 
 	result = alloc_private(dev, sizeof(struct daqboard2000_private));
-	if (result < 0) {
+	if (result < 0)
 		return -ENOMEM;
-	}
 	for (card = pci_get_device(0x1616, 0x0409, NULL);
 	     card != NULL; card = pci_get_device(0x1616, 0x0409, card)) {
 		if (bus || slot) {
@@ -759,10 +741,10 @@ static int daqboard2000_attach(struct comedi_device *dev,
 	}
 	if (!card) {
 		if (bus || slot)
-			printk(" no daqboard2000 found at bus/slot: %d/%d\n",
-			       bus, slot);
+			dev_dbg(dev->hw_dev, "no daqboard2000 found at bus/slot: %d/%d\n",
+				bus, slot);
 		else
-			printk(" no daqboard2000 found\n");
+			dev_dbg(dev->hw_dev, "no daqboard2000 found\n");
 		return -EIO;
 	} else {
 		u32 id;
@@ -772,7 +754,8 @@ static int daqboard2000_attach(struct comedi_device *dev,
 		      subsystem_device << 16) | card->subsystem_vendor;
 		for (i = 0; i < n_boardtypes; i++) {
 			if (boardtypes[i].id == id) {
-				printk(" %s", boardtypes[i].name);
+				dev_dbg(dev->hw_dev, "%s\n",
+					boardtypes[i].name);
 				dev->board_ptr = boardtypes + i;
 			}
 		}
@@ -786,7 +769,7 @@ static int daqboard2000_attach(struct comedi_device *dev,
 
 	result = comedi_pci_enable(card, "daqboard2000");
 	if (result < 0) {
-		printk(" failed to enable PCI device and request regions\n");
+		dev_err(dev->hw_dev, "failed to enable PCI device and request regions\n");
 		return -EIO;
 	}
 	devpriv->got_regions = 1;
@@ -794,9 +777,8 @@ static int daqboard2000_attach(struct comedi_device *dev,
 	    ioremap(pci_resource_start(card, 0), DAQBOARD2000_PLX_SIZE);
 	devpriv->daq =
 	    ioremap(pci_resource_start(card, 2), DAQBOARD2000_DAQ_SIZE);
-	if (!devpriv->plx || !devpriv->daq) {
+	if (!devpriv->plx || !devpriv->daq)
 		return -ENOMEM;
-	}
 
 	result = alloc_subdevices(dev, 3);
 	if (result < 0)
@@ -817,7 +799,7 @@ static int daqboard2000_attach(struct comedi_device *dev,
 	if (aux_data && aux_len) {
 		result = initialize_daqboard2000(dev, aux_data, aux_len);
 	} else {
-		printk("no FPGA initialization code, aborting\n");
+		dev_dbg(dev->hw_dev, "no FPGA initialization code, aborting\n");
 		result = -EIO;
 	}
 	if (result < 0)
@@ -857,30 +839,26 @@ static int daqboard2000_attach(struct comedi_device *dev,
 	result = subdev_8255_init(dev, s, daqboard2000_8255_cb,
 				  (unsigned long)(dev->iobase + 0x40));
 
-	printk("\n");
 out:
 	return result;
 }
 
 static int daqboard2000_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: daqboard2000: remove\n", dev->minor);
 
 	if (dev->subdevices)
 		subdev_8255_cleanup(dev, dev->subdevices + 2);
 
-	if (dev->irq) {
+	if (dev->irq)
 		free_irq(dev->irq, dev);
-	}
 	if (devpriv) {
 		if (devpriv->daq)
 			iounmap(devpriv->daq);
 		if (devpriv->plx)
 			iounmap(devpriv->plx);
 		if (devpriv->pci_dev) {
-			if (devpriv->got_regions) {
+			if (devpriv->got_regions)
 				comedi_pci_disable(devpriv->pci_dev);
-			}
 			pci_dev_put(devpriv->pci_dev);
 		}
 	}
-- 
1.7.6.4

