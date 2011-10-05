Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934592Ab1JEV17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 17:27:59 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:53392 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505Ab1JEV16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 17:27:58 -0400
X-Greylist: delayed 910 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Oct 2011 17:27:58 EDT
Message-Id: <201110052112.p95LCi4U007468@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 5 Oct 2011 17:09:29 -0400
Subject: [PATCH] tile: revert change from <asm/atomic.h> to <linux/atomic.h> in asm files
To: Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>, Arun Sharma <asharma@fb.com>,
        linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 05 Oct 2011 21:12:47.0244 (UTC) FILETIME=[880E2CC0:01CC83A3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 32-bit TILEPro support uses some #defines in <asm/atomic_32.h>
for atomic support routines in assembly.  To make this more explicit,
I've turned those includes into includes of <asm/atomic_32.h>, which
should hopefully make it clear that they shouldn't be bombed into
<linux/atomic.h> in any cleanups.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/intvec_32.S  |    2 +-
 arch/tile/lib/atomic_asm_32.S |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/tile/kernel/intvec_32.S b/arch/tile/kernel/intvec_32.S
index fc94607..aecc8ed 100644
--- a/arch/tile/kernel/intvec_32.S
+++ b/arch/tile/kernel/intvec_32.S
@@ -21,7 +21,7 @@
 #include <asm/ptrace.h>
 #include <asm/thread_info.h>
 #include <asm/irqflags.h>
-#include <linux/atomic.h>
+#include <asm/atomic_32.h>
 #include <asm/asm-offsets.h>
 #include <hv/hypervisor.h>
 #include <arch/abi.h>
diff --git a/arch/tile/lib/atomic_asm_32.S b/arch/tile/lib/atomic_asm_32.S
index 1f75a2a..3063804 100644
--- a/arch/tile/lib/atomic_asm_32.S
+++ b/arch/tile/lib/atomic_asm_32.S
@@ -70,7 +70,7 @@
  */
 
 #include <linux/linkage.h>
-#include <linux/atomic.h>
+#include <asm/atomic_32.h>
 #include <asm/page.h>
 #include <asm/processor.h>
 
-- 
1.6.5.2

