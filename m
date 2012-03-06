Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894Ab2CFWGN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 17:06:13 -0500
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:60632 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759349Ab2CFWGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 17:06:10 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4/4] ARM: u300: configure some pins as an example
Date: Tue, 6 Mar 2012 23:05:47 +0100
Message-ID: <1331071547-25109-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.8
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

To show how the pin configuration is used on the U300, let's
include some configs for two GPIO pins.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-u300/core.c |   25 +++++++++++++++++++++++--
 1 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-u300/core.c b/arch/arm/mach-u300/core.c
index f326d31..ab48547 100644
--- a/arch/arm/mach-u300/core.c
+++ b/arch/arm/mach-u300/core.c
@@ -27,6 +27,7 @@
 #include <linux/mtd/fsmc.h>
 #include <linux/pinctrl/machine.h>
 #include <linux/pinctrl/consumer.h>
+#include <linux/pinctrl/pinconf-generic.h>
 #include <linux/dma-mapping.h>
 
 #include <asm/types.h>
@@ -1605,7 +1606,23 @@ static struct platform_device dma_device = {
 	},
 };
 
-/* Pinmux settings */
+static unsigned long g0d_conf[] = {
+	PIN_CONF_PACKED(PIN_CONFIG_BIAS_PULL_UP, 0),
+};
+
+static unsigned long g1d_conf[] = {
+	PIN_CONF_PACKED(PIN_CONFIG_BIAS_PULL_UP, 0),
+};
+
+static unsigned long g0i_conf[] = {
+	PIN_CONF_PACKED(PIN_CONFIG_BIAS_PULL_UP, 0),
+};
+
+static unsigned long g1i_conf[] = {
+	PIN_CONF_PACKED(PIN_CONFIG_BIAS_PULL_UP, 0),
+};
+
+/* Pin control settings */
 static struct pinctrl_map __initdata u300_pinmux_map[] = {
 	/* anonymous maps for chip power and EMIFs */
 	PIN_MAP_MUX_GROUP_HOG_DEFAULT("pinctrl-u300", NULL, "power"),
@@ -1615,6 +1632,11 @@ static struct pinctrl_map __initdata u300_pinmux_map[] = {
 	PIN_MAP_MUX_GROUP_DEFAULT("mmci",  "pinctrl-u300", NULL, "mmc0"),
 	PIN_MAP_MUX_GROUP_DEFAULT("pl022", "pinctrl-u300", NULL, "spi0"),
 	PIN_MAP_MUX_GROUP_DEFAULT("uart0", "pinctrl-u300", NULL, "uart0"),
+	/* some pin configurations */
+	PIN_MAP_CONFIGS_PIN_DEFAULT("mmci", "pinctrl-u300", "GPIO0", g0d_conf),
+	PIN_MAP_CONFIGS_PIN_DEFAULT("mmci", "pinctrl-u300", "GPIO1", g1d_conf),
+	PIN_MAP_CONFIGS_PIN("mmci", "idle", "pinctrl-u300", "GPIO0", g0i_conf),
+	PIN_MAP_CONFIGS_PIN("mmci", "idle", "pinctrl-u300", "GPIO1", g1i_conf),
 };
 
 struct u300_mux_hog {
@@ -1640,7 +1662,6 @@ static int __init u300_pinctrl_fetch(void)
 
 	for (i = 0; i < ARRAY_SIZE(u300_mux_hogs); i++) {
 		struct pinctrl *p;
-		int ret;
 
 		p = pinctrl_get_select_default(u300_mux_hogs[i].dev);
 		if (IS_ERR(p)) {
-- 
1.7.8

