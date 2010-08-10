Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387Ab0HJEqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 00:46:14 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:46009 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695Ab0HJEqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 00:46:05 -0400
Date: Mon, 9 Aug 2010 21:45:41 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Ted Ts'o" <tytso@mit.edu>, Felipe Contreras <felipe.contreras@gmail.com>,
        david@lang.hm, Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, menage@google.com,
        david-b@pacbell.net, James.Bottomley@suse.de, arjan@infradead.org,
        swmike@swm.pp.se, galibert@pobox.com, dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
Message-ID: <20100810044541.GA2817@linux.vnet.ibm.com>
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
 <20100809201822.441905f7@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100809201822.441905f7@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 09, 2010 at 08:18:22PM +0100, Alan Cox wrote:
> > But wouldn't an office suite run as a power-oblivious application on an
> > Android device?  After all, office applications do not need to run when
> 
> I was waiting for soemone to leap down the pit I dug  Office suites have
> some quite important background activities. Consider the case of a power
> oblivious Open Office. You type a critical document, you suspend, your
> phone battery dies a bit later, you lost your document. Office suites do
> timed backing up as one simple obvious example. That could become a power
> aware behaviour but the truely power oblivious office suite is a myth.

It is a sad day on LKML when we are busy digging pits for each other.
On the other hand, I have seen far sadder days, and the pit you dug
happens to lead somewhere useful.  As Brian noted in his reply, the
situation you call out can occur with manual suspend-to-RAM already:
the fact is that this is a design choice.  You could indeed make a
PM-driving office application if you wished, or run the same application
as a power-oblivious application.  There is a slight difference in the
contract with the user.  Of course, it is quite clear which one -you-
prefer, but preferences can vary.

> > the screen is turned off, so these the applications do not need to use
> > suspend blockers.  That said, I could easily imagine that significant
> > work would be required to make OpenOffice run on Android, not due to
> > suspend blockers, but rather due to Android's unusual user space.
> 
> You are tightly linking suspend blockers with Android. If they were a
> sensible general solution they would be generic not tied closely to
> Android

Android is certainly where suspend blockers originated, and is to the best
of my knowledge is still the only platform that uses them.  But there is
a first user of every new mechanism, and for some time that first user
will by definition be the only user of that mechanism.  So the fact
that Android is most probably the only user of suspend blockers does
not prove anything about whether or not suspend blockers are sensible.

> Some of the other bad assumptions being made in this discussion:
> 
> - That the phone is special. Todays Android phones are up with the PC's
>   of some years back (but with better graphics and more faster storage),
>   in a few more generations of the technology what will they look like ?
>   I'm sure that within a few years there will be people playing Warcraft
>   or similar on their phone in the train.

Indeed, people have played games on their cellphones for some years.
Not sure whether any of the games resembles World of Warcraft, but they
probably soon will.  If so, perhaps they will make use of significant
hardware acceleration -- most other embedded systems do so.

But that doesn't guarantee that solutions developed for PCs and laptops
will be optimal (or even usable) on cellphones.  Sufficient difference
in scale can easily change the form of the optimal solution, so you
have not yet made your case.  (For that matter, you also haven't proven
that adoption of suspend blockers or something like them depends on the
assumption that cellphones are special.)

> - That Android will continue to tbe offering the same services in future
>   as today. If it does it'll go the way of PalmOS and Symbian. Equally
>   you can't just bust all the apps as it changes

I hope that no one is arguing that Android will remain unchanged, just
as I hope no one would argue that Linux will remain unchanged.  In fact,
I am quite confident that both Linux and Android will continue to change.
So exactly what point were you attempting to make here?

As to busting all apps, lthough there have been situations where busting
all the apps turned out to be the right thing to do, I agree that these
situations are extremely rare.  Such situations are usually associated
with the emergence of a new high-volume platform.

> As devices get more complex and varied you cannot afford to put the
> detailed awareness of platform behaviour in the applications. It
> doesn't scale. Android developers are haivng enough fun coping with all
> the OS variants, customisations and new phones - and thats far less
> variety than PC hardware. Generally the PC app folks are not having the
> same level of problem - so ask why ?

