Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab2AICXI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 21:23:08 -0500
Received: from tundra.namei.org ([65.99.196.166]:59909 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995Ab2AICXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 21:23:05 -0500
Date: Mon, 9 Jan 2012 13:22:59 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] Security subsystem updates for 3.3
Message-ID: <alpine.LRH.2.00.1201091252220.18816@tundra.namei.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The most significant change here is the addition of the digital signature 
verification API, for use by IMA, EVM and module loading.  The rest is 
general maintenance.

Please pull.


The following changes since commit 805a6af8dba5dfdd35ec35dc52ec0122400b2610:
  Linus Torvalds (1):
        Linux 3.2

are available in the git repository at:

  git://selinuxproject.org/~jmorris/linux-security for-linus

Andrew Morton (1):
      include/linux/security.h: fix security_inode_init_security() arg

Andy Shevchenko (1):
      selinuxfs: remove custom hex_to_bin()

Dan Carpenter (1):
      mpi/mpi-mpow: NULL dereference on allocation failure

David Howells (1):
      KEYS: Give key types their own lockdep class for key->sem

Dmitry Kasatkin (10):
      crypto: GnuPG based MPI lib - source files (part 1)
      crypto: GnuPG based MPI lib - header files (part 2)
      crypto: GnuPG based MPI lib - make files (part 3)
      crypto: GnuPG based MPI lib - additional sources (part 4)
      crypto: digital signature verification support
      integrity: digital signature verification using multiple keyrings
      evm: digital signature verification support
      digsig: build dependency fix
      evm: key must be set once during initialization
      evm: prevent racing during tfm allocation

Greg Kroah-Hartman (1):
      Security: tomoyo: add .gitignore file

James Morris (4):
      Merge branch 'master'; commit 'v3.2-rc2' into next
      Merge branch 'for-james' of git://github.com/srajiv/tpm into next
      Merge branch 'next-evm-digsig' of git://git.kernel.org/.../kasatkin/linux-digsig into next
      Merge branch 'next' into for-linus

Kees Cook (4):
      Documentation: clarify the purpose of LSMs
      apparmor: add missing rcu_dereference()
      tomoyo: add missing rcu_dereference()
      security: update security_file_mmap() docs

Rajiv Andrade (4):
      TPM: Use vendor specific function for status probe
      TPM: Export wait_for_stat for other vendor specific drivers
      TPM: NSC and TIS drivers X86 dependency fix
      TPM: fix transmit_cmd error logic

Roberto Sassu (2):
      ima: free duplicate measurement memory
      ima: fix invalid memory reference

Rusty Russell (1):
      apparmor: fix module parameter handling

Stefan Berger (5):
      tpm: Have tpm_get_timeouts return an error code
      tpm: Cleanup tpm_continue_selftest
      tpm: Introduce function to poll for result of self test
      tpm_tis: Check return code from getting timeouts/durations
      tpm_tis: add delay after aborting command

