Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab2AHBgF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 20:36:05 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56714 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab2AHBgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 20:36:03 -0500
Message-ID: <1325986552.4442.0.camel@phoenix>
Subject: [PATCH] i2c: convert gpio-i2cmux to use module_platform_driver()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Korsgaard <peter.korsgaard@barco.com>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org
Date: Sun, 08 Jan 2012 09:35:52 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts gpio-i2cmux to use the module_platform_driver() macro which
makes the code smaller and a bit simpler.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/i2c/muxes/gpio-i2cmux.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/i2c/muxes/gpio-i2cmux.c b/drivers/i2c/muxes/gpio-i2cmux.c
index 7b6ce62..e5fa695 100644
--- a/drivers/i2c/muxes/gpio-i2cmux.c
+++ b/drivers/i2c/muxes/gpio-i2cmux.c
@@ -165,18 +165,7 @@ static struct platform_driver gpiomux_driver = {
 	},
 };
 
-static int __init gpiomux_init(void)
-{
-	return platform_driver_register(&gpiomux_driver);
-}
-
-static void __exit gpiomux_exit(void)
-{
-	platform_driver_unregister(&gpiomux_driver);
-}
-
-module_init(gpiomux_init);
-module_exit(gpiomux_exit);
+module_platform_driver(gpiomux_driver);
 
 MODULE_DESCRIPTION("GPIO-based I2C multiplexer driver");
 MODULE_AUTHOR("Peter Korsgaard <peter.korsgaard@barco.com>");
-- 
1.7.5.4



