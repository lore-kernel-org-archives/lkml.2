Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab1HRFgB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 01:36:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775Ab1HRFf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 01:35:58 -0400
From: WANG Cong <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, WANG Cong <amwang@redhat.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Andi Kleen <andi@firstfloor.org>, Randy Dunlap <rdunlap@xenotime.net>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Ingo Molnar <mingo@elte.hu>, Daniel Lezcano <daniel.lezcano@free.fr>,
        Peter Zijlstra <peterz@infradead.org>, linux-doc@vger.kernel.org
Subject: [Patch] sysctl: make CONFIG_SYSCTL_SYSCALL default to n
Date: Thu, 18 Aug 2011 13:35:20 +0800
Message-Id: <1313645722-28722-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IIRC, when I tried to send a patch to remove it, Andi told me
we still need to keep compabitlies for old libc, so we can't
remove this completely.  Then just make it default to n and
remove the doc from feature-removal-schedule.txt.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Andi Kleen <andi@firstfloor.org>

---
diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index c4a6e14..ad5d67b 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -133,41 +133,6 @@ Who:	Pavel Machek <pavel@ucw.cz>
 
 ---------------------------
 
-What:	sys_sysctl
-When:	September 2010
-Option: CONFIG_SYSCTL_SYSCALL
-Why:	The same information is available in a more convenient from
-	/proc/sys, and none of the sysctl variables appear to be
-	important performance wise.
-
-	Binary sysctls are a long standing source of subtle kernel
-	bugs and security issues.
-
-	When I looked several months ago all I could find after
-	searching several distributions were 5 user space programs and
-	glibc (which falls back to /proc/sys) using this syscall.
-
-	The man page for sysctl(2) documents it as unusable for user
-	space programs.
-
-	sysctl(2) is not generally ABI compatible to a 32bit user
-	space application on a 64bit and a 32bit kernel.
-
-	For the last several months the policy has been no new binary
-	sysctls and no one has put forward an argument to use them.
-
-	Binary sysctls issues seem to keep happening appearing so
-	properly deprecating them (with a warning to user space) and a
-	2 year grace warning period will mean eventually we can kill
-	them and end the pain.
-
-	In the mean time individual binary sysctls can be dealt with
-	in a piecewise fashion.
-
-Who:	Eric Biederman <ebiederm@xmission.com>
-
----------------------------
-
 What:	/proc/<pid>/oom_adj
 When:	August 2012
 Why:	/proc/<pid>/oom_adj allows userspace to influence the oom killer's
diff --git a/init/Kconfig b/init/Kconfig
index d627783..566b2a4 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -935,7 +935,7 @@ config UID16
 config SYSCTL_SYSCALL
 	bool "Sysctl syscall support" if EXPERT
 	depends on PROC_SYSCTL
-	default y
+	default n
 	select SYSCTL
 	---help---
 	  sys_sysctl uses binary paths that have been found challenging
@@ -947,7 +947,7 @@ config SYSCTL_SYSCALL
 	  trying to save some space it is probably safe to disable this,
 	  making your kernel marginally smaller.
 
-	  If unsure say Y here.
+	  If unsure say N here.
 
 config KALLSYMS
 	 bool "Load all symbols for debugging/ksymoops" if EXPERT
