Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768010Ab2KOO0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 09:26:23 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:32463 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767933Ab2KOO0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 09:26:22 -0500
Date: Thu, 15 Nov 2012 14:26:21 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Ingo Molnar <mingo@kernel.org>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/8] Announcement: Enhanced NUMA scheduling with adaptive
 affinity
In-Reply-To: <20121113072441.GA21386@gmail.com>
Message-ID: <0000013b04769cf2-b57b16c0-5af0-4e7e-a736-e0aa2d4e4e78-000000@email.amazonses.com>
References: <20121112160451.189715188@chello.nl> <0000013af701ca15-3acab23b-a16d-4e38-9dc0-efef05cbc5f2-000000@email.amazonses.com> <20121113072441.GA21386@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2012, Ingo Molnar wrote:

> > the pages over both nodes in use.
>
> I'd not go as far as to claim that to be a general rule: the
> correct placement depends on the system and workload specifics:
> how much memory is on each node, how many tasks run on each
> node, and whether the access patterns and working set of the
> tasks is symmetric amongst each other - which is not a given at
> all.
>
> Say consider a database server that executes small and large
> queries over a large, memory-shared database, and has worker
> tasks to clients, to serve each query. Depending on the nature
> of the queries, interleaving can easily be the wrong thing to
> do.

The interleaving of memory areas that have an equal amount of shared
accesses from multiple nodes is essential to limit the traffic on the
interconnect and get top performance.

I guess through that in a non HPC environment where you are not interested
in one specific load running at top speed varying contention on the
interconnect and memory busses are acceptable. But this means that HPC
loads cannot be auto tuned.

