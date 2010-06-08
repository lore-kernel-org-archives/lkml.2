Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab0FHL5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 07:57:46 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44088 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317Ab0FHL5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 07:57:45 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <oleg@redhat.com>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH 04/10] oom: move sysctl declarations to oom.h
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100608204621.767A.A69D9226@jp.fujitsu.com>
References: <20100608204621.767A.A69D9226@jp.fujitsu.com>
Message-Id: <20100608205632.7686.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  8 Jun 2010 20:57:42 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Rientjes <rientjes@google.com>

The three oom killer sysctl variables (sysctl_oom_dump_tasks,
sysctl_oom_kill_allocating_task, and sysctl_panic_on_oom) are better
declared in include/linux/oom.h rather than kernel/sysctl.c.

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/linux/oom.h |    6 ++++++
 kernel/sysctl.c     |    4 +---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/linux/oom.h b/include/linux/oom.h
index effb223..14eb449 100644
--- a/include/linux/oom.h
+++ b/include/linux/oom.h
@@ -45,5 +45,11 @@ static inline void oom_killer_enable(void)
 {
 	oom_killer_disabled = false;
 }
+
+/* sysctls */
+extern int sysctl_oom_dump_tasks;
+extern int sysctl_oom_kill_allocating_task;
+extern int sysctl_panic_on_oom;
+
 #endif /* __KERNEL__*/
 #endif /* _INCLUDE_LINUX_OOM_H */
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 88ac884..4dfd618 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -55,6 +55,7 @@
 #include <linux/perf_event.h>
 #include <linux/kprobes.h>
 #include <linux/pipe_fs_i.h>
+#include <linux/oom.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -87,9 +88,6 @@
 /* External variables not in a header file. */
 extern int sysctl_overcommit_memory;
 extern int sysctl_overcommit_ratio;
-extern int sysctl_panic_on_oom;
-extern int sysctl_oom_kill_allocating_task;
-extern int sysctl_oom_dump_tasks;
 extern int max_threads;
 extern int core_uses_pid;
 extern int suid_dumpable;
-- 
1.6.5.2



