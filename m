Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961Ab2ABNKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 08:10:43 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60746 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab2ABNKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 08:10:38 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com, rmallon@gmail.com, joe@perches.com,
        valdis.kletnieks@vt.edu, jj@chaosbits.net,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 3/6] Staging: comedi: fix printk warning issue in contec_pci_dio.c
Date: Mon,  2 Jan 2012 18:39:59 +0530
Message-Id: <1325509801-20036-3-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1325509801-20036-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1325509801-20036-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes useless printk().

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/contec_pci_dio.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/contec_pci_dio.c b/drivers/staging/comedi/drivers/contec_pci_dio.c
index e3659bd..4767717 100644
--- a/drivers/staging/comedi/drivers/contec_pci_dio.c
+++ b/drivers/staging/comedi/drivers/contec_pci_dio.c
@@ -105,8 +105,6 @@ static int contec_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	struct pci_dev *pcidev = NULL;
 	struct comedi_subdevice *s;
 
-	printk("comedi%d: contec: ", dev->minor);
-
 	dev->board_name = thisboard->name;
 
 	if (alloc_private(dev, sizeof(struct contec_private)) < 0)
@@ -132,8 +130,6 @@ static int contec_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 				return -EIO;
 			}
 			dev->iobase = pci_resource_start(pcidev, 0);
-			printk(" base addr %lx ", dev->iobase);
-
 			dev->board_ptr = contec_boards + 0;
 
 			s = dev->subdevices + 0;
@@ -153,20 +149,16 @@ static int contec_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 			s->range_table = &range_digital;
 			s->insn_bits = contec_do_insn_bits;
 
-			printk("attached\n");
 
 			return 1;
 		}
 	}
 
-	printk("card not present!\n");
-
 	return -EIO;
 }
 
 static int contec_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: contec: remove\n", dev->minor);
 
 	if (devpriv && devpriv->pci_dev) {
 		if (dev->iobase)
-- 
1.7.0.4

