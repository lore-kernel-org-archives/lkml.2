Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933742Ab1CaDJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 23:09:32 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:28792 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932389Ab1CaDJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 23:09:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkIFABDuk015LK5JTmdsb2JhbAClVgsBARsFAyMliHm1WA2FXQSTBQ
Date: Thu, 31 Mar 2011 14:09:26 +1100
From: Dave Chinner <david@fromorbit.com>
To: Sage Weil <sage@newdream.net>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mszeredi@suse.cz
Subject: Re: [PATCH 4/7] vfs: push dentry_unhash on rename_dir into file
 systems
Message-ID: <20110331030926.GB30279@dastard>
References: <1301522968-4382-1-git-send-email-sage@newdream.net>
 <1301522968-4382-5-git-send-email-sage@newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301522968-4382-5-git-send-email-sage@newdream.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 03:09:25PM -0700, Sage Weil wrote:
> Only a few file systems need this.  Start by pushing it down into each
> rename method so that it can be dealt with on a per-fs basis.

What is the criteria for a filesystem needing this?

> Signed-off-by: Sage Weil <sage@newdream.net>
> ---
>  fs/9p/vfs_inode.c       |    3 +++
>  fs/affs/namei.c         |    3 +++
>  fs/afs/dir.c            |    3 +++
>  fs/bfs/dir.c            |    3 +++
>  fs/btrfs/inode.c        |    3 +++
>  fs/ceph/dir.c           |    3 +++
>  fs/cifs/inode.c         |    3 +++
>  fs/coda/dir.c           |    3 +++
>  fs/ecryptfs/inode.c     |    3 +++
>  fs/exofs/namei.c        |    3 +++
>  fs/ext2/namei.c         |    3 +++
>  fs/ext3/namei.c         |    3 +++
>  fs/ext4/namei.c         |    3 +++
>  fs/fat/namei_msdos.c    |    3 +++
>  fs/fat/namei_vfat.c     |    3 +++
>  fs/fuse/dir.c           |    4 ++++
>  fs/gfs2/ops_inode.c     |    3 +++
>  fs/hfs/dir.c            |    3 +++
>  fs/hostfs/hostfs_kern.c |    3 +++
>  fs/hpfs/namei.c         |    4 ++++
>  fs/jffs2/dir.c          |    3 +++
>  fs/jfs/namei.c          |    3 +++
>  fs/libfs.c              |    3 +++
>  fs/logfs/dir.c          |    3 +++
>  fs/minix/namei.c        |    3 +++
>  fs/namei.c              |    5 +----
>  fs/ncpfs/dir.c          |    3 +++
>  fs/nfs/dir.c            |    3 +++
>  fs/nilfs2/namei.c       |    3 +++
>  fs/ocfs2/namei.c        |    3 +++
>  fs/omfs/dir.c           |    3 +++
>  fs/reiserfs/namei.c     |    3 +++
>  fs/sysv/namei.c         |    3 +++
>  fs/ubifs/dir.c          |    3 +++
>  fs/udf/namei.c          |    3 +++
>  fs/ufs/namei.c          |    3 +++
>  36 files changed, 108 insertions(+), 4 deletions(-)

You didn't push it down into XFS, hence my question....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
