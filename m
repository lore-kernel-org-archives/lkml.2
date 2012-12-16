Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab2LPBxE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 20:53:04 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:57490 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab2LPBxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 20:53:02 -0500
Date: Sun, 16 Dec 2012 01:53:00 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: /usr/include/linux/errno.h:1:23: fatal error: asm/errno.h: No
 such file or directory
Message-ID: <20121216015300.GA4939@ZenIV.linux.org.uk>
References: <CAAJw_ZueeeNwCGnQD75=AcNwLxWBM3hEvq3LYXEiMcz4Sibk-w@mail.gmail.com>
 <20121216012816.GZ4939@ZenIV.linux.org.uk>
 <CAAJw_ZsM+nWJc8nu7GiXrbOMftwwVvyYDczO6yBuCEGyoCrT8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAJw_ZsM+nWJc8nu7GiXrbOMftwwVvyYDczO6yBuCEGyoCrT8g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2012 at 09:39:01AM +0800, Jeff Chua wrote:
> On Sun, Dec 16, 2012 at 9:28 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > On Sun, Dec 16, 2012 at 09:23:38AM +0800, Jeff Chua wrote:
> >> How should the symbolic links be setup to compile the latest kernel?
> >>
> >>
> >> Currently I had these links and kernels compiled fine until 2 days ago.
> >>
> >>          asm -> /usr/src/linux/include/uapi/asm-generic/
> >>          asm-generic -> /usr/src/linux/include/uapi/asm-generic
> >>          linux -> /usr/src/linux/include/uapi/linux
> >
> > What symlinks?  /usr/include/* should not contain any symlinks into
> > the kernel source.  At all.
> 
> Al,
> 
> Oh, perhaps I'm having the right setup. Where should I get the kernel
> headers.

>From your libc.  Which ought to have its own copies, normally coming from
make headers_install in kernel source.  And yes, it had been that way
for many years by now.  Userland should *not* blindly grab the kernel
headers.

Incidentally, your 'asm' is obviously bogus - the headers that should end
up there ought to come from arch/<whatever>/include/uapi/asm (and _not_
by pointing a symlink to it); yours points to the place where asm-generic
ones ought to have been copied from.
