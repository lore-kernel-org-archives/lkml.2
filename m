Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab1JXLV6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 07:21:58 -0400
Received: from tundra.namei.org ([65.99.196.166]:35286 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755257Ab1JXLVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 07:21:55 -0400
Date: Mon, 24 Oct 2011 22:21:53 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] Security subsystem updates for 3.2
Message-ID: <alpine.LRH.2.00.1110242108540.19271@tundra.namei.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The most significant item here is the inclusion of EVM:
https://lkml.org/lkml/2011/6/29/419

There are also enhancements to Smack and Tomoyo, as well as general 
cleanups and fixes across the subsystem.

Please pull.


The following changes since commit c3b92c8787367a8bb53d57d9789b558f1295cc96:
  Linus Torvalds (1):
        Linux 3.1

are available in the git repository at:

  git://selinuxproject.org/~jmorris/linux-security next

Axel Lin (1):
      CRED: fix build error due to 'tgcred' undeclared

Casey Schaufler (4):
      Smack: Rule list lookup performance
      Smack: Repair processing of fcntl
      Smack: Clean up comments
      Smack: Provide information for UDS getsockopt(SO_PEERCRED)

David Howells (8):
      KEYS: If install_session_keyring() is given a keyring, it should install it
      KEYS: keyctl_get_keyring_ID() should create a session keyring if create flag set
      KEYS: __key_link() should use the RCU deref wrapper for keyring payloads
      CRED: Fix prepare_kernel_cred() to provide a new thread_group_cred struct
      KEYS: Move the unreferenced key reaper to the keys garbage collector file
      KEYS: Make the key reaper non-reentrant
      KEYS: The dead key link reaper should be non-reentrant
      KEYS: Correctly destroy key payloads when their keytype is removed

Dmitry Kasatkin (6):
      evm: add support for different security.evm data types
      evm: crypto hash replaced by shash
      evm: additional parameter to pass integrity cache entry 'iint'
      evm: evm_verify_hmac must not return INTEGRITY_UNKNOWN
      evm: replace hmac_status with evm_status
      evm: clean verification status

James Morris (23):
      Merge branch 'linus'; commit 'v3.1-rc1' into next
      Merge branch 'next-queue' into next
      Merge branch 'next-evm' of git://git.kernel.org/.../zohar/ima-2.6 into next
      EVM: ensure trusted and encypted key symbols are available to EVM
      integrity: sparse fix: move iint_initialized to integrity.h
      apparmor: sparse fix: make aa_create_aafs static
      selinux: sparse fix: make selinux_secmark_refcount static
      selinux: sparse fix: move selinux_complete_init
      selinux: sparse fix: declare selinux_disable() in security.h
      apparmor: sparse fix: include ipc.h
      apparmor: sparse fix: add apparmor.h to lib.c
      apparmor: sparse fix: rename shadowed variables in policy_unpack.c
      apparmor: sparse fix: include procattr.h in procattr.c
      ima: sparse fix: make ima_open_policy static
      ima: sparse fix: include linux/ima.h in ima_main.c
      selinux: sparse fix: eliminate warnings for selinuxfs
      selinux: sparse fix: fix warnings in netlink code
      selinux: sparse fix: include selinux.h in exports.c
      selinux: sparse fix: fix several warnings in the security server code
      security: sparse fix: Move security_fixup_op to security.h
      Merge branch 'next-evm' of git://github.com/mzohar/linux-evm into next
      Merge branch 'next-hex2bin' of git://github.com/mzohar/linux-evm into next
      Merge branch 'master' of git://gitorious.org/smack-next/kernel into next

Jarkko Sakkinen (6):
      Smack: check permissions from user space (v2)
      Smack: domain transition protections (v3)
      Smack: fix for /smack/access output, use string instead of byte
      Smack: compilation fix
      Smack: fix: invalid length set for the result of /smack/access
      Smack: allow to access /smack/access as normal user

Mimi Zohar (28):
      security: new security_inode_init_security API adds function callback
      integrity: move ima inode integrity data management
      xattr: define vfs_getxattr_alloc and vfs_xattr_cmp
      evm: re-release
      security: imbed evm calls in security hooks
      evm: evm_inode_post_removexattr
      evm: imbed evm_inode_post_setattr
      evm: add evm_inode_init_security to initialize new files
      evm: call evm_inode_init_security from security_inode_init_security
      evm: permit only valid security.evm xattrs to be updated
      evm: add evm_inode_setattr to prevent updating an invalid security.evm
      evm: building without EVM enabled fixes
      evm: fix evm_inode_init_security return code
      CIFS: remove local xattr definitions
      evm: fix build problems
      evm: add Kconfig TCG_TPM dependency
      evm: add MAINTAINERS entry
      encrypted-keys: create encrypted-keys directory
      encrypted-keys: remove trusted-keys dependency
      evm: remove TCG_TPM dependency
      evm: fix security/security_old_init_security return code
      evm: limit verifying current security.evm integrity
      evm: posix acls modify i_mode
      evm: permit mode bits to be updated
      lib: add error checking to hex2bin
      trusted-keys: check hex2bin result
      encrypted-keys: check hex2bin result
      target: check hex2bin result

