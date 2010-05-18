Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab0ERXSD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 19:18:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43893 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218Ab0ERXSA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 19:18:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 7)
Date: Wed, 19 May 2010 01:19:07 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Brian Swetland <swetland@google.com>,
       Daniel Walker <dwalker@fifo99.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Matthew Garrett <mjg@redhat.com>
References: <1273810273-3039-1-git-send-email-arve@android.com> <201005190034.26085.rjw@sisk.pl> <AANLkTime0yZ_t32m8WjqJEtSeNlBJYZy15X8HwKzMqOl@mail.gmail.com>
In-Reply-To: <AANLkTime0yZ_t32m8WjqJEtSeNlBJYZy15X8HwKzMqOl@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201005190119.07710.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 May 2010, Arve Hjønnevåg wrote:
> 2010/5/18 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Wednesday 19 May 2010, Arve Hjønnevåg wrote:
> >> 2010/5/18 Rafael J. Wysocki <rjw@sisk.pl>:
> >> > On Tuesday 18 May 2010, Arve Hjønnevåg wrote:
> >> >> 2010/5/18 Rafael J. Wysocki <rjw@sisk.pl>:
> >> >> > On Tuesday 18 May 2010, Arve Hjønnevåg wrote:
> >> >> >> 2010/5/17 Rafael J. Wysocki <rjw@sisk.pl>:
> >> >> >> > On Monday 17 May 2010, Arve Hjønnevåg wrote:
> >> >> >> >> 2010/5/14 Rafael J. Wysocki <rjw@sisk.pl>:
> >> >> >> >> > On Friday 14 May 2010, Arve Hjønnevåg wrote:
> >> >> >> >> >> This patch series adds a suspend-block api that provides the same
> >> >> >> >> >> functionality as the android wakelock api. This version has some
> >> >> >> >> >> changes from, or requested by, Rafael. The most notable changes are:
> >> >> >> >> >> - DEFINE_SUSPEND_BLOCKER and suspend_blocker_register have been added
> >> >> >> >> >>   for statically allocated suspend blockers.
> >> >> >> >> >> - suspend_blocker_destroy is now called suspend_blocker_unregister
> >> >> >> >> >> - The user space mandatory _INIT ioctl has been replaced with an
> >> >> >> >> >>   optional _SET_NAME ioctl.
> >> >> >> >> >>
> >> >> >> >> >> I kept the ack and reviewed by tags on two of the patches even though
> >> >> >> >> >> there were a few cosmetic changes.
> >> >> >> >> >
> >> >> >> >> > Thanks for the patches, I think they are in a pretty good shape now.
> >> >> >> >> >
> >> >> >> >> > That said, I'd like the changelogs to be a bit more descriptive, at least for
> >> >> >> >> > patch [1/8].  I think it should explain (in a few words) what the purpose of
> >> >> >> >> > the feature is and what problems it solves that generally a combination of
> >> >> >> >> > runtime PM and cpuidle is not suitable for in your opinion.  IOW, why you
> >> >> >> >> > think we need that feature.
> >> >> >> >> >
> >> >> >> >>
> >> >> >> >> How about:
> >> >> >> >>
> >> >> >> >> PM: Add opportunistic suspend support.
> >> >> >> >
> >> >> >> > "PM: Opportunistic suspend support" would be sufficient IMO.
> >> >> >> >
> >> >> >> > Now, I'd start with the motivation.  Like "Power management features present
> >> >> >> > in the current mainline kernel are insufficient to get maximum possible energy
> >> >> >> > savings on some platforms, such as Android, because ..." (here go explanations
> >> >> >> > why this is the case in your opinion).
> >> >> >> >
> >> >> >> > Next, "To allow Android and similar platforms to save more energy than they
> >> >> >> > currently can save using the mainline kernel, introduce a mechanism by which
> >> >> >> > the system is automatically suspended (i.e. put into a system-wide sleep state)
> >> >> >> > whenever it's not doing useful work, called opportunistic suspend".
> >> >> >> >
> >> >> >> > "For this purpose introduce the suspend blockers framework allowing the
> >> >> >> > kernel's power management subsystem to decide when it is desirable to suspend
> >> >> >> > the system (i.e. when useful work is not being done).  Add an API that ..."
> >> >> >> >
> >> >> >>
> >> >> >> PM: Opportunistic suspend support.
> >> >> >>
> >> >> >> Power management features present in the current mainline kernel are
> >> >> >> insufficient to get maximum possible energy savings on some platforms,
> >> >> >> such as Android, because low power states can only safely be entered
> >> >> >> from idle.
> >> >> >
> >> >> > Do you mean CPU low-power states or system low-power states here?
> >> >> >
> >> >> I think either.
> >> >
> >> > The statement is not true for system low-power states (or sleep states),
> >> > because generally (ie. on many platforms) they aren't entered from idle.
> >> > Suspend is for entering them.
> >> >
> >> I don't think that makes my statement false. If you can only safely
> >> enter low power states from idle, but some low power states cannot be
> >> entered from idle, then it follows that you cannot safely enter those
> >> low power states.
> >
> > Define "safely", then.
> >
> OK. Is this clearer:

