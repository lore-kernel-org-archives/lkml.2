Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab2KPQI7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 11:08:59 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:41043 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594Ab2KPQI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 11:08:58 -0500
Date: Fri, 16 Nov 2012 17:08:52 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/43] mm: numa: Make pte_numa() and pmd_numa() a generic
 implementation
Message-ID: <20121116160852.GA4302@gmail.com>
References: <1353064973-26082-1-git-send-email-mgorman@suse.de>
 <1353064973-26082-7-git-send-email-mgorman@suse.de>
 <50A648FF.2040707@redhat.com>
 <20121116144109.GA8218@suse.de>
 <CA+55aFzH_-6FuwTF1GVDzLK+7c0MGLsLdPFjzzwU78GVUEMbBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzH_-6FuwTF1GVDzLK+7c0MGLsLdPFjzzwU78GVUEMbBw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, Nov 16, 2012 at 6:41 AM, Mel Gorman <mgorman@suse.de> wrote:
> >
> > I would have preferred asm-generic/pgtable.h myself and use
> > __HAVE_ARCH_whatever tricks
> 
> PLEASE NO!
> 
> Dammit, why is this disease still so prevalent, and why do people
> continue to do this crap?

Also, why is this done in a weird, roundabout way of first 
picking up a bad patch and then modifying it and making it even 
worse?

Why not use something what we have in numa/core already:

  f05ea0948708 mm/mpol: Create special PROT_NONE infrastructure

AFAICS, this portion of numa/core:

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

is a good foundation already with no WIP policy bits in it.

Mel, could you please work on this basis, or point out the bits 
you don't agree with so I can fix it?

Since I'm working on improving the policy bits I essentially 
need and have done all the 'foundation' work already - you might 
as well reuse it as-is instead of rebasing it?

Thanks,

	Ingo
