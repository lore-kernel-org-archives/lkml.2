Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab2JHMjz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 08:39:55 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:39615 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845Ab2JHMjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 08:39:53 -0400
MIME-Version: 1.0
Date: Mon, 8 Oct 2012 20:39:52 +0800
Message-ID: <CAPgLHd-=SuxABDRiUp3V-HzOnaJVhzOJd4XxPax+NjUJ9xjwVg@mail.gmail.com>
Subject: [PATCH] powerpc/83xx: use module_i2c_driver to simplify the code
From: Wei Yongjun <weiyj.lk@gmail.com>
To: galak@kernel.crashing.org, benh@kernel.crashing.org, paulus@samba.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com
Cc: yongjun_wei@trendmicro.com.cn, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
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
 arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c b/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c
index ef6537b..d91799e 100644
--- a/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c
+++ b/arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c
@@ -232,17 +232,7 @@ static struct i2c_driver mcu_driver = {
 	.id_table = mcu_ids,
 };
 
-static int __init mcu_init(void)
-{
-	return i2c_add_driver(&mcu_driver);
-}
-module_init(mcu_init);
-
-static void __exit mcu_exit(void)
-{
-	i2c_del_driver(&mcu_driver);
-}
-module_exit(mcu_exit);
+module_i2c_driver(mcu_driver);
 
 MODULE_DESCRIPTION("Power Management and GPIO expander driver for "
 		   "MPC8349E-mITX-compatible MCU");


