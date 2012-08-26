Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab2HZQBa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 12:01:30 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:39077
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754065Ab2HZQBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 12:01:21 -0400
X-IronPort-AV: E=Sophos;i="4.80,315,1344204000"; 
   d="scan'208";a="153852301"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: kernel-janitors@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        linux-arm-kernel@lists.infradead.org, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 13/13] drivers/rtc/rtc-coh901331.c: use clk_prepare_enable and clk_disable_unprepare
Date: Sun, 26 Aug 2012 18:01:05 +0200
Message-Id: <1345996865-32082-14-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1345996865-32082-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1345996865-32082-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Clk_prepare_enable and clk_disable_unprepare combine clk_prepare and
clk_enable, and clk_disable and clk_unprepare.  They make the code more
concise, and ensure that clk_unprepare is called when clk_enable fails.

A simplified version of the semantic patch that introduces calls to these
functions is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e;
@@

- clk_prepare(e);
- clk_enable(e);
+ clk_prepare_enable(e);

@@
expression e;
@@

- clk_disable(e);
- clk_unprepare(e);
+ clk_disable_unprepare(e);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
I'm not sure about this.  Maybe it would be better to leave the disable and
unprepare separated, since there is no matching nearby clk_prepare.

 drivers/rtc/rtc-coh901331.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-coh901331.c b/drivers/rtc/rtc-coh901331.c
index 76b2156..c8115b8 100644
--- a/drivers/rtc/rtc-coh901331.c
+++ b/drivers/rtc/rtc-coh901331.c
@@ -276,8 +276,7 @@ static void coh901331_shutdown(struct platform_device *pdev)
 
 	clk_enable(rtap->clk);
 	writel(0, rtap->virtbase + COH901331_IRQ_MASK);
-	clk_disable(rtap->clk);
-	clk_unprepare(rtap->clk);
+	clk_disable_unprepare(rtap->clk);
 }
 
 static struct platform_driver coh901331_driver = {

