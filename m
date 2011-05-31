Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898Ab1EaT3C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 15:29:02 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34728 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753523Ab1EaT3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 15:29:00 -0400
Date: Tue, 31 May 2011 21:28:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [PATCH v4 10/10] x86-64: Add CONFIG_UNSAFE_VSYSCALLS to
 feature-removal-schedule
Message-ID: <20110531192833.GA23458@elte.hu>
References: <cover.1306851090.git.luto@mit.edu>
 <1660d1687db01852ec58bbf970e22868db367d53.1306851090.git.luto@mit.edu>
 <20110531183448.GA27166@one.firstfloor.org>
 <BANLkTinXSDJoT6Uege6zLZqSp87oURfh0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinXSDJoT6Uege6zLZqSp87oURfh0w@mail.gmail.com>
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

> > And it's still a bad idea. Especially since there's a much better 
> > alternative anyways for the "security problem" which has none of 
> > these drawbacks.
> 
> What's the alternative?

Well, Andi likes to draw out such answers and likes to keep any 
answer as minimally helpful as possible (to demonstrate his 
superiority), but my guess would be that he is thinking of the 
(trivial) solution that filters the caller RIP at the generic syscall 
entry point and checks RCX against the 'expected' SYSCALL instruction 
address, which is the (per task) vdso-address + constant-offset.

That method has a big disadvantage:

 - it slows down the syscall fastpath with two or three unnecessary 
   instructions.

It has two advantages:

 - it's the simplest method of all

 - it also *only* allows the vdso address to be used for system calls,
   so if an attacker manages to find an executable SYSCALL 
   instruction somewhere in the executable space of an application,
   that entry point will not be usable.

... so this method is not completely off the table.

If everyone agrees that the generic syscall overhead is acceptable we 
could try this too.

Thoughts?

Thanks,

	Ingo
