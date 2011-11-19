Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758334Ab1KSEia (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 23:38:30 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59220 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758314Ab1KSEi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 23:38:26 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 18/25] Staging: comedi: fix printk issue in das08_cs.c
Date: Sat, 19 Nov 2011 10:06:50 +0530
Message-Id: <1321677417-2415-18-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1321677417-2415-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1321677417-2415-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the das08_cs.c file that fixes up a printk
warning found by the checkpatch.pl tool.

converted printks to dev_printk.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/das08_cs.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das08_cs.c b/drivers/staging/comedi/drivers/das08_cs.c
index 6d91d30..4ad398a 100644
--- a/drivers/staging/comedi/drivers/das08_cs.c
+++ b/drivers/staging/comedi/drivers/das08_cs.c
@@ -79,22 +79,20 @@ static int das08_cs_attach(struct comedi_device *dev,
 	if (ret < 0)
 		return ret;
 
-	printk("comedi%d: das08_cs: ", dev->minor);
+	dev_info(dev->hw_dev, "comedi%d: das08_cs:\n", dev->minor);
 	/*  deal with a pci board */
 
 	if (thisboard->bustype == pcmcia) {
 		if (link == NULL) {
-			printk(" no pcmcia cards found\n");
+			dev_err(dev->hw_dev, "no pcmcia cards found\n");
 			return -EIO;
 		}
 		iobase = link->resource[0]->start;
 	} else {
-		printk(" bug! board does not have PCMCIA bustype\n");
+		dev_err(dev->hw_dev, "bug! board does not have PCMCIA bustype\n");
 		return -EINVAL;
 	}
 
-	printk("\n");
-
 	return das08_common_attach(dev, iobase);
 }
 
-- 
1.7.0.4

