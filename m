Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab1LLFU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 00:20:59 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59165 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab1LLFU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 00:20:56 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 12/29] Staging: comedi: fix printk issue in jr3_pci.c
Date: Mon, 12 Dec 2011 10:49:24 +0530
Message-Id: <1323667181-17252-12-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the jr3_pci.c file that fixes up a
printk warning found by the checkpatch.pl tool.

Converted printks to dev_dbg().

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/jr3_pci.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/jr3_pci.c b/drivers/staging/comedi/drivers/jr3_pci.c
index 56f7e26..2d3d1b2 100644
--- a/drivers/staging/comedi/drivers/jr3_pci.c
+++ b/drivers/staging/comedi/drivers/jr3_pci.c
@@ -372,14 +372,14 @@ static int jr3_pci_open(struct comedi_device *dev)
 	int i;
 	struct jr3_pci_dev_private *devpriv = dev->private;
 
-	printk("jr3_pci_open\n");
+	dev_dbg(dev->hw_dev, "jr3_pci_open\n");
 	for (i = 0; i < devpriv->n_channels; i++) {
 		struct jr3_pci_subdev_private *p;
 
 		p = dev->subdevices[i].private;
 		if (p) {
-			printk("serial: %p %d (%d)\n", p, p->serial_no,
-			       p->channel_no);
+			dev_dbg(dev->hw_dev, "serial: %p %d (%d)\n", p,
+				p->serial_no, p->channel_no);
 		}
 	}
 	return 0;
@@ -457,8 +457,8 @@ static int jr3_download_firmware(struct comedi_device *dev, const u8 * data,
 					break;
 				more = more
 				    && read_idm_word(data, size, &pos, &addr);
-				printk("Loading#%d %4.4x bytes at %4.4x\n", i,
-				       count, addr);
+				dev_dbg(dev->hw_dev, "Loading#%d %4.4x bytes at %4.4x\n",
+					i, count, addr);
 				while (more && count > 0) {
 					if (addr & 0x4000) {
 						/*  16 bit data, never seen in real life!! */
-- 
1.7.0.4

