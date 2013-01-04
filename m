Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab3ADHBn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 02:01:43 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18324 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702Ab3ADHBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 02:01:39 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 03 Jan 2013 22:58:52 -0800
From: Prashant Gaikwad <pgaikwad@nvidia.com>
To: <mturquette@linaro.org>, <swarren@nvidia.com>, <grant.likely@secretlab.ca>,
        <linus.walleij@linaro.org>, <rob.herring@calxeda.com>,
        <maxime.ripard@free-electrons.com>, <linux@prisktech.co.nz>,
        <josh.cartwright@ni.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: [PATCH 3/7] clk: sunxi: Use common of_clk_init() function
Date: Fri, 4 Jan 2013 12:30:54 +0530
Message-ID: <1357282858-2112-3-git-send-email-pgaikwad@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357282858-2112-1-git-send-email-pgaikwad@nvidia.com>
References: <1357282858-2112-1-git-send-email-pgaikwad@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use common of_clk_init() function to initialize clocks.

Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
---
 drivers/clk/clk-sunxi.c           |   30 ------------------------------
 drivers/clocksource/sunxi_timer.c |    4 ++--
 include/linux/clk/sunxi.h         |   22 ----------------------
 3 files changed, 2 insertions(+), 54 deletions(-)
 delete mode 100644 drivers/clk/clk-sunxi.c
 delete mode 100644 include/linux/clk/sunxi.h

diff --git a/drivers/clk/clk-sunxi.c b/drivers/clk/clk-sunxi.c
deleted file mode 100644
index 0e831b5..0000000
--- a/drivers/clk/clk-sunxi.c
+++ /dev/null
@@ -1,30 +0,0 @@
-/*
- * Copyright 2012 Maxime Ripard
- *
- * Maxime Ripard <maxime.ripard@free-electrons.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#include <linux/clk-provider.h>
-#include <linux/clkdev.h>
-#include <linux/clk/sunxi.h>
-#include <linux/of.h>
-
-static const __initconst struct of_device_id clk_match[] = {
-	{ .compatible = "fixed-clock", .data = of_fixed_clk_setup, },
-	{}
-};
-
-void __init sunxi_init_clocks(void)
-{
-	of_clk_init(clk_match);
-}
diff --git a/drivers/clocksource/sunxi_timer.c b/drivers/clocksource/sunxi_timer.c
index 6c2ed56..08e1756 100644
--- a/drivers/clocksource/sunxi_timer.c
+++ b/drivers/clocksource/sunxi_timer.c
@@ -23,7 +23,7 @@
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <linux/sunxi_timer.h>
-#include <linux/clk/sunxi.h>
+#include <linux/clk-provider.h>
 
 #define TIMER_CTL_REG		0x00
 #define TIMER_CTL_ENABLE		(1 << 0)
@@ -124,7 +124,7 @@ void __init sunxi_timer_init(void)
 	if (irq <= 0)
 		panic("Can't parse IRQ");
 
-	sunxi_init_clocks();
+	of_clk_init(NULL);
 
 	clk = of_clk_get(node, 0);
 	if (IS_ERR(clk))
diff --git a/include/linux/clk/sunxi.h b/include/linux/clk/sunxi.h
deleted file mode 100644
index e074fdd..0000000
--- a/include/linux/clk/sunxi.h
+++ /dev/null
@@ -1,22 +0,0 @@
-/*
- * Copyright 2012 Maxime Ripard
- *
- * Maxime Ripard <maxime.ripard@free-electrons.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#ifndef __LINUX_CLK_SUNXI_H_
-#define __LINUX_CLK_SUNXI_H_
-
-void __init sunxi_init_clocks(void);
-
-#endif
-- 
1.7.4.1

