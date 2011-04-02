Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab1DBHCB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 03:02:01 -0400
Received: from vms173009pub.verizon.net ([206.46.173.9]:59186 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060Ab1DBHB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 03:01:58 -0400
From: Len Brown <lenb@kernel.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        x86@kernel.org
Subject: [PATCH 17/18] 2.6.40: x86 idle: do not export default_idle() and
 (pm_idle)()
Date: Sat, 02 Apr 2011 02:22:59 -0400
Message-id: <f67c099ed8071d3b3c96bf9c02eb42bc80654869.1301724243.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.5.rc0
In-reply-to: <1301725380-10579-1-git-send-email-lenb@kernel.org>
References: <alpine.LFD.2.02.1104010020280.2797@x980>
 <1301725380-10579-1-git-send-email-lenb@kernel.org>
In-reply-to: <c82cf78992a66bfa7f0c82aeb20ba6922127463b.1301724243.git.len.brown@intel.com>
References: <c82cf78992a66bfa7f0c82aeb20ba6922127463b.1301724243.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

With the removal of apm_cpu_idle(), we can now remove
EXPORT_SYMBOL() for both default_idle() and (pm_idle)().

Further, make default_idle() static.
(pm_idle)() is still global b/c it is used by cpu_idle().

cc: x86@kernel.org
Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/x86/include/asm/system.h |    2 --
 arch/x86/kernel/process.c     |    8 +-------
 2 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index 013dd42..a3379bc 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -338,8 +338,6 @@ void cpu_idle_wait(void);
 extern unsigned long arch_align_stack(unsigned long sp);
 extern void free_init_pages(char *what, unsigned long begin, unsigned long end);
 
-void default_idle(void);
-
 void stop_this_cpu(void *dummy);
 
 /*
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 53fb569..8daa323 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -340,15 +340,12 @@ EXPORT_SYMBOL(boot_option_idle_override);
  * Powermanagement idle function, if any..
  */
 void (*pm_idle)(void);
-#if defined(CONFIG_APM_MODULE) && defined(CONFIG_APM_CPU_IDLE)
-EXPORT_SYMBOL(pm_idle);
-#endif
 
 /*
  * We use this if we don't have any better
  * idle routine..
  */
-void default_idle(void)
+static void default_idle(void)
 {
 	trace_power_start(POWER_CSTATE, 1, smp_processor_id());
 	trace_cpu_idle(1, smp_processor_id());
@@ -367,9 +364,6 @@ void default_idle(void)
 	trace_power_end(smp_processor_id());
 	trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
 }
-#if defined(CONFIG_APM_MODULE) && defined(CONFIG_APM_CPU_IDLE)
-EXPORT_SYMBOL(default_idle);
-#endif
 
 void stop_this_cpu(void *dummy)
 {
-- 
1.7.5.rc0

