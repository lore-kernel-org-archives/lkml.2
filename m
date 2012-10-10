Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab2JJNFA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 09:05:00 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:58032 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747Ab2JJNE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 09:04:59 -0400
MIME-Version: 1.0
Date: Wed, 10 Oct 2012 21:04:58 +0800
Message-ID: <CAPgLHd9EpvEuFp4wtL+-BJRyd4t26qh9yzfbAvb5M+OPUttjCQ@mail.gmail.com>
Subject: [PATCH] pch_dma: use module_pci_driver to simplify the code
From: Wei Yongjun <weiyj.lk@gmail.com>
To: vinod.koul@intel.com, djbw@fb.com
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
 drivers/dma/pch_dma.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
index 987ab5c..b405916 100644
--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -1029,18 +1029,7 @@ static struct pci_driver pch_dma_driver = {
 #endif
 };
 
-static int __init pch_dma_init(void)
-{
-	return pci_register_driver(&pch_dma_driver);
-}
-
-static void __exit pch_dma_exit(void)
-{
-	pci_unregister_driver(&pch_dma_driver);
-}
-
-module_init(pch_dma_init);
-module_exit(pch_dma_exit);
+module_pci_driver(pch_dma_driver);
 
 MODULE_DESCRIPTION("Intel EG20T PCH / LAPIS Semicon ML7213/ML7223/ML7831 IOH "
 		   "DMA controller driver");


