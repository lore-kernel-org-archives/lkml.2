Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab0LQTYg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 14:24:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669Ab0LQTYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 14:24:35 -0500
Date: Fri, 17 Dec 2010 20:17:13 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/5] mutex: Use p->oncpu for the adaptive spin
Message-ID: <20101217191713.GA15381@redhat.com>
References: <20101216145602.899838254@chello.nl> <20101216150920.814666573@chello.nl> <20101216173430.GA12841@redhat.com> <1292527743.2708.75.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292527743.2708.75.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16, Peter Zijlstra wrote:
>
> So yea, I think we can simplify all this even further, but we do need a
> smp_rmb() in between those two checks, hmm, and RCU.

I am not sure we need rmb() or even read_barrier_depends(), I think
the simple barrier() should be enough. Although rcu_dereference()
may be more clean.

We don't really care about the "correct" result of *owner. All we need,
we should ensure it is safe to dereference this address. If CPU itself
does something like "readahead" before we verified "lock->owner == owner"
under RCU lock, this shouldn't lead to the fault.

Oleg.

