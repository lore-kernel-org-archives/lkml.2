Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab1KUKhf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 05:37:35 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64088 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755996Ab1KUKhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 05:37:33 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 3/8] Staging: comedi: fix printk issue in ni_daq_dio24.c
Date: Mon, 21 Nov 2011 16:07:01 +0530
Message-Id: <1321871826-13581-3-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1321871826-13581-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1321871826-13581-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the ni_daq_dio24.c file that fixes up a printk
warning found by the checkpatch.pl tool.
Converted printks to pr_<levels> and dev_version.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/ni_daq_dio24.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_dio24.c b/drivers/staging/comedi/drivers/ni_daq_dio24.c
index 75b3f9a..c0423a8 100644
--- a/drivers/staging/comedi/drivers/ni_daq_dio24.c
+++ b/drivers/staging/comedi/drivers/ni_daq_dio24.c
@@ -133,21 +133,19 @@ static int dio24_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 #endif
 		break;
 	default:
-		printk("bug! couldn't determine board type\n");
+		pr_err("bug! couldn't determine board type\n");
 		return -EINVAL;
 		break;
 	}
-	printk("comedi%d: ni_daq_dio24: %s, io 0x%lx", dev->minor,
-	       thisboard->name, iobase);
+	pr_debug("comedi%d: ni_daq_dio24: %s, io 0x%lx", dev->minor,
+		 thisboard->name, iobase);
 #ifdef incomplete
 	if (irq)
-		printk(", irq %u", irq);
+		pr_debug("irq %u\n", irq);
 #endif
 
-	printk("\n");
-
 	if (iobase == 0) {
-		printk("io base address is zero!\n");
+		pr_err("io base address is zero!\n");
 		return -EINVAL;
 	}
 
@@ -172,7 +170,7 @@ static int dio24_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static int dio24_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: ni_daq_dio24: remove\n", dev->minor);
+	dev_info(dev->hw_dev, "comedi%d: ni_daq_dio24: remove\n", dev->minor);
 
 	if (dev->subdevices)
 		subdev_8255_cleanup(dev, dev->subdevices + 0);
-- 
1.7.0.4

