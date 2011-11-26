Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab1KZHLU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 02:11:20 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54856 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab1KZHLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 02:11:19 -0500
Message-ID: <1322291472.20464.3.camel@phoenix>
Subject: [PATCH] dmaengine: convert drivers/dma/* to use
 module_platform_driver()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>, Piotr Ziecik <kosmo@semihalf.com>,
        Rongjun Ying <rongjun.ying@csr.com>, Barry Song <21cnbao@gmail.com>,
        Pelagicore AB <info@pelagicore.com>, Vinod Koul <vinod.koul@intel.com>
Date: Sat, 26 Nov 2011 15:11:12 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers in drivers/dma/* to use the
module_platform_driver() macro which makes the code smaller and a bit
simpler.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Piotr Ziecik <kosmo@semihalf.com>
Cc: Rongjun Ying <rongjun.ying@csr.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Pelagicore AB <info@pelagicore.com>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/dma/iop-adma.c    |   16 ++--------------
 drivers/dma/mpc512x_dma.c |   12 +-----------
 drivers/dma/sirf-dma.c    |   12 +-----------
 drivers/dma/timb_dma.c    |   12 +-----------
 4 files changed, 5 insertions(+), 47 deletions(-)

diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index 686dc76..04be90b 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -1735,8 +1735,6 @@ static void iop_chan_start_null_xor(struct iop_adma_chan *iop_chan)
 	spin_unlock_bh(&iop_chan->lock);
 }
 
-MODULE_ALIAS("platform:iop-adma");
-
 static struct platform_driver iop_adma_driver = {
 	.probe		= iop_adma_probe,
 	.remove		= __devexit_p(iop_adma_remove),
@@ -1746,19 +1744,9 @@ static struct platform_driver iop_adma_driver = {
 	},
 };
 
-static int __init iop_adma_init(void)
-{
-	return platform_driver_register(&iop_adma_driver);
-}
-
-static void __exit iop_adma_exit(void)
-{
-	platform_driver_unregister(&iop_adma_driver);
-	return;
-}
-module_exit(iop_adma_exit);
-module_init(iop_adma_init);
+module_platform_driver(iop_adma_driver);
 
 MODULE_AUTHOR("Intel Corporation");
 MODULE_DESCRIPTION("IOP ADMA Engine Driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:iop-adma");
diff --git a/drivers/dma/mpc512x_dma.c b/drivers/dma/mpc512x_dma.c
index 8ba4edc..4d6d4cf 100644
--- a/drivers/dma/mpc512x_dma.c
+++ b/drivers/dma/mpc512x_dma.c
@@ -835,17 +835,7 @@ static struct platform_driver mpc_dma_driver = {
 	},
 };
 
-static int __init mpc_dma_init(void)
-{
-	return platform_driver_register(&mpc_dma_driver);
-}
-module_init(mpc_dma_init);
-
-static void __exit mpc_dma_exit(void)
-{
-	platform_driver_unregister(&mpc_dma_driver);
-}
-module_exit(mpc_dma_exit);
+module_platform_driver(mpc_dma_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Piotr Ziecik <kosmo@semihalf.com>");
diff --git a/drivers/dma/sirf-dma.c b/drivers/dma/sirf-dma.c
index 55ec679..2333810 100644
--- a/drivers/dma/sirf-dma.c
+++ b/drivers/dma/sirf-dma.c
@@ -699,17 +699,7 @@ static struct platform_driver sirfsoc_dma_driver = {
 	},
 };
 
-static int __init sirfsoc_dma_init(void)
-{
-	return platform_driver_register(&sirfsoc_dma_driver);
-}
-module_init(sirfsoc_dma_init);
-
-static void __exit sirfsoc_dma_exit(void)
-{
-	platform_driver_unregister(&sirfsoc_dma_driver);
-}
-module_exit(sirfsoc_dma_exit);
+module_platform_driver(sirfsoc_dma_driver);
 
 MODULE_AUTHOR("Rongjun Ying <rongjun.ying@csr.com>, "
 	"Barry Song <baohua.song@csr.com>");
diff --git a/drivers/dma/timb_dma.c b/drivers/dma/timb_dma.c
index 8c88072..4eeaec7 100644
--- a/drivers/dma/timb_dma.c
+++ b/drivers/dma/timb_dma.c
@@ -841,17 +841,7 @@ static struct platform_driver td_driver = {
 	.remove	= __exit_p(td_remove),
 };
 
-static int __init td_init(void)
-{
-	return platform_driver_register(&td_driver);
-}
-module_init(td_init);
-
-static void __exit td_exit(void)
-{
-	platform_driver_unregister(&td_driver);
-}
-module_exit(td_exit);
+module_platform_driver(td_driver);
 
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("Timberdale DMA controller driver");
-- 
1.7.5.4



