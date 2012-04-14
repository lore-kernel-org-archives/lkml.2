Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab2DNR47 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 13:56:59 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:36299 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab2DNR4r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 13:56:47 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 14 Apr 2012 19:55:59 +0200
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
Message-ID: <20120414195559.3d5ab944@stein>
In-Reply-To: <CAMP44s2Un-M2OCmuRQGpGsHR21gH=S7oJKx4Ci8tvYVCCSitUw@mail.gmail.com>
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
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 14 Felipe Contreras wrote:
> On Sat, Apr 14, 2012 at 10:41 AM, Stefan Richter
> <stefanr@s5r6.in-berlin.de> wrote:
> > On Apr 14 Felipe Contreras wrote:
> >> I already exemplified how they are very different, but here it goes
> >> again. The patch "drm/i915: Add lock on drm_helper_resume_force_mode"
> >> was just tagged in 3.3.2, if I had said yesterday "this patch breaks
> >> things on my machine", then that patch would have been dropped for
> >> 3.3.2 even though it's still on mainline--why? Because we know it's
> >> broken, and broken patches are not supposed to land to stable. But
> >> today, one day later, we have to wait until it's fixed in master
> >> first. Why?
> >>
> >> What makes a patch droppable yesterday, but dependent on mainline today?
> >
> > Huh?
> >
> > Because "yesterday" was a review before stable release:
> >  - A buggy mainline release exists.
> >  - No buggy stable release exists.
> > whereas "today" is after stable release:
> >  - A buggy mainline release exists.
> >  - A buggy stable release exists.
> 
> IOW; a tag makes undroppable.

Generally, "commit + push out" makes it undroppable.  In case of -stable,
commit/ push out/ tag are close and virtually identical.

After a change was pushed out, the choice narrows down to add a reverting
change for a subsequent release or to rebase to a point before the
defective commit.  The latter is not done to -stable, obviously.  (3.3.2
is not being restarted from 3.3 if a regression from 3.3 to 3.3.1 was
discovered.)

> But *why*? You say you *really* need to problem to fixed in mainline,
> that's why it cannot be dropped, but that applies also to patches in
> the queue *before* the tag is made, doesn't it? If you find a patch in
> the stable review queue causes problems, why don't you leave it there?

As Willy wrote, that's actually what is done sometimes.  I didn't know
that.

> You *really* need to problem fixed in mainline, don't you?
> 
> So yesterday the priority is stability > 'upstream first', but today
> it's 'upstream first' > stability. Nobody has put forward an argument
> for this shift in priorities--

Yesterday, folks cared about mainline too.

> "a tag was made" is not argument.

"A faulty commit was pushed out" means that a defective release was made
and a fix needs to be created and released.  This is obviously something
different from rejecting to commit a submitted change after negative
review.

Sure, negative review of a stable submission consequently means that
mainline needs to be checked whether it requires a fix, and if yes, stable
users will be interested in getting that fix really into the mainline
rather sooner than later.  So suddenly they have to track a mainline bug.
Still /one/ bug though.

So that is when a stable submission was dropped "yesterday".  Now what
about if a defective change was not dropped but released, and now requires
a fix (e.g. revert) "today:  There are now /two/ bugs:  In the mainline
and in a stable kernel.

If you could convince stable to fix their bug before mainline does, then
you would have to track that other mainline bug too.  (You don't wan the
next branch point for stable to be faulty.)  Plus, either the fix from
stable needs to be forward-ported to mainline, or worse, two independent
fixes need to be developed.

What is actually done is simpler and less error prone:
  - Develop a fix for mainline.
  - Mark that fix Cc: stable.
  - Have that fix backported into stable.

[...]
> > "Drop a stable candidate before release" is a form of "decline a
> > submission to stable", happening late in the preparations of a stable
> > release.
> >
> > The latter is when damage was done; it is now about bug fixing.  This
> > involves debugging of the regression, finding a right approach to
> > fix it (e.g. revert), write + review + test + commit the fix, port the fix
> > to all relevant other kernel branches, review + test + commit those ports
> > too.
> 
> Really? So if the patch doesn't make it to stable you don't need to do
> any of that?

If the bug dosn't go into stable, you don't have to track and fix two
bugs.  You still have to track and fix a bug, but it is only one bug
instead of two.

> IOW; if the patch doesn't make it to stable, it's OK to
> leave it broken for v3.4? There's 10000 patches in v3.4-rc* that are
> all about bug fixing, they don't need to go into stable to be fixed,
> do they? If a non-stable patch needs to be reverted in mainline, it
> gets reverted in mainline, regardless of weather or not it made it to
> stable or not.
> 
> So, the hypothetical patch that was dropped in the stable review queue
> yesterday has to be fixed in mainline too,

I count one bug.

> just like the hypothetical
> patch that made it to stable and was found problematic today has to be
> fixed in mainline.

I count two bugs.

> Again, what makes a released patch undroppable? It's not the bug
> fixing; weather or not it gets into stable, it still has to be fixed
> in mainline.

If it is released, you can't drop, only revert or rebase to an older
origin.  (Well, to rebase onto older origin actually means to drop, though
not just that one commit but also all its successors.)

[...]
> Seems to me you are abusing the 'stable' branch as a bug tracking
> system for certain patches for the next release.

There is no abuse.

If a regression happens in stable, you always need to figure out whether
this is only a problem in stable or also in mainline (because mainline
will become the origin of a new stable series eventually, and the problem
should not reappear int the new stable series).  If the problem is only a
stable problem, just fix it in stable.  If it is also a mainline problem,
you want to have it fixed both in stable and in mainline (because their
mainline will become your stable in a new series).

Now there are three choices:
  - Develop a mainline fix, backport it to stable.
  - Develop a stable fix, forward-port it to mainline.
  - Develop the two fixes independently.

A variation of the second and third choice:  Develop a stable fix, leave
mainline unfixed for now, forward-port the stable fix from 3.M.y to 3.N.y,
until mainline is receiving the forward-port too or got an independently
developed fix.

Distributors routinely do any of the three choices.  Greg does only the
first one in stable:  No forward-ports, only backports.  I wrote about the
downsides of forward-ports in the other post.

There is an obvious downside to backports-only too:  The stable fix is
delayed until after mainline fix.  This one downside seems to have
inspired this huge mailinglist thread...  But you as a user of stable can
compensate for this delay in some ways:  You could switch back to a stable
release before the regression, you could apply a fix locally on top of the
regressed stable, or you could find a third party kernel which contains
such local fixes.

Sure, any of these options is a nuisance.  But these nuisances for end
users will still probably not change how stable is maintained.  Instead,
that forward-ports are out of scope of stable is one reason why you are
getting so frequent stable releases.  So you typically don't have to wait
for a regression fix in stable for unbearingly long.  No forward-ports in
stable also means lower likelyhood of stable-only regressions.
-- 
Stefan Richter
-=====-===-- -=-- -===-
http://arcgraph.de/sr/
