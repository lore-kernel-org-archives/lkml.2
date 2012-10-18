Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab2JRPNk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 11:13:40 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:38627 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755744Ab2JRPNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 11:13:38 -0400
MIME-Version: 1.0
Date: Thu, 18 Oct 2012 23:13:37 +0800
Message-ID: <CAPgLHd__XiRNpPNqePy2Qa1_8-SMbyF54Ef-Cko5pR7+nPCxxw@mail.gmail.com>
Subject: [PATCH] vme: vme_ca91cx42.c: use module_pci_driver to simplify the code
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
 drivers/vme/bridges/vme_ca91cx42.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/vme/bridges/vme_ca91cx42.c b/drivers/vme/bridges/vme_ca91cx42.c
index 1425d22c..64bfea3 100644
--- a/drivers/vme/bridges/vme_ca91cx42.c
+++ b/drivers/vme/bridges/vme_ca91cx42.c
@@ -34,10 +34,8 @@
 #include "../vme_bridge.h"
 #include "vme_ca91cx42.h"
 
-static int __init ca91cx42_init(void);
 static int ca91cx42_probe(struct pci_dev *, const struct pci_device_id *);
 static void ca91cx42_remove(struct pci_dev *);
-static void __exit ca91cx42_exit(void);
 
 /* Module parameters */
 static int geoid;
@@ -1523,11 +1521,6 @@ static void ca91cx42_free_consistent(struct device *parent, size_t size,
 	pci_free_consistent(pdev, size, vaddr, dma);
 }
 
-static int __init ca91cx42_init(void)
-{
-	return pci_register_driver(&ca91cx42_driver);
-}
-
 /*
  * Configure CR/CSR space
  *
@@ -1944,16 +1937,10 @@ static void ca91cx42_remove(struct pci_dev *pdev)
 	kfree(ca91cx42_bridge);
 }
 
-static void __exit ca91cx42_exit(void)
-{
-	pci_unregister_driver(&ca91cx42_driver);
-}
+module_pci_driver(ca91cx42_driver);
 
 MODULE_PARM_DESC(geoid, "Override geographical addressing");
 module_param(geoid, int, 0);
 
 MODULE_DESCRIPTION("VME driver for the Tundra Universe II VME bridge");
 MODULE_LICENSE("GPL");
-
-module_init(ca91cx42_init);
-module_exit(ca91cx42_exit);

