Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab2GUI4L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 04:56:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49984 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab2GUI4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 04:56:09 -0400
From: Devendra Naga <develkernel412222@gmail.com>
To: Omar Ramirez Luna <omar.ramirez@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?V=C3=ADctor=20Manuel=20J=C3=A1quez=20Leal?= 
	<vjaquez@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Devendra Naga <develkernel412222@gmail.com>
Subject: [PATCH 2/2] staging/tidspbridge: use module_platform_driver
Date: Sat, 21 Jul 2012 14:41:00 +0545
Message-Id: <1342860960-19463-1-git-send-email-develkernel412222@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the code under _init and _exit does platform_driver_register and
platform_driver_unregister respectively only,

so its better to use the module_platform_driver than just replicating
the module_platform_driver's implementation

Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
---

 drivers/staging/tidspbridge/rmgr/drv_interface.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/staging/tidspbridge/rmgr/drv_interface.c b/drivers/staging/tidspbridge/rmgr/drv_interface.c
index 3cac014..6acea2b 100644
--- a/drivers/staging/tidspbridge/rmgr/drv_interface.c
+++ b/drivers/staging/tidspbridge/rmgr/drv_interface.c
@@ -613,16 +613,6 @@ static struct platform_driver bridge_driver = {
 #endif
 };
 
-static int __init bridge_init(void)
-{
-	return platform_driver_register(&bridge_driver);
-}
-
-static void __exit bridge_exit(void)
-{
-	platform_driver_unregister(&bridge_driver);
-}
-
 /* To remove all process resources before removing the process from the
  * process context list */
 int drv_remove_all_resources(void *process_ctxt)
@@ -636,6 +626,4 @@ int drv_remove_all_resources(void *process_ctxt)
 	return status;
 }
 
-/* Bridge driver initialization and de-initialization functions */
-module_init(bridge_init);
-module_exit(bridge_exit);
+module_platform_driver(bridge_driver);
-- 
1.7.9.5

