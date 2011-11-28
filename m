Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab1K1JPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 04:15:17 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56349 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab1K1JPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 04:15:16 -0500
Message-ID: <1322471704.2730.1.camel@phoenix>
Subject: [PATCH] net: rfkill: convert net/rfkill/* to use
 module_platform_driver()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Antonio Ospite <ospite@studenti.unina.it>,
        Rhyland Klein <rklein@nvidia.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Date: Mon, 28 Nov 2011 17:15:04 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers in net/rfkill/* to use the
module_platform_driver() macro which makes the code smaller and a bit
simpler.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Antonio Ospite <ospite@studenti.unina.it>
Cc: Rhyland Klein <rklein@nvidia.com>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 net/rfkill/rfkill-gpio.c      |   13 +------------
 net/rfkill/rfkill-regulator.c |   12 +-----------
 2 files changed, 2 insertions(+), 23 deletions(-)

diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index 128677d..ca355e7 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -220,18 +220,7 @@ static struct platform_driver rfkill_gpio_driver = {
 	},
 };
 
-static int __init rfkill_gpio_init(void)
-{
-	return platform_driver_register(&rfkill_gpio_driver);
-}
-
-static void __exit rfkill_gpio_exit(void)
-{
-	platform_driver_unregister(&rfkill_gpio_driver);
-}
-
-module_init(rfkill_gpio_init);
-module_exit(rfkill_gpio_exit);
+module_platform_driver(rfkill_gpio_driver);
 
 MODULE_DESCRIPTION("gpio rfkill");
 MODULE_AUTHOR("NVIDIA");
diff --git a/net/rfkill/rfkill-regulator.c b/net/rfkill/rfkill-regulator.c
index 3ca7277..2ebfe8d 100644
--- a/net/rfkill/rfkill-regulator.c
+++ b/net/rfkill/rfkill-regulator.c
@@ -144,17 +144,7 @@ static struct platform_driver rfkill_regulator_driver = {
 	},
 };
 
-static int __init rfkill_regulator_init(void)
-{
-	return platform_driver_register(&rfkill_regulator_driver);
-}
-module_init(rfkill_regulator_init);
-
-static void __exit rfkill_regulator_exit(void)
-{
-	platform_driver_unregister(&rfkill_regulator_driver);
-}
-module_exit(rfkill_regulator_exit);
+module_platform_driver(rfkill_regulator_driver);
 
 MODULE_AUTHOR("Guiming Zhuo <gmzhuo@gmail.com>");
 MODULE_AUTHOR("Antonio Ospite <ospite@studenti.unina.it>");
-- 
1.7.5.4



