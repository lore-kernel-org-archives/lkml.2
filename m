Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737Ab2IUGO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 02:14:27 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:47128 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310Ab2IUGO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 02:14:26 -0400
MIME-Version: 1.0
Date: Fri, 21 Sep 2012 14:14:25 +0800
Message-ID: <CAPgLHd-0wYjWxWrmLdc+an0RVfEicv3QBEtvsuvQtphti3phdw@mail.gmail.com>
Subject: [PATCH] ARM: imx: fix the return value check in imx_clk_busy_divider()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: kernel@pengutronix.de, linux@arm.linux.org.uk
Cc: yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function clk_register() returns ERR_PTR()
no NULL pointer. The NULL test in the return value check should
be replaced with IS_ERR().

dpatch engine is used to auto generated this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 arch/arm/mach-imx/clk-busy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/clk-busy.c b/arch/arm/mach-imx/clk-busy.c
index 1a7a8dd..1ab91b5 100644
--- a/arch/arm/mach-imx/clk-busy.c
+++ b/arch/arm/mach-imx/clk-busy.c
@@ -108,7 +108,7 @@ struct clk *imx_clk_busy_divider(const char *name, const char *parent_name,
 	busy->div.hw.init = &init;
 
 	clk = clk_register(NULL, &busy->div.hw);
-	if (!clk)
+	if (IS_ERR(clk))
 		kfree(busy);
 
 	return clk;


