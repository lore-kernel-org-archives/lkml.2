Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab1AXTgX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 14:36:23 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:36283 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903Ab1AXTgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 14:36:19 -0500
From: Julia Lawall <julia@diku.dk>
To: Russell King <linux@arm.linux.org.uk>
Cc: kernel-janitors@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ryan Mallon <ryan@bluewatersys.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] arch/arm/mach-at91/clock.c: Add missing IS_ERR test
Date: Mon, 24 Jan 2011 20:55:20 +0100
Message-Id: <1295898922-18822-3-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295898922-18822-1-git-send-email-julia@diku.dk>
References: <1295898922-18822-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function clk_get, defined just below this code, returns ERR_PTR not NULL in
an error case.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
identifier f;
@@
f(...) { ... return ERR_PTR(...); }

@@
identifier r.f, fld;
expression x;
statement S1,S2;
@@
 x = f(...)
 ... when != IS_ERR(x)
(
 if (IS_ERR(x) ||...) S1 else S2
|
*x->fld
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/arm/mach-at91/clock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/clock.c b/arch/arm/mach-at91/clock.c
index 9113da6..c9ee6d0 100644
--- a/arch/arm/mach-at91/clock.c
+++ b/arch/arm/mach-at91/clock.c
@@ -224,7 +224,7 @@ void __init at91_clock_associate(const char *id, struct device *dev, const char
 {
 	struct clk *clk = clk_get(NULL, id);
 
-	if (!dev || !clk || !IS_ERR(clk_get(dev, func)))
+	if (!dev || IS_ERR(clk) || !IS_ERR(clk_get(dev, func)))
 		return;
 
 	clk->function = func;

