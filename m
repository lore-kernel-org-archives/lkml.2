Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751071Ab0CSOUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 10:20:35 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:51794 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab0CSOUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 10:20:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=CPbZHVJaC2gQpY9izkWvbUbfN7l4lRrm6l8ucWN11Mo1RArKpdzYPkSqfZTGCCWYKh
         Ayhh6R7KCxyg6dK4V9IDkovILohhtXYnu8tfFEHy6/aC2PFYy3yaCBS8Vm6WgQpAVjt5
         xoMaQ/phQuHduNydJkBeUWJFWBtyjxzOHI5SE=
From: Maurice Dawson <mauricedawson2699@googlemail.com>
To: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 20/20] Staging: comedi: fix KERN_facility level coding style issue in adl_pci9118.c
Date: Fri, 19 Mar 2010 14:20:10 +0000
Message-Id: <1269008410-3556-1-git-send-email-mauricedawson2699@googlemail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the adl_pci9118.c file that fixes WARNING: printk() should include KERN_facility level found by the checkpatch.pl tool

Signed-off-by: Maurice Dawson <mauricedawson2699@googlemail.com>
---
 drivers/staging/comedi/drivers/adl_pci9118.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index 066695a..38d8d5a 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -747,9 +747,8 @@ static void interrupt_pci9118_ai_dma(struct comedi_device *dev,
 		comedi_event(dev, s);
 		return;
 	}
-
 	if (int_adstat & devpriv->ai_maskerr)
-/* if (int_adstat & 0x106) */
+					/* if (int_adstat & 0x106) */
 		if (pci9118_decode_error_status(dev, s, int_adstat))
 			return;
 
@@ -2210,10 +2209,10 @@ static int pci9118_attach(struct comedi_device *dev,
 
 	if (!pcidev) {
 		if (opt_bus || opt_slot) {
-			printk(" - Card at b:s %d:%d %s\n",
+			printk(KERN_ERR " - Card at b:s %d:%d %s\n",
 			       opt_bus, opt_slot, errstr);
 		} else {
-			printk(" - Card %s\n", errstr);
+			printk(KERN_ERR " - Card %s\n", errstr);
 		}
 		return -EIO;
 	}
@@ -2228,8 +2227,8 @@ static int pci9118_attach(struct comedi_device *dev,
 	iobase_a = pci_resource_start(pcidev, 0);
 	iobase_9 = pci_resource_start(pcidev, 2);
 
-	printk(", b:s:f=%d:%d:%d, io=0x%4lx, 0x%4lx", pci_bus, pci_slot,
-	       pci_func, iobase_9, iobase_a);
+	printk(KERN_ERR ", b:s:f=%d:%d:%d, io=0x%4lx, 0x%4lx", pci_bus,
+				pci_slot, pci_func, iobase_9, iobase_a);
 
 	dev->iobase = iobase_9;
 	dev->board_name = this_board->name;
-- 
1.6.3.3

