Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933413Ab1DMXM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 19:12:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46994 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756243Ab1DMXMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 19:12:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: freezer: should barriers be smp ?
Date: Thu, 14 Apr 2011 01:12:29 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, uclinux-dist-devel@blackfin.uclinux.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <BANLkTi=F-C-vwX4PGGfbkdTBw3OWL-twfg@mail.gmail.com> <201104140049.23344.rjw@sisk.pl> <BANLkTi=_+kYvs3_dsXifd_rkxfmFzJLttA@mail.gmail.com>
In-Reply-To: <BANLkTi=_+kYvs3_dsXifd_rkxfmFzJLttA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104140112.29210.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 14, 2011, Mike Frysinger wrote:
> On Wed, Apr 13, 2011 at 18:49, Rafael J. Wysocki wrote:
> > On Thursday, April 14, 2011, Mike Frysinger wrote:
> >> i guess the trouble for us is that you have one CPU posting writes to
> >> task->flags (and doing so by grabbing the task's spinlock), but the
> >> other CPU is simply reading those flags.  there are no SMP barriers in
> >> between the read and write steps, nor is the reading CPU grabbing any
> >> locks which would be an implicit SMP barrier.  since the Blackfin SMP
> >> port lacks hardware cache coherency, there is no way for us to know
> >> "we've got to sync the caches before we can do this read".  by using
> >> the patch i posted above, we have that signal and so things work
> >> correctly.,
> >
> > In theory I wouldn't expect the patch to work correctly, because it replaces
> > _stronger_ memory barriers with _weaker_ SMP barriers.  However, looking at
> > the blackfin's definitions of SMP barriers I see that it uses extra stuff that
> > should _also_ be used in the definitions of the mandatory barriers.
> >
> > In my opinion is an architecture problem, not the freezer code problem.
> 
> OK, we have a patch pending locally which populates all barriers with
> this logic, but based on my understanding of things, that didnt seem
> correct.  i guess i'm reading too much into the names ... i'd expect
> the opposite behavior where "rmb" is only for UP needs while "smp_rmb"
> is a rmb which additionally covers SMP.

Well, I guess the naming is for historical reasons, ie. mb(), rmb() and wmb()
were there first and it probably was regarded cleaner to use new names for the
optimized smp_ variants than to rename all instances already in the code and
then repurpose the old names.

Thanks,
Rafael
