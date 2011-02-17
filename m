Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267Ab1BQRZh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 12:25:37 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:40863 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500Ab1BQRZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 12:25:34 -0500
Date: Thu, 17 Feb 2011 12:25:23 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Liu <lingjiujianke@gmail.com>, viro@zeniv.linux.org.uk,
        randy.dunlap@oracle.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, dchinner@redhat.com,
        liuqi <liuqi@thunderst.com>
Subject: Re: [PATCH] code cleanup on fs/super.c
Message-ID: <20110217172523.GJ26780@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Steven Liu <lingjiujianke@gmail.com>, viro@zeniv.linux.org.uk,
	randy.dunlap@oracle.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, dchinner@redhat.com,
	liuqi <liuqi@thunderst.com>
References: <AANLkTi=50m7xULN+Mob1942b+qBEgMcqUPDWSd3inan6@mail.gmail.com>
 <AANLkTim2fg5OUw2aZXA-4V4O7PUQ6T4mhoWxvjNdtYcc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTim2fg5OUw2aZXA-4V4O7PUQ6T4mhoWxvjNdtYcc@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 08:20:31AM -0800, Linus Torvalds wrote:
> On Thu, Feb 17, 2011 at 12:59 AM, Steven Liu <lingjiujianke@gmail.com> wrote:
> >
> >   Clean up the unsed code on fs/super.c, all filesystem using mount_bdev
> >   and mount_nodev to replace get_sb_bdev and get_sb_nodev.
> 
> There might easily be external modules that still use this.
> 
> Also, if you do this, then the same patch would also need to remove
> the declarations and the documentation entry, so that there is no sign
> at all of those functions in the whole kernel tree.

The documentation update should just state that previous users of
get_sb_bdev() and get_sb_bdev() can and should just use mount_bdev()
and mount_nodev() instead.  The lines of code in the get_sb_*()
functions that do this:

	  mnt->mnt_root = root;
	  mnt->mnt_sb = root->d_sb;

Actually aren't necessary, since these functions are used in a
filesystem's file_system_type->mount() function, and vfs_kern_mount(),
which calls the type->mount() function, already does the above call.

So telling external modules that if you use get_sb_bdev(), you should
use mount_bdev() instead, should be just fine.

						- Ted


