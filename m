Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759062Ab1FGXZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 19:25:53 -0400
Received: from r00tworld.com ([212.85.137.150]:50288 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135Ab1FGXZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 19:25:51 -0400
From: pageexec@freemail.hu
To: Ingo Molnar <mingo@elte.hu>
Date: Wed, 08 Jun 2011 01:24:11 +0200
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
Message-ID: <4DEEB31B.3353.19E649C2@pageexec.freemail.hu>
In-reply-to: <20110607083059.GB4133@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>, <4DED5985.542.14A05486@pageexec.freemail.hu>, <20110607083059.GB4133@elte.hu>
X-mailer: Pegasus Mail for Windows (4.61)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Wed, 08 Jun 2011 01:24:54 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 Jun 2011 at 10:30, Ingo Molnar wrote:

> 
> * pageexec@freemail.hu <pageexec@freemail.hu> wrote:
> 
> > > A fastpath is defined by optimization considerations applied to a 
> > > codepath (the priority it gets compared to other codepaths), 
> > > *not* by its absolute performance.
> > 
> > we're not talking about random arbitrarily defined paths here but 
> > the impact of putting well predicted branches into the pf handler 
> > vs. int xx (are you perhaps confused by 'fast path' vs. 
> > 'fastpath'?).
> 
> So please educate me, what is the difference between 'fast path' 
> versus 'fastpath', as used by kernel developers, beyond the space?

you seemed to have made a distinction, you tell me ;), i was simply
using it as a generic english phrase.

to give you an idea:
- if a code path executes in 1M or 1K cycles once every hour, then
  it's not a fast path, it doesn't matter to anyone whether it runs
  1 or 10 cycles faster or not,
- if a code path executes in 1M cycles 100 times a second then it's
  still not a fast path where single cycle speedups would mean anything,
- now if a code path executes in 1K cycles 100K times a second then
  suddenly there's a huge multiplier on even single cycle improvements
  that *may* be measurable and therefore relevant for some users

obviously these are just sample points in the parameter space, but
you get the idea (and no, there's no black&white clearly defined
subspace that could be labeled as 'fast path', it's a per-user fuzzy
set).

now for your pf handler. you said the pf handler was a 'fastpath'. you
didn't provide any numbers yet to back that up though so let's take it
at face value. you also said, no scratch that, *boasted* about a single
cycle improvement somewhere in that pf path. problem is that you have
never presented evidence for this claim. what is the reason for this
resistance? you must have measured the impact of your change to be able
to claim your numbers, so you must be able to present them, right? and
you must also be able to show its real life impact because it must have
done wonders to typical userland workloads. so where are the numbers Ingo?
or do you realize but have no balls to admit that your single cycle
'improvement' is simply bloody bullshit that noone cares about let alone
can experience? it's scary that one of the x86 maintainers has nothing
better to do than implement bogus 'optimizations'.

> > that impact only matters if it's measurable. you have yet to show 
> > that it is. and all this sillyness is for a hypothetical situation 
> > since those conditional branches don't even need to be in the 
> > general page fault processing paths.
> 
> Is this some sort of sick joke?

hey lookie, someone found his voice for a change ;). more seriously,
you should probably take reading comprehension lessons:

> Do you *really* claim that the number of instructions executed in a 
> fastpath do not matter

did i say that? let's see what i said, will be very easy as i'll just
have to copy-paste from above:

   that impact only matters if it's measurable.

do you understand the words 'impact' and 'measurable'? do you see the
words 'number' or 'instructions' in there?  do you understand that it's
not the insn count that matters per se but their measurable impact (which
is a function of more than just the insn count)?

> and that our years-long effort to shave off an 
> instruction here and there from the x86 do_page_fault() code were 
> meaningless

if they have no measurable impact then yes, it was all a pointless
exercise. if they do have measurable impact then it depends on what
that impact is and what a given user cares about. there's no black
and white answer, even if you think only in extremes.

> and that we can add branches with zero cost?

see above.

