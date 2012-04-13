Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209Ab2DMJWy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 05:22:54 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42300 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757864Ab2DMJWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 05:22:53 -0400
Date: Fri, 13 Apr 2012 10:22:40 +0100
From: Will Deacon <will.deacon@arm.com>
To: Hugh Dickins <hughd@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Nicolas Pitre <nico@linaro.org>, akpm@linux-foundation.org
Subject: Re: [PATCH] Revert "proc: clear_refs: do not clear reserved pages"
Message-ID: <20120413092240.GC394@mudshark.cambridge.arm.com>
References: <1334250034-29866-1-git-send-email-will.deacon@arm.com>
 <alpine.LSU.2.00.1204121049120.2288@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1204121049120.2288@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 06:51:10PM +0100, Hugh Dickins wrote:
> On Thu, 12 Apr 2012, Will Deacon wrote:
> 
> > This reverts commit 85e72aa5384b1a614563ad63257ded0e91d1a620, which was
> > a quick fix suitable for -stable until ARM had been moved over to the
> > gate_vma mechanism:
> > 
> > https://lkml.org/lkml/2012/1/14/55
> > 
> > With commit f9d4861f ("ARM: 7294/1: vectors: use gate_vma for vectors user
> > mapping"), ARM does now use the gate_vma, so the PageReserved check can
> > be removed from the proc code.
> > 
> > Cc: Nicolas Pitre <nico@linaro.org>
> > Signed-off-by: Will Deacon <will.deacon@arm.com>
> 
> Oh, great, I'm glad that worked out: thanks a lot for looking after it,
> Will, and now cleaning up afterwards.
> 
> Acked-by: Hugh Dickins <hughd@google.com>

Thanks, Hugh. I guess it's easiest if Andrew picks this one up as he took
the original patch.

Will

> > ---
> >  fs/proc/task_mmu.c |    3 ---
> >  1 files changed, 0 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > index 2b9a760..2d60492 100644
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -597,9 +597,6 @@ static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
> >  		if (!page)
> >  			continue;
> >  
> > -		if (PageReserved(page))
> > -			continue;
> > -
> >  		/* Clear accessed and referenced bits. */
> >  		ptep_test_and_clear_young(vma, addr, pte);
> >  		ClearPageReferenced(page);
> > -- 
> > 1.7.4.1
> > 
> > 
> 
