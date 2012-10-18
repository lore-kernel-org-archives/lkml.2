Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab2JRPSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 11:18:48 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:63137 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881Ab2JRPSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 11:18:47 -0400
MIME-Version: 1.0
Date: Thu, 18 Oct 2012 23:18:46 +0800
Message-ID: <CAPgLHd8w2kNAjwp312PBhfYN5ec7zHQ6sqxXOMpbjmBVa54+6w@mail.gmail.com>
Subject: [PATCH] Staging: ipack/bridges/tpci200: use module_pci_driver to
 simplify the code
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org
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
 drivers/staging/ipack/bridges/tpci200.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index bb8aa70..cfed409 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -763,17 +763,7 @@ static struct pci_driver tpci200_pci_drv = {
 	.remove = __devexit_p(tpci200_pci_remove),
 };
 
-static int __init tpci200_drvr_init_module(void)
-{
-	return pci_register_driver(&tpci200_pci_drv);
-}
-
-static void __exit tpci200_drvr_exit_module(void)
-{
-	pci_unregister_driver(&tpci200_pci_drv);
-}
+module_pci_driver(tpci200_pci_drv);
 
 MODULE_DESCRIPTION("TEWS TPCI-200 device driver");
 MODULE_LICENSE("GPL");
-module_init(tpci200_drvr_init_module);
-module_exit(tpci200_drvr_exit_module);

