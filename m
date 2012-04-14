Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab2DNTVS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 15:21:18 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44283 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885Ab2DNTVP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 15:21:15 -0400
MIME-Version: 1.0
In-Reply-To: <20120414195559.3d5ab944@stein>
References: <20120411231102.GA6404@kroah.com>
	<CAJyhjX2KrfSJW64PJMTHou9zSojsfA1iNT-WahinfMBce_B=BA@mail.gmail.com>
	<20120412002927.GA23167@kroah.com>
	<CAMP44s3Jh-t07A+i82qbAMQyEN0oWTmKk5BJcst942gFdD0=VA@mail.gmail.com>
	<20120412011313.GA23764@kroah.com>
	<CAMP44s2q+bQE3-zsX4bs=sQDt4jf8eE5bwZ8V88UjodjRyAjog@mail.gmail.com>
	<20120412144626.GA14868@kroah.com>
	<CAMP44s1T4EVwpzDuV_vV0Zh-5WcPCwdw9eeOfL17Geqp_UFN-Q@mail.gmail.com>
	<CAJ-VmonhwvnXPKa=LNOR4W0ZTXZqWmzw4UrsKLoE0YN_Bu0FzQ@mail.gmail.com>
	<CAMP44s2JPvhEB6Eb049Z_bToAFncHKMEheuyaxyhC=bnh2GJVg@mail.gmail.com>
	<20120413105746.10ffb120@stein>
	<CAMP44s0RohH9tPiM5qCDT57XBV=iO66PZkSjYVxA6Usg1qJPtw@mail.gmail.com>
	<20120413154216.476a02ac@stein>
	<CAMP44s10KVwL5pY=Q5hWfyUtU6CvvZZ4Bcg-fEY9dAhSL306aQ@mail.gmail.com>
	<20120414094137.54a7f213@stein>
	<CAMP44s2Un-M2OCmuRQGpGsHR21gH=S7oJKx4Ci8tvYVCCSitUw@mail.gmail.com>
	<20120414195559.3d5ab944@stein>
Date: Sat, 14 Apr 2012 22:21:13 +0300
Message-ID: <CAMP44s0ngzwkbQapTip=oW1b5m2uO5zCzbXHVqHXwT2+Wpgo_A@mail.gmail.com>
Subject: Re: [ 00/78] 3.3.2-stable review
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Adrian Chadd <adrian@freebsd.org>, Greg KH <gregkh@linuxfoundation.org>,
        Sergio Correia <lists@uece.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2012 at 8:55 PM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> On Apr 14 Felipe Contreras wrote:
>> On Sat, Apr 14, 2012 at 10:41 AM, Stefan Richter
>> <stefanr@s5r6.in-berlin.de> wrote:
>> > On Apr 14 Felipe Contreras wrote:
>> >> I already exemplified how they are very different, but here it goes
>> >> again. The patch "drm/i915: Add lock on drm_helper_resume_force_mode"
>> >> was just tagged in 3.3.2, if I had said yesterday "this patch breaks
>> >> things on my machine", then that patch would have been dropped for
>> >> 3.3.2 even though it's still on mainline--why? Because we know it's
>> >> broken, and broken patches are not supposed to land to stable. But
>> >> today, one day later, we have to wait until it's fixed in master
>> >> first. Why?
>> >>
>> >> What makes a patch droppable yesterday, but dependent on mainline today?
>> >
>> > Huh?
>> >
>> > Because "yesterday" was a review before stable release:
>> >  - A buggy mainline release exists.
>> >  - No buggy stable release exists.
>> > whereas "today" is after stable release:
>> >  - A buggy mainline release exists.
>> >  - A buggy stable release exists.
>>
>> IOW; a tag makes undroppable.
>
> Generally, "commit + push out" makes it undroppable.  In case of -stable,
> commit/ push out/ tag are close and virtually identical.
>
> After a change was pushed out, the choice narrows down to add a reverting
> change for a subsequent release or to rebase to a point before the
> defective commit.  The latter is not done to -stable, obviously.  (3.3.2
> is not being restarted from 3.3 if a regression from 3.3 to 3.3.1 was
> discovered.)

That's irrelevant; whether you rebase and drop the patch, or you
revert it, the resulting code is *exactly* the same. It's also the
same if Greg drops it from his quilt queue before pushing (assuming
that's what he uses).

Let's avoid this semantic red herring, by undroppable I mean
unrevertable, or undiscardable, or anything that effectively makes the
patch not be there.

>> But *why*? You say you *really* need to problem to fixed in mainline,
>> that's why it cannot be dropped, but that applies also to patches in
>> the queue *before* the tag is made, doesn't it? If you find a patch in
>> the stable review queue causes problems, why don't you leave it there?
>
> As Willy wrote, that's actually what is done sometimes.  I didn't know
> that.

Don't avoid the question.

I don't mean just leave it in the queue, I mean leave it so it gets
tagged in the release.

>> You *really* need to problem fixed in mainline, don't you?
>>
>> So yesterday the priority is stability > 'upstream first', but today
>> it's 'upstream first' > stability. Nobody has put forward an argument
>> for this shift in priorities--
>
> Yesterday, folks cared about mainline too.

Who suggested otherwise? Being priority #2 doesn't mean you don't
care. We always care about mainline, even for patches that are not
proposed for 'stable'.

But if we found yesterday that the patch would break things, it would
not make it to the stable release.

You are again avoiding the argument.

>> "a tag was made" is not argument.
>
> "A faulty commit was pushed out" means that a defective release was made
> and a fix needs to be created and released.  This is obviously something
> different from rejecting to commit a submitted change after negative
> review.
>
> Sure, negative review of a stable submission consequently means that
> mainline needs to be checked whether it requires a fix, and if yes, stable
> users will be interested in getting that fix really into the mainline
> rather sooner than later.  So suddenly they have to track a mainline bug.
> Still /one/ bug though.

Yes.

> So that is when a stable submission was dropped "yesterday".  Now what
> about if a defective change was not dropped but released, and now requires
> a fix (e.g. revert) "today:  There are now /two/ bugs:  In the mainline
> and in a stable kernel.

What?! So, if an issue has been in the kernel for the last 10 years,
and it's just fixed, that means we suddenly have hundreds of bugs?

You are playing with words; it's *one* bug that is present in multiple releases.

a) if there's a bug in an internal tree, say linux-nokia; it's sill *one* bug
b) if the bug gets propagated to linux-omap; it's still *one* bug
c) if the bug gets into Linus's 'master' branch (before a tag); it's
still *one* bug
d) if it gets tagged into v3.5-rc1; it's still *one* bug
e) if it gets into Greg's stable queue; it's still *one* bug
f) and if it gets into v3.4.1; it's still *one* bug.

This is an unseasoned assertion, and the rest of your comments assume
it is true, so I'm not going to reply to them.

By saying it's "two bugs", you are still avoiding the question of why
they are different. *Why* are they two bugs? What is so different
between e) and f) that makes bad patches undroppable?

I appreciate you are exploring this discussion, but I wonder if you
accept the possibility that there's actually no good reason for this
change in priorities, or if you accept that even a change in
priorities is taking place.

Cheers.

-- 
Felipe Contreras
