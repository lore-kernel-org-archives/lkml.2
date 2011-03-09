Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab1CIQCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 11:02:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35641 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755636Ab1CIQCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 11:02:51 -0500
Date: Wed, 9 Mar 2011 17:02:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H.J. Lu" <hjl.tools@gmail.com>
Cc: sedat.dilek@gmail.com, Sedat Dilek <sedat.dilek@googlemail.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        linux-next <linux-next@vger.kernel.org>, psomas@cslab.ece.ntua.gr,
        Jan Beulich <JBeulich@novell.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for March 8 (BROKEN:
 arch/x86/kernel/entry_32.S? Debian's binutils/as?)
Message-ID: <20110309160241.GC31249@elte.hu>
References: <AANLkTik_Cb7tXheZNOBjqnoQc4MSL1LnDtFGFP5mqZRi@mail.gmail.com>
 <AANLkTinBv__n7k3Z=EJWv1fdQScyB7AJV0SsYJE0mCwQ@mail.gmail.com>
 <AANLkTiknsT1iQzUQ_oBiOORaqWBFyk2BaLq_xu9C5E_G@mail.gmail.com>
 <1299605269.29313.1427511237@webmail.messagingengine.com>
 <AANLkTi=6YstJxad41knR4Q9WN3wYKikPv-g1i3kg3HS1@mail.gmail.com>
 <1299615939.25628.1427572905@webmail.messagingengine.com>
 <AANLkTimBMP1jiuEEUwmKKVNZcZnrkFxFA_YBcLmkEFJM@mail.gmail.com>
 <AANLkTikpMAXfG5aNWo8x7pKKppaQiE-U8qjFaG0B2azV@mail.gmail.com>
 <20110309085150.GC21294@elte.hu>
 <AANLkTiks9o18LRS46CrYHBXzq_6U-v-CqK=0Fzc4Tuco@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTiks9o18LRS46CrYHBXzq_6U-v-CqK=0Fzc4Tuco@mail.gmail.com>
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


* H.J. Lu <hjl.tools@gmail.com> wrote:

> > Yes, the .size directive not matching up is technically a bug, but it was not 
> > checked by binutils before, for *years* - and you cannot just flip a switch and 
> > break who knows how much code.
> >
> > You need to at least emit a warning for some time to give people a *chance* to 
> > fix bugs - not just stuff an incompatible binutils down their throat and break 
> > the kernel build for thousands of commits and break bisection.
> 
> If kernel doesn't use/need symbol size, don't put it in assembly code.

What does that have to do with the question i raised: that of binutils backwards 
(in)compatibility to be able to build the Linux kernel?

> > This binutils change is breaking numerous upstream kernel builds (and is making 
> > bisection with new binutils impossible) for no particular good reason: binutils 
> > was capable to figure out the symbol name before this change.
> 
> That is totally false. The old assembler just generates incorrect size and It 
> couldn't read the programmer's mind to find the correct symbol name.

Still it didnt make the kernel not build and it did not make the kernel not boot. It 
at most confused some ELF symbol table - which the kernel does not need.

So all i'm trying to point out to you is that you appear to be seeing the world in a 
very binary way: 'broken' versus 'correct' and that it can be rather harmful if you 
project that binary view on the real world that in reality is not binary but is 
shades of grey.

You are turning a benign ELF symbol table detail (that does not affect the kernel's 
ability to boot/work) into a hard build breakage and bisection barrier, covering 
hundreds of commits.

I'm not denying that it's buggy code - I'm just asking you to *PLEASE* at minimum 
acknowledge that surprise flag days that turn a before-benign condition into a fatal 
build failure suck to everyone else outside your own little universe.

Thanks,

	Ingo
