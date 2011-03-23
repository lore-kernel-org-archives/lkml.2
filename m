Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab1CWCMJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 22:12:09 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36206 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033Ab1CWCMH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 22:12:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QVNQ2/lz/PlJ7GwEZe1VNblDZy0r3fHE9D9zulbLUH26sTho5LlNEnXjApYKpr0vpB
         k0M8MtaK8hCTikLoiMZ2f0TTJEkrCy1jIZlVo81CXXe1eKpKSEgO0POI1og7relknP2g
         RULc52NO4TIpifB6J9aAw/mh6NQX6iXzL3NYo=
MIME-Version: 1.0
In-Reply-To: <1300845590-14184-1-git-send-email-valerie.aurora@gmail.com>
References: <1300845590-14184-1-git-send-email-valerie.aurora@gmail.com>
Date: Tue, 22 Mar 2011 19:12:06 -0700
Message-ID: <AANLkTim7q5L9v5uFx9NB2Eai48WCTi5sSSx9yFbQgszi@mail.gmail.com>
Subject: Re: [PATCH 00/74] Union mounts version something or other
From: Valerie Aurora <valerie.aurora@gmail.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And I cc'd linux@vger.kernel.org on all the patches instead of
linux-kernel@vger.kernel.org - guess I'm really out of the kernel
business now!  Anyway, if you want your replies to go to lkml, you'll
have to hand edit the cc list.

-VAL

