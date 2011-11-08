Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932892Ab1KHLSH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 06:18:07 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34626 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932324Ab1KHLRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 06:17:03 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 17/20] Staging: comedi: fix printk issue in adv_pci_dio.c
Date: Tue,  8 Nov 2011 16:45:27 +0530
Message-Id: <1320750930-9764-17-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1320750930-9764-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1320750930-9764-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the adv_pci_dio.c file that fixes up a printk
warning found by the checkpatch.pl tool.

converted printks to dev_version.
Removed unnecessary printk statements.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/adv_pci_dio.c |   23 +++++++----------------
 1 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci_dio.c b/drivers/staging/comedi/drivers/adv_pci_dio.c
index 69334f6..537e585 100644
--- a/drivers/staging/comedi/drivers/adv_pci_dio.c
+++ b/drivers/staging/comedi/drivers/adv_pci_dio.c
@@ -1106,13 +1106,10 @@ static int pci_dio_attach(struct comedi_device *dev,
 	unsigned long iobase;
 	struct pci_dev *pcidev = NULL;
 
-	printk("comedi%d: adv_pci_dio: ", dev->minor);
 
 	ret = alloc_private(dev, sizeof(struct pci_dio_private));
-	if (ret < 0) {
-		printk(", Error: Cann't allocate private memory!\n");
+	if (ret < 0)
 		return -ENOMEM;
-	}
 
 	for_each_pci_dev(pcidev) {
 		/*  loop through cards supported by this driver */
@@ -1140,19 +1137,18 @@ static int pci_dio_attach(struct comedi_device *dev,
 	}
 
 	if (!dev->board_ptr) {
-		printk(", Error: Requested type of the card was not found!\n");
+		dev_err(dev->hw_dev, "Error: Requested type of the card was not found!\n");
 		return -EIO;
 	}
 
 	if (comedi_pci_enable(pcidev, driver_pci_dio.driver_name)) {
-		printk
-		    (", Error: Can't enable PCI device and request regions!\n");
+		dev_err(dev->hw_dev, "Error: Can't enable PCI device and request regions!\n");
 		return -EIO;
 	}
 	iobase = pci_resource_start(pcidev, this_board->main_pci_region);
-	printk(", b:s:f=%d:%d:%d, io=0x%4lx",
-	       pcidev->bus->number, PCI_SLOT(pcidev->devfn),
-	       PCI_FUNC(pcidev->devfn), iobase);
+	dev_dbg(dev->hw_dev, "b:s:f=%d:%d:%d, io=0x%4lx\n",
+		pcidev->bus->number, PCI_SLOT(pcidev->devfn),
+		PCI_FUNC(pcidev->devfn), iobase);
 
 	dev->iobase = iobase;
 	dev->board_name = this_board->name;
@@ -1177,15 +1173,10 @@ static int pci_dio_attach(struct comedi_device *dev,
 	}
 
 	ret = alloc_subdevices(dev, n_subdevices);
-	if (ret < 0) {
-		printk(", Error: Cann't allocate subdevice memory!\n");
+	if (ret < 0)
 		return ret;
-	}
-
-	printk(".\n");
 
 	subdev = 0;
-
 	for (i = 0; i < MAX_DI_SUBDEVS; i++)
 		if (this_board->sdi[i].chans) {
 			s = dev->subdevices + subdev;
-- 
1.7.0.4

