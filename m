Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab0HHTHp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 15:07:45 -0400
Received: from netrider.rowland.org ([192.131.102.5]:47458 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755519Ab0HHTHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 15:07:42 -0400
Date: Sun, 8 Aug 2010 15:07:37 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, <david@lang.hm>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>,
        <linux-pm@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <pavel@ucw.cz>, <florian@mickler.org>, <swetland@google.com>,
        <peterz@infradead.org>, <tglx@linutronix.de>,
        <alan@lxorguk.ukuu.org.uk>
Subject: Re: Attempted summary of suspend-blockers LKML thread
In-Reply-To: <201008081925.42664.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1008081502150.6810-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Aug 2010, Rafael J. Wysocki wrote:

> > > Also please note that it depends a good deal on the definition of a "wakeup
> > > event".  Under the definition used when my patch was being developed, ie. that
> > > wakeup events are the events that would wake up the system from a sleep state,
> > > PCI interrupts cannot be wakeup events, unless the given device remains in the
> > > full power state although the system has been suspended (standard PCI devices
> > > are not allowed to generate signals except for PME from low-power states).
> > 
> > Um, what do you mean by "event"?  Let's take a concrete example.  
> > Suppose you have a system where you want USB plug or unplug events to
> > cause a wakeup.  This is relevant to the discussion at hand if your USB
> > host controller is a PCI device.
> > 
> > By your reckoning, a plug or unplug event that occurs while the system
> > is asleep would be a wakeup event by definition.  And yet you say that
> > the same plug or unplug event occurring while the controller was at
> > full power would not count as a wakeup event?  And in particular, it 
> > should not prevent the system from suspending before the event can be
> > fully processed?  That doesn't make sense.  The same event is the same 
> > event, regardless of the context in which it occurs.  If it is treated 
> > as a wakeup event in context then it should be treated as a wakeup 
> > event in other contexts too.
> 
> In this example the event is not a PCI interrupt itself, which is a consqeuence
> of the event, but the USB plug-unplug.  So, whoever detects the plug-unplug
> should use pm_stay_awake() or pm_wakeup_event().  That may be an
> interrupt handler of a PCI USB controller, so if that is the case, the
> controller driver probably should use one of these functions in its interrupt
> handler.  Still, that by no measn implies that _every_ PCI interrupt should in
> principle be regarded as a wakeup event.

Okay, agreed.  I just wanted you to grant that some PCI interrupts
should be treated like wakeup events even if they don't actually wake
the system up from a sleep state.  The "PCI interrupts cannot be wakeup 
events" statement is a little strong.

Alan Stern

