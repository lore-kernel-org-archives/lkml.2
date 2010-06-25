Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab0FYVLO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 17:11:14 -0400
Received: from king.tilera.com ([72.1.168.226]:44209 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755549Ab0FYVLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 17:11:01 -0400
Message-Id: <201006252110.o5PLArnp010772@farm-0002.internal.tilera.com>
To: linux-kernel@vger.kernel.org
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 25 Jun 2010 17:02:40 -0400
Subject: [PATCH] arch/tile: Fix bug in support for atomic64_xx() ops.
X-OriginalArrivalTime: 25 Jun 2010 21:10:53.0704 (UTC) FILETIME=[E5781880:01CB14AA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This wasn't properly tested until the perf-event subsystem started
to get brought up under the tile architecture.

The bug caused bogus atomic64_cmpxchg() values to be returned,
among other things.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/lib/atomic_asm_32.S |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/tile/lib/atomic_asm_32.S b/arch/tile/lib/atomic_asm_32.S
index c0d0585..5a5514b 100644
--- a/arch/tile/lib/atomic_asm_32.S
+++ b/arch/tile/lib/atomic_asm_32.S
@@ -89,11 +89,11 @@ STD_ENTRY_SECTION(__atomic\name, .text.atomic)
 	 lh     r22, r0
 	 .else
 	 lw     r22, r0
-	 addi   r23, r0, 4
+	 addi   r28, r0, 4
 	 .endif
 	}
 	.ifc \bitwidth,64
-	lw      r23, r23
+	lw      r23, r28
 	.endif
 	\body /* set r24, and r25 if 64-bit */
 	{
@@ -109,11 +109,10 @@ STD_ENTRY_SECTION(__atomic\name, .text.atomic)
 	 sh     r0, r24
 	 .else
 	 sw     r0, r24
-	 addi   r23, r0, 4
 	 .endif
 	}
 	.ifc \bitwidth,64
-	sw      r23, r25
+	sw      r28, r25
 	.endif
 	mf
 3:	{
-- 
1.6.5.2

