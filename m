Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab1LLFWI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 00:22:08 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59165 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab1LLFWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 00:22:03 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 26/29] Staging: comedi: fix printk issue in das1800.c
Date: Mon, 12 Dec 2011 10:49:38 +0530
Message-Id: <1323667181-17252-26-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the das1800.c file that fixes up a
printk warning found by the checkpatch.pl tool.

Included KERN_facility levels for printk.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/das1800.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das1800.c b/drivers/staging/comedi/drivers/das1800.c
index 6ef3e8f..3ca751c 100644
--- a/drivers/staging/comedi/drivers/das1800.c
+++ b/drivers/staging/comedi/drivers/das1800.c
@@ -632,17 +632,17 @@ static int das1800_attach(struct comedi_device *dev,
 	if (alloc_private(dev, sizeof(struct das1800_private)) < 0)
 		return -ENOMEM;
 
-	printk("comedi%d: %s: io 0x%lx", dev->minor, driver_das1800.driver_name,
-	       iobase);
+	printk(KERN_DEBUG "comedi%d: %s: io 0x%lx", dev->minor,
+	       driver_das1800.driver_name, iobase);
 	if (irq) {
-		printk(", irq %u", irq);
+		printk(KERN_CONT ", irq %u", irq);
 		if (dma0) {
-			printk(", dma %u", dma0);
+			printk(KERN_CONT ", dma %u", dma0);
 			if (dma1)
-				printk(" and %u", dma1);
+				printk(KERN_CONT " and %u", dma1);
 		}
 	}
-	printk("\n");
+	printk(KERN_CONT "\n");
 
 	if (iobase == 0) {
 		printk(" io base address required\n");
-- 
1.7.0.4

