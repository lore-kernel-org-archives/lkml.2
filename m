Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab0KPPmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 10:42:12 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:53311 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752349Ab0KPPmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 10:42:11 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX192+t1Qb352qmPMykrU2sfep8qhjvCLxAnvH/P5wF
	MCr6hex/XEviEa
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Mike Galbraith <efault@gmx.de>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101116150319.GA3475@redhat.com>
References: <AANLkTimwSktAQ5PkXNGY2EQz71DFmKY3Bt2fbZYasD0G@mail.gmail.com>
	 <AANLkTi=fT-DCP40_U24zft-3owseW24px=Zq=LnEJ_FF@mail.gmail.com>
	 <1289783580.495.58.camel@maggy.simson.net>
	 <1289811438.2109.474.camel@laptop>
	 <1289820766.16406.45.camel@maggy.simson.net>
	 <1289821590.16406.47.camel@maggy.simson.net>
	 <20101115125716.GA22422@redhat.com>
	 <1289856350.14719.135.camel@maggy.simson.net>
	 <20101116130413.GA29368@redhat.com>
	 <1289917109.5169.131.camel@maggy.simson.net>
	 <20101116150319.GA3475@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 08:41:48 -0700
Message-ID: <1289922108.5169.185.camel@maggy.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 16:03 +0100, Oleg Nesterov wrote:
> On 11/16, Mike Galbraith wrote:
> >
> > On Tue, 2010-11-16 at 14:04 +0100, Oleg Nesterov wrote:
> > > However, I must admit I dislike this check. Because, looking at this
> > > code, it is not clear why do we check PF_EXITING. It looks as if it
> > > is needed for correctness.
> >
> > Is _not_ needed I presume.
> >
> > I'll remove it, I'm not overly attached (a t t a..;) to it.
> 
> Argh!
> 
> I was wrong, it _is_ needed for correctness. Yes, it is always safe
> to read the pointer, but
> 
> > > Yes, sure, rq->lock should ensure signal->autogroup can't go away.
> > > (even if it can be changed under us). And it does, we are moving all
> > > threads before kref_put().
> >
> > (yeah)
> 
> Exactly. And this means we can _only_ assume it can't go away if
> autogroup_move_group() can see us on ->thread_group list.

Aha!

> Perhaps this deserve a commen (unless I missed something again).
> 
> Mike, sorry for confusion.

Oh no, thank you.  I hadn't figured it out yet, was going to go back and
poke rt kernel with sharp sticks.  (exit can be one scary beast)

	-Mike

