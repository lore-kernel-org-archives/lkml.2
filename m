Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab0FDIaK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 04:30:10 -0400
Received: from smtp-out.google.com ([74.125.121.35]:32468 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab0FDIaF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 04:30:05 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=dbnbzWCd2B7bECjthgrX1CPUHgWFbwYm6Kev8DWIhiOczv4u5ab4Bm3jXdgWHwY0/
	rbqY4PvPi5/cHJMYtCjUg==
MIME-Version: 1.0
In-Reply-To: <20100604075722.GA15181@elte.hu>
References: <20100603193045.GA7188@elte.hu>
	<AANLkTinsOF3wnxsruR0TvjBAQcHks4tf0ay_sM2xB_p4@mail.gmail.com>
	<20100604075722.GA15181@elte.hu>
Date: Fri, 4 Jun 2010 01:29:56 -0700
Message-ID: <AANLkTiksGnpL8tkcc5eScWHrGoijyZNUwZik5lXmU_TS@mail.gmail.com>
Subject: Re: suspend blockers & Android integration
From: Brian Swetland <swetland@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: tytso@mit.edu, Neil Brown <neilb@suse.de>,
       "Arve Hj?nnev?g" <arve@android.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 4, 2010 at 12:57 AM, Ingo Molnar <mingo@elte.hu> wrote:
> * Brian Swetland <swetland@google.com> wrote:
>>
>> We started here because it's possibly the only api level change we have --
>> almost everything else is driver or subarch type work or controversial but
>> entirely self-contained (like the binder, which I would be shocked to see
>> ever hit mainline). [...]
>
> So why arent those bits mainline? It's a 1000 times easier to get drivers and
> small improvements and non-ABI changes upstream.
>
> After basically two years of growing your fork (and some attempts to get your
> drivers into drivers/staging/ - from where they have meanwhile dropped out
> again) you re-started with the worst possible thing to merge: a big and
> difficult kernel feature affecting many subsystems. Why?

Because a large number of our drivers depend on it.

> This is one of the fundamental problems here. People simply dont know you,
> because you have not worked with us much - and hence they dont trust you
> positively out of box - they are neutral at best.
>
> And believe me, it's hard enough to get difficult features upstream if people
> _do_ know you and when they positively _do_ trust you ... Arent you talking to
> Andrew Morton about how to do these things properly? This is kernel
> contribution 101 really.
>
>> [...]  Assertions have been made that because the "android kernel" (not a
>> term I like -- linux is linux, we have some assorted patches on top) [...]
>
> I've been tracking android-common and android-msm for a while and i have to
> say that it shows a very lackluster attitude towards upstream:
>
>  - The latest branches i can see are v2.6.32 based today. We are in the
>   v2.6.35 stabilization cycle and are developing v2.6.36. I.e. your upstream
>   base is about a year too old.

We have some branch naming confusion and work going on in
experimental, but our active work right now is against 2.6.34 and
2.6.35-rc.  The tegra2 work has been very aggressively following
mainline (rebasing against 2.6.34rc as they were getting underway),
and we've been sending those patches out for review, in hopes of
getting that tree off on a better foot.

>
>  - The last commit is a couple of weeks old AFAICS.
>
>  - The diffstat of android-common/android-2.6.32 is:
>
>      890 files changed, 39962 insertions(+), 6286 deletions(-)
>
>   Those assorted patches have spread over nearly a thousand files. FYI, by
>   the looks of it you are facing an exponentially worsening maintenance
>   overhead curve here.
>
> Is there perhaps some other tree i should be following? I'm looking at:
>
>  [remote "android-msm"]
>         url = git://android.git.kernel.org/kernel/msm.git
>         fetch = +refs/heads/*:refs/remotes/android-msm/*
>  [remote "android-common"]
>         url = git://android.git.kernel.org/kernel/common.git
>         fetch = +refs/heads/*:refs/remotes/android-common/*
>
> Btw., the commits i've glanced at looked mostly clean and well structured, so
> i see no fundamental reason why this couldn't be done better.

I think the fundamental issue we keep bumping into is the turnaround
time on patch review / inclusion (again we're trying to get things
going much earlier on tegra2 to hopefully have less pain there).  We
aim for kernel style compliance (though we're not perfect and we make
our share of mistakes), but previously when I tried sending mach-msm
stuff out, it seemed infeasible to send 30-60+ patches, so we'd start
with 5-10, feedback would trickle in over the course of a week, I'd
respin, etc.  After a couple weeks some stuff would get picked up
toward a merge window but the rest would have to wait.  And then we
hit crunch to ship, etc, and get behind.

Totally our fault that we're not just constantly pushing patches (and
we're trying to get a fulltime engineer or two just to work on
upstream related stuff), but we rapidly hit the point where what we're
sending up is a drop in the bucket compared to the work we're doing
and things keep diverging, etc.

I'm told this happens to everyone, is common, etc.  We're (seriously)
a small team, trying to ship multiple products a year and keep our
head above water here, and unfortunately that means we keep tabling
these projects until we can find some cycles to give it another go and
the delta grows.

>> So, we figure, let's sort out the hard problem first and then move on with
>> our lives.
>
> Well, my suggestion would be to first build up a path towards upstream, build
> up trust, reduce your very high cross section to mainline - and do the most
> difficult bits last.

Having to maintain two versions of about half our driver code because
we depend on an ABI not in mainline is a significant factor for us --
it's difficult to have what's going upstream lag behind our active
work (basically we have to maintain two different trees -- one for
mainline one for ship) already, but having these codelines also be
different makes it worse for us.

> Especially 'move on with our lives' suggests that you just want to get rid of
> this ABI divergence and continue-as-usual with the pattern of non-cooperation,
> hm?

I'd like to make some forward progress either to get something
wakelock-ish in and shift to whatever that api is, or to get a clear
"no not going to happen" and deal with the fallout there.

...

Sadly, for mach-msm, we're now further out due to maintainership
shifts (Daniel stepped up to do msm stuff, is pushing up some hybrid
of our work and Qualcomm's work that doesn't seem to really fit with
either, and I have no idea how to sanely get our stuff to sit on top
of that).  I'd love to find some time to sit down, clean up the whole
msm tree for 8x50/7x30 which is (largely) pretty clean, and is
extremely stable and shippable, and try to get it into a patch series
and headed upstream, but we're now colliding with the upstream
mach-msm which has gone off in a different direction, etc.

Anyway, we continue to try to figure out how to make stuff work better
(again, trying some different approaches with tegra2), but so far the
process of getting code upstream has been extremely time intensive and
rather frustrating and it remains unclear who can sign off on what and
how many hoops different people will keep asking us to jump through.

Brian
