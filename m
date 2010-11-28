Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab0K1TSU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 14:18:20 -0500
Received: from adelie.canonical.com ([91.189.90.139]:33395 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab0K1TSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 14:18:17 -0500
Date: Sun, 28 Nov 2010 19:18:14 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        vaurora@redhat.com, neilb@suse.de, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 0/2] overlayfs fixes
Message-ID: <20101128191813.GC11339@shadowen.org>
References: <1290015424-5583-1-git-send-email-apw@canonical.com>
 <E1PLdPT-0003Y7-31@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1PLdPT-0003Y7-31@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 04:06:55PM +0100, Miklos Szeredi wrote:
> On Wed, 17 Nov 2010, Andy Whitcroft wrote:
> >   overlayfs: handle missing lower inodes in ovl_is_same_inode
> 
> I don't see how this could be needed.  vfs_is_same_inode() checks if
> the dentries are positive.  In that case either the upper dentry or
> the lower dentry or both must exist.

It was cirtinaly exploding in my tests without that change.  The test
case was overlaying a tmpfs over a squashfs.

> >   overlayfs: ovl_copy_up_xattr -- handle EOPNOTSUPP from vfs_listxattr
> 
> Applied.  Thanks, Andy.
> 
> I pushed an updated version based on v2.6.37-rc3 to the overlayfs.v5
> branch:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs.v5
> 
> Thanks,
> Miklos

I'll retest with that version and see if the first patch is still
required.

Thanks for the updated version.

-apw
