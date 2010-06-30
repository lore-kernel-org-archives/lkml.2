Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337Ab0F3PzI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 11:55:08 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:39521 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754492Ab0F3PzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 11:55:06 -0400
Date: Wed, 30 Jun 2010 17:55:03 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: David Brown <davidb@codeaurora.org>,
       Daniel Walker <dwalker@codeaurora.org>,
       Bryan Huntsman <bryanh@codeaurora.org>,
       Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH 04/33] Removing dead MSM7X00A_IDLE
Message-ID: <c7e75d44aebaaabfdff9cf5fbda54512d0062728.1277911346.git.siccegge@cs.fau.de>
References: <cover.1277911345.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1277911345.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MSM7X00A_IDLE doesn't exist in Kconfig, therefore removing all
references for it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 arch/arm/mach-msm/idle.S |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mach-msm/idle.S b/arch/arm/mach-msm/idle.S
index 6a94f05..d8e8027 100644
--- a/arch/arm/mach-msm/idle.S
+++ b/arch/arm/mach-msm/idle.S
@@ -20,17 +20,4 @@
 #include <asm/assembler.h>
 
 ENTRY(arch_idle)
-#ifdef CONFIG_MSM7X00A_IDLE
-	mrc     p15, 0, r1, c1, c0, 0    /* read current CR    */
-	bic     r0, r1, #(1 << 2)        /* clear dcache bit   */
-	bic     r0, r0, #(1 << 12)       /* clear icache bit   */
-	mcr     p15, 0, r0, c1, c0, 0    /* disable d/i cache  */
-
-	mov     r0, #0                   /* prepare wfi value  */
-	mcr     p15, 0, r0, c7, c10, 0   /* flush the cache    */
-	mcr     p15, 0, r0, c7, c10, 4   /* memory barrier     */
-	mcr     p15, 0, r0, c7, c0, 4    /* wait for interrupt */
-
-	mcr     p15, 0, r1, c1, c0, 0    /* restore d/i cache  */
-#endif
 	mov     pc, lr
-- 
1.7.0.4

