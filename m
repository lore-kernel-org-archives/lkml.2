Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab0HYE7I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 00:59:08 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17518 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab0HYE6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 00:58:23 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6084"; a="52012253"
X-IronPort-AV: E=Sophos;i="4.56,265,1280732400"; 
   d="scan'208";a="72366142"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Daniel Walker <dwalker@codeaurora.org>,
        Jeff Ohlstein <johlstei@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Gregory Bean <gbean@codeaurora.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Subject: [PATCH 12/24] msm: clock: add dummy clock driver
Date: Tue, 24 Aug 2010 21:57:41 -0700
Message-Id: <1282712273-344-13-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1282712273-344-1-git-send-email-johlstei@codeaurora.org>
References: <1282712273-344-1-git-send-email-johlstei@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need to add this until real clock support for 8x60 goes in, or else some
drivers won't compile.

Signed-off-by: Jeff Ohlstein <johlstei@codeaurora.org>
---
 arch/arm/mach-msm/Makefile      |    1 +
 arch/arm/mach-msm/clock-dummy.c |   54 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-msm/clock-dummy.c

diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 64a95ae..ff19e01 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -7,6 +7,7 @@ else
 obj-y += irq.o
 endif
 
+obj-$(CONFIG_ARCH_MSM8X60) += clock-dummy.o
 obj-$(CONFIG_MSM_PROC_COMM) += proc_comm.o clock-pcom.o vreg.o
 obj-$(CONFIG_MSM_PROC_COMM) += clock.o gpio.o
 obj-$(CONFIG_ARCH_QSD8X50) += sirc.o
diff --git a/arch/arm/mach-msm/clock-dummy.c b/arch/arm/mach-msm/clock-dummy.c
new file mode 100644
index 0000000..1250d22
--- /dev/null
+++ b/arch/arm/mach-msm/clock-dummy.c
@@ -0,0 +1,54 @@
+/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ */
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/module.h>
+
+struct clk *clk_get(struct device *dev, const char *id)
+{
+	return ERR_PTR(-ENOENT);
+}
+EXPORT_SYMBOL(clk_get);
+
+int clk_enable(struct clk *clk)
+{
+	return -ENOENT;
+}
+EXPORT_SYMBOL(clk_enable);
+
+void clk_disable(struct clk *clk)
+{
+}
+EXPORT_SYMBOL(clk_disable);
+
+unsigned long clk_get_rate(struct clk *clk)
+{
+	return 0;
+}
+EXPORT_SYMBOL(clk_get_rate);
+
+int clk_set_rate(struct clk *clk, unsigned long rate)
+{
+	return -ENOENT;
+}
+EXPORT_SYMBOL(clk_set_rate);
+
+void clk_put(struct clk *clk)
+{
+}
+EXPORT_SYMBOL(clk_put);
-- 
1.7.2.1

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
