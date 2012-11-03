Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab2KCNiM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 09:38:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51380 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab2KCNiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 09:38:10 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH] staging/comedi: Use dev_ printks in drivers/adl_pci9118.c
Date: Sat,  3 Nov 2012 22:38:03 +0900
Message-Id: <1351949883-16164-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
- WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/comedi/drivers/adl_pci9118.c |   31 ++++++++++++++------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index a5d0be2..e9d45c2 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -1888,7 +1888,7 @@ static struct pci_dev *pci9118_find_pci(struct comedi_device *dev,
 		 */
 		if (comedi_pci_enable(pcidev, "adl_pci9118"))
 			continue;
-		printk(KERN_ERR ", b:s:f=%d:%d:%d, io=0x%4lx, 0x%4lx",
+		dev_err(dev->class_dev, ", b:s:f=%d:%d:%d, io=0x%4lx, 0x%4lx",
 			pcidev->bus->number,
 			PCI_SLOT(pcidev->devfn),
 			PCI_FUNC(pcidev->devfn),
@@ -1896,9 +1896,9 @@ static struct pci_dev *pci9118_find_pci(struct comedi_device *dev,
 			(unsigned long)pci_resource_start(pcidev, 0));
 		return pcidev;
 	}
-	printk(KERN_ERR
-		"comedi%d: no supported board found! (req. bus/slot : %d/%d)\n",
-		dev->minor, bus, slot);
+	dev_err(dev->class_dev,
+		"no supported board found! (req. bus/slot : %d/%d)\n",
+		bus, slot);
 	return NULL;
 }
 
@@ -1914,7 +1914,7 @@ static int pci9118_attach(struct comedi_device *dev,
 	unsigned int irq;
 	u16 u16w;
 
-	printk("comedi%d: adl_pci9118: board=%s", dev->minor, this_board->name);
+	dev_dbg(dev->class_dev, "board=%s", this_board->name);
 
 	if (it->options[3] & 1)
 		master = 0;	/* user don't want use bus master */
@@ -1947,14 +1947,15 @@ static int pci9118_attach(struct comedi_device *dev,
 	if (irq > 0) {
 		if (request_irq(irq, interrupt_pci9118, IRQF_SHARED,
 				"ADLink PCI-9118", dev)) {
-			printk(", unable to allocate IRQ %d, DISABLING IT",
-			       irq);
+			dev_dbg(dev->class_dev,
+				", unable to allocate IRQ %d, DISABLING IT",
+				irq);
 			irq = 0;	/* Can't use IRQ */
 		} else {
-			printk(", irq=%u", irq);
+			dev_dbg(dev->class_dev, ", irq=%u", irq);
 		}
 	} else {
-		printk(", IRQ disabled");
+		dev_dbg(dev->class_dev, ", IRQ disabled");
 	}
 
 	dev->irq = irq;
@@ -1980,7 +1981,8 @@ static int pci9118_attach(struct comedi_device *dev,
 			}
 		}
 		if (!devpriv->dmabuf_virt[0]) {
-			printk(", Can't allocate DMA buffer, DMA disabled!");
+			dev_dbg(dev->class_dev,
+				", Can't allocate DMA buffer, DMA disabled!");
 			master = 0;
 		}
 
@@ -1991,9 +1993,9 @@ static int pci9118_attach(struct comedi_device *dev,
 
 	devpriv->master = master;
 	if (devpriv->master)
-		printk(", bus master");
+		dev_dbg(dev->class_dev, ", bus master");
 	else
-		printk(", no bus master");
+		dev_dbg(dev->class_dev, ", no bus master");
 
 	devpriv->usemux = 0;
 	if (it->options[2] > 0) {
@@ -2005,7 +2007,8 @@ static int pci9118_attach(struct comedi_device *dev,
 				devpriv->usemux = 128;
 					/* max 128 channels with softare S&H! */
 			}
-		printk(", ext. mux %d channels", devpriv->usemux);
+		dev_dbg(dev->class_dev,
+			", ext. mux %d channels", devpriv->usemux);
 	}
 
 	devpriv->softsshdelay = it->options[4];
@@ -2019,7 +2022,7 @@ static int pci9118_attach(struct comedi_device *dev,
 		devpriv->softsshhold = 0x80;
 	}
 
-	printk(".\n");
+	dev_dbg(dev->class_dev, ".\n");
 
 	pci_read_config_word(pcidev, PCI_COMMAND, &u16w);
 	pci_write_config_word(pcidev, PCI_COMMAND, u16w | 64);
-- 
1.7.9.5

