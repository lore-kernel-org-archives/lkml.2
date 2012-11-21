Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab2KUQxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 11:53:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38123 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755330Ab2KUQxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 11:53:49 -0500
Date: Wed, 21 Nov 2012 16:53:42 +0000
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>
Cc: Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Alex Shi <lkml.alex@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/46] Automatic NUMA Balancing V4
Message-ID: <20121121165342.GH8218@suse.de>
References: <1353493312-8069-1-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1353493312-8069-1-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 10:21:06AM +0000, Mel Gorman wrote:
> 
> I am not including a benchmark report in this but will be posting one
> shortly in the "Latest numa/core release, v16" thread along with the latest
> schednuma figures I have available.
> 

Report is linked here https://lkml.org/lkml/2012/11/21/202

I ended up cancelling the remaining tests and restarted with

1. schednuma + patches posted since so that works out as
   tip/sched/core from the time I last pulled
   patches as posted on the list
   patches posted since which are
     x86/vsyscall: Add Kconfig option to use native vsyscalls, switch to it
     mm/migration: Improve migrate_misplaced_page()
     mm, numa: Turn 4K pte NUMA faults into effective hugepage ones
     x86/mm: Don't flush the TLB on #WP pmd fixups

2. autonuma + native THP support porte by Hugh

3. balancenuma with a missing THP migration bit for memcg

If all goes according to plan it'll do a pair of runs -- one with oprofile
and one without in case there are profile-related questions. Hopefully
they'll be collected correctly and usable.  I'm not using perf simply
because I do not have the necessary automation in place. I had kept oprofile
automation in place when it was important that I could run identical tests
on older kernels.

I did not just pull the tip tree for schednuma because it would not be a
like-like comparison with the other trees.

-- 
Mel Gorman
SUSE Labs
