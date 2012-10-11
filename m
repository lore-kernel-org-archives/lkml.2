Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab2JKP4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 11:56:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63680 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab2JKP4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 11:56:42 -0400
Message-ID: <1349970986.9548.1.camel@phoenix>
Subject: [PATCH] hwmon: (ina2xx) Use module_i2c_driver macro
From: Axel Lin <axel.lin@ingics.com>
To: Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>
Cc: Lothar Felten <l-felten@ti.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Date: Thu, 11 Oct 2012 23:56:26 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/hwmon/ina2xx.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/hwmon/ina2xx.c b/drivers/hwmon/ina2xx.c
index 2b72634..8e7158c 100644
--- a/drivers/hwmon/ina2xx.c
+++ b/drivers/hwmon/ina2xx.c
@@ -302,19 +302,8 @@ static struct i2c_driver ina2xx_driver = {
 	.id_table	= ina2xx_id,
 };
 
-static int __init ina2xx_init(void)
-{
-	return i2c_add_driver(&ina2xx_driver);
-}
-
-static void __exit ina2xx_exit(void)
-{
-	i2c_del_driver(&ina2xx_driver);
-}
+module_i2c_driver(ina2xx_driver);
 
 MODULE_AUTHOR("Lothar Felten <l-felten@ti.com>");
 MODULE_DESCRIPTION("ina2xx driver");
 MODULE_LICENSE("GPL");
-
-module_init(ina2xx_init);
-module_exit(ina2xx_exit);
-- 
1.7.9.5



