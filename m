Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207Ab1FFWvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:51:31 -0400
Received: from r00tworld.com ([212.85.137.150]:51313 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757443Ab1FFWv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:51:29 -0400
From: pageexec@freemail.hu
To: Ingo Molnar <mingo@elte.hu>
Date: Tue, 07 Jun 2011 00:49:41 +0200
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
Message-ID: <4DED5985.542.14A05486@pageexec.freemail.hu>
In-reply-to: <20110606164700.GA2391@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>, <4DECFE18.23229.133B32ED@pageexec.freemail.hu>, <20110606164700.GA2391@elte.hu>
X-mailer: Pegasus Mail for Windows (4.61)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Tue, 07 Jun 2011 00:50:15 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 Jun 2011 at 18:47, Ingo Molnar wrote:

> * pageexec@freemail.hu <pageexec@freemail.hu> wrote:
> 
> > uhm, not sure why you're so worked up here. is it because i said
> > 'scalability' was completely irrelevant for the nx vsyscall page
> > approach? elaborate!
> 
> Firstly, 'fast' is a necessary first step towards good scalability, 
> secondly i was talking about *both* speed and scalability so your 
> insistence to only discuss speed is banging on open doors ...

uhm, why the heck do you keep bringing this up? what does it matter?
i talk about whatever i find relevant, and your scalability fetish
has no business with the vsyscall thing we're talking about here.
if you think it does, then you still haven't explained it.

> You are simply wrong about:
> 
> > > > sorry, but stating that the pf handler is a fast path doesn't 
> > > > make it so ;).
> 
> and 5-6 mails down the line you are still unwilling to admit it. Why?

why are you cutting out in all those mails of yours what i already told
you many times? the original statement from Andy was about the int cc path
vs. the pf path: he said that the latter would not tolerate a few well
predicted branches (if they were put there at all, that is) because the
pf handler is such a critical fast path code. it is *not*. it can't be
by almost definition given how much processing it has to do (it is by
far one of the most complex of cpu exceptions to process).

it seems to me that you're unwilling to admit that you tried to pick on
the wrong thing, probably in the heat of the discussion and now you try
to insist to save face or something. if you really want to get out of this
then please, go do the measurements i asked you and you'll see yourself.

> A fastpath is defined by optimization considerations applied to a 
> codepath (the priority it gets compared to other codepaths), *not* by 
> its absolute performance.

we're not talking about random arbitrarily defined paths here but the
impact of putting well predicted branches into the pf handler vs. int xx
(are you perhaps confused by 'fast path' vs. 'fastpath'?).

that impact only matters if it's measurable. you have yet to show that it
is. and all this sillyness is for a hypothetical situation since those
conditional branches don't even need to be in the general page fault
processing paths.

> You seem to be confused on several levels here.

you're talking about something else, probably because it's you who's
very confused about this whole fast path business. kinda surprising
given how much time you supposedly spent on this topic in the past.

