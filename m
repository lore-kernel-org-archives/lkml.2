Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab2JRPMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 11:12:53 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:56957 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845Ab2JRPMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 11:12:51 -0400
MIME-Version: 1.0
Date: Thu, 18 Oct 2012 23:12:50 +0800
Message-ID: <CAPgLHd-H31dtsbyMmYmPnG7VnOTPMc23w7y5e6DN_wvpcqxBkQ@mail.gmail.com>
Subject: [PATCH] vme: vme_tsi148.c: use module_pci_driver to simplify the code
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
 drivers/vme/bridges/vme_tsi148.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/vme/bridges/vme_tsi148.c b/drivers/vme/bridges/vme_tsi148.c
index 5fbd08f..9c1aa4d 100644
--- a/drivers/vme/bridges/vme_tsi148.c
+++ b/drivers/vme/bridges/vme_tsi148.c
@@ -35,10 +35,8 @@
 #include "../vme_bridge.h"
 #include "vme_tsi148.h"
 
-static int __init tsi148_init(void);
 static int tsi148_probe(struct pci_dev *, const struct pci_device_id *);
 static void tsi148_remove(struct pci_dev *);
-static void __exit tsi148_exit(void);
 
 
 /* Module parameter */
@@ -2244,11 +2242,6 @@ static void tsi148_free_consistent(struct device *parent, size_t size,
 	pci_free_consistent(pdev, size, vaddr, dma);
 }
 
-static int __init tsi148_init(void)
-{
-	return pci_register_driver(&tsi148_driver);
-}
-
 /*
  * Configure CR/CSR space
  *
@@ -2754,10 +2747,7 @@ static void tsi148_remove(struct pci_dev *pdev)
 	kfree(tsi148_bridge);
 }
 
-static void __exit tsi148_exit(void)
-{
-	pci_unregister_driver(&tsi148_driver);
-}
+module_pci_driver(tsi148_driver);
 
 MODULE_PARM_DESC(err_chk, "Check for VME errors on reads and writes");
 module_param(err_chk, bool, 0);
@@ -2767,6 +2757,3 @@ module_param(geoid, int, 0);
 
 MODULE_DESCRIPTION("VME driver for the Tundra Tempe VME bridge");
 MODULE_LICENSE("GPL");
-
-module_init(tsi148_init);
-module_exit(tsi148_exit);

