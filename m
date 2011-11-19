Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146Ab1KSEig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 23:38:36 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59220 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080Ab1KSEid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 23:38:33 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 20/25] Staging: comedi: fix brace coding style issue in daqboard2000.c
Date: Sat, 19 Nov 2011 10:06:52 +0530
Message-Id: <1321677417-2415-20-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1321677417-2415-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1321677417-2415-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the daqboard2000.c file that fixes up a brace
warning found by the checkpatch.pl tool.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/daqboard2000.c |   20 ++++++++------------
 1 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/staging/comedi/drivers/daqboard2000.c
index aef336f..bed2aa0 100644
--- a/drivers/staging/comedi/drivers/daqboard2000.c
+++ b/drivers/staging/comedi/drivers/daqboard2000.c
@@ -653,9 +653,8 @@ static void daqboard2000_activateReferenceDacs(struct comedi_device *dev)
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
@@ -663,9 +662,8 @@ static void daqboard2000_activateReferenceDacs(struct comedi_device *dev)
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
@@ -738,9 +736,9 @@ static int daqboard2000_attach(struct comedi_device *dev,
 	slot = it->options[1];
 
 	result = alloc_private(dev, sizeof(struct daqboard2000_private));
-	if (result < 0) {
+	if (result < 0)
 		return -ENOMEM;
-	}
+
 	for (card = pci_get_device(0x1616, 0x0409, NULL);
 	     card != NULL; card = pci_get_device(0x1616, 0x0409, card)) {
 		if (bus || slot) {
@@ -789,9 +787,8 @@ static int daqboard2000_attach(struct comedi_device *dev,
 	    ioremap(pci_resource_start(card, 0), DAQBOARD2000_PLX_SIZE);
 	devpriv->daq =
 	    ioremap(pci_resource_start(card, 2), DAQBOARD2000_DAQ_SIZE);
-	if (!devpriv->plx || !devpriv->daq) {
+	if (!devpriv->plx || !devpriv->daq)
 		return -ENOMEM;
-	}
 
 	result = alloc_subdevices(dev, 3);
 	if (result < 0)
@@ -864,18 +861,17 @@ static int daqboard2000_detach(struct comedi_device *dev)
 	if (dev->subdevices)
 		subdev_8255_cleanup(dev, dev->subdevices + 2);
 
-	if (dev->irq) {
+	if (dev->irq)
 		free_irq(dev->irq, dev);
-	}
+
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
1.7.0.4

