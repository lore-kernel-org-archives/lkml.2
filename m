Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386Ab0FIKAZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 06:00:25 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:64717 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756651Ab0FIKAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 06:00:23 -0400
Date: Wed, 9 Jun 2010 12:00:21 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH 3/5] Removing dead CONFIG_SMP_750
Message-ID: <8bf8cfaf47590e1a85f9510bb546ca35e3458bf8.1275925219.git.siccegge@cs.fau.de>
References: <cover.1275925219.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1275925219.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_SMP_750 doesn't exist in Kconfig, therefore removing all
references for it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 arch/powerpc/mm/tlb_hash32.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/mm/tlb_hash32.c b/arch/powerpc/mm/tlb_hash32.c
index 8aaa8b7..925fecb 100644
--- a/arch/powerpc/mm/tlb_hash32.c
+++ b/arch/powerpc/mm/tlb_hash32.c
@@ -94,11 +94,7 @@ void tlb_flush(struct mmu_gather *tlb)
  * the cache operations on the bus.  Hence we need to use an IPI
  * to get the other CPU(s) to invalidate their TLBs.
  */
-#ifdef CONFIG_SMP_750
-#define FINISH_FLUSH	smp_send_tlb_invalidate(0)
-#else
 #define FINISH_FLUSH	do { } while (0)
-#endif
 
 static void flush_range(struct mm_struct *mm, unsigned long start,
 			unsigned long end)
-- 
1.6.3.3

