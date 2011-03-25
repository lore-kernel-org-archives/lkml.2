Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab1CYLbH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 07:31:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44609 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629Ab1CYLbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 07:31:04 -0400
Date: Fri, 25 Mar 2011 12:30:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, x86@kernel.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86 APM: delete Linux kernel APM support
Message-ID: <20110325113048.GC29521@elte.hu>
References: <alpine.LFD.2.02.1103232321070.3848@x980>
 <20110324154505.934a56a0.sfr@canb.auug.org.au>
 <alpine.LFD.2.02.1103240336590.4529@x980>
 <alpine.LFD.2.02.1103240414450.4529@x980>
 <20110324083959.GE30812@elte.hu>
 <alpine.LFD.2.02.1103241929450.16085@x980>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1103241929450.16085@x980>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Len Brown <lenb@kernel.org> wrote:

> > Thus from a maintenance POV APM has not been much of a drag on the x86 
> > maintainer side. Sure, we do not test it, but that's the case with most of 
> > the obsolete drivers in the kernel.
> > 
> > The principle is that as long as there's no ongoing drag, the cost of 
> > carrying obsolete drivers is minimal - and the unknown cost of screwing 
> > someone in a big way by removing hardware support is hard to measure 
> > reliably. So we are cautious and err on the side of supporting too much 
> > hardware.
> 
> I think this reasoning would apply in 2006, but that was 5 years ago.

I cited a few real examples:

 > > Beyond the lack of a upstream-visible feature-removal-schedule entry, we 
 > > still have an Arcnet driver which hardware was obsoleted by Ethernet in the 
 > > late 80s, and we still have i486 support and those are *much* older than 
 > > APM.

So how does your reasoning not apply to those drivers? There's several which 
are older than APM support.

We had this really big battle about x86/Voyager two years ago, which x86 
subarchitecture literally had just a single user left, and the code was more 
intrusive than APM. Even there after much flaming the eventual consensus was 
that we'd accept it back if it was done cleanly, as part of the new-style 
x86_platform code.

Given that APM fits into the current PM frameworks there's no such problem here 
that i can see.

> Okay, I can delay this way:
> 
> 2.6.39:
> 	feature-removal.txt targets 2.6.42 removal
> 	depend on CONFIG_EXPERT
> 
> 2.6.40, 2.6.41:
> 	WARN once on run-time access
> 
> 2.6.42:
> 	remove.

Regardless of removal, i'd suggest a "this code is not supported" kind of 
WARN() message to the APM code today, into .39 - to see whether it pops up 
anywhere - and mark it for -stable as well.

.42 removal might be too fast, considering the typical release schedule of 
Linux distributions. And i'm still doubting the removal itself: we are adding 
lots of special-purpose subarch drivers to arch/x86/ as we speak (the embedded 
mess coming to x86) - which drivers will be tomorrow's APM code. On what 
grounds do we treat APM support differently?

Our general compatibility with old hardware is an *asset* that we should value.

Thanks,

	Ingo
