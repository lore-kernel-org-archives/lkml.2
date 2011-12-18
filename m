Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab1LRWrt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 17:47:49 -0500
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:40258 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751945Ab1LRWrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 17:47:46 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rongjun Ying <Rongjun.Ying@csr.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: [PATCH] pinctrl: rename U300 ans SIRF pin controllers
Date: Sun, 18 Dec 2011 23:47:05 +0100
Message-ID: <1324248425-26552-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.8
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

For stringen order, rename the pinmux-* pin controllers to
pinctrl-* and also rename the Kconfig symbols and in-kernel
users.

Cc: Rongjun Ying <Rongjun.Ying@csr.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-u300/Kconfig                        |    2 +-
 drivers/pinctrl/Kconfig                           |    8 ++++----
 drivers/pinctrl/Makefile                          |    4 ++--
 drivers/pinctrl/{pinmux-sirf.c => pinctrl-sirf.c} |    0
 drivers/pinctrl/{pinmux-u300.c => pinctrl-u300.c} |    0
 5 files changed, 7 insertions(+), 7 deletions(-)
 rename drivers/pinctrl/{pinmux-sirf.c => pinctrl-sirf.c} (100%)
 rename drivers/pinctrl/{pinmux-u300.c => pinctrl-u300.c} (100%)

diff --git a/arch/arm/mach-u300/Kconfig b/arch/arm/mach-u300/Kconfig
index c2d5c6c..54d8f34 100644
--- a/arch/arm/mach-u300/Kconfig
+++ b/arch/arm/mach-u300/Kconfig
@@ -7,7 +7,7 @@ comment "ST-Ericsson Mobile Platform Products"
 config MACH_U300
 	bool "U300"
 	select PINCTRL
-	select PINMUX_U300
+	select PINCTRL_U300
 	select PINCTRL_COH901
 
 comment "ST-Ericsson U300/U330/U335/U365 Feature Selections"
diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index c63c721..afaf885 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -23,13 +23,13 @@ config DEBUG_PINCTRL
 	help
 	  Say Y here to add some extra checks and diagnostics to PINCTRL calls.
 
-config PINMUX_SIRF
-	bool "CSR SiRFprimaII pinmux driver"
+config PINCTRL_SIRF
+	bool "CSR SiRFprimaII pin controller driver"
 	depends on ARCH_PRIMA2
 	select PINMUX
 
-config PINMUX_U300
-	bool "U300 pinmux driver"
+config PINCTRL_U300
+	bool "U300 pin controller driver"
 	depends on ARCH_U300
 	select PINMUX
 
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index c046f78..827601c 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -5,6 +5,6 @@ ccflags-$(CONFIG_DEBUG_PINCTRL)	+= -DDEBUG
 obj-$(CONFIG_PINCTRL)		+= core.o
 obj-$(CONFIG_PINMUX)		+= pinmux.o
 obj-$(CONFIG_PINCONF)		+= pinconf.o
-obj-$(CONFIG_PINMUX_SIRF)	+= pinmux-sirf.o
-obj-$(CONFIG_PINMUX_U300)	+= pinmux-u300.o
+obj-$(CONFIG_PINCTRL_SIRF)	+= pinctrl-sirf.o
+obj-$(CONFIG_PINCTRL_U300)	+= pinctrl-u300.o
 obj-$(CONFIG_PINCTRL_COH901)	+= pinctrl-coh901.o
diff --git a/drivers/pinctrl/pinmux-sirf.c b/drivers/pinctrl/pinctrl-sirf.c
similarity index 100%
rename from drivers/pinctrl/pinmux-sirf.c
rename to drivers/pinctrl/pinctrl-sirf.c
diff --git a/drivers/pinctrl/pinmux-u300.c b/drivers/pinctrl/pinctrl-u300.c
similarity index 100%
rename from drivers/pinctrl/pinmux-u300.c
rename to drivers/pinctrl/pinctrl-u300.c
-- 
1.7.8

