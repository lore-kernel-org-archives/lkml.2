Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab1FHHQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 03:16:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59166 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839Ab1FHHQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 03:16:46 -0400
Date: Wed, 8 Jun 2011 09:16:20 +0200
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
Message-ID: <20110608071620.GB6747@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>
 <4DED5985.542.14A05486@pageexec.freemail.hu>
 <20110607083059.GB4133@elte.hu>
 <4DEEB31B.3353.19E649C2@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DEEB31B.3353.19E649C2@pageexec.freemail.hu>
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

> to give you an idea:
> - if a code path executes in 1M or 1K cycles once every hour, then
>   it's not a fast path, it doesn't matter to anyone whether it runs
>   1 or 10 cycles faster or not,
> - if a code path executes in 1M cycles 100 times a second then it's
>   still not a fast path where single cycle speedups would mean anything,
> - now if a code path executes in 1K cycles 100K times a second then
>   suddenly there's a huge multiplier on even single cycle improvements
>   that *may* be measurable and therefore relevant for some users

The thing is, as i explained it before, your claim:

  > a page fault is never a fast path

is simply ridiculous on its face and crazy talk.

Beyond all the reasons why we don't want to touch the page fault path 
we have a working, implemented, tested IDT based alternative approach 
here that is faster and more compartmented so there's no reason 
whatsoever to touch the page fault path. We *do* add code to the page 
fault path in justified cases so this is not an absolute rule, but we 
try to avoid doing it, for all the reasons that me and others 
outlined.

Even if you do not take my word for it, several prominent kernel 
developers told you already that you are wrong, and i also showed you 
the commits that prove you wrong.

Your reply to that was to try to change the topic, laced with 
frequent insults thrown at me. You called me an 'asshole' yet the 
only thing i did was that i argued with you patiently.

Is there *any* point where you are willing to admit that you are 
wrong or should i just start filtering out your emails to save me all 
this trouble? When you comment on technical details you generally 
make very good suggestions so i'd hate to stop listening to your 
feedback, but there's a S/N ratio threshold under which i will need 
to do it ...

Thanks,

	Ingo
