Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880Ab0E0OUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 10:20:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757449Ab0E0OUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 10:20:00 -0400
Subject: [GIT PULL] notifiction tree
From: Eric Paris <eparis@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 May 2010 10:19:55 -0400
Message-ID: <1274969995.2810.88.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull the notification tree including fanotify.  This tree is
basically the same as the last pull request but now has some review!  Al
Viro and I sat down to talk about some of its warts (O/FMODE_NONOTIFY
and using the LSM hooks) and we are both actively working to clean those
up.  Hopefully we'll have those cleanups done in the next week or so,
but this code works, it's just ugly and suboptimal in places.

The following changes since commit 31f46717997a83bdf6db0dd04810c0a329eb3148:
  Linus Torvalds (1):
        Merge branch 'drm-linus' of git://git.kernel.org/.../airlied/drm-2.6

are available in the git repository at:

  git://git.infradead.org/users/eparis/notify.git for-linus

Alexey Dobriyan (1):
      dnotify: move dir_notify_enable declaration

Andreas Gruenbacher (15):
      fsnotify: kill FSNOTIFY_EVENT_FILE
      fsnotify: take inode->i_lock inside fsnotify_find_mark_entry()
      fanotify: create_fd cleanup
      fanotify: Add pids to events
      fsnotify/vfsmount: add fsnotify fields to struct vfsmount
      fsnotify: Infrastructure for per-mount watches
      fanotify: remove fanotify_update_mark
      fanotify: do not call fanotify_update_object_mask in fanotify_remove_mark
      fanotify: do not call fanotify_update_object_mask in fanotify_add_mark
      fanotify: do not return pointer from fanotify_add_*_mark
      fanotify: remove fanotify_add_mark
      fanotify: rename FAN_MARK_ON_VFSMOUNT to FAN_MARK_MOUNT
      fanotify: split fanotify_remove_mark
      fanotify: remove fanotify.h declarations
      fanotify: remove outgoing function checks in fanotify.h

Dave Young (1):
      sysctl extern cleanup: inotify

Eric Paris (80):
      inotify: simplify the inotify idr handling
      Audit: clean up the audit_watch split
      audit: convert audit watches to use fsnotify instead of inotify
      audit: redo audit watch locking and refcnt in light of fsnotify
      audit: do not get and put just to free a watch
      fsnotify: duplicate fsnotify_mark_entry data between 2 marks
      fsnotify: allow addition of duplicate fsnotify marks
      audit: reimplement audit_trees using fsnotify rather than inotify
      Audit: audit watches depend on fsnotify
      Audit: split audit watch Kconfig
      Audit: audit watch init should not be before fsnotify init
      fsnotify: use fsnotify_create_event to allocate the q_overflow event
      inotify: use container_of instead of casting
      fsnotify: kzalloc fsnotify groups
      fsnotify: use kmem_cache_zalloc to simplify event initialization
      inotify: do not reuse watch descriptors
      inotify: remove inotify in kernel interface
      inotify: do not spam console without limit
      fsnotify: provide the data type to should_send_event
      fsnotify: include data in should_send calls
      fsnotify: pass a file instead of an inode to open, read, and write
      fsnotify: send struct file when sending events to parents when possible
      fsnotify: per group notification queue merge types
      fsnotify: clone existing events
      fsnotify: replace an event on a list
      fsnotify: lock annotation for event replacement
      fsnotify: remove group_num altogether
      fsnotify: fsnotify_obtain_group kzalloc cleanup
      fsnotify: fsnotify_obtain_group should be fsnotify_alloc_group
      Audit: only set group mask when something is being watched
      fsnotify: drop mask argument from fsnotify_alloc_group
      fsnotify: rename fsnotify_groups to fsnotify_inode_groups
      fsnotify: initialize the group->num_marks in a better place
      fsnotify: add groups to fsnotify_inode_groups when registering inode watch
      fsnotify: mount point listeners list and global mask
      fsnotify: include vfsmount in should_send_event when appropriate
      fsnotify: put inode specific fields in an fsnotify_mark in a union
      fsnotify: add vfsmount specific fields to the fsnotify_mark_entry union
      fsnotify: add flags to fsnotify_mark_entries
      fsnotify: rename fsnotify_mark_entry to just fsnotify_mark
      fsnotify: rename fsnotify_find_mark_entry to fsnotify_find_mark
      fsnotify: rename mark_entry to just mark
      inotify: rename mark_entry to just mark
      dnotify: rename mark_entry to mark
      vfs: introduce FMODE_NONOTIFY
      fanotify: fscking all notification system
      fanotify:drop notification if they exist in the outgoing queue
      fanotify: merge notification events with different masks
      fanotify: do not clone on merge unless needed
      fanotify: fanotify_init syscall declaration
      fanotify: fanotify_init syscall implementation
      fanotify: sys_fanotify_mark declartion
      fanotify: fanotify_mark syscall implementation
      fanotify: send events using read
      fsnotify: split generic and inode specific mark code
      fsnotify: clear marks to 0 in fsnotify_init_mark
      fsnotify: vfsmount marks generic functions
      fanotify: should_send_event needs to handle vfsmounts
      fanotify: infrastructure to add an remove marks on vfsmounts
      fanotify: hooks the fanotify_mark syscall to the vfsmount code
      fsnotify: allow marks to not pin inodes in core
      fsnotify: ignored_mask - excluding notification
      fanotify: ignored_mask to ignore events
      fanotify: allow users to set an ignored_mask
      fsnotify: clear ignored mask on modify
      fsnotify: allow ignored_mask to survive modification
      fanotify: allow ignored_masks to survive modify
      fanotify: clear all fanotify marks
      fsnotify: add group priorities
      fsnotify: intoduce a notification merge argument
      fanotify: use merge argument to determine actual event added to queue
      fsnotify: use unsigned char * for dentry->d_name.name
      fsnotify: new fsnotify hooks and events types for access decisions
      fanotify: permissions and blocking
      fanotify: userspace interface for permission responses
      fanotify: do not return 0 in a void function
      fsnotify: call iput on inodes when no longer marked
      fsnotify: initialize mask in fsnotify_perm
      fanotify: default Kconfig to n
      fanotify: drop the useless priority argument

