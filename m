Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076Ab1GKDmw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 23:42:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49483 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757032Ab1GKDmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 23:42:46 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: Grant Likely <grant@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/6] clk: Provide a dummy clk_unregister()
Date: Mon, 11 Jul 2011 11:53:53 +0900
Message-Id: <1310352837-4277-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1310352837-4277-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20110711025344.GA27497@opensource.wolfsonmicro.com>
 <1310352837-4277-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even though unregistration is not actually supported by the clk API it is
still useful to provide a clk_unregister() so that drivers can implement
their unregistration code. This saves having to go back later and update
them once unregistration is possible.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/clk.h |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/include/linux/clk.h b/include/linux/clk.h
index 2ca4f66..df5c64f 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -149,6 +149,21 @@ extern struct clk_hw_ops clk_gate_ops;
 struct clk *clk_register(struct clk_hw_ops *ops, struct clk_hw *hw,
 			 const char *name);
 
+/**
+ * clk_unregister - remove a clock
+ *
+ * @clk: clock to unregister
+ *
+ * Remove a clock from the clk subsystem.  This is currently not
+ * implemented but is provided to allow unregistration code to be
+ * written in drivers ready for use when an implementation is
+ * provided.
+ */
+static inline int clk_unregister(struct clk *clk)
+{
+	return -ENOTSUPP;
+}
+
 #else /* !CONFIG_GENERIC_CLK */
 
 /*
-- 
1.7.5.4

