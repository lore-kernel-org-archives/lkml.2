Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab1I1IU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 04:20:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48643 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab1I1IUZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 04:20:25 -0400
Subject: Re: [PATCH 0/6] [RFC] Proposal for optimistic suspend idea.
From: Peter Zijlstra <peterz@infradead.org>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        arve@android.com, markgross@thegnar.org,
        Alan Stern <stern@rowland.harvard.edu>, amit.kucheria@linaro.org,
        farrowg@sg.ibm.com, "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        linux-pm@lists.linux-foundation.org, khilman@ti.com,
        Magnus Damm <damm@opensource.se>, mjg@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 28 Sep 2011 10:19:33 +0200
In-Reply-To: <1317164216.3112.711.camel@work-vm>
References: <1317064434-1829-1-git-send-email-john.stultz@linaro.org>
	 <1317068164.1763.39.camel@twins> <1317076065.3112.539.camel@work-vm>
	 <1317119870.15383.29.camel@twins> <1317164216.3112.711.camel@work-vm>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317197973.5781.28.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-27 at 15:56 -0700, John Stultz wrote:
> > For instance anybody trying to draw to an X surface after they've been
> > told the screen is off should get kicked. (And before people go whinge
> > about d-bus having to wake all tasks to get the msgs across, which
> > wastes power; if you fix the runtime up far enough the attempt of
> > drawing could return this information.)
> > 
> > I'm not quite sure how timer-slack comes into this, because every app
> > receiving random wakeups (no matter what slack) after its been told it
> > should quiesce is a fail, with the exception of the wakeup for telling
> > it its good to go again (but that comes _after_ the system policy
> > change, so its fine).
> 
> So you're suggesting we rewrite everything in the debian package
> archives to use DBUS and abide by some sort of userland power policy?
> 
> I'll admit its a terrible straw-man, but this starts to sound like: "We
> don't need protected memory! Just rewrite all the apps so they don't
> accidentally overwrite kernel structures!"
> 
> Don't get me wrong, I do think that there are power-optimizations to be
> had using more "runtime" regulated behavior. You're right, when the
> screen is powered off, the clock applet shouldn't be trying to make X
> calls to update itself every minute.
> 
> But I think once you get away from some theoretical system, containing
> only properly behaving apps, having some tools in the kernel to enforce
> a certain type of behavior (and having the kernel's ability to handle
> more complex cases like importance inheritance) might be helpful. 

So you want to add something that sends a SIGBUS or similar to an
application if it gets a wakeup when its not supposed to? That's what
happens with memory protection, you get killed.

And yes, when Arjan did his powertop thing people did go fix up
everything that made the top.

It really isn't that hard to fix most of these apps. But the problem
with Android is that the battery usage thing it has is utterly useless.
It mostly just tells you wireless or whatnot is sucking power, not what
app is causing that. (And of course the fact that its all fucking Java
crap, which I'll refuse to touch anyway).

This results in people (me) uninstalling everything they installed since
last it worked well and then cursing this crappy shit for wasting their
time.

I really think Android is a pile of privacy violating shit, I can't say
I actually enjoy using the phone. I'm at a point where I can call with
it (without it telling google whoem all I know and where I'm at) and
browse the interwebs and have decided to screw apps, they don't work
anyway.

The only reason I'm not back to the N900 is because the Android thing is
a lot faster at rendering web (better cpu etc..).