Oleg Nesterov (1):
      tomoyo: remove tomoyo_gc_thread()->daemonize()

Paul Moore (2):
      doc: Update the MAINTAINERS info for Paul Moore
      doc: Update the email address for Paul Moore in various source files

Serge Hallyn (1):
      capabilities: initialize has_cap

Stefan Berger (1):
      tpm: suppress durations sysfs output if not read

Stephen Rothwell (1):
      encrypted-keys: IS_ERR need include/err.h

Tetsuo Handa (16):
      TOMOYO: Fix incorrect enforce mode.
      TOMOYO: Add environment variable name restriction support.
      TOMOYO: Add socket operation restriction support.
      TOMOYO: Allow controlling generation of access granted logs for per an entry basis.
      TOMOYO: Allow domain transition without execve().
      TOMOYO: Avoid race when retrying "file execute" permission check.
      TOMOYO: Bump version.
      TOMOYO: Allow specifying domain transition preference.
      TOMOYO: Fix make namespacecheck warnings.
      TOMOYO: Simplify garbage collector.
      TOMOYO: Remove tomoyo_policy_memory_lock spinlock.
      TOMOYO: Fix domain transition failure warning.
      TOMOYO: Remove redundant tasklist_lock.
      TOMOYO: Fix quota and garbage collector.
      TOMOYO: Fix unused kernel config option.
      TOMOYO: Fix incomplete read after seek.

Zhi Li (1):
      capabilities: do not grant full privs for setuid w/ file caps + no effective caps