H Hartley Sweeten (1):
      inotify_user.c: make local symbol static

Heiko Carstens (1):
      fanotify: CONFIG_HAVE_SYSCALL_WRAPPERS for sys_fanotify_mark

Jean-Christophe Dubois (1):
      fanotify: do not always return 0 in fsnotify

Paul Mundt (1):
      fanotify: select ANON_INODES.

Signed-off-by: Wu Fengguang (1):
      fanotify: FMODE_NONOTIFY and __O_SYNC in sparc conflict

Tejun Heo (1):
      fsnotify: update gfp/slab.h includes

 Documentation/feature-removal-schedule.txt |    8 -
 arch/x86/ia32/ia32entry.S                  |    2 +
 arch/x86/ia32/sys_ia32.c                   |    9 +
 arch/x86/include/asm/sys_ia32.h            |    3 +
 arch/x86/include/asm/unistd_32.h           |    4 +-
 arch/x86/include/asm/unistd_64.h           |    4 +
 arch/x86/kernel/syscall_table_32.S         |    2 +
 fs/compat.c                                |    5 +-
 fs/exec.c                                  |    4 +-
 fs/inode.c                                 |    8 +-
 fs/namei.c                                 |    2 +-
 fs/namespace.c                             |    5 +
 fs/nfsd/vfs.c                              |    4 +-
 fs/notify/Kconfig                          |    1 +
 fs/notify/Makefile                         |    4 +-
 fs/notify/dnotify/dnotify.c                |  198 +++----
 fs/notify/fanotify/Kconfig                 |   26 +
 fs/notify/fanotify/Makefile                |    1 +
 fs/notify/fanotify/fanotify.c              |  255 ++++++++
 fs/notify/fanotify/fanotify_user.c         |  775 +++++++++++++++++++++++
 fs/notify/fsnotify.c                       |  141 ++++-
 fs/notify/fsnotify.h                       |   33 +-
 fs/notify/group.c                          |  174 +++---
 fs/notify/inode_mark.c                     |  309 +++-------
 fs/notify/inotify/Kconfig                  |   15 -
 fs/notify/inotify/Makefile                 |    1 -
 fs/notify/inotify/inotify.c                |  933 ----------------------------
 fs/notify/inotify/inotify.h                |    7 +-
 fs/notify/inotify/inotify_fsnotify.c       |  114 +++-
 fs/notify/inotify/inotify_user.c           |  307 ++++++----
 fs/notify/mark.c                           |  325 ++++++++++
 fs/notify/notification.c                   |  180 +++---
 fs/notify/vfsmount_mark.c                  |  175 ++++++
 fs/open.c                                  |    3 +-
 fs/read_write.c                            |    8 +-
 include/asm-generic/fcntl.h                |    8 +
 include/linux/Kbuild                       |    1 +
 include/linux/dnotify.h                    |    1 +
 include/linux/fanotify.h                   |  105 ++++
 include/linux/fs.h                         |   16 +-
 include/linux/fsnotify.h                   |  166 +++---
 include/linux/fsnotify_backend.h           |  168 ++++--
 include/linux/inotify.h                    |  175 +-----
 include/linux/mount.h                      |    6 +-
 include/linux/security.h                   |    1 +
 include/linux/syscalls.h                   |    4 +
 init/Kconfig                               |   10 +-
 kernel/Makefile                            |    5 +-
 kernel/audit.c                             |    1 -
 kernel/audit.h                             |   26 +-
 kernel/audit_tree.c                        |  233 ++++---
 kernel/audit_watch.c                       |  295 +++++----
 kernel/auditfilter.c                       |   39 +-
 kernel/auditsc.c                           |   10 +-
 kernel/sys_ni.c                            |    4 +
 kernel/sysctl.c                            |    7 +-
 security/security.c                        |   16 +-
 57 files changed, 3092 insertions(+), 2250 deletions(-)
 create mode 100644 fs/notify/fanotify/Kconfig
 create mode 100644 fs/notify/fanotify/Makefile
 create mode 100644 fs/notify/fanotify/fanotify.c
 create mode 100644 fs/notify/fanotify/fanotify_user.c
 delete mode 100644 fs/notify/inotify/inotify.c
 create mode 100644 fs/notify/mark.c
 create mode 100644 fs/notify/vfsmount_mark.c
 create mode 100644 include/linux/fanotify.h

