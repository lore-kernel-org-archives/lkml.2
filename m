Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009Ab2DRIH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 04:07:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49594 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751086Ab2DRIHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 04:07:18 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Turquette <mturquette@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] clk: Provide dummy clk_unregister()
Date: Wed, 18 Apr 2012 09:07:12 +0100
Message-Id: <1334736433-3402-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While there's no actual implementation behind it having the call to use
in drivers makes them feel neater from a driver author point of view. An
actual implementation can wait for someone who needs to use the function
in a real system.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/clk/clk.c            |   12 ++++++++++++
 include/linux/clk-provider.h |    1 +
 2 files changed, 13 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 33ef0df..31419ca 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1344,6 +1344,18 @@ struct clk *clk_register(struct device *dev, const char *name,
 }
 EXPORT_SYMBOL_GPL(clk_register);
 
+/**
+ * clk_unregister - unregister a currently registered clock
+ * @clk: clock to unregister
+ *
+ * Currently unimplemented.
+ */
+int clk_unregister(struct clk *clk)
+{
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(clk_unregister);
+
 /***        clk rate change notifiers        ***/
 
 /**
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 340acbc..57c0bd1 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -275,6 +275,7 @@ struct clk *clk_register_mux(struct device *dev, const char *name,
 struct clk *clk_register(struct device *dev, const char *name,
 		const struct clk_ops *ops, struct clk_hw *hw,
 		const char **parent_names, u8 num_parents, unsigned long flags);
+int clk_unregister(struct clk *clk);
 
 /* helper functions */
 const char *__clk_get_name(struct clk *clk);
-- 
1.7.10

