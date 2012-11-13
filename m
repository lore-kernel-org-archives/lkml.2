Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab2KMACe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 19:02:34 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:51092 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752542Ab2KMACc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 19:02:32 -0500
Date: Tue, 13 Nov 2012 00:02:31 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 5/8] sched, numa, mm: Add adaptive NUMA affinity
 support
In-Reply-To: <20121112161215.782018877@chello.nl>
Message-ID: <0000013af7130ad7-95edbaf9-d31d-4258-8fc0-013d152246a2-000000@email.amazonses.com>
References: <20121112160451.189715188@chello.nl> <20121112161215.782018877@chello.nl>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 12 Nov 2012, Peter Zijlstra wrote:

> We define 'shared memory' as all user memory that is frequently
> accessed by multiple tasks and conversely 'private memory' is
> the user memory used predominantly by a single task.

"All"? Should that not be "a memory segment that is frequently..."?

> Using this, we can construct two per-task node-vectors, 'S_i'
> and 'P_i' reflecting the amount of shared and privately used
> pages of this task respectively. Pages for which two consecutive
> 'hits' are of the same cpu are assumed private and the others
> are shared.

The classification is per task? But most tasks have memory areas
that are private and other areas where shared accesses occur. Can that be
per memory area? Private areas need to be kept with the process. Shared
areas may have to be spread across nodes if the memory area is too large.

Guess that is too complicated to determine unless we would be using vmas
which may only roughly correlate to the memory regions for which memory
policies are currently manually setup.

But then this is rather different from my expectations that I had after
reading the intro.

> We also add an extra 'lateral' force to the load balancer that
> perturbs the state when otherwise 'fairly' balanced. This
> ensures we don't get 'stuck' in a state which is fair but
> undesired from a memory location POV (see can_do_numa_run()).

We do useless moves and create additional overhead?

