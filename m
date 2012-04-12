Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933973Ab2DLBKD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 21:10:03 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55556 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933625Ab2DLBIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 21:08:49 -0400
From: Mike Turquette <mturquette@linaro.org>
To: <arnd.bergmann@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linaro-dev@lists.linaro.org>, <patches@linaro.org>,
        Rajendra Nayak <rnayak@ti.com>, Mike Turquette <mturquette@linaro.org>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Andrew Lunn <andrew@lunn.ch>, Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH 09/13] clk: Make clk_get_rate() return 0 on error
Date: Wed, 11 Apr 2012 18:02:47 -0700
Message-ID: <1334192572-12499-10-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1334192572-12499-1-git-send-email-mturquette@linaro.org>
References: <1334192572-12499-1-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rajendra Nayak <rnayak@ti.com>

Most users of clk_get_rate() actually assume a non zero
return value as a valid rate returned. Returing -EINVAL
might confuse such users, so make it instead return zero
on error.

Besides the return value of clk_get_rate seems to be
'unsigned long'.

Signed-off-by: Rajendra nayak <rnayak@ti.com>
Signed-off-by: Mike Turquette <mturquette@linaro.org>
Cc: Arnd Bergman <arnd.bergmann@linaro.org>
Cc: Olof Johansson <olof@lixom.net>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Shawn Guo <shawn.guo@freescale.com>
Cc: Richard Zhao <richard.zhao@linaro.org>
Cc: Saravana Kannan <skannan@codeaurora.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/clk/clk.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 9924aec..a24b121 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -285,7 +285,7 @@ unsigned long __clk_get_rate(struct clk *clk)
 	unsigned long ret;
 
 	if (!clk) {
-		ret = -EINVAL;
+		ret = 0;
 		goto out;
 	}
 
@@ -295,7 +295,7 @@ unsigned long __clk_get_rate(struct clk *clk)
 		goto out;
 
 	if (!clk->parent)
-		ret = -ENODEV;
+		ret = 0;
 
 out:
 	return ret;
@@ -560,7 +560,7 @@ EXPORT_SYMBOL_GPL(clk_enable);
  * @clk: the clk whose rate is being returned
  *
  * Simply returns the cached rate of the clk.  Does not query the hardware.  If
- * clk is NULL then returns -EINVAL.
+ * clk is NULL then returns 0.
  */
 unsigned long clk_get_rate(struct clk *clk)
 {
-- 
1.7.5.4

