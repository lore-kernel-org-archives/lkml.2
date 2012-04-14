Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab2DNJLR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 05:11:17 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:60054 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab2DNJLO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 05:11:14 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 14 Apr 2012 11:10:44 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>, Adrian Chadd <adrian@freebsd.org>,
        Greg KH <gregkh@linuxfoundation.org>, Sergio Correia <lists@uece.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 00/78] 3.3.2-stable review
Message-ID: <20120414111044.4930a5f3@stein>
In-Reply-To: <CAMP44s0OdVBTwVtCoru-xvB=LVtO56jgku7X-0a7mUz1=iVCzw@mail.gmail.com>
References: <20120412011313.GA23764@kroah.com>
	<CAMP44s2q+bQE3-zsX4bs=sQDt4jf8eE5bwZ8V88UjodjRyAjog@mail.gmail.com>
	<20120412144626.GA14868@kroah.com>
	<CAMP44s1T4EVwpzDuV_vV0Zh-5WcPCwdw9eeOfL17Geqp_UFN-Q@mail.gmail.com>
	<CAJ-VmonhwvnXPKa=LNOR4W0ZTXZqWmzw4UrsKLoE0YN_Bu0FzQ@mail.gmail.com>
	<CAMP44s2JPvhEB6Eb049Z_bToAFncHKMEheuyaxyhC=bnh2GJVg@mail.gmail.com>
	<20120413105746.10ffb120@stein>
	<CAMP44s0RohH9tPiM5qCDT57XBV=iO66PZkSjYVxA6Usg1qJPtw@mail.gmail.com>
	<20120413154216.476a02ac@stein>
	<CAMP44s10KVwL5pY=Q5hWfyUtU6CvvZZ4Bcg-fEY9dAhSL306aQ@mail.gmail.com>
	<20120413230525.GA13995@burratino>
	<CAMP44s0OdVBTwVtCoru-xvB=LVtO56jgku7X-0a7mUz1=iVCzw@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 14 Felipe Contreras wrote:
> On Sat, Apr 14, 2012 at 2:05 AM, Jonathan Nieder <jrnieder@gmail.com> wrote:
> > I don't think Stefan meant the above as tongue-in-cheek, for what it's
> > worth.  Another stable kernel with different rules really would be an
> > interesting exercise, and would probably fulfill a need for a certain
> > audience.
> >
> > It's not like nobody does that already, anyway.  For example, I hear
> > Fedora has a kernel that they maintain well for a different audience,
> > using different rules.
> 
> Of course, although the difference with the stable kernel would be
> very small if the only thing added is an extra rule for acceptance:
> "It reverts an earlier
> patch to 'stable'."

It looks like a small difference on the surface, but it isn't.  It would
mean "yes, we /do/ forward ports in -stable too in some cases".

In face of the frequent and predictable rate of mainline releases and the
very frequent stable releases, the problems associated with forward ports
very much appear to outweigh the benefits.

So the folks who do the actual work appear to be content with stable =
backports only, and it seems you can't convince them to do forward ports.
Which means that if you really want forward ports, you need to find
somebody else who does forward ports (e.g. a suitable distributor) or do
them yourself.

> But "we do this, and if you don't like it you can do whatever you
> want" is not a valid argument in favor of the status quo,

That would not be a valid argument, no.  But it has been mentioned /why/
only backports are done in stable, i.e. what the problems with forward
ports are:

  - First of all more work.  (Could be compensated by longer periods
    between stable releases, which would be an obvious downside too,
    and actually defeat much of the purpose of the stable series of
    getting out fixes to people.)

  - Backports are already risky, which is why only /small/ backports are
    allowed into stable.  Forward ports bring their own set of risks.
    Inevitably, users of the kernel called "stable" will get even
    more reason to wonder why this series is not "stable" in a sense of
    "absolutely free of regressions".

    For example, merging subsystem development trees into the mainline is
    actually a forward port.  The mainline is at risk not only because
    that subsystem tree hasn't had as much exposure to hardware and
    workloads as the mainline will have, but additionally because the
    merge result is different from the subsystem tree head.  (The result
    is a forward port.)  Mainline development uses for example the
    linux-next tree in order to reduce a subset of these forward porting
    risks, those associated with conflicting developments in different
    subsystems and cross-tree development.  Which kinds of tools should
    stable use if it were to accept forward ports?

    So, rather than managing the risk of forward ports in stable, those
    risks are systematically avoided by not ever doing forward ports, not
    even small ones.

  - The mainline would not immediately benefit from the work put into
    forward ports in stable.  Worse, fixes in those forward ports might
    not ever make it into the mainline.  That would be detrimental to all
    mainline users, and thus to all stable users.  (Stable users are
    mainline users because stable is branched off of mainline every 2.5
    months.)

These downsides have been mentioned in the thread; please consider them.
It is not about "we¹ do this because we are set in our ways".  The stable
rules have pragmatic reasons which are for example founded on lessons
learned from the 2.4/2.5/2.6 history of development, maintenance, and
distribution.

So there are arguments for the status quo, the arguments have been
mentioned several times, and I can't see what would invalidate any of
these arguments.

--------
¹) Greg, if you are still reading this thread:  Excuse the 'we', I do not
mean to speak for you.

Besides, Greg, thank you for the work.  As a driver maintainer and when
supporting end users, I benefit from it since distributor kernels do not
deviate much from mainline these days, among else thanks to your stable
and longterm series.  And it is an important way for me to get certain
driver fixes delivered to users conveniently and timely.
-- 
Stefan Richter
-=====-===-- -=-- -===-
http://arcgraph.de/sr/
