Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab2GTRbx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 13:31:53 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:50177 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab2GTRbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 13:31:51 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-132.messagelabs.com!1342805414!14943098!46
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] staging: comedi: remove pci_is_enabled() tests
Date: Fri, 20 Jul 2012 10:31:43 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207201031.43951.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As mentioned by Ian Abbott, the comedi pci drivers that try to
locate an unused pci device with the pci_is_enabled() test
might actually skip over a perfectly good unused device. This
test is also not consistent with the other comedi pci drivers.

Remove the test from all the comedi pci drivers.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Reported-by: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adv_pci1710.c | 3 ---
 drivers/staging/comedi/drivers/adv_pci1723.c | 2 --
 drivers/staging/comedi/drivers/adv_pci_dio.c | 2 --
 3 files changed, 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index 3198660..6b4d0d6 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -1349,9 +1349,6 @@ static struct pci_dev *pci1710_find_pci_dev(struct comedi_device *dev,
 		}
 		if (pcidev->vendor != PCI_VENDOR_ID_ADVANTECH)
 			continue;
-		if (pci_is_enabled(pcidev))
-			continue;
-
 		if (strcmp(this_board->name, DRV_NAME) == 0) {
 			for (i = 0; i < ARRAY_SIZE(boardtypes); ++i) {
 				if (pcidev->device == boardtypes[i].device_id) {
diff --git a/drivers/staging/comedi/drivers/adv_pci1723.c b/drivers/staging/comedi/drivers/adv_pci1723.c
index da5ee69..dfde0f6 100644
--- a/drivers/staging/comedi/drivers/adv_pci1723.c
+++ b/drivers/staging/comedi/drivers/adv_pci1723.c
@@ -301,8 +301,6 @@ static struct pci_dev *pci1723_find_pci_dev(struct comedi_device *dev,
 		}
 		if (pcidev->vendor != PCI_VENDOR_ID_ADVANTECH)
 			continue;
-		if (pci_is_enabled(pcidev))
-			continue;
 		return pcidev;
 	}
 	dev_err(dev->class_dev,
diff --git a/drivers/staging/comedi/drivers/adv_pci_dio.c b/drivers/staging/comedi/drivers/adv_pci_dio.c
index 97f06dc..2d4cb7f 100644
--- a/drivers/staging/comedi/drivers/adv_pci_dio.c
+++ b/drivers/staging/comedi/drivers/adv_pci_dio.c
@@ -1064,8 +1064,6 @@ static struct pci_dev *pci_dio_find_pci_dev(struct comedi_device *dev,
 			    slot != PCI_SLOT(pcidev->devfn))
 				continue;
 		}
-		if (pci_is_enabled(pcidev))
-			continue;
 		for (i = 0; i < ARRAY_SIZE(boardtypes); ++i) {
 			if (boardtypes[i].vendor_id != pcidev->vendor)
 				continue;
-- 
1.7.11

