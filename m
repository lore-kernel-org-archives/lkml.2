Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759688Ab2EVCY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 22:24:27 -0400
Received: from tundra.namei.org ([65.99.196.166]:55993 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758910Ab2EVCYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 22:24:24 -0400
Date: Tue, 22 May 2012 12:24:22 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [GIT] Security subsystem updates for 3.5
Message-ID: <alpine.LRH.2.02.1205221214470.23889@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

New notable features:
 - The seccomp work from Will Drewry
 - PR_{GET,SET}_NO_NEW_PRIVS from Andy Lutomirski
 - Longer security labels for Smack from Casey Schaufler
 - Additional ptrace restriction modes for Yama by Kees Cook


Please pull.

The following changes since commit 76e10d158efb6d4516018846f60c2ab5501900bc:
  Linus Torvalds (1):
        Linux 3.4

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next

Andy Lutomirski (1):
      Add PR_{GET,SET}_NO_NEW_PRIVS to prevent execve from granting privs

Casey Schaufler (2):
      Smack: recursive tramsmute
      Smack: allow for significantly longer Smack labels v4

Dan Carpenter (1):
      Yama: remove an unused variable

David Howells (9):
      KEYS: Use the compat keyctl() syscall wrapper on Sparc64 for Sparc32 compat
      KEYS: Move the key config into security/keys/Kconfig
      KEYS: Reorganise keys Makefile
      KEYS: Announce key type (un)registration
      KEYS: Perform RCU synchronisation on keys prior to key destruction
      KEYS: Permit in-place link replacement in keyring list
      KEYS: Do LRU discard in full keyrings
      KEYS: Add invalidation support
      KEYS: Don't check for NULL key pointer in key_validate()

Eric Paris (22):
      SELinux: allow seek operations on the file exposing policy
      SELinux: loosen DAC perms on reading policy
      SELinux: include flow.h where used rather than get it indirectly
      SELinux: allow default source/target selectors for user/role/range
      SELinux: add default_type statements
      SELinux: check OPEN on truncate calls
      SELinux: rename dentry_open to file_open
      SELinux: audit failed attempts to set invalid labels
      SELinux: possible NULL deref in context_struct_to_string
      SELinux: remove needless sel_div function
      SELinux: if sel_make_bools errors don't leave inconsistent state
      SELinux: delay initialization of audit data in selinux_inode_permission
      SELinux: remove inode_has_perm_noadp
      SELinux: move common_audit_data to a noinline slow path function
      LSM: remove the COMMON_AUDIT_DATA_INIT type expansion
      apparmor: move task from common_audit_data to apparmor_audit_data
      LSM: remove the task field from common_audit_data
      LSM: BUILD_BUG_ON if the common_audit_data union ever grows
      LSM: do not initialize common_audit_data to 0
      SELinux: remove auditdeny from selinux_audit_data
      SELinux: unify the selinux_audit_data and selinux_late_audit_data
      SELinux: remove unused common_audit_data in flush_unauthorized_files

James Morris (6):
      Merge branch 'linus-master'; commit 'v3.4-rc2' into next
      maintainers: add kernel/capability.c to capabilities entry
      maintainers: update wiki url for the security subsystem
      Merge tag 'v3.4-rc5' into next
      Merge branch 'for-1205' of http://git.gitorious.org/smack-next/kernel into next
      Merge branch 'master' of git://git.infradead.org/users/eparis/selinux into next

John Johansen (3):
      Fix execve behavior apparmor for PR_{GET,SET}_NO_NEW_PRIVS
      apparmor: fix profile lookup for unconfined
      apparmor: fix long path failure due to disconnected path

Kees Cook (3):
      seccomp: remove duplicated failure logging
      Yama: add additional ptrace scopes
      Yama: replace capable() with ns_capable()

Mimi Zohar (1):
      ima: fix filename hint to reflect script interpreter name

Stephen Rothwell (1):
      seccomp: use a static inline for a function stub

Tetsuo Handa (2):
      TOMOYO: Accept manager programs which do not start with / .
      gfp flags for security_inode_alloc()?

Wanlong Gao (2):
      SELinux: replace weak GFP_ATOMIC to GFP_KERNEL in avc_add_callback
      SELinux: avc: remove the useless fields in avc_add_callback

Will Drewry (15):
      sk_run_filter: add BPF_S_ANC_SECCOMP_LD_W
      net/compat.c,linux/filter.h: share compat_sock_fprog
      seccomp: kill the seccomp_t typedef
      asm/syscall.h: add syscall_get_arch
      arch/x86: add syscall_get_arch to syscall.h
      seccomp: add system call filtering using BPF
      seccomp: add SECCOMP_RET_ERRNO
      signal, x86: add SIGSYS info and make it synchronous.
      seccomp: Add SECCOMP_RET_TRAP
      ptrace,seccomp: Add PTRACE_SECCOMP support
      x86: Enable HAVE_ARCH_SECCOMP_FILTER
      Documentation: prctl/seccomp_filter
      seccomp: ignore secure_computing return values
      seccomp: fix build warnings when there is no CONFIG_SECCOMP_FILTER
      samples/seccomp: fix dependencies on arch macros

 Documentation/prctl/seccomp_filter.txt |  163 ++++++
 Documentation/security/Smack.txt       |  204 +++++--
 Documentation/security/Yama.txt        |   10 +-
 Documentation/security/keys.txt        |   17 +
 MAINTAINERS                            |    3 +-
 arch/Kconfig                           |   23 +
 arch/microblaze/kernel/ptrace.c        |    2 +-
 arch/mips/kernel/ptrace.c              |    2 +-
 arch/powerpc/kernel/ptrace.c           |    2 +-
 arch/s390/kernel/ptrace.c              |    2 +-
 arch/sh/kernel/ptrace_32.c             |    2 +-
 arch/sh/kernel/ptrace_64.c             |    2 +-
 arch/sparc/Kconfig                     |    3 +
 arch/sparc/kernel/ptrace_64.c          |    2 +-
 arch/sparc/kernel/systbls_64.S         |    2 +-
 arch/x86/Kconfig                       |    1 +
 arch/x86/ia32/ia32_signal.c            |    4 +
 arch/x86/include/asm/ia32.h            |    6 +
 arch/x86/include/asm/syscall.h         |   27 +
 arch/x86/kernel/ptrace.c               |    7 +-
 fs/exec.c                              |   10 +-
 fs/open.c                              |    2 +-
 include/asm-generic/siginfo.h          |   22 +
 include/asm-generic/syscall.h          |   14 +
 include/keys/keyring-type.h            |    2 +-
 include/linux/Kbuild                   |    1 +
 include/linux/audit.h                  |    8 +-
 include/linux/filter.h                 |   12 +
 include/linux/key.h                    |   11 +-
 include/linux/keyctl.h                 |    1 +
 include/linux/lsm_audit.h              |    6 -
 include/linux/prctl.h                  |   15 +
 include/linux/ptrace.h                 |    5 +-
 include/linux/sched.h                  |    4 +-
 include/linux/seccomp.h                |  107 +++-
 include/linux/security.h               |   14 +-
 kernel/auditsc.c                       |    8 +-
 kernel/fork.c                          |    3 +
 kernel/seccomp.c                       |  458 ++++++++++++++-
 kernel/signal.c                        |    9 +-
 kernel/sys.c                           |   12 +-
 net/compat.c                           |    8 -
 net/core/filter.c                      |    6 +
 net/dns_resolver/dns_key.c             |    5 -
 net/xfrm/xfrm_policy.c                 |    1 +
 samples/Makefile                       |    2 +-
 samples/seccomp/Makefile               |   32 +
 samples/seccomp/bpf-direct.c           |  190 ++++++
 samples/seccomp/bpf-fancy.c            |  102 ++++
 samples/seccomp/bpf-helper.c           |   89 +++
 samples/seccomp/bpf-helper.h           |  238 ++++++++
 samples/seccomp/dropper.c              |   68 +++
 security/Kconfig                       |   68 +--
 security/apparmor/audit.c              |   11 +-
 security/apparmor/capability.c         |    4 +-
 security/apparmor/domain.c             |   35 ++
 security/apparmor/file.c               |    2 +-
 security/apparmor/include/audit.h      |    1 +
 security/apparmor/ipc.c                |    2 +-
 security/apparmor/lib.c                |    2 +-
 security/apparmor/lsm.c                |    6 +-
 security/apparmor/path.c               |    2 +
 security/apparmor/policy.c             |    6 +-
 security/apparmor/policy_unpack.c      |    2 +-
 security/apparmor/resource.c           |    2 +-
 security/capability.c                  |    4 +-
 security/commoncap.c                   |    7 +-
 security/integrity/ima/ima_main.c      |    4 +-
 security/keys/Kconfig                  |   71 +++
 security/keys/Makefile                 |   12 +-
 security/keys/compat.c                 |    3 +
 security/keys/gc.c                     |   94 +--
 security/keys/internal.h               |   15 +-
 security/keys/key.c                    |   25 +
 security/keys/keyctl.c                 |   34 ++
 security/keys/keyring.c                |  167 ++++--
 security/keys/permission.c             |   43 +-
 security/keys/proc.c                   |    3 +-
 security/keys/process_keys.c           |    2 +
 security/lsm_audit.c                   |   15 +-
 security/security.c                    |    4 +-
 security/selinux/avc.c                 |  130 +----
 security/selinux/hooks.c               |  268 ++++-----
 security/selinux/include/avc.h         |  100 +++-
 security/selinux/include/security.h    |    4 +-
 security/selinux/netif.c               |    6 +-
 security/selinux/netnode.c             |    6 +-
 security/selinux/netport.c             |    6 +-
 security/selinux/selinuxfs.c           |   11 +-
 security/selinux/ss/context.h          |   20 +
 security/selinux/ss/mls.c              |   24 +
 security/selinux/ss/policydb.c         |   44 ++
 security/selinux/ss/policydb.h         |   14 +
 security/selinux/ss/services.c         |   56 +-
 security/smack/smack.h                 |   59 +-
 security/smack/smack_access.c          |  233 ++++----
 security/smack/smack_lsm.c             |  243 +++-----
 security/smack/smackfs.c               |  993 ++++++++++++++++++++++++--------
 security/tomoyo/common.c               |   26 +-
 security/tomoyo/common.h               |    1 -
 security/tomoyo/tomoyo.c               |    6 +-
 security/yama/yama_lsm.c               |   63 +-
 102 files changed, 3678 insertions(+), 1230 deletions(-)
 create mode 100644 Documentation/prctl/seccomp_filter.txt
 create mode 100644 samples/seccomp/Makefile
 create mode 100644 samples/seccomp/bpf-direct.c
 create mode 100644 samples/seccomp/bpf-fancy.c
 create mode 100644 samples/seccomp/bpf-helper.c
 create mode 100644 samples/seccomp/bpf-helper.h
 create mode 100644 samples/seccomp/dropper.c
 create mode 100644 security/keys/Kconfig
