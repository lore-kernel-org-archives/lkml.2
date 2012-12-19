Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab2LSRUF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 12:20:05 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:49057 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714Ab2LSRT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 12:19:56 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 3/4] clk: ux500: Provide an alias for the SMSC911x Ethernet chip
Date: Wed, 19 Dec 2012 17:19:46 +0000
Message-Id: <1355937587-31730-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355937587-31730-1-git-send-email-lee.jones@linaro.org>
References: <1355937587-31730-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case of some of the ux500 platforms, an Ethernet chip is
placed on an extended bus which is traditionally used as a NAND
flash chip placeholder. The p3_pclk0 clock is used to control it,
so we are required to provide and easy way to access it from the
SMSC911x driver. We do this using an alias provided by this patch.

Cc: Mike Turquette <mturquette@linaro.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/clk/ux500/u8500_clk.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/ux500/u8500_clk.c b/drivers/clk/ux500/u8500_clk.c
index a601802..9d9add1 100644
--- a/drivers/clk/ux500/u8500_clk.c
+++ b/drivers/clk/ux500/u8500_clk.c
@@ -325,6 +325,7 @@ void u8500_clk_init(void)
 	clk = clk_reg_prcc_pclk("p3_pclk0", "per3clk", U8500_CLKRST3_BASE,
 				BIT(0), 0);
 	clk_register_clkdev(clk, "fsmc", NULL);
+	clk_register_clkdev(clk, NULL, "smsc911x");
 
 	clk = clk_reg_prcc_pclk("p3_pclk1", "per3clk", U8500_CLKRST3_BASE,
 				BIT(1), 0);
-- 
1.7.9.5