Not really.

> Power management features present in the current mainline kernel are
> insufficient to get maximum possible energy savings on some platforms,
> such as Android, because some wakeup events must work at all times
> which means that low power states can only safely be entered from idle.

It's not clear what you mean by "some wakeup events must work at all times"
and what "safely" means.

> Suspend, in its current form, cannot be used, since wakeup events that
> occur right after initiating suspend will not be processed until another
> possibly unrelated event wake up the system again.

Well, I _guess_ I know what you're trying to say, but I'm not sure if that's
the core of the problem the patchset is supposed to address.

The problem, as I see it, is really two-fold.

First, to save as much energy as reasonably possible you need to put everything
except for memory (ie. I/O devices and CPUs) into low-power states and let that
stay in these low-power states for as long as reasonably possible, right?

Second, you need the system to _always_ respond to some _specific_ events
regardless of its current state, correct?

Now, at present, we can put I/O devices and the CPU into low-power states
at the same time in two ways: (1) by using runtime PM and cpuidle and (2) by
suspending the system.  Unfortunately, none of these approaches is ideal,
because (1) is vulnerable to periodic timers and polling apps (and CPU-bound
apps) and (2) doesn't guarantee that all events you care about will be
responded to.

The proposed solution is to use suspend with an additional mechanism that
will prevent the events that have to be responded to from being lost.  This
additional mechanism is suspend blockers.

Is this correct?

> >> > So, there is a difference and the explanation can go like this: "... to achieve
> >> > maximum energy savings one has to put all I/O devices and the CPU into
> >> > low-power states, but the CPU can only be put into a low-power state from
> >> > idle.  This, in turn, means that the CPU leaves the low-power state on
> >> > interrupts triggered by periodic timers and user space processes that use
> >> > polling.  It turns out, however, that many of these events causing the CPU to
> >> > leave the low-power state aren't essential for the desired system functionality
> >> > and from the power management point of view it would be better if they didn't
> >> > occur".
> >>
> >> This only explain why we still want to use suspend on systems that can
> >> enter the same power states from idle and suspend.
> >
> > Sorry, I'm confused now.  Isn't that why you do that on Android?
> >
> 
> Yes, but it is not the only reason to use opportunistic support. It is
> way more important to have opportunistic suspend support if the
> hardware can enter lower power states from suspend than idle.

Sure, but you can add something like "There also are systems where some
devices cannot be put into low-power states without suspending the entire
system (or the low-power states available to them without suspending the
entire system are substantially shallower than the low-power states they are
put into when the entire system is suspended), so the system have to be
suspended as a whole to achieve the maximum energy savings".

Rafael