rongqing.li@windriver.com (1):
      security: Fix a typo

 Documentation/ABI/testing/evm                      |   23 +
 Documentation/kernel-parameters.txt                |    6 +
 MAINTAINERS                                        |    7 +-
 drivers/char/tpm/tpm.c                             |    3 +
 drivers/target/target_core_fabric_lib.c            |   12 +-
 fs/attr.c                                          |    5 +-
 fs/btrfs/xattr.c                                   |   50 +-
 fs/cifs/xattr.c                                    |   40 +-
 fs/ext2/xattr_security.c                           |   34 +-
 fs/ext3/xattr_security.c                           |   36 +-
 fs/ext4/xattr_security.c                           |   36 +-
 fs/gfs2/inode.c                                    |   38 +-
 fs/jffs2/security.c                                |   35 +-
 fs/jfs/xattr.c                                     |   57 +-
 fs/ocfs2/xattr.c                                   |   38 +-
 fs/reiserfs/xattr_security.c                       |    4 +-
 fs/xattr.c                                         |   63 ++-
 fs/xfs/linux-2.6/xfs_iops.c                        |   39 +-
 include/linux/evm.h                                |  100 +++
 include/linux/ima.h                                |   13 -
 include/linux/integrity.h                          |   39 +
 include/linux/kernel.h                             |    2 +-
 include/linux/security.h                           |   32 +-
 include/linux/xattr.h                              |   19 +-
 kernel/cred.c                                      |   18 +-
 lib/hexdump.c                                      |   15 +-
 mm/shmem.c                                         |    4 +-
 security/Kconfig                                   |    6 +-
 security/Makefile                                  |    4 +-
 security/apparmor/apparmorfs.c                     |    2 +-
 security/apparmor/ipc.c                            |    1 +
 security/apparmor/lib.c                            |    1 +
 security/apparmor/policy_unpack.c                  |   12 +-
 security/apparmor/procattr.c                       |    1 +
 security/commoncap.c                               |   16 +-
 security/integrity/Kconfig                         |    7 +
 security/integrity/Makefile                        |   12 +
 security/integrity/evm/Kconfig                     |   13 +
 security/integrity/evm/Makefile                    |    7 +
 security/integrity/evm/evm.h                       |   38 +
 security/integrity/evm/evm_crypto.c                |  216 ++++++
 security/integrity/evm/evm_main.c                  |  384 ++++++++++
 security/integrity/evm/evm_posix_acl.c             |   26 +
 security/integrity/evm/evm_secfs.c                 |  108 +++
 security/integrity/iint.c                          |  172 +++++
 security/integrity/ima/Kconfig                     |    1 +
 security/integrity/ima/Makefile                    |    2 +-
 security/integrity/ima/ima.h                       |   30 +-
 security/integrity/ima/ima_api.c                   |    7 +-
 security/integrity/ima/ima_fs.c                    |    2 +-
 security/integrity/ima/ima_iint.c                  |  169 -----
 security/integrity/ima/ima_main.c                  |   13 +-
 security/integrity/integrity.h                     |   50 ++
 security/keys/Makefile                             |    2 +-
 security/keys/encrypted-keys/Makefile              |    6 +
 .../keys/{ => encrypted-keys}/ecryptfs_format.c    |    0
 .../keys/{ => encrypted-keys}/ecryptfs_format.h    |    0
 security/keys/{ => encrypted-keys}/encrypted.c     |   49 +-
 security/keys/{ => encrypted-keys}/encrypted.h     |   11 +
 security/keys/encrypted-keys/masterkey_trusted.c   |   45 ++
 security/keys/gc.c                                 |  386 +++++++---
 security/keys/internal.h                           |    4 +
 security/keys/key.c                                |  121 +---
 security/keys/keyring.c                            |    3 +-
 security/keys/process_keys.c                       |   16 +-
 security/keys/trusted.c                            |   19 +-
 security/security.c                                |   76 ++-
 security/selinux/exports.c                         |    1 +
 security/selinux/hooks.c                           |   13 +-
 security/selinux/include/avc_ss.h                  |    6 +
 security/selinux/include/security.h                |    8 +
 security/selinux/netlink.c                         |    2 +
 security/selinux/nlmsgtab.c                        |    1 +
 security/selinux/selinuxfs.c                       |    5 +-
 security/selinux/ss/conditional.c                  |    2 +-
 security/selinux/ss/conditional.h                  |    1 +
 security/selinux/ss/policydb.c                     |    2 -
 security/selinux/ss/services.c                     |    3 -
 security/smack/smack.h                             |   24 +-
 security/smack/smack_access.c                      |  134 ++--
 security/smack/smack_lsm.c                         |  266 +++++---
 security/smack/smackfs.c                           |  277 ++++++--
 security/tomoyo/Kconfig                            |    2 +
 security/tomoyo/Makefile                           |    4 +-
 security/tomoyo/audit.c                            |    7 +-
 security/tomoyo/common.c                           |  228 +++++--
 security/tomoyo/common.h                           |  189 +++++-
 security/tomoyo/condition.c                        |   71 ++-
 security/tomoyo/domain.c                           |  209 +++++-
 security/tomoyo/environ.c                          |  122 +++
 security/tomoyo/file.c                             |   42 +-
 security/tomoyo/gc.c                               |  540 ++++++--------
 security/tomoyo/group.c                            |   61 ++-
 security/tomoyo/memory.c                           |   39 +-
 security/tomoyo/network.c                          |  771 ++++++++++++++++++++
 security/tomoyo/realpath.c                         |   32 +-
 security/tomoyo/securityfs_if.c                    |  123 +++-
 security/tomoyo/tomoyo.c                           |   62 ++
 security/tomoyo/util.c                             |   80 ++-
 99 files changed, 4701 insertions(+), 1432 deletions(-)
 create mode 100644 Documentation/ABI/testing/evm
 create mode 100644 include/linux/evm.h
 create mode 100644 include/linux/integrity.h
 create mode 100644 security/integrity/Kconfig
 create mode 100644 security/integrity/Makefile
 create mode 100644 security/integrity/evm/Kconfig
 create mode 100644 security/integrity/evm/Makefile
 create mode 100644 security/integrity/evm/evm.h
 create mode 100644 security/integrity/evm/evm_crypto.c
 create mode 100644 security/integrity/evm/evm_main.c
 create mode 100644 security/integrity/evm/evm_posix_acl.c
 create mode 100644 security/integrity/evm/evm_secfs.c
 create mode 100644 security/integrity/iint.c
 delete mode 100644 security/integrity/ima/ima_iint.c
 create mode 100644 security/integrity/integrity.h
 create mode 100644 security/keys/encrypted-keys/Makefile
 rename security/keys/{ => encrypted-keys}/ecryptfs_format.c (100%)
 rename security/keys/{ => encrypted-keys}/ecryptfs_format.h (100%)
 rename security/keys/{ => encrypted-keys}/encrypted.c (96%)
 rename security/keys/{ => encrypted-keys}/encrypted.h (81%)
 create mode 100644 security/keys/encrypted-keys/masterkey_trusted.c
 create mode 100644 security/tomoyo/environ.c
 create mode 100644 security/tomoyo/network.c

-- 
James Morris
<jmorris@namei.org>
