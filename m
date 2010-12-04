Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719Ab0LDUBV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 15:01:21 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43173 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616Ab0LDUBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 15:01:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=SuXLRmdRuYDDBa0giLDDD3XqpobysLIkFjibYifeAz3+JNIK38itq+zG6TZgD5/Vyk
         g8WLSpltoKw0WMPp+JxtyU6CyYWdR7BcWFUXjHqOckejwpo/aWzAUUH++eO5yJvj4p6t
         PqaLj/KfF/NnLar25s/HEqiarKrKaJLC18xE8=
MIME-Version: 1.0
In-Reply-To: <AANLkTinWQkiadp7NCVt401bFiATJeqTK1g81RcP2awCv@mail.gmail.com>
References: <1289783580.495.58.camel@maggy.simson.net>
	<1289811438.2109.474.camel@laptop>
	<1289820766.16406.45.camel@maggy.simson.net>
	<1289821590.16406.47.camel@maggy.simson.net>
	<20101115125716.GA22422@redhat.com>
	<1289856350.14719.135.camel@maggy.simson.net>
	<20101116130413.GA29368@redhat.com>
	<1289917109.5169.131.camel@maggy.simson.net>
	<20101116150319.GA3475@redhat.com>
	<1289922108.5169.185.camel@maggy.simson.net>
	<20101116172804.GA9930@elte.hu>
	<1290281700.28711.9.camel@maggy.simson.net>
	<AANLkTinz12n9OKkCV8XRF8n1vKytO_aj26i-ytcAhFgN@mail.gmail.com>
	<AANLkTinWQkiadp7NCVt401bFiATJeqTK1g81RcP2awCv@mail.gmail.com>
Date: Sat, 4 Dec 2010 15:01:16 -0500
X-Google-Sender-Auth: pr9lUMJMNs9zzRPMsfFetGYW1_Q
Message-ID: <AANLkTinmgsBQ624habviTTj7khCdZH_p2m5mX24_SV9j@mail.gmail.com>
Subject: Re: [PATCH v4] sched: automated per session task groups
From: Colin Walters <walters@verbum.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 4, 2010 at 1:33 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> But the fundamental issue is that 'nice' is broken. It's very much
> broken at a conceptual and technical design angle (absolute priority
> levels, no fairness), but it's broken also from a psychological and
> practical angle (ie expecting people to manually do extra work is
> ridiculous and totally unrealistic).

I don't see it as ridiculous - for the simple reason that it really
has existed for so long and is documented (see below).

> Why would you want to do that? If you are willing to do group
> scheduling, do it on something sane and meaningful, and something that
> doesn't need user interaction or decisions. And do it on something
> that has more than 20 levels.

In this case, the "user interaction" component is pretty damn small.
We're talking about 4 extra characters.

> Nobody but morons ever "documented" that. Sure, you can find people
> saying it, but you won't be finding people actually _doing_ it. Look
> around.

Look around...where?  On what basis are you making that claim?  I did
a quick web search for "unix background process", and this tutorial
(in the first page of Google search results) aimed at grad students
who use Unix at college definitely describes "nice make":
http://acs.ucsd.edu/info/jobctrl.shtml

There are some that don't, like:
http://linux.about.com/od/itl_guide/a/gdeitl35t01.htm and
http://www.albany.edu/its/quickstarts/qs-common_unix.html

But then again here's a Berkeley "Unix Tutorial" that does cover it:
http://people.ischool.berkeley.edu/~kevin/unix-tutorial/section13.html

So, does your random Linux-using college student or professional
developer know about "nice"?  My guess is "likely".  Do they use it
for "make"?  No data.  The issue is that you really only have a bad
experience on *large* projects.  But if we just said to people who
come to us "Hey, when I compile webkit/linux/mozilla my system slows
down" we can tell them "use nice", especially since it's already
documented on the web, that seems to me like a pretty damn good
answer.

> Seriously. Nobody _ever_ does "nice make", unless they are seriously
> repressed beta-males (eg MIS people who get shouted at when they do
> system maintenance unless they hide in dark corners and don't get
> discovered). It just doesn't happen.

Heh.  Well, I do at least (or rather, my personal automagic build
wrapper script does (it detects Makefile/autotools etc. and tries to
DTRT)).

> But more fundamentally, it's still the wrong thing to do. What nice
> level should you use?

Doesn't matter - if they all got group-scheduled together, then the
default of 10 (0+10) is totally fine.

> Do you want to do "nice git" too? Especially as the reason the
> threaded lstat was implemented was that over NFS, you actually want
> the threads not because you're using lots of CPU, but because you want
> to fire up lots of concurrent network traffic - and you actually want
> low latency. So you do NOT want to mark these threads as
> "unimportant". They're not.

Hmm...how many threads are we talking about here?  If it's just say
one per core, then I doubt it needs nicing.  The reason people nice
make is because the whole thing alternates between being CPU bound and
I/O bound, so you need to start more jobs than cores (sometimes a lot
more) to ensure maximal utilization.

> But what you do want is a basic and automatic fairness. When I do "git
> grep", I want the full resources of the machine to do the grep for me,
> so that I can get the answer in half a second (which is about the
> limit at which point I start getting impatient). That's an _important_
> job for me. It should get all the resources it can, there is
> absolutely no excuse for nicing it down.

Sure...though I imagine for "most" people that's totally I/O bound
(either on ext4 journal or hard disk seeks).

> Now, I'm not saying that cgroups are necessarily the answer either.
> But using sessions as input to group scheduling is certainly _one_
> answer. And it's a hell of a better answer than 'nice' has ever been,
> or will ever be.

Well, the text of Documentation/scheduler/sched-design-CFS.txt
certainly seems to be claiming it was a big improvement in this kind
of situation from the previous scheduler.  If we're finding out there
are cases where it's not, it's definitely worth asking the question
why it's not working.

Speaking of the scheduler documentation - note that its sample shell
code contains exactly the problem showing what's wrong with
auto-grouping-by-tty, which is:

# firefox &	# Launch firefox and move it to "browser" group

As soon as you do that from the same terminal that you're going to
launch the "make" from, you're back to total lossage.  Are you going
to explain to a student that "oh, you need to create a new
gnome-terminal tab and launch firefox from that"?
