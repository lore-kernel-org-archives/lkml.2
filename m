Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab0HBDEk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 23:04:40 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:45841 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840Ab0HBDEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 23:04:39 -0400
Date: Sun, 1 Aug 2010 20:04:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, arve@android.com, mjg59@srcf.ucam.org,
        pavel@ucw.cz, florian@mickler.org, rjw@sisk.pl,
        stern@rowland.harvard.edu, swetland@google.com, peterz@infradead.org,
        tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100802030433.GV2470@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100731175841.GA9367@linux.vnet.ibm.com>
 <20100731215214.2543c07e@infradead.org>
 <20100801054816.GI2470@linux.vnet.ibm.com>
 <alpine.DEB.1.10.1008010812450.24755@uplift.swm.pp.se>
 <alpine.DEB.1.10.1008010838430.24755@uplift.swm.pp.se>
 <20100801192708.GM2470@linux.vnet.ibm.com>
 <20100801154904.243bc390@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100801154904.243bc390@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 01, 2010 at 03:49:04PM -0700, Arjan van de Ven wrote:
> On Sun, 1 Aug 2010 12:27:08 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > On Sun, Aug 01, 2010 at 08:49:43AM +0200, Mikael Abrahamsson wrote:
> > > On Sun, 1 Aug 2010, Mikael Abrahamsson wrote:
> > > 
> > > >it's just that mobile (low power) wasn't the intended target of
> > > >the application when it was written, and this commonly shows.
> > 
> > Good points in both this and your earlier post!!!
> > 
> > > I have another aspect I just thought about. I work for a telephony
> > > company. We provide Internet connectivity throught various means,
> > > DSL, Ethernet to the Home, mobile etc.
> > > 
> > > For ETTH and DSL, network usage is pretty straight forward, you send
> > > packets, they get delivered pretty quickly with low marginal cost
> > > per packet. For mobile, this is not quite so simple. Mobile networks
> > > are designed for terminal/UE (user equipment) to use low power, so
> > > they go down in low power state after a while. Let's take the case
> > > of 3G/HSPA:
> > > 
> > > After a short while (second) of idleness (no packets being sent),
> > > the mobile network negotiates away the high speed resources (the one
> > > that enables multimegabit/s transfers) and tries to give it to
> > > someone else. After approximately 30 seconds, the terminal goes to
> > > "idle", meaning it has no network resources at all. Next time it
> > > wants to send something (or the network wants to deliver something
> > > to it), network resources need to be negotiated again. This can take
> > > 1-2 seconds and uses battery power of course. It also consumes
> > > resources in the operator network (because mobility control units
> > > need to talk to base stations, tunnels need to be re-negotiated
> > > etc).
> > > 
> > > Anyhow, my point is that not only is there a benefit in having
> > > multiple applications wake up at the same time for power reasons
> > > within the device, there is also a point in having coordination of
> > > their network access. If a device is running 3 IM programs at the
> > > same time, it'd be beneficial if they were coordinated in their
> > > communication with their Internet servers. Same goes for the "check
> > > for new email" application. If they all were optimized to only wake
> > > up the network connectivity once every 180 seconds instead of doing
> > > it when the individual application felt like it, power and other
> > > resources would be saved by all involved parties.
> > 
> > This is a good point.  Within some limits, the timer-aggregation
> > changes that have gone into Linux can handle this, but I am not sure
> > whether or not 180 seconds is within the reasonable boundaries for
> > timer jitter.
> 
> this is why operating systems for mobile devices offer heartbeat
> services... where apps subscribe to and do background work like
> checking email at "convenient" times.
> 
> I'm not sure if the OS you use on your desktop has one, but MeeGo and
> Maemo and I'm pretty sure Android and most other mobile Linux OSes have
> one. It's a higher level activity alignment layer, well above the
> kernel.

Thank you, good to know!

							Thanx, Paul