Thomas Meyer (1):
      selinux: Casting (void *) value returned by kmalloc is useless

 Documentation/digsig.txt               |   96 ++
 Documentation/security/00-INDEX        |    2 +
 Documentation/security/LSM.txt         |   34 +
 Documentation/security/credentials.txt |    6 +-
 drivers/char/tpm/Kconfig               |    2 +
 drivers/char/tpm/tpm.c                 |  137 +++-
 drivers/char/tpm/tpm.h                 |    9 +-
 drivers/char/tpm/tpm_tis.c             |   84 +--
 include/linux/digsig.h                 |   64 ++
 include/linux/key-type.h               |    1 +
 include/linux/mpi.h                    |  146 ++++
 include/linux/security.h               |    4 +-
 lib/Kconfig                            |   25 +
 lib/Makefile                           |    3 +
 lib/digsig.c                           |  284 ++++++
 lib/mpi/Makefile                       |   32 +
 lib/mpi/generic_mpi-asm-defs.h         |    4 +
 lib/mpi/generic_mpih-add1.c            |   61 ++
 lib/mpi/generic_mpih-lshift.c          |   63 ++
 lib/mpi/generic_mpih-mul1.c            |   57 ++
 lib/mpi/generic_mpih-mul2.c            |   60 ++
 lib/mpi/generic_mpih-mul3.c            |   61 ++
 lib/mpi/generic_mpih-rshift.c          |   63 ++
 lib/mpi/generic_mpih-sub1.c            |   60 ++
 lib/mpi/longlong.h                     | 1478 ++++++++++++++++++++++++++++++++
 lib/mpi/mpi-add.c                      |  234 +++++
 lib/mpi/mpi-bit.c                      |  236 +++++
 lib/mpi/mpi-cmp.c                      |   68 ++
 lib/mpi/mpi-div.c                      |  333 +++++++
 lib/mpi/mpi-gcd.c                      |   59 ++
 lib/mpi/mpi-inline.c                   |   31 +
 lib/mpi/mpi-inline.h                   |  122 +++
 lib/mpi/mpi-internal.h                 |  261 ++++++
 lib/mpi/mpi-inv.c                      |  187 ++++
 lib/mpi/mpi-mpow.c                     |  134 +++
 lib/mpi/mpi-mul.c                      |  194 +++++
 lib/mpi/mpi-pow.c                      |  323 +++++++
 lib/mpi/mpi-scan.c                     |  136 +++
 lib/mpi/mpicoder.c                     |  365 ++++++++
 lib/mpi/mpih-cmp.c                     |   56 ++
 lib/mpi/mpih-div.c                     |  541 ++++++++++++
 lib/mpi/mpih-mul.c                     |  527 ++++++++++++
 lib/mpi/mpiutil.c                      |  208 +++++
 security/apparmor/audit.c              |    2 +-
 security/apparmor/lsm.c                |    6 +-
 security/integrity/Kconfig             |   14 +
 security/integrity/Makefile            |    1 +
 security/integrity/digsig.c            |   48 +
 security/integrity/evm/evm.h           |   12 +
 security/integrity/evm/evm_crypto.c    |   76 ++-
 security/integrity/evm/evm_main.c      |   94 ++-
 security/integrity/ima/ima_api.c       |    4 +-
 security/integrity/ima/ima_queue.c     |   17 +-
 security/integrity/integrity.h         |   21 +
 security/keys/key.c                    |    3 +
 security/selinux/selinuxfs.c           |   14 +-
 security/selinux/ss/conditional.c      |    2 +-
 security/tomoyo/.gitignore             |    2 +
 security/tomoyo/common.h               |    2 +-
 59 files changed, 7026 insertions(+), 143 deletions(-)
 create mode 100644 Documentation/digsig.txt
 create mode 100644 Documentation/security/LSM.txt
 create mode 100644 include/linux/digsig.h
 create mode 100644 include/linux/mpi.h
 create mode 100644 lib/digsig.c
 create mode 100644 lib/mpi/Makefile
 create mode 100644 lib/mpi/generic_mpi-asm-defs.h
 create mode 100644 lib/mpi/generic_mpih-add1.c
 create mode 100644 lib/mpi/generic_mpih-lshift.c
 create mode 100644 lib/mpi/generic_mpih-mul1.c
 create mode 100644 lib/mpi/generic_mpih-mul2.c
 create mode 100644 lib/mpi/generic_mpih-mul3.c
 create mode 100644 lib/mpi/generic_mpih-rshift.c
 create mode 100644 lib/mpi/generic_mpih-sub1.c
 create mode 100644 lib/mpi/longlong.h
 create mode 100644 lib/mpi/mpi-add.c
 create mode 100644 lib/mpi/mpi-bit.c
 create mode 100644 lib/mpi/mpi-cmp.c
 create mode 100644 lib/mpi/mpi-div.c
 create mode 100644 lib/mpi/mpi-gcd.c
 create mode 100644 lib/mpi/mpi-inline.c
 create mode 100644 lib/mpi/mpi-inline.h
 create mode 100644 lib/mpi/mpi-internal.h
 create mode 100644 lib/mpi/mpi-inv.c
 create mode 100644 lib/mpi/mpi-mpow.c
 create mode 100644 lib/mpi/mpi-mul.c
 create mode 100644 lib/mpi/mpi-pow.c
 create mode 100644 lib/mpi/mpi-scan.c
 create mode 100644 lib/mpi/mpicoder.c
 create mode 100644 lib/mpi/mpih-cmp.c
 create mode 100644 lib/mpi/mpih-div.c
 create mode 100644 lib/mpi/mpih-mul.c
 create mode 100644 lib/mpi/mpiutil.c
 create mode 100644 security/integrity/digsig.c
 create mode 100644 security/tomoyo/.gitignore
