Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab2JHOJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 10:09:52 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:35734 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab2JHOJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 10:09:48 -0400
MIME-Version: 1.0
Date: Mon, 8 Oct 2012 22:09:48 +0800
Message-ID: <CAPgLHd8ONvLXiAZG5brCuATwkyUW2MbWPwS9rQZn7Sru7qmFGw@mail.gmail.com>
Subject: [PATCH] mfd: use module_i2c_driver to simplify the code
From: Wei Yongjun <weiyj.lk@gmail.com>
To: michael.hennerich@analog.com, sameo@linux.intel.com
Cc: yongjun_wei@trendmicro.com.cn, device-drivers-devel@blackfin.uclinux.org,
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
 drivers/mfd/adp5520.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/mfd/adp5520.c b/drivers/mfd/adp5520.c
index ea8b947..94e7a6d 100644
--- a/drivers/mfd/adp5520.c
+++ b/drivers/mfd/adp5520.c
@@ -360,17 +360,7 @@ static struct i2c_driver adp5520_driver = {
 	.id_table 	= adp5520_id,
 };
 
-static int __init adp5520_init(void)
-{
-	return i2c_add_driver(&adp5520_driver);
-}
-module_init(adp5520_init);
-
-static void __exit adp5520_exit(void)
-{
-	i2c_del_driver(&adp5520_driver);
-}
-module_exit(adp5520_exit);
+module_i2c_driver(adp5520_driver);
 
 MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
 MODULE_DESCRIPTION("ADP5520(01) PMIC-MFD Driver");

