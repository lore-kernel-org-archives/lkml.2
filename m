Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936Ab2DMNnP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 09:43:15 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:50476 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769Ab2DMNnM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 09:43:12 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 13 Apr 2012 15:42:16 +0200
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
Message-ID: <20120413154216.476a02ac@stein>
In-Reply-To: <CAMP44s0RohH9tPiM5qCDT57XBV=iO66PZkSjYVxA6Usg1qJPtw@mail.gmail.com>
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
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 13 Felipe Contreras wrote:
> On Fri, Apr 13, 2012 at 11:57 AM, Stefan Richter
> <stefanr@s5r6.in-berlin.de> wrote:
> > On Apr 12 Felipe Contreras wrote:
> >> But this is exactly the opposite; the patch that broke things is in
> >> the 'release branch' (3.3.1); it's not in upstream (3.3). Sure, it's
> >> also on a later upstream, which is also broken.
> >            ^^^^^
> > No, upstream /earlier/ than 3.3.1 contains the defect.
> 
> Time is not relevant for the point being made, but fine:

Time of occurrence of a regression in mainline and stable is indeed
irrelevant, as there can only be two kinds of regressions in stable:

  A) First the regression was introduced into mainline, and accidentally it
     was carried over from there into stable.

  B) The regression only happened in stable because a backport from
     mainline to stable went wrong, e.g. a prerequisite to the backport
     was forgotten to be backported beforehand.

AFAIU we are talking about a regression of type A.

It seems you are arguing that stable candidate patches which fix
regressions of type A should be treated differently from other stable
candidate patches.

> But this is exactly the opposite; the patch that broke things is in
> the 'release branch' (3.3.1); it's not in the upstream release from
> where stable began (3.3). Sure, it's also on upstream, which is also
> broken.

(To what is this the opposite?)

So the defect is present in two kernel branches:  Linus'es and Greg's.
The fix needs eventually go into both branches.  For reasons which have
been enumerated many times in this thread already, Greg takes the fix from
Linus, not the other way around.

If you do not like to wait for Linus and Greg, you simply have to derive
an own kernel which additionally contains your preferred fixes.

The reasons for the Linus->Greg order of maintaining the stable series 100%
apply to fixes for type A regressions as well.

> > Furthermore, consider this:  You as user of the 3.3.y series are using a
> > temporary, dead-end side branch.  Its maintenance will stop at some point,
> > and you will be left looking for a different, maintained series to migrate
> > to.  You will be most interested in that series /not/ containing any
> > regressions that you suffered already through the 3.3.y lifetime.
> 
> Of course, I will be interested in that, although most likely I would
> be switching to another stable release (v3.4.1), not the upstream
> release (v3.4), and most distros would do the same.

Indeed.

> Even in the unlikely event that v3.4 is broken, most likely v3.4.1
> would contain the fix.

That would only happen if the upstream fix was published after v3.4 but
before Greg finished cherry-picking from Linus' post-3.4 git head.

> But I'm also interested in v3.3.2 working.

It's obviously a bit late for that, but v3.3.3 seems likely to bring the
fix.

> So you are saying that:
> 
> a) v3.3.1 (bad), v3.3.2 (bad), v3.4 (good)
> b) v3.3.1 (bad), v3.3.2 (good), v3.4 (bad)
> c) v3.3.1 (bad), v3.3.2 (good), v3.4 (good)
[...]

Not exactly.

I and others are saying that procedures must ensure that if e.g. v3.3.3
was "good", then v3.4 and hence v3.4.y must be "good" too.  ("Good" here
meaning "contains fix xyzabc".)

Furthermore I was saying that due to the time-based instead of
feature-based release schedule, the procedure which gives above guarantee
is a time-based procedure:  Greg takes fixes *if* they were published by
Linus == *after* they were published by Linus.

I add:  The second reason for this procedure is that v3.x.y is a successor
of v3.x but not of v3.x-1.y.  Forward-porting from v3.x-1.y to v3.x.y is
not in scope of the stable series.  The reasons why there is no
forward-porting done in stable series, again, have been mentioned several
times in this thread.
-- 
Stefan Richter
-=====-===-- -=-- -==-=
http://arcgraph.de/sr/
