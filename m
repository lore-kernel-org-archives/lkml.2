Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859Ab1AJTBb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 14:01:31 -0500
Received: from smtp-out.google.com ([216.239.44.51]:50058 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab1AJTB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 14:01:28 -0500
From: Dima Zavin <dima@android.com>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Gregory Bean <gbean@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dima Zavin <dima@android.com>
Subject: [PATCH] ARM: msm: 7x30: don't force a gpiomux table for the whole arch
Date: Mon, 10 Jan 2011 11:00:30 -0800
Message-Id: <1294686030-9817-1-git-send-email-dima@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1294680810.12298.2.camel@c-dwalke-linux.qualcomm.com>
References: <1294680810.12298.2.camel@c-dwalke-linux.qualcomm.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is completely board specific and therefore must be provided
on a per-board basis.

Change-Id: I96f922ad9bb9cbce7874c5ae6ac0d7479b7a2124
Signed-off-by: Dima Zavin <dima@android.com>
---
 arch/arm/mach-msm/Makefile        |    2 +-
 arch/arm/mach-msm/board-msm7x30.c |   22 +++++++++++++++++++++
 arch/arm/mach-msm/gpiomux-7x30.c  |   38 -------------------------------------
 3 files changed, 23 insertions(+), 39 deletions(-)
 delete mode 100644 arch/arm/mach-msm/gpiomux-7x30.c

diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index b5a7b07..b5695ce 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -25,7 +25,7 @@ obj-$(CONFIG_ARCH_MSM7X30) += board-msm7x30.o devices-msm7x30.o
 obj-$(CONFIG_ARCH_QSD8X50) += board-qsd8x50.o devices-qsd8x50.o
 obj-$(CONFIG_ARCH_MSM8X60) += board-msm8x60.o
 
-obj-$(CONFIG_ARCH_MSM7X30) += gpiomux-7x30.o gpiomux-v1.o gpiomux.o
+obj-$(CONFIG_ARCH_MSM7X30) += gpiomux-v1.o gpiomux.o
 obj-$(CONFIG_ARCH_QSD8X50) += gpiomux-8x50.o gpiomux-v1.o gpiomux.o
 obj-$(CONFIG_ARCH_MSM8X60) += gpiomux-8x60.o gpiomux-v2.o gpiomux.o
 ifndef CONFIG_MSM_V2_TLMM
diff --git a/arch/arm/mach-msm/board-msm7x30.c b/arch/arm/mach-msm/board-msm7x30.c
index 05241df..431be40 100644
--- a/arch/arm/mach-msm/board-msm7x30.c
+++ b/arch/arm/mach-msm/board-msm7x30.c
@@ -35,10 +35,32 @@
 
 #include <mach/vreg.h>
 #include "devices.h"
+#include "gpiomux.h"
 #include "proc_comm.h"
 
 extern struct sys_timer msm_timer;
 
+struct msm_gpiomux_config msm_gpiomux_configs[GPIOMUX_NGPIOS] = {
+#ifdef CONFIG_SERIAL_MSM_CONSOLE
+	[49] = { /* UART2 RFR */
+		.suspended = GPIOMUX_DRV_2MA | GPIOMUX_PULL_DOWN |
+			     GPIOMUX_FUNC_2 | GPIOMUX_VALID,
+	},
+	[50] = { /* UART2 CTS */
+		.suspended = GPIOMUX_DRV_2MA | GPIOMUX_PULL_DOWN |
+			     GPIOMUX_FUNC_2 | GPIOMUX_VALID,
+	},
+	[51] = { /* UART2 RX */
+		.suspended = GPIOMUX_DRV_2MA | GPIOMUX_PULL_DOWN |
+			     GPIOMUX_FUNC_2 | GPIOMUX_VALID,
+	},
+	[52] = { /* UART2 TX */
+		.suspended = GPIOMUX_DRV_2MA | GPIOMUX_PULL_DOWN |
+			     GPIOMUX_FUNC_2 | GPIOMUX_VALID,
+	},
+#endif
+};
+
 static struct platform_device *devices[] __initdata = {
 #if defined(CONFIG_SERIAL_MSM) || defined(CONFIG_MSM_SERIAL_DEBUGGER)
         &msm_device_uart2,
diff --git a/arch/arm/mach-msm/gpiomux-7x30.c b/arch/arm/mach-msm/gpiomux-7x30.c
deleted file mode 100644
index 6ce41c5..0000000
--- a/arch/arm/mach-msm/gpiomux-7x30.c
+++ /dev/null
@@ -1,38 +0,0 @@
-/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
- */
-#include "gpiomux.h"
-
-struct msm_gpiomux_config msm_gpiomux_configs[GPIOMUX_NGPIOS] = {
-#ifdef CONFIG_SERIAL_MSM_CONSOLE
-	[49] = { /* UART2 RFR */
-		.suspended = GPIOMUX_DRV_2MA | GPIOMUX_PULL_DOWN |
-			     GPIOMUX_FUNC_2 | GPIOMUX_VALID,
-	},
-	[50] = { /* UART2 CTS */
-		.suspended = GPIOMUX_DRV_2MA | GPIOMUX_PULL_DOWN |
-			     GPIOMUX_FUNC_2 | GPIOMUX_VALID,
-	},
-	[51] = { /* UART2 RX */
-		.suspended = GPIOMUX_DRV_2MA | GPIOMUX_PULL_DOWN |
-			     GPIOMUX_FUNC_2 | GPIOMUX_VALID,
-	},
-	[52] = { /* UART2 TX */
-		.suspended = GPIOMUX_DRV_2MA | GPIOMUX_PULL_DOWN |
-			     GPIOMUX_FUNC_2 | GPIOMUX_VALID,
-	},
-#endif
-};
-- 
1.7.3.1

