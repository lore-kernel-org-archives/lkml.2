Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840Ab2KHTy0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 14:54:26 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38724 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756783Ab2KHTyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 14:54:22 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <ben@decadent.org.uk>, Sean Young <sean@mess.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH] staging/media: Use pr_ printks in lirc/lirc_bt829.c
Date: Fri,  9 Nov 2012 04:54:09 +0900
Message-Id: <1352404449-7666-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
- WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
- WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...

and add pr_fmt.

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/media/lirc/lirc_bt829.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_bt829.c b/drivers/staging/media/lirc/lirc_bt829.c
index 951007a..4a3b1f5 100644
--- a/drivers/staging/media/lirc/lirc_bt829.c
+++ b/drivers/staging/media/lirc/lirc_bt829.c
@@ -18,6 +18,8 @@
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/threads.h>
@@ -72,20 +74,19 @@ static struct pci_dev *do_pci_probe(void)
 	my_dev = pci_get_device(PCI_VENDOR_ID_ATI,
 				PCI_DEVICE_ID_ATI_264VT, NULL);
 	if (my_dev) {
-		printk(KERN_ERR DRIVER_NAME ": Using device: %s\n",
-		       pci_name(my_dev));
+		pr_err("Using device: %s\n", pci_name(my_dev));
 		pci_addr_phys = 0;
 		if (my_dev->resource[0].flags & IORESOURCE_MEM) {
 			pci_addr_phys = my_dev->resource[0].start;
-			printk(KERN_INFO DRIVER_NAME ": memory at 0x%08X\n",
+			pr_info("memory at 0x%08X\n",
 			        (unsigned int)pci_addr_phys);
 		}
 		if (pci_addr_phys == 0) {
-			printk(KERN_ERR DRIVER_NAME ": no memory resource ?\n");
+			pr_err("no memory resource ?\n");
 			return NULL;
 		}
 	} else {
-		printk(KERN_ERR DRIVER_NAME ": pci_probe failed\n");
+		pr_err("pci_probe failed\n");
 		return NULL;
 	}
 	return my_dev;
@@ -140,7 +141,7 @@ int init_module(void)
 
 	atir_minor = lirc_register_driver(&atir_driver);
 	if (atir_minor < 0) {
-		printk(KERN_ERR DRIVER_NAME ": failed to register driver!\n");
+		pr_err("failed to register driver!\n");
 		return atir_minor;
 	}
 	dprintk("driver is registered on minor %d\n", atir_minor);
@@ -159,7 +160,7 @@ static int atir_init_start(void)
 {
 	pci_addr_lin = ioremap(pci_addr_phys + DATA_PCI_OFF, 0x400);
 	if (pci_addr_lin == 0) {
-		printk(KERN_INFO DRIVER_NAME ": pci mem must be mapped\n");
+		pr_info("pci mem must be mapped\n");
 		return 0;
 	}
 	return 1;
-- 
1.7.9.5

