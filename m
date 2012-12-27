Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759Ab2L0AOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 19:14:48 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:62819 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab2L0AOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 19:14:42 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH 1/3] clk: vt8500: Fix error in PLL calculations on non-exact match.
Date: Thu, 27 Dec 2012 13:14:29 +1300
Message-Id: <1356567272-3420-2-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1356567272-3420-1-git-send-email-linux@prisktech.co.nz>
References: <1356567272-3420-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a PLL frequency calculation is performed and a non-exact match
is found the wrong multiplier and divisors are returned.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 drivers/clk/clk-vt8500.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/clk-vt8500.c b/drivers/clk/clk-vt8500.c
index fe25570..0cb26be 100644
--- a/drivers/clk/clk-vt8500.c
+++ b/drivers/clk/clk-vt8500.c
@@ -361,9 +361,9 @@ static void wm8650_find_pll_bits(unsigned long rate, unsigned long parent_rate,
 	/* if we got here, it wasn't an exact match */
 	pr_warn("%s: requested rate %lu, found rate %lu\n", __func__, rate,
 							rate - best_err);
-	*multiplier = mul;
-	*divisor1 = div1;
-	*divisor2 = div2;
+	*multiplier = best_mul;
+	*divisor1 = best_div1;
+	*divisor2 = best_div2;
 }
 
 static int vtwm_pll_set_rate(struct clk_hw *hw, unsigned long rate,
-- 
1.7.9.5

