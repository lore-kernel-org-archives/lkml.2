Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926Ab2IYPHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 11:07:10 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:56768 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab2IYPHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 11:07:04 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 5/6] cputime: Gather time/stats accounting config options into a single menu
Date: Tue, 25 Sep 2012 17:06:06 +0200
Message-Id: <1348585567-2925-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348585567-2925-1-git-send-email-fweisbec@gmail.com>
References: <1348585567-2925-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This debloats a bit the general config menu and make these
config options easier to find.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 init/Kconfig |  116 ++++++++++++++++++++++++++++++----------------------------
 1 files changed, 60 insertions(+), 56 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index c40d0fb..2c5aa34 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -267,6 +267,65 @@ config POSIX_MQUEUE_SYSCTL
 	depends on SYSCTL
 	default y
 
+config FHANDLE
+	bool "open by fhandle syscalls"
+	select EXPORTFS
+	help
+	  If you say Y here, a user level program will be able to map
+	  file names to handle and then later use the handle for
+	  different file system operations. This is useful in implementing
+	  userspace file servers, which now track files using handles instead
+	  of names. The handle would remain the same even if file names
+	  get renamed. Enables open_by_handle_at(2) and name_to_handle_at(2)
+	  syscalls.
+
+config AUDIT
+	bool "Auditing support"
+	depends on NET
+	help
+	  Enable auditing infrastructure that can be used with another
+	  kernel subsystem, such as SELinux (which requires this for
+	  logging of avc messages output).  Does not do system-call
+	  auditing without CONFIG_AUDITSYSCALL.
+
+config AUDITSYSCALL
+	bool "Enable system-call auditing support"
+	depends on AUDIT && (X86 || PPC || S390 || IA64 || UML || SPARC64 || SUPERH || (ARM && AEABI && !OABI_COMPAT))
+	default y if SECURITY_SELINUX
+	help
+	  Enable low-overhead system-call auditing infrastructure that
+	  can be used independently or with another kernel subsystem,
+	  such as SELinux.
+
+config AUDIT_WATCH
+	def_bool y
+	depends on AUDITSYSCALL
+	select FSNOTIFY
+
+config AUDIT_TREE
+	def_bool y
+	depends on AUDITSYSCALL
+	select FSNOTIFY
+
+config AUDIT_LOGINUID_IMMUTABLE
+	bool "Make audit loginuid immutable"
+	depends on AUDIT
+	help
+	  The config option toggles if a task setting its loginuid requires
+	  CAP_SYS_AUDITCONTROL or if that task should require no special permissions
+	  but should instead only allow setting its loginuid if it was never
+	  previously set.  On systems which use systemd or a similar central
+	  process to restart login services this should be set to true.  On older
+	  systems in which an admin would typically have to directly stop and
+	  start processes this should be set to false.  Setting this to true allows
+	  one to drop potentially dangerous capabilites from the login tasks,
+	  but may not be backwards compatible with older init systems.
+
+source "kernel/irq/Kconfig"
+source "kernel/time/Kconfig"
+
+menu "CPU/Task time and stats accounting"
+
 config VIRT_CPU_ACCOUNTING
 	bool "Deterministic task and CPU time accounting"
 	depends on HAVE_VIRT_CPU_ACCOUNTING
@@ -305,18 +364,6 @@ config BSD_PROCESS_ACCT_V3
 	  for processing it. A preliminary version of these tools is available
 	  at <http://www.gnu.org/software/acct/>.
 
-config FHANDLE
-	bool "open by fhandle syscalls"
-	select EXPORTFS
-	help
-	  If you say Y here, a user level program will be able to map
-	  file names to handle and then later use the handle for
-	  different file system operations. This is useful in implementing
-	  userspace file servers, which now track files using handles instead
-	  of names. The handle would remain the same even if file names
-	  get renamed. Enables open_by_handle_at(2) and name_to_handle_at(2)
-	  syscalls.
-
 config TASKSTATS
 	bool "Export task/process statistics through netlink (EXPERIMENTAL)"
 	depends on NET
@@ -359,50 +406,7 @@ config TASK_IO_ACCOUNTING
 
 	  Say N if unsure.
 
-config AUDIT
-	bool "Auditing support"
-	depends on NET
-	help
-	  Enable auditing infrastructure that can be used with another
-	  kernel subsystem, such as SELinux (which requires this for
-	  logging of avc messages output).  Does not do system-call
-	  auditing without CONFIG_AUDITSYSCALL.
-
-config AUDITSYSCALL
-	bool "Enable system-call auditing support"
-	depends on AUDIT && (X86 || PPC || S390 || IA64 || UML || SPARC64 || SUPERH || (ARM && AEABI && !OABI_COMPAT))
-	default y if SECURITY_SELINUX
-	help
-	  Enable low-overhead system-call auditing infrastructure that
-	  can be used independently or with another kernel subsystem,
-	  such as SELinux.
-
-config AUDIT_WATCH
-	def_bool y
-	depends on AUDITSYSCALL
-	select FSNOTIFY
-
-config AUDIT_TREE
-	def_bool y
-	depends on AUDITSYSCALL
-	select FSNOTIFY
-
-config AUDIT_LOGINUID_IMMUTABLE
-	bool "Make audit loginuid immutable"
-	depends on AUDIT
-	help
-	  The config option toggles if a task setting its loginuid requires
-	  CAP_SYS_AUDITCONTROL or if that task should require no special permissions
-	  but should instead only allow setting its loginuid if it was never
-	  previously set.  On systems which use systemd or a similar central
-	  process to restart login services this should be set to true.  On older
-	  systems in which an admin would typically have to directly stop and
-	  start processes this should be set to false.  Setting this to true allows
-	  one to drop potentially dangerous capabilites from the login tasks,
-	  but may not be backwards compatible with older init systems.
-
-source "kernel/irq/Kconfig"
-source "kernel/time/Kconfig"
+endmenu # "CPU/Task time and stats accounting"
 
 menu "RCU Subsystem"
 
-- 
1.7.5.4

