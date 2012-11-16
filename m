Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751756Ab2KPOlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 09:41:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44806 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450Ab2KPOlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 09:41:13 -0500
Date: Fri, 16 Nov 2012 14:41:09 +0000
From: Mel Gorman <mgorman@suse.de>
To: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/43] mm: numa: Make pte_numa() and pmd_numa() a generic
 implementation
Message-ID: <20121116144109.GA8218@suse.de>
References: <1353064973-26082-1-git-send-email-mgorman@suse.de>
 <1353064973-26082-7-git-send-email-mgorman@suse.de>
 <50A648FF.2040707@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <50A648FF.2040707@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 09:09:03AM -0500, Rik van Riel wrote:
> On 11/16/2012 06:22 AM, Mel Gorman wrote:
> >It was pointed out by Ingo Molnar that the per-architecture definition of
> >the NUMA PTE helper functions means that each supporting architecture
> >will have to cut and paste it which is unfortunate. He suggested instead
> >that the helpers should be weak functions that can be overridden by the
> >architecture.
> >
> >This patch moves the helpers to mm/pgtable-generic.c and makes them weak
> >functions. Architectures wishing to use this will still be required to
> >define _PAGE_NUMA and potentially update their p[te|md]_present and
> >pmd_bad helpers if they choose to make PAGE_NUMA similar to PROT_NONE.
> >
> >Signed-off-by: Mel Gorman <mgorman@suse.de>
> 
> Is uninlining these simple tests really the right thing to do,
> or would they be better off as inlines in asm-generic/pgtable.h ?
> 

I would have preferred asm-generic/pgtable.h myself and use
__HAVE_ARCH_whatever tricks to keep the inlining but Ingo's suggestion
was to use __weak (https://lkml.org/lkml/2012/11/13/134) and I did not
have a strong reason to disagree. Is there a compelling choice either
way or a preference?

-- 
Mel Gorman
SUSE Labs
