Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442Ab2JRPPI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 11:15:08 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:42748 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636Ab2JRPPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 11:15:06 -0400
MIME-Version: 1.0
Date: Thu, 18 Oct 2012 23:15:05 +0800
Message-ID: <CAPgLHd-jNUdrUE5cwm=+iEbJQb+N_Bdduwa9kMh_rJMmU=tYuw@mail.gmail.com>
Subject: [PATCH] vme: vme_vmivme7805.c: use module_pci_driver to simplify the code
From: Wei Yongjun <weiyj.lk@gmail.com>
To: martyn.welch@ge.com, manohar.vanga@gmail.com, gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Use the module_pci_driver() macro to make the code simpler
by eliminating module_init and module_exit calls.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/vme/boards/vme_vmivme7805.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/vme/boards/vme_vmivme7805.c b/drivers/vme/boards/vme_vmivme7805.c
index 8e05bb4..dd22b50 100644
--- a/drivers/vme/boards/vme_vmivme7805.c
+++ b/drivers/vme/boards/vme_vmivme7805.c
@@ -19,10 +19,8 @@
 
 #include "vme_vmivme7805.h"
 
-static int __init vmic_init(void);
 static int vmic_probe(struct pci_dev *, const struct pci_device_id *);
 static void vmic_remove(struct pci_dev *);
-static void __exit vmic_exit(void);
 
 /** Base address to access FPGA register */
 static void *vmic_base;
@@ -41,11 +39,6 @@ static struct pci_driver vmic_driver = {
 	.remove = vmic_remove,
 };
 
-static int __init vmic_init(void)
-{
-	return pci_register_driver(&vmic_driver);
-}
-
 static int vmic_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	int retval;
@@ -109,15 +102,9 @@ static void vmic_remove(struct pci_dev *pdev)
 
 }
 
-static void __exit vmic_exit(void)
-{
-	pci_unregister_driver(&vmic_driver);
-}
+module_pci_driver(vmic_driver);
 
 MODULE_DESCRIPTION("VMIVME-7805 board support driver");
 MODULE_AUTHOR("Arthur Benilov <arthur.benilov@iba-group.com>");
 MODULE_LICENSE("GPL");
 
-module_init(vmic_init);
-module_exit(vmic_exit);
-


