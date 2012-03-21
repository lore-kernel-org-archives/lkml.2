Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759493Ab2CUCXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 22:23:15 -0400
Received: from tundra.namei.org ([65.99.196.166]:54235 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756572Ab2CUCXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 22:23:10 -0400
Date: Wed, 21 Mar 2012 13:23:05 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] Security subsystem updates for 3.4
Message-ID: <alpine.LRH.2.02.1203211312440.3364@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main addition here is the new Yama security module from Kees Cook, 
which was discussed at the Linux Security Summit last year.  Its purpose 
is to collect miscellaneous DAC security enhancements in one place.  This 
also marks a departure in policy for LSM modules, which were previously 
limited to being standalone access control systems.  Chromium OS is using 
Yama, and I believe there are plans for Ubuntu, at least.

This patchset also includes maintenance updates for AppArmor, TOMOYO and 
others.

Please pull.

--- 

The following changes since commit c16fa4f2ad19908a47c63d8fa436a1178438c7e7:
  Linus Torvalds (1):
        Linux 3.3

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next

Al Viro (2):
      mm: collapse security_vm_enough_memory() variants into a single function
      security: trim security.h

Dan Carpenter (1):
      KEYS: testing wrong bit for KEY_FLAG_REVOKED

David Howells (1):
      KEYS: Allow special keyrings to be cleared

Dmitry Kasatkin (2):
      ima: policy for RAMFS
      digsig: changed type of the timestamp

Eric Paris (1):
      IMA: fix audit res field to indicate 1 for success and 0 for failure

Fabio Estevam (1):
      ima: fix Kconfig dependencies

James Morris (4):
      Merge branch 'linus-master'; commit 'v3.3-rc3' into next
      Merge branch 'next-queue' into next
      Merge branch 'for-security' of git://git.kernel.org/.../jj/linux-apparmor into next
      Merge branch 'for-security' of git://git.kernel.org/.../jj/linux-apparmor into next

Jan Engelhardt (1):
      AppArmor: add const qualifiers to string arrays

John Johansen (13):
      AppArmor: Add mising end of structure test to caps unpacking
      AppArmor: Fix dropping of allowed operations that are force audited
      AppArmor: Fix underflow in xindex calculation
      AppArmor: fix mapping of META_READ to audit and quiet flags
      AppArmor: Fix the error case for chroot relative path name lookup
      AppArmor: Fix error returned when a path lookup is disconnected
      AppArmor: Fix oops in policy unpack auditing
      AppArmor: Add const qualifiers to generated string tables
      AppArmor: Retrieve the dentry_path for error reporting when path lookup fails
      AppArmor: Minor cleanup of d_namespace_path to consolidate error handling
      AppArmor: Update dfa matching routines.
      AppArmor: Move path failure information into aa_get_name and rename
      AppArmor: Add ability to load extended policy

Kees Cook (7):
      security: create task_free security callback
      security: Yama LSM
      Yama: add PR_SET_PTRACER_ANY
      AppArmor: refactor securityfs to use structures
      AppArmor: add initial "features" directory to securityfs
      AppArmor: add "file" details to securityfs
      AppArmor: export known rlimit names/value mappings in securityfs

Randy Dunlap (1):
      security: fix ima kconfig warning

Stefan Berger (2):
      tpm_tis: Only probe iTPMs
      tpm_tis: Clean up after module_param cleanup

Tetsuo Handa (4):
      TOMOYO: Fix mount flags checking order.
      TOMOYO: Return appropriate value to poll().
      TOMOYO: Return error if fails to delete a domain
      AppArmor: Fix location of const qualifier on generated string tables

