Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab2JGXYq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:24:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38739 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754716Ab2JGXXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:23:32 -0400
Message-Id: <20121007225837.493815951@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:58:54 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Matthew Leach <matthew.leach@arm.com>,
        Nicolas Pitre <nico@fluxnic.net>, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 020/108] ARM: 7532/1: decompressor: reset SCTLR.TRE for VMSA ARMv7 cores
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Leach <matthew.leach@arm.com>

commit e1e5b7e4251c7538ca08c2c5545b0c2fbd8a6635 upstream.

This patch zeroes the SCTLR.TRE bit prior to setting the mapping as
cacheable for ARMv7 cores in the decompressor, ensuring that the
memory region attributes are obtained from the C and B bits, not from
the page tables.

Cc: Nicolas Pitre <nico@fluxnic.net>
Reviewed-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Matthew Leach <matthew.leach@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/boot/compressed/head.S |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index 81769c1..bc67cbf 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -653,6 +653,7 @@ __armv7_mmu_cache_on:
 		mcrne	p15, 0, r0, c8, c7, 0	@ flush I,D TLBs
 #endif
 		mrc	p15, 0, r0, c1, c0, 0	@ read control reg
+		bic	r0, r0, #1 << 28	@ clear SCTLR.TRE
 		orr	r0, r0, #0x5000		@ I-cache enable, RR cache replacement
 		orr	r0, r0, #0x003c		@ write buffer
 #ifdef CONFIG_MMU


