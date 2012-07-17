Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab2GQS7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 14:59:45 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:44797 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754945Ab2GQS7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 14:59:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [patch] Rename CAP_EPOLLWAKEUP to CAL_BLOCK_SUSPEND
Date: Tue, 17 Jul 2012 21:05:21 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, mtk@lwn.net
References: <5004EBF9.3040406@gmail.com> <CAKgNAkh=LpuQDYWJ1XZpLMv+oFNqUD2Y+ZAxKOyB08-1OkJ55A@mail.gmail.com> <20120717135914.GA6662@mail.hallyn.com>
In-Reply-To: <20120717135914.GA6662@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207172105.22109.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 17, 2012, Serge E. Hallyn wrote:
> Quoting Michael Kerrisk (man-pages) (mtk.manpages@gmail.com):
> > On Tue, Jul 17, 2012 at 3:46 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
> > > Quoting Michael Kerrisk (mtk.manpages@gmail.com):
> > >> Rafael,
> > >>
> > >> As discussed in
> > >> http://thread.gmane.org/gmane.linux.kernel/1249726/focus=1288990,
> > >> the capability introduced in 4d7e30d98939a0340022ccd49325a3d70f7e0238
> > >> to govern EPOLLWAKEUP seems misnamed: this capability is about governing
> > >> the ability to suspend the system, not using a particular API flag
> > >> (EPOLLWAKEUP). We should make the name of the capability more general
> > >> to encourage reuse in related cases. (Whether or not this capability
> > >> should also be used to govern the use of /sys/power/wake_lock is a
> > >> question that needs to be separately resolved.)
> > >>
> > >> This patch renames the capability to CAP_BLOCK_SUSPEND. In order to ensure
> > >> that the old capability name doesn't make it out into the wild, could you
> > >> please apply and push up the tree to ensure that it is incorporated
> > >> for the 3.5 release.
> > >>
> > >> Thanks,
> > >>
> > >> Michael
> > >>
> > >> Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
> > >
> > > I definately like that name better, thanks.  Don't know if renaming it
> > > without an alias could cause trouble for some bleeding edge userspaces?
> > > Would it be worth keeping the
> > >
> > > #define CAP_EPOLLWAKEUP      36
> > >
> > > line?  If this is deemed early enough I do prefer not to complicate with
> > > a duplicate name.
> > 
> > Maybe I'm too ignorant. Are there userspaces that bleed with the -rc
> > series? I'd have thought this renaming would be a fairly safe change
> > at this point.

I'm not so sure of that, but then I think it will be less painful
to do it now rather than later.

> I'm sure there are, but I'm not sure what we've promised them.

I can't recall making any promises to anyone in that respect, but then
people have had quite enough time to get used to the existing name already.

> Like I say if at all possible I do prefer not to keep CAP_EPOLLWAKEUP.

I will push the Michael's patch to Linus for v3.5, if it's not too late,
but I'm not pleased by the timing of this, to put it lightly.

Thanks,
Rafael
