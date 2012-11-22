Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964860Ab2KVW4u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:56:50 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42291 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758809Ab2KVWvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 17:51:12 -0500
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
Subject: [PATCH 17/33] sched, mm, x86: Add the ARCH_SUPPORTS_NUMA_BALANCING flag
Date: Thu, 22 Nov 2012 23:49:38 +0100
Message-Id: <1353624594-1118-18-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353624594-1118-1-git-send-email-mingo@kernel.org>
References: <1353624594-1118-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow architectures to opt-in to the adaptive affinity NUMA balancing code.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 init/Kconfig | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/init/Kconfig b/init/Kconfig
index b8a4a58..cf3e79c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -725,6 +725,13 @@ config ARCH_USES_NUMA_GENERIC_PGPROT_HUGEPAGE
 config ARCH_WANTS_NUMA_VARIABLE_LOCALITY
 	bool
 
+#
+# For architectures that want to enable the PROT_NONE driven,
+# NUMA-affine scheduler balancing logic:
+#
+config ARCH_SUPPORTS_NUMA_BALANCING
+	bool
+
 menuconfig CGROUPS
 	boolean "Control Group support"
 	depends on EVENTFD
-- 
1.7.11.7

