Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab2IMBqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 21:46:16 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62212 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab2IMBqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 21:46:14 -0400
From: Bruce Humphrey <brucehum@gmail.com>
To: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        gregkh@linuxfoundation.org
Cc: hsweeten@visionengravers.com, standby24x7@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Bruce Humphrey <brucehum@gmail.com>
Subject: [PATCH 1/2] Staging: Comedi: dyna_pci10xx: Replace printk with dev_info
Date: Thu, 13 Sep 2012 03:46:00 +0200
Message-Id: <1347500760-4394-1-git-send-email-brucehum@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace printk(KERN_XXX with dev_info, dev_warn, dev_dbg as appropiate in dyna_pci10xx

Signed-off-by: Bruce Humphrey Ventura <brucehum@gmail.com>
---
 drivers/staging/comedi/drivers/dyna_pci10xx.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dyna_pci10xx.c b/drivers/staging/comedi/drivers/dyna_pci10xx.c
index 064be9a..bfa62d1 100644
--- a/drivers/staging/comedi/drivers/dyna_pci10xx.c
+++ b/drivers/staging/comedi/drivers/dyna_pci10xx.c
@@ -140,8 +140,7 @@ static int dyna_pci10xx_insn_read_ai(struct comedi_device *dev,
 				goto conv_finish;
 		}
 		data[n] = 0;
-		printk(KERN_DEBUG "comedi: dyna_pci10xx: "
-			"timeout reading analog input\n");
+		dev_dbg(dev->class_dev, "timeout reading analog input\n");
 		continue;
 conv_finish:
 		/* mask the first 4 bits - EOC bits */
@@ -262,8 +261,7 @@ static int dyna_pci10xx_attach(struct comedi_device *dev,
 	int ret;
 
 	if (alloc_private(dev, sizeof(struct dyna_pci10xx_private)) < 0) {
-		printk(KERN_ERR "comedi: dyna_pci10xx: "
-			"failed to allocate memory!\n");
+		dev_err(dev->class_dev, "failed to allocate memory!\n");
 		return -ENOMEM;
 	}
 
@@ -276,14 +274,14 @@ static int dyna_pci10xx_attach(struct comedi_device *dev,
 	dev->irq = 0;
 
 	if (comedi_pci_enable(pcidev, DRV_NAME)) {
-		printk(KERN_ERR "comedi: dyna_pci10xx: "
-			"failed to enable PCI device and request regions!");
+		dev_err(dev->class_dev,
+			"failed to enable PCI device and request regions!\n");
 		return -EIO;
 	}
 
 	mutex_init(&devpriv->mutex);
 
-	printk(KERN_INFO "comedi: dyna_pci10xx: device found!\n");
+	pr_info("comedi: dyna_pci10xx: device found!\n");
 
 	dev->iobase = pci_resource_start(pcidev, 2);
 	devpriv->BADR3 = pci_resource_start(pcidev, 3);
@@ -333,7 +331,7 @@ static int dyna_pci10xx_attach(struct comedi_device *dev,
 	s->state = 0;
 	s->insn_bits = dyna_pci10xx_do_insn_bits;
 
-	printk(KERN_INFO "comedi: dyna_pci10xx: %s - device setup completed!\n",
+	dev_info(dev->class_dev, "%s - device setup completed!\n",
 		thisboard->name);
 
 	return 1;
-- 
1.7.9.5

