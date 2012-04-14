Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab2DNHmL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 03:42:11 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:59336 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623Ab2DNHmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 03:42:09 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 14 Apr 2012 09:41:37 +0200
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
Message-ID: <20120414094137.54a7f213@stein>
In-Reply-To: <CAMP44s10KVwL5pY=Q5hWfyUtU6CvvZZ4Bcg-fEY9dAhSL306aQ@mail.gmail.com>
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
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 14 Felipe Contreras wrote:
> I already exemplified how they are very different, but here it goes
> again. The patch "drm/i915: Add lock on drm_helper_resume_force_mode"
> was just tagged in 3.3.2, if I had said yesterday "this patch breaks
> things on my machine", then that patch would have been dropped for
> 3.3.2 even though it's still on mainline--why? Because we know it's
> broken, and broken patches are not supposed to land to stable. But
> today, one day later, we have to wait until it's fixed in master
> first. Why?
> 
> What makes a patch droppable yesterday, but dependent on mainline today?

Huh?

Because "yesterday" was a review before stable release:
  - A buggy mainline release exists.
  - No buggy stable release exists.
whereas "today" is after stable release:
  - A buggy mainline release exists.
  - A buggy stable release exists.

(The WLAN breakage wich is being talked about was reported after
release, not during review, right?)

[quote re-ordered]
> Again, you can repeat the same thing as much as you want, it still
> doesn't answer what I have asked.

Yeah, sorry for that.  All the time I thought you asked why a *revert*
which is applicable to mainline and stable first happens in stable.

But your question was actually what the difference between
  - dropping a patch from a queue of candidate patches versus
  - adding a reverting patch to repair a defect from a previous release
is.

The former is still part of the decision whether a changeset which
exists in mainline should be backported into stable.  Somebody initially
thought it should be, but others should have a look too and amend that
decision if need be.  Somebody reports that the change would introduce a
regression.  Usually, this disqualifies a patch from being applied to
stable right away, without further work having to be done in stable.

"Drop a stable candidate before release" is a form of "decline a
submission to stable", happening late in the preparations of a stable
release.

The latter is when damage was done; it is now about bug fixing.  This
involves debugging of the regression, finding a right approach to
fix it (e.g. revert), write + review + test + commit the fix, port the fix
to all relevant other kernel branches, review + test + commit those ports
too.

"Add a reverting fix" is a form of "add a fix".

You are indeed pointing to a procedural flaw here.  In "add a fix" cases,
stable release procedures ensure that if 3.3.3 included the revert, 3.4
will include it to, by the Linus->Greg order of commiting patches. But in
the "drop a candidate before release" case, Greg and the stable reviewers
do not have a similarly fool-proof procedure to ensure that the next branch
point will be free of the regression.  Now they need to watch closely that
a fix gets into mainline ideally before the next branch point is going to
be released.

So there is indeed a difficulty involved with dropping patches from the
candidate queue.  Fortunately, it is not necessary to subject post-release
reverts to the same difficulty.

> This of course, has *not* been explained.

Others had discussed "not adding a changeset" versus "amending an already
released changeset by another changeset on top of it" already.  Now I did
too and apologize to everybody else for redundancy.
-- 
Stefan Richter
-=====-===-- -=-- -===-
http://arcgraph.de/sr/
