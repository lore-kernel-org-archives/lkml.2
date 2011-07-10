Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab1GJMGy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 08:06:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48792 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751971Ab1GJMGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 08:06:52 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] clk: Prototype and document clk_register()
Date: Sun, 10 Jul 2011 21:06:35 +0900
Message-Id: <1310299596-26137-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows the compiler to ensure drivers are using the correct prototype.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/clk.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/linux/clk.h b/include/linux/clk.h
index 7c26135..2ca4f66 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -136,6 +136,18 @@ extern struct clk_hw_ops clk_gate_ops;
 
 #endif /* CONFIG_GENERIC_CLK_GATE */
 
+/**
+ * clk_register - register and initialize a new clock
+ *
+ * @ops: ops for the new clock
+ * @hw: struct clk_hw to be passed to the ops of the new clock
+ * @name: name to use for the new clock
+ *
+ * Register a new clock with the clk subsytem.  Returns either a
+ * struct clk for the new clock or a NULL pointer.
+ */
+struct clk *clk_register(struct clk_hw_ops *ops, struct clk_hw *hw,
+			 const char *name);
 
 #else /* !CONFIG_GENERIC_CLK */
 
-- 
1.7.5.4

