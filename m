Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965055Ab2EYRJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 13:09:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933088Ab2EYRDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 13:03:35 -0400
From: Andrea Arcangeli <aarcange@redhat.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>
Subject: [PATCH 10/35] autonuma: define the autonuma flags
Date: Fri, 25 May 2012 19:02:14 +0200
Message-Id: <1337965359-29725-11-git-send-email-aarcange@redhat.com>
In-Reply-To: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
References: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These flags are the ones tweaked through sysfs, they control the
behavior of autonuma, from enabling disabling it, to selecting various
runtime options.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 include/linux/autonuma_flags.h |   62 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 62 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/autonuma_flags.h

diff --git a/include/linux/autonuma_flags.h b/include/linux/autonuma_flags.h
new file mode 100644
index 0000000..9c702fd
--- /dev/null
+++ b/include/linux/autonuma_flags.h
@@ -0,0 +1,62 @@
+#ifndef _LINUX_AUTONUMA_FLAGS_H
+#define _LINUX_AUTONUMA_FLAGS_H
+
+enum autonuma_flag {
+	AUTONUMA_FLAG,
+	AUTONUMA_IMPOSSIBLE,
+	AUTONUMA_DEBUG_FLAG,
+	AUTONUMA_SCHED_LOAD_BALANCE_STRICT_FLAG,
+	AUTONUMA_SCHED_CLONE_RESET_FLAG,
+	AUTONUMA_SCHED_FORK_RESET_FLAG,
+	AUTONUMA_SCAN_PMD_FLAG,
+	AUTONUMA_SCAN_USE_WORKING_SET_FLAG,
+	AUTONUMA_MIGRATE_DEFER_FLAG,
+};
+
+extern unsigned long autonuma_flags;
+
+static bool inline autonuma_enabled(void)
+{
+	return !!test_bit(AUTONUMA_FLAG, &autonuma_flags);
+}
+
+static bool inline autonuma_debug(void)
+{
+	return !!test_bit(AUTONUMA_DEBUG_FLAG, &autonuma_flags);
+}
+
+static bool inline autonuma_sched_load_balance_strict(void)
+{
+	return !!test_bit(AUTONUMA_SCHED_LOAD_BALANCE_STRICT_FLAG,
+			  &autonuma_flags);
+}
+
+static bool inline autonuma_sched_clone_reset(void)
+{
+	return !!test_bit(AUTONUMA_SCHED_CLONE_RESET_FLAG,
+			  &autonuma_flags);
+}
+
+static bool inline autonuma_sched_fork_reset(void)
+{
+	return !!test_bit(AUTONUMA_SCHED_FORK_RESET_FLAG,
+			  &autonuma_flags);
+}
+
+static bool inline autonuma_scan_pmd(void)
+{
+	return !!test_bit(AUTONUMA_SCAN_PMD_FLAG, &autonuma_flags);
+}
+
+static bool inline autonuma_scan_use_working_set(void)
+{
+	return !!test_bit(AUTONUMA_SCAN_USE_WORKING_SET_FLAG,
+			  &autonuma_flags);
+}
+
+static bool inline autonuma_migrate_defer(void)
+{
+	return !!test_bit(AUTONUMA_MIGRATE_DEFER_FLAG, &autonuma_flags);
+}
+
+#endif /* _LINUX_AUTONUMA_FLAGS_H */
