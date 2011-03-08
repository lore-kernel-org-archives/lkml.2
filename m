Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab1CHMqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 07:46:48 -0500
Received: from casper.infradead.org ([85.118.1.10]:38055 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab1CHMqr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 07:46:47 -0500
Subject: Re: [patchlet] sched: fix rt throttle runtime borrowing
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: Yong Zhang <yong.zhang0@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1299508052.8093.1.camel@marge.simson.net>
References: <1299486101.14465.25.camel@marge.simson.net>
	 <AANLkTikOY2-_EAjYTBZG4Wb9HNHRxJ4Qcd+zbvbxzPbt@mail.gmail.com>
	 <1299490414.14465.74.camel@marge.simson.net>
	 <1299508052.8093.1.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 08 Mar 2011 13:46:39 +0100
Message-ID: <1299588399.2308.1424.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-07 at 15:27 +0100, Mike Galbraith wrote:
> sched: fix rt throttle runtime borrowing
> 
> If allowed to borrow up to rt_period, the throttle has no effect on an out
> of control RT task, allowing it to consume 100% CPU indefinitely, blocking
> system critical SCHED_NORMAL threads indefinitely.
> 
> To make the throttle a more effective safety mechanism, disable borrowing
> by default. while providing an opt-in switch for those who know the risks.
> Also fix the throttle such that it never silently bumps rt_runtime to the
> point that it disables itself (rt_runtime >= rt_period).
> 
> Convert balance_runtime() and do_balance_runtime() to void since their
> return values are never used.
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>

I'm very hesitant here, pretty much all of the sched_rt cgroup stuff
needs to be thrown out and rewritten. Adding more knobs to it isn't
going to make things much better.

(I'd myself much prefer to simply not support SCHED_FIFO/RR at all, but
seeing as POSIX mandates that crap there's really no choice there).

Also, how much of a problem is it really? When I start a FIFO spinner on
my machine I can still ssh in and kill the thing.

Not allowing 100% FIFO usage on SMP is going to make it very very hard
to implement any kind of fifo-cgroup stuff.


