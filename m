Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203Ab1DGAC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 20:02:56 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:48029 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757140Ab1DGACy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 20:02:54 -0400
From: Kevin Hilman <khilman@ti.com>
To: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-sh@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        "Rafael J. Wysocki" <rjw@suse.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH/RFC 5/6] ARM: use common clock-based runtime PM implementation on SH-mobile & OMAP1
Date: Wed,  6 Apr 2011 17:02:48 -0700
Message-Id: <1302134569-22825-6-git-send-email-khilman@ti.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1302134569-22825-1-git-send-email-khilman@ti.com>
References: <1302134569-22825-1-git-send-email-khilman@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kevin Hilman <khilman@ti.com>
---
 arch/arm/mach-omap1/Makefile        |    2 +-
 arch/arm/mach-omap1/pm_runtime.c    |   18 ++++++++++++++++++
 arch/arm/mach-shmobile/pm_runtime.c |   23 +++++++++++++++++++++++
 3 files changed, 42 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/mach-omap1/pm_runtime.c
 create mode 100644 arch/arm/mach-shmobile/pm_runtime.c

diff --git a/arch/arm/mach-omap1/Makefile b/arch/arm/mach-omap1/Makefile
index 1913c2d..04c60f9 100644
--- a/arch/arm/mach-omap1/Makefile
+++ b/arch/arm/mach-omap1/Makefile
@@ -11,7 +11,7 @@ obj-$(CONFIG_OMAP_MCBSP) += mcbsp.o
 obj-$(CONFIG_OMAP_32K_TIMER)	+= timer32k.o
 
 # Power Management
-obj-$(CONFIG_PM) += pm.o sleep.o
+obj-$(CONFIG_PM) += pm.o sleep.o pm_runtime.o
 
 # DSP
 obj-$(CONFIG_OMAP_MBOX_FWK)	+= mailbox_mach.o
diff --git a/arch/arm/mach-omap1/pm_runtime.c b/arch/arm/mach-omap1/pm_runtime.c
new file mode 100644
index 0000000..bbceb64
--- /dev/null
+++ b/arch/arm/mach-omap1/pm_runtime.c
@@ -0,0 +1,18 @@
+/*
+ * Runtime PM support code for TI OMAP1
+ *
+ *  Copyright (C) 2011 Texas Instruments, Inc.
+ *  Author: Kevin Hilman <khilman@ti.com>
+ *
+ */
+#include <linux/kernel.h>
+#include <linux/init.h>
+
+#include <asm/pm_runtime.h>
+
+static int __init omap1_pm_runtime_init(void)
+{
+	pm_runtime_clock_init();
+	return 0;
+}
+core_initcall(omap1_pm_runtime_init);
diff --git a/arch/arm/mach-shmobile/pm_runtime.c b/arch/arm/mach-shmobile/pm_runtime.c
new file mode 100644
index 0000000..edc0fa5
--- /dev/null
+++ b/arch/arm/mach-shmobile/pm_runtime.c
@@ -0,0 +1,23 @@
+/*
+ * arch/arm/mach-shmobile/pm_runtime.c
+ *
+ * Runtime PM support code for SuperH Mobile ARM
+ *
+ *  Copyright (C) 2009-2010 Magnus Damm
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+
+#include <asm/pm_runtime.h>
+
+static int __init sh_pm_runtime_init(void)
+{
+	pm_runtime_clock_init();
+	return 0;
+}
+core_initcall(sh_pm_runtime_init);
-- 
1.7.4

