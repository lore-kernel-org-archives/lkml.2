Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030258Ab2EKKm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 06:42:58 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57485 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030234Ab2EKKmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 06:42:55 -0400
From: Ravishankar Karkala Mallikarjunayya <ravishankarkm32@gmail.com>
To: gregkh@linuxfoundation.org, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 23/25] Staging: comedi: fix printk issue in poc.c
Date: Fri, 11 May 2012 16:08:11 +0530
Message-Id: <1336732693-7408-24-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the poc.c file that fixes up a
printk warning found by the checkpatch.pl tool.

Converted printks to dev_<level> function.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/poc.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/poc.c b/drivers/staging/comedi/drivers/poc.c
index e3690bb..a55b877 100644
--- a/drivers/staging/comedi/drivers/poc.c
+++ b/drivers/staging/comedi/drivers/poc.c
@@ -142,21 +142,22 @@ static int poc_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	unsigned int iosize;
 
 	iobase = it->options[0];
-	printk(KERN_INFO "comedi%d: poc: using %s iobase 0x%lx\n", dev->minor,
-	       this_board->name, iobase);
+	dev_info(dev->hw_dev, "comedi%d: poc: using %s iobase 0x%lx\n",
+		 dev->minor, this_board->name, iobase);
 
 	dev->board_name = this_board->name;
 
 	if (iobase == 0) {
-		printk(KERN_ERR "io base address required\n");
+		dev_err(dev->hw_dev, "io base address required\n");
 		return -EINVAL;
 	}
 
 	iosize = this_board->iosize;
 	/* check if io addresses are available */
 	if (!request_region(iobase, iosize, "dac02")) {
-		printk(KERN_ERR "I/O port conflict: failed to allocate ports "
-			"0x%lx to 0x%lx\n", iobase, iobase + iosize - 1);
+		dev_err(dev->hw_dev,
+			"I/O port conflict: failed to allocate ports 0x%lx to 0x%lx\n",
+			iobase, iobase + iosize - 1);
 		return -EIO;
 	}
 	dev->iobase = iobase;
@@ -187,7 +188,7 @@ static int poc_detach(struct comedi_device *dev)
 	if (dev->iobase)
 		release_region(dev->iobase, this_board->iosize);
 
-	printk(KERN_INFO "comedi%d: dac02: remove\n", dev->minor);
+	dev_info(dev->hw_dev, "comedi%d: remove\n", dev->minor);
 
 	return 0;
 }
-- 
1.7.0.4

