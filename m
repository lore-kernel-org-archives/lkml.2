Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab1DBGXV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 02:23:21 -0400
Received: from vms173007pub.verizon.net ([206.46.173.7]:44586 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab1DBGXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 02:23:19 -0400
From: Len Brown <lenb@kernel.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        x86@kernel.org, Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 04/18] x86 idle: EXPORT_SYMBOL(default_idle,
 pm_idle) only when APM demands it
Date: Sat, 02 Apr 2011 02:22:46 -0400
Message-id: <dba24a423948935d0a0c1eb32414a476f3f90e02.1301724243.git.len.brown@intel.com>
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

In the long run, we don't want default_idle() or (pm_idle)() to
be exported outside of process.c.  Start by not exporting them
to modules, unless the APM build demands it.

cc: x86@kernel.org
cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/x86/kernel/process.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index ff45541..17b8771 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -340,7 +340,9 @@ EXPORT_SYMBOL(boot_option_idle_override);
  * Powermanagement idle function, if any..
  */
 void (*pm_idle)(void);
+#if defined(CONFIG_APM_MODULE) && defined(CONFIG_APM_CPU_IDLE)
 EXPORT_SYMBOL(pm_idle);
+#endif
 
 #ifdef CONFIG_X86_32
 /*
@@ -400,7 +402,7 @@ void default_idle(void)
 		cpu_relax();
 	}
 }
-#ifdef CONFIG_APM_MODULE
+#if defined(CONFIG_APM_MODULE) && defined(CONFIG_APM_CPU_IDLE)
 EXPORT_SYMBOL(default_idle);
 #endif
 
-- 
1.7.5.rc0

