Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190Ab0DWQnw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 12:43:52 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49950 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758052Ab0DWQns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 12:43:48 -0400
Date: Fri, 23 Apr 2010 12:43:46 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pavel Machek <pavel@ucw.cz>
cc: Arve Hj??nnev??g <arve@android.com>, Len Brown <len.brown@intel.com>,
       <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Magnus Damm <damm@igel.co.jp>,
       <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 2/9] PM: suspend_block: Add driver to access
 suspend blockers from user-space
In-Reply-To: <20100423084349.GC1573@ucw.cz>
Message-ID: <Pine.LNX.4.44L0.1004231242460.1777-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Apr 2010, Pavel Machek wrote:

> Hi!
> 
> > Add a misc device, "suspend_blocker", that allows user-space processes
> > to block auto suspend. The device has ioctls to create a suspend_blocker,
> > and to block and unblock suspend. To delete the suspend_blocker, close
> > the device.
> > 
> > Signed-off-by: Arve Hj??nnev??g <arve@android.com>
> 
> > --- a/Documentation/power/suspend-blockers.txt
> > +++ b/Documentation/power/suspend-blockers.txt
> > @@ -95,3 +95,20 @@ if (list_empty(&state->pending_work))
> >  else
> >  	suspend_block(&state->suspend_blocker);
> >  
> > +User-space API
> > +==============
> > +
> > +To create a suspend_blocker from user-space, open the suspend_blocker device:
> > +    fd = open("/dev/suspend_blocker", O_RDWR | O_CLOEXEC);
> > +then call:
> > +    ioctl(fd, SUSPEND_BLOCKER_IOCTL_INIT(strlen(name)), name);
> 
> 
> This seems like very wrong idea -- it uses different ioctl number for
> each length AFAICT.

How about specifying the name by an ordinary write() call instead of
by an ioctl()?

Alan Stern

