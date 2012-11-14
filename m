Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161221Ab2KNMYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 07:24:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44320 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422673Ab2KNMYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 07:24:11 -0500
Date: Wed, 14 Nov 2012 12:24:04 +0000
From: Mel Gorman <mgorman@suse.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 00/31] Foundation for automatic NUMA balancing V2
Message-ID: <20121114122404.GN8218@suse.de>
References: <1352805180-1607-1-git-send-email-mgorman@suse.de>
 <20121113151416.GA20044@gmail.com>
 <20121113154215.GD8218@suse.de>
 <20121113172734.GA12098@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20121113172734.GA12098@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 06:27:34PM +0100, Ingo Molnar wrote:
> 
> * Mel Gorman <mgorman@suse.de> wrote:
> 
> > > I'd also like to add another, structural side note: you 
> > > mixed new vm-stats bits into the whole queue, needlessly 
> > > blowing up the size and the mm/ specific portions of the 
> > > tree. I'd suggest to post and keep those bits separately, 
> > > preferably on top of what we have already once it has 
> > > settled down. I'm keeping the 'perf bench numa' bits 
> > > separate as well.
> > 
> > The stats part are fairly late in the queue. I noticed they 
> > break build for !CONFIG_BALANCE_NUMA but it was trivially 
> > resolved. [...]
> 
> Ok - the vm-stats bits are the last larger item remaining that 
> I've seen - could you please redo any of your changes on top of 
> the latest tip:numa/core tree, to make them easier for me to 
> pick up?
> 

I don't think it's that simple. I can rebase the stats patch on top without
too much effort of course but it's hardly a critical element. If the
stats were unavailable it would make no difference at all and no one would
lose any sleep over it. The greater issue for me is that superficially it
appears that a lot of the previous review comments still apply

prot_none still appears to be hard-coded (change_prot_none f.e.)
pick_numa_rand is still not random
THP migration optimisation is before patches, does schednuma depend on
	this optimisation? Dunno
cannot be disabled from command line in case it goes pear shaped
the new numa balancing is a massive monolithic patch with little comment
	(I have not reached the point yet where I'm ready to pick apart
	how and why it works and tests will not start until tonight)
the page-flags splitout is still a monolithic patch (although not a
	major concern in this case)
I think your scanner might not be restarting if the last VMA in the
	process is !vma_migratable. If true, it will not adapt with
	new information.
MIGRATE_FAULT is still there even though it's not clear it's even
	necessary

etc. I didn't go back through the old thread. I know I also have not applied
the same review issues to myself and it sounds like I'm being hypocritical
but I'm also not trying to merge. I also know that I'm currently way behind
in terms of overall performance reflecting the relative age of the tree.

> Your tree is slowly becoming a rebase of tip:numa/core and that 
> will certainly cause problems.
> 

How so? What I'm trying to do is build a tree that shows the logical
progression of getting from the vanilla kernel to a working NUMA
balancer. It's not in linux-next colliding with your tree or causing a
direct problem. I intend to expose a git tree of it shortly but am not
planning on asking it to be pulled because I know it's not ready.

> I'll backmerge any delta patches and rebase as necessary - but 
> please do them as deltas on top of tip:numa/core to make things 
> reviewable and easier to merge:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git numa/core
> 

It is a stretch to describe a git tree that requires a significant number
of scheduler patches to even apply and includes a monolith patch like
"sched, numa, mm: Add adaptive NUMA affinity support" as "reviewable".

-- 
Mel Gorman
SUSE Labs