On Tue, Mar 22, 2011 at 6:58 PM, Valerie Aurora
<valerie.aurora@gmail.com> wrote:
> Hi union mounts fans(?),
>
> Here's my current union mounts patch set, against 2.6.36-rc5.  I'm
> busy with other things[1] and unlikely to put in significant work on
> union mounts in the next year.  I'm happy to answer questions from
> anyone else working on them.
>
> As always, git trees for the kernel, util-linux, and e2fsprogs, lots
> of documentation, and LWN articles describing the various problems
> unioning file systems will encounter are here:
>
> http://valerieaurora.org/union/
>
> The devkit linked to from that page includes my Usermode Linux testing
> environment, including root file system image.  The README tells you
> how to run the test suite automatically (yes, an automated test suite
> - with Makefile and version control and comments and stuff!).
>
> I took a quick look at the current overlayfs patch set, and it's
> small, clean, and easy to understand.  If it does what people need, I
> say ship it.
>
> Thanks to everyone who reviewed and submitted patches for union mounts!
>
> -VAL
>
> [1] http://adainitiative.org
>
> ---
>
> Felix Fietkau (2):
>  whiteout: jffs2 whiteout support
>  fallthru: jffs2 fallthru support
>
> Jan Blunck (9):
>  VFS: Make lookup_hash() return a struct path
>  autofs4: Save autofs trigger's vfsmount in super block info
>  whiteout/NFSD: Don't return information about whiteouts to userspace
>  whiteout: Add vfs_whiteout() and whiteout inode operation
>  whiteout: Allow removal of a directory with whiteouts
>  whiteout: tmpfs whiteout support
>  union-mount: Introduce MNT_UNION and MS_UNION flags
>  union-mount: Free union stack on removal of topmost dentry from
>    dcache
>  union-mount: Create IS_MNT_UNION()
>
> Valerie Aurora (63):
>  VFS: Comment follow_mount() and friends
>  Documentation: Fix trivial typo in filesystems/sharedsubtree.txt
>  whiteout: Define opaque inode flags and operations
>  ext2: Add ext2_dirent_in_use()
>  ext2: Split ext2_add_entry() from ext2_add_link()
>  whiteout: ext2 whiteout support
>  fallthru: Basic fallthru definitions
>  fallthru: ext2 fallthru support
>  fallthru: tmpfs fallthru support
>  VFS: Add hard read-only users count to superblock
>  VFS: Make clone_mnt()/copy_tree()/collect_mounts() return errors
>  VFS: Add CL_NO_SHARED flag to clone_mnt()/copy_tree()
>  VFS: Add CL_NO_SLAVE flag to clone_mnt()/copy_tree()
>  VFS: Add CL_MAKE_HARD_READONLY flag to clone_mnt()/copy_tree()
>  union-mount: Union mounts documentation
>  union-mount: Add CONFIG_UNION_MOUNT option
>  union-mount: Create union_stack structure
>  union-mount: Add two superblock fields for union mounts
>  union-mount: Add union_alloc()
>  union-mount: Add union_find_dir()
>  union-mount: Create d_free_unions()
>  union-mount: Create union_add_dir()
>  union-mount: Add union_create_topmost_dir()
>  union-mount: Create needs_lookup_union()
>  union-mount: Create check_topmost_union_mnt()
>  union-mount: Add clone_union_tree() and put_union_sb()
>  union-mount: Create build_root_union()
>  union-mount: Create prepare_mnt_union() and cleanup_mnt_union()
>  union-mount: Prevent improper union-related remounts
>  union-mount: Prevent topmost file system from being mounted elsewhere
>  union-mount: Prevent bind mounts of union mounts
>  union-mount: Implement union mount
>  union-mount: Temporarily disable some syscalls
>  union-mount: Basic infrastructure of __lookup_union()
>  union-mount: Process negative dentries in __lookup_union()
>  union-mount: Return files found in lower layers in __lookup_union()
>  union-mount: Build union stack in __lookup_union()
>  union-mount: Follow mount in __lookup_union()
>  union-mount: Add lookup_union()
>  union-mount: Add do_lookup_union() wrapper for __lookup_union()
>  union-mount: Call union lookup functions in lookup path
>  union-mount: Create whiteout on unlink()
>  union-mount: Create whiteout on rmdir()
>  union-mount: Set opaque flag on new directories in unioned file
>    systems
>  union-mount: Copy up directory entries on first readdir()
>  union-mount: Add generic_readdir_fallthru() helper
>  fallthru: ext2 support for lookup of d_type/d_ino in fallthrus
>  fallthru: tmpfs support for lookup of d_type/d_ino in fallthrus
>  fallthru: jffs2 support for lookup of d_type/d_ino in fallthrus
>  VFS: Split inode_permission() and create path_permission()
>  VFS: Create user_path_nd() to lookup both parent and target
>  union-mount: In-kernel file copyup routines
>  union-mount: Implement union-aware access()/faccessat()
>  union-mount: Implement union-aware link()
>  union-mount: Implement union-aware rename()
>  union-mount: Implement union-aware writable open()
>  union-mount: Implement union-aware chown()
>  union-mount: Implement union-aware truncate()
>  union-mount: Implement union-aware chmod()/fchmodat()
>  union-mount: Implement union-aware lchown()
>  union-mount: Implement union-aware utimensat()
>  union-mount: Implement union-aware setxattr()
>  union-mount: Implement union-aware lsetxattr()
>
>  Documentation/filesystems/sharedsubtree.txt |    4 +-
>  Documentation/filesystems/union-mounts.txt  |  751 +++++++++++++++++++++++++
>  Documentation/filesystems/vfs.txt           |   16 +-
>  fs/Kconfig                                  |   13 +
>  fs/Makefile                                 |    1 +
>  fs/autofs4/autofs_i.h                       |    1 +
>  fs/autofs4/init.c                           |   11 +-
>  fs/autofs4/root.c                           |    6 +
>  fs/compat.c                                 |    9 +
>  fs/dcache.c                                 |   32 +-
>  fs/ext2/dir.c                               |  116 ++++-
>  fs/ext2/ext2.h                              |    3 +
>  fs/ext2/inode.c                             |   11 +-
>  fs/ext2/namei.c                             |   85 +++-
>  fs/ext2/super.c                             |    6 +
>  fs/jffs2/dir.c                              |  117 ++++-
>  fs/jffs2/fs.c                               |    4 +
>  fs/jffs2/super.c                            |    2 +-
>  fs/libfs.c                                  |   20 +-
>  fs/namei.c                                  |  807 ++++++++++++++++++++++++---
>  fs/namespace.c                              |  394 +++++++++++--
>  fs/nfsd/nfs3xdr.c                           |    5 +
>  fs/nfsd/nfs4xdr.c                           |    5 +
>  fs/nfsd/nfsxdr.c                            |    4 +
>  fs/open.c                                   |  116 ++++-
>  fs/pnode.c                                  |    5 +-
>  fs/pnode.h                                  |    3 +
>  fs/readdir.c                                |   18 +
>  fs/super.c                                  |    9 +
>  fs/union.c                                  |  714 ++++++++++++++++++++++++
>  fs/union.h                                  |  105 ++++
>  fs/utimes.c                                 |   14 +-
>  fs/xattr.c                                  |   65 ++-
>  include/linux/dcache.h                      |   37 ++-
>  include/linux/ext2_fs.h                     |    8 +
>  include/linux/fs.h                          |   45 ++
>  include/linux/jffs2.h                       |    8 +
>  include/linux/mount.h                       |    4 +
>  include/linux/namei.h                       |    2 +
>  kernel/audit_tree.c                         |   10 +-
>  mm/shmem.c                                  |  193 ++++++-
>  41 files changed, 3551 insertions(+), 228 deletions(-)
>  create mode 100644 Documentation/filesystems/union-mounts.txt
>  create mode 100644 fs/union.c
>  create mode 100644 fs/union.h
>
>
