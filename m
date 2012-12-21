Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050Ab2LUAVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 19:21:21 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:48968 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab2LUAVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 19:21:16 -0500
Date: Fri, 21 Dec 2012 00:21:15 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs.git
Message-ID: <20121221002115.GN4939@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fscache fixes, ESTALE patchset, vmtruncate removal series, assorted
misc stuff.  Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs for-linus

Shortlog:
Al Viro (1):
      path_init(): make -ENOTDIR failure exits consistent

Alessio Igor Bogani (1):
      vfs: Remove useless function prototypes

David Howells (23):
      CacheFiles: Fix the marking of cached pages
      CacheFiles: Downgrade the requirements passed to the allocator
      FS-Cache: Check that there are no read ops when cookie relinquished
      CacheFiles: Make some debugging statements conditional
      FS-Cache: Make cookie relinquishment wait for outstanding reads
      FS-Cache: Fix operation state management and accounting
      FS-Cache: Provide proper invalidation
      VFS: Make more complete truncate operation available to CacheFiles
      CacheFiles: Implement invalidation
      NFS: Use FS-Cache invalidation
      CacheFiles: Add missing retrieval completions
      FS-Cache: Convert the object event ID #defines into an enum
      FS-Cache: Initialise the object event mask with the calculated mask
      FS-Cache: Don't mask off the object event mask when printing it
      FS-Cache: Limit the number of I/O error reports for a cache
      FS-Cache: Exclusive op submission can BUG if there's been an I/O error
      NFS: nfs_migrate_page() does not wait for FS-Cache to finish with a page
      FS-Cache: Add transition to handle invalidate immediately after lookup
      NFS4: Open files for fscaching
      FS-Cache: Fix signal handling during waits
      FS-Cache: One of the write operation paths doesn't set the object state
      FS-Cache: Mark cancellation of in-progress operation
      FS-Cache: Clear remaining page count on retrieval cancellation

Jan Kara (1):
      fs: Fix imbalance in freeze protection in mark_files_ro()

Jeff Layton (30):
      vfs: remove unneeded permission check from path_init
      vfs: remove DCACHE_NEED_LOOKUP
      vfs: add a retry_estale helper function to handle retries on ESTALE
      vfs: make fstatat retry on ESTALE errors from getattr call
      vfs: fix readlinkat to retry on ESTALE
      vfs: turn is_dir argument to kern_path_create into a lookup_flags arg
      vfs: fix mknodat to retry on ESTALE errors
      vfs: fix mkdirat to retry once on an ESTALE error
      vfs: fix symlinkat to retry on ESTALE errors
      vfs: fix linkat to retry once on ESTALE errors
      vfs: add a flags argument to user_path_parent
      vfs: make do_rmdir retry once on ESTALE errors
      vfs: make do_unlinkat retry once on ESTALE errors
      vfs: fix renameat to retry on ESTALE errors
      vfs: have do_sys_truncate retry once on an ESTALE error
      vfs: have faccessat retry once on an ESTALE error
      vfs: have chdir retry lookup and call once on ESTALE error
      vfs: have chroot retry once on ESTALE error
      vfs: make fchmodat retry once on ESTALE errors
      vfs: make fchownat retry once on ESTALE errors
      vfs: fix user_statfs to retry once on ESTALE errors
      vfs: allow utimensat() calls to retry once on an ESTALE error
      vfs: allow setxattr to retry once on ESTALE errors
      vfs: allow lsetxattr() to retry once on ESTALE errors
      vfs: make getxattr retry once on an ESTALE error
      vfs: make lgetxattr retry once on ESTALE
      vfs: make listxattr retry once on ESTALE error
      vfs: make llistxattr retry once on ESTALE error
      vfs: make removexattr retry once on ESTALE
      vfs: make lremovexattr retry once on ESTALE error

Marco Stornelli (21):
      ufs: drop vmtruncate
      sysv: drop vmtruncate
      reiserfs: drop vmtruncate
      procfs: drop vmtruncate
      omfs: drop vmtruncate
      ocfs2: drop vmtruncate
      adfs: drop vmtruncate
      affs: drop vmtruncate
      bfs: drop vmtruncate
      hfs: drop vmtruncate
      hpfs: drop vmtruncate
      jfs: drop vmtruncate
      hfsplus: drop vmtruncate
      logfs: drop vmtruncate
      minix: drop vmtruncate
      ncpfs: drop vmtruncate
      nilfs2: drop vmtruncate
      ntfs: drop vmtruncate
      vfs: drop vmtruncate
      mm: drop vmtruncate
      documentation: drop vmtruncate

Miao Xie (1):
      vfs, freeze: use ACCESS_ONCE() to guard access to ->mnt_flags

