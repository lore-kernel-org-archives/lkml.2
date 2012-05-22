Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391Ab2EVDD3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 23:03:29 -0400
Received: from ozlabs.org ([203.10.76.45]:48759 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889Ab2EVDD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 23:03:26 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [patch 00/18] SMP: Boot and CPU hotplug refactoring - Part 1
In-Reply-To: <alpine.LFD.2.02.1205211013440.3231@ionos>
References: <20120420122120.097464672@linutronix.de> <4F916AF3.7020301@linux.vnet.ibm.com> <alpine.LFD.2.02.1204201602330.2542@ionos> <871ume48ds.fsf@rustcorp.com.au> <alpine.LFD.2.02.1205211013440.3231@ionos>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 22 May 2012 10:23:47 +0930
Message-ID: <87mx512fz8.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2012 10:25:21 +0200 (CEST), Thomas Gleixner <tglx@linutronix.de> wrote:
> On Mon, 21 May 2012, Rusty Russell wrote:
> 
> > On Fri, 20 Apr 2012 16:18:04 +0200 (CEST), Thomas Gleixner <tglx@linutronix.de> wrote:
> > > On Fri, 20 Apr 2012, Srivatsa S. Bhat wrote:
> > > The whole notifier business needs a redesign as well, because we don't
> > > have a way to express proper dependencies, we add random notifier
> > > points and the teardown path is ass backwards. The whole thing wants
> > > to be a tree which can be walked in either direction and from any
> > > point. Right now we cut the trunk first and keep the single limb up
> > > with a helicopter and start dismantling it.
> > 
> > But there are two ways to do it.  One is to eliminate the need for
> > callbacks.  The other is to make a full dependency-based callback
> 
> What do you mean with fully eliminating the need for callbacks. Do you
> want to put the necessary bringup/shutdown function calls just in the
> core code so we get rid of the notifiers or do you have something
> different in mind ?

Eliminate is probably too hard, but with park/unpark I can see it
getting less common.  Maybe few enough that we can simplify.

> > Not sure whether calling notifiers in parallel is going to be a big win:
> > they'll end up fighting over the cpu we're taking down.  But I could be
> > wrong.
> 
> I'm not going to aim for parallel in the first place. That was just an
> idea and if we chose the right implementation then parallelism can be
> added later.

Parallel CPUs going offline/online is probably a bigger win.  Both for
suspend/resume and powersaving.

> > The original concept of stopping the machine for cpu hotplug and trying
> > not to effect any other kernel code has jumped the shark: I think we
> > need to look seriously at a complete rewrite where we don't use
> > stop_machine.
> 
> Yep. Working on it. :)

I thought you might be :)

I'd love to review once you've got something.

Cheers,
Rusty.
