Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933559Ab0EYTFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 15:05:23 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54904 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933464Ab0EYTFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 15:05:22 -0400
Date: Tue, 25 May 2010 15:05:19 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@ucw.cz>, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@linux.intel.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Tejun Heo <tj@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nigel Cunningham <nigel@tuxonice.net>, Ming Lei <tom.leiming@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>, <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 1/8] PM: Opportunistic suspend support.
In-Reply-To: <20100525184740.GA4248@core.coreip.homeip.net>
Message-ID: <Pine.LNX.4.44L0.1005251501500.1634-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 May 2010, Dmitry Torokhov wrote:

> > > What you describe can be done in userspace though, via a "suspend manager" 
> > > process. Tasks reading input events will post "busy" events to stop the 
> > > manager process from sending system into suspend. But this can be confined to 
> > > Android userspace, leaving the kernel as is (well, kernel needs to be modified 
> > > to not go into suspend with full queues, but that is using existing kernel 
> > > APIs).
> > 
> > I think that could be made to work.  And it might remove the need for 
> > the userspace suspend-blocker API, which would be an advantage.  It 
> > could even remove the need for the opportunistic-suspend workqueue -- 
> > opportunistic suspends would be initiated by the "suspend manager" 
> > process instead of by the kernel.
> > 
> > However you still have the issue of modifying the kernel drivers to 
> > disallow opportunistic suspend if their queues are non-empty.  Doing 
> > that is more or less equivalent to implementing kernel-level suspend 
> > blockers.  (The suspend blocker approach is slightly more efficient, 
> > because it will prevent a suspend from starting if a queue is 
> > non-empty, instead of allowing the suspend to start and then aborting 
> > it partway through.)
> >
> > Maybe I'm missing something here...  No doubt someone will point it out 
> > if I am.
> > 
> 
> Well, from my perspective that would limit changes to the evdev driver
> (well, limited input core plumbing will be needed) but that is using the
> current PM infrastructure. The HW driver changes will be limited to what
> you described "type 2" in your other e-mail.
> 
> Also, not suspending while events are in progress) is probably
> beneficial for platforms other than Android as well. So unless I am
> missing something this sounds like a win.

I agree that simplifying the user API would be an advantage.  Instead 
of the full-blown suspend-blocker interface, we would need only a way 
to initiate an opportunistic suspend.  For example:

	echo opportunistic >/sys/power/state

Alan Stern

