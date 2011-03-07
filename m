Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab1CGJdk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 04:33:40 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:38951 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755370Ab1CGJdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 04:33:38 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19ozR4ADxVoWe5j9JW/KSRzWN5Tcyuzg0bZ5m+w6j
	IaHqanBNuQoeLL
Subject: Re: [patchlet] sched: fix rt throttle runtime borrowing
From: Mike Galbraith <efault@gmx.de>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <AANLkTikOY2-_EAjYTBZG4Wb9HNHRxJ4Qcd+zbvbxzPbt@mail.gmail.com>
References: <1299486101.14465.25.camel@marge.simson.net>
	 <AANLkTikOY2-_EAjYTBZG4Wb9HNHRxJ4Qcd+zbvbxzPbt@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Mar 2011 10:33:34 +0100
Message-ID: <1299490414.14465.74.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-07 at 17:11 +0800, Yong Zhang wrote:
> On Mon, Mar 7, 2011 at 4:21 PM, Mike Galbraith <efault@gmx.de> wrote:
> > Greetings,
> >
> > The RT throttle leaves a bit to be desired as a protection mechanism.
> > With default settings, the thing won't save your bacon if you start a
> > single hog as RT on SMP box, or if your normally sane app goes nuts.
> >
> > With the below, my box will limp along so I can kill the RT hog.  May
> > not be the best solution, but works for me.. modulo bustage I haven't
> > noticed yet of course.
> >
> > sched: fix rt throttle runtime borrowing
> >
> > If allowed to borrow up to rt_period, the throttle has no effect on an out
> > of control RT task, allowing it to consume 100% CPU indefinitely, blocking
> > system critical SCHED_NORMAL threads indefinitely.
> 
> Yep.
> I think it's helpful.

Well, it does prevent complete death, but you have to be pretty darn
attentive to notice that the patient is still technically alive ;-)

As such, turning borrowing off by default, and making borrowing up to
within a micron of 100% CPU an opt-in feature likely makes more sense.

	-Mike


