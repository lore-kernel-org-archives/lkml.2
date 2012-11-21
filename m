Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab2KULYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 06:24:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46994 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918Ab2KULYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 06:24:38 -0500
Date: Wed, 21 Nov 2012 11:24:33 +0000
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
Subject: Re: [PATCH 37/46] mm: numa: Add THP migration for the NUMA working
 set scanning fault case.
Message-ID: <20121121112433.GX8218@suse.de>
References: <1353493312-8069-1-git-send-email-mgorman@suse.de>
 <1353493312-8069-38-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1353493312-8069-38-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 10:21:43AM +0000, Mel Gorman wrote:
> Note: This is very heavily based on a patch from Peter Zijlstra with
> 	fixes from Ingo Molnar, Hugh Dickins and Johannes Weiner.  That patch
> 	put a lot of migration logic into mm/huge_memory.c where it does
> 	not belong. This version puts tries to share some of the migration
> 	logic with migrate_misplaced_page.  However, it should be noted
> 	that now migrate.c is doing more with the pagetable manipulation
> 	than is preferred. The end result is barely recognisable so as
> 	before, the signed-offs had to be removed but will be re-added if
> 	the original authors are ok with it.
> 
> Add THP migration for the NUMA working set scanning fault case.
> 
> It uses the page lock to serialize. No migration pte dance is
> necessary because the pte is already unmapped when we decide
> to migrate.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> ---
>  include/linux/migrate.h |   16 ++++
>  mm/huge_memory.c        |   55 +++++++-----
>  mm/internal.h           |    2 +
>  mm/migrate.c            |  212 ++++++++++++++++++++++++++++++++++++++---------
>  4 files changed, 226 insertions(+), 59 deletions(-)
> 

And now that I've released it I see that this almost certainly broke
memcg as the memcontrol.c bits are missing. I'll need to carry them
over.

-- 
Mel Gorman
SUSE Labs
