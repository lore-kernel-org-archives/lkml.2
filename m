Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab2JHM0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 08:26:44 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:54608 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab2JHM0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 08:26:38 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH] staging/comedi: Use dev_ printks in drivers/ii_pci20kc.c
Date: Mon,  8 Oct 2012 21:26:33 +0900
Message-Id: <1349699193-32468-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
- WARNING: Prefer netdev_warn(netdev, ... then dev_warn(dev, ... then pr_warn(...  to printk(KERN_WARNING ...
- WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/comedi/drivers/ii_pci20kc.c |   35 ++++++++++++---------------
 1 file changed, 15 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ii_pci20kc.c b/drivers/staging/comedi/drivers/ii_pci20kc.c
index 65ff1c9..746974b 100644
--- a/drivers/staging/comedi/drivers/ii_pci20kc.c
+++ b/drivers/staging/comedi/drivers/ii_pci20kc.c
@@ -215,13 +215,13 @@ static int pci20xxx_attach(struct comedi_device *dev,
 
 	/* Check PCI-20001 C-2A Carrier Board ID */
 	if ((readb(devpriv->ioaddr) & PCI20000_ID) != PCI20000_ID) {
-		printk(KERN_WARNING "comedi%d: ii_pci20kc PCI-20001"
-		       " C-2A Carrier Board at base=0x%p not found !\n",
-		       dev->minor, devpriv->ioaddr);
+		dev_warn(dev->class_dev,
+			 "PCI-20001 C-2A Carrier Board at base=0x%p not found !\n",
+			 devpriv->ioaddr);
 		return -EINVAL;
 	}
-	printk(KERN_INFO "comedi%d: ii_pci20kc: PCI-20001 C-2A at base=0x%p\n",
-	       dev->minor, devpriv->ioaddr);
+	dev_info(dev->class_dev, "PCI-20001 C-2A at base=0x%p\n",
+		 devpriv->ioaddr);
 
 	for (i = 0; i < PCI20000_MODULES; i++) {
 		s = &dev->subdevices[i];
@@ -234,23 +234,21 @@ static int pci20xxx_attach(struct comedi_device *dev,
 			    devpriv->ioaddr + (i + 1) * PCI20000_OFFSET;
 			pci20006_init(dev, s, it->options[2 * i + 2],
 				      it->options[2 * i + 3]);
-			printk(KERN_INFO "comedi%d: "
-			       "ii_pci20kc PCI-20006 module in slot %d\n",
-			       dev->minor, i + 1);
+			dev_info(dev->class_dev,
+				 "PCI-20006 module in slot %d\n", i + 1);
 			break;
 		case PCI20341_ID:
 			sdp->pci20341.iobase =
 			    devpriv->ioaddr + (i + 1) * PCI20000_OFFSET;
 			pci20341_init(dev, s, it->options[2 * i + 2],
 				      it->options[2 * i + 3]);
-			printk(KERN_INFO "comedi%d: "
-			       "ii_pci20kc PCI-20341 module in slot %d\n",
-			       dev->minor, i + 1);
+			dev_info(dev->class_dev,
+				 "PCI-20341 module in slot %d\n", i + 1);
 			break;
 		default:
-			printk(KERN_WARNING "ii_pci20kc: unknown module "
-			       "code 0x%02x in slot %d: module disabled\n",
-			       id, i); /* XXX this looks like a bug! i + 1 ?? */
+			dev_warn(dev->class_dev,
+				 "unknown module code 0x%02x in slot %d: module disabled\n",
+				 id, i); /* XXX this looks like a bug! i + 1 ?? */
 			/* fall through */
 		case PCI20xxx_EMPTY_ID:
 			s->type = COMEDI_SUBD_UNUSED;
@@ -346,8 +344,7 @@ static int pci20006_insn_write(struct comedi_device *dev,
 		writeb(0x00, sdp->iobase + PCI20006_STROBE1);
 		break;
 	default:
-		printk(KERN_WARNING
-		       " comedi%d: pci20xxx: ao channel Error!\n", dev->minor);
+		dev_warn(dev->class_dev, "ao channel Error!\n");
 		return -EINVAL;
 	}
 
@@ -462,10 +459,8 @@ static int pci20341_insn_read(struct comedi_device *dev,
 			eoc = readb(sdp->iobase + PCI20341_STATUS_REG);
 		}
 		if (j >= 100) {
-			printk(KERN_WARNING
-			       "comedi%d:  pci20xxx: "
-			       "AI interrupt channel %i polling exit !\n",
-			       dev->minor, i);
+			dev_warn(dev->class_dev,
+				 "AI interrupt channel %i polling exit !\n", i);
 			return -EINVAL;
 		}
 		lo = readb(sdp->iobase + PCI20341_LDATA);
-- 
1.7.9.5

