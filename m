Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab1EWKzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 06:55:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53601 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711Ab1EWKzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 06:55:38 -0400
Date: Mon, 23 May 2011 12:55:22 +0200
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
Message-ID: <20110523105522.GC24674@elte.hu>
References: <20110520161210.81bbef3a.sfr@canb.auug.org.au>
 <BANLkTi=Dn_jvJ8mLY0Bc6C1Ptoqa-kJrCg@mail.gmail.com>
 <20110523090918.GA5474@elte.hu>
 <BANLkTi=Vbr+DRBy6sa7omGpvAb0uGunYMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=Vbr+DRBy6sa7omGpvAb0uGunYMA@mail.gmail.com>
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

> On Mon, May 23, 2011 at 12:09 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >      24594a2bfcaa: [PATCH] x86-64 merge
> >
> >     - Remove some unneeded prefetches.  Just two are enough to kickstart
> >       the hardware prefetcher.
> >
> >   But despite touching prefetches explicitly, this too sloppily left the (now
> >   dangling) prefetch.h include file around.
> 
> Well, developer removes include, developer risks compile breakage.

If developer removes the final prefetch() from an unrelated header he might as 
well think of removing the prefetch.h header. If there's compile breakage we 
want to fix the breakage.

But yes, this is easily forgotten and the basic psychology is for header file 
dependencies to grow, almost never to shrink.

To counteract that in a really good way we need tooling help - we are fighting 
entropy here ...

> > Anway, what i tried to demonstrate with this mail how much *real* slowdown 
> > in the kernel build our current header file bloat is causing. We could 
> > literally halve our kernel build times if we fixed this!
> 
> News at 11!

I have not seen *actual hard numbers* measured before, so how exactly is this 
news at 11? So i think your condescending reply is neither fair nor justified.

Yes, we all knew that there's build time costs of header bloat - but it was 
never AFAIK measured and posted to lkml in such a clear way.

Thanks,

	Ingo
