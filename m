Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760020Ab2CUTPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 15:15:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59143 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752057Ab2CUTPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 15:15:21 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Turquette <mturquette@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] clk: Constify parent name arrays
Date: Wed, 21 Mar 2012 19:15:07 +0000
Message-Id: <1332357307-10693-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers should be able to declare their arrays of parent names as const
so the APIs need to accept const arguments.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

We should probably have a MAINTAINERS entry for the clk API...

 drivers/clk/clk-mux.c        |    2 +-
 drivers/clk/clk.c            |    2 +-
 include/linux/clk-private.h  |    2 +-
 include/linux/clk-provider.h |    4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/clk-mux.c b/drivers/clk/clk-mux.c
index c71ad1f..bf9f42e 100644
--- a/drivers/clk/clk-mux.c
+++ b/drivers/clk/clk-mux.c
@@ -91,7 +91,7 @@ struct clk_ops clk_mux_ops = {
 EXPORT_SYMBOL_GPL(clk_mux_ops);
 
 struct clk *clk_register_mux(struct device *dev, const char *name,
-		char **parent_names, u8 num_parents, unsigned long flags,
+		const char **parent_names, u8 num_parents, unsigned long flags,
 		void __iomem *reg, u8 shift, u8 width,
 		u8 clk_mux_flags, spinlock_t *lock)
 {
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 9cf6f59..33ef0df 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1322,7 +1322,7 @@ out:
  */
 struct clk *clk_register(struct device *dev, const char *name,
 		const struct clk_ops *ops, struct clk_hw *hw,
-		char **parent_names, u8 num_parents, unsigned long flags)
+		const char **parent_names, u8 num_parents, unsigned long flags)
 {
 	struct clk *clk;
 
diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
index 5e4312b..164e115 100644
--- a/include/linux/clk-private.h
+++ b/include/linux/clk-private.h
@@ -30,7 +30,7 @@ struct clk {
 	const struct clk_ops	*ops;
 	struct clk_hw		*hw;
 	struct clk		*parent;
-	char			**parent_names;
+	const char		**parent_names;
 	struct clk		**parents;
 	u8			num_parents;
 	unsigned long		rate;
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 5508897..1fa0b0d 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -253,7 +253,7 @@ struct clk_mux {
 #define CLK_MUX_INDEX_BIT		BIT(1)
 
 struct clk *clk_register_mux(struct device *dev, const char *name,
-		char **parent_names, u8 num_parents, unsigned long flags,
+		const char **parent_names, u8 num_parents, unsigned long flags,
 		void __iomem *reg, u8 shift, u8 width,
 		u8 clk_mux_flags, spinlock_t *lock);
 
@@ -274,7 +274,7 @@ struct clk *clk_register_mux(struct device *dev, const char *name,
  */
 struct clk *clk_register(struct device *dev, const char *name,
 		const struct clk_ops *ops, struct clk_hw *hw,
-		char **parent_names, u8 num_parents, unsigned long flags);
+		const char **parent_names, u8 num_parents, unsigned long flags);
 
 /* helper functions */
 const char *__clk_get_name(struct clk *clk);
-- 
1.7.9.1

