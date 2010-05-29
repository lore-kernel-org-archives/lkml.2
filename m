Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab0E2IKa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 04:10:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42349 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab0E2IKY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 04:10:24 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Peter Zijlstra <peterz@infradead.org>
To: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Cc: tytso@mit.edu, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
In-Reply-To: <AANLkTikEtlbkT4Ws3H2YGt_9QC46B5dr-b1oxJOcG4GN@mail.gmail.com>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>
	 <Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org>
	 <20100527230806.4deb6de3@lxorguk.ukuu.org.uk>
	 <20100527220949.GB10602@srcf.ucam.org>
	 <20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
	 <20100527223605.GB11364@srcf.ucam.org>
	 <20100527235546.09f3ce8a@lxorguk.ukuu.org.uk>
	 <20100528043114.GC26177@thunk.org> <1275030704.32462.11.camel@laptop>
	 <AANLkTikEtlbkT4Ws3H2YGt_9QC46B5dr-b1oxJOcG4GN@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 29 May 2010 10:10:18 +0200
Message-ID: <1275120618.27810.12699.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-28 at 17:43 -0700, Arve Hjønnevåg wrote:
> On Fri, May 28, 2010 at 12:11 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Fri, 2010-05-28 at 00:31 -0400, tytso@mit.edu wrote:
> >> Keep in mind, though, that a solution which is acceptable for Android
> >> has to include making sure that crappy applications don't cause the
> >> battery to get drained.  There seem to be some people who seem
> >> adamently against this requirement.
> >
> > Again, Alan, Thomas and myself don't argue against that, what we do
> > however argue against is suspend running apps as a form of power
> > management.
> >
> 
> You seem to argue that android is not allowed to use suspend because
> the hardware we have shipped on can enter the same power state from
> idle. From my point of view, since we need to support suspend on some
> hardware we should be allowed to leverage this solution on the better
> hardware platforms as well if it improves our battery life.

Correct, I strongly oppose using suspend. Not running runnable tasks is
not a sane solution.

If current hardware can't cope, too friggin bad, get better hardware.

But the truth is, all your OMAP phones really can deal with it.

> I have not seen any suggestions for how to deal with all our
> interprocess dependencies when pausing a subset of processes. Without
> a solution to that we can only pause a subset of the processes we want
> to pause.

Do not 'pause' processes and you don't have the problem, make them stop
on their own accord or kill them if they dont listen.. who cares about
ill-behaved apps anyway?

But really, if you want a more detailed answer, you need to provide more
detail on these problems.

If you want to allow an untrusted app to provide a dependency for a
trusted app, you've lost and I don't care.

Trusted apps should be well behaved, otherwise there really is no point.

> These solutions do not allow us to use suspend. They may get us closer
> to the power consumption we get from suspend on the good hardware or
> even surpass it, but we still need suspend on some hardware, and we
> would get event better results by using these solutions in addition to
> suspend compared to using them instead of suspend.

Not using suspend is exactly the point. As Alan has argued, propagating
suspend blockers up into all regions of userspace will take much longer
than fixing the hardware.

You got to realize this is about Linux as a whole, I really don't care
one whit about the specific Android case. We want a solution that is
generic enough to solve the power consumption problem and makes sense on
future hardware.

The only abstraction that really makes sense in that view is idle
states.


