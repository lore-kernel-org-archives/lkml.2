Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab1G0Ll2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 07:41:28 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:43565 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529Ab1G0Ll0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 07:41:26 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH v2] Staging: comedi: fix printk issue in adv_pci_dio.c
Date: Wed, 27 Jul 2011 17:10:59 +0530
Message-Id: <1311766859-6217-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <[PATCH]Staging: Comedi: fix printk issue in adv_pci_dio.c>
References: <[PATCH]Staging: Comedi: fix printk issue in adv_pci_dio.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the adv_pci_dio.c file that fixes up a printk warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/adv_pci_dio.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci_dio.c b/drivers/staging/comedi/drivers/adv_pci_dio.c
index d23799b..1d2261f 100644
--- a/drivers/staging/comedi/drivers/adv_pci_dio.c
+++ b/drivers/staging/comedi/drivers/adv_pci_dio.c
@@ -1106,11 +1106,11 @@ static int pci_dio_attach(struct comedi_device *dev,
 	unsigned long iobase;
 	struct pci_dev *pcidev = NULL;
 
-	printk("comedi%d: adv_pci_dio: ", dev->minor);
+	printk(KERN_INFO "comedi%d: adv_pci_dio: ", dev->minor);
 
 	ret = alloc_private(dev, sizeof(struct pci_dio_private));
 	if (ret < 0) {
-		printk(", Error: Cann't allocate private memory!\n");
+		printk(KERN_CONT ", Error: Cann't allocate private memory!\n");
 		return -ENOMEM;
 	}
 
@@ -1140,19 +1140,19 @@ static int pci_dio_attach(struct comedi_device *dev,
 	}
 
 	if (!dev->board_ptr) {
-		printk(", Error: Requested type of the card was not found!\n");
+		printk(KERN_WARNING ", Error: Requested type of the card was not "
+		"found!\n");
 		return -EIO;
 	}
 
 	if (comedi_pci_enable(pcidev, driver_pci_dio.driver_name)) {
 		printk
-		    (", Error: Can't enable PCI device and request regions!\n");
+		(KERN_WARNING ", Error: Can't enable PCI device and request "
+		"regions!\n");
 		return -EIO;
 	}
 	iobase = pci_resource_start(pcidev, this_board->main_pci_region);
-	printk(", b:s:f=%d:%d:%d, io=0x%4lx",
-	       pcidev->bus->number, PCI_SLOT(pcidev->devfn),
-	       PCI_FUNC(pcidev->devfn), iobase);
+	printk(KERN_CONT ", b:s:f=%d:%d:%d, io=0x%4lx",
+	       pcidev->bus->number, PCI_SLOT(pcidev->devfn),
+	       PCI_FUNC(pcidev->devfn), iobase);

 	dev->iobase = iobase;
 	dev->board_name = this_board->name;
@@ -1178,11 +1178,11 @@ static int pci_dio_attach(struct comedi_device *dev,
 
 	ret = alloc_subdevices(dev, n_subdevices);
 	if (ret < 0) {
-		printk(", Error: Cann't allocate subdevice memory!\n");
+		printk(KERN_CONT ", Error: Cann't allocate subdevice memory!\n");
 		return ret;
 	}
 
-	printk(".\n");
+	printk(KERN_CONT ".\n");
 
 	subdev = 0;
 
-- 
1.6.5.2

