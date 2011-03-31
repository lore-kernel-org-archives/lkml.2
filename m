Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933089Ab1CaGEi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 02:04:38 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:44952 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250Ab1CaGDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 02:03:50 -0400
From: Len Brown <lenb@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 7/9] x86 idle: do not EXPORT_SYMBOL pm_idle and default_idle
Date: Thu, 31 Mar 2011 02:03:22 -0400
Message-id: <31ad970fd2a09dbe4cbccb9bc7b8520fac973f38.1301550524.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.4.2.406.gbe91
In-reply-to: <1301551404-8263-1-git-send-email-lenb@kernel.org>
References: <1300950508-22746-1-git-send-email-lenb@kernel.org>
 <1301551404-8263-1-git-send-email-lenb@kernel.org>
In-reply-to: <67e90d97e0a77df4acd0c75e1bacc7714e011f3e.1301550524.git.len.brown@intel.com>
References: <67e90d97e0a77df4acd0c75e1bacc7714e011f3e.1301550524.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

APM was the only potential modular user of pm_idle,
and default_idle(), and that use is now gone.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/x86/kernel/process.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 094d4ac..9d485d9 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -340,7 +340,6 @@ EXPORT_SYMBOL(boot_option_idle_override);
  * Powermanagement idle function, if any..
  */
 void (*pm_idle)(void);
-EXPORT_SYMBOL(pm_idle);
 
 /*
  * We use this if we don't have any better
@@ -365,9 +364,6 @@ void default_idle(void)
 	trace_power_end(smp_processor_id());
 	trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
 }
-#ifdef CONFIG_APM_MODULE
-EXPORT_SYMBOL(default_idle);
-#endif
 
 void stop_this_cpu(void *dummy)
 {
-- 
1.7.4.2.406.gbe91

