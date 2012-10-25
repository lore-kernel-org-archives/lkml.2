Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946044Ab2JYPCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 11:02:20 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:48800 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757110Ab2JYPCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 11:02:18 -0400
MIME-Version: 1.0
Date: Thu, 25 Oct 2012 23:02:18 +0800
Message-ID: <CAPgLHd9Q3bZVth2NSxwH6kBpPsBmRGD+4pfZRpWL69KCw4HY4g@mail.gmail.com>
Subject: [PATCH] ARM i.MX: fix error-valued pointer dereference in clk_register_gate2()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: kernel@pengutronix.de, linux@arm.linux.org.uk
Cc: yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The error-valued pointer clk is used for the arg of kfree, it should be
kfree(gate) if clk_register() return ERR_PTR().

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 arch/arm/mach-imx/clk-gate2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/clk-gate2.c b/arch/arm/mach-imx/clk-gate2.c
index 3c1b8ff..cc49c7a 100644
--- a/arch/arm/mach-imx/clk-gate2.c
+++ b/arch/arm/mach-imx/clk-gate2.c
@@ -112,7 +112,7 @@ struct clk *clk_register_gate2(struct device *dev, const char *name,
 
 	clk = clk_register(dev, &gate->hw);
 	if (IS_ERR(clk))
-		kfree(clk);
+		kfree(gate);
 
 	return clk;
 }


