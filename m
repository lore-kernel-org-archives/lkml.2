Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab1EWLv6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 07:51:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45046 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754546Ab1EWLv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 07:51:56 -0400
Date: Mon, 23 May 2011 13:51:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        David Miller <davem@davemloft.net>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [bloat] Measuring header file bloat effects on kernel build
 performance: a more than 2x slowdown ...
Message-ID: <20110523115138.GA17196@elte.hu>
References: <20110520161210.81bbef3a.sfr@canb.auug.org.au>
 <BANLkTi=Dn_jvJ8mLY0Bc6C1Ptoqa-kJrCg@mail.gmail.com>
 <20110523090918.GA5474@elte.hu>
 <BANLkTi=Vbr+DRBy6sa7omGpvAb0uGunYMA@mail.gmail.com>
 <20110523105522.GC24674@elte.hu>
 <BANLkTinh8raz_96vgdgzzeeG+1TM=s5eVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinh8raz_96vgdgzzeeG+1TM=s5eVw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Mon, May 23, 2011 at 1:55 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Alexey Dobriyan <adobriyan@gmail.com> wrote:
> >
> >> On Mon, May 23, 2011 at 12:09 PM, Ingo Molnar <mingo@elte.hu> wrote:
> 
> >> > Anway, what i tried to demonstrate with this mail how much *real* slowdown
> >> > in the kernel build our current header file bloat is causing. We could
> >> > literally halve our kernel build times if we fixed this!
> >>
> >> News at 11!
> >
> > I have not seen *actual hard numbers* measured before, so how exactly is this
> > news at 11? So i think your condescending reply is neither fair nor justified.
> 
> That's because the final number itself neither important nor interesting.

I disagree rather violently: it's obviously important to know whether it's a 
marginal 3% or the massive 50%+ i measured ...

It's also important to know whether latest GCC got faster at parsing away 
~30-40 KLOC of irrelevant crap. (it didn't)

> It's enough to know it's big enough.
> 
> Even removing "extern" from prototypes has small but noticeable effect, 
> you're talking about real headers.
> 
> Linus dropped few header cleanups of mine, I don't even know when is the 
> right time to send them now.

I do not think your header cleanups are discouraged by Linus, at all (i think 
they were always pretty nice and valuable) - i think you misinterpreted the 
did-not-get-applied events:

Firstly, i've seen a fair amount of avoidable breakage from your header 
cleanups, which are really testable with relatively simple means (key configs 
and randconfig) - so you could either try to improve your testing, or you could 
try to team up with someone better at testing to produce less buggy patches, or 
you could push it into linux-next.

But my main guess is that it's mostly just bad timing: if you don't work 
through maintainer trees (which you don't and sometimes you can't) you don't 
want to push when there's lots of pending trees (for example right now in the 
merge window), nor when possibly-broken cleanups are frowned upon (-rc3 or 
later).

-rc1 to -rc2 would be a pretty safe and large window to send such bits IMO.

Thanks,

	Ingo
