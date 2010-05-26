Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948Ab0EZWM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 18:12:26 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49801 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752710Ab0EZWMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 18:12:23 -0400
Date: Wed, 26 May 2010 18:12:22 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@linux.intel.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Tejun Heo <tj@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nigel Cunningham <nigel@tuxonice.net>, Ming Lei <tom.leiming@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>, <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 1/8] PM: Opportunistic suspend support.
In-Reply-To: <201005262351.59626.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1005261759100.1328-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010, Rafael J. Wysocki wrote:

> > The reason is simple: When a user process initiates an opportunistic 
> > suspend, you make it wait in an interruptible sleep until all the 
> > kernel suspend blockers are released.  No polling.  If another user 
> > thread decides in the meantime that it needs to block the suspend, it 
> > sends a signal to the power manager process.
> > 
> > In fact, other threads should signal the power manager process whenever 
> > they want to block or unblock suspends.  That way the power manager 
> > process can spend all its time sleeping, without doing any polling.
> 
> I still see an issue here.  Namely, if the power manager is in user space and
> it's signaled to suspend, it has to ask the kernel to do that, presumably by
> writing something to a sysfs file.  Then, if the kernel blocks the suspend, the
> power manager waits until the block is released.  Now, it should go back and
> check if user space still doesn't block suspend and if so, wait until the block
> is released and start over.  With all suspend blockers in the kernel this
> looping behavior is avoidable.

I must be missing something.  In Arve's patch 1/8, if the system is in
opportunistic suspend, and a wakeup event occurs but no suspend
blockers get enabled by the handler, what causes the system to go back
into suspend after the event is handled?  Isn't that a loop of some
sort?

And even if it isn't, so what?  What's wrong with looping behavior?  
Especially a loop that's as short as this one and spends almost all of
its time sleeping.  Think how much harder it would be to write programs
if you weren't allowed to use any loops.  :-)

Alan Stern

