Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab1FHKjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 06:39:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34505 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752955Ab1FHKjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 06:39:43 -0400
Date: Wed, 8 Jun 2011 12:39:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: pageexec@freemail.hu
Cc: Andi Kleen <andi@firstfloor.org>, Andrew Lutomirski <luto@mit.edu>,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jesper Juhl <jj@chaosbits.net>,
        Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH v5 8/9] x86-64: Emulate legacy vsyscalls
Message-ID: <20110608103906.GB13393@elte.hu>
References: <20110608091120.GI27166@one.firstfloor.org>
 <4DEF424F.2351.1C15AD40@pageexec.freemail.hu>
 <20110608100612.GJ27166@one.firstfloor.org>
 <4DEF4E69.14274.1C44F04F@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DEF4E69.14274.1C44F04F@pageexec.freemail.hu>
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

> On 8 Jun 2011 at 12:06, Andi Kleen wrote:
> 
> > > eventually may even go away as time progresses and linux 
> > > systems begin to fully rely on the vdso instead.
> > 
> > That assumes that everyone uses glibc and also updates their 
> > userland. As pointed out many times that's a deeply flawed 
> > assumption.
> 
> i think the assumption is not that everyone uses glibc but that 
> everyone else (as in, every other libc) can simply take the 
> necessary changes from glibc, provided they need such changes at 
> all (i.e., they're using the vsyscall entry points over the vdso 
> ones).
> 
> i frankly didn't check any of the alternatives myself 
> (uclibc/klibc/bionic/etc) but i can't imagine that it'd be that 
> much harder to patch them than glibc.

Correct. Also, as i pointed it out in the previous mail, ABI does not 
mean 'will execute the same instructions', that would be silly. We 
*do* fix serious wide-scale performance regressions (obviously), but 
if it's about some weird crazy legacy path that we had good security 
reasons to change, and which is trivial to performance-improve in the 
library then we are well within our boundaries to keep the change.

> as i said, this was a compromise solution but then i think you 
> already made it clear that you didn't even think there was a 
> problem here to solve, so i guess we should work that out first, if 
> you want to ;).

Heh, indeed ;-)

Thanks,

	Ingo
