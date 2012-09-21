Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914Ab2IUGfU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 02:35:20 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:42247 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab2IUGfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 02:35:18 -0400
MIME-Version: 1.0
Date: Fri, 21 Sep 2012 14:35:18 +0800
Message-ID: <CAPgLHd-BtGhVBHYGW1UFT9wqmnPqmuf9AWkQk6mXG7xSzWqOOA@mail.gmail.com>
Subject: [PATCH] clk: fix return value check in of_fixed_clk_setup()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: mturquette@ti.com
Cc: yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function clk_register_fixed_rate() returns
ERR_PTR() not NULL pointer. The NULL test in the return value
check should be replaced with IS_ERR().

dpatch engine is used to auto generated this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/clk/clk-fixed-rate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-fixed-rate.c b/drivers/clk/clk-fixed-rate.c
index f5ec0ee..af78ed6 100644
--- a/drivers/clk/clk-fixed-rate.c
+++ b/drivers/clk/clk-fixed-rate.c
@@ -97,7 +97,7 @@ void __init of_fixed_clk_setup(struct device_node *node)
 	of_property_read_string(node, "clock-output-names", &clk_name);
 
 	clk = clk_register_fixed_rate(NULL, clk_name, NULL, CLK_IS_ROOT, rate);
-	if (clk)
+	if (!IS_ERR(clk))
 		of_clk_add_provider(node, of_clk_src_simple_get, clk);
 }
 EXPORT_SYMBOL_GPL(of_fixed_clk_setup);


