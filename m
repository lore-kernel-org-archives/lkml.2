Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab2F2B3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 21:29:15 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48300 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036Ab2F2B3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 21:29:14 -0400
From: Sebastian Benvenuti <sebastianbenvenuti@gmail.com>
To: abbotti@mev.co.uk
Cc: fmhess@users.sourceforge.net, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org,
        Sebastian Benvenuti <sebastianbenvenuti@gmail.com>
Subject: [PATCH] Staging: comedi: vmk80xx: All syntax issues fixed
Date: Thu, 28 Jun 2012 22:28:57 -0300
Message-Id: <1340933337-2752-1-git-send-email-sebastianbenvenuti@gmail.com>
X-Mailer: git-send-email 1.7.11.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed "printk(KERN_INFO" to "pr_info("
and "printk(KERN_DEBUG" to "pr_debug("
Fixed a "quoted string split across lines" issue
no warnings after that

Signed-off-by: Sebastian Benvenuti <sebastianbenvenuti@gmail.com>
---
 drivers/staging/comedi/drivers/vmk80xx.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/vmk80xx.c b/drivers/staging/comedi/drivers/vmk80xx.c
index baee8d7..4b4b183 100644
--- a/drivers/staging/comedi/drivers/vmk80xx.c
+++ b/drivers/staging/comedi/drivers/vmk80xx.c
@@ -160,7 +160,7 @@ static int dbgcm;
 #define dbgcm(fmt, arg...)                     \
 do {                                           \
 	if (dbgcm)                             \
-		printk(KERN_DEBUG fmt, ##arg); \
+		pr_debug(fmt, ##arg); \
 } while (0)
 
 enum vmk80xx_model {
@@ -1240,8 +1240,7 @@ static int vmk80xx_attach(struct comedi_device *cdev,
 
 	minor = cdev->minor;
 
-	printk(KERN_INFO
-	       "comedi%d: vmk80xx: board #%d [%s] attached to comedi\n",
+	pr_info("comedi%d: vmk80xx: board #%d [%s] attached to comedi\n",
 	       minor, dev->count, dev->board.name);
 
 	up(&dev->limit_sem);
@@ -1384,11 +1383,11 @@ static int vmk80xx_probe(struct usb_interface *intf,
 
 	if (dev->board.model == VMK8061_MODEL) {
 		vmk80xx_read_eeprom(dev, IC3_VERSION);
-		printk(KERN_INFO "comedi#: vmk80xx: %s\n", dev->fw.ic3_vers);
+		pr_info("comedi#: vmk80xx: %s\n", dev->fw.ic3_vers);
 
 		if (vmk80xx_check_data_link(dev)) {
 			vmk80xx_read_eeprom(dev, IC6_VERSION);
-			printk(KERN_INFO "comedi#: vmk80xx: %s\n",
+			pr_info("comedi#: vmk80xx: %s\n",
 			       dev->fw.ic6_vers);
 		} else {
 			dbgcm("comedi#: vmk80xx: no conn. to CPU\n");
@@ -1400,7 +1399,7 @@ static int vmk80xx_probe(struct usb_interface *intf,
 
 	dev->probed = 1;
 
-	printk(KERN_INFO "comedi#: vmk80xx: board #%d [%s] now attached\n",
+	pr_info("comedi#: vmk80xx: board #%d [%s] now attached\n",
 	       dev->count, dev->board.name);
 
 	mutex_unlock(&glb_mutex);
@@ -1435,7 +1434,7 @@ static void vmk80xx_disconnect(struct usb_interface *intf)
 	kfree(dev->usb_rx_buf);
 	kfree(dev->usb_tx_buf);
 
-	printk(KERN_INFO "comedi#: vmk80xx: board #%d [%s] now detached\n",
+	pr_info("comedi#: vmk80xx: board #%d [%s] now detached\n",
 	       dev->count, dev->board.name);
 
 	up(&dev->limit_sem);
@@ -1462,7 +1461,7 @@ static int __init vmk80xx_init(void)
 {
 	int retval;
 
-	printk(KERN_INFO "vmk80xx: version 0.8.01 "
+	pr_info("vmk80xx: version 0.8.01 " \
 	       "Manuel Gebele <forensixs@gmx.de>\n");
 
 	retval = comedi_driver_register(&driver_vmk80xx);
-- 
1.7.11.1

