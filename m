Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933275Ab0KORk4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 12:40:56 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49289 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933236Ab0KORky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 12:40:54 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Will Deacon <will.deacon@arm.com>
Subject: [PATCH v3 16/20] ARM: LPAE: Use generic dma_addr_t type definition
Date: Mon, 15 Nov 2010 17:40:25 +0000
Message-Id: <1289842829-3027-17-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.3.2.164.g6f10c
In-Reply-To: <1289842829-3027-1-git-send-email-catalin.marinas@arm.com>
References: <1289842829-3027-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 15 Nov 2010 17:40:38.0035 (UTC) FILETIME=[37040630:01CB84EC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

This patch uses the types.h implementation in asm-generic to define the
dma_addr_t type as the same width as phys_addr_t.

NOTE: this is a temporary patch until the corresponding patches unifying
the dma_addr_t and removing the dma64_addr_t are merged into mainline.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/include/asm/types.h |   20 +-------------------
 1 files changed, 1 insertions(+), 19 deletions(-)

diff --git a/arch/arm/include/asm/types.h b/arch/arm/include/asm/types.h
index 345df01..dc1bdbb 100644
--- a/arch/arm/include/asm/types.h
+++ b/arch/arm/include/asm/types.h
@@ -1,30 +1,12 @@
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
 
 #define BITS_PER_LONG 32
 
-#ifndef __ASSEMBLY__
-
-/* Dma addresses are 32-bits wide.  */
-
-typedef u32 dma_addr_t;
-typedef u32 dma64_addr_t;
-
-#endif /* __ASSEMBLY__ */
-
 #endif /* __KERNEL__ */
 
 #endif
