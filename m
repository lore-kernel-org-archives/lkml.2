Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab2F0BCJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 21:02:09 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:5427 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab2F0BCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 21:02:08 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-209.messagelabs.com!1340758911!7009530!8
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 22/36] staging: comedi: cb_pcidas: move the "find pci" dev_printk messages
Date: Tue, 26 Jun 2012 18:01:51 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206261801.51354.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the dev_printk messages associated with the "find pci device"
from the *attach function into the *find_pci_device function.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidas.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index a2901bb..9f883dd 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -1537,10 +1537,15 @@ static struct pci_dev *cb_pcidas_find_pci_device(struct comedi_device *dev,
 					continue;
 				}
 			}
+			dev_dbg(dev->class_dev,
+				"Found %s on bus %i, slot %i\n",
+				thisboard->name,
+				pcidev->bus->number, PCI_SLOT(pcidev->devfn));
 			dev->board_ptr = thisboard;
 			return pcidev;
 		}
 	}
+	dev_err(dev->class_dev, "No supported card found\n");
 	return NULL;
 }
 
@@ -1558,15 +1563,9 @@ static int cb_pcidas_attach(struct comedi_device *dev,
 	devpriv = dev->private;
 
 	devpriv->pci_dev = cb_pcidas_find_pci_device(dev, it);
-	if (!devpriv->pci_dev) {
-		dev_err(dev->class_dev, "No supported card found\n");
+	if (!devpriv->pci_dev)
 		return -EIO;
-	}
-
 	thisboard = comedi_board(dev);
-	dev_dbg(dev->class_dev, "Found %s on bus %i, slot %i\n",
-		thisboard->name, devpriv->pci_dev->bus->number,
-		PCI_SLOT(devpriv->pci_dev->devfn));
 
 	if (comedi_pci_enable(devpriv->pci_dev, "cb_pcidas")) {
 		dev_err(dev->class_dev,
-- 
1.7.11

