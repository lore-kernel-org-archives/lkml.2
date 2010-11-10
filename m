Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab0KJJEh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 04:04:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52807 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753468Ab0KJJEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 04:04:32 -0500
Date: Wed, 10 Nov 2010 10:04:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kees Cook <kees.cook@canonical.com>,
        matthieu castet <castet.matthieu@free.fr>
Cc: Siarhei Liakh <sliakh.lkml@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Security] proactive defense: using read-only memory, RO/NX
 modules
Message-ID: <20101110090415.GC8370@elte.hu>
References: <20101107193520.GO5327@outflux.net>
 <20101108061324.GA30540@elte.hu>
 <20101108214228.GQ5876@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101108214228.GQ5876@outflux.net>
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

> Hi,
> 
> On Mon, Nov 08, 2010 at 07:13:24AM +0100, Ingo Molnar wrote:
> > * Kees Cook <kees.cook@canonical.com> wrote:
> > > While Dan Rosenberg is working to make things harder to locate potential targets 
> > > in the kernel through fixing kernel address leaks[1], I'd like to approach a 
> > > related proactive security measure: enforcing read-only memory for things that 
> > > would make good targets.
> > 
> > Nice! IMHO we need more of that. (If the readonly section gets big enough in 
> > practice we could perhaps even mark it large-page in the future. It could serve as 
> > an allocator to module code as well - that would probably be a speedup even for 
> > modules.)
> 
> Well, I can try to extract and send what PaX does, but it seems relatively
> incompatible with the existing system that uses set_kernel_text_rw() and
> friends.
> 
> > > - Modules need to be correctly marked RO/NX. This patch exists[3], but is
> > >   not in mainline. It needs to be in mainline.
> > [...]
> > >
> > > [3] http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=commitdiff;h=65187d24fa3ef60f691f847c792e8eaca7e19251
> > 
> > The reason the RO/NX patch from Siarhei Liakh is not upstream yet is rather mundane: 
> > it introduced regressions - it caused boot crashes on one of my testboxes.
> > 
> > But there is no fundamental reason why it shouldnt be upstream. We can push it 
> > upstream if the crashes are resolved and if it gets an Ack from Rusty or Linus 
> > for the module bits.
> 
> Oh, well, yes, that's a good reason. :) Where was this covered? I'd like to help 
> get it reproduced and ironed out.

Matthieu Castet seems to have dusted off those patches and submitted two of them in 
this mail:

  Subject: [RFC] reworked NX protection for kernel data

Matthieu, are you still interested in this topic?

The original, broken patches were these -tip commits:

 1e858c081af5: x86, mm: RO/NX protection for loadable kernel modules
 18c60ddc9eff: x86, mm: NX protection for kernel data
 c226a2feba21: x86, mm: Set first MB as RW+NX
 b29d530510d4: x86, mm: Correcting improper large page preservation

I reported one of the crashes in:

  Subject: Re: [tip:x86/mm] x86, mm: Set first MB as RW+NX

on lkml.

Thanks,

	Ingo
