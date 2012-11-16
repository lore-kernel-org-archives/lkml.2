Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab2KPP7v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 10:59:51 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:39027 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514Ab2KPP7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 10:59:50 -0500
Date: Fri, 16 Nov 2012 16:59:43 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/8] Announcement: Enhanced NUMA scheduling with adaptive
 affinity
Message-ID: <20121116155943.GB4271@gmail.com>
References: <20121112160451.189715188@chello.nl>
 <0000013af701ca15-3acab23b-a16d-4e38-9dc0-efef05cbc5f2-000000@email.amazonses.com>
 <20121113072441.GA21386@gmail.com>
 <0000013b04769cf2-b57b16c0-5af0-4e7e-a736-e0aa2d4e4e78-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000013b04769cf2-b57b16c0-5af0-4e7e-a736-e0aa2d4e4e78-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux.com> wrote:

> On Tue, 13 Nov 2012, Ingo Molnar wrote:
> 
> > > the pages over both nodes in use.
> >
> > I'd not go as far as to claim that to be a general rule: the 
> > correct placement depends on the system and workload 
> > specifics: how much memory is on each node, how many tasks 
> > run on each node, and whether the access patterns and 
> > working set of the tasks is symmetric amongst each other - 
> > which is not a given at all.
> >
> > Say consider a database server that executes small and large 
> > queries over a large, memory-shared database, and has worker 
> > tasks to clients, to serve each query. Depending on the 
> > nature of the queries, interleaving can easily be the wrong 
> > thing to do.
> 
> The interleaving of memory areas that have an equal amount of 
> shared accesses from multiple nodes is essential to limit the 
> traffic on the interconnect and get top performance.

That is true only if the load is symmetric.

> I guess through that in a non HPC environment where you are 
> not interested in one specific load running at top speed 
> varying contention on the interconnect and memory busses are 
> acceptable. But this means that HPC loads cannot be auto 
> tuned.

I'm not against improving these workloads (at all) - I just 
pointed out that interleaving isn't necessarily the best 
placement strategy for 'large' workloads.

Thanks,

	Ingo
