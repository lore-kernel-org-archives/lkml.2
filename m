Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab2JOK6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 06:58:13 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63320 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab2JOK6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 06:58:12 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH] staging/comedi: Use dev_ printks in drivers/vmk80xx.c
Date: Mon, 15 Oct 2012 19:58:06 +0900
Message-Id: <1350298686-20770-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <507BD53D.2070407@mev.co.uk>
References: <507BD53D.2070407@mev.co.uk>
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
index df277aa..3df4fcf 100644
--- a/drivers/staging/comedi/drivers/vmk80xx.c
+++ b/drivers/staging/comedi/drivers/vmk80xx.c
@@ -1371,12 +1371,12 @@ static int vmk80xx_usb_probe(struct usb_interface *intf,
 
 	if (dev->board.model == VMK8061_MODEL) {
 		vmk80xx_read_eeprom(dev, IC3_VERSION);
-		printk(KERN_INFO "comedi#: vmk80xx: %s\n", dev->fw.ic3_vers);
+		dev_info(&intf->dev, "vmk80xx: %s\n", dev->fw.ic3_vers);
 
 		if (vmk80xx_check_data_link(dev)) {
 			vmk80xx_read_eeprom(dev, IC6_VERSION);
-			printk(KERN_INFO "comedi#: vmk80xx: %s\n",
-			       dev->fw.ic6_vers);
+			dev_info(&intf->dev, "vmk80xx: %s\n",
+				 dev->fw.ic6_vers);
 		} else {
 			dbgcm("comedi#: vmk80xx: no conn. to CPU\n");
 		}
@@ -1387,8 +1387,8 @@ static int vmk80xx_usb_probe(struct usb_interface *intf,
 
 	dev->probed = 1;
 
-	printk(KERN_INFO "comedi#: vmk80xx: board #%d [%s] now attached\n",
-	       dev->count, dev->board.name);
+	dev_info(&intf->dev, "vmk80xx: board #%d [%s] now attached\n",
+		 dev->count, dev->board.name);
 
 	mutex_unlock(&glb_mutex);
 
@@ -1422,8 +1422,8 @@ static void vmk80xx_usb_disconnect(struct usb_interface *intf)
 	kfree(dev->usb_rx_buf);
 	kfree(dev->usb_tx_buf);
 
-	printk(KERN_INFO "comedi#: vmk80xx: board #%d [%s] now detached\n",
-	       dev->count, dev->board.name);
+	dev_info(&intf->dev, "vmk80xx: board #%d [%s] now detached\n",
+		 dev->count, dev->board.name);
 
 	up(&dev->limit_sem);
 	mutex_unlock(&glb_mutex);
-- 
1.7.9.5

