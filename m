Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab2KPQQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 11:16:59 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:54159 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab2KPQQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 11:16:57 -0500
Date: Fri, 16 Nov 2012 17:16:52 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Benchmark results: "Enhanced NUMA scheduling with adaptive
 affinity"
Message-ID: <20121116161652.GB4302@gmail.com>
References: <20121112160451.189715188@chello.nl>
 <20121112184833.GA17503@gmail.com>
 <20121115100805.GS8218@suse.de>
 <CA+55aFyEJwRvQezg3oKg71Nk9+1QU7qwvo0BH4ykReKxNhFJRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyEJwRvQezg3oKg71Nk9+1QU7qwvo0BH4ykReKxNhFJRg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> [...]
> 
> I would ask the involved people to please come up with a set 
> of initial patches that people agree on, so that we can at 
> least start merging some of the infrastructure, and see how 
> far we can get on at least getting *started*.

That would definitely be a step forward.

> [...] As I mentioned to Andrew and Mel separately, nobody 
> seems to disagree with the TLB optimization patches. What 
> else? Is Mel's set of early patches still considered a 
> reasonable starting point for everybody?

My suggestion for a 'foundation' would be all the non-policy 
bits in numa/core:

c740b1cccdcb x86/mm: Completely drop the TLB flush from ptep_set_access_flags()
02743c9c03f1 mm/mpol: Use special PROT_NONE to migrate pages
b33467764d8a mm/migrate: Introduce migrate_misplaced_page()
db4aa58db59a numa, mm: Support NUMA hinting page faults from gup/gup_fast
ca2ea0747a5b mm/mpol: Add MPOL_MF_LAZY
f05ea0948708 mm/mpol: Create special PROT_NONE infrastructure
37081a3de2bf mm/mpol: Check for misplaced page
cd203e33c39d mm/mpol: Add MPOL_MF_NOOP
88f4670789e3 mm/mpol: Make MPOL_LOCAL a real policy
83babc0d2944 mm/pgprot: Move the pgprot_modify() fallback definition to mm.h
536165ead34b sched, numa, mm, MIPS/thp: Add pmd_pgprot() implementation
6fe64360a759 mm: Only flush the TLB when clearing an accessible pte
e9df40bfeb25 x86/mm: Introduce pte_accessible()
3f2b613771ec mm/thp: Preserve pgprot across huge page split
a5a608d83e0e sched, numa, mm, s390/thp: Implement pmd_pgprot() for s390
995334a2ee83 sched, numa, mm: Describe the NUMA scheduling problem formally
7ee9d9209c57 sched, numa, mm: Make find_busiest_queue() a method
4fd98847ba5c x86/mm: Only do a local tlb flush in ptep_set_access_flags()
d24fc0571afb mm/generic: Only flush the local TLB in ptep_set_access_flags()

Which I've pushed out into the separate numa/base tree:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git numa/base

These are just the minimal set of patches needed to get to be 
able to concentrate on the real details.

AFAICS Mel started going in this design direction as well in his 
latest patches, so there should be no real technical objections 
to this other than any details I might have missed: and I'll 
rebase this tree if the mm/ folks have any other suggestions for 
improvement, as that seems the be the preferred mm workflow.

Andrea, Mel?

Getting this out of the way would be a big help.

Thanks,

	Ingo
