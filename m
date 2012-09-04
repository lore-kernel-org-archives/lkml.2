Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832Ab2IDWji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 18:39:38 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57966 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757772Ab2IDWjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 18:39:37 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] pinctrl: tegra: move pinconf-tegra.h content into drivers/pinctrl
Date: Tue,  4 Sep 2012 16:39:30 -0600
Message-Id: <1346798370-28795-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Now that Tegra's pinmux is configured solely from device tree, there's
no need for the pinconf types to be defined in arch/arm/mach-tegra/.
Move it into the pinctrl directory to clean up mach-tegra, as a pre-
requisite for single-zImage.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
I'll need to take this through the Tegra tree, since it depends on some
patches that remove inclusion of the deleted header.

 arch/arm/mach-tegra/include/mach/pinconf-tegra.h |   63 ----------------------
 drivers/pinctrl/pinctrl-tegra.c                  |    2 -
 drivers/pinctrl/pinctrl-tegra.h                  |   44 +++++++++++++++
 3 files changed, 44 insertions(+), 65 deletions(-)
 delete mode 100644 arch/arm/mach-tegra/include/mach/pinconf-tegra.h

diff --git a/arch/arm/mach-tegra/include/mach/pinconf-tegra.h b/arch/arm/mach-tegra/include/mach/pinconf-tegra.h
deleted file mode 100644
index 1f24d30..0000000
--- a/arch/arm/mach-tegra/include/mach/pinconf-tegra.h
+++ /dev/null
@@ -1,63 +0,0 @@
-/*
- * pinctrl configuration definitions for the NVIDIA Tegra pinmux
- *
- * Copyright (c) 2011, NVIDIA CORPORATION.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- */
-
-#ifndef __PINCONF_TEGRA_H__
-#define __PINCONF_TEGRA_H__
-
-enum tegra_pinconf_param {
-	/* argument: tegra_pinconf_pull */
-	TEGRA_PINCONF_PARAM_PULL,
-	/* argument: tegra_pinconf_tristate */
-	TEGRA_PINCONF_PARAM_TRISTATE,
-	/* argument: Boolean */
-	TEGRA_PINCONF_PARAM_ENABLE_INPUT,
-	/* argument: Boolean */
-	TEGRA_PINCONF_PARAM_OPEN_DRAIN,
-	/* argument: Boolean */
-	TEGRA_PINCONF_PARAM_LOCK,
-	/* argument: Boolean */
-	TEGRA_PINCONF_PARAM_IORESET,
-	/* argument: Boolean */
-	TEGRA_PINCONF_PARAM_HIGH_SPEED_MODE,
-	/* argument: Boolean */
-	TEGRA_PINCONF_PARAM_SCHMITT,
-	/* argument: Boolean */
-	TEGRA_PINCONF_PARAM_LOW_POWER_MODE,
-	/* argument: Integer, range is HW-dependant */
-	TEGRA_PINCONF_PARAM_DRIVE_DOWN_STRENGTH,
-	/* argument: Integer, range is HW-dependant */
-	TEGRA_PINCONF_PARAM_DRIVE_UP_STRENGTH,
-	/* argument: Integer, range is HW-dependant */
-	TEGRA_PINCONF_PARAM_SLEW_RATE_FALLING,
-	/* argument: Integer, range is HW-dependant */
-	TEGRA_PINCONF_PARAM_SLEW_RATE_RISING,
-};
-
-enum tegra_pinconf_pull {
-	TEGRA_PINCONFIG_PULL_NONE,
-	TEGRA_PINCONFIG_PULL_DOWN,
-	TEGRA_PINCONFIG_PULL_UP,
-};
-
-enum tegra_pinconf_tristate {
-	TEGRA_PINCONFIG_DRIVEN,
-	TEGRA_PINCONFIG_TRISTATE,
-};
-
-#define TEGRA_PINCONF_PACK(_param_, _arg_) ((_param_) << 16 | (_arg_))
-#define TEGRA_PINCONF_UNPACK_PARAM(_conf_) ((_conf_) >> 16)
-#define TEGRA_PINCONF_UNPACK_ARG(_conf_) ((_conf_) & 0xffff)
-
-#endif
diff --git a/drivers/pinctrl/pinctrl-tegra.c b/drivers/pinctrl/pinctrl-tegra.c
index ae52e4e..729b686 100644
--- a/drivers/pinctrl/pinctrl-tegra.c
+++ b/drivers/pinctrl/pinctrl-tegra.c
@@ -30,8 +30,6 @@
 #include <linux/pinctrl/pinconf.h>
 #include <linux/slab.h>
 
-#include <mach/pinconf-tegra.h>
-
 #include "core.h"
 #include "pinctrl-tegra.h"
 
diff --git a/drivers/pinctrl/pinctrl-tegra.h b/drivers/pinctrl/pinctrl-tegra.h
index 705c007..62e3809 100644
--- a/drivers/pinctrl/pinctrl-tegra.h
+++ b/drivers/pinctrl/pinctrl-tegra.h
@@ -16,6 +16,50 @@
 #ifndef __PINMUX_TEGRA_H__
 #define __PINMUX_TEGRA_H__
 
+enum tegra_pinconf_param {
+	/* argument: tegra_pinconf_pull */
+	TEGRA_PINCONF_PARAM_PULL,
+	/* argument: tegra_pinconf_tristate */
+	TEGRA_PINCONF_PARAM_TRISTATE,
+	/* argument: Boolean */
+	TEGRA_PINCONF_PARAM_ENABLE_INPUT,
+	/* argument: Boolean */
+	TEGRA_PINCONF_PARAM_OPEN_DRAIN,
+	/* argument: Boolean */
+	TEGRA_PINCONF_PARAM_LOCK,
+	/* argument: Boolean */
+	TEGRA_PINCONF_PARAM_IORESET,
+	/* argument: Boolean */
+	TEGRA_PINCONF_PARAM_HIGH_SPEED_MODE,
+	/* argument: Boolean */
+	TEGRA_PINCONF_PARAM_SCHMITT,
+	/* argument: Boolean */
+	TEGRA_PINCONF_PARAM_LOW_POWER_MODE,
+	/* argument: Integer, range is HW-dependant */
+	TEGRA_PINCONF_PARAM_DRIVE_DOWN_STRENGTH,
+	/* argument: Integer, range is HW-dependant */
+	TEGRA_PINCONF_PARAM_DRIVE_UP_STRENGTH,
+	/* argument: Integer, range is HW-dependant */
+	TEGRA_PINCONF_PARAM_SLEW_RATE_FALLING,
+	/* argument: Integer, range is HW-dependant */
+	TEGRA_PINCONF_PARAM_SLEW_RATE_RISING,
+};
+
+enum tegra_pinconf_pull {
+	TEGRA_PINCONFIG_PULL_NONE,
+	TEGRA_PINCONFIG_PULL_DOWN,
+	TEGRA_PINCONFIG_PULL_UP,
+};
+
+enum tegra_pinconf_tristate {
+	TEGRA_PINCONFIG_DRIVEN,
+	TEGRA_PINCONFIG_TRISTATE,
+};
+
+#define TEGRA_PINCONF_PACK(_param_, _arg_) ((_param_) << 16 | (_arg_))
+#define TEGRA_PINCONF_UNPACK_PARAM(_conf_) ((_conf_) >> 16)
+#define TEGRA_PINCONF_UNPACK_ARG(_conf_) ((_conf_) & 0xffff)
+
 /**
  * struct tegra_function - Tegra pinctrl mux function
  * @name: The name of the function, exported to pinctrl core.
-- 
1.7.0.4

