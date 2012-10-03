Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab2JCBjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 21:39:41 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41020 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab2JCBji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 21:39:38 -0400
Date: Wed, 3 Oct 2012 02:39:36 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs, part 1
Message-ID: <20121003013936.GN13973@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	This is *not* all; fs/dcache.c bits will go separately, for one
thing - that's just the first pile.  Please, pull from the usual place -
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus
Shortlog:
Al Viro (67):
      do_add_mount()/umount -l races
      close the race in nlmsvc_free_block()
      Merge remote branch 'origin' into for-next
      take descriptor handling from sock_alloc_file() to callers
      unexport sock_map_fd(), switch to sock_alloc_file()
      make get_unused_fd_flags() a function
      autofs4: don't open-code fd_install()
      binder: don't allow mmap() by process other than proc->tsk
      pipe(2) - race-free error recovery
      events: don't use get_unused_fd_flags() when get_unused_fd() will do
      fanotify: sanitize failure exits in copy_event_to_user()
      take rlimit check to callers of expand_files()
      new helper: __alloc_fd()
      move files_struct-related bits from kernel/exit.c to fs/file.c
      don't bother with call_rcu() in put_files_struct()
      trim free_fdtable_rcu()
      move put_unused_fd() and fd_install() to fs/file.c
      expose a low-level variant of fd_install() for binder
      take fget() and friends to fs/file.c
      take descriptor-related part of close() to file.c
      um: resurrect the right variant of mconsole_proc()
      take close-on-exec logics to fs/file.c, clean it up a bit
      take purely descriptor-related stuff from fcntl.c to file.c
      new helper: replace_fd()
      switch flush_unauthorized_files() to replace_fd()
      take __{set,clear}_{open_fd,close_on_exec}() into fs/file.c
      make expand_files() and alloc_fd() static
      new helper: iterate_fd()
      do_coredump(): make sure that descriptor table isn't shared
      switch spufs/coredump to iterate_fd()
      new helper: daemonize_descriptors()
      don't leak O_CLOEXEC into ->f_flags
      namei.c: fix BS comment
      switch ftruncate(2) to fget_light
      switch fallocate(2) to fget_light()
      switch fchmod(2) to fget_light()
      switch fadvise(2) to fget_light()
      switch readahead(2) to fget_light()
      switch osf_getdirentries() to fget_light()
      switch itanic perfmonctl(2) to fget_light()
      switch hpux_getdents() to fget_light()
      ext4: close struct file leak on EXT4_IOC_MOVE_EXT
      export fget_light
      switch EXT4_IOC_MOVE_EXT to fget_light()
      switch btrfs_ioctl_snap_create_transid() to fget_light()
      switch epoll_wait(2) to fget_light()
      switch timerfd_[sg]ettime(2) to fget_light()
      switch SNDRV_PCM_IOCTL_LINK to fget_light()
      switch mqueue syscalls to fget_light()
      switch btrfs_ioctl_clone() to fget_light()
      switch vfio_group_set_container() to fget_light()
      switch infinibarf users of fget() to fget_light()
      switch coda get_device_index() to fget_light()
      switch xfs_swapext() to fget_light()
      switch xfs_find_handle() to fget_light()
      switch prctl_set_mm_exe_file() to fget_light()
      vhost_set_vring(): turn pollstart/pollstop into bool
      make get_file() return its argument
      proc_map_files_readdir(): don't bother with grabbing files
      switch o2hb_region_dev_write() to fget_light()
      new helpers: fdget()/fdput()
      switch simple cases of fget_light to fdget
      hypfs: ->d_parent is never NULL or negative
      ceph: don't abuse d_delete() on failure exits
      fcntl: fix misannotations
      usb/gadget: fix misannotations
      btrfs: reada_extent doesn't need kref for refcount

Alan Cox (1):
      vfs: delete surplus inode NULL check

Alex Kelly (1):
      coredump: move core dump functionality into its own file

Catalin Marinas (1):
      compat: fs: Generic compat_sys_sendfile implementation

Chuck Lever (1):
      MAX_LFS_FILESIZE should be a loff_t

