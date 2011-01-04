Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab1ADTGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 14:06:40 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:48562 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751226Ab1ADTGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 14:06:38 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/sUaY4yzfsxfsAG2SqYEhbeSYW75OLQ0zOaSju8u
	iGlaVTSX9DuF7E
Subject: Re: [tip:sched/core] sched, autogroup: Fix reference leak
From: Mike Galbraith <efault@gmx.de>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110104145722.GA5812@redhat.com>
References: <1293784350.6839.2.camel@marge.simson.net>
	 <tip-101e5f77bf35679809586e250b6c62193d2ed179@git.kernel.org>
	 <20110104145722.GA5812@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Jan 2011 20:06:24 +0100
Message-ID: <1294167984.9334.44.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 15:57 +0100, Oleg Nesterov wrote:

> > diff --git a/kernel/fork.c b/kernel/fork.c
> > index b6f2475..0672444 100644
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -1317,7 +1317,7 @@ bad_fork_cleanup_mm:
> >  	}
> >  bad_fork_cleanup_signal:
> >  	if (!(clone_flags & CLONE_THREAD))
> > -		free_signal_struct(p->signal);
> > +		put_signal_struct(p->signal);
> 
> Well, free_signal_struct() was correct. Without CLONE_THREAD
> sig->sigcnt must be equal to 1.

Yeah, it was only about the autogroup reference leak.

> But yes, autogroup puts sched_autogroup_exit() into put_signal_struct(),
> so this patch looks fine.
> 
> Although I must admit, to me it would be more clean to simply move
> sched_autogroup_exit() from put_signal_struct() into free_signal_struct()
> instead.

OK, I'll send a move it patchlet.

	-Mike

