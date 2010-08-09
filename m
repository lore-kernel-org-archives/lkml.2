Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab0HITHP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 15:07:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51633 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753762Ab0HITHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 15:07:13 -0400
Date: Mon, 9 Aug 2010 20:18:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: paulmck@linux.vnet.ibm.com
Cc: "Ted Ts'o" <tytso@mit.edu>, Felipe Contreras <felipe.contreras@gmail.com>,
        david@lang.hm, Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, menage@google.com,
        david-b@pacbell.net, James.Bottomley@suse.de, arjan@infradead.org,
        swmike@swm.pp.se, galibert@pobox.com, dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
Message-ID: <20100809201822.441905f7@lxorguk.ukuu.org.uk>
In-Reply-To: <20100809181638.GI3026@linux.vnet.ibm.com>
References: <20100806225453.GA3947@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1008061651530.30564@asgard.lang.hm>
	<AANLkTikyRhtfX4R3x_NDgHnXssmfVuhjC5PbhRZ0a7su@mail.gmail.com>
	<alpine.DEB.2.00.1008062010510.30564@asgard.lang.hm>
	<20100807061558.GA28087@thunk.org>
	<AANLkTi=sMVjya9CH6UoZwJCXJTDRgBhnPXmApU_RHVTi@mail.gmail.com>
	<20100808155719.GB3635@thunk.org>
	<AANLkTinM5e2HGOFavODPZNzZx4KshDSjsvKN4pLpGGgr@mail.gmail.com>
	<20100808213821.GD3635@thunk.org>
	<20100809112453.77210acc@lxorguk.ukuu.org.uk>
	<20100809181638.GI3026@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But wouldn't an office suite run as a power-oblivious application on an
> Android device?  After all, office applications do not need to run when

I was waiting for soemone to leap down the pit I dug  Office suites have
some quite important background activities. Consider the case of a power
oblivious Open Office. You type a critical document, you suspend, your
phone battery dies a bit later, you lost your document. Office suites do
timed backing up as one simple obvious example. That could become a power
aware behaviour but the truely power oblivious office suite is a myth.

> the screen is turned off, so these the applications do not need to use
> suspend blockers.  That said, I could easily imagine that significant
> work would be required to make OpenOffice run on Android, not due to
> suspend blockers, but rather due to Android's unusual user space.

You are tightly linking suspend blockers with Android. If they were a
sensible general solution they would be generic not tied closely to
Android

Some of the other bad assumptions being made in this discussion:

- That the phone is special. Todays Android phones are up with the PC's
  of some years back (but with better graphics and more faster storage),
  in a few more generations of the technology what will they look like ?
  I'm sure that within a few years there will be people playing Warcraft
  or similar on their phone in the train.

- That Android will continue to tbe offering the same services in future
  as today. If it does it'll go the way of PalmOS and Symbian. Equally
  you can't just bust all the apps as it changes

As devices get more complex and varied you cannot afford to put the
detailed awareness of platform behaviour in the applications. It
doesn't scale. Android developers are haivng enough fun coping with all
the OS variants, customisations and new phones - and thats far less
variety than PC hardware. Generally the PC app folks are not having the
same level of problem - so ask why ?

> On devices that do not have suspend blockers, a normal application runs
> in a manner similar to a hypothetical Android application that acquires
> a suspend blocker when it starts and holds that suspend blocker until
> it exits.  In contrast with Android, this situation requires that each
> and every application be carefully written to avoid battery drain,
> which I suspect is what Ted is getting at with his King Canute analogy.

Which is flawed and not the case. The same argument could be made for
multi-tasking

DOS	"Each application implements its own internal
	multitasking/polling if needed"

Windows 3.x	"Each application has an event loop and is built
in a certain way" (the 'suspend blocker' mentality)

Real OS		"The scheduler operates in a manner which prevents
CPU hogs breaking the system or abusing it sufficiently to threaten its
functionality"

The same applies to power. Only the OS has the big picture and can hide
the hardware and general policy variety from the application.

OpenOffice runs on netbooks, laptops, servers, even big non x86 boxes. It
runs on virtual machines, it runs in power sensitive environments, it
runs in thermally constrained environments, it runs in I/O constrained
environments, it runs in latency constrained environments etc etc

All the same code, true some work has been done to make it behave
politely but the rest is down to the OS doing its job - deploying the
resources available while considering and obeying the constraints
present, in a manner which makes best use of the resources to achieve the
policy goals of the system.

And not unsurprisingly that all starts to look like Stafford Beer's good
old viable systems model.

Alan
