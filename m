Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab2JHOGL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 10:06:11 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:60847 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab2JHOGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 10:06:08 -0400
MIME-Version: 1.0
Date: Mon, 8 Oct 2012 22:06:07 +0800
Message-ID: <CAPgLHd9u7-N=MVtP7d6QYTfeVL6CL3pc94Lrucp_NVDLo6yxPA@mail.gmail.com>
Subject: [PATCH] w1/ds2482: use module_i2c_driver to simplify the code
From: Wei Yongjun <weiyj.lk@gmail.com>
To: zbr@ioremap.net
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
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
 drivers/w1/masters/ds2482.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/w1/masters/ds2482.c b/drivers/w1/masters/ds2482.c
index e5f7441..6429b9e 100644
--- a/drivers/w1/masters/ds2482.c
+++ b/drivers/w1/masters/ds2482.c
@@ -505,19 +505,8 @@ static int ds2482_remove(struct i2c_client *client)
 	return 0;
 }
 
-static int __init sensors_ds2482_init(void)
-{
-	return i2c_add_driver(&ds2482_driver);
-}
-
-static void __exit sensors_ds2482_exit(void)
-{
-	i2c_del_driver(&ds2482_driver);
-}
+module_i2c_driver(ds2482_driver);
 
 MODULE_AUTHOR("Ben Gardner <bgardner@wabtec.com>");
 MODULE_DESCRIPTION("DS2482 driver");
 MODULE_LICENSE("GPL");
-
-module_init(sensors_ds2482_init);
-module_exit(sensors_ds2482_exit);


