Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573Ab1EQXAP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 19:00:15 -0400
Received: from www.linutronix.de ([62.245.132.108]:55071 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932485Ab1EQXAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 19:00:13 -0400
Date: Wed, 18 May 2011 00:59:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Andy Lutomirski <luto@MIT.EDU>, Ingo Molnar <mingo@elte.hu>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Borislav Petkov <bp@amd64.org>
Subject: Re: [PATCH v4 0/6] Micro-optimize vclock_gettime
In-Reply-To: <m2hb8typxt.fsf@firstfloor.org>
Message-ID: <alpine.LFD.2.02.1105172354040.3078@ionos>
References: <20110516160943.GC25898@one.firstfloor.org> <alpine.LFD.2.02.1105161817120.3078@ionos> <20110516164939.GD25898@one.firstfloor.org> <BANLkTintkmnkN3kW06oa+TjT7W0Q1yQQGA@mail.gmail.com> <m2fwoeo0pf.fsf@firstfloor.org> <alpine.LFD.2.02.1105162345110.3078@ionos>
 <BANLkTinVnr1ZM2wOxuH-rHZGh+_SBWT-+g@mail.gmail.com> <alpine.LFD.2.02.1105170022430.3078@ionos> <20110517080029.GB22093@elte.hu> <BANLkTimpEfb3P9FWgrCDwSSVr6RA8nXb5w@mail.gmail.com> <20110517113634.GC13475@elte.hu> <4DD2BEFB.6070609@mit.edu>
 <m2hb8typxt.fsf@firstfloor.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 May 2011, Andi Kleen wrote:
> Andy Lutomirski <luto@MIT.EDU> writes:
> >
> > On KVM on Sandy Bridge, I can emulate a vsyscall that does nothing in 400ns or so.  I'll try to make this code emulate real vsyscalls over the weekend.  This was much easier than I expected.
> 
> How about the performance of all the statically linked programs? I guess

_ALL_ the statically linked programs? Point out a single one which
matters and _IS_ performance critical.

> you just declared they don't matter? gettimeofday is quite critical
> and adding a exception into it is just a performance desaster.
> 
> Also it's always a dangerous assumption to think that all
> programs on Linux use glibc ("all world is a Vax")
> 
> In fact more and more of Linux users are using different libcs these
> days (like Android or embedded systems or languages with special runtime
> systems) Who knows if all those other libraries use vDSO?

Which is completely irrelevant to x86_64. Point to a single relevant
x86_64 embedded system to which one of the above handwaving applies.

> And then there are of course the old glibcs. A lot of people
> (including me) use new kernels with old userland.

And how is your use case performance critical ?

Furthermore any halfways up to date deployemnt is using VDSO for
obvious reasons and the archaic stuff which might be affected is not
using a recent kernel at all (except for akpm on his retro laptop, but
that "performance penalty" is probably the least of his worries).

> For me this seems like a very risky move -- breaking performance of
> previously perfectly good set ups for very little reason.
> 
> Given the old vsyscall code is somewhat ugly -- I wouldn't argue that --

It's not somewhat ugly. It's a design failure and more important it's
a risk - and you very well know that.

> but compatibility (including performance compatibility) has always
> been importand in Linux and we have far uglier code around in the
> name of compatibility..

We have ugly code around, but it has always been more important to fix
security risks than keeping them around for performance sake.
 
> And the "security problem" you keep talking about can be fixed much
> easier and more compatible as I pointed out.

Unless you come forth with a patch which addresses _ALL_ reasons which
caused me to remove your superior "Make the vsyscall less risky"
approach, just admit that it's fcked up by design and be done with it.

Stop your "as I pointed out" handwaving please. That code was broken
and even exploitable and I removed it for more than one very good
reason. Stop claiming that your "design" is in any way fixable. It's
not.

> As far as I'm concered the change is a bad idea.

As far as I'm concerned you seem to regain your old habits of
defending your proven to be wrong "design" decisions no matter what.

And as long as you can't come up with documented proof that a single
application is affected by such a change, STFU!

Even if you are not able to proof it, it's a total nobrainer to revert
such a change and make it CONFIG_KEEP_FCKUP=y dependent in the very
unliklely case that we get a proper and reasonable regression report.

Thanks,

	tglx
