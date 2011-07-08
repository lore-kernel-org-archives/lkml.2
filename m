Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab1GHHc1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 03:32:27 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64007 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245Ab1GHHc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 03:32:26 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankr <ravishakarkm32@gmail.com>
Subject: [PATCH 4/4] Staging: comedi: fix printk issue in rtd520.c
Date: Fri,  8 Jul 2011 13:14:45 +0530
Message-Id: <1310111085-28284-1-git-send-email-ravi.shankar@greenturtles.in>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH]Staging: comedi: fix printk warning issues in rtd520.c>
References: <[PATCH]Staging: comedi: fix printk warning issues in rtd520.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the rtd520.c file that fixes up a printk  warning found by the checkpatch.pl tool

Signed-off-by: Ravishankr <ravishakarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/rtd520.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 7f09ed7..f7f4752 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -29,8 +29,8 @@ Status: Works.  Only tested on DM7520-8.  Not SMP safe.
 
 Configuration options:
   [0] - PCI bus of device (optional)
-          If bus/slot is not specified, the first available PCI
-          device will be used.
+	If bus / slot is not specified, the first available PCI
+	device will be used.
   [1] - PCI slot of device (optional)
 */
 /*
@@ -186,7 +186,7 @@ Configuration options:
 		       | PLX_DEMAND_MODE_BIT)
 
 #define DMA_TRANSFER_BITS (\
-/* descriptors in PCI memory*/ 	PLX_DESC_IN_PCI_BIT \
+/* descriptors in PCI memory*/  PLX_DESC_IN_PCI_BIT \
 /* interrupt at end of block */ | PLX_INTR_TERM_COUNT \
 /* from board to PCI */		| PLX_XFER_LOCAL_TO_PCI)
 
@@ -869,7 +869,7 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	}
 
 	/* Show board configuration */
-	printk("%s:", dev->board_name);
+	printk(KERN_INFO "%s:", dev->board_name);
 
 	/*
 	 * Allocate the subdevice structures.  alloc_subdevice() is a
@@ -958,7 +958,7 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		return ret;
 	}
 	dev->irq = devpriv->pci_dev->irq;
-	printk("( irq=%u )", dev->irq);
+	printk(KERN_INFO "( irq=%u )", dev->irq);
 
 	ret = rtd520_probe_fifo_depth(dev);
 	if (ret < 0)
-- 
1.6.5.2

