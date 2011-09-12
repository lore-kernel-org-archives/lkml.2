Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab1ILOrK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 10:47:10 -0400
Received: from mail.openrapids.net ([64.15.138.104]:35970 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755899Ab1ILOrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 10:47:09 -0400
Date: Mon, 12 Sep 2011 10:47:06 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Huang Ying <ying.huang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/5] llist: Remove cpu_relax() usage in cmpxchg loops
Message-ID: <20110912144706.GA21716@Krystal>
References: <1315461646-1379-1-git-send-email-ying.huang@intel.com> <1315836358.26517.43.camel@twins> <20110912142305.GN7761@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110912142305.GN7761@one.firstfloor.org>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 10:43:00 up 292 days, 19:46,  4 users,  load average: 0.12, 0.09,
	0.03
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> On Mon, Sep 12, 2011 at 04:05:58PM +0200, Peter Zijlstra wrote:
> > Subject: llist: Remove cpu_relax() usage in cmpxchg loops
> > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date: Mon Sep 12 15:50:49 CEST 2011
> > 
> > Initial benchmarks show they're a net loss (2 socket wsm):
> > 
> 
> May still save power.

Looking at kernel/spinlock.c:

void __lockfunc __raw_##op##_lock(locktype##_t *lock) \
{
[...]
                while (!raw_##op##_can_lock(lock) && (lock)->break_lock)\
                        arch_##op##_relax(&lock->raw_lock); \

so basically, in typical locking primitives (spinlock), it looks like
lower power consumption is preferred over getting the raw maximal
performance in fully contented scenarios.

So what is the rationale for making those lock-less lists retry scheme
different from spinlocks here ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
