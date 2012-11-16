Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789Ab2KPLXZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 06:23:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33001 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739Ab2KPLXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 06:23:20 -0500
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>
Cc: Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 17/43] sched, mm, x86: Add the ARCH_SUPPORTS_NUMA_BALANCING flag
Date: Fri, 16 Nov 2012 11:22:27 +0000
Message-Id: <1353064973-26082-18-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1353064973-26082-1-git-send-email-mgorman@suse.de>
References: <1353064973-26082-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

Allow architectures to opt-in to the adaptive affinity NUMA balancing code.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 init/Kconfig |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/init/Kconfig b/init/Kconfig
index 6fdd6e3..17434ca 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -696,6 +696,13 @@ config LOG_BUF_SHIFT
 config HAVE_UNSTABLE_SCHED_CLOCK
 	bool
 
+#
+# For architectures that want to enable the PROT_NUMA driven,
+# NUMA-affine scheduler balancing logic:
+#
+config ARCH_SUPPORTS_NUMA_BALANCING
+	bool
+
 menuconfig CGROUPS
 	boolean "Control Group support"
 	depends on EVENTFD
-- 
1.7.9.2

