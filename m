Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab2JXFWD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 01:22:03 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38943 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab2JXFWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 01:22:01 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH v2] staging/comedi: Use dev_ printks in drivers/vmk80xx.c
Date: Wed, 24 Oct 2012 14:21:51 +0900
Message-Id: <1351056111-11851-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20121022194537.GB30479@kroah.com>
References: <20121022194537.GB30479@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warning.
- Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/comedi/drivers/vmk80xx.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/vmk80xx.c b/drivers/staging/comedi/drivers/vmk80xx.c
index df277aa..3664907 100644
--- a/drivers/staging/comedi/drivers/vmk80xx.c
+++ b/drivers/staging/comedi/drivers/vmk80xx.c
@@ -1371,12 +1371,11 @@ static int vmk80xx_usb_probe(struct usb_interface *intf,
 
 	if (dev->board.model == VMK8061_MODEL) {
 		vmk80xx_read_eeprom(dev, IC3_VERSION);
-		printk(KERN_INFO "comedi#: vmk80xx: %s\n", dev->fw.ic3_vers);
+		dev_info(&intf->dev, "%s\n", dev->fw.ic3_vers);
 
 		if (vmk80xx_check_data_link(dev)) {
 			vmk80xx_read_eeprom(dev, IC6_VERSION);
-			printk(KERN_INFO "comedi#: vmk80xx: %s\n",
-			       dev->fw.ic6_vers);
+			dev_info(&intf->dev, "%s\n", dev->fw.ic6_vers);
 		} else {
 			dbgcm("comedi#: vmk80xx: no conn. to CPU\n");
 		}
@@ -1387,8 +1386,8 @@ static int vmk80xx_usb_probe(struct usb_interface *intf,
 
 	dev->probed = 1;
 
-	printk(KERN_INFO "comedi#: vmk80xx: board #%d [%s] now attached\n",
-	       dev->count, dev->board.name);
+	dev_info(&intf->dev, "board #%d [%s] now attached\n",
+		 dev->count, dev->board.name);
 
 	mutex_unlock(&glb_mutex);
 
@@ -1422,8 +1421,8 @@ static void vmk80xx_usb_disconnect(struct usb_interface *intf)
 	kfree(dev->usb_rx_buf);
 	kfree(dev->usb_tx_buf);
 
-	printk(KERN_INFO "comedi#: vmk80xx: board #%d [%s] now detached\n",
-	       dev->count, dev->board.name);
+	dev_info(&intf->dev, "board #%d [%s] now detached\n",
+		 dev->count, dev->board.name);
 
 	up(&dev->limit_sem);
 	mutex_unlock(&glb_mutex);
-- 
1.7.9.5

