Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab1EINwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 09:52:20 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60920 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab1EINwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 09:52:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=BnaVr68ctExo71JhiCa5EYyvo+dCp4gODcoOX7SFZOfp/e2K3jXcHXJ3O/Xx4SzdRh
         4G/RJlHJUMRXGN+hbKhlZ4qnW90q3r81t7MDM90yMwQwV55eEeN3BnUlI4oky0o5r4nE
         BraBDED2goSmeQtXl/fd7a+o6fP31o6Nd07GM=
From: Stephane Pajot <pajot.stephane@gmail.com>
To: gregkh@suse.de, arun.thomas@gmail.com, ruben.smits@mech.kuleuven.be,
        abbotti@mev.co.uk, ext-andriy.shevchenko@nokia.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Stephane Pajot <pajot.stephane@gmail.com>
Subject: [PATCH] Staging: comedi: fix brace coding style issue in jr3_pci.c This is a patch to the jr3_pci.c file that fixes up a brace warning found by the checkpatch.pl tool Signed-off-by: Stephane Pajot <pajot.stephane@gmail.com>
Date: Mon,  9 May 2011 15:51:59 +0200
Message-Id: <1304949119-8250-1-git-send-email-pajot.stephane@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/comedi/drivers/jr3_pci.c |   27 +++++++++------------------
 1 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/comedi/drivers/jr3_pci.c b/drivers/staging/comedi/drivers/jr3_pci.c
index 5c6c727..d96140c 100644
--- a/drivers/staging/comedi/drivers/jr3_pci.c
+++ b/drivers/staging/comedi/drivers/jr3_pci.c
@@ -193,9 +193,8 @@ static void set_transforms(volatile struct jr3_channel *channel,
 		set_s16(&channel->transforms[num].link[i].link_amount,
 			transf.link[i].link_amount);
 		udelay(1);
-		if (transf.link[i].link_type == end_x_form) {
+		if (transf.link[i].link_type == end_x_form)
 			break;
-		}
 	}
 }
 
@@ -460,9 +459,8 @@ static int jr3_download_firmware(struct comedi_device *dev, const u8 * data,
 				unsigned int count, addr;
 				more = more
 				    && read_idm_word(data, size, &pos, &count);
-				if (more && count == 0xffff) {
+				if (more && count == 0xffff)
 					break;
-				}
 				more = more
 				    && read_idm_word(data, size, &pos, &addr);
 				printk("Loading#%d %4.4x bytes at %4.4x\n", i,
@@ -793,9 +791,8 @@ static int jr3_pci_attach(struct comedi_device *dev,
 	}
 
 	result = alloc_private(dev, sizeof(struct jr3_pci_dev_private));
-	if (result < 0) {
+	if (result < 0)
 		return -ENOMEM;
-	}
 	card = NULL;
 	devpriv = dev->private;
 	init_timer(&devpriv->timer);
@@ -851,9 +848,8 @@ static int jr3_pci_attach(struct comedi_device *dev,
 	}
 
 	result = comedi_pci_enable(card, "jr3_pci");
-	if (result < 0) {
+	if (result < 0)
 		return -EIO;
-	}
 
 	devpriv->pci_enabled = 1;
 	devpriv->iobase = ioremap(pci_resource_start(card, 0),
@@ -922,9 +918,8 @@ static int jr3_pci_attach(struct comedi_device *dev,
 	result = comedi_load_firmware(dev, "jr3pci.idm", jr3_download_firmware);
 	printk("Firmare load %d\n", result);
 
-	if (result < 0) {
+	if (result < 0)
 		goto out;
-	}
 /*
  * TODO: use firmware to load preferred offset tables. Suggested
  * format:
@@ -973,21 +968,17 @@ static int jr3_pci_detach(struct comedi_device *dev)
 		del_timer_sync(&devpriv->timer);
 
 		if (dev->subdevices) {
-			for (i = 0; i < devpriv->n_channels; i++) {
+			for (i = 0; i < devpriv->n_channels; i++)
 				kfree(dev->subdevices[i].private);
-			}
 		}
 
-		if (devpriv->iobase) {
+		if (devpriv->iobase)
 			iounmap((void *)devpriv->iobase);
-		}
-		if (devpriv->pci_enabled) {
+		if (devpriv->pci_enabled)
 			comedi_pci_disable(devpriv->pci_dev);
-		}
 
-		if (devpriv->pci_dev) {
+		if (devpriv->pci_dev)
 			pci_dev_put(devpriv->pci_dev);
-		}
 	}
 	return 0;
 }
-- 
1.7.1

