Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab1LLFVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 00:21:15 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59165 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab1LLFVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 00:21:11 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 15/29] Staging: comedi: fix brace coding style issue in ni_at_a2150.c
Date: Mon, 12 Dec 2011 10:49:27 +0530
Message-Id: <1323667181-17252-15-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the ni_at_a2150.c file that fixes up a brace
warning found by the checkpatch.pl tool.

Converted printks to dev_<levels>.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/ni_at_a2150.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_at_a2150.c b/drivers/staging/comedi/drivers/ni_at_a2150.c
index c25e44c..26f204c 100644
--- a/drivers/staging/comedi/drivers/ni_at_a2150.c
+++ b/drivers/staging/comedi/drivers/ni_at_a2150.c
@@ -366,13 +366,13 @@ static int a2150_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		return -ENOMEM;
 
 	if (iobase == 0) {
-		printk(" io base address required\n");
+		dev_err(dev->hw_dev, "io base address required\n");
 		return -EINVAL;
 	}
 
 	/* check if io addresses are available */
 	if (!request_region(iobase, A2150_SIZE, driver_a2150.driver_name)) {
-		printk(" I/O port conflict\n");
+		dev_err(dev->hw_dev, "I/O port conflict\n");
 		return -EIO;
 	}
 	dev->iobase = iobase;
@@ -381,12 +381,13 @@ static int a2150_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (irq) {
 		/*  check that irq is supported */
 		if (irq < 3 || irq == 8 || irq == 13 || irq > 15) {
-			printk(" invalid irq line %u\n", irq);
+			dev_err(dev->hw_dev, "invalid irq line %u\n", irq);
 			return -EINVAL;
 		}
 		if (request_irq(irq, a2150_interrupt, 0,
 				driver_a2150.driver_name, dev)) {
-			printk("unable to allocate irq %u\n", irq);
+			dev_err(dev->hw_dev, "unable to allocate irq %u\n",
+				irq);
 			return -EINVAL;
 		}
 		devpriv->irq_dma_bits |= IRQ_LVL_BITS(irq);
-- 
1.7.0.4

