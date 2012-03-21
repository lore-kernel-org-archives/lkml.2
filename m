Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483Ab2CUDb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 23:31:58 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53894 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab2CUDb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 23:31:56 -0400
Date: Wed, 21 Mar 2012 03:31:53 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs pile 1
Message-ID: <20120321033152.GM6589@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is _not_ all; in particular, Miklos' and Jan's stuff is not there
yet.  Please, pull from the usual place -
git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (59):
      vfs: check i_nlink limits in vfs_{mkdir,rename_dir,link}
      vfs: drop_file_write_access() made static
      ecryptfs: don't bother with ->drop_inode()
      vfs: turn generic_drop_inode() into static inline
      clean up the failure exits in cifs_read_super()
      coda: clean failure exits in coda_fill_super()
      ... and the same failure exits cleanup for ocfs2
      procfs: clean proc_fill_super() up
      switch open-coded instances of d_make_root() to new helper
      ntfs: switch to d_make_root()
      fat: switch to d_make_root()
      hfsplus: switch to d_make_root()
      minixfs: switch to d_make_root()
      tidy up after d_make_root() conversion
      vfs: d_alloc_root() gone
      aio: don't bother with async freeing on failure in ioctx_alloc()
      aio: aio_nr decrements don't need to be delayed
      aio: aio_nr_lock is taken only synchronously now
      aio: use cancel_delayed_work_sync()
      aio: don't bother with cancel_delayed_work() in exit_aio()
      aio: fix the comment in aio_kick_handler()
      constify path argument of audit_log_d_path()
      constify path argument of trace_seq_path()
      switch unix_sock to struct path
      switch touch_atime to struct path
      no need to play with fs->seq in exit_fs()
      vfs: take path_get_longterm() out of write_seqcount scope
      take private bits of reiserfs_xattr.h to fs/reiserfs/xattr.h
      move reiserfs_acl.h to fs/reiserfs/acl.h
      kill pointless includes of reiserfs_fs_{i,sb}.h
      move private bits of reiserfs_fs.h to fs/reiserfs/reiserfs.h
      kill reiserfs_fs_{i,sb}.h
      spufs: make register_filesystem the last potential failure exit
      ibmasmfs: make register_filesystem the last failure exit
      make simple_pin_fs() pass MS_KERNMOUNT - it's a kernel-internal one
      usbfs: kill racy detection of simple_pin_fs()
      9p: make register_filesystem() the last failure exit
      anon_inodes: move allocation of anon_inode into ->mount()
      autofs: set things up *before* registering fs type
      __register_binfmt() made void
      configfs: don't bother with checks for mkdir/rmdir/unlink/symlink in root
      configfs: kill configfs_sb
      configfs: sanitize configfs_create()
      configfs: configfs_create_dir() has parent dentry in dentry->d_parent
      make configfs_pin_fs() return root dentry on success
      jfs: mising cleanup on register_filesystem() failure
      logfs: missing cleanup on register_filesystem() failure
      ntfs: forgets to unregister sysctls on register_filesystem() failure
      ecryptfs: make register_filesystem() the last potential failure exit
      ocfs2: fix leaks on failure exits in module_init
      gadgetfs: list_for_each_safe() misuse
      um: embed ->stub_pages[] into mmu_context
      um: uml_dup_mmap() relies on ->mmap_sem being held, but activate_mm() doesn't hold it
      trim includes in inode.c
      take removal of PF_FORKNOEXEC to flush_old_exec()
      qnx4: get rid of qnx4_bread/qnx4_getblk
      qnx4: new helper - try_extent()
      debugfs-related mode_t whack-a-mole
      ext4: initialization of ext4_li_mtx needs to be done earlier

Kai Bankett (2):
      qnx4fs: small cleanup
      fs: initial qnx6fs addition

Matthew Garrett (3):
      hfsplus: initialise userflags
      hfsplus: change finder_info to u32
      hfsplus: add an ioctl to bless files

