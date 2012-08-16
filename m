Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab2HPAcK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 20:32:10 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:42049 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154Ab2HPAcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 20:32:08 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-160.messagelabs.com!1345077127!7029575!2
X-Originating-IP: [216.166.12.98]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/7] staging: comedi: contec_pci_dio: remove unneeded boardinfo code
Date: Wed, 15 Aug 2012 17:31:59 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208151731.59898.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The boardinfo code is not needed by this driver. Only one board
type is supported.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/contec_pci_dio.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/comedi/drivers/contec_pci_dio.c b/drivers/staging/comedi/drivers/contec_pci_dio.c
index 698d05b..4b47fa0 100644
--- a/drivers/staging/comedi/drivers/contec_pci_dio.c
+++ b/drivers/staging/comedi/drivers/contec_pci_dio.c
@@ -36,17 +36,6 @@ Configuration Options:
 
 #include "../comedidev.h"
 
-enum contec_model {
-	PIO1616L = 0,
-};
-
-struct contec_board {
-	const char *name;
-};
-static const struct contec_board contec_boards[] = {
-	{"PIO1616L", },
-};
-
 #define PCI_DEVICE_ID_PIO1616L 0x8172
 
 /*
@@ -94,7 +83,6 @@ static struct pci_dev *contec_find_pci_dev(struct comedi_device *dev,
 		    pcidev->device != PCI_DEVICE_ID_PIO1616L)
 			continue;
 
-		dev->board_ptr = contec_boards + 0;
 		return pcidev;
 	}
 	dev_err(dev->class_dev,
@@ -105,7 +93,6 @@ static struct pci_dev *contec_find_pci_dev(struct comedi_device *dev,
 
 static int contec_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
-	const struct contec_board *thisboard;
 	struct pci_dev *pcidev;
 	struct comedi_subdevice *s;
 	int ret;
@@ -120,8 +107,7 @@ static int contec_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (!pcidev)
 		return -EIO;
 	comedi_set_hw_dev(dev, &pcidev->dev);
-	thisboard = comedi_board(dev);
-	dev->board_name = thisboard->name;
+	dev->board_name = dev->driver->driver_name;
 
 	if (comedi_pci_enable(pcidev, "contec_pci_dio")) {
 		printk("error enabling PCI device and request regions!\n");
@@ -182,8 +168,7 @@ static void __devexit contec_pci_dio_pci_remove(struct pci_dev *dev)
 }
 
 static DEFINE_PCI_DEVICE_TABLE(contec_pci_dio_pci_table) = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_CONTEC, PCI_DEVICE_ID_PIO1616L),
-		.driver_data = PIO1616L },
+	{ PCI_DEVICE(PCI_VENDOR_ID_CONTEC, PCI_DEVICE_ID_PIO1616L) },
 	{ 0 }
 };
 MODULE_DEVICE_TABLE(pci, contec_pci_dio_pci_table);
-- 
1.7.11

