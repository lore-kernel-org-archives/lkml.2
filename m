Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab2KHTyB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 14:54:01 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38724 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab2KHTx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 14:53:59 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <ben@decadent.org.uk>, Sean Young <sean@mess.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH] staging/media: Use dev_ printks in lirc/igorplugusb.c
Date: Fri,  9 Nov 2012 04:53:53 +0900
Message-Id: <1352404433-7632-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
- WARNING: Prefer netdev_warn(netdev, ... then dev_warn(dev, ... then pr_warn(...  to printk(KERN_WARNING ...
- WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/media/lirc/lirc_igorplugusb.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_igorplugusb.c b/drivers/staging/media/lirc/lirc_igorplugusb.c
index 939a801..2faa391 100644
--- a/drivers/staging/media/lirc/lirc_igorplugusb.c
+++ b/drivers/staging/media/lirc/lirc_igorplugusb.c
@@ -223,8 +223,8 @@ static int unregister_from_lirc(struct igorplug *ir)
 	int devnum;
 
 	if (!ir) {
-		printk(KERN_ERR "%s: called with NULL device struct!\n",
-		       __func__);
+		dev_err(&ir->usbdev->dev,
+			"%s: called with NULL device struct!\n", __func__);
 		return -EINVAL;
 	}
 
@@ -232,8 +232,8 @@ static int unregister_from_lirc(struct igorplug *ir)
 	d = ir->d;
 
 	if (!d) {
-		printk(KERN_ERR "%s: called with NULL lirc driver struct!\n",
-		       __func__);
+		dev_err(&ir->usbdev->dev,
+			"%s: called with NULL lirc driver struct!\n", __func__);
 		return -EINVAL;
 	}
 
@@ -347,8 +347,8 @@ static int igorplugusb_remote_poll(void *data, struct lirc_buffer *buf)
 		if (ir->buf_in[2] == 0)
 			send_fragment(ir, buf, DEVICE_HEADERLEN, ret);
 		else {
-			printk(KERN_WARNING DRIVER_NAME
-			       "[%d]: Device buffer overrun.\n", ir->devnum);
+			dev_warn(&ir->usbdev->dev,
+				 "[%d]: Device buffer overrun.\n", ir->devnum);
 			/* HHHNNNNNNNNNNNOOOOOOOO H = header
 			      <---[2]--->         N = newer
 			   <---------ret--------> O = older */
-- 
1.7.9.5

