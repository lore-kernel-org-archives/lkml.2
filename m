Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119Ab1FFVyt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 17:54:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53315 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758055Ab1FFVyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 17:54:46 -0400
Date: Mon, 6 Jun 2011 23:54:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, pageexec@freemail.hu,
        Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH v5 9/9] x86-64: Add CONFIG_UNSAFE_VSYSCALLS to
 feature-removal-schedule
Message-ID: <20110606215421.GA12079@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>
 <4DECAE68.16683.1203EBBB@pageexec.freemail.hu>
 <BANLkTin5jEmUUxWUUkYn9pKzGRwcA-zRLw@mail.gmail.com>
 <4DED206E.20356.13C155EA@pageexec.freemail.hu>
 <BANLkTi=choqfXPYmnivznYBbEFeg2UfbuA@mail.gmail.com>
 <BANLkTim8mSoifxoN=b2Gpe+WLjJyuqBR8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTim8mSoifxoN=b2Gpe+WLjJyuqBR8g@mail.gmail.com>
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

> > don't even bother making it a config option for now. If we can 
> > replace the vsyscall page with a page fault or int3 or whatever, 
> > and it's only used for the 'time()' system call, just do it.
> 
> Really?
> 
> I won't personally complain about the 200+ ns hit, but I'm sure 
> someone will cc: me on a regression report if there's no option.

Well, for 0.2 usecs to show up one would have to do like a million of 
them per second.

Why an application would want to query the *same value* from the 
kernel a million times per second is beyond me. vgettimeofday()? 
Sure. But vtime()?

Thanks,

	Ingo
