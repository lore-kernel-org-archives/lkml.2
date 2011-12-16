Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760481Ab1LPShT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 13:37:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40479 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755763Ab1LPShO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 13:37:14 -0500
Date: Fri, 16 Dec 2011 10:36:13 -0800
From: Greg KH <gregkh@suse.de>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: tty idle time and hooking inode_ops from a chardev
Message-ID: <20111216183613.GA3612@suse.de>
References: <4EEB774D.1070407@cfl.rr.com>
 <20111216175735.GA5404@suse.de>
 <4EEB8C4A.5080809@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EEB8C4A.5080809@cfl.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 01:22:02PM -0500, Phillip Susi wrote:
> On 12/16/2011 12:57 PM, Greg KH wrote:
> >Don't worry about it, as it's not really an important issue at all? :)
> 
> That's why it has been broken for years; because nobody cares enough
> about it to fix it, but that kind of thing irks me.
> 
> >It seems that your userspace programs aren't properly measuring the
> >correct thing here, it's not that the kernel is doing something wrong,
> >right?
> 
> I thought so at first, but it appears that the tty layer was
> originally written specifically to work this way.

But you said that your userspace programs are opening the wrong tty
device for what you are trying to look at, right?

> >And atime on a character node is pretty undefined, isn't it?
> 
> Is it?  I would have thought so but after looking at all of this
> code, it looks like it is one of those things that has just been
> around for decades, but nobody knows about, kind of like FIONREAD.
> 
> I wonder if that's how who has always worked going back to AT&T
> Unix. If it is, then I'd like to stick with it ( but fix it ) rather
> than say, add an ioctl to read the idle time and change coreutils to
> use that instead.

That's not "fixing" it at all, adding an ioctl is the same as adding a
new system call, do you really think that is ok here?

As you are opening the tty node once, that's when atime is set, right?
The fact that you keep it open still keeps the atime to the original
open time, you aren't supposed to check for every single read/write of
the node once it was opened.

But to be sure, what does POSIX say about this?

thanks,

greg k-h