Cyrill Gorcunov (2):
      procfs: Move /proc/pid/fd[info] handling code to fd.[ch]
      procfs: Convert /proc/pid/fdinfo/ handling routines to seq-file v2

Denys Vlasenko (1):
      coredump: prevent double-free on an error path in core dumper

Kirill A. Shutemov (1):
      fs: push rcu_barrier() from deactivate_locked_super() to filesystems

Diffstat:
 arch/alpha/kernel/osf_sys.c                  |   13 +-
 arch/ia64/kernel/perfmon.c                   |   18 +-
 arch/parisc/hpux/fs.c                        |   17 +-
 arch/powerpc/include/asm/systbl.h            |    4 +-
 arch/powerpc/include/asm/unistd.h            |    1 +
 arch/powerpc/kernel/sys_ppc32.c              |   45 +--
 arch/powerpc/platforms/cell/spu_syscalls.c   |   21 +-
 arch/powerpc/platforms/cell/spufs/coredump.c |   40 +-
 arch/s390/hypfs/inode.c                      |    2 -
 arch/sparc/include/asm/unistd.h              |    1 +
 arch/sparc/kernel/sys32.S                    |    2 +-
 arch/sparc/kernel/sys_sparc32.c              |   46 --
 arch/um/drivers/mconsole_kern.c              |   99 +---
 drivers/base/dma-buf.c                       |    3 +-
 drivers/infiniband/core/ucma.c               |   10 +-
 drivers/infiniband/core/uverbs_cmd.c         |   21 +-
 drivers/infiniband/core/uverbs_main.c        |   11 +-
 drivers/staging/android/binder.c             |  113 +----
 drivers/staging/omapdrm/omap_gem.c           |    3 +-
 drivers/tty/tty_io.c                         |   45 +--
 drivers/usb/gadget/f_fs.c                    |    4 +-
 drivers/vfio/vfio.c                          |   15 +-
 drivers/vhost/vhost.c                        |    8 +-
 drivers/video/msm/mdp.c                      |   12 +-
 fs/9p/v9fs.c                                 |    5 +
 fs/Makefile                                  |    2 +-
 fs/adfs/super.c                              |    5 +
 fs/affs/super.c                              |    5 +
 fs/afs/super.c                               |    5 +
 fs/autofs4/dev-ioctl.c                       |   18 +-
 fs/autofs4/waitq.c                           |    3 +-
 fs/befs/linuxvfs.c                           |    5 +
 fs/bfs/inode.c                               |    5 +
 fs/binfmt_elf.c                              |   19 +-
 fs/btrfs/extent_io.c                         |    6 +
 fs/btrfs/inode.c                             |    5 +
 fs/btrfs/ioctl.c                             |   32 +-
 fs/btrfs/reada.c                             |   18 +-
 fs/ceph/inode.c                              |    4 +-
 fs/ceph/super.c                              |    5 +
 fs/cifs/cifsfs.c                             |    5 +
 fs/coda/inode.c                              |   37 +-
 fs/compat.c                                  |  112 +++--
 fs/compat_ioctl.c                            |   27 +-
 fs/coredump.c                                |  686 +++++++++++++++++++++++++
 fs/dcache.c                                  |    2 +-
 fs/ecryptfs/main.c                           |    6 +
 fs/efs/super.c                               |    5 +
 fs/eventpoll.c                               |   23 +-
 fs/exec.c                                    |  688 +-------------------------
 fs/exofs/super.c                             |    5 +
 fs/ext2/super.c                              |    5 +
 fs/ext3/super.c                              |    5 +
 fs/ext4/ioctl.c                              |   15 +-
 fs/ext4/super.c                              |    5 +
 fs/fat/inode.c                               |    5 +
 fs/fcntl.c                                   |  166 +------
 fs/fhandle.c                                 |   17 +-
 fs/file.c                                    |  573 ++++++++++++++++++++-
 fs/file_table.c                              |  106 ----
 fs/freevxfs/vxfs_super.c                     |    5 +
 fs/fuse/dev.c                                |    3 +-
 fs/fuse/inode.c                              |    6 +
 fs/hfs/super.c                               |    6 +
 fs/hfsplus/super.c                           |    6 +
 fs/hpfs/super.c                              |    5 +
 fs/hugetlbfs/inode.c                         |    5 +
 fs/ioctl.c                                   |   25 +-
 fs/isofs/inode.c                             |    5 +
 fs/jffs2/super.c                             |    6 +
 fs/jfs/super.c                               |    6 +
 fs/lockd/svclock.c                           |    3 +-
 fs/locks.c                                   |   20 +-
 fs/logfs/inode.c                             |    5 +
 fs/minix/inode.c                             |    5 +
 fs/namei.c                                   |   41 +-
 fs/namespace.c                               |   10 +-
 fs/ncpfs/inode.c                             |    5 +
 fs/nfs/inode.c                               |    5 +
 fs/nfsd/nfs4state.c                          |    3 +-
 fs/nilfs2/super.c                            |    6 +
 fs/notify/fanotify/fanotify_user.c           |   87 ++--
 fs/notify/inotify/inotify_user.c             |   28 +-
 fs/ntfs/super.c                              |    6 +
 fs/ocfs2/cluster/heartbeat.c                 |   38 +-
 fs/ocfs2/dlmfs/dlmfs.c                       |    5 +
 fs/ocfs2/super.c                             |    5 +
 fs/open.c                                    |  130 ++----
 fs/openpromfs/inode.c                        |    5 +
 fs/pipe.c                                    |   31 +-
 fs/proc/Makefile                             |    2 +-
 fs/proc/base.c                               |  417 +---------------
 fs/proc/fd.c                                 |  367 ++++++++++++++
 fs/proc/fd.h                                 |   14 +
 fs/proc/internal.h                           |   48 ++
 fs/qnx4/inode.c                              |    5 +
 fs/qnx6/inode.c                              |    5 +
 fs/read_write.c                              |  180 +++----
 fs/read_write.h                              |    2 +
 fs/readdir.c                                 |   36 +-
 fs/reiserfs/super.c                          |    5 +
 fs/romfs/super.c                             |    5 +
 fs/select.c                                  |   31 +-
 fs/signalfd.c                                |   13 +-
 fs/splice.c                                  |   69 ++--
 fs/squashfs/super.c                          |    5 +
 fs/stat.c                                    |   10 +-
 fs/statfs.c                                  |    9 +-
 fs/super.c                                   |    6 -
 fs/sync.c                                    |   33 +-
 fs/sysv/inode.c                              |    5 +
 fs/timerfd.c                                 |   45 +-
 fs/ubifs/super.c                             |    6 +
 fs/udf/super.c                               |    5 +
 fs/ufs/super.c                               |    5 +
 fs/utimes.c                                  |   11 +-
 fs/xattr.c                                   |   52 +--
 fs/xfs/xfs_dfrag.c                           |   34 +-
 fs/xfs/xfs_ioctl.c                           |   10 +-
 fs/xfs/xfs_super.c                           |    5 +
 include/linux/compat.h                       |    3 +
 include/linux/fdtable.h                      |   39 +-
 include/linux/file.h                         |   35 ++-
 include/linux/fs.h                           |   10 +-
 include/linux/net.h                          |    3 +-
 include/linux/sched.h                        |    1 +
 ipc/mqueue.c                                 |   78 ++--
 kernel/events/core.c                         |   72 ++--
 kernel/exit.c                                |   97 +----
 kernel/sys.c                                 |   14 +-
 kernel/taskstats.c                           |   11 +-
 mm/fadvise.c                                 |   34 +-
 mm/fremap.c                                  |    3 +-
 mm/mmap.c                                    |    3 +-
 mm/nommu.c                                   |    6 +-
 mm/readahead.c                               |   14 +-
 net/9p/trans_fd.c                            |   16 +-
 net/compat.c                                 |    3 +-
 net/core/netprio_cgroup.c                    |   38 +-
 net/core/scm.c                               |    3 +-
 net/sctp/socket.c                            |   25 +-
 net/socket.c                                 |   66 ++-
 security/selinux/hooks.c                     |   73 +--
 sound/core/pcm_native.c                      |   13 +-
 144 files changed, 2925 insertions(+), 2880 deletions(-)
 create mode 100644 fs/coredump.c
 create mode 100644 fs/proc/fd.c
 create mode 100644 fs/proc/fd.h
