Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867Ab2CaUIp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 16:08:45 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53001 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab2CaUIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 16:08:42 -0400
Date: Sat, 31 Mar 2012 21:08:38 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs part 2
Message-ID: <20120331200838.GZ6589@ZenIV.linux.org.uk>
References: <20120331051906.GU6589@ZenIV.linux.org.uk>
 <CA+55aFxmOEUCXeHtSAN+g3cSpFVvf5vPTSzZDtXdJs0Hq1rVZw@mail.gmail.com>
 <CA+55aFztRQHX+3KET_xdQd9TuEEuuGS6ogrKAEYGaWfd6m9rDA@mail.gmail.com>
 <20120331185738.GW6589@ZenIV.linux.org.uk>
 <CA+55aFxtN9j5j6XC9nDf+mNJ06ipgD4cbW6hrZw6+3KfvDSuww@mail.gmail.com>
 <20120331193913.GX6589@ZenIV.linux.org.uk>
 <CA+55aFwbHtLuo4yuDnWO-UgH5p7JThhG6uppX9hvQAXic9MS2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwbHtLuo4yuDnWO-UgH5p7JThhG6uppX9hvQAXic9MS2w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2012 at 12:48:22PM -0700, Linus Torvalds wrote:
> On Sat, Mar 31, 2012 at 12:39 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Variants:
> > ? ? ? ?1) drop that commit, fold obvious fix into it, leave it for for-next
> > once -rc1 is there; ask you to pull the branch with that sucker excluded
> > ? ? ? ?2) fold the fix into commit, ask you to pull the resulting branch
> > ? ? ? ?3) add fix to the end of existing branch, ask to pull
> 
> Let's go for (2). I'll take a new look after the pull request, but no
> guarantees that I'll then pull it.
> 
> Btw, I liked the do_lookup cleanups, but nicer commit logs would have
> been good. Especially the first lines. The whole
> 
>      untangling do_lookup(), part 1
>      untangling do_lookup(), part 2
>      untangling do_lookup(), part 3
>      untangling do_lookup(), part 4
>      untangling do_lookup(), part 5
>      untangling do_lookup(), part 6
>      untangling do_lookup(), part 7
>      untangling do_lookup(), part 8
>      untangling do_lookup(), part 9
> 
> in shortlogs (and gitk!) does turn me off. So since you have to redo
> the series anyway, can I ask you to perhaps try to make it a bit more
> descriptive?

OK...  Keep in mind that this is a splitup of what used to be a monolithic
patch from Miklos, so this series is basically "how do I convince myself
that his patch is correct (or find a hole in it)".  No holes found and
I like the resulting cleanup, so in it went...

Anyway, commit messages prettied up a bit, fix folded and the whole thing
is pushed to the same place - i.e.

git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (18):
      selinuxfs: merge dentry allocation into sel_make_dir()
      aio: merge aio_cancel_all() with wait_for_all_aios()
      aio: take final put_ioctx() into callers of io_destroy()
      pstore: trim pstore_get_inode()
      mtdchar: kill persistently held vfsmount
      get rid of pointless includes of ext2_fs.h
      new helper: ext2_image_size()
      migrate ext2_fs.h guts to fs/ext2/ext2.h
      ext3: move headers to fs/ext3/
      untangling do_lookup() - isolate !dentry stuff from the rest of it.
      untangling do_lookup() - expand the area under ->i_mutex
      untangling do_lookup() - eliminate a loop.
      untangling do_lookup() - get rid of need_reval in !dentry case
      untangling do_lookup() - massage !dentry case towards __lookup_hash()
      untangling do_lookup() - merge failure exits in !dentry case
      untangling do_lookup() - merge d_alloc_and_lookup() callers
      untangling do_lookup() - switch to calling __lookup_hash()
      untangling do_lookup() - take __lookup_hash()-calling case out of line.

J. Bruce Fields (1):
      vfs: fix out-of-date dentry_unhash() comment

Miklos Szeredi (4):
      vfs: fix d_need_lookup/d_revalidate order in do_lookup
      vfs: don't revalidate just looked up dentry
      vfs: move MAY_EXEC check from __lookup_hash()
      vfs: split __lookup_hash

Thierry Reding (1):
      ext2: No longer export ext2_fs.h to user space

Diffstat:
 arch/blackfin/kernel/setup.c              |    7 +-
 drivers/mtd/mtdchar.c                     |   53 +--
 fs/aio.c                                  |   32 +-
 fs/ext2/ext2.h                            |  631 +++++++++++++++++++++++++++++
 fs/ext2/xattr_security.c                  |    5 +-
 fs/ext2/xattr_trusted.c                   |    5 +-
 fs/ext2/xip.c                             |    2 -
 fs/ext3/acl.c                             |    8 +-
 fs/ext3/balloc.c                          |   10 +-
 fs/ext3/bitmap.c                          |    4 +-
 fs/ext3/dir.c                             |    7 +-
 include/linux/ext3_fs.h => fs/ext3/ext3.h |  488 +++++++++++++++++++----
 fs/ext3/ext3_jbd.c                        |    2 +-
 fs/ext3/file.c                            |    6 +-
 fs/ext3/fsync.c                           |    8 +-
 fs/ext3/hash.c                            |    4 +-
 fs/ext3/ialloc.c                          |   13 +-
 fs/ext3/inode.c                           |   12 +-
 fs/ext3/ioctl.c                           |    7 +-
 fs/ext3/namei.c                           |   14 +-
 fs/ext3/resize.c                          |    5 +-
 fs/ext3/super.c                           |   18 +-
 fs/ext3/symlink.c                         |    4 +-
 fs/ext3/xattr.c                           |    7 +-
 fs/ext3/xattr_security.c                  |    6 +-
 fs/ext3/xattr_trusted.c                   |    6 +-
 fs/ext3/xattr_user.c                      |    5 +-
 fs/gfs2/file.c                            |    1 -
 fs/namei.c                                |  195 ++++------
 fs/ocfs2/ioctl.c                          |    2 -
 fs/pstore/inode.c                         |   26 +-
 include/linux/Kbuild                      |    1 -
 include/linux/ext2_fs.h                   |  569 +-------------------------
 include/linux/ext2_fs_sb.h                |  126 ------
 include/linux/ext3_fs_i.h                 |  151 -------
 include/linux/ext3_fs_sb.h                |   91 -----
 include/linux/ext3_jbd.h                  |  229 -----------
 init/do_mounts_initrd.c                   |    1 -
 init/do_mounts_rd.c                       |    9 +-
 security/selinux/hooks.c                  |    9 +-
 security/selinux/selinuxfs.c              |  110 ++---
 41 files changed, 1249 insertions(+), 1640 deletions(-)
 rename include/linux/ext3_fs.h => fs/ext3/ext3.h (67%)
 delete mode 100644 include/linux/ext2_fs_sb.h
 delete mode 100644 include/linux/ext3_fs_i.h
 delete mode 100644 include/linux/ext3_fs_sb.h
 delete mode 100644 include/linux/ext3_jbd.h
