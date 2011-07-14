Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab1GNE3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 00:29:52 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39915 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab1GNE3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 00:29:50 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 30/30] Staging: comedi: fix printk() issue in das16m1.c
Date: Thu, 14 Jul 2011 10:12:27 +0530
Message-Id: <1310618547-8801-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH 3/3]Staging: comedi: fix printk warning issue in das16m1.c>
References: <[PATCH 3/3]Staging: comedi: fix printk warning issue in das16m1.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the das16m1.c file that fixes up a printk() warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/das16m1.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das16m1.c b/drivers/staging/comedi/drivers/das16m1.c
index ccb7991..efc6132 100644
--- a/drivers/staging/comedi/drivers/das16m1.c
+++ b/drivers/staging/comedi/drivers/das16m1.c
@@ -672,7 +672,7 @@ static int das16m1_attach(struct comedi_device *dev,
 
 	iobase = it->options[0];
 
-	printk("comedi%d: das16m1:", dev->minor);
+	printk(KERN_INFO "comedi%d: das16m1:", dev->minor);
 
 	ret = alloc_private(dev, sizeof(struct das16m1_private_struct));
 	if (ret < 0)
@@ -690,7 +690,7 @@ static int das16m1_attach(struct comedi_device *dev,
 	if (!request_region(iobase + DAS16M1_82C55, DAS16M1_SIZE2,
 			    driver_das16m1.driver_name)) {
 		release_region(iobase, DAS16M1_SIZE);
-		printk(" I/O port conflict\n");
+		printk(KERN_ERR " I/O port conflict\n");
 		return -EIO;
 	}
 	dev->iobase = iobase;
@@ -710,7 +710,7 @@ static int das16m1_attach(struct comedi_device *dev,
 	} else if (irq == 0) {
 		printk(", no irq\n");
 	} else {
-		printk(", invalid irq\n"
+		printk(KERN_ERR ", invalid irq\n"
 		       " valid irqs are 2, 3, 5, 7, 10, 11, 12, or 15\n");
 		return -EINVAL;
 	}
@@ -776,7 +776,7 @@ static int das16m1_attach(struct comedi_device *dev,
 
 static int das16m1_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: das16m1: remove\n", dev->minor);
+	printk(KERN_INFO "comedi%d: das16m1: remove\n", dev->minor);
 
 /* das16m1_reset(dev); */
 
-- 
1.6.5.2

