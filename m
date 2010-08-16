Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250Ab0HPVNK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 17:13:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45802 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372Ab0HPVNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 17:13:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [linux-pm] Attempted summary of suspend-blockers LKML thread, take three
Date: Mon, 16 Aug 2010 23:11:27 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rjw+; KDE/4.4.4; x86_64; ; )
Cc: "Ted Ts'o" <tytso@mit.edu>, david@lang.hm, arjan@infradead.org,
        peterz@infradead.org, Brian Swetland <swetland@google.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        linux-kernel@vger.kernel.org, galibert@pobox.com, florian@mickler.org,
        tglx@linutronix.de, menage@google.com, paulmck@linux.vnet.ibm.com,
        linux-pm@lists.linux-foundation.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, swmike@swm.pp.se
References: <AANLkTi=RD=eM_gpc7FfRq0923sUbARmZ2+4-m+fLibYC@mail.gmail.com> <20100813190801.GB26950@thunk.org> <1281746599.16747.11.camel@mulgrave.site>
In-Reply-To: <1281746599.16747.11.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008162311.27584.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, August 14, 2010, James Bottomley wrote:
> On Fri, 2010-08-13 at 15:08 -0400, Ted Ts'o wrote: 
> > On Fri, Aug 13, 2010 at 01:11:29PM -0400, James Bottomley wrote:
> > > 
> > > The facts are that suspend blockers identifies a race within our suspend
> > > to ram system that permeates from top to bottom (that's from server to
> > > mobile).  The problem is that resume events are racy with respect to
> > > suspend and vice versa.  This manifests itself most annoyingly on my
> > > laptop in the "double suspend" case: where I suspend with a pending
> > > suspend event, my laptop will resume and then immediately re-suspend
> > > (leading me to kick myself and remind myself to check it stayed up
> > > before pushing unsuspend and walking away).  The other annoying case is
> > > that if I accidentally close the lid before presenting, I have to wait
> > > until the system is fully down before pressing resume.
> > 
> > This is all true, but it's also only one aspect of the problem.  I
> > agree with you that this is the part of the problem which affects
> > Linux at all scales, from Cloud servers in a data center that want to
> > suspend themselves when there's no work to do (and then fail to
> > respond to the WOL packet) to mobile platforms that are suspending
> > much more frequently.
> > 
> > However, it doesn't follow that this is the _only_ problem that the
> > Android folks might be interested in solving.  Opportunistic suspend
> > is a different part of the problem space, which is generally believed
> > by the Android developers as being far more efficient than a
> > user-space suspend manager.  Rafael has stated his complete
> > unwillingness to deal with this part of the problem.  OK, so that
> > probably means that for Android, it will have to be an out-of-tree
> > kernel patch.
> 
> OK, so I tried desperately to avoid the question of whether
> opportunistic suspend is a good way of managing power.  However, it
> seems to me that it is in use by several systems (android, olpc, etc).
> I'll defer the question of whether it's better in user space or kernel
> space to Rafael's investigations  ...  but I will point out that the
> kernel space patch, once the suspend blockers issue is taken care of
> looks like a single patch to one file, so should be locally containable
> and should allow upstream to be useful as the driver base again.
> 
> > The question, then, is whether a solution which addresses the only
> > part of the problem which Rafael is interested in dealing with at this
> > point, is sufficient such that (a) the kernel-level opportunistic
> > suspend can be done as an out-of-tree patch, while simultaneously (b)
> > allowing device drivers for Android devices can utilize Rafael's
> > interfaces to solve the race design bug currently found in our suspend
> > subsystem, while (c) requiring minimal changes to the Android
> > userspace, and (d) providing all of the statistics and debugging
> > functionality required by the Android userspace.
> > 
> > If we can engineer a solution which meets (a), (b), (c), and (d)
> > above, then everyone will be happy.
> 
> That's my goal.

In fact, we (which means basically Alan Stern and me at this point) are working
with Arve on this right now.

Thanks,
Rafael
