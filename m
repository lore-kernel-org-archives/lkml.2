Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab2JINHi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 09:07:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52364 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab2JINHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 09:07:35 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH] staging/comedi: Use pr_ or dev_ printks in drivers/dt9812.c
Date: Tue,  9 Oct 2012 22:07:27 +0900
Message-Id: <1349788047-5775-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
- WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
- WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...

and added pr_fmt.

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/comedi/drivers/dt9812.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dt9812.c b/drivers/staging/comedi/drivers/dt9812.c
index bc6f409..dd707c9 100644
--- a/drivers/staging/comedi/drivers/dt9812.c
+++ b/drivers/staging/comedi/drivers/dt9812.c
@@ -43,6 +43,8 @@ for my needs.
  *      says P1).
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/init.h>
@@ -1077,8 +1079,7 @@ static int dt9812_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->insn_write = &dt9812_ao_winsn;
 	s->insn_read = &dt9812_ao_rinsn;
 
-	printk(KERN_INFO "comedi%d: successfully attached to dt9812.\n",
-	       dev->minor);
+	dev_info(dev->class_dev, "successfully attached to dt9812.\n");
 
 	down(&dt9812_mutex);
 	/* Find a slot for the comedi device */
@@ -1140,17 +1141,15 @@ static int __init usb_dt9812_init(void)
 	/* register with the USB subsystem */
 	result = usb_register(&dt9812_usb_driver);
 	if (result) {
-		printk(KERN_ERR KBUILD_MODNAME
-		       ": usb_register failed. Error number %d\n", result);
+		pr_err("usb_register failed. Error number %d\n", result);
 		return result;
 	}
 	/* register with comedi */
 	result = comedi_driver_register(&dt9812_comedi_driver);
 	if (result) {
 		usb_deregister(&dt9812_usb_driver);
-		printk(KERN_ERR KBUILD_MODNAME
-			": comedi_driver_register failed. Error number %d\n",
-			result);
+		pr_err("comedi_driver_register failed. Error number %d\n",
+		       result);
 	}
 
 	return result;
-- 
1.7.9.5

