Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030246Ab2EKKmw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 06:42:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51406 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030234Ab2EKKms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 06:42:48 -0400
From: Ravishankar Karkala Mallikarjunayya <ravishankarkm32@gmail.com>
To: gregkh@linuxfoundation.org, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 22/25] Staging: comedi: fix printk issue in pcmad.c
Date: Fri, 11 May 2012 16:08:10 +0530
Message-Id: <1336732693-7408-23-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the pcmad.c file that fixes up a
printk warning found by the checkpatch.pl tool.

Converted printks to dev_<levels> function.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/pcmad.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcmad.c b/drivers/staging/comedi/drivers/pcmad.c
index fe8ef66..c974523 100644
--- a/drivers/staging/comedi/drivers/pcmad.c
+++ b/drivers/staging/comedi/drivers/pcmad.c
@@ -109,12 +109,11 @@ static int pcmad_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	unsigned long iobase;
 
 	iobase = it->options[0];
-	printk(KERN_INFO "comedi%d: pcmad: 0x%04lx ", dev->minor, iobase);
+	dev_info(dev->hw_dev, "comedi%d: 0x%04lx\n", dev->minor, iobase);
 	if (!request_region(iobase, PCMAD_SIZE, "pcmad")) {
-		printk(KERN_CONT "I/O port conflict\n");
+		dev_err(dev->hw_dev, "I/O port conflict\n");
 		return -EIO;
 	}
-	printk(KERN_CONT "\n");
 	dev->iobase = iobase;
 
 	ret = alloc_subdevices(dev, 1);
@@ -141,7 +140,7 @@ static int pcmad_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static int pcmad_detach(struct comedi_device *dev)
 {
-	printk(KERN_INFO "comedi%d: pcmad: remove\n", dev->minor);
+	dev_info(dev->hw_dev, "comedi%d: remove\n", dev->minor);
 
 	if (dev->irq)
 		free_irq(dev->irq, dev);
-- 
1.7.0.4

