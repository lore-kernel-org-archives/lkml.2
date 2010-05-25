Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700Ab0EYQ6N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 12:58:13 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:47380 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758987Ab0EYQ6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 12:58:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=ILsUR/+NXQ2WjnWaQ4zknwy4f4T4frrIPmElMZ4xUy9+c3qxyGMliWZ0aX/tbbzvkN
         SDSDsBWgOZykj9kNahIFal/L4AKY4ZnQlEhY5jUT5n/iSjxeJLSQoO2OkViZmSfqtig0
         KWJDKXHGMdnDZHilzpWxzUTudFnpUx0oXVII4=
Date: Tue, 25 May 2010 09:57:56 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
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
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/8] PM: Opportunistic suspend support.
Message-ID: <20100525165756.GA2979@core.coreip.homeip.net>
References: <AANLkTikz2UcDv6BZQ9Hq2MdowuAK1y_PBBPPXMEkDmNa@mail.gmail.com>
 <Pine.LNX.4.44L0.1005242130290.8440-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.44L0.1005242130290.8440-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 09:34:54PM -0400, Alan Stern wrote:
> On Mon, 24 May 2010, Arve Hjønnevåg wrote:
> 
> > > Wakeup events can be lost in at least three different ways:
> > >
> > >     1. A hardware signal (such as an IRQ) gets ignored.
> > >
> > >     2. The hardware event occurs, but without effect since the
> > >        kernel thread that would handle the event has been frozen.
> > >        The event just ends up sitting in a queue somewhere until
> > >        something else wakes up the system.
> > >
> > >     3. The hardware event occurs and the kernel handles it fully,
> > >        but the event propagates to userspace for further handling
> > >        and the user program is already frozen.
> > >
> > > 1 is a hardware configuration failure (for example, it might happen as
> > > a result of using edge-triggered IRQs instead of level-triggered) and
> > > is outside the scope of this discussion.
> > >
> > > 2 generally represents a failure of the core PM subsystem, or a failure
> > > of some other part of the kernel to use the PM core correctly.  In
> > > theory we should be able to fix such mistakes.  Right now I'm aware of
> > > at least one possible failure scenario that could be fixed fairly
> > > easily.
> > >
> > > 3 is the type of failure that suspend blockers were really meant to
> > > handle, particularly the userspace suspend-blocker API.
> 
> > I don't see a big difference between 2 and 3. You can use suspend
> > blockers to handle either.
> 
> You can, but they aren't necessary.  If 2 were the only reason for 
> suspend blockers, I would say they shouldn't be merged.
> 
> Whereas 3, on the other hand, can _not_ be handled by any existing
> mechanism.  3 is perhaps the most important reason for using suspend
> blockers.
> 

I do not see why 3 has to be implemented using suspend blockers either.
If you are concerned that event gets stuck somewhere in the stack make
sure that devices in the stack do not suspend while their queue is not
empty. This way if you try opportunistic suspend it will keep failing
until you drained all important queues.

-- 
Dmitry
