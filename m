Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625Ab1BRDJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 22:09:01 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41532 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932613Ab1BRDI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 22:08:56 -0500
Date: Fri, 18 Feb 2011 03:08:47 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Steven Liu <lingjiujianke@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, randy.dunlap@oracle.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        dchinner@redhat.com, liuqi <liuqi@thunderst.com>
Subject: Re: [PATCH] code cleanup on fs/super.c
Message-ID: <20110218030846.GL22723@ZenIV.linux.org.uk>
References: <AANLkTi=50m7xULN+Mob1942b+qBEgMcqUPDWSd3inan6@mail.gmail.com>
 <AANLkTim2fg5OUw2aZXA-4V4O7PUQ6T4mhoWxvjNdtYcc@mail.gmail.com>
 <20110217173615.GJ22723@ZenIV.linux.org.uk>
 <AANLkTinN1CamMpKZ5O3nDeV+LXpcMVZpxT59J7mJ5HQo@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinN1CamMpKZ5O3nDeV+LXpcMVZpxT59J7mJ5HQo@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 18, 2011 at 10:45:12AM +0800, Steven Liu wrote:
> Hi  AI Viro,
> 
>      I have saw this message, :)
> 
>      I think the nfs is using fs_type->get_sb, but it isn't using
> get_sb_bdev(or get_sb_nodev) .
>      So if the nfs cannot let
>      struct dentry *(*mount) (struct file_system_type *, int,
>                const char *, void *);
>      to replace
> 
>      int (*get_sb) (struct file_system_type *, int,
>                const char *, void *, struct vfsmount *);
>      Now, this patch cannot influence nfs normal use.
>      Because get_sb is not must use get_sb_bdev or get_sb_nodev to get mnt,
>      All the filesystem are using mount_bdev mount_nodev now, but it
> isn't called
>      by get_sb,is called by *mount. Do you agreed with me?

Sigh...  Yes, and it is irrelevant.  There's simply no reason to remove
that stuff before the next merge window, when ->get_sb() is going to go
away _anyway_, along with those helpers.  I am not saying that it can't
be done right now; there's simply no point in doing so.  I don't particulary
care about hurting out-of-tree filesystems and if we had ->mnt_devname
series in this window I'd cheerfully ripped ->get_sb() out and let them
deal with it.  However, I don't see any reasons for removing the helpers
in this cycle.  What for?  To force the (trivial) switch to ->mount() in
out-of-tree block filesystems one cycle earlier?
