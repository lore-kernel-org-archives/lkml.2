Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab0LDWkh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 17:40:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39863 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754605Ab0LDWkg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 17:40:36 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTinmgsBQ624habviTTj7khCdZH_p2m5mX24_SV9j@mail.gmail.com>
References: <1289783580.495.58.camel@maggy.simson.net> <1289811438.2109.474.camel@laptop>
 <1289820766.16406.45.camel@maggy.simson.net> <1289821590.16406.47.camel@maggy.simson.net>
 <20101115125716.GA22422@redhat.com> <1289856350.14719.135.camel@maggy.simson.net>
 <20101116130413.GA29368@redhat.com> <1289917109.5169.131.camel@maggy.simson.net>
 <20101116150319.GA3475@redhat.com> <1289922108.5169.185.camel@maggy.simson.net>
 <20101116172804.GA9930@elte.hu> <1290281700.28711.9.camel@maggy.simson.net>
 <AANLkTinz12n9OKkCV8XRF8n1vKytO_aj26i-ytcAhFgN@mail.gmail.com>
 <AANLkTinWQkiadp7NCVt401bFiATJeqTK1g81RcP2awCv@mail.gmail.com> <AANLkTinmgsBQ624habviTTj7khCdZH_p2m5mX24_SV9j@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 4 Dec 2010 14:39:40 -0800
Message-ID: <AANLkTikFXv042qg4uzXF--9_co6-b_UgJF7Jeo2bVA=f@mail.gmail.com>
Subject: Re: [PATCH v4] sched: automated per session task groups
To: Colin Walters <walters@verbum.org>
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 4, 2010 at 12:01 PM, Colin Walters <walters@verbum.org> wrote:
>
> But then again here's a Berkeley "Unix Tutorial" that does cover it:
> http://people.ischool.berkeley.edu/~kevin/unix-tutorial/section13.html

What part of "nobody does that" didn't you understand?

I know about "nice". I think it was part of the original Unix course I
ever took, and it probably made more sense back then (sixteen people
at a time on a microvax, compiling stuff). And I never used it, afaik.
Nor does really anybody else.

But hey, whatever floats your boat. You can use it. And you can feel
special and better than the rest of us exactly because you know you
really _are_ special.

> Hmm...how many threads are we talking about here?  If it's just say
> one per core, then I doubt it needs nicing.

I think git defaults to a maximum of 20 for it. Remember: it's not
about "cores". It's about IO, and then 20 is a "let's not mess up
everybody else _too_ much when we're actually CPU-bound".

But that's not the point. The point is that "nice" is totally the
wrong thing to do. It's _always_ the wrong thing to do. The only
reason it's in tutorials and taught in intro Unix classes is that it's
the only thing there is in traditional unix.

And we can be better. We don't need to be stupid and traditional.

But you go right on and use it. Nobody stops you.

> Sure...though I imagine for "most" people that's totally I/O bound
> (either on ext4 journal or hard disk seeks).

Sure. And "most" people do something totally different. What's your
point? The fact is, the session-based group scheduling really does
work. It works on a lot of different loads. It's nice for things like
my use, but it's _also_ nice for things like me ssh'ing into my kids
or wife's computers to update their kernel. And it's nice for things
like "make -j test" for git etc.

And it doesn't hurt you. If you're happy with "nice", go on and use
it. Why are you even discussing it? I'm telling you the FACT that
others aren't happy with nice, and that smart people consider nice to
be totally useless.

But none of that means that you can't go on using it. Comprende?

> # firefox &     # Launch firefox and move it to "browser" group
>
> As soon as you do that from the same terminal that you're going to
> launch the "make" from, you're back to total lossage.

"Mommy mommy, it hurts when I stick forks in my eyes!"

What's your point again? It's a heuristic. It works great for the
cases many normal people have. If you have a graphical desktop, most
sane people would tend to start the browser from that nice big browser
icon. But again, if you want to stick forks in your eyes, go right
ahead. It's not _my_ problem.

And similarly, it's not _your_ problem if other people want to do
saner things, is it?

                    Linus
