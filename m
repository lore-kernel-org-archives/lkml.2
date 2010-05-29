Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab0E2QPW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 12:15:22 -0400
Received: from cobra.newdream.net ([66.33.216.30]:46618 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757344Ab0E2QPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 12:15:20 -0400
Date: Sat, 29 May 2010 09:15:25 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Peter Zijlstra <peterz@infradead.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, andreas.herrmann3@amd.com,
       tglx@linutronix.de, efault@gmx.de, akpm@linux-foundation.org
Subject: Re: [PATCH] sched: add wait_for_completion_killable_timeout
In-Reply-To: <1275129887.27810.13216.camel@twins>
Message-ID: <Pine.LNX.4.64.1005290913190.8568@cobra.newdream.net>
References: <Pine.LNX.4.64.1005241129500.1745@cobra.newdream.net>
 <Pine.LNX.4.64.1005281214390.2828@cobra.newdream.net> <1275129887.27810.13216.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 May 2010, Peter Zijlstra wrote:
> On Fri, 2010-05-28 at 12:16 -0700, Sage Weil wrote:
> > Hi-
> > 
> > Do I need an ACK on this, or should I just send this to Linus with the 
> > Ceph fix?  It's a pretty trivial fixup.
> 
> > > --- a/kernel/sched.c
> > > +++ b/kernel/sched.c
> > > @@ -4161,6 +4161,23 @@ int __sched wait_for_completion_killable(struct completion *x)
> > >  EXPORT_SYMBOL(wait_for_completion_killable);
> > >  
> > >  /**
> > > + * wait_for_completion_killable_timeout: - waits for completion of a task (w/(to,killable))
> > > + * @x:  holds the state of this particular completion
> > > + * @timeout:  timeout value in jiffies
> > > + *
> > > + * This waits for either a completion of a specific task to be
> > > + * signaled or for a specified timeout to expire. It can be
> > > + * interrupted by a kill signal. The timeout is in jiffies.
> > > + */
> > > +unsigned long __sched
> > > +wait_for_completion_killable_timeout(struct completion *x,
> > > +				     unsigned long timeout)
> > > +{
> > > +	return wait_for_common(x, timeout, TASK_KILLABLE);
> > > +}
> > > +EXPORT_SYMBOL(wait_for_completion_killable_timeout);
> > > +
> > > +/**
> > >   *	try_wait_for_completion - try to decrement a completion without blocking
> > >   *	@x:	completion structure
> > >   *
> 
> I guess its ok, although I have an intrinsic suspicion of all things
> timeout, but since we have plenty of those interfaces around I can't
> object too much ;-)
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Agreed (about timeouts).  In this case the timeout is only used during 
mount so that we don't hang indefinitely if the server is unreachable.

Thanks :)
sage
