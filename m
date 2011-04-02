Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab1DBHCl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 03:02:41 -0400
Received: from vms173009pub.verizon.net ([206.46.173.9]:59186 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab1DBHB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 03:01:59 -0400
From: Len Brown <lenb@kernel.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        x86@kernel.org
Subject: [PATCH 12/18] 2.6.40: x86 idle: remove deprecated "no-hlt" cmdline
 param
Date: Sat, 02 Apr 2011 02:22:54 -0400
Message-id: <6f29c9504382d48164e62f10ec0c7928c57a4e2c.1301724243.git.len.brown@intel.com>
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

The X86_32-only "no-hlt" cmdline option was used to disable
the HLT instruction in the idle loop for the beneift of
systems with flakey power issues 15 years ago.

It would also set the "hlt_bug" line in /proc/cpuinfo
and disable HLT in machine_halt().

If such a system is still running the upstream kernel,
"idle=poll" is available to disable HLT in the idle loop.
The kernel will, however, still use HLT in machine_halt().

cc: x86@kernel.org
Signed-off-by: Len Brown <len.brown@intel.com>
---
 Documentation/feature-removal-schedule.txt |   11 -----------
 Documentation/kernel-parameters.txt        |    4 ----
 arch/x86/kernel/cpu/bugs.c                 |    9 ---------
 3 files changed, 0 insertions(+), 24 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 9ee4a2c..720e698 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -24,17 +24,6 @@ Who:	Len Brown <len.brown@intel.com>
 
 ----------------------------
 
-What:	x86_32 "no-hlt" cmdline param
-When:	2.6.40
-Why:	remove a branch from idle path, simplify code used by everybody.
-	This option disabled the use of HLT in idle and machine_halt()
-	for hardware that was flakey 15-years ago.  Today we have
-	"idle=poll" that removed HLT from idle, and so if such a machine
-	is still running the upstream kernel, "idle=poll" is likely sufficient.
-Who:	Len Brown <len.brown@intel.com>
-
-----------------------------
-
 What:	x86 "idle=mwait" cmdline param
 When:	2.6.40
 Why:	simplify x86 idle code
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 08e8a22..a9db94e 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1669,10 +1669,6 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			wfi(ARM) instruction doesn't work correctly and not to
 			use it. This is also useful when using JTAG debugger.
 
-	no-hlt		[BUGS=X86-32] Tells the kernel that the hlt
-			instruction doesn't work correctly and not to
-			use it.
-
 	no_file_caps	Tells the kernel not to honor file capabilities.  The
 			only way then for a file to be executed with privilege
 			is to be setuid root or executed by root.
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 525514c..4c91631 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -17,15 +17,6 @@
 #include <asm/paravirt.h>
 #include <asm/alternative.h>
 
-static int __init no_halt(char *s)
-{
-	WARN_ONCE(1, "\"no-hlt\" is deprecated, please use \"idle=poll\"\n");
-	boot_cpu_data.hlt_works_ok = 0;
-	return 1;
-}
-
-__setup("no-hlt", no_halt);
-
 static int __init no_387(char *s)
 {
 	boot_cpu_data.hard_math = 0;
-- 
1.7.5.rc0

