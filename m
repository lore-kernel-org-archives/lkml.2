Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620Ab0E0T6r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 15:58:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49673 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755488Ab0E0T6p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 15:58:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 1/8] PM: Opportunistic suspend support.
Date: Thu, 27 May 2010 22:00:09 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
Cc: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
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
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-doc@vger.kernel.org
References: <AANLkTikFwznonORd42piWZvBv3oqqSj9odC9Jaud8o3x@mail.gmail.com> <AANLkTingAiO8dkwnInc993PTyA63rV-WRvBIRlB2ChXs@mail.gmail.com> <20100527181333.GA8297@core.coreip.homeip.net>
In-Reply-To: <20100527181333.GA8297@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201005272200.09679.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 May 2010, Dmitry Torokhov wrote:
> On Wed, May 26, 2010 at 05:52:40PM -0700, Arve Hjønnevåg wrote:
> > 2010/5/26 Alan Stern <stern@rowland.harvard.edu>:
> > > On Wed, 26 May 2010, Arve Hjønnevåg wrote:
> > >
> > >> > I must be missing something.  In Arve's patch 1/8, if the system is in
> > >> > opportunistic suspend, and a wakeup event occurs but no suspend
> > >> > blockers get enabled by the handler, what causes the system to go back
> > >> > into suspend after the event is handled?  Isn't that a loop of some
> > >> > sort?
> > >> >
> > >>
> > >> Yes it is a loop. I think what you are missing is that it only loops
> > >> repeatedly if the driver that aborts suspend does not use a suspend
> > >> blocker.
> > >
> > > You mean "the driver that handles the wakeup event".  I was asking what
> > > happened if suspend succeeded and then a wakeup occurred.  But yes, if
> > > a suspend blocker is used then its release causes another suspend
> > > attempt, with no looping.
> > >
> > >> > And even if it isn't, so what?  What's wrong with looping behavior?
> > >>
> > >> It is a significant power drain.
> > >
> > > Not in the situation I was discussing.
> > >
> > 
> > If you meant it spend most of the time suspended, then I agree. It
> > only wastes power when a driver blocks suspend by returning an error
> > from its suspend hook and we are forced to loop doing no useful work.
> > 
> 
> If driver refuses to suspend that means there are events that need
> processing. I fail to see why it would be called "looping doing no
> useful work".

I guess Arve meant the case of events that didn't propagate to user space.

Rafael


> 
> 

