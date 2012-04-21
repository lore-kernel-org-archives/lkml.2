Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab2DULwS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 07:52:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42984 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab2DULwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 07:52:16 -0400
From: Viresh Kumar <viresh.linux@gmail.com>
To: akpm@linux-foundation.org
Cc: spear-devel@list.st.com, viresh.linux@gmail.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        mturquette@linaro.org, sshtylyov@mvista.com, jgarzik@redhat.com,
        Viresh Kumar <viresh.kumar@st.com>,
        Wolfram Sang <w.sang@pengutronix.de>, linux-i2c@vger.kernel.org
Subject: [PATCH 06/13] i2c/i2c-pxa: Remove conditional compilation of clk code
Date: Sat, 21 Apr 2012 17:17:33 +0530
Message-Id: <dc3d8fd0eeee7a93048ed2b1d6ed0c1cfe9e3ba0.1335008617.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <cover.1335008617.git.viresh.kumar@st.com>
References: <cover.1335008617.git.viresh.kumar@st.com>
In-Reply-To: <cover.1335008617.git.viresh.kumar@st.com>
References: <cover.1335008617.git.viresh.kumar@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With addition of dummy clk_*() calls for non CONFIG_HAVE_CLK cases in clk.h,
there is no need to have clk code enclosed in #ifdef CONFIG_HAVE_CLK, #endif
macros.

pxa i2c also has these dummy macros defined locally. Remove them as they aren't
required anymore.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-i2c@vger.kernel.org
---
 drivers/i2c/busses/i2c-pxa.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
index f673326..5fab849 100644
--- a/drivers/i2c/busses/i2c-pxa.c
+++ b/drivers/i2c/busses/i2c-pxa.c
@@ -41,13 +41,6 @@
 
 #include <asm/irq.h>
 
-#ifndef CONFIG_HAVE_CLK
-#define clk_get(dev, id)	NULL
-#define clk_put(clk)		do { } while (0)
-#define clk_disable(clk)	do { } while (0)
-#define clk_enable(clk)		do { } while (0)
-#endif
-
 struct pxa_reg_layout {
 	u32 ibmr;
 	u32 idbr;
-- 
1.7.9

