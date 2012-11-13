Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab2KMLhp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 06:37:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50291 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752816Ab2KMLho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 06:37:44 -0500
Date: Tue, 13 Nov 2012 11:37:39 +0000
From: Mel Gorman <mgorman@suse.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/19] mm: numa: teach gup_fast about pmd_numa
Message-ID: <20121113113739.GX8218@suse.de>
References: <1352193295-26815-1-git-send-email-mgorman@suse.de>
 <1352193295-26815-7-git-send-email-mgorman@suse.de>
 <20121113100735.GC21522@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20121113100735.GC21522@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 11:07:36AM +0100, Ingo Molnar wrote:
> 
> * Mel Gorman <mgorman@suse.de> wrote:
> 
> > From: Andrea Arcangeli <aarcange@redhat.com>
> > 
> > When scanning pmds, the pmd may be of numa type (_PAGE_PRESENT not set),
> > however the pte might be present. Therefore, gup_pmd_range() must return
> > 0 in this case to avoid losing a NUMA hinting page fault during gup_fast.
> > 
> > Note: gup_fast will skip over non present ptes (like numa 
> > types), so no explicit check is needed for the pte_numa case. 
> > [...]
> 
> So, why not fix all architectures that choose to expose 
> pte_numa() and pmd_numa() methods - via the patch below?
> 

I'll pick it up. Thanks.

-- 
Mel Gorman
SUSE Labs
