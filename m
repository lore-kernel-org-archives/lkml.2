Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335Ab0CWLQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 07:16:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36959 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598Ab0CWLQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 07:16:30 -0400
Date: Tue, 23 Mar 2010 12:16:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, yinghai@kernel.org,
       tglx@linutronix.de, hpa@zytor.com, jbarnes@virtuousgeek.org,
       ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 06/20] early_res: seperate common memmap func from e820.c
 to fw_memmap.c
Message-ID: <20100323111612.GB1189@elte.hu>
References: <4BA6EA62.1030603@kernel.org>
 <20100321.210023.209981130.davem@davemloft.net>
 <4BA6F1F6.3070102@kernel.org>
 <20100321.213350.176660494.davem@davemloft.net>
 <20100322092809.GA20607@elte.hu>
 <1269290862.8599.77.camel@pasglop>
 <20100322205703.GA25254@elte.hu>
 <1269294857.8599.90.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269294857.8599.90.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Mon, 2010-03-22 at 21:57 +0100, Ingo Molnar wrote:
> > 
> > > You use that arguemnt ONE MORE FUCKING TIME and you'll end up in my killfile 
> > > with a auto-NACK reply of anything that looks like a patch from you.
> > 
> > Does this mean you disagree with that? (I think it's pretty factual, last i 
> > checked the usage stats of devel kernels was somewhere around 99.7%.)
> 
> I disagree with that being a relevant argument in the technical discussion 
> on the relative merits of two implementations of a given facility. I also 
> disagree with your numbers, if you talk about deployement, I would be very 
> very surprised if ARM wasn't close to on-par with x86.

As an upstream maintainer i mainly care about upstream kernel contributions. 
These contributions have three main forms:

  - patches i get against latest upstream

  - on-lkml review/analysis that is done on those patches

  - test/bug/regression reports i get against latest upstream (either directly 
    on lkml or via kerneloops.org or bugzilla.kernel.org)

So i weigh the architectures based on that input.

Since you mentioned ARM - here's the Git contribution stats. In the last 5 
years since we have kernel Git history, there's been 1080 commits to 
kernel/sched.c. Amongst those 1080 commits i could find only a _single commit_ 
(a minor fix) being related to or contributed by anyone doing ARM development!

To be on the safe side lets assume that i missed many commits, lets up that 
count to ten times of that count: 10 commits. I.e. the 'weight of ARM', when 
it comes to kernel/sched.c, is still less than 1%.
 
'millions of ARM units' alone means little to me, if it does not translate 
into actual upstream kernel contributions. Many of those 'millions of units' 
are walled off from kernel contributions: the users dont even know they are 
running Linux. They are not linked to kerneloops.org and dont produce bugzilla 
bugreports. They do finance Linux developers by proxy - but as far as the 
upstream kernel is concerned they only exist to the extent they finance kernel 
developers to care about it.

Lets look at a counter example: Sparc64. There's literally just a handful of 
Sparc64 'units' that run Linux, still the weight of the arch is much higher - 
due to the well-known highly productive kernel contributor who is using that 
architecture. I have seen about 10 times more scheduler contributions [~15 
commits] from that single unit Sparc64 angle than from the millions of ARM 
units! (and davem isnt even doing scheduler development per se - he's mostly 
doing drive-by fixes and improvements with no particular focus on the 
scheduler.)

Or lets look at an architecture that during its development had a physical 
unit count of _zero_: SGI UV. It was only running in simulators for a year but 
it sure resulted in dozens and dozens of useful patches that extended Linux's 
scalability reach. So did SGI UV matter, despite having had a zero unit count? 
Heck it did ...

I singled out kernel/sched.c but there's a very similar picture and 
contribution weights when it comes to other areas i co-maintain: lockdep, 
perf, tracing, etc.

So if you want your architecture to matter to me the rule is very simple: 
contribute, contribute, contribute, and stop whining. If you dont contribute, 
frankly you dont really exist to me. On the other hand if you are actively 
contributing while your architecture only exists on paper, it already starts 
mattering to me.

I'm really that simple.

Thanks,

	Ingo
