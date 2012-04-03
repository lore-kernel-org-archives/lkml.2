Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab2DCAvF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 20:51:05 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33757 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab2DCAvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 20:51:03 -0400
Message-ID: <1333414253.18133.1.camel@phoenix>
Subject: [PATCH] Input: use module_pci_driver
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org
Date: Tue, 03 Apr 2012 08:50:53 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers in drivers/input/* to use module_pci_driver()
macro which makes the code smaller and a bit simpler.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/gameport/emu10k1-gp.c |   13 +------------
 drivers/input/gameport/fm801-gp.c   |   16 ++--------------
 drivers/input/serio/pcips2.c        |   15 ++-------------
 3 files changed, 5 insertions(+), 39 deletions(-)

diff --git a/drivers/input/gameport/emu10k1-gp.c b/drivers/input/gameport/emu10k1-gp.c
index 422aa0a..daceafe 100644
--- a/drivers/input/gameport/emu10k1-gp.c
+++ b/drivers/input/gameport/emu10k1-gp.c
@@ -125,15 +125,4 @@ static struct pci_driver emu_driver = {
         .remove =       __devexit_p(emu_remove),
 };
 
-static int __init emu_init(void)
-{
-	return pci_register_driver(&emu_driver);
-}
-
-static void __exit emu_exit(void)
-{
-	pci_unregister_driver(&emu_driver);
-}
-
-module_init(emu_init);
-module_exit(emu_exit);
+module_pci_driver(emu_driver);
diff --git a/drivers/input/gameport/fm801-gp.c b/drivers/input/gameport/fm801-gp.c
index a3b70ff..48ad382 100644
--- a/drivers/input/gameport/fm801-gp.c
+++ b/drivers/input/gameport/fm801-gp.c
@@ -144,6 +144,7 @@ static const struct pci_device_id fm801_gp_id_table[] = {
 	{ PCI_VENDOR_ID_FORTEMEDIA, PCI_DEVICE_ID_FM801_GP, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0  },
 	{ 0 }
 };
+MODULE_DEVICE_TABLE(pci, fm801_gp_id_table);
 
 static struct pci_driver fm801_gp_driver = {
 	.name =		"FM801_gameport",
@@ -152,20 +153,7 @@ static struct pci_driver fm801_gp_driver = {
 	.remove =	__devexit_p(fm801_gp_remove),
 };
 
-static int __init fm801_gp_init(void)
-{
-	return pci_register_driver(&fm801_gp_driver);
-}
-
-static void __exit fm801_gp_exit(void)
-{
-	pci_unregister_driver(&fm801_gp_driver);
-}
-
-module_init(fm801_gp_init);
-module_exit(fm801_gp_exit);
-
-MODULE_DEVICE_TABLE(pci, fm801_gp_id_table);
+module_pci_driver(fm801_gp_driver);
 
 MODULE_DESCRIPTION("FM801 gameport driver");
 MODULE_AUTHOR("Takashi Iwai <tiwai@suse.de>");
diff --git a/drivers/input/serio/pcips2.c b/drivers/input/serio/pcips2.c
index 4349474..0c42497 100644
--- a/drivers/input/serio/pcips2.c
+++ b/drivers/input/serio/pcips2.c
@@ -206,6 +206,7 @@ static const struct pci_device_id pcips2_ids[] = {
 	},
 	{ 0, }
 };
+MODULE_DEVICE_TABLE(pci, pcips2_ids);
 
 static struct pci_driver pcips2_driver = {
 	.name			= "pcips2",
@@ -214,20 +215,8 @@ static struct pci_driver pcips2_driver = {
 	.remove			= __devexit_p(pcips2_remove),
 };
 
-static int __init pcips2_init(void)
-{
-	return pci_register_driver(&pcips2_driver);
-}
-
-static void __exit pcips2_exit(void)
-{
-	pci_unregister_driver(&pcips2_driver);
-}
-
-module_init(pcips2_init);
-module_exit(pcips2_exit);
+module_pci_driver(pcips2_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Russell King <rmk@arm.linux.org.uk>");
 MODULE_DESCRIPTION("PCI PS/2 keyboard/mouse driver");
-MODULE_DEVICE_TABLE(pci, pcips2_ids);
-- 
1.7.5.4



