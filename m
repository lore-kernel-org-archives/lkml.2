Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab0DOS1d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 14:27:33 -0400
Received: from www.tglx.de ([62.245.132.106]:37183 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494Ab0DOS1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 14:27:31 -0400
Date: Thu, 15 Apr 2010 20:26:57 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Michal Simek <michal.simek@petalogix.com>
cc: steve@digidescorp.com, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, Wu Zhangjin <wuzhangjin@gmail.com>
Subject: Re: sched_clock - microblaze
In-Reply-To: <4BC73D02.5090108@petalogix.com>
Message-ID: <alpine.LFD.2.00.1004152025240.3625@localhost.localdomain>
References: <4BC728DD.5020404@petalogix.com> <1271343970.3856.7.camel@iscandar.digidescorp.com> <4BC73D02.5090108@petalogix.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Apr 2010, Michal Simek wrote:

> Steven J. Magnani wrote:
> > Michal,
> > 
> > On Thu, 2010-04-15 at 16:55 +0200, Michal Simek wrote:
> > 
> > > Is unimplemented sched_clock the reason why ftrace not show fine grain
> > > time?
> > > 
> > > Or is there any other thing which is wrong?
> > > 
> > 
> > I think that's it. On my platform we have a free-running 1 MHz counter
> > so I implemented a platform sched_clock for that, and I get nice ftrace
> > times.
> > 
> >  0) + 65.000 us   |  finish_task_switch();
> >  0)               |  lock_sock_nested() {
> >  0) + 52.000 us   |    local_bh_disable();
> >  0) + 53.000 us   |    local_bh_enable();
> >  0) ! 264.000 us  |  }
> 
> I don't understand why I should add any "new" free running counter because we
> have one free running counter which do it (clocksource timer - timer1). Or am
> I missing something?

No, you just can use the clocksource for it. We have that separation
as on x86 we want to use the TSC even if it is not usable for time
keeping as it is the fastest accesible clock in x86. So for your case
you can just use your main clocksource as sched_clock and be done.

Thanks,

	tglx
