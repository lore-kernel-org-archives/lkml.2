Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761467Ab2FVHMu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 03:12:50 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:58102 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761447Ab2FVHMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 03:12:49 -0400
Date: Fri, 22 Jun 2012 09:12:43 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 3.5-rc3] mm, mempolicy: fix mbind() to do synchronous
 migration
Message-ID: <20120622071243.GB22167@gmail.com>
References: <alpine.DEB.2.00.1206201758500.3068@chino.kir.corp.google.com>
 <20120621164606.4ae1a71d.akpm@linux-foundation.org>
 <CA+55aFzPXMD3N3Oy-om6utDCQYmrBDnDgdqpVC5cgKe-v6uZ3w@mail.gmail.com>
 <20120621184536.6dd97746.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120621184536.6dd97746.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 21 Jun 2012 17:46:52 -0700 Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Thu, Jun 21, 2012 at 4:46 PM, Andrew Morton
> > <akpm@linux-foundation.org> wrote:
> > >
> > > I can't really do anything with this patch - it's a bug 
> > > added by Peter's "mm/mpol: Simplify do_mbind()" and added 
> > > to linux-next via one of Ingo's trees.
> > >
> > > And I can't cleanly take the patch over as it's all bound 
> > > up with the other changes for sched/numa balancing.
> > 
> > I took the patch, it looked obviously correct (passing in a 
> > boolean was clearly crap).
> 
> Ah, OK, the bug was actually "retained" by "mm/mpol: Simplify 
> do_mbind()".
> 
> I do still ask what the plans are for that patchset..

Somewhat off topic, but the main sched/numa objections were over 
the mbind/etc. syscalls and the extra configuration space - we 
dropped those bits and just turned it all into an improved NUMA 
scheduling feature, as suggested by Peter and me in the original 
discussion.

There were no objections to that approach so the reworked NUMA 
scheduling/balancing scheme is now in the scheduler tree 
(tip:sched/core).

The mbind/etc. syscall changes and all the related cleanups, 
speedups and reorganization of the MM code are still in limbo.

I dropped them with the rest of tip:sched/numa as nobody from 
the MM side expressed much interest in them and I wanted to keep 
things simple and not carry objected-to commits.

We can revive them if there's interest and consensus. I suspect 
once we gather experience with the automatic NUMA scheduling 
feature we'll see whether it's worth exposing that to user-space 
as an ABI - or whether we should go back to random placement and 
forget about it all.

Thanks,

	Ingo
