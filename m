Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab2DCCHH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 22:07:07 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59240 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab2DCCHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 22:07:06 -0400
Message-ID: <1333418821.18133.8.camel@phoenix>
Subject: [PATCH] firewire: use module_pci_driver
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kristian Hoegsberg <krh@bitplanet.net>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net
Date: Tue, 03 Apr 2012 10:07:01 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers in drivers/firewire/* to use module_pci_driver()
macro which makes the code smaller and a bit simpler.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Kristian Hoegsberg <krh@bitplanet.net>
---
 drivers/firewire/nosy.c |   20 ++++----------------
 drivers/firewire/ohci.c |   15 ++-------------
 2 files changed, 6 insertions(+), 29 deletions(-)

diff --git a/drivers/firewire/nosy.c b/drivers/firewire/nosy.c
index a7c4422..4ebfb22 100644
--- a/drivers/firewire/nosy.c
+++ b/drivers/firewire/nosy.c
@@ -693,6 +693,8 @@ static struct pci_device_id pci_table[] __devinitdata = {
 	{ }	/* Terminating entry */
 };
 
+MODULE_DEVICE_TABLE(pci, pci_table);
+
 static struct pci_driver lynx_pci_driver = {
 	.name =		driver_name,
 	.id_table =	pci_table,
@@ -700,22 +702,8 @@ static struct pci_driver lynx_pci_driver = {
 	.remove =	remove_card,
 };
 
+module_pci_driver(lynx_pci_driver);
+
 MODULE_AUTHOR("Kristian Hoegsberg");
 MODULE_DESCRIPTION("Snoop mode driver for TI pcilynx 1394 controllers");
 MODULE_LICENSE("GPL");
-MODULE_DEVICE_TABLE(pci, pci_table);
-
-static int __init nosy_init(void)
-{
-	return pci_register_driver(&lynx_pci_driver);
-}
-
-static void __exit nosy_cleanup(void)
-{
-	pci_unregister_driver(&lynx_pci_driver);
-
-	pr_info("Unloaded %s\n", driver_name);
-}
-
-module_init(nosy_init);
-module_exit(nosy_cleanup);
diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 2b54600..67c8d27 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -3789,6 +3789,8 @@ static struct pci_driver fw_ohci_pci_driver = {
 #endif
 };
 
+module_pci_driver(fw_ohci_pci_driver);
+
 MODULE_AUTHOR("Kristian Hoegsberg <krh@bitplanet.net>");
 MODULE_DESCRIPTION("Driver for PCI OHCI IEEE1394 controllers");
 MODULE_LICENSE("GPL");
@@ -3797,16 +3799,3 @@ MODULE_LICENSE("GPL");
 #ifndef CONFIG_IEEE1394_OHCI1394_MODULE
 MODULE_ALIAS("ohci1394");
 #endif
-
-static int __init fw_ohci_init(void)
-{
-	return pci_register_driver(&fw_ohci_pci_driver);
-}
-
-static void __exit fw_ohci_cleanup(void)
-{
-	pci_unregister_driver(&fw_ohci_pci_driver);
-}
-
-module_init(fw_ohci_init);
-module_exit(fw_ohci_cleanup);
-- 
1.7.5.4



