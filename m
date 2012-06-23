Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab2FWCwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 22:52:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42579 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230Ab2FWCwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 22:52:04 -0400
From: Daniel Lawrence <daniel@danielscottlawrence.com>
To: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        gregkh@linuxfoundation.org, hsweeten@visionengravers.com
Cc: daniel@danielscottlawrence.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: comedi: fixed printk coding style issue in acl7225b.c
Date: Sat, 23 Jun 2012 12:51:43 +1000
Message-Id: <1340419903-21928-1-git-send-email-daniel@danielscottlawrence.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the acl7225.b file that fixes up 2 printk warnings
found by the checkpatch.pl tool.
As this is a comedi driver the printk's have been changed to the
dev_printk style.

Signed-off-by: Daniel Lawrence <daniel@danielscottlawrence.com>
---
 drivers/staging/comedi/drivers/acl7225b.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/acl7225b.c b/drivers/staging/comedi/drivers/acl7225b.c
index 4e4fc41..ca74519 100644
--- a/drivers/staging/comedi/drivers/acl7225b.c
+++ b/drivers/staging/comedi/drivers/acl7225b.c
@@ -72,11 +72,11 @@ static int acl7225b_attach(struct comedi_device *dev,
 
 	iobase = it->options[0];
 	iorange = this_board->io_range;
-	printk(KERN_INFO "comedi%d: acl7225b: board=%s 0x%04x\n", dev->minor,
+	dev_info(dev->class_dev, "acl7225b: board=%s 0x%04x\n",
 	       this_board->name, iobase);
 	if (!request_region(iobase, iorange, "acl7225b")) {
-		printk(KERN_ERR "comedi%d: request_region failed - I/O port conflict\n",
-			dev->minor);
+		dev_err(dev->class_dev,
+				"request_region failed - I/O port conflict\n");
 		return -EIO;
 	}
 	dev->board_name = this_board->name;
-- 
1.7.9.5

