Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab2G0WnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 18:43:16 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:49662 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab2G0WnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 18:43:13 -0400
From: Len Brown <lenb@kernel.org>
To: x86@kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>
Subject: [PATCH 3/4] x86, idle: make default_idle() static
Date: Fri, 27 Jul 2012 18:42:54 -0400
Message-Id: <a4eaab6aa17a36fb01bbc2dfb481e8fbc8a5c98d.1343428708.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.12.rc0
In-Reply-To: <1343428975-3897-1-git-send-email-lenb@kernel.org>
References: <1343428975-3897-1-git-send-email-lenb@kernel.org>
In-Reply-To: <06ed885aac76cc68bd1ca1f32c8dcab7bcca1940.1343428708.git.len.brown@intel.com>
References: <06ed885aac76cc68bd1ca1f32c8dcab7bcca1940.1343428708.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

default_idle() was public and exported to modules
for the benefit of APM.  But APM no longer touches
default_idle(), so default_idle() can now be private.

Cc: x86@kernel.org
Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/x86/include/asm/processor.h | 1 -
 arch/x86/kernel/process.c        | 5 +----
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 39bc577..b02e48c 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -979,7 +979,6 @@ extern bool cpu_has_amd_erratum(const int *);
 extern unsigned long arch_align_stack(unsigned long sp);
 extern void free_init_pages(char *what, unsigned long begin, unsigned long end);
 
-void default_idle(void);
 bool set_pm_idle_to_default(void);
 
 void stop_this_cpu(void *dummy);
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 735279e..165f870 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -479,7 +479,7 @@ void cpu_idle(void)
  * We use this if we don't have any better
  * idle routine..
  */
-void default_idle(void)
+static void default_idle(void)
 {
 	if (hlt_use_halt()) {
 		trace_power_start_rcuidle(POWER_CSTATE, 1, smp_processor_id());
@@ -504,9 +504,6 @@ void default_idle(void)
 		cpu_relax();
 	}
 }
-#ifdef CONFIG_APM_MODULE
-EXPORT_SYMBOL(default_idle);
-#endif
 
 bool set_pm_idle_to_default(void)
 {
-- 
1.7.12.rc0

