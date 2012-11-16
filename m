Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab2KPSzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 13:55:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53906 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666Ab2KPSzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 13:55:24 -0500
Date: Fri, 16 Nov 2012 18:55:17 +0000
From: Mel Gorman <mgorman@suse.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/43] mm: numa: Make pte_numa() and pmd_numa() a generic
 implementation
Message-ID: <20121116185517.GH8218@suse.de>
References: <1353064973-26082-1-git-send-email-mgorman@suse.de>
 <1353064973-26082-7-git-send-email-mgorman@suse.de>
 <50A648FF.2040707@redhat.com>
 <20121116144109.GA8218@suse.de>
 <CA+55aFzH_-6FuwTF1GVDzLK+7c0MGLsLdPFjzzwU78GVUEMbBw@mail.gmail.com>
 <20121116160852.GA4302@gmail.com>
 <20121116165606.GE8218@suse.de>
 <20121116171243.GA4697@gmail.com>
 <20121116174853.GF8218@suse.de>
 <20121116180404.GA4728@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20121116180404.GA4728@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 07:04:04PM +0100, Ingo Molnar wrote:
> 
> * Mel Gorman <mgorman@suse.de> wrote:
> 
> > That said, your approach just ends up being heavier. [...]
> 
> Well, it's more fundamental than just whether to inline or not 
> (which I think should be a separate optimization and I won't 
> object to two-instruction variants the slightest) - but you 
> ended up open-coding change_protection() 
> via:
> 
>    change_prot_numa_range() et al
> 
> which is a far bigger problem...
> 
> Do you have valid technical arguments in favor of that 
> duplication?
> 

No, I don't and I have not claimed that it *has* to exist. In fact I've
said multiple times than I can convert to change_protection as long as
_PAGE_NUMA == _PAGE_NONE. This initial step was to build the list
of requirements without worrying about breaking existing users of
change_protection. Now that I know what the requirements are, I can convert.

> If you just embrace the PROT_NONE reuse approach of numa/core 
> then 90% of the differences in your tree will disappear and 
> you'll have a code base very close to where numa/core was 3 
> weeks ago already, modulo a handful of renames.
> 

Pointed out the missing parts in another mail already -- MIGRATE_FAULT,
pmd handling in batch, stats and a logical progression from a simple to
a complex policy.

> It's not like PROT_NONE will go away anytime soon.
> 
> PROT_NONE is available on every architecture, and we use the 
> exact semantics of it in the scheduler, we just happen to drive 
> it from a special worklet instead of a syscall, and happen to 
> have a callback to the faults when they happen...
> 
> Please stay open to that approach.
> 

I will.

If anything, me switching to prot_none would be a hell of a lot easier
than you trying to pick up the bits you're missing. I'll take a look
Monday and see what falls out.

-- 
Mel Gorman
SUSE Labs
