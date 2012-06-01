Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965590Ab2FAQ4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 12:56:18 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44016 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965516Ab2FAQ4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 12:56:15 -0400
Date: Fri, 1 Jun 2012 17:56:14 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs.git
Message-ID: <20120601165614.GJ30000@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Less than I would like to have there, but since the window is about to close...
Please, pull from
git.kernel.org:/pub/scm/linux/kernel/git/viro/vfs.git for-linus

There's a trivial conflict in Documentation/filesystems/vfs.txt - two
method prototypes added, one in mainline, one here.  With the obvious
conflict resolution...

Shortlog:
Al Viro (55):
      switch do_fsync() to fget_light()
      switch readdir/getdents to fget_light/fput_light
      switch xattr syscalls to fget_light/fput_light
      switch fcntl to fget_raw_light/fput_light
      switch signalfd4() to fget_light/fput_light
      switch flock to fget_light/fput_light
      switch statfs to fget_light/fput_light
      switch utimes() to fget_light/fput_light
      xfs: switch to proper __bitwise type for KM_... flags
      ubifs: use generic_fillattr()
      ->encode_fh() API change
      selinuxfs snprintf() misuses
      kill v9fs_dentry_from_dir_inode()
      affs: bury unused macros
      ocfs2: trivial endianness misannotations
      ocfs2: deal with __user misannotations
      ocfs2: kill endianness abuses in blockcheck.c
      btrfs: trivial endianness annotations
      hpfs: endianness bugs
      hpfs: get rid of bitfields endianness wanking in extended_attribute
      hpfs: get rid of bitfields in struct fnode
      hpfs: bitmaps are little-endian
      hpfs: annotate struct dnode
      hpfs: annotate btree nodes, get rid of bitfields mess
      hpfs: annotate struct fnode
      hpfs: annotate struct anode
      hpfs: annotate struct hpfs_dirent
      hpfs: annotate ea
      hpfs: assorted endianness annotations
      get rid of pointless allocations and copying in ecryptfs_follow_link()
      ocfs: simplify symlink handling
      get rid of idiotic misplaced __kernel_mode_t in ncfps kernel-private data structure
      mode_t whack-a-mole: ->is_visible() returns umode_t...
      mips: get rid of nlink_t, use explictly-sized type (__u32 in all cases)
      powerpc: get rid of nlink_t uses, switch to explicitly-sized type
      parisc: get rid of nlink_t, switch to explicitly-sized type
      bury __kernel_nlink_t, make internal nlink_t consistent
      i810: switch to vm_mmap()
      vfs: umount_tree() might be called on subtree that had never made it
      binfmt_elf: switch elf_map() to vm_mmap/vm_munmap
      binfmt_flat: use vm_munmap, we are missing ->mmap_sem there
      ia64, sparc64: convert wrappers around do_mremap() to sys_mremap()
      merge do_mremap() into sys_mremap()
      ia64 perfmon: fix get_unmapped_area() use there
      unexport do_mmap()
      split cap_mmap_addr() out of cap_file_mmap()
      split ->file_mmap() into ->mmap_addr()/->mmap_file()
      take security_mmap_file() outside of ->mmap_sem
      move security_mmap_addr() to saner place
      take calculation of final prot in security_mmap_file() into a helper
      switch aio and shm to do_mmap_pgoff(), make do_mmap() static
      kill do_mmap() completely
      new helper: vm_mmap_pgoff()
      unexport do_munmap()
      sch_atm.c: get rid of poinless extern

Andi Kleen (2):
      brlocks/lglocks: turn into functions
      brlocks/lglocks: API cleanups

Artem Bityutskiy (9):
      jffs2: remove lock_super
      jffs2: remove unnecessary GC pass on umount
      jffs2: remove unnecessary GC pass on sync
      jffs2: get rid of jffs2_sync_super
      reiserfs: cleanup reiserfs_fill_super a bit
      reiserfs: clean-up function return type
      reiserfs: remove useless superblock dirtying
      reiserfs: mark the superblock as dirty a bit later
      reiserfs: get rid of resierfs_sync_super

Cong Wang (1):
      fs: move file_remove_suid() to fs/inode.c

Dan Carpenter (1):
      fsnotify: remove unused parameter from send_to_group()

Dmitry Kasatkin (1):
      vfs: increment iversion when a file is truncated

J. Bruce Fields (2):
      vfs: stop d_splice_alias creating directory aliases
      vfs: remove unused __d_splice_alias argument

Josef Bacik (2):
      fs: introduce inode operation ->update_time
      Btrfs: move over to use ->update_time

