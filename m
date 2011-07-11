Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099Ab1GKDm6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 23:42:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49497 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757022Ab1GKDmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 23:42:55 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: Grant Likely <grant@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/6] clk: Prototype and document clk_register()
Date: Mon, 11 Jul 2011 11:53:52 +0900
Message-Id: <1310352837-4277-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <20110711025344.GA27497@opensource.wolfsonmicro.com>
References: <20110711025344.GA27497@opensource.wolfsonmicro.com>
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

