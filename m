Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044Ab0LEWrw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 17:47:52 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51892 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288Ab0LEWrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 17:47:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=dagEf0YKCQHWh4R963OWfOIdyYLO6YMkAIatQopjo7RTYVqP9+fc3N8JevorWwIxN8
         +NJahkQVFK5plSujJcRUgtxJdYlORoMo9lxZTWfpn30Zu9nRACmtkjFb3SkDEz1w/aMS
         GSA2xYKkltKC3H5Bl2y8rXnNelX4+aAYV7OfM=
MIME-Version: 1.0
In-Reply-To: <AANLkTinOQ5sWigfW844dSBc2PvVwFj5c7yu+scNXxMcv@mail.gmail.com>
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
	<AANLkTinmgsBQ624habviTTj7khCdZH_p2m5mX24_SV9j@mail.gmail.com>
	<AANLkTikFXv042qg4uzXF--9_co6-b_UgJF7Jeo2bVA=f@mail.gmail.com>
	<AANLkTikrc+_r1KE477c-NeD-9PWDOXx1ExHGm08Lm6wM@mail.gmail.com>
	<AANLkTiniEUdADMHUE1a9Fs1bGsWn6F6yeJX_NO4L94JK@mail.gmail.com>
	<AANLkTi=7FRCK9R2PVCTdtSqKo9FZemD5cXQTFoOKLEFB@mail.gmail.com>
	<AANLkTinOQ5sWigfW844dSBc2PvVwFj5c7yu+scNXxMcv@mail.gmail.com>
Date: Sun, 5 Dec 2010 17:47:49 -0500
X-Google-Sender-Auth: 9Cn6esnkU5sIh0VM38WFRvlDuCc
Message-ID: <AANLkTi=jN83+w8AC8bOMtmqmgp3SLpTvtfoAYE9nR=H0@mail.gmail.com>
Subject: Re: [PATCH v4] sched: automated per session task groups
From: Colin Walters <walters@verbum.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ray Lee <ray-lk@madrabbit.org>, Mike Galbraith <efault@gmx.de>,
        Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 5, 2010 at 3:47 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> The semantics of "nice" are not - and have never been - to put things
> into process scheduling groups of their own.

Again, I obviously understand that - the point is to explore the space
of changes here and consider what would (and wouldn't) break.  And
actually, what would improve.

> This is very much documented. People rely on it.

Well, we established my Fedora 14 system doesn't.  You said "no one"
uses "nice" interactively.  So...that leaves - who?  If you were
saying to me something like "I know Yahoo has some code in their data
centers which uses a range of nice values; if we made this change, all
of a sudden they'd get more CPU contention..."  Or like, "I'm pretty
sure Maemo uses very low nice values for some UI code".  But you so
far haven't really done that, it's just been (mostly)
assertions/handwaving.  Now you obviously have a lot more experience
that gives those assertions and handwaving a lot of credibility - but
all we need is one concrete example to shut me up =)

Playing around with Google code search a bit, hits for "nice" were
almost all duplicates of various C library headers/implementations.
"setpriority" was a bit more interesting, it appears Chromium has some
code to bump up the nice value by 5 for "background" processes:

http://google.com/codesearch/p?hl=en#OAMlx_jo-ck/src/base/process_linux.cc&q=setpriority&exact_package=chromium&l=21

But all my Chrome related processes here are 0, so who knows what
that's used for.   There are also hits for chromium's copy of embedded
cygwin+perl...terrifying.  I assume (hope, desperately) that
Cygwin+Perl is just used for building...

Another hit here in some random X screensaver code:
http://google.com/codesearch/p?hl=en#tJJawb1IJ20/driver/exec.c&q=setpriority%20file:.*.c&l=218

But I can't find a place where it's setting a non-zero value for that.

So...ah, here's one in Android's "development" git:
http://google.com/codesearch/p?hl=en#CRBM04-7BoA/simulator/wrapsim/Init.c&q=setpriority%20file:.*.c&l=91

Except it appears to be unused =/

Oh!  Here we go, one in the Android UI code:
http://google.com/codesearch/p?hl=en#uX1GffpyOZk/libs/rs/rsContext.cpp&q=setpriority%20file:.*.c&sa=N&cd=29&ct=rc
Pasting this one so people don't have to follow the link:

void * Context::threadProc(void *vrsc)
{
  ...
  setpriority(PRIO_PROCESS, rsc->mNativeThreadId, ANDROID_PRIORITY_DISPLAY);

}

Where ANDROID_PRIORITY_DISPLAY = -4.  Actually the whole enum is interesting:
http://google.com/codesearch/p?hl=en#uX1GffpyOZk/include/utils/threads.h&q=ANDROID_PRIORITY_DISPLAY&l=39

One interesting bit here is that they renice UI that the user is
presently interacting with:

    /* threads currently running a UI that the user is interacting with */
    ANDROID_PRIORITY_FOREGROUND     =  -2,

(Something "we" (and by "we" I mean GNOME) don't do, I believe Windows
does though).  Though, honestly I could whip up a
gnome-settings-daemon plugin to do this in about 10 minutes.  Maybe
after dinner.

So...we've established that important released operating systems do
use negative nice values (not surprising). I can't offhand find any
uses of e.g. ANDROID_PRIORITY_BACKGROUND (i.e. a positive nice value)
in the "base" sources though.

> Different nice levels shouldn't get group scheduled together - they
> should be scheduled *less*.

But it seems obvious (right?) that putting them in one group *will*
ensure they get scheduled less, since that one group has to contend
with all other processes.

> And it's not about "make", since nobody
> really ever uses nice on make anyway, it's about things like
> pulseaudio (that wants higher priorities)

Note that pulse is actually using the RT scheduling class, so (I
think) its actual nice value is irrelevant.

Again using F14, the only things using negative nice besides pulse is
udev and auditd.

> Not very much (because they are mostly useless), but there really are
> people who use it.

Still trying to extract specific examples of "people who use it" from you...

> Do you *really* think that the person who niced the filesystem indexer
> down wants the indexer to get 50% of the CPU, just because it's
> scheduled separately from the parallel make?

Finally, an example!  I can work with this.  So let's assume I'm using
some JavaScript-intensive website in Firefox in GNOME, and
tracker-miner-fs kicks in after noticing I just saved a Word document
I want to look at later.  And an otherwise idle system.  You're
suggesting that, now tracker-miner-fs would be using a lot more CPU if
it was in an empty group than it would have before?

That does seem likely to be true.  But would it be a *problem*?  I
don't know, it's not obvious to me offhand.  Especially on any
hardware that's dual-core, where SpiderMonkey can be burning one core
(since that's all it will use, modulo Web Workers), and tracker on
another.

Anyways, I don't have the kernel-fu to make a patch myself here,
especially since the scheduler is probably one of the hardest parts of
the OS.  So ultimately I guess, if you just totally disagree, fine.
But I wasn't satisfied with the response - my engineering intuition is
to work through problems and try to really understand what would be
wrong.  It's hard to accept "just trust me, that's stupid".
