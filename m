Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090Ab0D0WDN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 18:03:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49449 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932079Ab0D0WDK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 18:03:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [linux-pm] [PATCH 2/9] PM: suspend_block: Add driver to access suspend blockers from user-space
Date: Wed, 28 Apr 2010 00:03:31 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc4-rjw; KDE/4.3.5; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
       linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Magnus Damm <damm@igel.co.jp>,
       linux-pm@lists.linux-foundation.org
References: <Pine.LNX.4.44L0.1004271432280.1850-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1004271432280.1850-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201004280003.31668.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 April 2010, Alan Stern wrote:
> On Mon, 26 Apr 2010, Arve Hjønnevåg wrote:
> 
> > > If you insist on using ioctl for init, you should use the standard
> > > convention for passing variable-length data.  The userspace program
> > > sets up a fixed-size buffer containing a pointer to the name and the
> > > name's length, and it passes the buffer's address as the ioctl
> > > argument.
> > 
> > Are you sure that is the standard? I searched for ioctls with NAME in
> > their name and only found one that passed the name that way. The rest
> > used fixed length string buffers, or passed the buffersize to _IOC
> > like I do. For instance, input.h has ioctls to read string and
> > bitmasks where user space specify the buffer size as an argument to
> > the ioctl macro. These pass data from the kernel to user space, but I
> > don't passing a string length is any worse than passing a buffer size.
> 
> You're right.  Okay, I withdraw my objection.

In the meantime, though, I thought that the suspend blocker might be created
by _open() if we found a way to automatically choose a name for it.  That'd be
kind of logical, since it's later destroyed by _release().

So, what about using the name of the process that opened the special device
file (or that name with'0' appended, or generally with a number appended) as
the suspend blocker name?

Rafael
