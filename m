Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab0DZTZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 15:25:13 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:60155 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753917Ab0DZTZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 15:25:10 -0400
Date: Mon, 26 Apr 2010 15:25:09 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
cc: Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
       <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Magnus Damm <damm@igel.co.jp>,
       <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 2/9] PM: suspend_block: Add driver to access
  suspend blockers from user-space
In-Reply-To: <v2ld6200be21004251534y6c820e96l824f3288201a757d@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1004261518130.1764-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Apr 2010, Arve Hjønnevåg wrote:

> >> > >> > +User-space API
> >> > >> > +==============
> >> > >> > +
> >> > >> > +To create a suspend_blocker from user-space, open the suspend_blocker device:
> >> > >> > +    fd = open("/dev/suspend_blocker", O_RDWR | O_CLOEXEC);
> >> > >> > +then call:
> >> > >> > +    ioctl(fd, SUSPEND_BLOCKER_IOCTL_INIT(strlen(name)), name);
> >> > >>
> >> > >>
> >> > >> This seems like very wrong idea -- it uses different ioctl number for
> >> > >> each length AFAICT.
> >> > >
> >> > > How about specifying the name by an ordinary write() call instead of
> >> > > by an ioctl()?
> >> > >
> >> >
> >> > I prefer using ioctls. We have three operations at the moment. Init,
> >> > block and unblock. If we do init with write but block and unblock
> >> > using ioctls, it would be pretty strange. Specifying a command and
> >>
> >> Why would it be "strange"?
> >
> > Why indeed?  Using write() is the natural way to pass a data buffer
> > into the kernel, especially a variable-length buffer.
> >
> > Mixing ioctl() and write() might seem strange at first, but it has
> > plenty of precedent.  Consider adjusting the settings for a serial
> > port, for example.
> >
> That sound like to opposite situation to me. It uses ioctls for setup
> and read/write access the data stream.

Or you could say that it uses ioctls to send commands and read/write to 
pass data.  That's pretty much what you would be doing.

Let's put it another way: You find it excessively strange to do init
using write and to send commands via ioctl, but you don't find it
strange to abuse the ioctl number code for passing the string length?  
The old saying about motes and beams applies here...

If you insist on using ioctl for init, you should use the standard
convention for passing variable-length data.  The userspace program
sets up a fixed-size buffer containing a pointer to the name and the
name's length, and it passes the buffer's address as the ioctl
argument.

Alan Stern

