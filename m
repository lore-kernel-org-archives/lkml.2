Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179Ab0FIMgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 08:36:13 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:38598 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565Ab0FIMgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 08:36:11 -0400
Date: Wed, 9 Jun 2010 08:35:57 -0400
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Christoph Egger <siccegge@cs.fau.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 3/5] Removing dead CONFIG_SMP_750
Message-ID: <20100609123557.GJ7801@zod.rchland.ibm.com>
References: <cover.1275925219.git.siccegge@cs.fau.de> <8bf8cfaf47590e1a85f9510bb546ca35e3458bf8.1275925219.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bf8cfaf47590e1a85f9510bb546ca35e3458bf8.1275925219.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 09, 2010 at 12:00:21PM +0200, Christoph Egger wrote:
>CONFIG_SMP_750 doesn't exist in Kconfig, therefore removing all
>references for it from the source code.

Yeah, we don't support SMP on 750 at the moment.  This code was carried over
from the arch/ppc days, and that code was present pre-git.  I think we can
drop it, but I'll leave that up to Ben.  Maybe he has crazy plans for a 750 SMP
board.

josh

>
>Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
>---
> arch/powerpc/mm/tlb_hash32.c |    4 ----
> 1 files changed, 0 insertions(+), 4 deletions(-)
>
>diff --git a/arch/powerpc/mm/tlb_hash32.c b/arch/powerpc/mm/tlb_hash32.c
>index 8aaa8b7..925fecb 100644
>--- a/arch/powerpc/mm/tlb_hash32.c
>+++ b/arch/powerpc/mm/tlb_hash32.c
>@@ -94,11 +94,7 @@ void tlb_flush(struct mmu_gather *tlb)
>  * the cache operations on the bus.  Hence we need to use an IPI
>  * to get the other CPU(s) to invalidate their TLBs.
>  */
>-#ifdef CONFIG_SMP_750
>-#define FINISH_FLUSH	smp_send_tlb_invalidate(0)
>-#else
> #define FINISH_FLUSH	do { } while (0)
>-#endif
>
> static void flush_range(struct mm_struct *mm, unsigned long start,
> 			unsigned long end)
>-- 
>1.6.3.3
>
>_______________________________________________
>Linuxppc-dev mailing list
>Linuxppc-dev@lists.ozlabs.org
>https://lists.ozlabs.org/listinfo/linuxppc-dev
