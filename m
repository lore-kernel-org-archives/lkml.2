Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab0HITMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 15:12:16 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:50669 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547Ab0HITMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 15:12:15 -0400
Date: Mon, 9 Aug 2010 11:54:47 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: david@lang.hm
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Ted Ts'o" <tytso@mit.edu>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, menage@google.com,
        david-b@pacbell.net, James.Bottomley@suse.de, arjan@infradead.org,
        swmike@swm.pp.se, galibert@pobox.com, dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
Message-ID: <20100809185447.GL3026@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <AANLkTikyRhtfX4R3x_NDgHnXssmfVuhjC5PbhRZ0a7su@mail.gmail.com>
 <alpine.DEB.2.00.1008062010510.30564@asgard.lang.hm>
 <20100807061558.GA28087@thunk.org>
 <AANLkTi=sMVjya9CH6UoZwJCXJTDRgBhnPXmApU_RHVTi@mail.gmail.com>
 <20100808155719.GB3635@thunk.org>
 <AANLkTinM5e2HGOFavODPZNzZx4KshDSjsvKN4pLpGGgr@mail.gmail.com>
 <20100808213821.GD3635@thunk.org>
 <20100809112453.77210acc@lxorguk.ukuu.org.uk>
 <20100809181638.GI3026@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1008091122220.23481@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1008091122220.23481@asgard.lang.hm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 09, 2010 at 11:28:02AM -0700, david@lang.hm wrote:
> On Mon, 9 Aug 2010, Paul E. McKenney wrote:
> 
> >On Mon, Aug 09, 2010 at 11:24:53AM +0100, Alan Cox wrote:
> >
> >[ . . . ]
> >
> >>>would agree that in the ideal world, it would be nice if you could
> >>>have applications that make the correct performance/battery
> >>>utilization tradeoff for devices running on 800 mWh batteries, 94,000
> >>>mWh batteries, and while running on the AC mains.  But I don't believe
> >>>that it's likely to be true, and if you want to try to beat up on
> >>>application writers one at a time to be power optimized --- as far as
> >>>I'm concerned, that's an argument *for* suspend blockers, since I'm
> >>>not big believer in plans that begin, "First, you command the tides of
> >>>the sea to go back", King Canute style.  :-)
> >>
> >>Suspend blockers drive the system policy part way into the apps, that in
> >>turn makes the apps very vulnerable to change in their environment because
> >>you've specialised them. I am sure that in the Android world it's
> >>considered fine, and that the marketing and business people even like
> >>this binding together - but it doesn't generalise and will blow up in
> >>people's faces in the future.
> >>
> >>To consider your tide analogy - suspend blockers is like trying to
> >>program the waves individually. Show me a suspend blocker aware open
> >>office patch 8)
> >
> >But wouldn't an office suite run as a power-oblivious application on an
> >Android device?  After all, office applications do not need to run when
> >the screen is turned off, so these the applications do not need to use
> >suspend blockers.  That said, I could easily imagine that significant
> >work would be required to make OpenOffice run on Android, not due to
> >suspend blockers, but rather due to Android's unusual user space.
> 
> pick your application if you don't like the example.

I like the office-suite example just fine.

> but also, which android system should the applicaton be written for?
> the phone with a 800maH battery or a larger device with a 94,000maH
> battery?

Does battery size make a difference in this particular case?

> well bahaved applications (not doing unnecessary wakeups, etc) are
> well bahaved, no matter what system they are on

Yep.  Your point being what exactly?  That all applications should be
required to be power-optimized, and that any technology that automates
energy efficiency should be rejected out of hand?  If so, please justify
your position.

>                                                 (explicitly setting
> allowable timer fuzz is linux specific, but will again help on any
> system)

Setting aside the question of how timer fuzz will help on non-Linux
systems if timer fuzz is specific to Linux...

							Thanx, Paul
