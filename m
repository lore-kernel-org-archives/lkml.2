Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416Ab1EQSuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 14:50:11 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:33442 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756226Ab1EQSuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 14:50:09 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/lzeNLCg7lWSKuRMWpDlWNDGW9Y5/ys10/JdtvnE
	8E6isW4/RBr/un
Subject: Re: [PATCH] sched: avoid overpull when pulling RT task
From: Mike Galbraith <efault@gmx.de>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <BANLkTi=0pe8U6TZsQcXssV3iK_5Y+jRWCA@mail.gmail.com>
References: <BANLkTi=_gfo4bZjkoBsxspLxxWSPy=7J+Q@mail.gmail.com>
	 <1305441316.7460.40.camel@marge.simson.net>
	 <BANLkTino730kar=fEDJGCy8bCSVUe52aOw@mail.gmail.com>
	 <1305555077.12285.63.camel@marge.simson.net>
	 <BANLkTi=0pe8U6TZsQcXssV3iK_5Y+jRWCA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 May 2011 20:50:05 +0200
Message-ID: <1305658205.6238.53.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-17 at 22:25 +0800, Hillf Danton wrote:
> On Mon, May 16, 2011 at 10:11 PM, Mike Galbraith <efault@gmx.de> wrote:
> > On Mon, 2011-05-16 at 21:14 +0800, Hillf Danton wrote:
> >
> >> In the following patch, pulling is played in two rounds. In the first round,
> >> the highest priority task is determined with no pull operation. Pulling is
> >> carried out in the second round, and if the highest priority task is pulled,
> >> pulling could be stopped when overload detected, to relieve overpull.
> >>
> >> Please review again, thanks.
> >
> > Traversing runqueues twice to avoid some potential task bouncing during
> > overload situation seems like a really bad trade.  Not to mention that
> > between pass one and pass two, the world turns under your feet.
> >
> > You could do it in one pass by leaving the victim's runqueue locked
> > unless you find a better victim I suppose.  Dunno, guess it all depends
> > on how much benefit the is to pulling only highest, which I can't answer
> > (my gut says "none, only more pain to be had here").
> >
> Hi Mike
> 
> Efforts are put on the puller's side, but bad result is reached:(

Don't be discouraged by bad results, they're unavoidable.  Keep on
looking, thinking and poking.

> Another patch is prepared, in which pusher is asked to do the hard works,
> say pushees and tasks are selected.
> 
> Unlike puller who only concerns one runqueue that accepts the pulled tasks,
> pusher delivers tasks to more runqueues, so the overpull could get bigger.
> 
> Please review again, thanks.

Sorry, but I don't have any free time atm, my cup runneth over bigtime.
Best suggestion I can offer is measure, and measure again.  No theory
can compete with cold hard numbers.

	-Mike

