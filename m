Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520Ab1FFP1Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 11:27:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41595 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539Ab1FFP1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 11:27:15 -0400
Date: Mon, 6 Jun 2011 17:26:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: pageexec@freemail.hu
Cc: Andrew Lutomirski <luto@mit.edu>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH v5 8/9] x86-64: Emulate legacy vsyscalls
Message-ID: <20110606152657.GJ30348@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>
 <4DECC07A.8317.124A847C@pageexec.freemail.hu>
 <BANLkTi=viR9DaQu2hzX4THdpDqfOZq-cXw@mail.gmail.com>
 <4DECDD14.5845.12BA3C18@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DECDD14.5845.12BA3C18@pageexec.freemail.hu>
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


* pageexec@freemail.hu <pageexec@freemail.hu> wrote:

> > > a page fault is never a fast path, after all the cpu has just 
> > > taken an exception (vs. the syscall/sysenter style actually 
> > > fast user->kernel transition) and is about to make page table 
> > > changes (and possibly TLB flushes).
> >
> > Sure it is.  It's a path that's optimized carefully and needs to 
> > be as fast as possible.  Just because it's annoyingly slow 
> > doesn't mean we get to make it even slower.
> 
> sorry, but stating that the pf handler is a fast path doesn't make 
> it so ;) [...]

Are you talking about the Linux kernel?

FYI, incredible amount of work has gone into making pagefaults as 
fast and scalable as possible. If you are following Linux kernel 
development you'd have to be virtually blind to not see all that 
effort.

[ And yes, serious amount of work has gone into the hardware side as
  well - P4's used to suck *really* bad at pagefaults. ]

You claiming that pagefaults are a slow-path and ridiculing those who 
point out your mistake does not make it a slowpath.

Thanks,

	Ingo
