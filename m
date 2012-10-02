Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab2JBLmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 07:42:35 -0400
Received: from mga14.intel.com ([143.182.124.37]:3579 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692Ab2JBLmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 07:42:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,523,1344236400"; 
   d="scan'208";a="199571514"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>,
        balbi@ti.com
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 1/4] dmaengine: dw_dmac: use helper macro module_platform_driver()
Date: Tue,  2 Oct 2012 14:41:58 +0300
Message-Id: <1349178121-9105-2-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1349178121-9105-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1349178121-9105-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

Since v3.2 we have nice macro to define the platform driver's init and exit
calls. This patch simplifies the dw_dmac driver by using that macro.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/dma/dw_dmac.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index c4b0eb3..0b88ced 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1700,6 +1700,7 @@ MODULE_DEVICE_TABLE(of, dw_dma_id_table);
 #endif
 
 static struct platform_driver dw_driver = {
+	.probe		= dw_probe,
 	.remove		= __devexit_p(dw_remove),
 	.shutdown	= dw_shutdown,
 	.driver = {
@@ -1709,17 +1710,7 @@ static struct platform_driver dw_driver = {
 	},
 };
 
-static int __init dw_init(void)
-{
-	return platform_driver_probe(&dw_driver, dw_probe);
-}
-subsys_initcall(dw_init);
-
-static void __exit dw_exit(void)
-{
-	platform_driver_unregister(&dw_driver);
-}
-module_exit(dw_exit);
+module_platform_driver(dw_driver);
 
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("Synopsys DesignWare DMA Controller driver");
-- 
1.7.10.4

