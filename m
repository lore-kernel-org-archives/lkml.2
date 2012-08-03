Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab2HCI1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 04:27:09 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:35269 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab2HCI1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 04:27:04 -0400
From: Devendra Naga <develkernel412222@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <david-b@pacbell.net>, <justin.waters@timesys.com>,
        <a.zummo@towertech.it>, Andrew Morton <akpm@linux-foundation.org>,
        Devendra Naga <develkernel412222@gmail.com>
Subject: [PATCH] rtc/at91sam9: use module_platform_driver macro
Date: Fri,  3 Aug 2012 14:11:40 +0545
Message-Id: <1343982400-17245-1-git-send-email-develkernel412222@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver does seems to do only platform_driver_register in the
init function and platform_driver_unregister in the exit function,

so replace all this code including the module_init and module_exit with
module_platform_driver macro...

Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
---
 drivers/rtc/rtc-at91sam9.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/rtc/rtc-at91sam9.c b/drivers/rtc/rtc-at91sam9.c
index 8318689..1063ea1 100644
--- a/drivers/rtc/rtc-at91sam9.c
+++ b/drivers/rtc/rtc-at91sam9.c
@@ -465,18 +465,7 @@ static struct platform_driver at91_rtc_driver = {
 	},
 };
 
-static int __init at91_rtc_init(void)
-{
-	return platform_driver_register(&at91_rtc_driver);
-}
-module_init(at91_rtc_init);
-
-static void __exit at91_rtc_exit(void)
-{
-	platform_driver_unregister(&at91_rtc_driver);
-}
-module_exit(at91_rtc_exit);
-
+module_platform_driver(at91_rtc_driver);
 
 MODULE_AUTHOR("Michel Benoit");
 MODULE_DESCRIPTION("RTC driver for Atmel AT91SAM9x");
-- 
1.7.9.5

