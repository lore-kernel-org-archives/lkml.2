Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab1CJHRa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 02:17:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33780 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944Ab1CJHR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 02:17:27 -0500
Date: Thu, 10 Mar 2011 08:17:09 +0100
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
Message-ID: <20110310071709.GG9289@elte.hu>
References: <AANLkTiknsT1iQzUQ_oBiOORaqWBFyk2BaLq_xu9C5E_G@mail.gmail.com>
 <1299605269.29313.1427511237@webmail.messagingengine.com>
 <AANLkTi=6YstJxad41knR4Q9WN3wYKikPv-g1i3kg3HS1@mail.gmail.com>
 <1299615939.25628.1427572905@webmail.messagingengine.com>
 <AANLkTimBMP1jiuEEUwmKKVNZcZnrkFxFA_YBcLmkEFJM@mail.gmail.com>
 <AANLkTikpMAXfG5aNWo8x7pKKppaQiE-U8qjFaG0B2azV@mail.gmail.com>
 <20110309085150.GC21294@elte.hu>
 <AANLkTiks9o18LRS46CrYHBXzq_6U-v-CqK=0Fzc4Tuco@mail.gmail.com>
 <20110309160241.GC31249@elte.hu>
 <AANLkTinCzzqq6KC5H1Gad7a99dkp_x-cc8f3FHnXdjLJ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinCzzqq6KC5H1Gad7a99dkp_x-cc8f3FHnXdjLJ@mail.gmail.com>
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


* H.J. Lu <hjl.tools@gmail.com> wrote:

> On Wed, Mar 9, 2011 at 8:02 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> >> > This binutils change is breaking numerous upstream kernel builds (and is making
> >> > bisection with new binutils impossible) for no particular good reason: binutils
> >> > was capable to figure out the symbol name before this change.
> >>
> >> That is totally false. The old assembler just generates incorrect size and It
> >> couldn't read the programmer's mind to find the correct symbol name.
> >
> > Still it didnt make the kernel not build and it did not make the kernel not boot. It
> > at most confused some ELF symbol table - which the kernel does not need.
> >
> > So all i'm trying to point out to you is that you appear to be seeing the world in a
> > very binary way: 'broken' versus 'correct' and that it can be rather harmful if you
> > project that binary view on the real world that in reality is not binary but is
> > shades of grey.
> >
> > You are turning a benign ELF symbol table detail (that does not affect the kernel's
> > ability to boot/work) into a hard build breakage and bisection barrier, covering
> > hundreds of commits.
> 
> The original assembler change didn't mention the bogus symbol name in error 
> message, which is very unhelpful. I changed the assembler to print out the bogus 
> symbol name in error message. It should be very trivial to identify the bogus 
> kernel assembly codes.
> 
> > I'm not denying that it's buggy code - I'm just asking you to *PLEASE* at 
> > minimum acknowledge that surprise flag days that turn a before-benign condition 
> > into a fatal build failure suck to everyone else outside your own little 
> > universe.
> 
> There is no way for assembler to know if a bug in input source code is "benign" or 
> not. For assembler, a bug in input is a bug in input.  Assembly programmers should 
> appreciate this assembler change for helping him/her catch such bugs in his/her 
> codes.

I think you _still_ have not understood the very simple compatibility point i'm 
trying to make.

You are retroactively build-breaking kernel code that built and worked fine before. 
Your change could turn large sections of kernel history into a build-broken mess.

GCC does this more or less correctly: i can still build very old versions of the 
kernel even with latest GCC - i have recently bisected to and build v2.6.20 which is 
now a 4+ years old kernel, and had no problems building and booting such an old 
kernel, with a new GCC version.

GCC does this by trying to introduce new restrictions on successful compilation 
conservatively: if the compiler gets smarter and notices bugs (or potential bugs) it 
does not abort the build, it emits a warning instead.

Your "it's simple to fix" argument misses that point: i was talking about bisection 
breakage, and during bisection of kernel bugs we dive back into older versions of 
the code.

It does not matter that you declare the .size directive bogus. It is buggy and yes 
i've already queued up the fixes and i apprecitate them being fixed, but that's 
immaterial to the compatibility argument i made: BINUTILS BUILT THE KERNEL FINE 
BEFORE.

If you do changes to a major component of the build environment of thousands of free 
software projects you *must* consider the real-life compatbility effects of your 
change on others, not just your own motivation.

If you do that you need to at least UNDERSTAND what i'm talking about. It scares the 
heck out of me that we are here at mail #20 with a *very* simple compatibility 
scenario and the maintainer of a major piece of free software infrastructure *still* 
does not understand this very simple argument. How the heck will you be able to 
handle more complex cases of compatibility in a responsible way?

> [...] Assembly programmers should appreciate this assembler change for helping 
> him/her catch such bugs in his/her codes.

Sure, and a warning will have a similar effect and we'll appreciate it. Forcing a 
build error and retroactively breaking the build for working code out of blue, not 
so much.

Thanks,

	Ingo
