Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab1GENxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 09:53:25 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46756 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab1GENxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 09:53:24 -0400
From: ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH] Staging: comedi: fix prink warning style issue in ni_daq_700.c
Date: Tue,  5 Jul 2011 19:22:49 +0530
Message-Id: <1309873969-4690-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <[PATCH] Staging: comedi: fix prink warning issues in ni_daq_700.c>
References: <[PATCH] Staging: comedi: fix prink warning issues in ni_daq_700.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the ni_daq_700.c file that fixes up a prink  warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/ni_daq_700.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index 2672629..e242012 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -51,7 +51,7 @@ IRQ is assigned but not used.
 #include <pcmcia/cisreg.h>
 #include <pcmcia/ds.h>
 
-static struct pcmcia_device *pcmcia_cur_dev = NULL;
+static struct pcmcia_device *pcmcia_cur_dev;
 
 #define DIO700_SIZE 8		/*  size of io region used by board */
 
@@ -381,11 +381,11 @@ static int dio700_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 #endif
 		break;
 	default:
-		printk("bug! couldn't determine board type\n");
+		printk(KERN_ERR "bug! couldn't determine board type\n");
 		return -EINVAL;
 		break;
 	}
-	printk("comedi%d: ni_daq_700: %s, io 0x%lx", dev->minor,
+	printk(KERN_ERR "comedi%d: ni_daq_700: %s, io 0x%lx", dev->minor,
 	       thisboard->name, iobase);
 #ifdef incomplete
 	if (irq)
@@ -396,7 +396,7 @@ static int dio700_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	printk("\n");
 
 	if (iobase == 0) {
-		printk("io base address is zero!\n");
+		printk(KERN_ERR "io base address is zero!\n");
 		return -EINVAL;
 	}
 
@@ -421,7 +421,7 @@ static int dio700_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static int dio700_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: ni_daq_700: cs-remove\n", dev->minor);
+	printk(KERN_ERR "comedi%d: ni_daq_700: cs-remove\n", dev->minor);
 
 	if (dev->subdevices)
 		subdev_700_cleanup(dev, dev->subdevices + 0);
-- 
1.7.1.1