NeilBrown (1):
      vfs: d_obtain_alias() needs to use "/" as default name.

Diffstat:
 Documentation/filesystems/Locking                 |    6 -
 Documentation/filesystems/caching/backend-api.txt |   38 ++++-
 Documentation/filesystems/caching/netfs-api.txt   |   46 ++++-
 Documentation/filesystems/caching/object.txt      |   23 ++-
 Documentation/filesystems/caching/operations.txt  |    2 +-
 Documentation/filesystems/porting                 |    2 +-
 Documentation/filesystems/vfs.txt                 |   11 --
 arch/powerpc/platforms/cell/spufs/syscalls.c      |    2 +-
 drivers/base/devtmpfs.c                           |    2 +-
 fs/adfs/inode.c                                   |   15 +-
 fs/affs/file.c                                    |   18 ++-
 fs/affs/inode.c                                   |    5 +-
 fs/bfs/file.c                                     |   15 +-
 fs/btrfs/inode.c                                  |   16 +--
 fs/cachefiles/interface.c                         |   57 ++++++-
 fs/cachefiles/internal.h                          |    2 +
 fs/cachefiles/key.c                               |    2 +-
 fs/cachefiles/namei.c                             |    3 +-
 fs/cachefiles/rdwr.c                              |  114 +++++++-----
 fs/cachefiles/xattr.c                             |    2 +-
 fs/dcache.c                                       |   35 +----
 fs/file_table.c                                   |    2 +-
 fs/fscache/cache.c                                |    8 +-
 fs/fscache/cookie.c                               |   78 ++++++++
 fs/fscache/internal.h                             |   15 ++-
 fs/fscache/object-list.c                          |    2 +-
 fs/fscache/object.c                               |  101 ++++++++++-
 fs/fscache/operation.c                            |  140 ++++++++++++----
 fs/fscache/page.c                                 |  195 +++++++++++++++++----
 fs/fscache/stats.c                                |   17 ++-
 fs/hfs/inode.c                                    |   26 ++-
 fs/hfsplus/inode.c                                |   27 ++--
 fs/hpfs/file.c                                    |   20 ++-
 fs/hpfs/hpfs_fn.h                                 |    1 +
 fs/hpfs/inode.c                                   |    5 +-
 fs/jfs/file.c                                     |    6 +-
 fs/jfs/inode.c                                    |   20 ++-
 fs/libfs.c                                        |    2 -
 fs/logfs/readwrite.c                              |   10 +-
 fs/minix/file.c                                   |    6 +-
 fs/minix/inode.c                                  |   17 ++-
 fs/namei.c                                        |  118 +++++++++----
 fs/namespace.c                                    |    2 +-
 fs/ncpfs/inode.c                                  |    4 +-
 fs/nfs/fscache.c                                  |    1 +
 fs/nfs/fscache.h                                  |   20 ++-
 fs/nfs/inode.c                                    |   20 ++-
 fs/nfs/nfs4file.c                                 |    2 +
 fs/nfs/nfs4proc.c                                 |    3 +-
 fs/nfs/write.c                                    |    3 +-
 fs/nilfs2/file.c                                  |    1 -
 fs/nilfs2/inode.c                                 |   24 ++-
 fs/nilfs2/nilfs.h                                 |    1 +
 fs/nilfs2/recovery.c                              |    3 +-
 fs/ntfs/file.c                                    |   16 ++-
 fs/ntfs/inode.c                                   |    8 +-
 fs/ntfs/inode.h                                   |    4 +
 fs/ocfs2/file.c                                   |   18 --
 fs/omfs/file.c                                    |   22 ++-
 fs/open.c                                         |   97 +++++++----
 fs/proc/base.c                                    |    7 -
 fs/proc/generic.c                                 |    9 +-
 fs/proc/proc_sysctl.c                             |    7 -
 fs/reiserfs/file.c                                |    3 +-
 fs/reiserfs/inode.c                               |   15 ++-
 fs/reiserfs/reiserfs.h                            |    1 +
 fs/stat.c                                         |   16 ++-
 fs/statfs.c                                       |    9 +-
 fs/sysv/file.c                                    |    5 +-
 fs/sysv/itree.c                                   |   17 ++-
 fs/ufs/inode.c                                    |   15 +-
 fs/utimes.c                                       |    6 +-
 fs/xattr.c                                        |   72 ++++++--
 include/linux/dcache.h                            |    8 -
 include/linux/fs.h                                |    6 +-
 include/linux/fscache-cache.h                     |   71 ++++++--
 include/linux/fscache.h                           |   50 +++++-
 include/linux/mm.h                                |    1 -
 include/linux/namei.h                             |   20 ++-
 mm/truncate.c                                     |   23 ---
 80 files changed, 1311 insertions(+), 531 deletions(-)
