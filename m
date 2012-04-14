Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323Ab2DNVWD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 17:22:03 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:37892 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197Ab2DNVWA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 17:22:00 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 14 Apr 2012 23:21:24 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Adrian Chadd <adrian@freebsd.org>, Greg KH <gregkh@linuxfoundation.org>,
        Sergio Correia <lists@uece.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 00/78] 3.3.2-stable review
Message-ID: <20120414232124.1ffd7ac9@stein>
In-Reply-To: <CAMP44s0ngzwkbQapTip=oW1b5m2uO5zCzbXHVqHXwT2+Wpgo_A@mail.gmail.com>
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
	<CAMP44s0ngzwkbQapTip=oW1b5m2uO5zCzbXHVqHXwT2+Wpgo_A@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 14 Felipe Contreras wrote:
> On Sat, Apr 14, 2012 at 8:55 PM, Stefan Richter
> <stefanr@s5r6.in-berlin.de> wrote:
> > Generally, "commit + push out" makes it undroppable.  In case of -stable,
> > commit/ push out/ tag are close and virtually identical.
> >
> > After a change was pushed out, the choice narrows down to add a reverting
> > change for a subsequent release or to rebase to a point before the
> > defective commit.  The latter is not done to -stable, obviously.  (3.3.2
> > is not being restarted from 3.3 if a regression from 3.3 to 3.3.1 was
> > discovered.)
> 
> That's irrelevant; whether you rebase and drop the patch, or you
> revert it, the resulting code is *exactly* the same. It's also the
> same if Greg drops it from his quilt queue before pushing (assuming
> that's what he uses).

The result may be the same (sometimes it actually isn't), but the way to
get there is not.

> Let's avoid this semantic red herring, by undroppable I mean
> unrevertable, or undiscardable, or anything that effectively makes the
> patch not be there.

How do you "make it not be there"?  By adding a reverting patch.

The reverting patch needs to come from somewhere, and the only
disagreement is basically through which channels the patch should be
allowed to come, or which qualifications this reverting patch should
fulfill.

> >> But *why*? You say you *really* need to problem to fixed in mainline,
> >> that's why it cannot be dropped, but that applies also to patches in
> >> the queue *before* the tag is made, doesn't it? If you find a patch in
> >> the stable review queue causes problems, why don't you leave it there?
> >
> > As Willy wrote, that's actually what is done sometimes.  I didn't know
> > that.
> 
> Don't avoid the question.

Willy answered that, hence I didn't think I have to.  The patch can in
fact be kept in the stable queue as a reminder, it just should not be
applied to stable as long as there is no resolution for mainline.

> I don't mean just leave it in the queue, I mean leave it so it gets
> tagged in the release.

That would be even sillier than the discussion which we are having.

> >> You *really* need to problem fixed in mainline, don't you?
> >>
> >> So yesterday the priority is stability > 'upstream first', but today
> >> it's 'upstream first' > stability. Nobody has put forward an argument
> >> for this shift in priorities--
> >
> > Yesterday, folks cared about mainline too.
> 
> Who suggested otherwise? Being priority #2 doesn't mean you don't
> care. We always care about mainline, even for patches that are not
> proposed for 'stable'.
> 
> But if we found yesterday that the patch would break things, it would
> not make it to the stable release.
> 
> You are again avoiding the argument.

The priorities argument is bogus.  The procedure of receiving stable
patches only as backports from mainline is exactly about stabilization,
nothing else.

[...]
> > if a defective change was not dropped but released, and now requires
> > a fix (e.g. revert) "today:  There are now /two/ bugs:  In the mainline
> > and in a stable kernel.
> 
> What?! So, if an issue has been in the kernel for the last 10 years,
> and it's just fixed, that means we suddenly have hundreds of bugs?

You would have fixed hundreds of bugs if you released fixes into hundreds
of kernel branches.

> You are playing with words; it's *one* bug that is present in multiple releases.

Count it as a single bug if you prefer.  The fact is, the bugs or bug
needs fixes in each affected maintained kernel branch.  So even if you
count one bug, there are still more than one bug resolutions to be done.

> e) if it gets into Greg's stable queue; it's still *one* bug
> f) and if it gets into v3.4.1; it's still *one* bug.
[...]
> By saying it's "two bugs", you are still avoiding the question of why
> they are different. *Why* are they two bugs? What is so different
> between e) and f)

e) requires a fix to be published in the mainline.  f) requires a fix to
be published in the mainline and another fix to be published in stable.

> that makes bad patches undroppable?

f) makes stable require a reverting patch.

> I appreciate you are exploring this discussion, but I wonder if you
> accept the possibility that there's actually no good reason for this
> change in priorities, or if you accept that even a change in
> priorities is taking place.

Stabilization is the only priority.  There is nothing else.

I stated one reason for the procedure in case of f):

Fixing mainline first and then backporting to stable is always easier and
safer than fixing stable first and only then start to think about how
mainline can be fixed.  I and others also explained a bit more why it is
easier and safer.

I realise that this is not a good enough reason in your opinion, at least
as far as revert-type fixes are concerned.  Some of the folks who are
unfortunate enough to be Cc'd on this discussion have quite a bit of
experience with varying kernel maintenance models though, so I find their
opinions in these matters well worth thinking about.
-- 
Stefan Richter
-=====-===-- -=-- -===-
http://arcgraph.de/sr/
