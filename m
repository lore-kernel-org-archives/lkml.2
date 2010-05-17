Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab0EQUjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 16:39:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38537 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755766Ab0EQUjV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 16:39:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 7)
Date: Mon, 17 May 2010 22:40:35 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Brian Swetland <swetland@google.com>
References: <1273810273-3039-1-git-send-email-arve@android.com> <201005162142.39343.rjw@sisk.pl> <AANLkTinP68yHYfVCW-urCrRbeSb0Mlz8JsvAs-FKoUPZ@mail.gmail.com>
In-Reply-To: <AANLkTinP68yHYfVCW-urCrRbeSb0Mlz8JsvAs-FKoUPZ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201005172240.35742.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 May 2010, Arve Hjønnevåg wrote:
> 2010/5/16 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Friday 14 May 2010, Arve Hjønnevåg wrote:
> >> This patch series adds a suspend-block api that provides the same
> >> functionality as the android wakelock api. This version has some
> >> changes from, or requested by, Rafael. The most notable changes are:
> >> - DEFINE_SUSPEND_BLOCKER and suspend_blocker_register have been added
> >>   for statically allocated suspend blockers.
> >> - suspend_blocker_destroy is now called suspend_blocker_unregister
> >> - The user space mandatory _INIT ioctl has been replaced with an
> >>   optional _SET_NAME ioctl.
> >>
> >> I kept the ack and reviewed by tags on two of the patches even though
> >> there were a few cosmetic changes.
> >
> > I have one more comment, sorry for that.
> >
> > Namely, if /sys/power/policy is set to "opportunistic" and "mem" is written
> > into /sys/power/state and there are no suspend blockers present except for
> > the main blocker (and the blockers used only for statistics), the system won't
> > be able to go out of an infinit suspend-resume loop (or at least it seems
> > so from reading the code).
> >
> > I think we should prevent that from happening somehow.
> >
> 
> It should get out of that loop as soon as someone blocks suspend. If
> someone is constantly aborting suspend without using a suspend blocker
> it will be very inefficient, but it should still work.

Well, the scenario I have in mind is the following.  Someone wants to check
the feature and simply writes "opportunistic" to /sys/power/policy and "mem" to
/sys/power/state without any drivers or apps that use suspend blockers.

How in that case is the system supposed to break out of the suspend-resume loop
resulting from this?  I don't see right now, because the main blocker is
inactive, there are no other blockers that can be activated and it is next to
impossible to write to /sys/power/state again.

Rafael
