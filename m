Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337Ab0GDJML (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 05:12:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52169 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756935Ab0GDJMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 05:12:08 -0400
Date: Sun, 4 Jul 2010 11:11:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Dillow <dillowda@ornl.gov>
Cc: Vince Weaver <vweaver1@eecs.utk.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] perf wrong branches event on AMD
Message-ID: <20100704091153.GB10073@elte.hu>
References: <alpine.DEB.2.00.1007011526010.23160@cl320.eecs.utk.edu>
 <1278070727.1917.253.camel@laptop>
 <alpine.DEB.2.00.1007020950420.29784@cl320.eecs.utk.edu>
 <1278080613.1917.258.camel@laptop>
 <alpine.DEB.2.00.1007021546150.3405@cl320.eecs.utk.edu>
 <20100703135408.GE26067@elte.hu>
 <1278203423.4311.46.camel@obelisk.thedillows.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278203423.4311.46.camel@obelisk.thedillows.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.5
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4901]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Dillow <dillowda@ornl.gov> wrote:

> On Sat, 2010-07-03 at 15:54 +0200, Ingo Molnar wrote:
> > * Vince Weaver <vweaver1@eecs.utk.edu> wrote:
> > 
> > > On Fri, 2 Jul 2010, Peter Zijlstra wrote:
> > > 
> > > > On Fri, 2010-07-02 at 09:56 -0400, Vince Weaver wrote:
> > > > > You think I have root on this machine?
> > > > 
> > > > Well yeah,.. I'd not want a dev job and not have full access to the
> > > > hardware. But then, maybe I'm picky.
> > > 
> > > I can see how this support call would go now.
> > > 
> > >   Me:  Hello, I need you to upgrade the kernel on the
> > >        2.332 petaflop machine with 37,376 processors 
> > >        so I can have the right branch counter on perf.
> > >   Them: Umm... no.
> > >   Me:  Well then can I have root so I can patch
> > >        the kernel on the fly?
> > >   Them: <click>
> > 
> > No, the way it would go, for this particular bug you reported, is something 
> > like:
> > 
> >     Me:   Hello, I need you to upgrade the kernel on the
> >           2.332 petaflop machine with 37,376 processors 
> >           so I can have the right branch counter on perf.
> > 
> >     Them: Please wait for the next security/stability update of
> >           the 2.6.32 kernel.
> > 
> >     Me:   Thanks.
> 
> You're both funny, though Vince is closer to reality for the scale of 
> machines he's talking about. The vendor kernel on these behemoths is a 
> patched SLES11 kernel based on 2.6.18, and paint does indeed dry faster than 
> changes to that kernel occur.

Well, i replied to the hypothetical posed in the mail, which presumed v2.6.32.

Note that a v2.6.18 box wont have perf events in any case [or any recent 
kernel feature] - they got introduced more than a year ago in v2.6.31.

Of course in real life there are even 2.6.9 based machines out there. There's 
some 2.4 leftovers as well. Life can be arbitrarily weird, for various good 
(and some not so good) reasons.

> > In fact often the kernel gets updated more frequently, because it's so 
> > central.
> 
> Quite the reverse here, we update compilers and libraries quite often, and 
> we have a system in place that keeps the old versions in place.

If you stipulate that you can upgrade anything but the component where a 
significant chunk of perf events logic lives (the kernel) then of course it 
will fail the comparison.

Our point is that it is not how most systems and most developers operate and 
that there are significant, well-proven advantages to the in-kernel model.

And the thing is, for 10 years performance monitoring under Linux was designed 
precisely in the way that was friendly to the 'impossible to upgrade the 
kernel' scenario you outlined - so it's not like we made a random design 
choice.

Still it got virtually nowhere in those 10 years and produced utterly 
incapable software - at least as far as kernel developers are concerned and we 
are trying a different angle now. If you want to help with the user-space 
centric design that Vince worked on then you can help him replace our design. 
I will certainly be glad to merge superior code.

Right now i dont see how that would be possible, having seen both approaches 
first-hand - but i'm ready to be surprised with code.

Or you can lobby your vendors to be more uptodate with the kernel. We upstream 
kernel developers are lobbying them too - it's a good thing to do in any case.

