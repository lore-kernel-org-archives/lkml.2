Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758432Ab0E1OuF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 10:50:05 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49105 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756906Ab0E1OuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 10:50:01 -0400
Date: Fri, 28 May 2010 10:49:58 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Peter Zijlstra <peterz@infradead.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, <felipe.balbi@nokia.com>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <1275031197.32462.14.camel@laptop>
Message-ID: <Pine.LNX.4.44L0.1005281045290.1939-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 May 2010, Peter Zijlstra wrote:

> On Thu, 2010-05-27 at 20:59 -0400, Alan Stern wrote:
> > On Fri, 28 May 2010, Rafael J. Wysocki wrote:
> > 
> > > > And the forced-suspend design relies on the fact that processes remain 
> > > > frozen throughout.  If we leave some processes unfrozen and one of them 
> > > > somehow becomes runnable, that means we have to abort the forced 
> > > > suspend before the process is allowed to run.
> > > 
> > > We could avoid that if drivers could block tasks, but there are questions to
> > > answer.  First off, how a driver is supposed to know when to block the task
> > > using it and when to do its power management transparently for the task?
> > > Second, how to intercept and block all possible interfaces that user space
> > > can use to talk to drivers (how to intercept a task using mmapped device, for
> > > example)?
> > 
> > We talked about this a few years ago and decided it was not feasible.  
> > It would require substantial changes to every device driver.
> 
> But what if its the _right_ thing to do? We make changes to every device
> driver out there on a regular basis. Also, why won't an incremental
> process work? Add the interface with a fallback for drivers that haven't
> implemented it and implement it for those drivers its most urgent (like
> those in use on an Android phone).

There is no reasonable fallback.  In fact, I seriously doubt that
there's any way to carry this out at all, reasonable or not.  For
example, how do you handle the situation where a user task gets an
error because it accessed an mmapped address belonging to a device that
has been suspended?

> Not doing the right thing simply because its a lot of work seems like a
> fine way to let the kernel rot into an unmaintainable mess.

Firstly, it's not at all clear that this _is_ the right thing.

Secondly, when doing the right thing involves making invasive changes 
to half the .c files in the kernel, people might stop to think that it 
would add more bugs than it would solve problems.

Alan Stern

