Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417Ab1JTGV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 02:21:28 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62560 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303Ab1JTGVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 02:21:25 -0400
From: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 14/24] Staging: comedi: fix printk issue in cb_pcimdda.c
Date: Thu, 20 Oct 2011 11:49:00 +0530
Message-Id: <1319091550-2558-14-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1319091550-2558-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1319091550-2558-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_pcimdda.c file that fixes up a printk warning
found by the checkpatch.pl tool
Converted printks to dev_printk.

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

