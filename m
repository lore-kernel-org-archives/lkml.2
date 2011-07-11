Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249Ab1GKHUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 03:20:36 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63848 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757158Ab1GKHUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 03:20:35 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 9/9] Staging: comedi: fix printk issue in pcl818.c
Date: Mon, 11 Jul 2011 13:03:05 +0530
Message-Id: <1310369585-26899-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH 8/8]Staging: comedi: fix printk issue in pcl818.c>
References: <[PATCH 8/8]Staging: comedi: fix printk issue in pcl818.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the pcl818.c file that fixes up a printk() warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/pcl818.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index 21f1cc9..2fdb8c9 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -1534,7 +1534,7 @@ static int pcl818_ai_cancel(struct comedi_device *dev,
 	}
 
 end:
-	printk("pcl818_ai_cancel() end\n");
+	printk(KERN_INFO "pcl818_ai_cancel() end\n");
 	return 0;
 }
 
@@ -1738,7 +1738,7 @@ static int pcl818_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	/* claim our I/O space */
 	iobase = it->options[0];
-	printk("comedi%d: pcl818:  board=%s, ioport=0x%03lx",
+	printk(KERN_INFO "comedi%d: pcl818:  board=%s, ioport=0x%03lx",
 	       dev->minor, this_board->name, iobase);
 	devpriv->io_range = this_board->io_range;
 	if ((this_board->fifo) && (it->options[2] == -1)) {	/*  we've board with FIFO and we want to use FIFO */
@@ -1753,7 +1753,7 @@ static int pcl818_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	dev->iobase = iobase;
 
 	if (pcl818_check(iobase)) {
-		printk(", I can't detect board. FAIL!\n");
+		printk(KERN_ERR ", I can't detect board. FAIL!\n");
 		return -EIO;
 	}
 
-- 
1.6.5.2

