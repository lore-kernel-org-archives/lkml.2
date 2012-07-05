Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933107Ab2GENyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:54:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58373 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932362Ab2GENyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:54:33 -0400
Subject: Re: [PATCH] perf: add /proc/perf_events file for dump perf events
 info
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jovi Zhang <bookjovi@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@redhat.com>
In-Reply-To: <CACV3sb+rixP3HZ2=dJoe7x+9Rc5amRKu7dyj_4mcaZajwH2MSA@mail.gmail.com>
References: <CACV3sbLSzPoYYFJky=sFpca4L2gKdoOoEySn+mVHh1aphQLkyw@mail.gmail.com>
	 <1341476877.7709.0.camel@twins>
	 <CACV3sb+aadXJYu7_JUedCodgQmF8d1q7OxSVoz=vwfc+Ow_caA@mail.gmail.com>
	 <CACV3sbLJpv2KSSkrRRDVuJ6xtJOSwCKaJfhO1wMF6DgAU9eCBw@mail.gmail.com>
	 <1341493725.19870.46.camel@laptop>
	 <CACV3sb+rixP3HZ2=dJoe7x+9Rc5amRKu7dyj_4mcaZajwH2MSA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Jul 2012 15:54:00 +0200
Message-ID: <1341496440.19870.69.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-05 at 21:38 +0800, Jovi Zhang wrote:
> On Thu, Jul 5, 2012 at 9:08 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > On Thu, 2012-07-05 at 21:02 +0800, Jovi Zhang wrote:
> >> > Watch all perf events in system wide can be very useful for perf subsystem issue handling,
> >> > to know which perf event is active in system,
> >> > perf event is a resouce, it would like to be managed easily for user, with more visable, like /proc/timer, etc...
> >> >
> >> > .jovi
> >>
> >>
> >> Ping...
> >
> > Never saw your reply, due to HTML it landed in the spam folder.
> >
> > That's a pretty non-specific answer.. again, why are you interested,
> > what specific problem are you wanting to solve.
> >
> > I've never had this need myself.
> >
> sorry, I will try to explain more.
> 
> One problem I faced is about hw_breakpoint.
> As you known, hw_breakpoint use limit debug register in most architecture,
> In multi-user environment, sometime user cannot set hw_breakpoint because
> other user already occupy hw_breakpoint slots. currently, there don't
> have a way to know
> how many hw_breakpint perf event already is used in system, so that's
> why I thinking
> we might need a way to get perf event in systerm wide, with visable output.

Hrmm,. so this seems pretty specific to the horror of hw_breakpoint. And
yes those are unfortunate and weird.

But how would you use this proc file? Would you go read it
programmatically or just look at it as a user to figure out why stuff
doesn't work?

> Also this method is not only used for hw_breakpoint, others perf event
> might have similar problem,
> even other perf event don't have limit number, but it can make use of
> this /proc/perf_events

They have a limit alright, but we can round-robin them to hide this fact
(unless you tell it not to).

> Active perf events is cpu consumer at most time, at this point of
> view, system administrator also can use this
> /proc/perf_events to detect is there have any perf events is consuming cpu.

I doubt you can see which is consuming cycles, but you can see if
there's any in use.

> A method to detect perf event leak? of couse our perf subsystem is
> very stable right now, ingnore this :)

There's alway bugs ;-)

The problem I have with the patch is the global nature of it.. but if
something like this is require I guess I can live with it. But it might
be the current proposal is exposing too much information, I would
certainly not mark it readable for the entire world either.



