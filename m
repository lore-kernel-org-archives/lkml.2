Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab1FFQrY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 12:47:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52881 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753686Ab1FFQrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 12:47:23 -0400
Date: Mon, 6 Jun 2011 18:47:00 +0200
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
Message-ID: <20110606164700.GA2391@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>
 <4DECF6E8.19026.131F1F1F@pageexec.freemail.hu>
 <20110606155953.GB7374@elte.hu>
 <4DECFE18.23229.133B32ED@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DECFE18.23229.133B32ED@pageexec.freemail.hu>
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

> On 6 Jun 2011 at 17:59, Ingo Molnar wrote:
> 
> > > > FYI, incredible amount of work has gone into making pagefaults as 
> > > > fast and scalable as possible.
> > > 
> > > i wasn't talking about scalability (it's irrelevant anyway here), 
> > > only speed. [...]
> > 
> > Which part of "fast and scalable" did you not understand?
> 
> uhm, not sure why you're so worked up here. is it because i said
> 'scalability' was completely irrelevant for the nx vsyscall page
> approach? elaborate!

Firstly, 'fast' is a necessary first step towards good scalability, 
secondly i was talking about *both* speed and scalability so your 
insistence to only discuss speed is banging on open doors ...

You are simply wrong about:

> > > sorry, but stating that the pf handler is a fast path doesn't 
> > > make it so ;).

and 5-6 mails down the line you are still unwilling to admit it. Why?

A fastpath is defined by optimization considerations applied to a 
codepath (the priority it gets compared to other codepaths), *not* by 
its absolute performance.

For example even though kmalloc() is about two orders of magnitude 
slower than the an unlikely() branch in the scheduler wakeup path, it 
is still kmalloc() that is the fastpath and the unlikely() branch in 
try_to_wake_up() is a slowpath.

You seem to be confused on several levels here.

Thanks,

	Ingo
