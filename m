Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760437Ab0FKOqc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 10:46:32 -0400
Received: from netrider.rowland.org ([192.131.102.5]:51719 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760384Ab0FKOqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 10:46:31 -0400
Date: Fri, 11 Jun 2010 10:46:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: James Bottomley <James.Bottomley@suse.de>
cc: David Brownell <david-b@pacbell.net>, <tytso@mit.edu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Neil Brown <neilb@suse.de>,
       Brian Swetland <swetland@google.com>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] suspend blockers & Android integration
In-Reply-To: <1276266502.2862.74.camel@mulgrave.site>
Message-ID: <Pine.LNX.4.44L0.1006111045340.12006-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jun 2010, James Bottomley wrote:

> On Thu, 2010-06-10 at 21:21 -0700, David Brownell wrote:
> > Do we at least have a clean way that a driver can
> > reject a system suspend?  I've lost track of many
> > issues, but maybe this could be phrased as a QOS
> > constraint:  the current config of driver X needs
> > clock Y active to enter the  target system suspend
> > state, driver's suspend() method reports as much.  Then the entry to
> > that system state gets blocked
> > if the clock isn't enabled.
> 
> So in QoS modifications to android patches, the answer is "yes" ...
> except that the current android patch set didn't actually have this type
> of wakelock in it.
> 
> Android wants an idleness suspend block (or pm qos constraint) that a
> driver can set to prevent the system idleness power govenor from
> dropping into a power state too low for the driver, so in USB terms this
> would prevent the states that shut down the clock.  For android, it
> prevented shutdown of an internal i2c bus.
> 
> The one thing that does look difficult is that these power constraints
> are device (and sometimes SoC) specific.  Expressing them in a generic
> way for the cpu govenors to make sense of might be hard.

Doesn't the clock framework already handle this sort of thing?

Alan Stern

