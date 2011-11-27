Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab1K0EoC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 23:44:02 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56769 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab1K0EoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 23:44:00 -0500
Message-ID: <1322369029.2522.1.camel@phoenix>
Subject: [PATCH] parport: convert drivers/parport/* to use
 module_platform_driver()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ben Dooks <ben@simtec.co.uk>, "Derrick J. Brashear" <shadow@dementia.org>,
        Andrew Morton <akpm@google.com>, Greg Kroah-Hartman <gregkh@suse.de>
Date: Sun, 27 Nov 2011 12:43:49 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers in drivers/parport/* to use the
module_platform_driver() macro which makes the code smaller and a bit
simpler.

Cc: Ben Dooks <ben@simtec.co.uk>
Cc: Derrick J. Brashear <shadow@dementia.org>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/parport/parport_ax88796.c |   13 +------------
 drivers/parport/parport_sunbpp.c  |   13 +------------
 2 files changed, 2 insertions(+), 24 deletions(-)

diff --git a/drivers/parport/parport_ax88796.c b/drivers/parport/parport_ax88796.c
index 844f613..7c5d866 100644
--- a/drivers/parport/parport_ax88796.c
+++ b/drivers/parport/parport_ax88796.c
@@ -420,18 +420,7 @@ static struct platform_driver axdrv = {
 	.resume		= parport_ax88796_resume,
 };
 
-static int __init parport_ax88796_init(void)
-{
-	return platform_driver_register(&axdrv);
-}
-
-static void __exit parport_ax88796_exit(void)
-{
-	platform_driver_unregister(&axdrv);
-}
-
-module_init(parport_ax88796_init)
-module_exit(parport_ax88796_exit)
+module_platform_driver(axdrv);
 
 MODULE_AUTHOR("Ben Dooks <ben@simtec.co.uk>");
 MODULE_DESCRIPTION("AX88796 Parport parallel port driver");
diff --git a/drivers/parport/parport_sunbpp.c b/drivers/parport/parport_sunbpp.c
index 910c5a2..9390a53 100644
--- a/drivers/parport/parport_sunbpp.c
+++ b/drivers/parport/parport_sunbpp.c
@@ -391,21 +391,10 @@ static struct platform_driver bpp_sbus_driver = {
 	.remove		= __devexit_p(bpp_remove),
 };
 
-static int __init parport_sunbpp_init(void)
-{
-	return platform_driver_register(&bpp_sbus_driver);
-}
-
-static void __exit parport_sunbpp_exit(void)
-{
-	platform_driver_unregister(&bpp_sbus_driver);
-}
+module_platform_driver(bpp_sbus_driver);
 
 MODULE_AUTHOR("Derrick J Brashear");
 MODULE_DESCRIPTION("Parport Driver for Sparc bidirectional Port");
 MODULE_SUPPORTED_DEVICE("Sparc Bidirectional Parallel Port");
 MODULE_VERSION("2.0");
 MODULE_LICENSE("GPL");
-
-module_init(parport_sunbpp_init)
-module_exit(parport_sunbpp_exit)
-- 
1.7.5.4



