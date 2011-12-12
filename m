Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab1LLFUd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 00:20:33 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59165 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab1LLFU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 00:20:29 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 07/29] Staging: comedi: fix printk issue in pcmuio.c
Date: Mon, 12 Dec 2011 10:49:19 +0530
Message-Id: <1323667181-17252-7-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the pcmuio.c file that fixes up a printk
warning found by the checkpatch.pl tool.

Converted printks to dev_functions.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/pcmuio.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcmuio.c b/drivers/staging/comedi/drivers/pcmuio.c
index 41f843b..9a5dc91 100644
--- a/drivers/staging/comedi/drivers/pcmuio.c
+++ b/drivers/staging/comedi/drivers/pcmuio.c
@@ -436,14 +436,13 @@ static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 				   irqs.. */
 
 	if (irq[0]) {
-		printk("irq: %u ", irq[0]);
+		dev_dbg(dev->hw_dev, "irq: %u\n", irq[0]);
 		if (irq[1] && thisboard->num_asics == 2)
-			printk("second ASIC irq: %u ", irq[1]);
+			dev_dbg(dev->hw_dev, "second ASIC irq: %u\n", irq[1]);
 	} else {
-		printk("(IRQ mode disabled) ");
+		dev_dbg(dev->hw_dev, "(IRQ mode disabled)\n");
 	}
 
-	printk("attached\n");
 
 	return 1;
 }
@@ -460,7 +459,8 @@ static int pcmuio_detach(struct comedi_device *dev)
 {
 	int i;
 
-	printk("comedi%d: %s: remove\n", dev->minor, driver.driver_name);
+	dev_dbg(dev->hw_dev, "comedi%d: %s: remove\n", dev->minor,
+		driver.driver_name);
 	if (dev->iobase)
 		release_region(dev->iobase, ASIC_IOSIZE * thisboard->num_asics);
 
-- 
1.7.0.4

