Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab2AKHqF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 02:46:05 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62253 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228Ab2AKHqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 02:46:03 -0500
Message-ID: <1326267956.15588.4.camel@phoenix>
Subject: [PATCH 3/3] power_supply: da9052-battery: Convert to use
 module_platform_driver
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        David Dajun Chen <dchen@diasemi.com>
Date: Wed, 11 Jan 2012 15:45:56 +0800
In-Reply-To: <1326267824.15588.2.camel@phoenix>
References: <1326267824.15588.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the module_platform_driver() macro which makes the code smaller and a bit
simpler.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/power/da9052-battery.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/power/da9052-battery.c b/drivers/power/da9052-battery.c
index daf52a4..d648ba9 100644
--- a/drivers/power/da9052-battery.c
+++ b/drivers/power/da9052-battery.c
@@ -648,17 +648,7 @@ static struct platform_driver da9052_bat_driver = {
 	},
 };
 
-static int __init da9052_bat_init(void)
-{
-	return platform_driver_register(&da9052_bat_driver);
-}
-module_init(da9052_bat_init);
-
-static void __exit da9052_bat_exit(void)
-{
-	platform_driver_unregister(&da9052_bat_driver);
-}
-module_exit(da9052_bat_exit);
+module_platform_driver(da9052_bat_driver);
 
 MODULE_DESCRIPTION("DA9052 BAT Device Driver");
 MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>");
-- 
1.7.5.4



