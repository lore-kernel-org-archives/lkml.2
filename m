Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab1KCGkp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 02:40:45 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54315 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258Ab1KCGkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 02:40:41 -0400
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 12/14] Staging: comedi: fix printk issue in cb_pcimdas.c
Date: Thu,  3 Nov 2011 12:10:00 +0530
Message-Id: <1320302402-5025-5-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1320302402-5025-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1320302402-5025-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_pcimdas.c file that fixes up a printk
warning found by the checkpatch.pl tool.

converted printks to dev_printk.
Removed unnecessary printk statements.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_pcimdas.c |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdas.c b/drivers/staging/comedi/drivers/cb_pcimdas.c
index b1b832b..321af6d 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdas.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdas.c
@@ -212,8 +212,6 @@ static int cb_pcimdas_attach(struct comedi_device *dev,
 	int index;
 	/* int i; */
 
-	printk("comedi%d: cb_pcimdas: ", dev->minor);
-
 /*
  * Allocate the private structure area.
  */
@@ -223,7 +221,6 @@ static int cb_pcimdas_attach(struct comedi_device *dev,
 /*
  * Probe the device to determine what device in the series it is.
  */
-	printk("\n");
 
 	for_each_pci_dev(pcidev) {
 		/*  is it not a computer boards card? */
@@ -248,26 +245,26 @@ static int cb_pcimdas_attach(struct comedi_device *dev,
 		}
 	}
 
-	printk("No supported ComputerBoards/MeasurementComputing card found on "
-	       "requested position\n");
+	dev_err(dev->hw_dev, "No supported ComputerBoards/MeasurementComputing card found on requested position\n");
 	return -EIO;
 
 found:
 
-	printk("Found %s on bus %i, slot %i\n", cb_pcimdas_boards[index].name,
-	       pcidev->bus->number, PCI_SLOT(pcidev->devfn));
+	dev_dbg(dev->hw_dev, "Found %s on bus %i, slot %i\n",
+		cb_pcimdas_boards[index].name, pcidev->bus->number,
+		PCI_SLOT(pcidev->devfn));
 
 	/*  Warn about non-tested features */
 	switch (thisboard->device_id) {
 	case 0x56:
 		break;
 	default:
-		printk("THIS CARD IS UNSUPPORTED.\n"
-		       "PLEASE REPORT USAGE TO <mocelet@sucs.org>\n");
+		dev_dbg(dev->hw_dev, "THIS CARD IS UNSUPPORTED.\n"
+			"PLEASE REPORT USAGE TO <mocelet@sucs.org>\n");
 	}
 
 	if (comedi_pci_enable(pcidev, "cb_pcimdas")) {
-		printk(" Failed to enable PCI device and request regions\n");
+		dev_err(dev->hw_dev, "Failed to enable PCI device and request regions\n");
 		return -EIO;
 	}
 
@@ -333,8 +330,6 @@ found:
 	else
 		s->type = COMEDI_SUBD_UNUSED;
 
-	printk("attached\n");
-
 	return 1;
 }
 
-- 
1.7.0.4

