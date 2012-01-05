Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab2AESTr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 13:19:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51969 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753099Ab2AESTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 13:19:45 -0500
Date: Thu, 5 Jan 2012 10:18:57 -0800
From: Greg KH <gregkh@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Tejun Heo <tj@kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Revoking filesystems [was Re: Sysfs attributes racing with
 unregistration]
Message-ID: <20120105181857.GA2555@suse.de>
References: <m1boqietiv.fsf@fess.ebiederm.org>
 <Pine.LNX.4.44L0.1201051001360.1434-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1201051001360.1434-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 10:13:31AM -0500, Alan Stern wrote:
> On Wed, 4 Jan 2012, Eric W. Biederman wrote:
> 
> > > Ted Ts'o has been talking about something similar but not the same -- a
> > > way to revoke an entire filesystem.  For example, see commit
> > > 7c2e70879fc0949b4220ee61b7c4553f6976a94d (ext4: add ext4-specific
> > > kludge to avoid an oops after the disk disappears).
> > >
> > > The use case for that is obvious and widespread: Somebody yanks out a
> > > USB drive without unmounting it first.
> > 
> > Agreed.  The best I have at the moment is a library that can wrap
> > filesystem methods to implement the hotplug bits.
> > 
> > Do you know how hard it is to remove event up to the filesystem that
> > sits on top of a block device?
> 
> I don't have a clear idea of what's involved (in particular, how to go
> from a block_device structure to a mounted filesystem).  But the place
> to do it would probably be block/genhd.c:invalidate_partition().  Ted
> can tell you if there's a better alternative.
> 
> > Do you know how hard it is to detect at mount time if a block device
> > might be hot-plugable?  We can always use a mount option here and
> > make userspace figure it out, but being to have a good default would
> > be nice.
> 
> I don't think it's possible to tell if a device is hot-unpluggable.  
> For example, the device itself might not be removable from its parent, 
> but the parent might be hot-unpluggable.  You'll probably have to 
> assume that every device can potentially be unplugged, one way or 
> another.

These days, _any_ block device is hot unplugable, what with PCI hotplug
and the like (running in a virtual machine, etc.)  So you always need to
assume that any device can go away at any point in time.

thanks,

greg k-h