>From what I can see, the Android developers are suffering less than
the PC developers were suffering when the PC was the same age that
Android is now.  For that matter, suspend blockers don't put detailed
awareness of platform behavior into apps.  You must look to the heavily
power-optimized apps to find that kind of awareness.

> > On devices that do not have suspend blockers, a normal application runs
> > in a manner similar to a hypothetical Android application that acquires
> > a suspend blocker when it starts and holds that suspend blocker until
> > it exits.  In contrast with Android, this situation requires that each
> > and every application be carefully written to avoid battery drain,
> > which I suspect is what Ted is getting at with his King Canute analogy.
> 
> Which is flawed and not the case.

Hmmm...  Exactly which part do you consider flawed?  Let's take it
one sentence at a time.  The devices that I know of that lack suspend
blockers also lack opportunistic suspend.  Therefore, all applications on
such devices run as would an application that acquired a suspend blocker
when it started and did not release that suspend blocker until it exited.
Pretty straightforward.

As for the first part of the second sentence, you yourself have argued
that each and every application should be carefully written to avoid
battery drain (or, equivalently, to promote energy efficiency), so
presumably the flaw does not reside there.  That leaves the second
half of that sentence, for which we both must defer to Ted.  But Ted's
intended meaning of his King Canute analogy does not affect the argument
as to whether or not suspend blockers (or, again, something like them)
are useful.

>                                   The same argument could be made for
> multi-tasking
> 
> DOS	"Each application implements its own internal
> 	multitasking/polling if needed"
> 
> Windows 3.x	"Each application has an event loop and is built
> in a certain way" (the 'suspend blocker' mentality)
> 
> Real OS		"The scheduler operates in a manner which prevents
> CPU hogs breaking the system or abusing it sufficiently to threaten its
> functionality"

I really do like this progression.  I will return to it further down.

> The same applies to power. Only the OS has the big picture and can hide
> the hardware and general policy variety from the application.

The OS can be said to possess the full picture only if the applications
communicate their portion of the picture to the OS.  Linux has quite a
few APIs devoted to this sort of communication, many of them mandated
by POSIX.  Some people are proposing suspend blockers (or something like
them) as another member of this set of APIs.

> OpenOffice runs on netbooks, laptops, servers, even big non x86 boxes. It
> runs on virtual machines, it runs in power sensitive environments, it
> runs in thermally constrained environments, it runs in I/O constrained
> environments, it runs in latency constrained environments etc etc

And there are numerous environments in which it will not run.  So what?

> All the same code, true some work has been done to make it behave
> politely but the rest is down to the OS doing its job - deploying the
> resources available while considering and obeying the constraints
> present, in a manner which makes best use of the resources to achieve the
> policy goals of the system.

And if the work has not been done on the application, and if there is
nothing like suspend blockers, the OS cannot do its job.  So how exactly
does this support your position?

Which brings us to the progression from DOS to Windows 3.x to Real
OS.  Why can the Real OS's scheduler can operate "in a manner which
prevents CPU hogs from breaking the system or abusing it sufficiently
to threaten its functionality" while still allowing applications with
special requirements to operate correctly?  One reason is the advent
of any number of APIs that communicate special properties of specific
applications to the OS, including the old nice() system call, POSIX
realtime, numerous facilities to communicate application properties to
the VM system, and so on.

Given this context, are you sure that suspend blockers are not the next
step in the Real OS progression?  Or some QoS mechanism that subsumes
suspend blockers?  However, there is a lot of negative experience
around general-purpose QoS mechanisms -- you have to be quite careful
in order to avoid spending more energy computing QoS than you would
otherwise spend on the application's computations.  The usual way out of
this trap is to abandon generality in favor of exploiting the commonly
occurring special cases.  For all I know, raw suspend blockers might be
the appropriate special case.

> And not unsurprisingly that all starts to look like Stafford Beer's good
> old viable systems model.

Hmmm...  I do like "Absolutum Obsoletum", especially if it really does
translate to "If it works it's out of date."  However, I am not at all
convinced that it supports your position!  ;-)

							Thanx, Paul
