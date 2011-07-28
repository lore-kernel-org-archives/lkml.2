Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab1G1CN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 22:13:26 -0400
Received: from tundra.namei.org ([65.99.196.166]:48592 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517Ab1G1CNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 22:13:19 -0400
Date: Thu, 28 Jul 2011 12:13:15 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] Security subsystem changes for 3.1
Message-ID: <alpine.LRH.2.00.1107281209010.4722@tundra.namei.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull.

Highlights for this window are a major upgrade to Tomoyo and a whole bunch 
of TPM fixes.  Fairly quiet otherwise.


The following changes since commit 22712200e175e0df5c7f9edfe6c6bf5c94c23b83:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../mason/btrfs-unstable

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6 for-linus

David Howells (1):
      KEYS: Don't return EAGAIN to keyctl_assume_authority()

James Morris (4):
      Merge branch 'linus'; commit 'v3.0-rc2' into next
      Merge branch 'linus' into next
      Merge branch 'for-security' of git://git.kernel.org/.../jj/apparmor-dev into next
      Merge branch 'next' into for-linus

John Johansen (2):
      AppArmor: Fix reference to rcu protected pointer outside of rcu_read_lock
      AppArmor: Fix masking of capabilities in complain mode

Mimi Zohar (1):
      encrypted-keys: move ecryptfs documentation to proper location

Roberto Sassu (7):
      encrypted_keys: avoid dumping the master key if the request fails
      encrypted-keys: fixed valid_master_desc() function description
      encrypted-keys: added additional debug messages
      encrypted-keys: add key format support
      eCryptfs: export global eCryptfs definitions to include/linux/ecryptfs.h
      encrypted-keys: add ecryptfs format support
      eCryptfs: added support for the encrypted key type

Stefan Berger (15):
      tpm: Use durations returned from TPM
      tpm: Adjust the durations if they are too small
      tpm_tis: Introduce durations sysfs entry
      tpm: Use interface timeouts returned from the TPM
      tpm: Adjust interface timeouts if they are too small
      tpm_tis: Add timeouts sysfs entry
      tpm: Fix display of data in pubek sysfs entry
      tpm_tis: Re-enable interrupts upon (S3) resume
      tpm_tis: Delay ACPI S3 suspend while the TPM is busy
      tpm_tis: Fix the probing for interrupts
      tpm_tis: Probing function for Intel iTPM bug
      tpm: Fix a typo
      tpm: Fix compilation warning when CONFIG_PNP is not defined
      tpm: Move tpm_tis_reenable_interrupts out of CONFIG_PNP block
      tpm_nsc: Fix bug when loading multiple TPM drivers

Tetsuo Handa (26):
      TOMOYO: Cleanup part 1.
      TOMOYO: Cleanup part 2.
      TOMOYO: Cleanup part 3.
      TOMOYO: Use struct for passing ACL line.
      TOMOYO: Rename directives.
      TOMOYO: Simplify profile structure.
      TOMOYO: Add auditing interface.
      TOMOYO: Add ACL group support.
      TOMOYO: Add policy namespace support.
      TOMOYO: Change pathname for non-rename()able filesystems.
      TOMOYO: Fix lockdep warning.
      TOMOYO: Cleanup part 4.
      TOMOYO: Rename meminfo to stat and show more statistics.
      TOMOYO: Add built-in policy support.
      TOMOYO: Make several options configurable.
      TOMOYO: Fix build error with CONFIG_SECURITY_TOMOYO_OMIT_USERSPACE_LOADER=y .
      TOMOYO: Update MAINTAINERS file.
      TOMOYO: Cleanup header file.
      TOMOYO: Fix wrong domainname in tomoyo_init_log().
      TOMOYO: Remove /sys/kernel/security/tomoyo/.domain_status interface.
      TOMOYO: Allow using UID/GID etc. of current thread as conditions.
      TOMOYO: Allow using owner/group etc. of file objects as conditions.
      TOMOYO: Allow using executable's realpath and symlink's target as conditions.
      TOMOYO: Allow using argv[]/envp[] of execve() as conditions.
      TOMOYO: Enable conditional ACL.
      TOMOYO: Update kernel-doc.

eparis@redhat (1):
      cgroupfs: use init_cred when populating new cgroupfs mount

 Documentation/security/keys-ecryptfs.txt          |   68 +
 Documentation/security/keys-trusted-encrypted.txt |   52 +-
 MAINTAINERS                                       |    2 +-
 drivers/char/tpm/tpm.c                            |  102 +-
 drivers/char/tpm/tpm.h                            |    7 +
 drivers/char/tpm/tpm_nsc.c                        |   14 +-
 drivers/char/tpm/tpm_tis.c                        |  182 ++-
 fs/ecryptfs/ecryptfs_kernel.h                     |  150 +--
 fs/ecryptfs/keystore.c                            |   13 +-
 include/keys/encrypted-type.h                     |   13 +-
 include/linux/ecryptfs.h                          |  113 ++
 kernel/cgroup.c                                   |    5 +
 security/apparmor/domain.c                        |    2 +-
 security/apparmor/lsm.c                           |    2 +-
 security/keys/Makefile                            |    2 +-
 security/keys/ecryptfs_format.c                   |   81 +
 security/keys/ecryptfs_format.h                   |   30 +
 security/keys/encrypted.c                         |  251 +++-
 security/keys/request_key_auth.c                  |    2 +
 security/tomoyo/Kconfig                           |   61 +
 security/tomoyo/Makefile                          |   49 +-
 security/tomoyo/audit.c                           |  456 +++++
 security/tomoyo/common.c                          | 1959 +++++++++++++--------
 security/tomoyo/common.h                          | 1197 +++++++------
 security/tomoyo/condition.c                       | 1035 +++++++++++
 security/tomoyo/domain.c                          |  630 +++++---
 security/tomoyo/file.c                            |  954 ++++------
 security/tomoyo/gc.c                              |  551 +++++-
 security/tomoyo/group.c                           |   61 +-
 security/tomoyo/load_policy.c                     |   80 +-
 security/tomoyo/memory.c                          |  173 +--
 security/tomoyo/mount.c                           |  176 +--
 security/tomoyo/realpath.c                        |  226 ++-
 security/tomoyo/securityfs_if.c                   |   22 +-
 security/tomoyo/tomoyo.c                          |  238 +++-
 security/tomoyo/util.c                            |  363 +++--
 36 files changed, 6483 insertions(+), 2839 deletions(-)
 create mode 100644 Documentation/security/keys-ecryptfs.txt
 create mode 100644 include/linux/ecryptfs.h
 create mode 100644 security/keys/ecryptfs_format.c
 create mode 100644 security/keys/ecryptfs_format.h
 create mode 100644 security/tomoyo/audit.c
 create mode 100644 security/tomoyo/condition.c
