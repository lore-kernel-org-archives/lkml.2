Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131Ab2BPW1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 17:27:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56665 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650Ab2BPW1O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 17:27:14 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [PATCH] Input: Add ioctl to block suspend while event queue is not empty.
Date: Thu, 16 Feb 2012 23:31:06 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: linux-input@vger.kernel.org, linux-pm@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Matthew Garrett <mjg@redhat.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
References: <1327112659-31145-1-git-send-email-arve@android.com> <201202160051.16011.rjw@sisk.pl> <CAMP5XgfpM8309wHMW+W0XrEYvsz6pYdcwdqxkp-Jgpbm1m5hgQ@mail.gmail.com>
In-Reply-To: <CAMP5XgfpM8309wHMW+W0XrEYvsz6pYdcwdqxkp-Jgpbm1m5hgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201202162331.07051.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 16, 2012, Arve Hjønnevåg wrote:
> 2012/2/15 Rafael J. Wysocki <rjw@sisk.pl>:
> ...
> > Still, I have one issue with adding those ioctls.  Namely, wouldn't it be
> > simpler to treat all events coming from wakeup devices as wakeup events?
> >
> 
> User-space needs to block suspend between select/poll and read for
> this to work, so an explicit call to enable this is useful.
> 
> > With the new ioctls user space can "mark" a queue of events coming out of
> > a device that's not a wakeup one as a "wakeup source", which doesn't seem to
> > be correct.
> >
> 
> OK, but I don't think this is a big problem.
> 
> > Conversely, with those ioctls user space can effectively turn events coming
> > out of a wakeup device into non-wakeup ones, which doesn't seem to be correct
> > either.
> >
> 
> I don't agree with this. There can be multiple readers on an input
> device. Only the reader that is responsible for acting on the wakeup
> event should call this ioctl.

Ah, OK.  So you envision the new ioctls as the way of saying "I'm the one
who's going to take care of those wakeup events"?  If that's the case, may
I suggest changing the names?

> > So, I think evdev client queue's wakeup source (or wakelock) should stay active
> > if there are any events in the queue and the underlying device is a wakeup one,
> 
> I don't want additional readers of the device to prevent suspend.

OK

> > i.e. device_may_wakeup() returns true for it.  Then, we won't need the new
> > ioctls at all and user space will still be able to control which events are to
> > be regarded as wakeup ones by changing the wakeup settings of the devices that
> > generate them.
> >
> 
> I don't think this is currently hooked up for most of the devices we
> have. If we do add a dynamic wakeup settings I would prefer to have an
> ioctl to set which events on a device should be enabled for wakeup (or
> just enabled) instead of switching the entire drive. That way we could
> turn off unneeded rows and columns in a key matrix.

Can you actually select what keys may wake up the system from sleep
(I mean "real sleep", when the whole system is entirely off except for wakeup
devices)?

Rafael
