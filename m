Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738Ab2DPXvO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 19:51:14 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55433 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab2DPXvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 19:51:10 -0400
From: Robert Lee <rob.lee@linaro.org>
To: kernel@pengutronix.de
Cc: shawn.guo@linaro.org, amit.kucheria@linaro.org, daniel.lezcano@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Subject: [PATCH 3/3] ARM: imx: Add imx6q cpuidle driver
Date: Mon, 16 Apr 2012 18:50:14 -0500
Message-Id: <1334620214-25803-4-git-send-email-rob.lee@linaro.org>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1334620214-25803-1-git-send-email-rob.lee@linaro.org>
References: <1334620214-25803-1-git-send-email-rob.lee@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add basic imx6q cpuidle driver.  For now, only basic WFI state is
supported.  Deeper idle states will be added in the future.

Signed-off-by: Robert Lee <rob.lee@linaro.org>
---
 arch/arm/mach-imx/Makefile        |    2 +-
 arch/arm/mach-imx/cpuidle-imx6q.c |   33 +++++++++++++++++++++++++++++++++
 arch/arm/mach-imx/mach-imx6q.c    |    2 ++
 3 files changed, 36 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/mach-imx/cpuidle-imx6q.c

diff --git a/arch/arm/mach-imx/Makefile b/arch/arm/mach-imx/Makefile
index 84b8976..530f0fd 100644
--- a/arch/arm/mach-imx/Makefile
+++ b/arch/arm/mach-imx/Makefile
@@ -70,7 +70,7 @@ obj-$(CONFIG_CPU_V7) += head-v7.o
 AFLAGS_head-v7.o :=-Wa,-march=armv7-a
 obj-$(CONFIG_SMP) += platsmp.o
 obj-$(CONFIG_HOTPLUG_CPU) += hotplug.o
-obj-$(CONFIG_SOC_IMX6Q) += clock-imx6q.o mach-imx6q.o
+obj-$(CONFIG_SOC_IMX6Q) += clock-imx6q.o mach-imx6q.o cpuidle-imx6q.o
 
 ifeq ($(CONFIG_PM),y)
 obj-$(CONFIG_SOC_IMX6Q) += pm-imx6q.o
diff --git a/arch/arm/mach-imx/cpuidle-imx6q.c b/arch/arm/mach-imx/cpuidle-imx6q.c
new file mode 100644
index 0000000..b74557f
--- /dev/null
+++ b/arch/arm/mach-imx/cpuidle-imx6q.c
@@ -0,0 +1,33 @@
+/*
+ * Copyright 2012 Freescale Semiconductor, Inc.
+ * Copyright 2012 Linaro Ltd.
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/cpuidle.h>
+#include <linux/export.h>
+#include <asm/cpuidle.h>
+#include <mach/cpuidle.h>
+
+static struct cpuidle_driver imx6q_cpuidle_driver = {
+	.name			= "imx6q_cpuidle",
+	.owner			= THIS_MODULE,
+	.en_core_tk_irqen	= 1,
+	.states[0]		= ARM_CPUIDLE_WFI_STATE,
+	.state_count		= 1,
+};
+
+int __init imx6q_cpuidle_init(void)
+{
+	imx_cpuidle_set_driver(&imx6q_cpuidle_driver);
+
+	return 0;
+}
diff --git a/arch/arm/mach-imx/mach-imx6q.c b/arch/arm/mach-imx/mach-imx6q.c
index da6c1d9..6f31ca6 100644
--- a/arch/arm/mach-imx/mach-imx6q.c
+++ b/arch/arm/mach-imx/mach-imx6q.c
@@ -29,6 +29,7 @@
 #include <asm/system_misc.h>
 #include <mach/common.h>
 #include <mach/hardware.h>
+#include <mach/cpuidle.h>
 
 void imx6q_restart(char mode, const char *cmd)
 {
@@ -84,6 +85,7 @@ static void __init imx6q_init_machine(void)
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 
 	imx6q_pm_init();
+	imx6q_cpuidle_init();
 }
 
 static void __init imx6q_map_io(void)
-- 
1.7.10

