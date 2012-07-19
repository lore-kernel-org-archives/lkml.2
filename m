Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab2GSCCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 22:02:50 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:9793 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab2GSCCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 22:02:37 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-131.messagelabs.com!1342663355!14759256!2
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 79/90] staging: comedi: ke_counter: minor cleanup of cnt_attach()
Date: Wed, 18 Jul 2012 19:02:29 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181902.29767.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup the attach function a bit to follow the style of
the other comedi pci drivers.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ke_counter.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ke_counter.c b/drivers/staging/comedi/drivers/ke_counter.c
index 826e6c2..78eb8d4 100644
--- a/drivers/staging/comedi/drivers/ke_counter.c
+++ b/drivers/staging/comedi/drivers/ke_counter.c
@@ -158,9 +158,9 @@ static struct pci_dev *cnt_find_pci_dev(struct comedi_device *dev,
 
 static int cnt_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
-	struct pci_dev *pci_device;
+	const struct cnt_board_struct *board;
+	struct pci_dev *pcidev;
 	struct comedi_subdevice *subdevice;
-	struct cnt_board_struct *board;
 	unsigned long io_base;
 	int error;
 
@@ -169,16 +169,16 @@ static int cnt_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (error < 0)
 		return error;
 
-	pci_device = cnt_find_pci_dev(dev, it);
-	if (!pci_device)
+	pcidev = cnt_find_pci_dev(dev, it);
+	if (!pcidev)
 		return -EIO;
-	devpriv->pcidev = pci_device;
-	board = (struct cnt_board_struct *)dev->board_ptr;
+	devpriv->pcidev = pcidev;
+	board = comedi_board(dev);
 
 	dev->board_name = board->name;
 
 	/* enable PCI device and request regions */
-	error = comedi_pci_enable(pci_device, CNT_DRIVER_NAME);
+	error = comedi_pci_enable(pcidev, CNT_DRIVER_NAME);
 	if (error < 0) {
 		printk(KERN_WARNING "comedi%d: "
 		       "failed to enable PCI device and request regions!\n",
@@ -187,7 +187,7 @@ static int cnt_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 
 	/* read register base address [PCI_BASE_ADDRESS #0] */
-	io_base = pci_resource_start(pci_device, 0);
+	io_base = pci_resource_start(pcidev, 0);
 	dev->iobase = io_base;
 
 	error = comedi_alloc_subdevices(dev, 1);
-- 
1.7.11

