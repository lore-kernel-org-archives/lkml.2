Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab1HJSIu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 14:08:50 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:29561 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab1HJSIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 14:08:40 -0400
X-Greylist: delayed 335 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Aug 2011 14:08:40 EDT
Message-Id: <201108101803.p7AI34fd008483@farm-0023.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 10 Aug 2011 13:53:02 -0400
Subject: [PATCH] arch/tile: use #include <asm/atomic.h> in tilepro assembly files
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 10 Aug 2011 18:03:04.0775 (UTC) FILETIME=[C0713D70:01CC5787]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The standard <linux/atomic.h> is not safe to include from assembly, and
in general there's no need for it to be, since it's not very meaningful
for assembly code.

Assembly support in tilepro for atomics does need to get some constants
from the tilepro <asm/atomic.h>, however, so fix those files back to
the way they were, to directly #include <asm/atomic.h>.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/intvec_32.S  |    2 +-
 arch/tile/lib/atomic_asm_32.S |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/tile/kernel/intvec_32.S b/arch/tile/kernel/intvec_32.S
index fc94607..72ade79 100644
--- a/arch/tile/kernel/intvec_32.S
+++ b/arch/tile/kernel/intvec_32.S
@@ -21,7 +21,7 @@
 #include <asm/ptrace.h>
 #include <asm/thread_info.h>
 #include <asm/irqflags.h>
-#include <linux/atomic.h>
+#include <asm/atomic.h>
 #include <asm/asm-offsets.h>
 #include <hv/hypervisor.h>
 #include <arch/abi.h>
diff --git a/arch/tile/lib/atomic_asm_32.S b/arch/tile/lib/atomic_asm_32.S
index 1f75a2a..2444873 100644
--- a/arch/tile/lib/atomic_asm_32.S
+++ b/arch/tile/lib/atomic_asm_32.S
@@ -70,7 +70,7 @@
  */
 
 #include <linux/linkage.h>
-#include <linux/atomic.h>
+#include <asm/atomic.h>
 #include <asm/page.h>
 #include <asm/processor.h>
 
-- 
1.6.5.2

