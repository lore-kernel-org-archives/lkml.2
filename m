Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab0KKJHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 04:07:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56138 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab0KKJHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 04:07:46 -0500
Date: Thu, 11 Nov 2010 10:07:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kees Cook <kees.cook@canonical.com>
Cc: matthieu castet <castet.matthieu@free.fr>,
        Siarhei Liakh <sliakh.lkml@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Security] proactive defense: using read-only memory, RO/NX
 modules
Message-ID: <20101111090713.GC18789@elte.hu>
References: <20101107193520.GO5327@outflux.net>
 <20101108061324.GA30540@elte.hu>
 <20101108214228.GQ5876@outflux.net>
 <20101110090415.GC8370@elte.hu>
 <20101111065658.GA5876@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101111065658.GA5876@outflux.net>
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


* Kees Cook <kees.cook@canonical.com> wrote:

> Hi Ingo,
> 
> On Wed, Nov 10, 2010 at 10:04:15AM +0100, Ingo Molnar wrote:
> > * Kees Cook <kees.cook@canonical.com> wrote:
> > > Oh, well, yes, that's a good reason. :) Where was this covered? I'd like to help 
> > > get it reproduced and ironed out.
> > 
> > Matthieu Castet seems to have dusted off those patches and submitted two of them in 
> > this mail:
> > 
> >   Subject: [RFC] reworked NX protection for kernel data
> > 
> > Matthieu, are you still interested in this topic?
> > 
> > The original, broken patches were these -tip commits:
> > 
> >  1e858c081af5: x86, mm: RO/NX protection for loadable kernel modules
> >  18c60ddc9eff: x86, mm: NX protection for kernel data
> >  c226a2feba21: x86, mm: Set first MB as RW+NX
> >  b29d530510d4: x86, mm: Correcting improper large page preservation
> > 
> > I reported one of the crashes in:
> > 
> >   Subject: Re: [tip:x86/mm] x86, mm: Set first MB as RW+NX
> > 
> > on lkml.
> 
> Thanks for looking this up!
> 
> Can we get 1e858c081af5 and 18c60ddc9eff back in, and then work forward
> from there?

Yeah. Please port them to latest -tip:

   http://people.redhat.com/mingo/tip.git/README

And give them some testing, and send out the new series. I'll re-report the crash to 
you for a new kernel, if it still occurs.

(Please also keep Rusty and Linus Cc:-ed for the module bits.)

In hindsight, i think the kernel/module.c bits should be in arch/x86/kernel/module.c 
- the new code is full of x86 only names and facilities.

Also, please remove various checkpatch col80 artifacts, such as:

+               if (end_pfn > begin_pfn)
+                       set_memory_nx(begin_pfn << PAGE_SHIFT,
+                                               end_pfn - begin_pfn);

that should be:

+               if (end_pfn > begin_pfn)
+                       set_memory_nx(begin_pfn << PAGE_SHIFT, end_pfn - begin_pfn);

Thanks,

	Ingo
