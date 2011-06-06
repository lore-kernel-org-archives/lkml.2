Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659Ab1FFPuX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 11:50:23 -0400
Received: from r00tworld.com ([212.85.137.150]:47572 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530Ab1FFPuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 11:50:22 -0400
From: pageexec@freemail.hu
To: Ingo Molnar <mingo@elte.hu>
Date: Mon, 06 Jun 2011 17:48:56 +0200
MIME-Version: 1.0
Subject: Re: [PATCH v5 8/9] x86-64: Emulate legacy vsyscalls
Reply-to: pageexec@freemail.hu
CC: Andrew Lutomirski <luto@mit.edu>, x86@kernel.org,
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
Message-ID: <4DECF6E8.19026.131F1F1F@pageexec.freemail.hu>
In-reply-to: <20110606152657.GJ30348@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>, <4DECDD14.5845.12BA3C18@pageexec.freemail.hu>, <20110606152657.GJ30348@elte.hu>
X-mailer: Pegasus Mail for Windows (4.61)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Mon, 06 Jun 2011 17:49:30 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 Jun 2011 at 17:26, Ingo Molnar wrote:

> 
> * pageexec@freemail.hu <pageexec@freemail.hu> wrote:
> 
> > > > a page fault is never a fast path, after all the cpu has just 
> > > > taken an exception (vs. the syscall/sysenter style actually 
> > > > fast user->kernel transition) and is about to make page table 
> > > > changes (and possibly TLB flushes).
> > >
> > > Sure it is.  It's a path that's optimized carefully and needs to 
> > > be as fast as possible.  Just because it's annoyingly slow 
> > > doesn't mean we get to make it even slower.
> > 
> > sorry, but stating that the pf handler is a fast path doesn't make 
> > it so ;) [...]
> 
> Are you talking about the Linux kernel?

yes, what else? ;)

> FYI, incredible amount of work has gone into making pagefaults as 
> fast and scalable as possible.

i wasn't talking about scalability (it's irrelevant anyway here), only
speed. you're the man with the (in)famous measuring stick, tell me how
many cycles it takes to serve a C-O-W fault or instantiation of an anon
page and a file page (both cached and non-cached). then stick a few well
predicted conditional branches in that path (something that wouldn't
actually happen with my code but let's play this out fully) and show me
measured differences. then we'll talk about the 'impact on fast path'.

> If you are following Linux kernel development you'd have to be
> virtually blind to not see all that effort. 

nice attempt to question me but it won't get you anywhere (didn't i just
tell you to heed your own advice?). case in point, i'd fixed the anon_vma
refcount leak (exploitable and silently fixed as usual in mainline) a
few months before you guys did. just by reading the code. now show me
that you know your stuff around and can find the commit i'm talking about.
unless of course you are not "following Linux kernel development" and
are "virtually blind to not see all that effort".
 
> You claiming that pagefaults are a slow-path and ridiculing those who 
> point out your mistake does not make it a slowpath.

you must have realized by now that slow/fast path in this context were
relative to int xx vs. pf processing. and i'm yet to receive the numbers
that show how much faster the latter is processed than the former and why
sticking a few well predictable conditional jumps (no really, they would
not be there, but let's assume they are) shows a measurable impact on
these all so fast pf paths.

