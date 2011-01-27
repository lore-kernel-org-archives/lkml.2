Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab1A0AVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 19:21:47 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:62484 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab1A0AU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 19:20:59 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6238"; a="71900278"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>
Subject: [PATCHv2 2/5] msm: clock: Remove 7x30 and pcom includes from clock.h
Date: Wed, 26 Jan 2011 16:20:53 -0800
Message-Id: <1296087656-3693-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <1296087656-3693-1-git-send-email-sboyd@codeaurora.org>
References: <1296087656-3693-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clock.h includes clock-pcom.h and clock-7x30.h when it really
doesn't need to. Remove the includes and fixup breakages.

Reviewed-By: Saravana Kannan <skannan@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/clock-pcom.c      |    1 +
 arch/arm/mach-msm/clock.c           |    1 +
 arch/arm/mach-msm/clock.h           |    3 ---
 arch/arm/mach-msm/devices-msm7x00.c |    1 +
 arch/arm/mach-msm/devices-msm7x30.c |    1 +
 arch/arm/mach-msm/devices-qsd8x50.c |    1 +
 6 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-msm/clock-pcom.c b/arch/arm/mach-msm/clock-pcom.c
index a3b4562..8c4e867 100644
--- a/arch/arm/mach-msm/clock-pcom.c
+++ b/arch/arm/mach-msm/clock-pcom.c
@@ -20,6 +20,7 @@
 
 #include "proc_comm.h"
 #include "clock.h"
+#include "clock-pcom.h"
 
 /*
  * glue for the proc_comm interface
diff --git a/arch/arm/mach-msm/clock.c b/arch/arm/mach-msm/clock.c
index b67498d..8f71f8d 100644
--- a/arch/arm/mach-msm/clock.c
+++ b/arch/arm/mach-msm/clock.c
@@ -29,6 +29,7 @@
 #include "clock.h"
 #include "proc_comm.h"
 #include "clock-7x30.h"
+#include "clock-pcom.h"
 
 static DEFINE_MUTEX(clocks_mutex);
 static DEFINE_SPINLOCK(clocks_lock);
diff --git a/arch/arm/mach-msm/clock.h b/arch/arm/mach-msm/clock.h
index db9a77a..6a0cade 100644
--- a/arch/arm/mach-msm/clock.h
+++ b/arch/arm/mach-msm/clock.h
@@ -20,9 +20,6 @@
 #include <linux/list.h>
 #include <mach/clk.h>
 
-#include "clock-pcom.h"
-#include "clock-7x30.h"
-
 #define CLKFLAG_INVERT			0x00000001
 #define CLKFLAG_NOINVERT		0x00000002
 #define CLKFLAG_NONEST			0x00000004
diff --git a/arch/arm/mach-msm/devices-msm7x00.c b/arch/arm/mach-msm/devices-msm7x00.c
index 2549fb2..ed62806 100644
--- a/arch/arm/mach-msm/devices-msm7x00.c
+++ b/arch/arm/mach-msm/devices-msm7x00.c
@@ -26,6 +26,7 @@
 
 
 #include "clock.h"
+#include "clock-pcom.h"
 #include <mach/mmc.h>
 
 static struct resource resources_uart1[] = {
diff --git a/arch/arm/mach-msm/devices-msm7x30.c b/arch/arm/mach-msm/devices-msm7x30.c
index d4c7afc..e430fdd 100644
--- a/arch/arm/mach-msm/devices-msm7x30.c
+++ b/arch/arm/mach-msm/devices-msm7x30.c
@@ -28,6 +28,7 @@
 #include <asm/mach/flash.h>
 
 #include "clock-pcom.h"
+#include "clock-7x30.h"
 
 #include <mach/mmc.h>
 
diff --git a/arch/arm/mach-msm/devices-qsd8x50.c b/arch/arm/mach-msm/devices-qsd8x50.c
index c9fa655..c5dad8f 100644
--- a/arch/arm/mach-msm/devices-qsd8x50.c
+++ b/arch/arm/mach-msm/devices-qsd8x50.c
@@ -27,6 +27,7 @@
 #include <asm/mach/flash.h>
 
 #include <mach/mmc.h>
+#include "clock-pcom.h"
 
 static struct resource resources_uart3[] = {
 	{
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

