Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab2ILQ7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:59:40 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40192 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191Ab2ILQ7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:59:35 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6832"; a="233521327"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 01/24] ARM: msm: Remove msm_hw_reset_hook
Date: Wed, 12 Sep 2012 09:58:37 -0700
Message-Id: <1347469140-25069-2-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347469140-25069-1-git-send-email-davidb@codeaurora.org>
References: <1347469140-25069-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

This reset hook is never assigned and is dead code. Remove it so
we have one less header file in the mach directory.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/board-mahimahi.c      |  1 -
 arch/arm/mach-msm/board-sapphire.c      |  1 -
 arch/arm/mach-msm/include/mach/system.h | 19 -------------------
 arch/arm/mach-msm/proc_comm.c           |  1 -
 arch/arm/mach-msm/smd.c                 |  7 -------
 5 files changed, 29 deletions(-)
 delete mode 100644 arch/arm/mach-msm/include/mach/system.h

diff --git a/arch/arm/mach-msm/board-mahimahi.c b/arch/arm/mach-msm/board-mahimahi.c
index cf1f89a..df00bc0 100644
--- a/arch/arm/mach-msm/board-mahimahi.c
+++ b/arch/arm/mach-msm/board-mahimahi.c
@@ -30,7 +30,6 @@
 
 #include <mach/board.h>
 #include <mach/hardware.h>
-#include <mach/system.h>
 
 #include "board-mahimahi.h"
 #include "devices.h"
diff --git a/arch/arm/mach-msm/board-sapphire.c b/arch/arm/mach-msm/board-sapphire.c
index 2e569ab..b7b0fc7 100644
--- a/arch/arm/mach-msm/board-sapphire.c
+++ b/arch/arm/mach-msm/board-sapphire.c
@@ -27,7 +27,6 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 #include <asm/mach/flash.h>
-#include <mach/system.h>
 #include <mach/vreg.h>
 #include <mach/board.h>
 
diff --git a/arch/arm/mach-msm/include/mach/system.h b/arch/arm/mach-msm/include/mach/system.h
deleted file mode 100644
index f5fb2ec..0000000
--- a/arch/arm/mach-msm/include/mach/system.h
+++ /dev/null
@@ -1,19 +0,0 @@
-/* arch/arm/mach-msm/include/mach/system.h
- *
- * Copyright (C) 2007 Google, Inc.
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-/* low level hardware reset hook -- for example, hitting the
- * PSHOLD line on the PMIC to hard reset the system
- */
-extern void (*msm_hw_reset_hook)(void);
diff --git a/arch/arm/mach-msm/proc_comm.c b/arch/arm/mach-msm/proc_comm.c
index 9980dc7..8f1eecd 100644
--- a/arch/arm/mach-msm/proc_comm.c
+++ b/arch/arm/mach-msm/proc_comm.c
@@ -19,7 +19,6 @@
 #include <linux/io.h>
 #include <linux/spinlock.h>
 #include <mach/msm_iomap.h>
-#include <mach/system.h>
 
 #include "proc_comm.h"
 
diff --git a/arch/arm/mach-msm/smd.c b/arch/arm/mach-msm/smd.c
index 657be73..84183ed 100644
--- a/arch/arm/mach-msm/smd.c
+++ b/arch/arm/mach-msm/smd.c
@@ -30,7 +30,6 @@
 #include <linux/delay.h>
 
 #include <mach/msm_smd.h>
-#include <mach/system.h>
 
 #include "smd_private.h"
 #include "proc_comm.h"
@@ -39,8 +38,6 @@
 #define CONFIG_QDSP6 1
 #endif
 
-void (*msm_hw_reset_hook)(void);
-
 #define MODULE_NAME "msm_smd"
 
 enum {
@@ -101,10 +98,6 @@ static void handle_modem_crash(void)
 	pr_err("ARM9 has CRASHED\n");
 	smd_diag();
 
-	/* hard reboot if possible */
-	if (msm_hw_reset_hook)
-		msm_hw_reset_hook();
-
 	/* in this case the modem or watchdog should reboot us */
 	for (;;)
 		;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

