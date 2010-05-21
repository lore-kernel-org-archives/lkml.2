Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934362Ab0EUSom (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 14:44:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49946 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934253Ab0EUSol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 14:44:41 -0400
Date: Fri, 21 May 2010 20:44:29 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [PULL REQUEST] Ext2, ext3, and quota updates for 2.6.35-rc1
Message-ID: <20100521184428.GC10149@quack.suse.cz>
References: <20100521174658.GA10149@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100521174658.GA10149@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 21-05-10 19:46:58, Jan Kara wrote:
> 
>   Hello Linus,
> 
>   could you please pull from
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs-2.6.git for_linus
> 
>   to get the changes below? The big chunks are BKL removal from ext2, OCFS2
> quota locking fixes, and some quota cleanups from Christoph (I have some
> more of them pending but I got to testing them properly only today and thus
> I want to leave the final version in linux-next at least over the weekend
> before pushing them...).
  Oops, I've just found a bug in one of my ocfs2 fixes. I've fixed that up
so the new diffstat is here:

 Documentation/filesystems/ext3.txt |   15 ++-
 fs/ext2/balloc.c                   |    6 +
 fs/ext2/ialloc.c                   |    9 +-
 fs/ext2/inode.c                    |    7 +-
 fs/ext2/super.c                    |   99 +++++------
 fs/ext2/xattr.c                    |    2 +
 fs/ext3/balloc.c                   |    6 +
 fs/ext3/fsync.c                    |   20 +--
 fs/ext3/inode.c                    |    2 +-
 fs/ext3/super.c                    |   77 +++++---
 fs/ext4/inode.c                    |    2 +-
 fs/gfs2/quota.c                    |   12 +-
 fs/jbd/commit.c                    |    8 +-
 fs/jbd/journal.c                   |   33 ++++
 fs/jfs/file.c                      |    2 +-
 fs/ocfs2/dlmglue.c                 |    3 +-
 fs/ocfs2/file.c                    |   21 +--
 fs/ocfs2/quota.h                   |   12 +-
 fs/ocfs2/quota_global.c            |  347 +++++++++++++++++++++---------------
 fs/ocfs2/quota_local.c             |  133 +++++++-------
 fs/ocfs2/super.c                   |   12 ++-
 fs/quota/dquot.c                   |  275 +++++++++++++++++-----------
 fs/quota/quota.c                   |   63 +++++--
 fs/quota/quota_tree.c              |   50 +++---
 fs/quota/quota_tree.h              |    6 +
 fs/quota/quota_v1.c                |    4 +-
 fs/quota/quota_v2.c                |    6 +-
 fs/reiserfs/inode.c                |    3 +-
 fs/udf/file.c                      |    2 +-
 fs/ufs/inode.c                     |    2 +-
 fs/ufs/namei.c                     |    2 +-
 fs/ufs/symlink.c                   |    8 +
 fs/ufs/truncate.c                  |   10 +-
 fs/ufs/ufs.h                       |    2 +
 fs/xfs/linux-2.6/xfs_quotaops.c    |    8 +-
 fs/xfs/quota/xfs_qm_syscalls.c     |   10 +-
 include/linux/dqblk_xfs.h          |    9 +
 include/linux/ext2_fs_sb.h         |    9 +
 include/linux/jbd.h                |    3 +-
 include/linux/quota.h              |   48 ++++--
 include/linux/quotaops.h           |   15 ++-
 41 files changed, 836 insertions(+), 527 deletions(-)

Sorry for the confusion.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
