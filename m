Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762Ab2FPL1M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 07:27:12 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:60455 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756477Ab2FPL1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 07:27:06 -0400
Date: Sat, 16 Jun 2012 12:30:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        ksummit-2012-discuss@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2012-discuss] [ATTEND or not ATTEND] That's the
 question!
Message-ID: <20120616123032.251dd101@pyramind.ukuu.org.uk>
In-Reply-To: <20120615233413.GB8894@kroah.com>
References: <alpine.LFD.2.02.1206152313310.3086@ionos>
	<20120615233413.GB8894@kroah.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2012 16:34:13 -0700
Greg KH <greg@kroah.com> wrote:

> On Sat, Jun 16, 2012 at 12:56:36AM +0200, Thomas Gleixner wrote:
> > So the main questions I want to raise on Kernel Summit are:
> > 
> >    - How do we cope with the need to review the increasing amount of
> >      (insane) patches and their potential integration?

One possibility perhaps is to throw insane stuff at submaintainers or
folks learning that path. Once they've achieved some kind of sanity with
the submaintainer then it can bother the real maintainer.

And for a lot of the insane stuff we should just say no (*). People can
maintain it out of tree and there is a point at which some work is best
done out of tree, and some specialist stuff is best kept out of the main
tree if it harms the mainstream too much.

(*) politely. So not by taking lessons from Linus.
 
> That's a very good question, and I've been wondering if someone is
> trying to flood us with crap submissions just to try to DoS us and slow
> us down.  If not, it's an interesting "attack" vector onto our
> development process that we need to be able to handle better.

There are a small number of very large businesses that generate a lot of
the money in the server space. They have individual needs and the money
tends to drive chunks of kernel development. Thats both a bad and a good.
The bad is they are trying to get it to do what they need, now and
without planning for the long term properly. The good is that they are
paying developers who otherwise might be working on other stuff.

It's a parallel IMHO of the "distribution people sucked everyone away and
then realised they'd dug a huge hole" problem but with new actors.

We also have a large consumer electronics and now android ecosystem much
of which is made up of companies and people whose business history and
business model for all products has always been

- make it boot
- make it usable
- ship it
- run 

they have little incentive to share, they have no interest in the longer
term, and it's often not rational economics for them to clean up their
code and upstream it because it just helps their rivals, and besides the
part is now 6 months old so obsolete in their world.

For a lot of hardware the only way that is going to get fixed is if

a) it is easier to do the job right than hack it up
b) when the hardware vendors are more involved and have longer term plans
c) their customers start to demand it in order to be up and running very
fast (ie there is heavy consolidation in the platform)

It's not in these little "hack it/ship it" houses interest to care about
making a part work well long term, because they have no particular loyalty
to any component or supplier, and can charge twice if they do the work
twice anyway.

> >    - How do we prevent further insanity to known problem spaces (like
> >      cpu hotplug) without stopping progress?
> 
> Progress can slow, if we want it to, in some areas, just to let people
> get the time to fix up the issues we currently have.  That saves time in
> the long run, but requires that someone make it very clear as to what is
> going on and how it will change in the future.

There are also a couple of areas (chunks of VM perhaps is one) where it
might actually be quicker to shoot the patient and breed a replacement.
Possibly however that's one of the areas that getting someone
mathematical involved to do more rigorous modelling of the behaviour
might be better. I know looking at what comes out of the VM to the block
layer.. it ain't pretty at times.

> But, both of these are great things to talk about, I like it.
> 
> > A side question, but definitely related is:
> > 
> >    - How do we handle "established maintainers" who are mainly
> >      interested in their own personal agenda and ignoring justified
> >      criticism just because they can?

More often than not it's because they believe their agenda is right.
E.g. I'm firmly of the opinion that 99% of users would be better off if we
took all the current scheduler nonsense and replaced it with a lightly
tweaked version of Ingo's original O(1) scheduler.

I don't think Ingo and Peter have "persona" agendas in this area they are
doing what they think is right and dealing with the needs of big
enterprise and where most of the money is.

I have a suspicion that two things are going to correct chunks of this
over time anyway
- handheld/phone/tablet
- the need for very thin virtualisation

> The wonderful, "how do we remove a maintainer who isn't working out"
> problem.  It's a tough one, I don't think we really have any standard
> way.  Luckily in the past, the insane ones went away on their own :)

We have current problems and they are often caused by the maintainer in
question having other commitments that they consider more important (and
probably are in some cases).

One thing that seems to be working well are all the areas that have two
or more maintainers. As a simple statistical fault tolerance they don't
generally both have newborns, get the flu, change job or get yanked into
a critical customer problem by their employer on the same week.

Right now we are doing it for real in some areas, and via the "screw
this, mail Andrew Morton" process for others, plus Linus fields some of
the really dumb ones. We could formalise some of that a bit more and
encourage more maintainers to actual team up with one of the other
contributors they trust.

(And we probably need to clone DaveM or get him to delegate more 8))

And we need about ten extra GregKH's if anyone has spares

Alan
--
'Go go go Gregzilla'