> There are often odd interdependencies between the libraries, and particular 
> science applications often require a specific version to run. Upgrading 
> libraries is fairly painless for us, and we can do it without making the 
> system unavailable to users.
> 
> > The solution for that is to not use restrictive environments with obsolete 
> > tools for bleeding-edge development - or to wait until the features you 
> > rely on trickle down to that environment as well.
> 
> Unfortunately, bleeding-edge high-performance computing requires running in 
> the vendor-supported environment, restrictive as it may be. There's no where 
> else that you can run an application that requires scaling up to that many 
> processors and memory footprint.

Well, 'restrictive, vendor-supplied software' is pretty much the opposite of 
what Linux is about, and for good reasons. It may work for you but i would not 
expect miracles - the two models dont mix very well.

By staying on v2.6.18 or older you will miss out on a lot of other nice kernel 
enhancements, not just perf events. Just in v2.6.32 we made a lot of other 
scalability enhancements to insanely-large hardware. If your vendor is still 
on v2.6.18 then you'll be hurting in a lot of places on sufficiently large 
hardware.

v2.6.18 is a nearly 4 years old kernel.

> > Also, our design targets far more developers than just those who are 
> > willing to download the latest library and are willing to use LD_PRELOAD 
> > or other tricks. In reality most developers will wait for updates if 
> > there's a bug in the tool they are using.
> > 
> > You are a special case of a special case - _and_ you are limiting yourself 
> > by being willing to update everything _but_ the kernel.
> 
> We're limiting ourselves by expecting to get support from the vendor after 
> paying many millions for the machine, and the vendor just doesn't move very 
> quickly in kernel space. I could probably make HEAD run on the machine with 
> some hacking on the machine specific device drivers, but it'd never see 
> production use -- it would void support and that's a deal-killer.

Looks like a possible market opening for a vendor with a better update 
frequency.

Also note the specific event table bug this thread is about: the fix is 
trivial, and any sane vendor, even if based on an old kernel, should be able 
to adopt it very quickly - just as quickly as they adapt security fixes.

And if you cannot wait for that, PeterZ posted a patch how you can redirect 
user-space towards a raw event of your choice.

> Note that I'm not arguing for a design change -- I'm just trying to give you 
> some background on why people in the high-performance computing sector keep 
> saying how much easier it is for them if they can fix issues with a new 
> library rather than a new kernel.
> 
> Once the (very) downstream vendors catch up to a baseline kernel with
> perf in it, fixing bugs like this will require at least partial machine
> downtimes or rolling upgrades with ksplice. Both of those mechanisms
> have their own drawbacks and will require an increased candy supply to
> keep the system admins from picking up pitchforks. :)

I can feel your pain of being unable to upgrade the kernel, but you really 
should shift that pain to your vendors and make them feel it too - not shift 
it towards kernel developers. We are doing our utmost best to give you the 
best technology on the planet, but one thing we cannot give you is a time 
machine that transports the features and fixes you care about back 4 years 
(and only those features) for free. (yet ;-)

Your 'cool feature' is another persons's 'stupid upstream flux that just 
destabilizes the kernel', and what is stupid upstream flux for you, may be a 
must-have cool feature for another person or organization. There's no way we 
can cut out just the feature stream that you care about and isolate you from 
the risks of all the other changes you dont care about.

And no, user-space libraries are not such a mechanism, for instrumentation 
technology. Most of the recent changes to perf events were in kernel logic 
that is not really sane to implement in user-space and which perfmon never 
even attempted to implement. So it's apples to oranges.

Also, i'd expect the core perf functionality to calm down, and i expect event 
table bugs to be fleshed out. We are keeping good backwards compatibility so 
even if you end up with an old kernel, you should have all the functionality 
that was implemented back then to work fine.

Also, it would be great if you could help out extend our self-test mechanisms 
to make sure stupid event table bugs do not slip through. We have 'perf test' 
[which is very small at the moment] which could be used to add more regression 
tests - the ones you care about.

So even with an in-kernel design there's various ways you could help us 
improve the situation and you could thus also influence features in a 
direction that is favorable to you.

Thanks,

	Ingo
