Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab2BOX0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 18:26:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54596 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697Ab2BOX0e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 18:26:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Input: Add ioctl to block suspend while event queue is not empty.
Date: Thu, 16 Feb 2012 00:30:26 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        linux-input@vger.kernel.org, linux-pm@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Matthew Garrett <mjg@redhat.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
References: <1327112659-31145-1-git-send-email-arve@android.com> <20120214142540.04de41df@notabene.brown>
In-Reply-To: <20120214142540.04de41df@notabene.brown>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201202160030.26503.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 14, 2012, NeilBrown wrote:
> On Fri, 20 Jan 2012 18:24:16 -0800 Arve Hjønnevåg <arve@android.com> wrote:
> 
> > Add an ioctl, EVIOCSSUSPENDBLOCK, to block suspend while the event
> > queue is not empty. This allows userspace code to process input
> > events while the device appears to be asleep.
> > 
> > Signed-off-by: Arve Hjønnevåg <arve@android.com>
> 
> This is exactly the sort of "feature creep" that I worried about in my reply
> to Rafael's recent "autosleep" patches.
> 
> A particular issue here:  This patch allows any process that can open an
> input device to keep the device awake - by not reading an event that has
> arrived (whether due to incompetence or malice).
> 
> So either we would need strict controls on who can open /dev/input/eventX,
> or be happy that any process can disable suspend.
> Or add some extra feature-creep to provide access control.

I actually think the approach almost correct, because if there are any events
coming from a wakeup device and there is any user space client interested in
them, the kernel should really stay awake until those events are removed from
the client's queue.

So, if they are not read, either we drop them entirely, or we don't suspend
_automatically_.

The problem I have with the $subject patch is that it doesn't check if the
device is a wakeup one and it adds ioctls allowing user space to use the event
queue of a non-wakeup device as a "wakeup source".

> (or just keep this stuff out of the kernel and let a user-space daemon make
> those decisions).

Which is never going to really work, IMHO.

Realistically, do you know of any distro, vendor, whoever, who tried to
actually do that in a released product (or even in a release candidate,
or milestone, or whatever different from a prototype running only on one's
personal desktop)?  I don't.

Thanks,
Rafael
