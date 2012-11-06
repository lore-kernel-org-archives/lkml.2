Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432Ab2KFTix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 14:38:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab2KFTiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 14:38:52 -0500
Message-ID: <509967D9.7050706@redhat.com>
Date: Tue, 06 Nov 2012 14:41:13 -0500
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
Subject: Re: [PATCH 15/19] mm: numa: Add fault driven placement and migration
References: <1352193295-26815-1-git-send-email-mgorman@suse.de> <1352193295-26815-16-git-send-email-mgorman@suse.de>
In-Reply-To: <1352193295-26815-16-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2012 04:14 AM, Mel Gorman wrote:
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
>
> NOTE: This patch is based on "sched, numa, mm: Add fault driven
> 	placement and migration policy" but as it throws away all the policy
> 	to just leave a basic foundation I had to drop the signed-offs-by.
>
> This patch creates a bare-bones method for setting PTEs pte_numa in the
> context of the scheduler that when faulted later will be faulted onto the
> node the CPU is running on.  In itself this does nothing useful but any
> placement policy will fundamentally depend on receiving hints on placement
> from fault context and doing something intelligent about it.
>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Excellent basis for implementing a smarter NUMA
policy.

Not sure if such a policy should be implemented
as a replacement for this patch, or on top of it...

Either way, thank you for cleaning up all of the
NUMA base code, while I was away at conferences
and stuck in airports :)

Peter, Andrea - does this look like a good basis
for implementing and comparing your NUMA policies?

I mean, it does to me. I am just wondering if there
is any reason at all you two could not use it as a
basis for an apples-to-apples comparison of your
NUMA placement policies?

Sharing 2/3 of the code would sure get rid of the
bulk of the discussion, and allow us to make real
progress.

