Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab2CEQJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:09:59 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:34166 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965Ab2CEQJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:09:57 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.136.97 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Mon, 5 Mar 2012 08:09:53 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jiri Slaby <jirislaby@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH] sysfs: Optionally count subdirectories to support buggy
 applications
Message-ID: <20120305160953.GA3870@kroah.com>
References: <20120130222717.GA6393@kroah.com>
 <m18vkoirv9.fsf@fess.ebiederm.org>
 <4F27C6EB.2070305@suse.cz>
 <m14nvc82jo.fsf@fess.ebiederm.org>
 <CA+55aFwZNdoAA9iPMiEp8-+ndgV+CtSZO4neSh_L+gd77k7-vg@mail.gmail.com>
 <m1wr87ywex.fsf@fess.ebiederm.org>
 <m1ehueyz20.fsf_-_@fess.ebiederm.org>
 <CA+55aFyNQnXrL7fWhBt4LYBuoHD_x+j=Af-N=ueFMBkymy9Rnw@mail.gmail.com>
 <CA+55aFzZX544ZDN9vN3jWMWZ=_9ZtpZ9cR6gNEzUnx9RCqR5LQ@mail.gmail.com>
 <4F54BFEC.6000206@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F54BFEC.6000206@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 02:30:20PM +0100, Jiri Slaby wrote:
> On 02/02/2012 12:18 AM, Linus Torvalds wrote:
> > On Wed, Feb 1, 2012 at 3:15 PM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> >>
> >> No extra "keep track of inode counts by hand" crap, and no idiotic
> >> config options that just make it easy to (conditionally) get things
> >> wrong. Just do it right, and do it *unconditionally* right.
> > 
> > And btw, "nlink shows number of subdirectories" for a directory entry
> > really *is* right. It's how Unix filesystems work, like it or not.
> > 
> > It's mainly lazy/bad filesystems that set nlink to 1. So the whole
> > "nlink==1" case is meant for crap like FAT etc, not for a filesystem
> > that we control and that could easily just do it right.
> > 
> > Which is why I detest that config option. It's as if you were asking the user
> > 
> >  "Do you want to make the sysfs filesystem act like crap filesystems?"
> > 
> > and kernel config time. What kind of inane question is that?
> 
> <thread resumed...>
> 
> What's going on here? I still have to revert "sysfs: Kill nlink
> counting." with today's -next to have working sensors.

I don't remember.  I thought there was a proposed patch for this issue
from Eric, but I don't see it in my queue anywhere.

Eric, what was the resolution here?

greg k-h
