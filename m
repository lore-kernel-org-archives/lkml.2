Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab0JYJBD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 05:01:03 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46512 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754592Ab0JYJAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 05:00:54 -0400
Subject: [RFC PATCH 13/18] ARM: LPAE: ensure dma_addr_t is the same size as
 phys_addr_t
To: linux-arm-kernel@lists.infradead.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org
Date: Mon, 25 Oct 2010 10:00:46 +0100
Message-ID: <20101025090046.25275.80297.stgit@e102109-lin.cambridge.arm.com>
In-Reply-To: <20101025085812.25275.55757.stgit@e102109-lin.cambridge.arm.com>
References: <20101025085812.25275.55757.stgit@e102109-lin.cambridge.arm.com>
User-Agent: StGit/0.15-103-g0e84
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Oct 2010 09:00:47.0330 (UTC) FILETIME=[1D3B6420:01CB7423]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

Now that phys_addr_t can be 64-bit on ARM, we must ensure that dma_addr_t
is sufficiently large to hold physical addresses.

This patch uses the types.h implementation in asm-generic to define the
dma_addr_t type as the same width as phys_addr_t.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/include/asm/types.h |   19 ++-----------------
 1 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/arch/arm/include/asm/types.h b/arch/arm/include/asm/types.h
index 345df01..039dd8f 100644
--- a/arch/arm/include/asm/types.h
+++ b/arch/arm/include/asm/types.h
@@ -1,28 +1,13 @@
 #ifndef __ASM_ARM_TYPES_H
 #define __ASM_ARM_TYPES_H
 
-#include <asm-generic/int-ll64.h>
+#include <asm-generic/types.h>
 
-#ifndef __ASSEMBLY__
-
-typedef unsigned short umode_t;
-
-#endif /* __ASSEMBLY__ */
-
-/*
- * These aren't exported outside the kernel to avoid name space clashes
- */
 #ifdef __KERNEL__
-
 #define BITS_PER_LONG 32
 
 #ifndef __ASSEMBLY__
-
-/* Dma addresses are 32-bits wide.  */
-
-typedef u32 dma_addr_t;
-typedef u32 dma64_addr_t;
-
+typedef dma_addr_t dma64_addr_t;
 #endif /* __ASSEMBLY__ */
 
 #endif /* __KERNEL__ */

