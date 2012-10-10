Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab2JJNBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 09:01:52 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:62466 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755907Ab2JJNBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 09:01:48 -0400
MIME-Version: 1.0
Date: Wed, 10 Oct 2012 21:01:47 +0800
Message-ID: <CAPgLHd_cde1DQOsjs7PQgb8K=QxX5FcHPzwf=6B4MYWYvpnmPQ@mail.gmail.com>
Subject: [PATCH] block, sx8: use module_pci_driver to simplify the code
From: Wei Yongjun <weiyj.lk@gmail.com>
To: jgarzik@redhat.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
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
 drivers/block/sx8.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/block/sx8.c b/drivers/block/sx8.c
index 3fb6ab4..d7abf0d 100644
--- a/drivers/block/sx8.c
+++ b/drivers/block/sx8.c
@@ -1747,17 +1747,6 @@ static void carm_remove_one (struct pci_dev *pdev)
 	pci_set_drvdata(pdev, NULL);
 }
 
-static int __init carm_init(void)
-{
-	return pci_register_driver(&carm_driver);
-}
-
-static void __exit carm_exit(void)
-{
-	pci_unregister_driver(&carm_driver);
-}
-
-module_init(carm_init);
-module_exit(carm_exit);
+module_pci_driver(carm_driver);
 
 


