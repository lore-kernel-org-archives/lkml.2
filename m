Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309Ab2KMRPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 12:15:42 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37723 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932292Ab2KMRPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 12:15:38 -0500
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Paul Turner <pjt@google.com>, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 25/31] sched, mm, x86: Add the ARCH_SUPPORTS_NUMA_BALANCING flag
Date: Tue, 13 Nov 2012 18:13:48 +0100
Message-Id: <1352826834-11774-26-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352826834-11774-1-git-send-email-mingo@kernel.org>
References: <1352826834-11774-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 init/Kconfig | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/init/Kconfig b/init/Kconfig
index ae412fd..78807b3 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -703,6 +703,13 @@ config HAVE_UNSTABLE_SCHED_CLOCK
 config ARCH_WANT_NUMA_VARIABLE_LOCALITY
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

