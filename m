Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234Ab0KPOUK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 09:20:10 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:48974 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1757977Ab0KPOUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 09:20:08 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/4xNRkbU74OEUjKIQOMX6bHEn+j02no9Bxssh/d1
	/Dt5hLxCFDLna/
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1289916081.2109.620.camel@laptop>
References: <AANLkTikjSCbcRnKOU=nd4os1sdW-GJkD6QVj=U5zPyu8@mail.gmail.com>
	 <20101114202734.GA1627@arch.trippelsdorf.de>
	 <AANLkTimHtjH3YvtX6i542_XjfFeuvG-AnU8i224a1R4j@mail.gmail.com>
	 <1289778189.5154.10.camel@maggy.simson.net>
	 <AANLkTimwSktAQ5PkXNGY2EQz71DFmKY3Bt2fbZYasD0G@mail.gmail.com>
	 <AANLkTi=fT-DCP40_U24zft-3owseW24px=Zq=LnEJ_FF@mail.gmail.com>
	 <1289783580.495.58.camel@maggy.simson.net>
	 <1289811438.2109.474.camel@laptop>
	 <1289820766.16406.45.camel@maggy.simson.net>
	 <1289821590.16406.47.camel@maggy.simson.net>
	 <20101115125716.GA22422@redhat.com>
	 <1289856350.14719.135.camel@maggy.simson.net>
	 <1289916081.2109.620.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 07:19:52 -0700
Message-ID: <1289917192.5169.132.camel@maggy.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 15:01 +0100, Peter Zijlstra wrote:
> On Mon, 2010-11-15 at 14:25 -0700, Mike Galbraith wrote:
> > > > +   if (p->flags & PF_EXITING)
> > > > +           return false;
> > > 
> > > Hmm, why? Perhaps PF_EXITING was needed in the previous version to
> > > avoid the race with release_task(). But now it is always safe to
> > > use signal->autogroup.
> > 
> > That came into existence when I stress tested previous version in
> > PREEMPT_RT (boom).  I see no good reason to bother an exiting task
> > though, so would prefer to leave it as is. 
> 
> PREEMPT_RT has a slightly different exit path IIRC. If that was the only
> thing you saw it explode on we could leave the check out for now and
> revisit it in the -rt patches when and if it pops up. Hmm?

Yeah, I'm going to whack it.  (and add your lockdep thingy)

	-Mike


