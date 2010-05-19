Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab0ESBlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 21:41:16 -0400
Received: from mail.windriver.com ([147.11.1.11]:41255 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757172Ab0ESBkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 21:40:35 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 01/25] Move kernel/kgdb.c to kernel/debug/debug_core.c
Date: Tue, 18 May 2010 20:39:11 -0500
Message-Id: <1274233175-3675-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1274233175-3675-1-git-send-email-jason.wessel@windriver.com>
References: <1274233175-3675-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 19 May 2010 01:39:41.0703 (UTC) FILETIME=[26CEF170:01CAF6F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move kgdb.c in preparation to separate the gdbstub from the debug
core and exception handling.

CC: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/Makefile                       |    2 +-
 kernel/debug/Makefile                 |    6 ++++++
 kernel/{kgdb.c => debug/debug_core.c} |    0
 3 files changed, 7 insertions(+), 1 deletions(-)
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
index 0000000..5d78504
--- /dev/null
+++ b/kernel/debug/Makefile
@@ -0,0 +1,6 @@
+#
+# Makefile for the linux kernel debugger
+#
+
+obj-$(CONFIG_KGDB) += debug_core.o
+
diff --git a/kernel/kgdb.c b/kernel/debug/debug_core.c
similarity index 100%
rename from kernel/kgdb.c
rename to kernel/debug/debug_core.c
-- 
1.6.3.3

