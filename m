Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab2JHMki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 08:40:38 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38511 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab2JHMkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 08:40:36 -0400
MIME-Version: 1.0
Date: Mon, 8 Oct 2012 20:40:35 +0800
Message-ID: <CAPgLHd99+yWL1br_FgWbj=5vnjRWoAAqe9ME6LS45aCj=Ga-Wg@mail.gmail.com>
Subject: [PATCH] hwmon: ina2xx: use module_i2c_driver to simplify the code
From: Wei Yongjun <weiyj.lk@gmail.com>
To: khali@linux-fr.org, linux@roeck-us.net
Cc: yongjun_wei@trendmicro.com.cn, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Use the module_i2c_driver() macro to make the code smaller
and a bit simpler.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/hwmon/ina2xx.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/hwmon/ina2xx.c b/drivers/hwmon/ina2xx.c
index 70717d4..3e7a869 100644
--- a/drivers/hwmon/ina2xx.c
+++ b/drivers/hwmon/ina2xx.c
@@ -301,19 +301,8 @@ static struct i2c_driver ina2xx_driver = {
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


