Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146Ab1EaQnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 12:43:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34271 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827Ab1EaQna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 12:43:30 -0400
Date: Tue, 31 May 2011 18:43:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Lutomirski <luto@mit.edu>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jesper Juhl <jj@chaosbits.net>,
        Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v4 09/10] x86-64: Randomize int 0xcc magic al values at
 boot
Message-ID: <20110531164316.GB15651@elte.hu>
References: <cover.1306851090.git.luto@mit.edu>
 <75a00aee647302e22c86a5c5fac0478b9776481a.1306851090.git.luto@mit.edu>
 <20110531154012.GB30353@elte.hu>
 <BANLkTimGAtCPuvwvKfD6TLcabVzqKZhfGg@mail.gmail.com>
 <BANLkTi=cV=aOZsg5D0gNQP6GOZnKwPi9tQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=cV=aOZsg5D0gNQP6GOZnKwPi9tQ@mail.gmail.com>
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


* Andrew Lutomirski <luto@mit.edu> wrote:

> On Tue, May 31, 2011 at 11:56 AM, Andrew Lutomirski <luto@mit.edu> wrote:
> > We could scrap int 0xcc entirely and emulate on page fault, but that
> > is slower and has other problems (like breaking anything that thinks
> > it can look at a call target in a binary and dereference that
> > address).
> >
> > Here's a possibly dumb/evil idea:
> >
> > Put real syscalls in the vsyscall page but mark the page NX.  Then
> > emulate the vsyscalls on the PF_INSTR fault when userspace jumps to
> > the correct address but send SIGSEGV for the wrong address.
> >
> > Down side: it's even more complexity for the same silly case.
> 
> Scratch that.  It's incompatible with keeping time() fast for now.

If we can find another fault than #PF then it will be similarly fast 
to an INT $0xCC so please at least investigate this route.

Thanks,

	Ingo
