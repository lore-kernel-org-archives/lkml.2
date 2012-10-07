Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab2JGOCs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 10:02:48 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:48064 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab2JGOCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 10:02:40 -0400
MIME-Version: 1.0
Date: Sun, 7 Oct 2012 22:02:40 +0800
Message-ID: <CAPgLHd95ofKiKWC9B67q9mgkjsc6_YJ5x92aY0xKPiohuUMk4Q@mail.gmail.com>
Subject: [PATCH] clk: fix return value check in bcm2835_init_clocks()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: mturquette@ti.com, swarren@wwwdotorg.org
Cc: yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        linux-rpi-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function clk_register_fixed_rate() returns
ERR_PTR() and never returns NULL. The NULL test in the return value
check should be replaced with IS_ERR().

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/clk/clk-bcm2835.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/clk-bcm2835.c b/drivers/clk/clk-bcm2835.c
index 67ad16b..b61ee2c 100644
--- a/drivers/clk/clk-bcm2835.c
+++ b/drivers/clk/clk-bcm2835.c
@@ -33,17 +33,17 @@ void __init bcm2835_init_clocks(void)
 
 	clk = clk_register_fixed_rate(NULL, "sys_pclk", NULL, CLK_IS_ROOT,
 					250000000);
-	if (!clk)
+	if (IS_ERR(clk))
 		pr_err("sys_pclk not registered\n");
 
 	clk = clk_register_fixed_rate(NULL, "apb_pclk", NULL, CLK_IS_ROOT,
 					126000000);
-	if (!clk)
+	if (IS_ERR(clk))
 		pr_err("apb_pclk not registered\n");
 
 	clk = clk_register_fixed_rate(NULL, "uart0_pclk", NULL, CLK_IS_ROOT,
 					3000000);
-	if (!clk)
+	if (IS_ERR(clk))
 		pr_err("uart0_pclk not registered\n");
 	ret = clk_register_clkdev(clk, NULL, "20201000.uart");
 	if (ret)
@@ -51,7 +51,7 @@ void __init bcm2835_init_clocks(void)
 
 	clk = clk_register_fixed_rate(NULL, "uart1_pclk", NULL, CLK_IS_ROOT,
 					125000000);
-	if (!clk)
+	if (IS_ERR(clk))
 		pr_err("uart1_pclk not registered\n");
 	ret = clk_register_clkdev(clk, NULL, "20215000.uart");
 	if (ret)

