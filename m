Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536Ab2C0Cvs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 22:51:48 -0400
Received: from ozlabs.org ([203.10.76.45]:35412 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757247Ab2C0Cvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 22:51:45 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: paulmck@linux.vnet.ibm.com,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        "akpm\@linux-foundation.org" <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Milton Miller <miltonm@bga.com>, "mingo\@elte.hu" <mingo@elte.hu>,
        Tejun Heo <tj@kernel.org>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: CPU Hotplug rework
In-Reply-To: <1332781541.23924.110.camel@gandalf.stny.rr.com>
References: <4F674649.2000300@linux.vnet.ibm.com> <87aa3cqht9.fsf@rustcorp.com.au> <1332240151.18960.401.camel@twins> <874ntic1ze.fsf@rustcorp.com.au> <1332320519.18960.466.camel@twins> <87d3859s9r.fsf@rustcorp.com.au> <20120322224919.GW2450@linux.vnet.ibm.com> <877gya99uj.fsf@rustcorp.com.au> <20120324002347.GD2450@linux.vnet.ibm.com> <87bonkchxk.fsf@rustcorp.com.au> <1332748920.16159.65.camel@twins> <1332767386.23924.75.camel@gandalf.stny.rr.com> <1332769098.16159.111.camel@twins> <1332775340.23924.102.camel@gandalf.stny.rr.com> <1332778438.16159.136.camel@twins> <1332781541.23924.110.camel@gandalf.stny.rr.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 27 Mar 2012 12:02:31 +1030
Message-ID: <87iphqbzgw.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2012 13:05:41 -0400, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 2012-03-26 at 18:13 +0200, Peter Zijlstra wrote:
> > On Mon, 2012-03-26 at 11:22 -0400, Steven Rostedt wrote:
> 
> > So how about we add another variant of kthread_freezable_should_stop(),
> > maybe call it kthread_bound_should_stop() that checks if the cpu its
> > bound to goes awol, if so, park it.
> 
> Do you mean to have this function automate the "park". When it is
> called, if the cpu is going down it should simply schedule off and not
> return until the CPU comes back on line?
> 
> Actually, why not just keep "kthread_should_stop()" and instead create a
> "kthread_park()", and call that instead of kthread_stop(). Then when the
> task calls kthread_should_stop(), that can park the thread then.

Do we ever have to do this?  Why not say we never move kthreads, and if
anyone really needs this, they have to do it themselves.

We *will* need a way for the kthreads to say "don't take this cpu away
now" in a v. lightweight way, but I'm happy with the -rt solution that
Steven mentioned.

Basically, it's time to revisit cpu hotplug entirely.  Let's not get
too caught up in what we've got now.

Cheers,
Rusty.
PS.  And I'm sure you'll finish the work while I'm on honeymoon :)
-- 
  How could I marry someone with more hair than me?  http://baldalex.org
