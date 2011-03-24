Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933379Ab1CXHJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 03:09:15 -0400
Received: from vms173009pub.verizon.net ([206.46.173.9]:51562 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933305Ab1CXHI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 03:08:57 -0400
From: Len Brown <lenb@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 1/5] x86 idle: remove "no-hlt" cmdline param
Date: Thu, 24 Mar 2011 03:08:24 -0400
Message-id: <67e90d97e0a77df4acd0c75e1bacc7714e011f3e.1300950095.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.4.1.343.ga91df
In-reply-to: <1300950508-22746-1-git-send-email-lenb@kernel.org>
References: <1300950508-22746-1-git-send-email-lenb@kernel.org>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

The X86_32-only "no-hlt" option was the functional equivalent of
"idle=poll" for the idle loop.

It would also set the X86_32-only "hlt_bug" line in the /proc/cpuinfo,
and cause halt to be skipped in stop_this_cpu().

Signed-off-by: Len Brown <len.brown@intel.com>
---
 Documentation/kernel-parameters.txt |    4 ----
 arch/x86/kernel/cpu/bugs.c          |    8 --------
 2 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index f4a04c0..e6b4843 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1666,10 +1666,6 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
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
index c39576c..4c91631 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -17,14 +17,6 @@
 #include <asm/paravirt.h>
 #include <asm/alternative.h>
 
-static int __init no_halt(char *s)
-{
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
1.7.4.1.343.ga91df

