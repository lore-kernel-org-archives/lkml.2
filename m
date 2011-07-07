Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab1GGNPY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 09:15:24 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44758 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756535Ab1GGNPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 09:15:22 -0400
Subject: [PATCH] power_supply: ds2780_battery/z2_battery: add __devexit_p
 at necessary places
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Clifton Barnes <cabarnes@indesign-llc.com>,
        Peter Edwards <sweetlilmre@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jul 2011 21:15:13 +0800
Message-ID: <1310044513.24314.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the comments in include/linux/init.h:

"Pointers to __devexit functions must use __devexit_p(function_name), the
wrapper will insert either the function_name or NULL, depending on the config
options."

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Clifton Barnes <cabarnes@indesign-llc.com>
Cc: Peter Edwards <sweetlilmre@gmail.com>
---
 drivers/power/ds2780_battery.c |    2 +-
 drivers/power/z2_battery.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/ds2780_battery.c b/drivers/power/ds2780_battery.c
index 1fefe82..ed25ef5 100644
--- a/drivers/power/ds2780_battery.c
+++ b/drivers/power/ds2780_battery.c
@@ -832,7 +832,7 @@ static struct platform_driver ds2780_battery_driver = {
 		.name = "ds2780-battery",
 	},
 	.probe	  = ds2780_battery_probe,
-	.remove   = ds2780_battery_remove,
+	.remove   = __devexit_p(ds2780_battery_remove),
 };
 
 static int __init ds2780_battery_init(void)
diff --git a/drivers/power/z2_battery.c b/drivers/power/z2_battery.c
index d119c38..ae38c44 100644
--- a/drivers/power/z2_battery.c
+++ b/drivers/power/z2_battery.c
@@ -313,7 +313,7 @@ static struct i2c_driver z2_batt_driver = {
 		.pm	= Z2_BATTERY_PM_OPS
 	},
 	.probe		= z2_batt_probe,
-	.remove		= z2_batt_remove,
+	.remove		= __devexit_p(z2_batt_remove),
 	.id_table	= z2_batt_id,
 };
 
-- 
1.7.4.1



