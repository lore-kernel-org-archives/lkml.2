Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358Ab1G2LqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 07:46:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:59296 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755622Ab1G2LqS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 07:46:18 -0400
Subject: Re: [PATCH] sched: Remove WAKEUP_PREEMPT feature check in
 entity_tick
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Lin Ming <ming.m.lin@intel.com>, "mingo@elte.hu" <mingo@elte.hu>,
        lkml <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>
In-Reply-To: <20110729084637.GC12106@zhy>
References: <1311846203.3938.1555.camel@minggr.sh.intel.com>
	 <20110729062158.GA8971@zhy>
	 <1311922180.3938.1573.camel@minggr.sh.intel.com>
	 <20110729070356.GA10420@zhy>
	 <1311924975.3938.1583.camel@minggr.sh.intel.com>
	 <20110729074635.GB10420@zhy> <1311926218.5890.215.camel@twins>
	 <20110729081800.GA12106@zhy> <1311927650.5890.217.camel@twins>
	 <20110729084637.GC12106@zhy>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 29 Jul 2011 13:45:33 +0200
Message-ID: <1311939933.5890.341.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-29 at 16:46 +0800, Yong Zhang wrote:
> Let's take UP for example, we have cpu-hug task A and threadirq B.
> 
>         n tick          --->            n+1 tick
> set_tsk_need_resched(A);
>                 B comes in and
>                 wake up thread-B;
> 
> So for system on which we disable WAKEUP_PREEMPT,
> if we don't have that check, thread-B will wait until n+1 tick comes
> to get to run.
> But if we have that check, thread-B will get to run after IRQ-B returns.

But that's exactly what wakeup preemption is about, waking tasks don't
get to preempt running tasks. So no doing that preemption is exactly
right for !WAKEUP_PREEMPT.

Anyway, I've queued the removal patch since that removes all
confusion ;-)
