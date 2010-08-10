Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab0HJI1X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 04:27:23 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34359 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751422Ab0HJI1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 04:27:15 -0400
Date: Tue, 10 Aug 2010 09:38:49 +0100
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
Message-ID: <20100810093849.138e2318@lxorguk.ukuu.org.uk>
In-Reply-To: <20100810044541.GA2817@linux.vnet.ibm.com>
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
	<20100810044541.GA2817@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> situation you call out can occur with manual suspend-to-RAM already:
> the fact is that this is a design choice.  You could indeed make a

Losing data is a design choice ? The application set a timer, the OS
shouldn't be ignoring it in that situation. It might want to delay it, it
might want to warn the user its hogging things it shouldnt (powertop,
battery usage monitors in Android etc)

> will by definition be the only user of that mechanism.  So the fact
> that Android is most probably the only user of suspend blockers does
> not prove anything about whether or not suspend blockers are sensible.

They don't appear to solve the constraints on power management that you
have in other environments, nor do they happen to be conveniently
backward compatible or available on other platforms - which makes code
hard to port.

> But that doesn't guarantee that solutions developed for PCs and laptops
> will be optimal (or even usable) on cellphones.  Sufficient difference

Your cellphone is to all intents a laptop from ten years ago, it even has
a similar display resolution and internet availability. The underlying
difference between the two is solely form factor - the laptop had a
better keyboard.

> I hope that no one is arguing that Android will remain unchanged, just
> as I hope no one would argue that Linux will remain unchanged.  In fact,
> I am quite confident that both Linux and Android will continue to change.
> So exactly what point were you attempting to make here?

That anything which ties to a particular style of behaviour and set of
current usage assumptions is broken. If you rewrite all the apps to
Android 2.1 and design in a single tasking model then you'll have to
unrewrite half of it again when Android grows up. Ditto suspend blockers
- encode too much policy in your apps and you lose the ability to change
the environment under them. See the mess Microsoft got into with Win16 on
Win32. Compare with Linux 32bit on Linux 64bit.

> As to busting all apps, lthough there have been situations where busting
> all the apps turned out to be the right thing to do, I agree that these
> situations are extremely rare.  Such situations are usually associated
> with the emergence of a new high-volume platform.

Like Microsoft Windows 16bit co-operative multi-tasking ? It's rarely
right. It's merely that in certain cases the value in the market is large
enough that it can be used as a big stick to beat people into doing lots
of usually wasted work.

> Hmmm...  Exactly which part do you consider flawed?  Let's take it
> one sentence at a time.  The devices that I know of that lack suspend
> blockers also lack opportunistic suspend.  Therefore, all applications on
> such devices run as would an application that acquired a suspend blocker
> when it started and did not release that suspend blocker until it exited.
> Pretty straightforward.

What do you mean by "opportunistic suspend", lots of systems drop into
lowest power states whenever they can. "Suspend is different" is a bit of
Android religion that I am dubious has any basis in reality as seen from
the application end of the universe.

You may also wish to review the earlier parts of the discussion where it
was explicitly stated by several developers that they were using
"suspend" type modes as power states already and not using suspend
blockers. So it's being done, today on ARM and your statement is directly
contradicting the code. Modern ARM processors and x86 MID devices can
suspend and resume extremely fast (fast enough that the fact Linux x86
rewriting all the SMP alternatives on suspend/resume is a measurable
problem). If this same property doesn't end up on big PC boxes in time
then I'd be very surprised. At that point the openoffice with suspend
blockers or oracle with suspend blockers question becomes rather relevant.

> As for the first part of the second sentence, you yourself have argued
> that each and every application should be carefully written to avoid
> battery drain (or, equivalently, to promote energy efficiency), so

No. I've argued that applications need to be generally well behaved, not
keep waking up, not burn cpu - which is a generic property applicable on
all environments not a specialisation.

> > OpenOffice runs on netbooks, laptops, servers, even big non x86 boxes. It
> > runs on virtual machines, it runs in power sensitive environments, it
> > runs in thermally constrained environments, it runs in I/O constrained
> > environments, it runs in latency constrained environments etc etc
> 
> And there are numerous environments in which it will not run.  So what?

It's one codebase for all of them and furthermore almost all of that was
done by modifying only the OS. Linux learned to do power throttling
without the app being involved, it learned to do virtualisation without
the app being changed, it is learning (with -rt) to handle to do real
time this way. 

> > All the same code, true some work has been done to make it behave
> > politely but the rest is down to the OS doing its job - deploying the
> > resources available while considering and obeying the constraints
> > present, in a manner which makes best use of the resources to achieve the
> > policy goals of the system.
> 
> And if the work has not been done on the application, and if there is
> nothing like suspend blockers, the OS cannot do its job. 

I don't see any evidence to support that claim. I see evidence that there
are cases where apps wish to communicate their intentions around power
more clearly but a suspend blocker is a crude single case hammer. Today
most applications communicate their sleep/wake requirements fairly well by
sleeping, by executing code and by setting timers/alarms.

> Given this context, are you sure that suspend blockers are not the next
> step in the Real OS progression?  Or some QoS mechanism that subsumes
> suspend blockers?  However, there is a lot of negative experience
> around general-purpose QoS mechanisms -- you have to be quite careful
> in order to avoid spending more energy computing QoS than you would
> otherwise spend on the application's computations.  The usual way out of
> this trap is to abandon generality in favor of exploiting the commonly
> occurring special cases.  For all I know, raw suspend blockers might be
> the appropriate special case.

For Android possibly and I've never had any objection to Android keeping
suspend blockers in private patches. The claim is only a small number are
needed in their kernel so its a tiddly patch and the patch context will
no doubt keep it applying between releases and easy for them to maintain.

For the rest of us - I see no evidence it's generally useful. A QoS API
does appear to be generally useful but as you say you need to get the
performance right. However you can also tackle that the way we tackle
several other examples of one interface/many needs - such as schedulers,
security models and the like.

One interface to applications and one interface to drivers so that its
easy to maintain and you don't end up with hooks all over the place for
different things, then if it proves neccessary different implementations.
So yes maybe Android would use a "qos_basic" which returns -EOPNOTSUPP to
anything but a suspend blocker behaviour. The important thing about that
is that my device drivers, my applications and my other platforms don't
have to care that Android made this choice - they can still be generic
code.

That is why I used the Win16 example. The Win16 model encapsulated an
implementation into the API. Had they followed a more conventional
interface based around yielding then like MacOS they'd have had a far
smoother move to pre-emptive MT.

Alan
