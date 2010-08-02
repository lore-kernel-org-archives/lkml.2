Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab0HBAcU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 20:32:20 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:55847 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278Ab0HBAcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 20:32:18 -0400
Date: Sun, 1 Aug 2010 17:32:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, swetland@google.com, peterz@infradead.org,
        tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100802003212.GR2470@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <Pine.LNX.4.44L0.1007311544470.5418-100000@netrider.rowland.org>
 <201008011741.31086.rjw@sisk.pl>
 <20100801195617.GN2470@linux.vnet.ibm.com>
 <201008020044.57155.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008020044.57155.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 12:44:56AM +0200, Rafael J. Wysocki wrote:
> On Sunday, August 01, 2010, Paul E. McKenney wrote:
> > On Sun, Aug 01, 2010 at 05:41:30PM +0200, Rafael J. Wysocki wrote:
> > > On Saturday, July 31, 2010, Alan Stern wrote:
> > > > On Sat, 31 Jul 2010, Paul E. McKenney wrote:
> ... 
> > > > On Android this goes somewhat farther.  IIUC, they want hardly anything 
> > > > to run while the display is powered off.  (But my understanding could 
> > > > be wrong.)
> > > 
> > > Not really.  Quite a lot of things happen on these systems while the display
> > > is off (let alone the periodic battery monitoring on Nexus One :-)).  They
> > > can send things over the network and do similar stuff in that state.
> > > 
> > > I think the opposite is true, ie. the display is aggressively turned off
> > > whenever it appears not to be used, because it draws a lot of power.
> > 
> > Fair enough.  It appears to me that Android won't suspend if the display
> > is on, but I could easily be confused here.
> 
> That's correct.  In fact, Android uses a special mechanism called "early
> suspend" (or similar) to suspend the display and some other devices before the
> "real" suspend happens.

Sounds good!

> ...
> > > > > o	Power-naive applications must be prohibited from controlling
> > > > > 	the system power state.  One acceptable approach is through
> > > > > 	use of group permissions on a special power-control device.
> > > > 
> > > > You mean non-power-aware applications, not power-naive applications.  
> > > > But then the statement is redundant; it follows directly from the
> > > > definition of "power-aware".
> > > 
> > > Agreed.
> > 
> > OK, but I still believe that an enforcement mechanism is required.
> 
> The requirement is that power-oblivious applications should not participate
> in deciding whether or not to put the system into a sleep state which is pretty
> much by definition.

I moved this into the definitions section -- you and Alan convince me.  ;-)

> > > > > o	Statistics of the power-control actions taken by power-aware
> > > > > 	applications must be provided, and must be keyed off of program
> > > > > 	name.
> > > > > 
> > > > > o	Power-aware applications can make use of power-naive infrastructure.
> > > > > 	This means that a power-aware application must have some way,
> > > > > 	whether explicit or implicit, to ensure that any power-naive
> > > > > 	infrastructure is permitted to run when a power-aware application
> > > > > 	needs it to run.
> > > > > 
> > > > > o	When a power-aware application is preventing the system from
> > > > > 	shutting down, and is also waiting on a power-naive application,
> > > > > 	the power-aware application must set a timeout to handle
> > > > > 	the possibility that the power-naive application might halt
> > > > > 	or otherwise fail.  (Such timeouts are also used to limit the
> > > > > 	number of kernel modifications required.)
> > > > 
> > > > No, this is not a requirement.  A power-optimized application would do 
> > > > this, of course, by definition.  But a power-aware application doesn't 
> > > > have to.
> > > 
> > > Agreed.
> > 
> > Again, this requirement was explicitly called out by the Android folks.
> 
> Rather, there should be a mechanism allowing PM-driving applications to do
> that, but they are not required to use that mechanism.

Fair enough!  I moved this into a new section that I am currently calling
"SUGGESTED USAGE".

							Thanx, Paul
