Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425Ab0IBVmg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:42:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142Ab0IBVme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:42:34 -0400
Date: Thu, 2 Sep 2010 17:42:15 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de,
        viro@zeniv.linux.org.uk, jblunck@suse.de, hch@infradead.org
Subject: Re: [PATCH 5/5] union: hybrid union filesystem prototype
Message-ID: <20100902214215.GB16004@shell>
References: <20100826183340.027591901@szeredi.hu> <20100826183507.402136609@szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100826183507.402136609@szeredi.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 08:33:45PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> This union filesystem is a hybrid of entirely filesystem based
> (unionfs, aufs) and entierly VFS based (union mounts) solutions.
> 
> The dentry tree is duplicated from the underlying filesystems, this
> enables fast cached lookups without adding special support into the
> VFS.  This uses slightly more memory than union mounts, but dentries
> are relatively small.
> 
> Inode structures are only duplicated for directories.  Regular files,
> symlinks and special files each share a single inode.  This means that
> locking victim for unlink is a quasi-filesystem lock, which is
> suboptimal, but could be worked around in the VFS.
> 
> Opening non directories results in the open forwarded to the
> underlying filesystem.  This makes the behavior very similar to union
> mounts (with the same limitations vs. fchmod/fchown on O_RDONLY file
> descriptors).
> 
> Usage:
> 
>   mount -t union -olowerdir=/union/lower,upperdir=/union/upper union /mnt/union
> 
> Supported:
> 
>  - all operations
> 
> Missing:
> 
>  - upgrade credentials for copy-up
>  - ensure that filesystems part of the union are not modified outside
>    the union

Just a note that the infrastructure I wrote to do this last bullet
point for union mounts (hard read-only count plus mount checks) is
completely compatible with hybrid union fs.

-VAL
