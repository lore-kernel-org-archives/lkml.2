Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab0FCTuO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 15:50:14 -0400
Received: from smtp-out.google.com ([216.239.44.51]:4699 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366Ab0FCTuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 15:50:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=UGdE1yHDUNkhx3OsQa0tk94XXfA/sij+yhLlZdIhKkEqNj0o6xz1BUmZ6xp8I/Anu
	QWIHX7xz1ta0d7macppPg==
MIME-Version: 1.0
In-Reply-To: <20100603193045.GA7188@elte.hu>
References: <20100603193045.GA7188@elte.hu>
Date: Thu, 3 Jun 2010 12:50:02 -0700
Message-ID: <AANLkTinsOF3wnxsruR0TvjBAQcHks4tf0ay_sM2xB_p4@mail.gmail.com>
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
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 3, 2010 at 12:30 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> Sadly the response from the Android team has been 100% uncompromising: either
> suspend blockers or nothing.

Well, we're willing to accept something that gives us the same
functionality (thus rewriting the api several times to meet various
objections, current discussions around
constraint-based-implementations / pm-qos, etc).  We believe we're
solving a real problem here and have not seen a counter-proposal that
accomplishes the same.

Suggestions such as "just yell at developers for writing bad apps" or
"it's the user's fault if they install a lousy app" or "make your app
marketplace more restrictive" are not helpful.  The technical
discussions around alternatives are more so (though I do feel like
we're going in circles in places), which again is why we're still here
talking about this (that and Arve is about a billion times more
patient and persistent than I am).

We're not interested in massively rearchitecting our userspace to
accomplish this (and the "rewrite your userspace!" proposals I've seen
have had race conditions and/or significant more complexity than the
wakelock model).

...

> Also, why did the Android team start its contributions with such a difficult
> and controversial kernel feature?

We started here because it's possibly the only api level change we
have -- almost everything else is driver or subarch type work or
controversial but entirely self-contained (like the binder, which I
would be shocked to see ever hit mainline).  Assertions have been made
that because the "android kernel" (not a term I like -- linux is
linux, we have some assorted patches on top) has this feature it
represents a difficulty for silicon vendors trying to support both
Android projects and OEMs and mainline:

See: http://www.kroah.com/log/linux/android-kernel-problems.html and
various other rants about the evil terrible android forks, etc.

So, we figure, let's sort out the hard problem first and then move on
with our lives.

> There is absolutely _zero_ technical reason why the Android team should
> present this as as an all-or-nothing effort. Why not merge hw drivers first
> (with suspend blockers commented or stubbed out), to reduce the fork distance?

If that's the case then there is no problem and people could stop
yelling at us and just submit their drivers.  Awesome.

I can't speak for all the nameless silicon vendors Greg represents,
that we apparently are preventing from doing this (how? I don't
know!), etc, but for my team maintaining multiple versions of drivers
is a headache, we'd rather square away the wakelock debate first and
figure something out there, as it just seems like a more logical
approach.  Maybe we're crazy.

> Really, i myself have controversial kernel features pending all the time. They
> dont go upstream for a few kernel releases - over a year sometimes - and
> sometimes they never go upstream.
>
> But the fact that some feature of mine is pending doesnt give me the right to
> go away sulking, it doesnt mean i will block the whole flow of patches in
> retaliation (as you seem to suggest Google will now have the right to do) - i
> simply try to work it out.

We're not blocking anything.  Hell, if people want drivers we wrote
upstream and we're not fast enough for 'em, we publish everything via
android.git.kernel.org, pretty aggressively rebase to follow latest
mainline, and release everything under GPLv2, ready-to-go.  We have to
ship though, and as long as the version we maintain has the features
we need to ship and the mainline version doesn't, we're going to ship
based on our version, but this really shouldn't be surprising to
anyone.

> Lets be reasonable and work it all out, ok?

We're trying.

I do feel like we're suffering from lack of a clear "how do we move
forward" path, and in particular from an environment where every time
we do a bunch of work to address one set of concerns and entirely new
set of people pop up with different concerns (sometimes contradicting
the last round of changes we were asked to make, etc, etc).

Brian
