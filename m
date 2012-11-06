Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933648Ab2KFCfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 21:35:25 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:46916 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933609Ab2KFCfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 21:35:24 -0500
Message-ID: <1352169260.2625.4.camel@phoenix>
Subject: [PATCH] clk: spear: Add stub functions for spear3[0|1|2]0_clk_init()
From: Axel Lin <axel.lin@ingics.com>
To: Viresh Kumar <viresh.linux@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        spear-devel@list.st.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Tue, 06 Nov 2012 10:34:20 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes compile error if one of SPEAr3xx implementations is not selected.

  CC      drivers/clk/spear/spear3xx_clock.o
drivers/clk/spear/spear3xx_clock.c: In function 'spear3xx_clk_init':
drivers/clk/spear/spear3xx_clock.c:599:3: error: implicit declaration of function 'spear300_clk_init' [-Werror=implicit-function-declaration]
drivers/clk/spear/spear3xx_clock.c:601:3: error: implicit declaration of function 'spear310_clk_init' [-Werror=implicit-function-declaration]
drivers/clk/spear/spear3xx_clock.c:603:3: error: implicit declaration of function 'spear320_clk_init' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[3]: *** [drivers/clk/spear/spear3xx_clock.o] Error 1
make[2]: *** [drivers/clk/spear] Error 2
make[1]: *** [drivers/clk] Error 2
make: *** [drivers] Error 2

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/clk/spear/spear3xx_clock.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/clk/spear/spear3xx_clock.c b/drivers/clk/spear/spear3xx_clock.c
index c315745..59049cf 100644
--- a/drivers/clk/spear/spear3xx_clock.c
+++ b/drivers/clk/spear/spear3xx_clock.c
@@ -157,6 +157,8 @@ static void __init spear300_clk_init(void)
 			1);
 	clk_register_clkdev(clk, NULL, "a0000000.kbd");
 }
+#else
+static inline void spear300_clk_init(void) { }
 #endif
 
 /* array of all spear 310 clock lookups */
@@ -197,6 +199,8 @@ static void __init spear310_clk_init(void)
 			1);
 	clk_register_clkdev(clk, NULL, "b2200000.serial");
 }
+#else
+static inline void spear310_clk_init(void) { }
 #endif
 
 /* array of all spear 320 clock lookups */
@@ -336,6 +340,8 @@ static void __init spear320_clk_init(void)
 			&_lock);
 	clk_register_clkdev(clk, NULL, "60100000.serial");
 }
+#else
+static inline void spear320_clk_init(void) { }
 #endif
 
 void __init spear3xx_clk_init(void)
-- 
1.7.9.5




