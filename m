Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932727Ab2FGSAS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 14:00:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:44258 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056Ab2FGSAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 14:00:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="154348264"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        rostedt@goodmis.org
Subject: [PATCH] perf: Don't disable function tracing for perf
Date: Thu,  7 Jun 2012 10:59:56 -0700
Message-Id: <1339091996-24109-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

According to Steven there is no reason left to not do function
tracing for perf code. So remove the -pg for the x86 and core
perf code. This makes perf easier to debug.

Cc: rostedt@goodmis.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/Makefile |    1 -
 kernel/events/Makefile       |    4 ----
 2 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 6ab6aa2..5bd8b32 100644
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

