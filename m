Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088Ab2AESgJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 13:36:09 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37896 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099Ab2AESgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 13:36:08 -0500
Date: Thu, 5 Jan 2012 10:36:02 -0800
From: Tejun Heo <tj@kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>, Alan Stern <stern@rowland.harvard.edu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Revoking filesystems [was Re: Sysfs attributes racing with
 unregistration]
Message-ID: <20120105183602.GE18486@google.com>
References: <m1ehvecf23.fsf@fess.ebiederm.org>
 <Pine.LNX.4.44L0.1201051133490.1434-100000@iolanthe.rowland.org>
 <20120105182752.GC26382@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120105182752.GC26382@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ted.

On Thu, Jan 05, 2012 at 01:27:52PM -0500, Ted Ts'o wrote:
> So it's really more of a filesystem force-umount method.  I could
> imagine that this could also be used to extend the functionality of
> umount(2) so that the MNT_FORCE flag could be used with non-NFS file
> systems as well as NFS file systems.

I think these are two separate mechanisms.  Filesystems need to be
able to handle IO errors no matter what and underlying device going
away is the same situation.  There's no reason to mix that with force
unmount.  That's a separate feature and whether to force unmount
filesystem on device removal or permanent failure is a policy decision
which belongs to userland - ie. if such behavior is desired, it should
be implemented via udev/udisk instead of hard coded logic in kernel.

I don't know enough to decide whether such forced unmount is a useful
feature tho.  It can be neat for development but is there any real
necessity for the feature?

> [1] Interesting question: do we convert an mmap region to an anonymous
> region and perhaps notify the user out of band this has happened?  Or
> do we just make the mapping disappear and nuke the process with a SEGV
> if it attempts to access it?

FWIW, I vote for SIGBUS similarly to the way we handle mmap
vs. truncate.

Thanks.

-- 
tejun
