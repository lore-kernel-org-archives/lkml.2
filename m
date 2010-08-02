Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab0HBA2K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 20:28:10 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:55908 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888Ab0HBA2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 20:28:08 -0400
Date: Sun, 1 Aug 2010 17:28:02 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, swetland@google.com,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100802002802.GP2470@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100801201117.GO2470@linux.vnet.ibm.com>
 <Pine.LNX.4.44L0.1008011810300.22928-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1008011810300.22928-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 01, 2010 at 06:16:57PM -0400, Alan Stern wrote:
> On Sun, 1 Aug 2010, Paul E. McKenney wrote:
> 
> > > I should have made a stronger point: "power-aware" is _not_ a good
> > > term for these applications.  "power-enabled" would be better but
> > > still not ideal.  Maybe "power-permitted"?  The definition is that
> > > they are _permitted_ to do something (acquire suspend blockers), not
> > > that they actually _do_ something.
> > 
> > How about "PM-driving applications", as Rafael suggested?
> 
> Perhaps.  But it's a little misleading, since what these applications
> are permitted to do is to _prevent_ the system from going to low power.  
> So in a real sense they don't drive PM -- they block it.  (Indeed,
> that's what inspired the name "suspend blocker".)  Of course, the same 
> objection applies to "power-permitted".

Good point, but for the moment I would like to keep the number of
classes of applications down to a dull roar, and so am proposing
one class for applications that either actively control device/system
power/sleep or prevent changes in same.

I am of course open to improvements in the "PM-driving applications"
name.  ;-)

> > > I was agreeing with the requirement but disagreeing with the reason
> > > given for it.  Even when buffers are large enough that the danger of
> > > overrunning them is infinitesimal, delays in input event delivery are
> > > still undesirable.
> > > 
> > > Besides, the Android kernel doesn't vary its behavior based on whether
> > > the recipient is power-permitted or power-naive; it _always_ delivers
> > > input events in a timely fashion.
> > 
> > True, the difference between the two classes of applications is in
> > whether or not the application is permitted to process the event.
> > 
> > I added "and to minimize response latencies" to the requirement.
> > Does that capture it?
> 
> Yes.

Very good!!!

> > > > But leaving that aside, I thought that Arve and Brian explicitly
> > > > stated this as a requirement on power-aware applications -- one of the
> > > > responsibilities that came with the power to block suspend.
> > > 
> > > No.  There are _no_ requirements on power-permitted (or power-aware if
> > > you prefer) applications, other than that the user decides to give it
> > > the appropriate permission.
> > > 
> > > Internally, of course, Android may enforce this rule on their own
> > > software.  But it has no force in regard to external applications.
> > 
> > So should this be moved to a new "ANDROID POLICY" section or some such?
> 
> Or DESIRED BEHAVIOR, or some such.

SUGGESTED USAGE?

							Thanx, Paul
