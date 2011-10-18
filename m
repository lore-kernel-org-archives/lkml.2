Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757762Ab1JRNND (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 09:13:03 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:32853 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab1JRNNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 09:13:01 -0400
From: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 14/20] Staging: comedi: fix printk issue in cb_pcimdda.c
Date: Tue, 18 Oct 2011 18:42:09 +0530
Message-Id: <1318943535-8251-1-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_pcimdda.c file that fixes up a printk warning
found by the checkpatch.pl tool
Converted printks to dev_printk.
Removed unnecessary printk statement.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_pcimdda.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdda.c b/drivers/staging/comedi/drivers/cb_pcimdda.c
index 8c981a8..6f8ba18 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdda.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdda.c
@@ -300,7 +300,8 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		return err;
 
 /* Output some info */
-	printk("comedi%d: %s: ", dev->minor, thisboard->name);
+	dev_dbg(dev->hw_dev, "comedi%d: %s: attached\n", dev->minor,
+		thisboard->name);
 
 /*
  * Initialize dev->board_name.  Note that we can use the "thisboard"
@@ -341,7 +342,7 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 			break;
 		case DIO_INTERNAL:
 		default:
-			printk("DIO_INTERNAL not implemented yet!\n");
+			dev_err(dev->hw_dev, "DIO_INTERNAL not implemented yet!\n");
 			return -ENXIO;
 			break;
 		}
@@ -351,8 +352,6 @@ static int attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	devpriv->attached_successfully = 1;
 
-	printk("attached\n");
-
 	return 1;
 }
 
@@ -381,8 +380,8 @@ static int detach(struct comedi_device *dev)
 		}
 
 		if (devpriv->attached_successfully && thisboard)
-			printk("comedi%d: %s: detached\n", dev->minor,
-			       thisboard->name);
+			dev_dbg(dev->hw_dev, "comedi%d: %s: detached\n",
+				dev->minor, thisboard->name);
 
 	}
 
@@ -503,7 +502,6 @@ static int probe(struct comedi_device *dev, const struct comedi_devconfig *it)
 		}
 	}
 
-	printk("cb_pcimdda: No supported ComputerBoards/MeasurementComputing "
-	       "card found at the requested position\n");
+	dev_err(dev->hw_dev, "No supported ComputerBoards/MeasurementComputing card found at the requested position\n");
 	return -ENODEV;
 }
-- 
1.7.6.4

