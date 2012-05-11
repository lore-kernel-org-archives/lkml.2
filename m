Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429Ab2EKKkz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 06:40:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63800 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759247Ab2EKKkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 06:40:51 -0400
From: Ravishankar Karkala Mallikarjunayya <ravishankarkm32@gmail.com>
To: gregkh@linuxfoundation.org, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 09/25] Staging: comedi: fix printk issue in rti802.c
Date: Fri, 11 May 2012 16:07:57 +0530
Message-Id: <1336732693-7408-10-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the rti802.c file that fixes up a printk found
by the checkpatch.pl tool.

Used dev_*() functions instead of printks.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/rti802.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rti802.c b/drivers/staging/comedi/drivers/rti802.c
index 21baf1a..202d830 100644
--- a/drivers/staging/comedi/drivers/rti802.c
+++ b/drivers/staging/comedi/drivers/rti802.c
@@ -94,9 +94,9 @@ static int rti802_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	unsigned long iobase;
 
 	iobase = it->options[0];
-	printk(KERN_INFO "comedi%d: rti802: 0x%04lx ", dev->minor, iobase);
+	dev_info(dev->hw_dev, "comedi%d: 0x%04lx\n", dev->minor, iobase);
 	if (!request_region(iobase, RTI802_SIZE, "rti802")) {
-		printk(KERN_WARNING "I/O port conflict\n");
+		dev_warn(dev->hw_dev, "I/O port conflict\n");
 		return -EIO;
 	}
 	dev->iobase = iobase;
@@ -131,7 +131,7 @@ static int rti802_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static int rti802_detach(struct comedi_device *dev)
 {
-	printk(KERN_INFO "comedi%d: rti802: remove\n", dev->minor);
+	dev_info(dev->hw_dev, "comedi%d: remove\n", dev->minor);
 
 	if (dev->iobase)
 		release_region(dev->iobase, RTI802_SIZE);
-- 
1.7.0.4

