Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab3AJIzf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 03:55:35 -0500
Received: from mga11.intel.com ([192.55.52.93]:8056 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283Ab3AJIxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 03:53:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,443,1355126400"; 
   d="scan'208";a="275270868"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        spear-devel <spear-devel@list.st.com>
Subject: [PATCHv2 07/11] dw_dmac: call .probe after we have a device in place
Date: Thu, 10 Jan 2013 10:53:02 +0200
Message-Id: <1357807986-4026-8-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357807986-4026-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1357807986-4026-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we don't yet have the platform device for the driver when it is being loaded
we fail to probe the driver. So instead of calling probe() directly we call
platform_driver_register(). It will call the probe() immediately if we have the
device but also makes the driver to work on platforms where the platform device
is created later.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/dma/dw_dmac.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index ca996bc..e5540278 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1858,6 +1858,7 @@ MODULE_DEVICE_TABLE(of, dw_dma_id_table);
 #endif
 
 static struct platform_driver dw_driver = {
+	.probe		= dw_probe,
 	.remove		= dw_remove,
 	.shutdown	= dw_shutdown,
 	.driver = {
@@ -1869,7 +1870,7 @@ static struct platform_driver dw_driver = {
 
 static int __init dw_init(void)
 {
-	return platform_driver_probe(&dw_driver, dw_probe);
+	return platform_driver_register(&dw_driver);
 }
 subsys_initcall(dw_init);
 
-- 
1.7.10.4