Tim Gardner (1):
      TPM: Zero buffer whole after copying to userspace

 Documentation/networking/dns_resolver.txt |    4 +
 Documentation/security/00-INDEX           |    2 +
 Documentation/security/Yama.txt           |   65 ++++++
 Documentation/security/keys.txt           |    4 +
 drivers/char/tpm/Kconfig                  |    1 -
 drivers/char/tpm/tpm.c                    |    3 +-
 drivers/char/tpm/tpm.h                    |    2 +
 drivers/char/tpm/tpm_tis.c                |   17 +-
 drivers/net/macvtap.c                     |    1 +
 drivers/target/iscsi/iscsi_target.c       |    1 +
 drivers/target/iscsi/iscsi_target_login.c |    1 +
 fs/cifs/cifsacl.c                         |    1 +
 fs/nfs/client.c                           |    1 +
 fs/nfs/idmap.c                            |    1 +
 fs/proc/proc_sysctl.c                     |    2 +
 fs/quota/dquot.c                          |    1 +
 fs/super.c                                |    1 +
 include/linux/digsig.h                    |    4 +-
 include/linux/key.h                       |    1 +
 include/linux/prctl.h                     |    7 +
 include/linux/security.h                  |   80 ++++----
 include/net/sock.h                        |    2 +
 ipc/msgutil.c                             |    2 +
 kernel/cred.c                             |    1 +
 kernel/exit.c                             |    1 +
 kernel/fork.c                             |    3 +-
 kernel/sched/core.c                       |    1 +
 kernel/sysctl.c                           |    1 +
 mm/mmap.c                                 |   17 ++-
 mm/mprotect.c                             |    2 +-
 mm/mremap.c                               |    2 +-
 mm/shmem.c                                |    4 +-
 mm/swapfile.c                             |    4 +-
 net/dns_resolver/dns_key.c                |    1 +
 security/Kconfig                          |    6 +
 security/Makefile                         |    2 +
 security/apparmor/Makefile                |   27 ++-
 security/apparmor/apparmorfs.c            |  195 ++++++++++++++----
 security/apparmor/audit.c                 |    7 +-
 security/apparmor/domain.c                |    5 +-
 security/apparmor/file.c                  |   21 +--
 security/apparmor/include/apparmor.h      |   15 ++-
 security/apparmor/include/apparmorfs.h    |   44 ++++
 security/apparmor/include/audit.h         |    9 +-
 security/apparmor/include/file.h          |    2 +-
 security/apparmor/include/match.h         |    3 +
 security/apparmor/include/path.h          |    3 +-
 security/apparmor/include/policy.h        |   15 ++-
 security/apparmor/include/resource.h      |    4 +
 security/apparmor/match.c                 |   80 +++++++-
 security/apparmor/path.c                  |   56 +++--
 security/apparmor/policy.c                |    3 +-
 security/apparmor/policy_unpack.c         |   31 +++-
 security/apparmor/resource.c              |    5 +
 security/capability.c                     |    5 +
 security/commoncap.c                      |    1 +
 security/integrity/ima/Kconfig            |    4 +-
 security/integrity/ima/ima_audit.c        |    2 +-
 security/integrity/ima/ima_policy.c       |    3 +-
 security/keys/keyctl.c                    |   15 ++-
 security/keys/process_keys.c              |    3 +-
 security/security.c                       |   21 +--
 security/selinux/hooks.c                  |    2 +
 security/smack/smack_lsm.c                |    3 +
 security/tomoyo/audit.c                   |    4 +-
 security/tomoyo/common.c                  |   63 ++----
 security/tomoyo/common.h                  |    6 +-
 security/tomoyo/mount.c                   |   38 ++--
 security/tomoyo/securityfs_if.c           |    5 +-
 security/yama/Kconfig                     |   13 ++
 security/yama/Makefile                    |    3 +
 security/yama/yama_lsm.c                  |  323 +++++++++++++++++++++++++++++
 72 files changed, 1036 insertions(+), 252 deletions(-)
 create mode 100644 Documentation/security/Yama.txt
 create mode 100644 security/yama/Kconfig
 create mode 100644 security/yama/Makefile
 create mode 100644 security/yama/yama_lsm.c
