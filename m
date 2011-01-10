Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814Ab1AJIIn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 03:08:43 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:41584 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751552Ab1AJIIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 03:08:41 -0500
Date: Mon, 10 Jan 2011 09:08:39 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH 01/17] pramfs: documentation
Message-ID: <20110110080839.GA16066@atrey.karlin.mff.cuni.cz>
References: <4D25AF02.60208@gmail.com> <AANLkTimGt5hi+TpFHWxktJEg3tcDQmmARdqFqzAt++OQ@mail.gmail.com> <4D2777FC.6040509@gmail.com> <AANLkTimtvYfHXG=rMLbFLzVaKbfB6nrj_ZE1AH4quRG2@mail.gmail.com> <4D281D65.1070102@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D281D65.1070102@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 07/01/2011 22:59, Tony Luck wrote:
> > On Fri, Jan 7, 2011 at 12:30 PM, Marco Stornelli
> > <marco.stornelli@gmail.com> wrote:
> >> constraint). About the errors: pramfs does not maintain file data in the
> >> page caches for normal file I/O, so no writeback, the read/write
> >> operation are done with direct io and they are always sync. The data are
> >> write protected in hw when the arch provide this facility (x86 does).
> >> Inode contains a checksum and when there are problems they are marked as
> >> bad. Superblock contains checksum and there is a redundant superblock.
> > 
> > But you can still get pramfs inconsistencies if the system crashes at an
> > inopportune moment. E.g. when making files you write the new inode to
> > pramfs, and then you insert the entry into the directory. A crash between
> > these two operations leaves an allocated inode that doesn't appear in
> > any directory.  Without a fsck option, it will be hard to see that you have
> > this problem, and your only recovery option is to wipe *all* files by making
> > a new filesystem.
> 
> Is it a problem if you lost some logs? However do you expect that fsck
> in this case will drop the inode?

Ask it the other way around.

What is persistent filesystem good for when it is only persistent
sometimes?

You'd be better running ext2 over special block device, it is quite simple.


									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
