Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab2LBHe2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 02:34:28 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:34392 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750991Ab2LBHe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 02:34:27 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+KoWN8FBOKxZNpzAnJ6QSTn32+ID1CpKRFjrLWQ8
	G6lvYFbFobftpK
Message-ID: <1354433662.7048.14.camel@marge.simpson.net>
Subject: Re: [RFC GIT PULL] scheduler fix for autogroups
From: Mike Galbraith <efault@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Sun, 02 Dec 2012 08:34:22 +0100
In-Reply-To: <CA+55aFwp7ZNN5s1vhY9M2VwtjCEien=_iVfCeE1khqH4KY7prw@mail.gmail.com>
References: <20121201111609.GA18679@gmail.com>
	 <CA+55aFx_yJbonbEC5AYteyNv+qWbG-H=yj_=YaiJHwKyu4FH3Q@mail.gmail.com>
	 <20121201214438.GA6544@gmail.com>
	 <CA+55aFwp7ZNN5s1vhY9M2VwtjCEien=_iVfCeE1khqH4KY7prw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-12-01 at 14:03 -0800, Linus Torvalds wrote: 
> On Sat, Dec 1, 2012 at 1:44 PM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > You are not missing anything. That flag is my fault not Mike's:
> > I booted the initial version of that patch but was unsure
> > whether autogroups was enabled - it's a pretty transparent
> > feature. So I figured that having that flag (but readonly) would
> > give us this information definitely.
> 
> So what's the advantage of it being read-only at all?
> 
> Since the flag is clearly *used*, make it read-write, and then all my
> objections go away (except for a slight worry that the dropping of
> /proc/<pid>/autogroup_nice or whatever it is could break some odd
> system app, but I don't worry *too* much about that).
> 
> Disabling autogroup is clearly something people might want, since the
> code tests for it. So removing the flag entirely seems wrong too. But
> if it exists, it should be writable. No?

No, because turning autogroup off at runtime is what now makes boom.

With Peter's race fix in place, lazy movement (was noop on UP) is gone,
mandating that you either walk the box, moving all tasks when you flick
the switch, or you remove the ability to flick the switch other than
'off' at boot time.  You didn't like the original instant on/off switch,
and I didn't like the thought of making autogroup bigger to fix the
explosion either, so went for rip the switch and problematic /proc stuff
that really should have never existed in the first place out option.

-Mike

