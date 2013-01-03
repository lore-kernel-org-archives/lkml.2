Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab3ACJe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 04:34:29 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:50938 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751178Ab3ACJe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 04:34:26 -0500
X-IronPort-AV: E=Sophos;i="4.84,402,1355094000"; 
   d="scan'208";a="188308017"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: kernel-janitors@vger.kernel.org,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] drivers/i2c/busses/i2c-sh7760.c: use clk API instead of direct dereferences
Date: Thu,  3 Jan 2013 11:34:19 +0100
Message-Id: <1357209260-15412-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

A struct clk value is intended to be an abstract pointer, so it should be
manipulated using the various API functions.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e,e1;
identifier i;
@@

*e = clk_get(...)
 ... when != e = e1
     when any
*e->i
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
I am not able to compile this code.  Furthermore, the documentation on
clk_get_rate says that the result is only valid if the clock has been
enabled, and I don't know if that is the case here.

 drivers/i2c/busses/i2c-sh7760.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-sh7760.c b/drivers/i2c/busses/i2c-sh7760.c
index 3a2253e..972eafe 100644
--- a/drivers/i2c/busses/i2c-sh7760.c
+++ b/drivers/i2c/busses/i2c-sh7760.c
@@ -401,7 +401,7 @@ static int calc_CCR(unsigned long scl_hz)
 	if (IS_ERR(mclk)) {
 		return PTR_ERR(mclk);
 	} else {
-		mck = mclk->rate;
+		mck = clk_get_rate(mclk);
 		clk_put(mclk);
 	}
 

