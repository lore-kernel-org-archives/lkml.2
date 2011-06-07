Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241Ab1FGIbW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 04:31:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60554 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197Ab1FGIbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 04:31:18 -0400
Date: Tue, 7 Jun 2011 10:30:59 +0200
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
Message-ID: <20110607083059.GB4133@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>
 <4DECFE18.23229.133B32ED@pageexec.freemail.hu>
 <20110606164700.GA2391@elte.hu>
 <4DED5985.542.14A05486@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DED5985.542.14A05486@pageexec.freemail.hu>
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

> > A fastpath is defined by optimization considerations applied to a 
> > codepath (the priority it gets compared to other codepaths), 
> > *not* by its absolute performance.
> 
> we're not talking about random arbitrarily defined paths here but 
> the impact of putting well predicted branches into the pf handler 
> vs. int xx (are you perhaps confused by 'fast path' vs. 
> 'fastpath'?).

So please educate me, what is the difference between 'fast path' 
versus 'fastpath', as used by kernel developers, beyond the space?

> that impact only matters if it's measurable. you have yet to show 
> that it is. and all this sillyness is for a hypothetical situation 
> since those conditional branches don't even need to be in the 
> general page fault processing paths.

Is this some sort of sick joke?

Do you *really* claim that the number of instructions executed in a 
fastpath do not matter and that our years-long effort to shave off an 
instruction here and there from the x86 do_page_fault() code were 
meaningless and that we can add branches with zero cost?

Thanks,

	Ingo
