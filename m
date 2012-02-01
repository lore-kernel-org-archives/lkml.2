Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab2BAHU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 02:20:26 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64221 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904Ab2BAHUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 02:20:22 -0500
From: Dmitry Antipov <dmitry.antipov@linaro.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, Dmitry Antipov <dmitry.antipov@linaro.org>
Subject: [PATCH] sched: move CONFIG_IRQ_TIME_ACCOUNTING to common code
Date: Wed,  1 Feb 2012 11:19:49 +0400
Message-Id: <1328080789-18277-1-git-send-email-dmitry.antipov@linaro.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since CONFIG_IRQ_TIME_ACCOUNTING is architecture-agnostic,
move it from x86 area to common code.

Signed-off-by: Dmitry Antipov <dmitry.antipov@linaro.org>
---
 arch/x86/Kconfig  |   11 -----------
 lib/Kconfig.debug |   11 +++++++++++
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5bed94e..4759676 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -805,17 +805,6 @@ config SCHED_MC
 	  making when dealing with multi-core CPU chips at a cost of slightly
 	  increased overhead in some places. If unsure say N here.
 
-config IRQ_TIME_ACCOUNTING
-	bool "Fine granularity task level IRQ time accounting"
-	default n
-	---help---
-	  Select this option to enable fine granularity task irq time
-	  accounting. This is done by reading a timestamp on each
-	  transitions between softirq and hardirq state, so there can be a
-	  small performance impact.
-
-	  If in doubt, say N here.
-
 source "kernel/Kconfig.preempt"
 
 config X86_UP_APIC
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 8745ac7..d6d7afc 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -299,6 +299,17 @@ config SCHEDSTATS
 	  application, you can say N to avoid the very slight overhead
 	  this adds.
 
+config IRQ_TIME_ACCOUNTING
+	bool "Fine granularity task level IRQ time accounting"
+	default n
+	---help---
+	  Select this option to enable fine granularity task irq time
+	  accounting. This is done by reading a timestamp on each
+	  transitions between softirq and hardirq state, so there can be a
+	  small performance impact.
+
+	  If in doubt, say N here.
+
 config TIMER_STATS
 	bool "Collect kernel timers statistics"
 	depends on DEBUG_KERNEL && PROC_FS
-- 
1.7.7.6