Miklos Szeredi (16):
      vfs: split do_lookup()
      vfs: do_last(): make exit RCU safe
      vfs: do_last(): inline walk_component()
      vfs: do_last(): use inode variable
      vfs: make follow_link check RCU safe
      vfs: do_last(): make ENOENT exit RCU safe
      vfs: do_last(): check LOOKUP_DIRECTORY
      vfs: do_last(): only return EISDIR for O_CREAT
      vfs: do_last(): add audit_inode before open
      vfs: do_last() common post lookup
      vfs: split __dentry_open()
      vfs: do_dentry_open(): don't put filp
      vfs: nameidata_to_filp(): inline __dentry_open()
      vfs: nameidata_to_filp(): don't throw away file on error
      vfs: retry last component if opening stale dentry
      nfs: don't open in ->d_revalidate

Naohiro Aota (1):
      fsnotify: handle subfiles' perm events

Randy Dunlap (1):
      fs: fix inode.c kernel-doc warnings

Rusty Russell (1):
      lglock: remove online variants of lock

Sage Weil (1):
      ceph: move encode_fh to new API

Shai Fultheim (1):
      fs: Move bh_cachep to the __read_mostly section

Will Deacon (1):
      pipe: return -ENOIOCTLCMD instead of -EINVAL on unknown ioctl command

