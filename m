Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab0CVTUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 15:20:25 -0400
Received: from mail.windriver.com ([147.11.1.11]:36487 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755597Ab0CVTSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 15:18:15 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/8] Move kernel/kgdb.c to kernel/debug/debug_core.c
Date: Mon, 22 Mar 2010 14:17:22 -0500
Message-Id: <1269285449-1424-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1269285449-1424-1-git-send-email-jason.wessel@windriver.com>
References: <1269285449-1424-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 22 Mar 2010 19:17:36.0314 (UTC) FILETIME=[54AA71A0:01CAC9F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move kgdb.c in preparation to separate the gdbstub from the debug
core and exception handling.

CC: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/Makefile                       |    2 +-
 kernel/debug/Makefile                 |    5 +++++
 kernel/{kgdb.c => debug/debug_core.c} |    0
 3 files changed, 6 insertions(+), 1 deletions(-)
 create mode 100644 kernel/debug/Makefile
 rename kernel/{kgdb.c => debug/debug_core.c} (100%)

diff --git a/kernel/Makefile b/kernel/Makefile
index a987aa1..80b17ce 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -75,7 +75,7 @@ obj-$(CONFIG_AUDITSYSCALL) += auditsc.o
 obj-$(CONFIG_GCOV_KERNEL) += gcov/
 obj-$(CONFIG_AUDIT_TREE) += audit_tree.o
 obj-$(CONFIG_KPROBES) += kprobes.o
-obj-$(CONFIG_KGDB) += kgdb.o
+obj-$(CONFIG_KGDB) += debug/
 obj-$(CONFIG_DETECT_SOFTLOCKUP) += softlockup.o
 obj-$(CONFIG_DETECT_HUNG_TASK) += hung_task.o
 obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
diff --git a/kernel/debug/Makefile b/kernel/debug/Makefile
new file mode 100644
index 0000000..5287fc8
--- /dev/null
+++ b/kernel/debug/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for the linux kernel debugger
+#
+
+obj-$(CONFIG_KGDB) += debug_core.o
\ No newline at end of file
diff --git a/kernel/kgdb.c b/kernel/debug/debug_core.c
similarity index 100%
rename from kernel/kgdb.c
rename to kernel/debug/debug_core.c
-- 
1.6.4.rc1

