Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740Ab2KAFd6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 01:33:58 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:40058 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab2KAFd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 01:33:56 -0400
MIME-Version: 1.0
Date: Thu, 1 Nov 2012 13:33:55 +0800
Message-ID: <CAPgLHd-LVhPkOHUWOwjmcsDA-4spfQMTxW9z2tB7fnEuS_5OOw@mail.gmail.com>
Subject: [PATCH -next] CLK: clk-twl6040: fix return value check in twl6040_clk_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: mturquette@ti.com, peter.ujfalusi@ti.com
Cc: yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function clk_register() returns ERR_PTR()
and never returns NULL. The NULL test in the return value check
should be replaced with IS_ERR().

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/clk/clk-twl6040.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk-twl6040.c b/drivers/clk/clk-twl6040.c
index f4a3389..bc1e713 100644
--- a/drivers/clk/clk-twl6040.c
+++ b/drivers/clk/clk-twl6040.c
@@ -92,8 +92,8 @@ static int __devinit twl6040_clk_probe(struct platform_device *pdev)
 
 	clkdata->mcpdm_fclk.init = &wm831x_clkout_init;
 	clkdata->clk = clk_register(&pdev->dev, &clkdata->mcpdm_fclk);
-	if (!clkdata->clk)
-		return -EINVAL;
+	if (IS_ERR(clkdata->clk))
+		return PTR_ERR(clkdata->clk);
 
 	dev_set_drvdata(&pdev->dev, clkdata);
 


