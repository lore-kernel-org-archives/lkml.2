Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab1HABd6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 21:33:58 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55992 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992Ab1HABdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 21:33:53 -0400
Date: Mon, 1 Aug 2011 09:33:41 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Lin Ming <ming.m.lin@intel.com>, "mingo@elte.hu" <mingo@elte.hu>,
        lkml <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] sched: Remove WAKEUP_PREEMPT feature check in entity_tick
Message-ID: <20110801013341.GA26768@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20110729062158.GA8971@zhy>
 <1311922180.3938.1573.camel@minggr.sh.intel.com>
 <20110729070356.GA10420@zhy>
 <1311924975.3938.1583.camel@minggr.sh.intel.com>
 <20110729074635.GB10420@zhy>
 <1311926218.5890.215.camel@twins>
 <20110729081800.GA12106@zhy>
 <1311927650.5890.217.camel@twins>
 <20110729084637.GC12106@zhy>
 <1311939933.5890.341.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1311939933.5890.341.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 01:45:33PM +0200, Peter Zijlstra wrote:
> On Fri, 2011-07-29 at 16:46 +0800, Yong Zhang wrote:
> > Let's take UP for example, we have cpu-hug task A and threadirq B.
> > 
> >         n tick          --->            n+1 tick
> > set_tsk_need_resched(A);
> >                 B comes in and
> >                 wake up thread-B;
> > 
> > So for system on which we disable WAKEUP_PREEMPT,
> > if we don't have that check, thread-B will wait until n+1 tick comes
> > to get to run.
> > But if we have that check, thread-B will get to run after IRQ-B returns.
> 
> But that's exactly what wakeup preemption is about, waking tasks don't
> get to preempt running tasks. So no doing that preemption is exactly
> right for !WAKEUP_PREEMPT.
> 
> Anyway, I've queued the removal patch since that removes all
> confusion ;-)

Yup, that sounds good. Thanks Peter.

-Yong

-- 
Only stand for myself
