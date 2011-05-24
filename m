Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370Ab1EXNsf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 09:48:35 -0400
Received: from tundra.namei.org ([65.99.196.166]:54647 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932244Ab1EXNse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 09:48:34 -0400
Date: Tue, 24 May 2011 23:48:10 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [GIT] Security subsystem updates for 2.6.40 (or equivalent)
Message-ID: <alpine.LRH.2.00.1105242343210.12590@tundra.namei.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mostly bugfixes for this kernel.

Please pull.

The following changes since commit d762f4383100c2a87b1a3f2d678cd3b5425655b4:
  Linus Torvalds (1):
        Merge branch 'sh-latest' of git://git.kernel.org/.../lethal/sh-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6 for-linus

Andi Kleen (1):
      SECURITY: Move exec_permission RCU checks into security modules

David Howells (3):
      KEYS: Improve /proc/keys
      KEYS: Make request_key() and co. return an error for a negative key
      CRED: Fix load_flat_shared_library() to initialise bprm correctly

Eric Paris (24):
      SELinux: update git tree in MAINTAINERS
      capabilites: allow the application of capability limits to usermode helpers
      capabilities: do not special case exec of init
      capabilities: do not drop CAP_SETPCAP from the initial task
      capabilities: delete unused cap_set_full
      capabilities: delete all CAP_INIT macros
      SELinux: delete debugging printks from filename_trans rule processing
      SELinux: silence build warning when !CONFIG_BUG
      SELinux: security_read_policy should take a size_t not ssize_t
      SELINUX: Make selinux cache VFS RCU walks safe
      LSM: split LSM_AUDIT_DATA_FS into _PATH and _INODE
      LSM: separate LSM_AUDIT_DATA_DENTRY from LSM_AUDIT_DATA_PATH
      SMACK: smack_file_lock can use the struct path
      SELinux: fix comment to state filename_compute_type takes an objname not a qstr
      SELinux: rename filename_compute_type argument to *type instead of *con
      SELinux: skip filename trans rules if ttype does not match parent dir
      SELinux: calculate and print hashtab stats with a generic function
      SELinux: generic hashtab entry counter
      SELinux: put name based create rules in a hashtable
      SELinux: pass last path component in may_create
      flex_array: flex_array_prealloc takes a number of elements, not an end
      flex_arrays: allow zero length flex arrays
      flex_array: allow 0 length elements
      SELinux: introduce path_has_perm

Greg Kroah-Hartman (1):
      SELINUX: add /sys/fs/selinux mount point to put selinuxfs

Harry Ciao (4):
      SELinux: Add class support to the role_trans structure
      SELinux: Compute role in newcontext for all classes
      SELinux: Write class field in role_trans_write.
      Initialize policydb.process_class eariler.

James Morris (6):
      Merge branch 'master'; commit 'v2.6.39-rc1' into next
      Merge branch 'next-queue' into next
      Merge branch 'master'; commit 'v2.6.39-rc3' into next
      Merge branch 'master' into next
      Merge branch 'next' into for-linus
      Merge branch 'master' of git://git.infradead.org/users/eparis/selinux into for-linus

Kohei Kaigai (1):
      selinux: add type_transition with name extension support for selinuxfs

Paul Gortmaker (1):
      security: select correct default LSM_MMAP_MIN_ADDR on ARM.

Stephen Smalley (1):
      selinux: Fix regression for Xorg

Tetsuo Handa (5):
      TOMOYO: Fix race on updating profile's comment line.
      TOMOYO: Don't add / for allow_unmount permission check.
      TOMOYO: Fix infinite loop bug when reading /sys/kernel/security/tomoyo/audit
      TOMOYO: Fix refcount leak in tomoyo_mount_acl().
      TOMOYO: Fix wrong domainname validation.

Xiaochen Wang (1):
      tomoyo: fix memory leak in tomoyo_commit_ok()

 MAINTAINERS                         |    3 +-
 fs/binfmt_flat.c                    |    8 +
 include/linux/capability.h          |    5 -
 include/linux/init_task.h           |    7 -
 include/linux/key.h                 |   13 ++
 include/linux/kmod.h                |    3 +
 include/linux/lsm_audit.h           |   11 +-
 kernel/capability.c                 |    4 -
 kernel/cred.c                       |    6 +-
 kernel/kmod.c                       |  100 ++++++++++++++
 kernel/sysctl.c                     |    6 +
 lib/flex_array.c                    |   26 +++-
 net/dns_resolver/dns_key.c          |   10 +-
 security/Kconfig                    |    1 +
 security/commoncap.c                |   13 +--
 security/keys/internal.h            |    4 +-
 security/keys/keyctl.c              |    6 +
 security/keys/keyring.c             |   37 ++++--
 security/keys/proc.c                |    2 +-
 security/keys/process_keys.c        |   12 +-
 security/keys/request_key.c         |    3 +-
 security/keys/request_key_auth.c    |    3 +-
 security/keys/user_defined.c        |    4 +-
 security/lsm_audit.c                |   59 +++++----
 security/selinux/avc.c              |    2 +-
 security/selinux/hooks.c            |   92 ++++++++------
 security/selinux/include/security.h |    9 +-
 security/selinux/netnode.c          |    1 +
 security/selinux/selinuxfs.c        |   28 ++++-
 security/selinux/ss/policydb.c      |  244 ++++++++++++++++++++++++-----------
 security/selinux/ss/policydb.h      |   12 ++-
 security/selinux/ss/services.c      |   72 ++++++-----
 security/smack/smack.h              |   11 +-
 security/smack/smack_lsm.c          |   48 ++++---
 security/tomoyo/common.c            |   17 ++-
 security/tomoyo/file.c              |    1 -
 security/tomoyo/memory.c            |    1 +
 security/tomoyo/mount.c             |    1 +
 security/tomoyo/util.c              |    2 +-
 39 files changed, 603 insertions(+), 284 deletions(-)
