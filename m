Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab2KIOnV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 09:43:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753842Ab2KIOnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 09:43:20 -0500
Date: Fri, 9 Nov 2012 15:42:57 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 00/19] Foundation for automatic NUMA balancing
Message-ID: <20121109144257.GA26870@redhat.com>
References: <1352193295-26815-1-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352193295-26815-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

On Tue, Nov 06, 2012 at 09:14:36AM +0000, Mel Gorman wrote:
> This series addresses part of the integration and sharing problem by
> implementing a foundation that either the policy for schednuma or autonuma
> can be rebased on. The actual policy it implements is a very stupid
> greedy policy called "Migrate On Reference Of pte_numa Node (MORON)".
> While stupid, it can be faster than the vanilla kernel and the expectation
> is that any clever policy should be able to beat MORON. The advantage is
> that it still defines how the policy needs to hook into the core code --
> scheduler and mempolicy mostly so many optimisations (s uch as native THP
> migration) can be shared between different policy implementations.

I haven't had much time to look into it yet, because I've been
attending KVM Forum the last few days, but this foundation looks ok
with me as a starting base and I ack it for merging it upstream. I'll
try to rebase on top of this and send you some patches.

> Patch 14 adds a MPOL_MF_LAZY mempolicy that an interested application can use.
> 	On the next reference the memory should be migrated to the node that
> 	references the memory.

This approach of starting with a stripped down foundation won't allow
for easy backportability anyway, so merging the userland API at the
first step shouldn't provide any benefit for the work that is ahead of
us. I would leave this for later and not part of the foundation.

All we need is a failsafe runtime and boot time turn off knob, just in
case.

Thanks,
Andrea
