Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab0C0Btz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 21:49:55 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:64967 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab0C0Btx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 21:49:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HAXRG6qT3vW4E937CNDIeHz2+SVSGpATCF0FTwD3E1gVMoeKjbSvs7VzfYRI5WOPnU
         8mBsGytgxvAL5hZUyhB4qCS0FMlgZt2jWBivlmgDsXompBiE2Gtq/MdzTPGNtJFWLB4a
         SrN7aavVOGsyZLsCOL9VYvHhft9EuQgGQZQ7A=
From: Jason Wong <tsanghan@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Jason Wong <tsanghan@gmail.com>
Subject: [PATCH 6/9] Staging: comedi: adv_pci_dio: fixed multiple brace coding style issue
Date: Sat, 27 Mar 2010 09:48:40 +0800
Message-Id: <1269654523-2682-7-git-send-email-tsanghan@gmail.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <Jason Wong <tsanghan@gmail.com>
References: <Jason Wong <tsanghan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed multiple coding style issue.

Signed-off-by: Jason Wong <tsanghan@gmail.com>
---
 drivers/staging/comedi/drivers/adv_pci_dio.c |   34 +++++++++++++-------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci_dio.c b/drivers/staging/comedi/drivers/adv_pci_dio.c
index 61d35fe..dbfeef8 100644
--- a/drivers/staging/comedi/drivers/adv_pci_dio.c
+++ b/drivers/staging/comedi/drivers/adv_pci_dio.c
@@ -367,9 +367,9 @@ static int pci_dio_insn_bits_di_b(struct comedi_device *dev,
 	int i;
 
 	data[1] = 0;
-	for (i = 0; i < d->regs; i++) {
+	for (i = 0; i < d->regs; i++)
 		data[1] |= inb(dev->iobase + d->addr + i) << (8 * i);
-	}
+
 
 	return 2;
 }
@@ -882,9 +882,9 @@ static int CheckAndAllocCard(struct comedi_device *dev,
 	struct pci_dio_private *pr, *prev;
 
 	for (pr = pci_priv, prev = NULL; pr != NULL; prev = pr, pr = pr->next) {
-		if (pr->pcidev == pcidev) {
+		if (pr->pcidev == pcidev)
 			return 0;	/*  this card is used, look for another */
-		}
+
 	}
 
 	if (prev) {
@@ -1040,22 +1040,22 @@ static int pci_dio_detach(struct comedi_device *dev)
 	int subdev;
 
 	if (dev->private) {
-		if (devpriv->valid) {
+		if (devpriv->valid)
 			pci_dio_reset(dev);
-		}
+
 
 		/* This shows the silliness of using this kind of
 		 * scheme for numbering subdevices.  Don't do it.  --ds */
 		subdev = 0;
 		for (i = 0; i < MAX_DI_SUBDEVS; i++) {
-			if (this_board->sdi[i].chans) {
+			if (this_board->sdi[i].chans)
 				subdev++;
-			}
+
 		}
 		for (i = 0; i < MAX_DO_SUBDEVS; i++) {
-			if (this_board->sdo[i].chans) {
+			if (this_board->sdo[i].chans)
 				subdev++;
-			}
+
 		}
 		for (i = 0; i < MAX_DIO_SUBDEVG; i++) {
 			for (j = 0; j < this_board->sdio[i].regs; j++) {
@@ -1071,20 +1071,20 @@ static int pci_dio_detach(struct comedi_device *dev)
 		}
 
 		if (devpriv->pcidev) {
-			if (dev->iobase) {
+			if (dev->iobase)
 				comedi_pci_disable(devpriv->pcidev);
-			}
+
 			pci_dev_put(devpriv->pcidev);
 		}
 
-		if (devpriv->prev) {
+		if (devpriv->prev)
 			devpriv->prev->next = devpriv->next;
-		} else {
+		else
 			pci_priv = devpriv->next;
-		}
-		if (devpriv->next) {
+
+		if (devpriv->next)
 			devpriv->next->prev = devpriv->prev;
-		}
+
 	}
 
 	return 0;
-- 
1.7.0.3

