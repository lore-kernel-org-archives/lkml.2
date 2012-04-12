Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933612Ab2DLBIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 21:08:42 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43201 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933583Ab2DLBIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 21:08:39 -0400
From: Mike Turquette <mturquette@linaro.org>
To: <arnd.bergmann@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linaro-dev@lists.linaro.org>, <patches@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Turquette <mturquette@linaro.org>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>, Andrew Lunn <andrew@lunn.ch>,
        Rajendra Nayak <rnayak@ti.com>, Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH 11/13] clk: Constify parent name arrays
Date: Wed, 11 Apr 2012 18:02:49 -0700
Message-ID: <1334192572-12499-12-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1334192572-12499-1-git-send-email-mturquette@linaro.org>
References: <1334192572-12499-1-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

Drivers should be able to declare their arrays of parent names as const
so the APIs need to accept const arguments.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
[mturquette@linaro.org: constified gate]
Signed-off-by: Mike Turquette <mturquette@linaro.org>
Cc: Arnd Bergman <arnd.bergmann@linaro.org>
Cc: Olof Johansson <olof@lixom.net>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Shawn Guo <shawn.guo@freescale.com>
Cc: Richard Zhao <richard.zhao@linaro.org>
Cc: Saravana Kannan <skannan@codeaurora.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Rajendra Nayak <rnayak@ti.com>
Cc: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/clk/clk-mux.c        |    2 +-
 drivers/clk/clk.c            |    2 +-
 include/linux/clk-private.h  |    2 +-
 include/linux/clk-provider.h |    8 ++++----
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/clk/clk-mux.c b/drivers/clk/clk-mux.c
index 5424488..bd5e598 100644
--- a/drivers/clk/clk-mux.c
+++ b/drivers/clk/clk-mux.c
@@ -89,7 +89,7 @@ const struct clk_ops clk_mux_ops = {
 EXPORT_SYMBOL_GPL(clk_mux_ops);
 
 struct clk *clk_register_mux(struct device *dev, const char *name,
-		char **parent_names, u8 num_parents, unsigned long flags,
+		const char **parent_names, u8 num_parents, unsigned long flags,
 		void __iomem *reg, u8 shift, u8 width,
 		u8 clk_mux_flags, spinlock_t *lock)
 {
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index a24b121..ddade87 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1328,7 +1328,7 @@ out:
  */
 struct clk *clk_register(struct device *dev, const char *name,
 		const struct clk_ops *ops, struct clk_hw *hw,
-		char **parent_names, u8 num_parents, unsigned long flags)
+		const char **parent_names, u8 num_parents, unsigned long flags)
 {
 	struct clk *clk;
 
diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
index f19fee0..e9c8b98 100644
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
index 6eb8e5d..8981435 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -176,7 +176,7 @@ struct clk_gate {
 	u8		bit_idx;
 	u8		flags;
 	spinlock_t	*lock;
-	char		*parent[1];
+	const char	*parent[1];
 };
 
 #define CLK_GATE_SET_TO_DISABLE		BIT(0)
@@ -214,7 +214,7 @@ struct clk_divider {
 	u8		width;
 	u8		flags;
 	spinlock_t	*lock;
-	char		*parent[1];
+	const char	*parent[1];
 };
 
 #define CLK_DIVIDER_ONE_BASED		BIT(0)
@@ -257,7 +257,7 @@ struct clk_mux {
 
 extern const struct clk_ops clk_mux_ops;
 struct clk *clk_register_mux(struct device *dev, const char *name,
-		char **parent_names, u8 num_parents, unsigned long flags,
+		const char **parent_names, u8 num_parents, unsigned long flags,
 		void __iomem *reg, u8 shift, u8 width,
 		u8 clk_mux_flags, spinlock_t *lock);
 
@@ -278,7 +278,7 @@ struct clk *clk_register_mux(struct device *dev, const char *name,
  */
 struct clk *clk_register(struct device *dev, const char *name,
 		const struct clk_ops *ops, struct clk_hw *hw,
-		char **parent_names, u8 num_parents, unsigned long flags);
+		const char **parent_names, u8 num_parents, unsigned long flags);
 
 /* helper functions */
 const char *__clk_get_name(struct clk *clk);
-- 
1.7.5.4

