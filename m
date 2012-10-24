Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934570Ab2JXJfc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 05:35:32 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45907 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932132Ab2JXJf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 05:35:29 -0400
Date: Wed, 24 Oct 2012 10:35:10 +0100
From: Will Deacon <will.deacon@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "mhocko@suse.cz" <mhocko@suse.cz>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        "aarcange@redhat.com" <aarcange@redhat.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        Steve Capper <Steve.Capper@arm.com>
Subject: Re: [PATCH v2] mm: thp: Set the accessed flag for old pages on
 access fault.
Message-ID: <20121024093510.GB23775@mudshark.cambridge.arm.com>
References: <20121017130125.GH5973@mudshark.cambridge.arm.com>
 <20121017.112620.1865348978594874782.davem@davemloft.net>
 <20121017155401.GJ5973@mudshark.cambridge.arm.com>
 <20121018150502.3dee7899.akpm@linux-foundation.org>
 <20121019091016.GA4582@mudshark.cambridge.arm.com>
 <20121019114955.3a0c2b66.akpm@linux-foundation.org>
 <20121022103503.GA26619@mudshark.cambridge.arm.com>
 <20121022111843.4406850d.akpm@linux-foundation.org>
 <20121023101125.GA20210@mudshark.cambridge.arm.com>
 <20121023145027.40710e7a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121023145027.40710e7a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 10:50:27PM +0100, Andrew Morton wrote:
> On Tue, 23 Oct 2012 11:11:25 +0100
> Will Deacon <will.deacon@arm.com> wrote:
> > This patch ("mm: thp: Set the accessed flag for old pages on access fault")
> > doesn't depend on "ARM: mm: Transparent huge page support for LPAE systems"
> > because currently transparent huge pages cannot be enabled for ARM in
> > mainline (or linux-next). update_mmu_cache_pmd is only called from
> > mm/huge_memory.c, which depends on CONFIG_TRANSPARENT_HUGEPAGE=y.
> > 
> > As for the new huge_pmd_set_accessed function... there's a similar situation
> > for the do_huge_pmd_wp_page function: it's called from mm/memory.c but is
> > only defined in mm/huge_memory.c. Looks like the compiler optimises those
> > calls away because pmd_trans_huge and friends constant-fold to 0.
> 
> Ah, OK.
> 
> "mm: thp: Set the accessed flag for old pages on access fault" clashes
> in a non-trivial way with linux-next changes, due to the sched-numa
> changes (sigh).  This is a problem for me, because I either need to
> significantly alter your patch (so it isn't applicable to mainline) or
> I need to stage your patch ahead of linux-next, then fix up linux-next
> every day after I've pulled and re-merged it.
> 
> I'm unsure what your timing is.  Can you carry "mm: thp: Set the
> accessed flag for old pages on access fault" until either the whole
> patchset is ready to merge or until the sched-numa situation has been
> cleared up?

I think DaveM may want this patch for sparc, so I'll keep it separate from
the ARM patches and have a go at reworking it when the sched-numa stuff has
settled down. Is that all in linux-next btw? If so, I can use that as a
starting point to dealing with the mess.

Cheers,

Will
