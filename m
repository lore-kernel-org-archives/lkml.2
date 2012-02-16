Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab2BPFYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 00:24:37 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42050 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab2BPFYd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 00:24:33 -0500
MIME-Version: 1.0
In-Reply-To: <201202160051.16011.rjw@sisk.pl>
References: <1327112659-31145-1-git-send-email-arve@android.com>
	<201202120028.23364.rjw@sisk.pl>
	<CAMP5XgfrG=3qeFasg4prBu88-Ox59_PtFw-rpgb=PN=uo6VPuw@mail.gmail.com>
	<201202160051.16011.rjw@sisk.pl>
Date: Wed, 15 Feb 2012 21:24:31 -0800
Message-ID: <CAMP5XgfpM8309wHMW+W0XrEYvsz6pYdcwdqxkp-Jgpbm1m5hgQ@mail.gmail.com>
Subject: Re: [PATCH] Input: Add ioctl to block suspend while event queue is
 not empty.
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-input@vger.kernel.org, linux-pm@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Matthew Garrett <mjg@redhat.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/15 Rafael J. Wysocki <rjw@sisk.pl>:
...
> Still, I have one issue with adding those ioctls.  Namely, wouldn't it be
> simpler to treat all events coming from wakeup devices as wakeup events?
>

User-space needs to block suspend between select/poll and read for
this to work, so an explicit call to enable this is useful.

> With the new ioctls user space can "mark" a queue of events coming out of
> a device that's not a wakeup one as a "wakeup source", which doesn't seem to
> be correct.
>

OK, but I don't think this is a big problem.

> Conversely, with those ioctls user space can effectively turn events coming
> out of a wakeup device into non-wakeup ones, which doesn't seem to be correct
> either.
>

I don't agree with this. There can be multiple readers on an input
device. Only the reader that is responsible for acting on the wakeup
event should call this ioctl.

> So, I think evdev client queue's wakeup source (or wakelock) should stay active
> if there are any events in the queue and the underlying device is a wakeup one,

I don't want additional readers of the device to prevent suspend.

> i.e. device_may_wakeup() returns true for it.  Then, we won't need the new
> ioctls at all and user space will still be able to control which events are to
> be regarded as wakeup ones by changing the wakeup settings of the devices that
> generate them.
>

I don't think this is currently hooked up for most of the devices we
have. If we do add a dynamic wakeup settings I would prefer to have an
ioctl to set which events on a device should be enabled for wakeup (or
just enabled) instead of switching the entire drive. That way we could
turn off unneeded rows and columns in a key matrix.

-- 
Arve Hjønnevåg
