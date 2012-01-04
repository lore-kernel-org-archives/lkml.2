Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab2ADMlE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 07:41:04 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:45813 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755421Ab2ADMkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 07:40:47 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com, rmallon@gmail.com, joe@perches.com,
        valdis.kletnieks@vt.edu,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 04/11] Staging: comedi: fix printk warning issue in cb_pcimdda.c
Date: Wed,  4 Jan 2012 18:09:59 +0530
Message-Id: <1325680806-10917-4-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1325680806-10917-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1325680806-10917-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a printk warning found by the checkpatch.pl
tool.
Convert printk to dev_<levels>.
Convert multiple printk message to single printk message.
Removes useless printk messages.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_pcimdda.c |   19 ++++++-------------
 1 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdda.c b/drivers/staging/comedi/drivers/cb_pcimdda.c
index 40bddfa..8f5b2fe 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdda.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdda.c
@@ -301,9 +301,6 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (err)
 		return err;
 
-/* Output some info */
-	printk("comedi%d: %s: ", dev->minor, thisboard->name);
-
 /*
  * Initialize dev->board_name.  Note that we can use the "thisboard"
  * macro now, since we just initialized it in the last line.
@@ -346,7 +343,7 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 			break;
 		case DIO_INTERNAL:
 		default:
-			printk("DIO_INTERNAL not implemented yet!\n");
+			dev_warn(dev->hw_dev, "DIO_INTERNAL not implemented yet!\n");
 			return -ENXIO;
 			break;
 		}
@@ -356,7 +353,8 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	devpriv->attached_successfully = 1;
 
-	printk("attached\n");
+	dev_info(dev->hw_dev, "comedi%d: %s: attached\n", dev->minor,
+		 thisboard->name);
 
 	return 1;
 }
@@ -386,8 +384,8 @@ static int detach(struct comedi_device *dev)
 		}
 
 		if (devpriv->attached_successfully && thisboard)
-			printk("comedi%d: %s: detached\n", dev->minor,
-			       thisboard->name);
+			dev_info(dev->hw_dev, "comedi%d: %s: detached\n",
+				 dev->minor, thisboard->name);
 
 	}
 
@@ -496,11 +494,8 @@ static int probe(struct comedi_device *dev, const struct comedi_devconfig *it)
 
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
@@ -511,7 +506,5 @@ static int probe(struct comedi_device *dev, const struct comedi_devconfig *it)
 		}
 	}
 
-	printk("cb_pcimdda: No supported ComputerBoards/MeasurementComputing "
-	       "card found at the requested position\n");
 	return -ENODEV;
 }
-- 
1.7.0.4

