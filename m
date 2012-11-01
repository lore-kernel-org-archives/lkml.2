Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964883Ab2KAPwd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 11:52:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48605 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964826Ab2KAPwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 11:52:30 -0400
Date: Thu, 1 Nov 2012 15:52:26 +0000
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 30/31] sched, numa, mm: Implement slow start for working
 set sampling
Message-ID: <20121101155226.GE3888@suse.de>
References: <20121025121617.617683848@chello.nl>
 <20121025124834.720647725@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20121025124834.720647725@chello.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 02:16:47PM +0200, Peter Zijlstra wrote:
> Add a 1 second delay before starting to scan the working set of
> a task and starting to balance it amongst nodes.
> 
> [ note that before the constant per task WSS sampling rate patch
>   the initial scan would happen much later still, in effect that
>   patch caused this regression. ]
> 
> The theory is that short-run tasks benefit very little from NUMA
> placement: they come and go, and they better stick to the node
> they were started on. As tasks mature and rebalance to other CPUs
> and nodes, so does their NUMA placement have to change and so
> does it start to matter more and more.
> 

Yeah, ok. It's done by wall time, right? Should it be CPU time in case
it spent the first second asleep?

-- 
Mel Gorman
SUSE Labs
