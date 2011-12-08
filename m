Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab1LHMzc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 07:55:32 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36787 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885Ab1LHMz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 07:55:27 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 30/30] Staging: comedi: fix printk issue in das1800.c
Date: Thu,  8 Dec 2011 18:22:25 +0530
Message-Id: <1323348745-31477-30-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the das1800.c file that fixes up a
printk warning found by the checkpatch.pl tool.

Included KERN_facility levels for printk.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/das1800.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das1800.c b/drivers/staging/comedi/drivers/das1800.c
index a6df30b..da9bdc5 100644
--- a/drivers/staging/comedi/drivers/das1800.c
+++ b/drivers/staging/comedi/drivers/das1800.c
@@ -644,7 +644,7 @@ static int das1800_attach(struct comedi_device *dev,
 	printk("\n");
 
 	if (iobase == 0) {
-		printk(" io base address required\n");
+		printk(KERN_ERR "io base address required\n");
 		return -EINVAL;
 	}
 
@@ -659,7 +659,7 @@ static int das1800_attach(struct comedi_device *dev,
 
 	board = das1800_probe(dev);
 	if (board < 0) {
-		printk(" unable to determine board type\n");
+		printk(KERN_ERR "unable to determine board type\n");
 		return -ENODEV;
 	}
 
@@ -683,7 +683,7 @@ static int das1800_attach(struct comedi_device *dev,
 	if (irq) {
 		if (request_irq(irq, das1800_interrupt, 0,
 				driver_das1800.driver_name, dev)) {
-			printk(" unable to allocate irq %u\n", irq);
+			printk(KERN_ERR "unable to allocate irq %u\n", irq);
 			return -EINVAL;
 		}
 	}
@@ -712,7 +712,7 @@ static int das1800_attach(struct comedi_device *dev,
 		devpriv->irq_dma_bits |= 0x38;
 		break;
 	default:
-		printk(" irq out of range\n");
+		printk(KERN_ERR "irq out of range\n");
 		return -EINVAL;
 		break;
 	}
-- 
1.7.0.4

