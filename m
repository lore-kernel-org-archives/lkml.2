Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab2G3KoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 06:44:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45467 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030Ab2G3KoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 06:44:18 -0400
From: Devendra Naga <develkernel412222@gmail.com>
To: Renata Sayakhova <renata@oktetlabs.ru>, Anton Vorontsov <cbou@mail.ru>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Cc: Devendra Naga <develkernel412222@gmail.com>
Subject: [PATCH 1/2] ds2781_battery: convert to module_platform_driver
Date: Mon, 30 Jul 2012 16:29:10 +0545
Message-Id: <1343645050-14982-1-git-send-email-develkernel412222@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

module_platform_driver can be used to replace the
platform_driver register and unregister functions,
with the calls to module_init and module_exit,

i.e. all the code that is doing like the below

static int __init mymod_init(void)
{
	return platform_driver_register(&drv_operations);
}

static void __exit mymod_exit(void)
{
	platform_driver_unregister(&drv_operations);
}

module_init(mymod_init);
module_exit(mymod_exit);

can be replaced with
module_platform_driver(drv_operations)...

Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
---
 drivers/power/ds2781_battery.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/power/ds2781_battery.c b/drivers/power/ds2781_battery.c
index 7a1ff4e..8f84ab7 100644
--- a/drivers/power/ds2781_battery.c
+++ b/drivers/power/ds2781_battery.c
@@ -835,19 +835,7 @@ static struct platform_driver ds2781_battery_driver = {
 	.remove   = __devexit_p(ds2781_battery_remove),
 };
 
-static int __init ds2781_battery_init(void)
-{
-	return platform_driver_register(&ds2781_battery_driver);
-}
-
-static void __exit ds2781_battery_exit(void)
-{
-	platform_driver_unregister(&ds2781_battery_driver);
-}
-
-module_init(ds2781_battery_init);
-module_exit(ds2781_battery_exit);
-
+module_platform_driver(ds2781_battery_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Renata Sayakhova <renata@oktetlabs.ru>");
-- 
1.7.9.5

