Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757729Ab2HUP6n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:58:43 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55544 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab2HUP6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:58:41 -0400
Date: Tue, 21 Aug 2012 17:02:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@kernel.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Alex Shi <alex.shi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
Message-ID: <20120821170254.0b10ece6@pyramind.ukuu.org.uk>
In-Reply-To: <20120821151910.GA5359@gmail.com>
References: <1345028738.31459.82.camel@twins>
	<502BA7DC.7060907@linux.intel.com>
	<1345041548.31459.90.camel@twins>
	<502BB5A3.5000403@linux.intel.com>
	<1345043096.31459.106.camel@twins>
	<502BE38D.9030405@linux.intel.com>
	<20120820080606.GA6931@gmail.com>
	<20120820181651.GA737@srcf.ucam.org>
	<20120821094203.GB12385@gmail.com>
	<20120821113951.GA22436@srcf.ucam.org>
	<20120821151910.GA5359@gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > That's a fundamentally uninteresting thing for the kernel to 
> > know about. [...]
> 
> I disagree.

The kernel has no idea of the power architecture leading up to the plug
socket. The kernel has no idea of the policy concerns of the user.

> > [...] AC/battery is just not an important power management 
> > policy input when compared to various other things.
> 
> Such as?
> 
> The thing is, when I use Linux on a laptop then AC/battery is 
> *the* main policy input.

Along with distance likely to be travelled without a socket being
available, whether you remembered the charger, and a pile of other things
('can I get this built before Linus wakes up').

The kernel isn't capable of computing these other factors. The userspace
can at least make an educated guess,

In the business space its even more complicated because battery/mains may
well only be visible via SNMP queries to the power systems and the bigger
concern may well be heat efficiency. If you are running a cloud your
policy considerations also include things like your current spot
electricity price, outside temperature and your current spot compute price
chargeable.

> > Userspace has been doing a perfectly reasonable job of 
> > determining policy here.
> 
> Has it properly switched the scheduler's balancing between 
> power-effient and performance-maximizing strategies when for 
> example a laptop's AC got unplugged/replugged?

You work for Red Hat, maybe you should ask your distro people if they do.
While you are it at perhaps also some of the ATA power management that
will probably be an order of magnitude more significant could get
included ;)

Seriously. On a typical laptop the things you can do about power are
dominated by the backlight, by disk power (eg idle SATA links), by USB
device power downs where possible, by turning off any unused phys and by
not having the CPU wake up, which means fixing the desktop apps to behave
sensibly.

I'd like to see actual numbers and evidence on a wide range of workloads
the spread/don't spread thing is even measurable given that you've also
got to factor in effects like completing faster and turning everything
off. I'd *really* like to see such evidence on a laptop,which is your
one cited case it might work.

> > Your suggestions aren't a working default mechanism.
> 
> In what way?

For one if the default behaviour is that when I get on the train and am
on battery my video playback begins to stutter due to some kernel
magic then I shall be unamused and file it as a regression.....

Policy is userspace - the desktop can figure out I'm watching movies and
what this means, the kernel can't.

I'd also note there have been repeated attempts to put power management
policy on various OS's by putting the power management policy 

- in the hardware
- in SMM handlers
- in the kernel

and every single one has been a failure because those parts of the system
never have enough information nor do they have enough variety of control
to manage the complexity of input state.

It's a single policy file for a distro to do scheduler configuration
based upon power events. One trivial 'drop it here' shell script. The
difference then being the desktop can be taught to do overrides and
policy properly.

It might be the kernel has important knowledge about what "schedule
for efficiency" means and even to be able to ask the kernel to dot hat
- but it has no idea what the right policy is at any given moment.

ie even if there is a /sys/mumble/schedule_for_efficiency

the echo "1" > and echo "0" > belong in a script

Alan

