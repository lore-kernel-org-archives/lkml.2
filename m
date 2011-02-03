Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab1BCVGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 16:06:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36205 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247Ab1BCVG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 16:06:29 -0500
Date: Thu, 3 Feb 2011 22:06:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>
Subject: Re: [patch] x86, mm: avoid stale tlb entries by clearing prev
 mm_cpumask after switching mm
Message-ID: <20110203210616.GA17471@elte.hu>
References: <1296677247.4418.103.camel@sbsiddha-MOBL3.sc.intel.com>
 <AANLkTi=P+aoY4GY32xa8D8gHbDP73QpPmzvKbB4VM7g2@mail.gmail.com>
 <AANLkTinvQatNF0ZJqmvuKYNq7oKXqfR5Ke1FuaSLFNEF@mail.gmail.com>
 <1296757637.4418.1482.camel@sbsiddha-MOBL3.sc.intel.com>
 <AANLkTimuSV273ksidN_vQ4o1rLr6D--9Q3dNnBiB13-K@mail.gmail.com>
 <1296761671.4418.1558.camel@sbsiddha-MOBL3.sc.intel.com>
 <AANLkTimjYAYPLf=QG22hFHm7yhABCQj7q=kOpB6HcB5e@mail.gmail.com>
 <1296764404.4418.1634.camel@sbsiddha-MOBL3.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296764404.4418.1634.camel@sbsiddha-MOBL3.sc.intel.com>
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


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> On Thu, 2011-02-03 at 11:48 -0800, Linus Torvalds wrote:
> > On Thu, Feb 3, 2011 at 11:34 AM, Suresh Siddha
> > <suresh.b.siddha@intel.com> wrote:
> > >
> > > True. 'stale' is the wrong word. Do you want me to send a corrected one
> > > by replacing it with 'bogus'?
> > 
> > Please.
> > 
> > > my understanding is that unless we end up using that TLB entry, we will
> > > not have the issues like machine checks due to cacheability issues etc.
> > > If it is not global, upcoming cr3 change will flush it and meanwhile I
> > > don't think there is a scenario where we refer to these user-addresses.
> > 
> > Quite possible. The situation I envisioned was the same speculative
> > memory access that causes the TLB fill to also cause a cache fill -
> > for a noncacheable region (because the bogus TLB entry sets the random
> > address to cacheable).
> > 
> > And then what happens when somebody else accesses the same memory
> > noncacheably (through a valid TLB entry), and finds it in the cache?
> > 
> > I dunno. Not really important. The important part is the "possible
> > random bogus TLB entry", the fact that the CPU can act strangely after
> > that is pretty much a given.
> > 
> 
> Ok. Updated patch appended.

Linus, the patch fine to me too.

Acked-by: Ingo Molnar <mingo@elte.hu>

Do you want to apply it or should I?

Thanks,

	Ingo
