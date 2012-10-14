Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab2JNNlE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 09:41:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58496 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab2JNNlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 09:41:02 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH] staging/comedi: Use dev_ printks in drivers/vmk80xx.c
Date: Sun, 14 Oct 2012 22:40:55 +0900
Message-Id: <1350222055-7666-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warning.
- Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/comedi/drivers/vmk80xx.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/vmk80xx.c b/drivers/staging/comedi/drivers/vmk80xx.c
index df277aa..3e77d40 100644
--- a/drivers/staging/comedi/drivers/vmk80xx.c
+++ b/drivers/staging/comedi/drivers/vmk80xx.c
@@ -1371,12 +1371,12 @@ static int vmk80xx_usb_probe(struct usb_interface *intf,
 
 	if (dev->board.model == VMK8061_MODEL) {
 		vmk80xx_read_eeprom(dev, IC3_VERSION);
-		printk(KERN_INFO "comedi#: vmk80xx: %s\n", dev->fw.ic3_vers);
+		dev_info(&intf->dev, "%s: %s\n", __FILE__, dev->fw.ic3_vers);
 
 		if (vmk80xx_check_data_link(dev)) {
 			vmk80xx_read_eeprom(dev, IC6_VERSION);
-			printk(KERN_INFO "comedi#: vmk80xx: %s\n",
-			       dev->fw.ic6_vers);
+			dev_info(&intf->dev, "%s: %s\n",
+				 __FILE__, dev->fw.ic6_vers);
 		} else {
 			dbgcm("comedi#: vmk80xx: no conn. to CPU\n");
 		}
@@ -1387,8 +1387,8 @@ static int vmk80xx_usb_probe(struct usb_interface *intf,
 
 	dev->probed = 1;
 
-	printk(KERN_INFO "comedi#: vmk80xx: board #%d [%s] now attached\n",
-	       dev->count, dev->board.name);
+	dev_info(&intf->dev, "%s: board #%d [%s] now attached\n",
+		 __FILE__, dev->count, dev->board.name);
 
 	mutex_unlock(&glb_mutex);
 
@@ -1422,8 +1422,8 @@ static void vmk80xx_usb_disconnect(struct usb_interface *intf)
 	kfree(dev->usb_rx_buf);
 	kfree(dev->usb_tx_buf);
 
-	printk(KERN_INFO "comedi#: vmk80xx: board #%d [%s] now detached\n",
-	       dev->count, dev->board.name);
+	dev_info(&intf->dev, "%s: board #%d [%s] now detached\n",
+		 __FILE__, dev->count, dev->board.name);
 
 	up(&dev->limit_sem);
 	mutex_unlock(&glb_mutex);
-- 
1.7.9.5