Diffstat:
 Documentation/filesystems/Locking       |    3 +
 Documentation/filesystems/vfs.txt       |    4 +
 arch/alpha/include/asm/posix_types.h    |    3 -
 arch/arm/include/asm/posix_types.h      |    3 -
 arch/avr32/include/asm/posix_types.h    |    3 -
 arch/blackfin/include/asm/posix_types.h |    3 -
 arch/cris/include/asm/posix_types.h     |    3 -
 arch/frv/include/asm/posix_types.h      |    3 -
 arch/h8300/include/asm/posix_types.h    |    3 -
 arch/ia64/include/asm/posix_types.h     |    3 -
 arch/ia64/kernel/perfmon.c              |   10 +-
 arch/ia64/kernel/sys_ia64.c             |   19 +--
 arch/m32r/include/asm/posix_types.h     |    3 -
 arch/m68k/include/asm/posix_types.h     |    3 -
 arch/mips/include/asm/posix_types.h     |    5 -
 arch/mips/include/asm/stat.h            |    6 +-
 arch/mn10300/include/asm/posix_types.h  |    3 -
 arch/parisc/include/asm/posix_types.h   |    3 -
 arch/parisc/include/asm/stat.h          |    4 +-
 arch/powerpc/include/asm/posix_types.h  |    3 -
 arch/powerpc/include/asm/stat.h         |    4 +-
 arch/s390/include/asm/posix_types.h     |    3 -
 arch/sh/include/asm/posix_types_32.h    |    2 -
 arch/sh/include/asm/posix_types_64.h    |    2 -
 arch/sparc/include/asm/posix_types.h    |    5 -
 arch/sparc/kernel/sys_sparc_64.c        |   11 +-
 arch/tile/include/asm/compat.h          |    1 -
 arch/x86/include/asm/posix_types_32.h   |    3 -
 drivers/base/soc.c                      |    2 +-
 drivers/gpu/drm/i810/i810_dma.c         |    4 +-
 fs/9p/vfs_inode_dotl.c                  |   24 +---
 fs/affs/affs.h                          |    8 -
 fs/aio.c                                |    6 +-
 fs/attr.c                               |    5 +
 fs/binfmt_elf.c                         |    8 +-
 fs/binfmt_flat.c                        |    8 +-
 fs/btrfs/ctree.h                        |    1 -
 fs/btrfs/export.c                       |   15 +--
 fs/btrfs/file.c                         |    2 +-
 fs/btrfs/free-space-cache.c             |    7 +-
 fs/btrfs/inode.c                        |   53 ++----
 fs/btrfs/ulist.c                        |    4 +-
 fs/btrfs/ulist.h                        |    4 +-
 fs/buffer.c                             |    2 +-
 fs/ceph/export.c                        |   32 +++--
 fs/compat.c                             |   33 ++--
 fs/dcache.c                             |   20 +--
 fs/ecryptfs/inode.c                     |   48 +----
 fs/exec.c                               |    4 -
 fs/exportfs/expfs.c                     |   33 ++--
 fs/fat/inode.c                          |    9 +-
 fs/fcntl.c                              |   42 ++---
 fs/file_table.c                         |   17 +-
 fs/fuse/file.c                          |    4 +-
 fs/fuse/inode.c                         |   17 +--
 fs/gfs2/export.c                        |   17 +--
 fs/hpfs/alloc.c                         |   14 +-
 fs/hpfs/anode.c                         |   43 +++--
 fs/hpfs/dir.c                           |    2 +-
 fs/hpfs/dnode.c                         |   10 +-
 fs/hpfs/ea.c                            |   60 ++++----
 fs/hpfs/hpfs.h                          |  289 +++++++++++++++----------------
 fs/hpfs/hpfs_fn.h                       |   16 +-
 fs/hpfs/inode.c                         |    2 +-
 fs/hpfs/map.c                           |   20 +-
 fs/hpfs/namei.c                         |    2 +-
 fs/hpfs/super.c                         |    4 +-
 fs/inode.c                              |  124 +++++++++++--
 fs/internal.h                           |    3 +-
 fs/isofs/export.c                       |   13 +-
 fs/jffs2/jffs2_fs_sb.h                  |    4 +
 fs/jffs2/os-linux.h                     |    7 +-
 fs/jffs2/super.c                        |   21 ---
 fs/jffs2/wbuf.c                         |   55 ++++++-
 fs/locks.c                              |    5 +-
 fs/namei.c                              |  177 ++++++++++++++------
 fs/namespace.c                          |  142 ++++++++--------
 fs/ncpfs/file.c                         |    6 +-
 fs/ncpfs/ncp_fs_sb.h                    |   10 +-
 fs/nfs/dir.c                            |   56 +------
 fs/nfs/file.c                           |   77 ++++++++-
 fs/nilfs2/namei.c                       |   22 +--
 fs/notify/fsnotify.c                    |   12 +-
 fs/ntfs/file.c                          |    4 +-
 fs/ocfs2/blockcheck.c                   |   42 +++--
 fs/ocfs2/dlm/dlmast.c                   |    2 +-
 fs/ocfs2/dlm/dlmcommon.h                |    6 +-
 fs/ocfs2/dlm/dlmdomain.c                |    2 +-
 fs/ocfs2/export.c                       |   19 +--
 fs/ocfs2/inode.c                        |   13 +-
 fs/ocfs2/ioctl.c                        |   31 ++--
 fs/ocfs2/move_extents.c                 |    6 +-
 fs/ocfs2/namei.c                        |    5 +-
 fs/ocfs2/symlink.c                      |  115 +++----------
 fs/ocfs2/symlink.h                      |    2 +-
 fs/open.c                               |   76 ++++++--
 fs/pipe.c                               |    9 +-
 fs/pnode.c                              |    4 +-
 fs/proc_namespace.c                     |    4 +-
 fs/readdir.c                            |   33 ++--
 fs/reiserfs/inode.c                     |   28 ++--
 fs/reiserfs/journal.c                   |   15 +-
 fs/reiserfs/reiserfs.h                  |   12 +-
 fs/reiserfs/resize.c                    |    1 -
 fs/reiserfs/super.c                     |   74 ++++++--
 fs/signalfd.c                           |    7 +-
 fs/splice.c                             |    6 +-
 fs/statfs.c                             |    5 +-
 fs/sync.c                               |    5 +-
 fs/ubifs/dir.c                          |   11 +-
 fs/udf/namei.c                          |   14 +-
 fs/utimes.c                             |    5 +-
 fs/xattr.c                              |   20 ++-
 fs/xfs/kmem.c                           |   10 +-
 fs/xfs/kmem.h                           |   21 ++-
 fs/xfs/xfs_export.c                     |   23 +--
 fs/xfs/xfs_file.c                       |    7 +-
 fs/xfs/xfs_log.c                        |    2 +-
 fs/xfs/xfs_log_priv.h                   |    2 +-
 fs/xfs/xfs_trans.c                      |    2 +-
 fs/xfs/xfs_trans.h                      |    2 +-
 include/asm-generic/posix_types.h       |    4 -
 include/linux/errno.h                   |    1 +
 include/linux/exportfs.h                |    4 +-
 include/linux/fs.h                      |   10 +-
 include/linux/fsnotify_backend.h        |    2 +-
 include/linux/lglock.h                  |  179 +++----------------
 include/linux/mm.h                      |    2 +-
 include/linux/security.h                |   40 +++--
 include/linux/types.h                   |    2 +-
 ipc/shm.c                               |    7 +-
 kernel/Makefile                         |    2 +-
 kernel/lglock.c                         |   89 ++++++++++
 mm/cleancache.c                         |    6 +-
 mm/filemap.c                            |   69 +-------
 mm/filemap_xip.c                        |    4 +-
 mm/internal.h                           |    4 +
 mm/mmap.c                               |   54 +-----
 mm/mremap.c                             |   26 +---
 mm/nommu.c                              |   35 +----
 mm/shmem.c                              |    6 +-
 mm/util.c                               |   30 ++++
 net/sched/sch_atm.c                     |    2 -
 security/apparmor/lsm.c                 |   15 +--
 security/capability.c                   |    3 +-
 security/commoncap.c                    |   17 +-
 security/security.c                     |   51 +++++-
 security/selinux/hooks.c                |   15 +-
 security/selinux/selinuxfs.c            |   36 +---
 security/smack/smack_lsm.c              |   15 +-
 150 files changed, 1499 insertions(+), 1622 deletions(-)
 create mode 100644 kernel/lglock.c
