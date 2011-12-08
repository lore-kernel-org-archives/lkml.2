Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab1LHMxa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 07:53:30 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36787 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab1LHMxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 07:53:25 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 07/30] Staging: comedi: fix printk issue in cb_pcimdda.c
Date: Thu,  8 Dec 2011 18:22:02 +0530
Message-Id: <1323348745-31477-7-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_pcimdda.c file that fixes up a
printk warning found by the checkpatch.pl tool.

Removed unnecessary printk statements.
Included KERN_facility levels.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_pcimdda.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdda.c b/drivers/staging/comedi/drivers/cb_pcimdda.c
index 6521d61..d2f3c3b 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdda.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdda.c
@@ -298,7 +298,8 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		return err;
 
 /* Output some info */
-	printk("comedi%d: %s: ", dev->minor, thisboard->name);
+	printk(KERN_INFO "comedi%d: %s: attached\n", dev->minor,
+	       thisboard->name);
 
 /*
  * Initialize dev->board_name.  Note that we can use the "thisboard"
@@ -339,7 +340,7 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 			break;
 		case DIO_INTERNAL:
 		default:
-			printk("DIO_INTERNAL not implemented yet!\n");
+			printk(KERN_WARNING "DIO_INTERNAL not implemented yet!\n");
 			return -ENXIO;
 			break;
 		}
@@ -349,8 +350,6 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	devpriv->attached_successfully = 1;
 
-	printk("attached\n");
-
 	return 1;
 }
 
@@ -379,7 +378,7 @@ static int detach(struct comedi_device *dev)
 		}
 
 		if (devpriv->attached_successfully && thisboard)
-			printk("comedi%d: %s: detached\n", dev->minor,
+			printk(KERN_INFO "comedi%d: %s: detached\n", dev->minor,
 			       thisboard->name);
 
 	}
@@ -486,11 +485,8 @@ static int probe(struct comedi_device *dev, const struct comedi_devconfig *it)
 
 			devpriv->pci_dev = pcidev;
 			dev->board_ptr = boards + index;
-			if (comedi_pci_enable(pcidev, thisboard->name)) {
-				printk
-				    ("cb_pcimdda: Failed to enable PCI device and request regions\n");
+			if (comedi_pci_enable(pcidev, thisboard->name))
 				return -EIO;
-			}
 			registers =
 			    pci_resource_start(devpriv->pci_dev,
 					       REGS_BADRINDEX);
@@ -501,7 +497,6 @@ static int probe(struct comedi_device *dev, const struct comedi_devconfig *it)
 		}
 	}
 
-	printk("cb_pcimdda: No supported ComputerBoards/MeasurementComputing "
-	       "card found at the requested position\n");
+	printk(KERN_ERR "cb_pcimdda: No supported ComputerBoards/MeasurementComputing card found at the requested position\n");
 	return -ENODEV;
 }
-- 
1.7.0.4

