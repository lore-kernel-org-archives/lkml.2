Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132Ab0HHR16 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 13:27:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50859 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703Ab0HHR15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 13:27:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Attempted summary of suspend-blockers LKML thread
Date: Sun, 8 Aug 2010 19:25:42 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, david@lang.hm,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, swetland@google.com,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
References: <Pine.LNX.4.44L0.1008070926260.20673-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1008070926260.20673-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008081925.42664.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, August 07, 2010, Alan Stern wrote:
> On Sat, 7 Aug 2010, Rafael J. Wysocki wrote:
> 
> > > Arguably not every PCI interrupt should be regarded as a wakeup event, so
> > > I think we can simply say in the cases when that's necessary the driver should
> > > be responsible for using pm_wakeup_event() or pm_stay_awake() / pm_relax() as
> > > appropriate.
> > > 
> > > My patch only added it to the bus-level code which covered the PME-based
> > > wakeup events that _cannot_ be handled by device drivers.
> 
> In other words, your bus-level changes were a necessary but not
> sufficient start.  I can buy that.
> 
> > Also please note that it depends a good deal on the definition of a "wakeup
> > event".  Under the definition used when my patch was being developed, ie. that
> > wakeup events are the events that would wake up the system from a sleep state,
> > PCI interrupts cannot be wakeup events, unless the given device remains in the
> > full power state although the system has been suspended (standard PCI devices
> > are not allowed to generate signals except for PME from low-power states).
> 
> Um, what do you mean by "event"?  Let's take a concrete example.  
> Suppose you have a system where you want USB plug or unplug events to
> cause a wakeup.  This is relevant to the discussion at hand if your USB
> host controller is a PCI device.
> 
> By your reckoning, a plug or unplug event that occurs while the system
> is asleep would be a wakeup event by definition.  And yet you say that
> the same plug or unplug event occurring while the controller was at
> full power would not count as a wakeup event?  And in particular, it 
> should not prevent the system from suspending before the event can be
> fully processed?  That doesn't make sense.  The same event is the same 
> event, regardless of the context in which it occurs.  If it is treated 
> as a wakeup event in context then it should be treated as a wakeup 
> event in other contexts too.

In this example the event is not a PCI interrupt itself, which is a consqeuence
of the event, but the USB plug-unplug.  So, whoever detects the plug-unplug
should use pm_stay_awake() or pm_wakeup_event().  That may be an
interrupt handler of a PCI USB controller, so if that is the case, the
controller driver probably should use one of these functions in its interrupt
handler.  Still, that by no measn implies that _every_ PCI interrupt should in
principle be regarded as a wakeup event.

Thanks,
Rafael
