Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031415Ab2CFVQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 16:16:48 -0500
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:41722 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752592Ab2CFVQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 16:16:47 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl: split pincontrol states into its own header
Date: Tue, 6 Mar 2012 22:15:52 +0100
Message-ID: <1331068552-16988-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.8
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Move the pin control state defines into its own header file,
since it is used both by machine.h which is facing the platform
and by consumer.h which is facing the drivers, and pinctrl.h
which is pinctrl-driver internal, let's not have each and every
.h file include all others, then isolation is moot.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 include/linux/pinctrl/consumer.h      |    2 +-
 include/linux/pinctrl/machine.h       |    2 +-
 include/linux/pinctrl/pinctrl-state.h |    6 ++++++
 include/linux/pinctrl/pinctrl.h       |    3 +--
 4 files changed, 9 insertions(+), 4 deletions(-)
 create mode 100644 include/linux/pinctrl/pinctrl-state.h

diff --git a/include/linux/pinctrl/consumer.h b/include/linux/pinctrl/consumer.h
index 9ad5896..191e726 100644
--- a/include/linux/pinctrl/consumer.h
+++ b/include/linux/pinctrl/consumer.h
@@ -15,7 +15,7 @@
 #include <linux/err.h>
 #include <linux/list.h>
 #include <linux/seq_file.h>
-#include "pinctrl.h"
+#include "pinctrl-state.h"
 
 /* This struct is private to the core and should be regarded as a cookie */
 struct pinctrl;
diff --git a/include/linux/pinctrl/machine.h b/include/linux/pinctrl/machine.h
index 3fd2f9d..fee4349 100644
--- a/include/linux/pinctrl/machine.h
+++ b/include/linux/pinctrl/machine.h
@@ -12,7 +12,7 @@
 #ifndef __LINUX_PINCTRL_MACHINE_H
 #define __LINUX_PINCTRL_MACHINE_H
 
-#include "pinctrl.h"
+#include "pinctrl-state.h"
 
 enum pinctrl_map_type {
 	PIN_MAP_TYPE_INVALID,
diff --git a/include/linux/pinctrl/pinctrl-state.h b/include/linux/pinctrl/pinctrl-state.h
new file mode 100644
index 0000000..3920e28
--- /dev/null
+++ b/include/linux/pinctrl/pinctrl-state.h
@@ -0,0 +1,6 @@
+/*
+ * Standard pin control state definitions
+ */
+
+#define PINCTRL_STATE_DEFAULT "default"
+#define PINCTRL_STATE_IDLE "idle"
diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
index bbdd7e1..e9e94eb 100644
--- a/include/linux/pinctrl/pinctrl.h
+++ b/include/linux/pinctrl/pinctrl.h
@@ -17,8 +17,7 @@
 #include <linux/radix-tree.h>
 #include <linux/list.h>
 #include <linux/seq_file.h>
-
-#define PINCTRL_STATE_DEFAULT "default"
+#include "pinctrl-state.h"
 
 struct pinctrl_dev;
 struct pinmux_ops;
-- 
1.7.8

