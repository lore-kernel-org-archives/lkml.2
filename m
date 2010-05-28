Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600Ab0E1K6X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 06:58:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32797 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab0E1K6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 06:58:21 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Peter Zijlstra <peterz@infradead.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.44L0.1005272057500.31050-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1005272057500.31050-100000@netrider.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 May 2010 09:19:57 +0200
Message-ID: <1275031197.32462.14.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-27 at 20:59 -0400, Alan Stern wrote:
> On Fri, 28 May 2010, Rafael J. Wysocki wrote:
> 
> > > And the forced-suspend design relies on the fact that processes remain 
> > > frozen throughout.  If we leave some processes unfrozen and one of them 
> > > somehow becomes runnable, that means we have to abort the forced 
> > > suspend before the process is allowed to run.
> > 
> > We could avoid that if drivers could block tasks, but there are questions to
> > answer.  First off, how a driver is supposed to know when to block the task
> > using it and when to do its power management transparently for the task?
> > Second, how to intercept and block all possible interfaces that user space
> > can use to talk to drivers (how to intercept a task using mmapped device, for
> > example)?
> 
> We talked about this a few years ago and decided it was not feasible.  
> It would require substantial changes to every device driver.

But what if its the _right_ thing to do? We make changes to every device
driver out there on a regular basis. Also, why won't an incremental
process work? Add the interface with a fallback for drivers that haven't
implemented it and implement it for those drivers its most urgent (like
those in use on an Android phone).

Not doing the right thing simply because its a lot of work seems like a
fine way to let the kernel rot into an unmaintainable mess.

