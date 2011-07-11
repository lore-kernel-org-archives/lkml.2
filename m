Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043Ab1GKDnW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 23:43:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49515 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757068Ab1GKDnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 23:43:17 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: Grant Likely <grant@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/6] clk: Constify struct clk_hw_ops
Date: Mon, 11 Jul 2011 11:53:54 +0900
Message-Id: <1310352837-4277-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1310352837-4277-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20110711025344.GA27497@opensource.wolfsonmicro.com>
 <1310352837-4277-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/clk/clk.c   |    4 ++--
 include/linux/clk.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 3a4d70e..1df6e23 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -16,7 +16,7 @@
 
 struct clk {
 	const char		*name;
-	struct clk_hw_ops	*ops;
+	const struct clk_hw_ops	*ops;
 	struct clk_hw		*hw;
 	unsigned int		enable_count;
 	unsigned int		prepare_count;
@@ -252,7 +252,7 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
 }
 EXPORT_SYMBOL_GPL(clk_set_parent);
 
-struct clk *clk_register(struct clk_hw_ops *ops, struct clk_hw *hw,
+struct clk *clk_register(const struct clk_hw_ops *ops, struct clk_hw *hw,
 		const char *name)
 {
 	struct clk *clk;
diff --git a/include/linux/clk.h b/include/linux/clk.h
index df5c64f..fb5e435 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -146,7 +146,7 @@ extern struct clk_hw_ops clk_gate_ops;
  * Register a new clock with the clk subsytem.  Returns either a
  * struct clk for the new clock or a NULL pointer.
  */
-struct clk *clk_register(struct clk_hw_ops *ops, struct clk_hw *hw,
+struct clk *clk_register(const struct clk_hw_ops *ops, struct clk_hw *hw,
 			 const char *name);
 
 /**
-- 
1.7.5.4

