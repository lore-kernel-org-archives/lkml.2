Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043Ab0DXFz3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 01:55:29 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:52306 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750940Ab0DXFz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 01:55:27 -0400
Date: Sat, 24 Apr 2010 07:55:23 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Len Brown <len.brown@intel.com>,
       linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Magnus Damm <damm@igel.co.jp>,
       linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [PATCH 2/9] PM: suspend_block: Add driver to access
 suspend blockers from user-space
Message-ID: <20100424055523.GC2290@elf.ucw.cz>
References: <20100423084349.GC1573@ucw.cz>
 <Pine.LNX.4.44L0.1004231242460.1777-100000@iolanthe.rowland.org>
 <i2zd6200be21004232020t46f4de0ct93b94e2bd67a6e76@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <i2zd6200be21004232020t46f4de0ct93b94e2bd67a6e76@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2010-04-23 20:20:47, Arve Hj?nnev?g wrote:
> On Fri, Apr 23, 2010 at 9:43 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Fri, 23 Apr 2010, Pavel Machek wrote:
> >
> >> Hi!
> >>
> >> > Add a misc device, "suspend_blocker", that allows user-space processes
> >> > to block auto suspend. The device has ioctls to create a suspend_blocker,
> >> > and to block and unblock suspend. To delete the suspend_blocker, close
> >> > the device.
> >> >
> >> > Signed-off-by: Arve Hj??nnev??g <arve@android.com>
> >>
> >> > --- a/Documentation/power/suspend-blockers.txt
> >> > +++ b/Documentation/power/suspend-blockers.txt
> >> > @@ -95,3 +95,20 @@ if (list_empty(&state->pending_work))
> >> >  else
> >> >     suspend_block(&state->suspend_blocker);
> >> >
> >> > +User-space API
> >> > +==============
> >> > +
> >> > +To create a suspend_blocker from user-space, open the suspend_blocker device:
> >> > +    fd = open("/dev/suspend_blocker", O_RDWR | O_CLOEXEC);
> >> > +then call:
> >> > +    ioctl(fd, SUSPEND_BLOCKER_IOCTL_INIT(strlen(name)), name);
> >>
> >>
> >> This seems like very wrong idea -- it uses different ioctl number for
> >> each length AFAICT.
> >
> > How about specifying the name by an ordinary write() call instead of
> > by an ioctl()?
> >
> 
> I prefer using ioctls. We have three operations at the moment. Init,
> block and unblock. If we do init with write but block and unblock
> using ioctls, it would be pretty strange. Specifying a command and

Why would it be "strange"?

> argument in a string to write is more complicated to parse than using
> ioctls.

More complicated to parse?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
