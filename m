Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571Ab2KFTye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 14:54:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840Ab2KFTyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 14:54:32 -0500
Message-ID: <50996B8B.30404@redhat.com>
Date: Tue, 06 Nov 2012 14:56:59 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 19/19] mm: sched: numa: Implement slow start for working
 set sampling
References: <1352193295-26815-1-git-send-email-mgorman@suse.de> <1352193295-26815-20-git-send-email-mgorman@suse.de>
In-Reply-To: <1352193295-26815-20-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2012 04:14 AM, Mel Gorman wrote:
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
>
> Add a 1 second delay before starting to scan the working set of
> a task and starting to balance it amongst nodes.
>
> [ note that before the constant per task WSS sampling rate patch
>    the initial scan would happen much later still, in effect that
>    patch caused this regression. ]
>
> The theory is that short-run tasks benefit very little from NUMA
> placement: they come and go, and they better stick to the node
> they were started on. As tasks mature and rebalance to other CPUs
> and nodes, so does their NUMA placement have to change and so
> does it start to matter more and more.
>
> In practice this change fixes an observable kbuild regression:
>
>     # [ a perf stat --null --repeat 10 test of ten bzImage builds to /dev/shm ]
>
>     !NUMA:
>     45.291088843 seconds time elapsed                                          ( +-  0.40% )
>     45.154231752 seconds time elapsed                                          ( +-  0.36% )
>
>     +NUMA, no slow start:
>     46.172308123 seconds time elapsed                                          ( +-  0.30% )
>     46.343168745 seconds time elapsed                                          ( +-  0.25% )
>
>     +NUMA, 1 sec slow start:
>     45.224189155 seconds time elapsed                                          ( +-  0.25% )
>     45.160866532 seconds time elapsed                                          ( +-  0.17% )
>
> and it also fixes an observable perf bench (hackbench) regression:
>
>     # perf stat --null --repeat 10 perf bench sched messaging
>
>     -NUMA:
>
>     -NUMA:                  0.246225691 seconds time elapsed                   ( +-  1.31% )
>     +NUMA no slow start:    0.252620063 seconds time elapsed                   ( +-  1.13% )
>
>     +NUMA 1sec delay:       0.248076230 seconds time elapsed                   ( +-  1.35% )
>
> The implementation is simple and straightforward, most of the patch
> deals with adding the /proc/sys/kernel/balance_numa_scan_delay_ms tunable
> knob.
>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Rik van Riel <riel@redhat.com>
> [ Wrote the changelog, ran measurements, tuned the default. ]
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>

