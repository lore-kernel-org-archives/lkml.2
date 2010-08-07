Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762293Ab0HGAgs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 20:36:48 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:47393 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154Ab0HGAgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 20:36:46 -0400
Date: Fri, 6 Aug 2010 17:36:42 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: david@lang.hm, Brian Swetland <swetland@google.com>,
        kevin granade <kevin.granade@gmail.com>,
        Arve Hj?nnev?g <arve@android.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100807003642.GQ2432@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <AANLkTinatKEBfHhMnKc5wbys13P81PKWSc+nxccgHe-Y@mail.gmail.com>
 <alpine.DEB.2.00.1008051715520.30632@asgard.lang.hm>
 <AANLkTikOuY-q42mDRmxc-9W0uLeJeW-hiFG26WrV7CfU@mail.gmail.com>
 <alpine.DEB.2.00.1008051800360.25170@asgard.lang.hm>
 <20100806123047.GE31326@sirena.org.uk>
 <20100806172226.GH2432@linux.vnet.ibm.com>
 <20100806173325.GA25367@rakim.wolfsonmicro.main>
 <20100806181832.GJ2432@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1008061517130.30564@asgard.lang.hm>
 <20100807001431.GA3252@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100807001431.GA3252@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 07, 2010 at 01:14:32AM +0100, Mark Brown wrote:
> On Fri, Aug 06, 2010 at 04:35:59PM -0700, david@lang.hm wrote:
> > On Fri, 6 Aug 2010, Paul E. McKenney wrote:
> 
> Guys, please try to cut unneeded text from the quotes - it makes it much
> easier to find the new text.
> 
> >>> Well, not really from the Linux point of view.  It's not massively
> >>> different to something like keeping an ethernet controller sufficiently
> >>> alive to allow it to provide wake on LAN functionality while the system
> 
> >> The wake-on-LAN and the lights-out management systems are indeed
> >> interesting examples, and actually pretty good ones.  The reason I
> >> excluded them is that they don't do any application processing -- their
> >> only purpose is the care and feeding of the system itself.  In contrast,
> >> the embedded processors are able to do significant applications processing
> >> (e.g., play back music) while any CPUs are completely shut down and most
> >> of the memory is powered down as well.
> 
> This isn't a particularly meaningful distinction, things like the LoM
> systems on servers are generally at least as capable as things like the
> DSPs doing tasks like offloaded MP3 decode and often provide useful
> services in themselves (like system monitoring).  It's really just
> semantics to treat them differently to something like a cellular modem -
> at a high level they're both just independant processors ticking away
> without the application processor.

I agree that a smartphone's cellular modem can be argued to be very
similar to wake-on-LAN.  The smartphone applications that seem to me
to be very different from wake-on-LAN are things like audio playback,
where the system is providing service to the user during the time that
it is suspended.

> > one other significant issue is that on the PC, things like wake-on-LAN,  
> > lights out management cards, etc require nothing from the main system  
> > other than power. If they do something, they are sending the signal to 
> > the chipset, which then wakes the system up. they don't interact with the 
> > main processor/memory/etc at all.
> 
> I don't see that it makes much difference what gets kept alive - at the
> end of the day the point is that we're making a decision to keep bits of
> the system alive over suspend.

The distinction is whether or not the system is perceived to be actively
doing something useful while it is suspended.  Yes, this is subjective,
but the distinction is still important.

> > So as I see it, we need to do one of two things.
> 
> > 1. change the suspend definition to allow for some things to not be  
> > suspended
> 
> This is essentially what's already happening.

The time-of-day clock is certainly a case in point here.  ;-)

							Thanx, Paul

> > 2. change the sleep/low-power mode definition to have a more standardized 
> > way of turning things off, and extend it to allow clocks to be turned off 
> > as well (today we have things able to be turned off, drive spin-down for  
> > example, but per comments in this thread it's all one-off methods)
> 
> Currently things like clock trees are frequently managed orthogonaly to
> the system power state to at least some extent anyway - for example,
> perfectly normal wake events like button presses will often require
> clocks for things like debouncing.
