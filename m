Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab2KFLxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 06:53:43 -0500
Received: from mga14.intel.com ([143.182.124.37]:56957 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903Ab2KFLxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 06:53:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,722,1344236400"; 
   d="scan'208";a="214046493"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: viresh kumar <viresh.kumar@linaro.org>,
        Vinod Koul <vinod.koul@linux.intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] dw_dmac: call .probe after we have a device in place
Date: Tue,  6 Nov 2012 13:53:31 +0200
Message-Id: <1352202811-29384-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we don't yet have the platform device for the driver when it is being loaded
we fail to probe the driver. So instead of calling probe() directly we call
platform_driver_register(). It will call the probe() immediately if we have the
device but also makes the driver to work on platforms where the platform device
is created later.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 2c8096d..b0b301b 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1829,6 +1829,7 @@ MODULE_DEVICE_TABLE(of, dw_dma_id_table);
 #endif
 
 static struct platform_driver dw_driver = {
+	.probe		= dw_probe,
 	.remove		= __devexit_p(dw_remove),
 	.shutdown	= dw_shutdown,
 	.driver = {
@@ -1840,7 +1841,7 @@ static struct platform_driver dw_driver = {
 
 static int __init dw_init(void)
 {
-	return platform_driver_probe(&dw_driver, dw_probe);
+	return platform_driver_register(&dw_driver);
 }
 subsys_initcall(dw_init);
 
-- 
1.7.10.4