Diffstat:
 Documentation/filesystems/debugfs.txt             |    2 +-
 Documentation/filesystems/porting                 |    6 +
 Documentation/filesystems/qnx6.txt                |  174 ++
 Documentation/ioctl/ioctl-number.txt              |    1 +
 arch/alpha/kernel/binfmt_loader.c                 |    3 +-
 arch/powerpc/platforms/cell/spufs/inode.c         |   14 +-
 arch/s390/hypfs/inode.c                           |    6 +-
 arch/um/include/asm/mmu.h                         |    2 +-
 arch/um/include/asm/mmu_context.h                 |   11 +-
 arch/um/kernel/skas/mmu.c                         |   25 +-
 arch/x86/ia32/ia32_aout.c                         |    4 +-
 drivers/misc/ibmasm/ibmasmfs.c                    |   16 +-
 drivers/misc/ibmasm/module.c                      |   11 +-
 drivers/mmc/card/block.c                          |    2 +-
 drivers/net/ethernet/brocade/bna/bnad_debugfs.c   |    2 +-
 drivers/oprofile/oprofilefs.c                     |   11 +-
 drivers/usb/core/inode.c                          |   23 +-
 drivers/usb/gadget/f_fs.c                         |    8 +-
 drivers/usb/gadget/inode.c                        |   13 +-
 fs/9p/v9fs.c                                      |   16 +-
 fs/9p/vfs_super.c                                 |    3 +-
 fs/Kconfig                                        |    1 +
 fs/Makefile                                       |    1 +
 fs/adfs/super.c                                   |    3 +-
 fs/affs/super.c                                   |    7 +-
 fs/afs/super.c                                    |    7 +-
 fs/aio.c                                          |   65 +-
 fs/anon_inodes.c                                  |  109 +-
 fs/autofs4/init.c                                 |    6 +-
 fs/autofs4/inode.c                                |   10 +-
 fs/befs/linuxvfs.c                                |    3 +-
 fs/bfs/inode.c                                    |    3 +-
 fs/binfmt_aout.c                                  |    4 +-
 fs/binfmt_elf.c                                   |    5 +-
 fs/binfmt_elf_fdpic.c                             |    6 +-
 fs/binfmt_em86.c                                  |    3 +-
 fs/binfmt_flat.c                                  |    4 +-
 fs/binfmt_misc.c                                  |    7 +-
 fs/binfmt_script.c                                |    3 +-
 fs/binfmt_som.c                                   |    4 +-
 fs/btrfs/super.c                                  |    8 +-
 fs/cachefiles/namei.c                             |    3 +-
 fs/ceph/super.c                                   |    3 +-
 fs/cifs/cifsfs.c                                  |    7 +-
 fs/coda/inode.c                                   |    6 +-
 fs/configfs/configfs_internal.h                   |    7 +-
 fs/configfs/dir.c                                 |   72 +-
 fs/configfs/inode.c                               |   62 +-
 fs/configfs/mount.c                               |   16 +-
 fs/configfs/symlink.c                             |   12 +-
 fs/cramfs/inode.c                                 |    6 +-
 fs/dcache.c                                       |   24 -
 fs/debugfs/file.c                                 |    2 +-
 fs/devpts/inode.c                                 |    3 +-
 fs/ecryptfs/file.c                                |    9 +-
 fs/ecryptfs/main.c                                |   19 +-
 fs/ecryptfs/super.c                               |    1 -
 fs/efs/super.c                                    |    3 +-
 fs/exec.c                                         |    8 +-
 fs/exofs/namei.c                                  |   13 +-
 fs/exofs/super.c                                  |    4 +-
 fs/ext2/namei.c                                   |   13 +-
 fs/ext2/super.c                                   |    4 +-
 fs/ext3/super.c                                   |    3 +-
 fs/ext4/super.c                                   |    8 +-
 fs/fat/inode.c                                    |    8 +-
 fs/file_table.c                                   |    3 +-
 fs/freevxfs/vxfs_super.c                          |    3 +-
 fs/fs_struct.c                                    |   29 +-
 fs/fuse/inode.c                                   |    9 +-
 fs/gfs2/ops_fstype.c                              |    3 +-
 fs/hfs/super.c                                    |    6 +-
 fs/hfsplus/hfsplus_fs.h                           |    5 +
 fs/hfsplus/hfsplus_raw.h                          |    2 +-
 fs/hfsplus/inode.c                                |    2 +
 fs/hfsplus/ioctl.c                                |   34 +
 fs/hfsplus/super.c                                |   17 +-
 fs/hostfs/hostfs_kern.c                           |    4 +-
 fs/hpfs/super.c                                   |    6 +-
 fs/hppfs/hppfs.c                                  |    9 +-
 fs/hugetlbfs/inode.c                              |   13 +-
 fs/inode.c                                        |   28 +-
 fs/isofs/inode.c                                  |    3 +-
 fs/jffs2/fs.c                                     |    6 +-
 fs/jfs/namei.c                                    |   13 -
 fs/jfs/super.c                                    |   12 +-
 fs/libfs.c                                        |    8 +-
 fs/logfs/dir.c                                    |    3 -
 fs/logfs/super.c                                  |   12 +-
 fs/minix/inode.c                                  |   38 +-
 fs/minix/minix.h                                  |    1 -
 fs/minix/namei.c                                  |   14 +-
 fs/namei.c                                        |   15 +-
 fs/ncpfs/inode.c                                  |    6 +-
 fs/nfs/getroot.c                                  |    6 +-
 fs/nfsd/fault_inject.c                            |    2 +-
 fs/nfsd/vfs.c                                     |   11 +-
 fs/nilfs2/namei.c                                 |   11 -
 fs/nilfs2/super.c                                 |    4 +-
 fs/ntfs/super.c                                   |    9 +-
 fs/ocfs2/dlmfs/dlmfs.c                            |   14 +-
 fs/ocfs2/super.c                                  |   51 +-
 fs/omfs/inode.c                                   |    6 +-
 fs/openpromfs/inode.c                             |    3 +-
 fs/proc/inode.c                                   |   16 +-
 fs/pstore/inode.c                                 |   25 +-
 fs/qnx4/inode.c                                   |   88 +-
 fs/qnx4/namei.c                                   |    9 +-
 fs/qnx4/qnx4.h                                    |    2 -
 fs/qnx6/Kconfig                                   |   26 +
 fs/qnx6/Makefile                                  |    7 +
 fs/qnx6/README                                    |    8 +
 fs/qnx6/dir.c                                     |  291 ++
 fs/qnx6/inode.c                                   |  698 +++++
 fs/qnx6/namei.c                                   |   42 +
 fs/qnx6/qnx6.h                                    |  135 +
 fs/qnx6/super_mmi.c                               |  150 ++
 fs/ramfs/inode.c                                  |   30 +-
 include/linux/reiserfs_acl.h => fs/reiserfs/acl.h |    0
 fs/reiserfs/bitmap.c                              |    4 +-
 fs/reiserfs/dir.c                                 |    2 +-
 fs/reiserfs/do_balan.c                            |    2 +-
 fs/reiserfs/file.c                                |    6 +-
 fs/reiserfs/fix_node.c                            |    2 +-
 fs/reiserfs/hashes.c                              |    2 +-
 fs/reiserfs/ibalance.c                            |    2 +-
 fs/reiserfs/inode.c                               |    6 +-
 fs/reiserfs/ioctl.c                               |    2 +-
 fs/reiserfs/item_ops.c                            |    2 +-
 fs/reiserfs/journal.c                             |    2 +-
 fs/reiserfs/lbalance.c                            |    2 +-
 fs/reiserfs/lock.c                                |    2 +-
 fs/reiserfs/namei.c                               |    6 +-
 fs/reiserfs/objectid.c                            |    3 +-
 fs/reiserfs/prints.c                              |    4 +-
 fs/reiserfs/procfs.c                              |    3 +-
 fs/reiserfs/reiserfs.h                            | 2922 +++++++++++++++++++++
 fs/reiserfs/resize.c                              |    3 +-
 fs/reiserfs/stree.c                               |    2 +-
 fs/reiserfs/super.c                               |   12 +-
 fs/reiserfs/tail_conversion.c                     |    2 +-
 fs/reiserfs/xattr.c                               |    6 +-
 fs/reiserfs/xattr.h                               |  122 +
 fs/reiserfs/xattr_acl.c                           |    6 +-
 fs/reiserfs/xattr_security.c                      |    4 +-
 fs/reiserfs/xattr_trusted.c                       |    4 +-
 fs/reiserfs/xattr_user.c                          |    4 +-
 fs/romfs/super.c                                  |    6 +-
 fs/squashfs/super.c                               |    3 +-
 fs/stat.c                                         |    2 +-
 fs/sysfs/mount.c                                  |    3 +-
 fs/sysv/namei.c                                   |   12 +-
 fs/sysv/super.c                                   |   27 +-
 fs/sysv/sysv.h                                    |    1 -
 fs/ubifs/super.c                                  |    6 +-
 fs/udf/namei.c                                    |   13 -
 fs/udf/super.c                                    |    6 +-
 fs/ufs/namei.c                                    |   14 +-
 fs/ufs/super.c                                    |    7 +-
 fs/xfs/xfs_rename.c                               |   11 -
 fs/xfs/xfs_super.c                                |    7 +-
 fs/xfs/xfs_utils.c                                |    2 -
 fs/xfs/xfs_vnodeops.c                             |   16 -
 include/linux/audit.h                             |    2 +-
 include/linux/binfmts.h                           |   10 +-
 include/linux/dcache.h                            |    1 -
 include/linux/debugfs.h                           |    4 +-
 include/linux/file.h                              |    1 -
 include/linux/fs.h                                |   10 +-
 include/linux/magic.h                             |    1 +
 include/linux/qnx6_fs.h                           |  134 +
 include/linux/reiserfs_fs.h                       | 2334 ----------------
 include/linux/reiserfs_fs_i.h                     |   63 -
 include/linux/reiserfs_fs_sb.h                    |  554 ----
 include/linux/reiserfs_xattr.h                    |  128 -
 include/linux/trace_seq.h                         |    4 +-
 include/net/af_unix.h                             |    3 +-
 ipc/mqueue.c                                      |   24 +-
 kernel/audit.c                                    |    2 +-
 kernel/cgroup.c                                   |    8 +-
 kernel/trace/trace_output.c                       |    2 +-
 mm/shmem.c                                        |   10 +-
 net/sunrpc/rpc_pipe.c                             |    8 +-
 net/unix/af_unix.c                                |   37 +-
 net/unix/diag.c                                   |    2 +-
 security/lsm_audit.c                              |    8 +-
 186 files changed, 5360 insertions(+), 4141 deletions(-)
 create mode 100644 Documentation/filesystems/qnx6.txt
 create mode 100644 fs/qnx6/Kconfig
 create mode 100644 fs/qnx6/Makefile
 create mode 100644 fs/qnx6/README
 create mode 100644 fs/qnx6/dir.c
 create mode 100644 fs/qnx6/inode.c
 create mode 100644 fs/qnx6/namei.c
 create mode 100644 fs/qnx6/qnx6.h
 create mode 100644 fs/qnx6/super_mmi.c
 rename include/linux/reiserfs_acl.h => fs/reiserfs/acl.h (100%)
 create mode 100644 fs/reiserfs/reiserfs.h
 create mode 100644 fs/reiserfs/xattr.h
 create mode 100644 include/linux/qnx6_fs.h
 delete mode 100644 include/linux/reiserfs_fs_i.h
 delete mode 100644 include/linux/reiserfs_fs_sb.h
