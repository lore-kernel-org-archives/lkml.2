Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab2JBLer (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 07:34:47 -0400
Received: from tundra.namei.org ([65.99.196.166]:41817 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445Ab2JBLeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 07:34:46 -0400
Date: Tue, 2 Oct 2012 21:35:07 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] Security subsystem updates for 3.7
Message-ID: <alpine.LRH.2.02.1210022124060.15182@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Highlights:

- Integrity: add local fs integrity verification to detect offline attacks
- Integrity: add digital signature verification
- Simple stacking of Yama with other LSMs (per LSS discussions)
- IBM vTPM support on ppc64
- Add new driver for Infineon I2C TIS TPM
- Smack: add rule revocation for subject labels


Please pull.



The following changes since commit a0d271cbfed1dd50278c6b06bead3d00ba0a88f9:
  Linus Torvalds (1):
        Linux 3.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next

Ashley Lai (3):
      drivers/char/tpm: Add new device driver to support IBM vTPM
      PPC64: Add support for instantiating SML from Open Firmware
      drivers/char/tpm: Add securityfs support for event log

Casey Schaufler (2):
      Smack: remove task_wait() hook.
      Smack: setprocattr memory leak fix

Daniel Wagner (1):
      Documentation: Update git repository URL for Smack userland tools

Dmitry Kasatkin (6):
      ima: allocating iint improvements
      ima: replace iint spinblock with rwlock/read_lock
      ima: digital signature verification support
      ima: rename ima_must_appraise_or_measure
      ima: generic IMA action flag handling
      ima: change flags container data type

Heiko Carstens (2):
      samples/seccomp: fix endianness bug in LO_ARG define
      samples/seccomp: fix 31 bit build on s390

James Morris (4):
      Merge tag 'v3.6-rc2' into next
      Merge branch 'next-ima-appraisal' of git://git.kernel.org/.../zohar/linux-integrity into next
      Merge branch 'for-1209' of git://gitorious.org/smack-next/kernel into next
      Merge tag 'v3.6-rc7' into next

Jesper Juhl (1):
      tpm: Do not dereference NULL pointer if acpi_os_map_memory() fails.

Kees Cook (2):
      security: allow Yama to be unconditionally stacked
      Yama: handle 32-bit userspace prctl

Kent Yoder (7):
      tpm: modularize event log collection
      tpm: Move tpm_get_random api into the TPM device driver
      hw_random: add support for the TPM chip as a hardware RNG source
      tpm: fix double write race and tpm_release free issue
      tpm: compile out unused code in the PNP and PM cases
      ima: enable the IBM vTPM as the default TPM in the PPC64 case
      tpm: fix tpm_acpi sparse warning on different address spaces

Mimi Zohar (7):
      vfs: extend vfs_removexattr locking
      vfs: move ima_file_free before releasing the file
      ima: integrity appraisal extension
      ima: add appraise action keywords and default rules
      ima: add inode_post_setattr call
      ima: add ima_inode_setxattr/removexattr function and calls
      ima: add support for different security.ima data types

Peter Huewe (1):
      char/tpm: Add new driver for Infineon I2C TIS TPM

Peter Moody (2):
      audit: export audit_log_task_info
      ima: audit log hashes

Rafal Krypa (1):
      Smack: implement revoking all rules for a subject label

Tetsuo Handa (1):
      ptrace: mark __ptrace_may_access() static

Xiaoyan Zhang (3):
      Documentation: sysfs for Physical Presence Interface
      driver: add PPI support in tpm driver
      driver/char/tpm: declare internal symbols as static

 Documentation/ABI/testing/ima_policy            |   25 +-
 Documentation/ABI/testing/sysfs-driver-ppi      |   70 +++
 Documentation/kernel-parameters.txt             |    8 +
 Documentation/security/Smack.txt                |   10 +-
 arch/powerpc/kernel/prom_init.c                 |   62 ++
 drivers/char/hw_random/Kconfig                  |   13 +
 drivers/char/hw_random/Makefile                 |    1 +
 drivers/char/hw_random/tpm-rng.c                |   50 ++
 drivers/char/tpm/Kconfig                        |   19 +
 drivers/char/tpm/Makefile                       |    8 +
 drivers/char/tpm/tpm.c                          |   74 ++-
 drivers/char/tpm/tpm.h                          |   35 +-
 drivers/char/tpm/tpm_acpi.c                     |  109 ++++
 drivers/char/tpm/{tpm_bios.c => tpm_eventlog.c} |  147 +----
 drivers/char/tpm/tpm_eventlog.h                 |   86 +++
 drivers/char/tpm/tpm_i2c_infineon.c             |  695 +++++++++++++++++++++
 drivers/char/tpm/tpm_ibmvtpm.c                  |  749 +++++++++++++++++++++++
 drivers/char/tpm/tpm_ibmvtpm.h                  |   77 +++
 drivers/char/tpm/tpm_of.c                       |   73 +++
 drivers/char/tpm/tpm_ppi.c                      |  461 ++++++++++++++
 drivers/char/tpm/tpm_tis.c                      |    3 +-
 fs/attr.c                                       |    2 +
 fs/file_table.c                                 |    2 +-
 fs/xattr.c                                      |    6 +-
 include/linux/audit.h                           |    2 +
 include/linux/ima.h                             |   27 +
 include/linux/integrity.h                       |    7 +-
 include/linux/ptrace.h                          |    2 -
 include/linux/security.h                        |   31 +
 include/linux/tpm.h                             |    4 +
 include/linux/xattr.h                           |    3 +
 kernel/auditsc.c                                |   74 +--
 kernel/ptrace.c                                 |    3 +-
 samples/seccomp/Makefile                        |   24 +-
 samples/seccomp/bpf-helper.h                    |   15 +-
 security/integrity/evm/evm_main.c               |    3 +
 security/integrity/iint.c                       |   64 +-
 security/integrity/ima/Kconfig                  |   16 +
 security/integrity/ima/Makefile                 |    1 +
 security/integrity/ima/ima.h                    |   39 +-
 security/integrity/ima/ima_api.c                |   86 ++-
 security/integrity/ima/ima_appraise.c           |  263 ++++++++
 security/integrity/ima/ima_crypto.c             |    8 +-
 security/integrity/ima/ima_main.c               |   93 ++-
 security/integrity/ima/ima_policy.c             |  195 ++++--
 security/integrity/integrity.h                  |   22 +-
 security/keys/trusted.c                         |   54 +-
 security/security.c                             |   27 +
 security/smack/smack_lsm.c                      |   51 +-
 security/smack/smackfs.c                        |   75 +++
 security/yama/Kconfig                           |    8 +
 security/yama/yama_lsm.c                        |   16 +-
 52 files changed, 3540 insertions(+), 458 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-ppi
 create mode 100644 drivers/char/hw_random/tpm-rng.c
 create mode 100644 drivers/char/tpm/tpm_acpi.c
 rename drivers/char/tpm/{tpm_bios.c => tpm_eventlog.c} (75%)
 create mode 100644 drivers/char/tpm/tpm_eventlog.h
 create mode 100644 drivers/char/tpm/tpm_i2c_infineon.c
 create mode 100644 drivers/char/tpm/tpm_ibmvtpm.c
 create mode 100644 drivers/char/tpm/tpm_ibmvtpm.h
 create mode 100644 drivers/char/tpm/tpm_of.c
 create mode 100644 drivers/char/tpm/tpm_ppi.c
 create mode 100644 security/integrity/ima/ima_appraise.c
