Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab0IPTLL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 15:11:11 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:39563 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab0IPTLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 15:11:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=GXgf37iC1vYV18Eq1YzdM2CXij4dsAPwMdGxK580LBkA7vISo46l+yafpPtNBBtV64
         51iExwNHhA4xu5jnes9Xqae8G/BP+RqfmXO6BaPBrDoegVoJUyAqifX9YShTKlSQTUDK
         m2HdpGjhjVEyRL3lYeMAa2AmEW4AWFh3P9F1g=
From: Maurice Dawson <mauricedawson2699@gmail.com>
To: gregkh@suse.de, reodge@gmail.com, arun.thomas@gmail.com, segooon@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] Staging: comedi: fix printk() coding style issue in adl_pci9111.c
Date: Thu, 16 Sep 2010 20:10:49 +0100
Message-Id: <1284664249-2786-1-git-send-email-mauricedawson2699@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the adl_pci9111.c file that fixes all, printk() should
include KERN-facility level, warnings found by the checkpatch.pl tool

Signed-off-by: Maurice Dawson <mauricedawson2699@gmail.com>
---
 drivers/staging/comedi/drivers/adl_pci9111.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9111.c b/drivers/staging/comedi/drivers/adl_pci9111.c
index 18103b6..fc48bae 100644
--- a/drivers/staging/comedi/drivers/adl_pci9111.c
+++ b/drivers/staging/comedi/drivers/adl_pci9111.c
@@ -1292,7 +1292,8 @@ static int pci9111_attach(struct comedi_device *dev,
 		return -ENOMEM;
 	/*  Probe the device to determine what device in the series it is. */
 
-	printk("comedi%d: " PCI9111_DRIVER_NAME " driver\n", dev->minor);
+	printk(KERN_ERR "comedi%d: " PCI9111_DRIVER_NAME " driver\n",
+								dev->minor);
 
 	for_each_pci_dev(pci_device) {
 		if (pci_device->vendor == PCI_VENDOR_ID_ADLINK) {
@@ -1325,13 +1326,14 @@ static int pci9111_attach(struct comedi_device *dev,
 		}
 	}
 
-	printk("comedi%d: no supported board found! (req. bus/slot : %d/%d)\n",
-	       dev->minor, it->options[0], it->options[1]);
+	printk(KERN_ERR
+		"comedi%d: no supported board found! (req. bus/slot : %d/%d)\n",
+			dev->minor, it->options[0], it->options[1]);
 	return -EIO;
 
 found:
 
-	printk("comedi%d: found %s (b:s:f=%d:%d:%d) , irq=%d\n",
+	printk(KERN_ERR "comedi%d: found %s (b:s:f=%d:%d:%d) , irq=%d\n",
 	       dev->minor,
 	       pci9111_boards[i].name,
 	       pci_device->bus->number,
@@ -1362,7 +1364,7 @@ found:
 	io_base = pci_resource_start(pci_device, 2);
 	io_range = pci_resource_len(pci_device, 2);
 
-	printk("comedi%d: 6503 registers at address 0x%4lx [0x%4lx]\n",
+	printk(KERN_ERR "comedi%d: 6503 registers at address 0x%4lx [0x%4lx]\n",
 	       dev->minor, io_base, io_range);
 
 	dev->iobase = io_base;
@@ -1380,8 +1382,9 @@ found:
 	if (pci_device->irq > 0) {
 		if (request_irq(pci_device->irq, pci9111_interrupt,
 				IRQF_SHARED, PCI9111_DRIVER_NAME, dev) != 0) {
-			printk("comedi%d: unable to allocate irq  %u\n",
-			       dev->minor, pci_device->irq);
+			printk(KERN_ERR
+				"comedi%d: unable to allocate irq  %u\n",
+					dev->minor, pci_device->irq);
 			return -EINVAL;
 		}
 	}
-- 
1.7.0.4

