Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab2HRQQf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 12:16:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:47092 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754901Ab2HRQPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 12:15:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,791,1336374000"; 
   d="scan'208";a="182344836"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, rostedt@goodmis.org
Subject: [PATCH 2/2] perf: Enable function tracing for perf core
Date: Sat, 18 Aug 2012 09:15:30 -0700
Message-Id: <1345306530-25665-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345306530-25665-1-git-send-email-andi@firstfloor.org>
References: <1345306530-25665-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

According to Steven R. there is no reason left to not support
function tracing for the perf core. This makes it easier to debug
perf.

Don't remove -pg for the x86 and generic perf core.

Cc: rostedt@goodmis.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/Makefile |    1 -
 kernel/events/Makefile       |    4 ----
 2 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index d30a6a9..6a16725 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -5,7 +5,6 @@
 # Don't trace early stages of a secondary CPU boot
 ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_common.o = -pg
-CFLAGS_REMOVE_perf_event.o = -pg
 endif
 
 # Make sure load_percpu_segment has no stackprotector
diff --git a/kernel/events/Makefile b/kernel/events/Makefile
index 103f5d1..a630994 100644
--- a/kernel/events/Makefile
+++ b/kernel/events/Makefile
@@ -1,7 +1,3 @@
-ifdef CONFIG_FUNCTION_TRACER
-CFLAGS_REMOVE_core.o = -pg
-endif
-
 obj-y := core.o ring_buffer.o callchain.o
 
 obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
-- 
1.7.7.6

