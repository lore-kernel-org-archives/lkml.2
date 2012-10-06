Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937Ab2JFFbw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 01:31:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36886 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab2JFFbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 01:31:51 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH] staging/comedi: Use dev_ printks in drivers/me_daq.c
Date: Sat,  6 Oct 2012 14:31:43 +0900
Message-Id: <1349501503-7436-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349395648-5976-1-git-send-email-yamanetoshi@gmail.com>
References: <1349395648-5976-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
- WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
- WARNING: quoted string split across lines

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/comedi/drivers/me_daq.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/comedi/drivers/me_daq.c b/drivers/staging/comedi/drivers/me_daq.c
index 2ce0b14..6a468c1 100644
--- a/drivers/staging/comedi/drivers/me_daq.c
+++ b/drivers/staging/comedi/drivers/me_daq.c
@@ -384,8 +384,7 @@ static int me_ai_insn_read(struct comedi_device *dev,
 		    (readw(dev_private->me_regbase +
 			   ME_READ_AD_FIFO) ^ 0x800) & 0x0FFF;
 	} else {
-		printk(KERN_ERR "comedi%d: Cannot get single value\n",
-		       dev->minor);
+		dev_err(dev->class_dev, "Cannot get single value\n");
 		return -EIO;
 	}
 
@@ -566,8 +565,7 @@ static int me2600_xilinx_download(struct comedi_device *dev,
 	if (value & 0x20) {
 		/* Disable interrupt */
 		writel(0x00, dev_private->plx_regbase + PLX_INTCSR);
-		printk(KERN_ERR "comedi%d: Xilinx download failed\n",
-		       dev->minor);
+		dev_err(dev->class_dev, "Xilinx download failed\n");
 		return -EIO;
 	}
 
@@ -654,8 +652,8 @@ static int me_attach_pci(struct comedi_device *dev, struct pci_dev *pcidev)
 
 	/* Enable PCI device and request PCI regions */
 	if (comedi_pci_enable(pcidev, dev->board_name) < 0) {
-		printk(KERN_ERR "comedi%d: Failed to enable PCI device and "
-		       "request regions\n", dev->minor);
+		dev_err(dev->class_dev,
+			"Failed to enable PCI device and request regions\n");
 		return -EIO;
 	}
 
@@ -666,7 +664,7 @@ static int me_attach_pci(struct comedi_device *dev, struct pci_dev *pcidev)
 	    ioremap(plx_regbase_tmp, plx_regbase_size_tmp);
 	dev_private->plx_regbase_size = plx_regbase_size_tmp;
 	if (!dev_private->plx_regbase) {
-		printk("comedi%d: Failed to remap I/O memory\n", dev->minor);
+		dev_err(dev->class_dev, "Failed to remap I/O memory\n");
 		return -ENOMEM;
 	}
 
@@ -676,11 +674,11 @@ static int me_attach_pci(struct comedi_device *dev, struct pci_dev *pcidev)
 	swap_regbase_size_tmp = pci_resource_len(pcidev, 5);
 
 	if (!swap_regbase_tmp)
-		printk(KERN_ERR "comedi%d: Swap not present\n", dev->minor);
+		dev_err(dev->class_dev, "Swap not present\n");
 
 	/*---------------------------------------------- Workaround start ---*/
 	if (plx_regbase_tmp & 0x0080) {
-		printk(KERN_ERR "comedi%d: PLX-Bug detected\n", dev->minor);
+		dev_err(dev->class_dev, "PLX-Bug detected\n");
 
 		if (swap_regbase_tmp) {
 			regbase_tmp = plx_regbase_tmp;
@@ -716,8 +714,7 @@ static int me_attach_pci(struct comedi_device *dev, struct pci_dev *pcidev)
 	dev_private->me_regbase_size = me_regbase_size_tmp;
 	dev_private->me_regbase = ioremap(me_regbase_tmp, me_regbase_size_tmp);
 	if (!dev_private->me_regbase) {
-		printk(KERN_ERR "comedi%d: Failed to remap I/O memory\n",
-		       dev->minor);
+		dev_err(dev->class_dev, "Failed to remap I/O memory\n");
 		return -ENOMEM;
 	}
 
-- 
1.7.9.5

