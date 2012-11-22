Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823Ab2KVWvO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:51:14 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:43246 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758766Ab2KVWvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 17:51:06 -0500
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>
Subject: [PATCH 15/33] sched, numa, mm, arch: Add variable locality exception
Date: Thu, 22 Nov 2012 23:49:36 +0100
Message-Id: <1353624594-1118-16-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353624594-1118-1-git-send-email-mingo@kernel.org>
References: <1353624594-1118-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Some architectures (ab)use NUMA to represent different memory
regions all cpu-local but of different latencies, such as SuperH.

The naming comes from Mel Gorman.

Named-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/sh/mm/Kconfig | 1 +
 init/Kconfig       | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/arch/sh/mm/Kconfig b/arch/sh/mm/Kconfig
index cb8f992..5d2a4df 100644
--- a/arch/sh/mm/Kconfig
+++ b/arch/sh/mm/Kconfig
@@ -111,6 +111,7 @@ config VSYSCALL
 config NUMA
 	bool "Non Uniform Memory Access (NUMA) Support"
 	depends on MMU && SYS_SUPPORTS_NUMA && EXPERIMENTAL
+	select ARCH_WANTS_NUMA_VARIABLE_LOCALITY
 	default n
 	help
 	  Some SH systems have many various memories scattered around
diff --git a/init/Kconfig b/init/Kconfig
index f36c83d..b8a4a58 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -718,6 +718,13 @@ config ARCH_USES_NUMA_GENERIC_PGPROT_HUGEPAGE
 	depends on ARCH_USES_NUMA_GENERIC_PGPROT
 	depends on TRANSPARENT_HUGEPAGE
 
+#
+# For architectures that (ab)use NUMA to represent different memory regions
+# all cpu-local but of different latencies, such as SuperH.
+#
+config ARCH_WANTS_NUMA_VARIABLE_LOCALITY
+	bool
+
 menuconfig CGROUPS
 	boolean "Control Group support"
 	depends on EVENTFD
-- 
1.7.11.7

