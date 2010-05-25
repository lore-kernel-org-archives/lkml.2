Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759123Ab0EYVng (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 17:43:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39542 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758778Ab0EYVnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 17:43:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/8] PM: Opportunistic suspend support.
Date: Tue, 25 May 2010 23:44:37 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-tst; KDE/4.3.5; x86_64; ; )
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@linux.intel.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Tejun Heo <tj@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nigel Cunningham <nigel@tuxonice.net>, Ming Lei <tom.leiming@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-doc@vger.kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <gregkh@suse.de>,
       tytso@mit.edu, James Bottomley <James.Bottomley@suse.de>
References: <Pine.LNX.4.44L0.1005251647530.1634-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1005251647530.1634-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005252344.37639.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 May 2010, Alan Stern wrote:
> On Tue, 25 May 2010, Rafael J. Wysocki wrote:
> 
> > So, basically, you'd prefer to move the entire complexity to user space.
> 
> No, just the complexity of the userspace suspend blockers.  That was 
> one of the parts of the interface that people objected to, after all.
> 
> > I'm not sure if that's a big win
> 
> It's not a _big_ win, but it is an improvement IMO.
> 
> >  and I'm not sure anyone is actually going to
> > implement it (and some drivers would still have to be modified to participate
> > in this framework).
> 
> Of course drivers have to be modified.  The kernel-layer suspend
> blockers aren't affected by this proposal, so they still have to be
> implemented.
> 
> >  So again, we have a hunch that the goal may be achieved
> > in a different way, but at this point we'd rather need a _working_ _solution_
> > (in the form of code one can build and actually use).
> 
> It's not very different from what has been submitted, and I think
> there's little doubt that it could be built and used fairly easily.  
> All we're talking about is removing the userspace suspend-blocker API
> and the opportunistic workqueue, replacing them with an "opportunistic"
> entry in /sys/power/state, and setting up a userspace power manager
> process.
> 
> > I don't think it's realistic to expect the Android people to go and redesign
> > their stuff along the lines you've described, because they have a working
> > implementation (in the kernel) that they are satisfied with.
> 
> The redesign would be pretty small.  The kernel changes relative to
> what they have submitted are minimal, mostly just removing a few of
> their additions.  Furthermore, we've been told that Android _already_
> funnels all its userspace suspend-blocker work through a single
> process.  All that would be needed would be to make that process
> initiate an opportunistic suspend whenever no userspace suspend
> blockers were active.
> 
> > Now, we can reject their patches, but that's not going to cause any progress
> > to happen, realistically.  Quite on the contrary, Android will continue to use
> > wakelocks and Android driver writers will continue to ignore the mainline
> > and the gap between the two kernel lines will only get wider and wider over
> > time.
> > 
> > And what really is the drawback if we merge the patches?  Quite frankly,
> > I don't see any.
> 
> You don't seem to appreciate how small a change Dmitry has proposed.  
> Almost all of the suspend-blocker work would remain as in the submitted
> patches.  The only difference is that the userspace API and
> opportunistic-suspend implementation would be simplified, by moving
> some of the work out of the kernel.

No, I don't really think it's going to be a small change.  The problem is that
for the Android people changing user space is very hard, so I don't think
this realy is an option, given that they would have to implement it themselves,
test it, validate it on multiple different hardware platforms etc. and _then_
resubmit the feature without any guarantee that it will be merged.

So, my opinion is that we only have a choice to either take the feature as is
now, or reject it altogether and live with the consequeces in each case.  And
quite frankly I don't feel like I'm in position to make that decision.

Thanks,
Rafael
