Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814Ab1GNGFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 02:05:55 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35113 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445Ab1GNGFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 02:05:54 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 2/3] Staging: comedi: fix brace coding style issue in daqboard2000.c
Date: Thu, 14 Jul 2011 11:48:31 +0530
Message-Id: <1310624311-17875-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH 2/3]Staging: comedi: fix brace coding style issue in daqboard2000.c>
References: <[PATCH 2/3]Staging: comedi: fix brace coding style issue in daqboard2000.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the daqboard2000.c file that fixes up a brace warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/daqboard2000.c |   33 ++++++++----------------
 1 files changed, 11 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/staging/comedi/drivers/daqboard2000.c
index 6441771..12ccdae 100644
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
@@ -605,9 +601,8 @@ static int initialize_daqboard2000(struct comedi_device *dev,
 			for (; i < len; i += 2) {
 				int data =
 				    (cpld_array[i] << 8) + cpld_array[i + 1];
-				if (!daqboard2000_writeCPLD(dev, data)) {
+				if (!daqboard2000_writeCPLD(dev, data))
 					break;
-				}
 			}
 			if (i >= len) {
 #ifdef DEBUG_EEPROM
@@ -658,9 +653,8 @@ static void daqboard2000_activateReferenceDacs(struct comedi_device *dev)
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
@@ -668,9 +662,8 @@ static void daqboard2000_activateReferenceDacs(struct comedi_device *dev)
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
@@ -743,9 +736,8 @@ static int daqboard2000_attach(struct comedi_device *dev,
 	slot = it->options[1];
 
 	result = alloc_private(dev, sizeof(struct daqboard2000_private));
-	if (result < 0) {
+	if (result < 0)
 		return -ENOMEM;
-	}
 	for (card = pci_get_device(0x1616, 0x0409, NULL);
 	     card != NULL; card = pci_get_device(0x1616, 0x0409, card)) {
 		if (bus || slot) {
@@ -794,9 +786,8 @@ static int daqboard2000_attach(struct comedi_device *dev,
 	    ioremap(pci_resource_start(card, 0), DAQBOARD2000_PLX_SIZE);
 	devpriv->daq =
 	    ioremap(pci_resource_start(card, 2), DAQBOARD2000_DAQ_SIZE);
-	if (!devpriv->plx || !devpriv->daq) {
+	if (!devpriv->plx || !devpriv->daq)
 		return -ENOMEM;
-	}
 
 	result = alloc_subdevices(dev, 3);
 	if (result < 0)
@@ -869,18 +860,16 @@ static int daqboard2000_detach(struct comedi_device *dev)
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
1.6.5.2

