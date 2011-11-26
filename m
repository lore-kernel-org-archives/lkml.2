Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab1KZHTH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 02:19:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35607 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab1KZHTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 02:19:02 -0500
Message-ID: <1322291935.20464.5.camel@phoenix>
Subject: [PATCH] uio: convert drivers/uio/* to use module_platform_driver()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>,
        Magnus Damm <damm@igel.co.jp>,
        Amit Chatterjee <amit.chatterjee@ti.com>,
        Pratheesh Gangadhar <pratheesh@ti.com>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Greg Kroah-Hartman <gregkh@suse.de>
Date: Sat, 26 Nov 2011 15:18:55 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers in drivers/uio/* to use the
module_platform_driver() macro which makes the code smaller and a bit
simpler.

Cc: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
Cc: Magnus Damm <damm@igel.co.jp>
Cc: Amit Chatterjee <amit.chatterjee@ti.com>
Cc: Pratheesh Gangadhar <pratheesh@ti.com>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/uio/uio_pdrv.c        |   12 +-----------
 drivers/uio/uio_pdrv_genirq.c |   13 +------------
 drivers/uio/uio_pruss.c       |   14 +-------------
 3 files changed, 3 insertions(+), 36 deletions(-)

diff --git a/drivers/uio/uio_pdrv.c b/drivers/uio/uio_pdrv.c
index ff50595..72d3646 100644
--- a/drivers/uio/uio_pdrv.c
+++ b/drivers/uio/uio_pdrv.c
@@ -104,17 +104,7 @@ static struct platform_driver uio_pdrv = {
 	},
 };
 
-static int __init uio_pdrv_init(void)
-{
-	return platform_driver_register(&uio_pdrv);
-}
-
-static void __exit uio_pdrv_exit(void)
-{
-	platform_driver_unregister(&uio_pdrv);
-}
-module_init(uio_pdrv_init);
-module_exit(uio_pdrv_exit);
+module_platform_driver(uio_pdrv);
 
 MODULE_AUTHOR("Uwe Kleine-Koenig");
 MODULE_DESCRIPTION("Userspace I/O platform driver");
diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
index 25de302..b98371d 100644
--- a/drivers/uio/uio_pdrv_genirq.c
+++ b/drivers/uio/uio_pdrv_genirq.c
@@ -273,18 +273,7 @@ static struct platform_driver uio_pdrv_genirq = {
 	},
 };
 
-static int __init uio_pdrv_genirq_init(void)
-{
-	return platform_driver_register(&uio_pdrv_genirq);
-}
-
-static void __exit uio_pdrv_genirq_exit(void)
-{
-	platform_driver_unregister(&uio_pdrv_genirq);
-}
-
-module_init(uio_pdrv_genirq_init);
-module_exit(uio_pdrv_genirq_exit);
+module_platform_driver(uio_pdrv_genirq);
 
 MODULE_AUTHOR("Magnus Damm");
 MODULE_DESCRIPTION("Userspace I/O platform driver with generic IRQ handling");
diff --git a/drivers/uio/uio_pruss.c b/drivers/uio/uio_pruss.c
index e67b566..33a7a27 100644
--- a/drivers/uio/uio_pruss.c
+++ b/drivers/uio/uio_pruss.c
@@ -227,19 +227,7 @@ static struct platform_driver pruss_driver = {
 		   },
 };
 
-static int __init pruss_init_module(void)
-{
-	return platform_driver_register(&pruss_driver);
-}
-
-module_init(pruss_init_module);
-
-static void __exit pruss_exit_module(void)
-{
-	platform_driver_unregister(&pruss_driver);
-}
-
-module_exit(pruss_exit_module);
+module_platform_driver(pruss_driver);
 
 MODULE_LICENSE("GPL v2");
 MODULE_VERSION(DRV_VERSION);
-- 
1.7.5.4



