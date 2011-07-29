Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab1G2Iqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 04:46:47 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56111 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab1G2Iqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 04:46:45 -0400
Date: Fri, 29 Jul 2011 16:46:37 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Lin Ming <ming.m.lin@intel.com>, "mingo@elte.hu" <mingo@elte.hu>,
        lkml <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] sched: Remove WAKEUP_PREEMPT feature check in entity_tick
Message-ID: <20110729084637.GC12106@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1311846203.3938.1555.camel@minggr.sh.intel.com>
 <20110729062158.GA8971@zhy>
 <1311922180.3938.1573.camel@minggr.sh.intel.com>
 <20110729070356.GA10420@zhy>
 <1311924975.3938.1583.camel@minggr.sh.intel.com>
 <20110729074635.GB10420@zhy>
 <1311926218.5890.215.camel@twins>
 <20110729081800.GA12106@zhy>
 <1311927650.5890.217.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1311927650.5890.217.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 10:20:50AM +0200, Peter Zijlstra wrote:
> On Fri, 2011-07-29 at 16:18 +0800, Yong Zhang wrote:
> > > Nah, if there is 1 runnable task it will always run, preemption simply
> > > doesn't matter. There's nothing to preempt it with.
> > 
> > Hmmm, so the newly waked task could be scheduled a little later.
> > That means schedule tick judge everything. 
> 
> Oh, are you referring to the case where a task gets woken on an idle
> remote cpu?

Not really.

Let's take UP for example, we have cpu-hug task A and threadirq B.

	n tick		--->		n+1 tick
set_tsk_need_resched(A);
		B comes in and
		wake up thread-B;

So for system on which we disable WAKEUP_PREEMPT,
if we don't have that check, thread-B will wait until n+1 tick comes
to get to run.
But if we have that check, thread-B will get to run after IRQ-B returns.

Thanks,
Yong

-- 
Only stand for myself
