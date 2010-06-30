Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab0F3QCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 12:02:19 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:40082 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756880Ab0F3QCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 12:02:17 -0400
Date: Wed, 30 Jun 2010 18:02:14 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH 26/33] Removing dead XSCALE_CACHE_ERRATA
Message-ID: <e9515441013afc8e866f3081dd35bbe0122ece5e.1277911346.git.siccegge@cs.fau.de>
References: <cover.1277911345.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1277911345.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

XSCALE_CACHE_ERRATA doesn't exist in Kconfig, therefore removing all
references for it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 arch/arm/mach-pxa/sleep.S |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-pxa/sleep.S b/arch/arm/mach-pxa/sleep.S
index 2ed95f3..52c30b0 100644
--- a/arch/arm/mach-pxa/sleep.S
+++ b/arch/arm/mach-pxa/sleep.S
@@ -339,10 +339,6 @@ ENTRY(pxa_cpu_resume)
 	mcr	p15, 0, r1, c8, c7, 0   	@ invalidate I & D TLBs
 	mcr	p15, 0, r1, c7, c7, 0		@ invalidate I & D caches, BTB
 
-#ifdef CONFIG_XSCALE_CACHE_ERRATA
-	bic     r9, r9, #0x0004			@ see cpu_xscale_proc_init
-#endif
-
 	mcr	p14, 0, r3, c6, c0, 0		@ clock configuration, turbo mode.
 	mcr	p15, 0, r4, c15, c1, 0		@ CP access reg
 	mcr	p15, 0, r5, c13, c0, 0		@ PID
@@ -368,9 +364,6 @@ sleep_save_sp:
 
 	.text
 resume_after_mmu:
-#ifdef CONFIG_XSCALE_CACHE_ERRATA
-	bl	cpu_xscale_proc_init
-#endif
 	ldmfd	sp!, {r2, r3}
 #ifndef CONFIG_IWMMXT
 	mar	acc0, r2, r3
-- 
1.7.0.4

