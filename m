Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab2JHMZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 08:25:46 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38947 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab2JHMZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 08:25:43 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH] staging/comedi: Use dev_ printks in drivers/usbdux.c
Date: Mon,  8 Oct 2012 21:25:37 +0900
Message-Id: <1349699137-32366-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warning.
- WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/comedi/drivers/usbdux.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index b536bba..e89f4e2 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -2386,14 +2386,12 @@ static int usbdux_attach_usb(struct comedi_device *dev,
 	down(&start_stop_sem);
 	this_usbduxsub = usb_get_intfdata(uinterf);
 	if (!this_usbduxsub || !this_usbduxsub->probed) {
-		printk(KERN_ERR
-		       "comedi%d: usbdux: error: attach_usb failed, not connected\n",
-		       dev->minor);
+		dev_err(dev->class_dev,
+			"usbdux: error: attach_usb failed, not connected\n");
 		ret = -ENODEV;
 	} else if (this_usbduxsub->attached) {
-		printk(KERN_ERR
-		       "comedi%d: usbdux: error: attach_usb failed, already attached\n",
-		       dev->minor);
+		dev_err(dev->class_dev,
+			"error: attach_usb failed, already attached\n");
 		ret = -ENODEV;
 	} else
 		ret = usbdux_attach_common(dev, this_usbduxsub);
-- 
1.7.9.5

