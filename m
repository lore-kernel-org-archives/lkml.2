Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934024Ab2DLBLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 21:11:38 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47199 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757172Ab2DLBI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 21:08:29 -0400
From: Mike Turquette <mturquette@linaro.org>
To: <arnd.bergmann@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linaro-dev@lists.linaro.org>, <patches@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Richard Zhao <richard.zhao@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Andrew Lunn <andrew@lunn.ch>, Rajendra Nayak <rnayak@ti.com>,
        Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH 02/13] clk: core: remove dead code paths
Date: Wed, 11 Apr 2012 18:02:40 -0700
Message-ID: <1334192572-12499-3-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1334192572-12499-1-git-send-email-mturquette@linaro.org>
References: <1334192572-12499-1-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some static inline dummy functions were left over from before the clock
core was consolidated from several C files down to one.  Remove them.

Reported-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Mike Turquette <mturquette@linaro.org>
Cc: Arnd Bergman <arnd.bergmann@linaro.org>
Cc: Olof Johansson <olof@lixom.net>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Richard Zhao <richard.zhao@linaro.org>
Cc: Saravana Kannan <skannan@codeaurora.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Rajendra Nayak <rnayak@ti.com>
Cc: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/clk/clk.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 3ed36d3..4daacf5 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -194,7 +194,7 @@ static int __init clk_debug_init(void)
 late_initcall(clk_debug_init);
 #else
 static inline int clk_debug_register(struct clk *clk) { return 0; }
-#endif /* CONFIG_COMMON_CLK_DEBUG */
+#endif
 
 #ifdef CONFIG_COMMON_CLK_DISABLE_UNUSED
 /* caller must hold prepare_lock */
@@ -246,9 +246,7 @@ static int clk_disable_unused(void)
 	return 0;
 }
 late_initcall(clk_disable_unused);
-#else
-static inline int clk_disable_unused(struct clk *clk) { return 0; }
-#endif /* CONFIG_COMMON_CLK_DISABLE_UNUSED */
+#endif
 
 /***    helper functions   ***/
 
-- 
1.7.5.4

