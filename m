Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab0HBUgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 16:36:18 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:56374 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388Ab0HBUgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 16:36:16 -0400
Date: Mon, 2 Aug 2010 13:36:09 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, stern@rowland.harvard.edu, swetland@google.com,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100802203609.GG2405@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100731175841.GA9367@linux.vnet.ibm.com>
 <20100801154708.19817b75@infradead.org>
 <20100802011006.GS2470@linux.vnet.ibm.com>
 <201008021552.20505.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008021552.20505.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 03:52:20PM +0200, Rafael J. Wysocki wrote:
> On Monday, August 02, 2010, Paul E. McKenney wrote:
> > On Sun, Aug 01, 2010 at 03:47:08PM -0700, Arjan van de Ven wrote:
> > > On Sun, 1 Aug 2010 12:12:28 -0700
> > > "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> ...
> > > Another one: freezing whole cgroups..... we have that today. it
> > > actually works quite well.... of course the hard part is the decision
> > > what to put in which cgroup, and at what frequency and duration you let
> > > cgroups run.
> > 
> > Indeed, the Android guys seemed to be quite excited by cgroup freezing
> > until they thought about the application-classification problem.
> > Seems like it should be easy for some types of applications, but I do
> > admit that apps can have non-trivial and non-obvious dependencies.
> 
> This isn't more difficult than deciding which applications will be allowed to
> use wakelocks (in the wakelocks world).  It actually seems to be pretty much
> equivalent to me. :-)

If I understand correctly, the problem they were concerned about was
instead "given that a certain set of apps are permitted to use wakelocks,
which of the other apps can safely be frozen when the display blanks
itself."

> > > on the suspend blockers for drivers; the linux device runtime PM is
> > > effectively doing the same things; it allows drivers to suspend/resume
> > > individually (with a very nice API/programming model I should say) based
> > > on usage. And it works on a tree level, so that it's relatively easy
> > > to do things like "I want to go to <this magic deep idle state>, but
> > > only if <this set of devices is suspended already>". This is obviously
> > > an important functionality for all low power devices, ARM or x86. 
> > > Suspend blockers had this functionality as part of what it did (they do
> > > more obviously) but I'd wager that the current Linux infrastructure is
> > > outright nicer. 
> > 
> > This is what Rafael has been working on?
> 
> If you mean the runtime PM framework, then yes, I've been working on it.
> 
> > Of course, the Android guys also want to pay attention to which apps
> > are running as well as to the state of devices on the system.
> 
> In fact the runtime PM framework is also important to Android, because it
> can be used in there, for example, to implement the "early suspend" thing
> I referred to in one of my previous messages in this thread.

Now we just need to convince the Android guys of that.  ;-)

							Thanx, Paul
