Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972Ab2BAVIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:08:30 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48105 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756028Ab2BAVI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:08:27 -0500
X-Sasl-enc: mtb4v3jemye5OLXUdw2yquQfYZJsy6ccQagkG3vl5E+X 1328130506
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 12:57:39 2012
Message-Id: <20120201205739.581973780@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:56:04 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [24/65] ARM: 7296/1: proc-v7.S: remove HARVARD_CACHE preprocessor guards
In-Reply-To: <20120201210236.GA25966@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit 612539e81f655f6ac73c7af1da8701c1ee618aee upstream.

On v7, we use the same cache maintenance instructions for data lines
as for unified lines. This was not the case for v6, where HARVARD_CACHE
was defined to indicate the L1 cache topology.

This patch removes the erroneous compile-time check for HARVARD_CACHE in
proc-v7.S, ensuring that we perform I-side invalidation at boot.

Reported-and-Acked-by: Shawn Guo <shawn.guo@linaro.org>

Acked-by: Catalin Marinas <Catalin.Marinas@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mm/proc-v7.S |    6 ------
 1 file changed, 6 deletions(-)

--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -270,10 +270,6 @@ cpu_resume_l1_flags:
  *	Initialise TLB, Caches, and MMU state ready to switch the MMU
  *	on.  Return in r0 the new CP15 C1 control register setting.
  *
- *	We automatically detect if we have a Harvard cache, and use the
- *	Harvard cache control instructions insead of the unified cache
- *	control instructions.
- *
  *	This should be able to cover all ARMv7 cores.
  *
  *	It is assumed that:
@@ -363,9 +359,7 @@ __v7_setup:
 #endif
 
 3:	mov	r10, #0
-#ifdef HARVARD_CACHE
 	mcr	p15, 0, r10, c7, c5, 0		@ I+BTB cache invalidate
-#endif
 	dsb
 #ifdef CONFIG_MMU
 	mcr	p15, 0, r10, c8, c7, 0		@ invalidate I + D TLBs


