Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab2GWCjD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 22:39:03 -0400
Received: from tundra.namei.org ([65.99.196.166]:42835 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086Ab2GWCjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 22:39:00 -0400
Date: Mon, 23 Jul 2012 12:38:58 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [GIT] Security subsystem update for 3.6
Message-ID: <alpine.LRH.2.02.1207231233421.13554@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing groundbreaking for this kernel, just cleanups and fixes, and a 
couple of Smack enhancements.

Please pull.

The following changes since commit 28a33cbc24e4256c143dce96c7d93bf423229f92:
  Linus Torvalds (1):
        Linux 3.5

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next

Andi Shyti (1):
      tpm: check the chip reference before using it

Casey Schaufler (4):
      Smack: fix smack_new_inode bogosities
      Smack: onlycap limits on CAP_MAC_ADMIN
      Smack: user access check bounds
      Smack: Maintainer Record

Chad Williamson (1):
      samples: seccomp: add .gitignore for untracked executables

David Howells (1):
      KEYS: Fix some sparse warnings

Dmitry Kasatkin (7):
      Revert "crypto: GnuPG based MPI lib - additional sources (part 4)"
      Remove unused code from MPI library
      ima: free securityfs violations file
      ima: remove unused cleanup functions
      ima: add policy for pseudo fs
      ima: ima_initialized is set only if successful
      ima: audit is compiled only when enabled

James Morris (2):
      Merge branches 'next-queue' and 'next' into next
      Merge commit 'v3.5-rc2' into next

Mimi Zohar (1):
      ima: use full pathnames in measurement list

Paul Mundt (1):
      security: Fix nommu build.

Rafal Krypa (1):
      Smack: don't show empty rules when /smack/load or /smack/load2 is read

Rajiv Andrade (2):
      MAINTAINERS: TPM maintainers' contacts update
      TPM: chip disabled state erronously being reported as error

Wanlong Gao (1):
      TPM: fix memleak when register hardware fails

 MAINTAINERS                         |   16 +-
 drivers/char/tpm/tpm.c              |   27 ++-
 drivers/char/tpm/tpm_infineon.c     |    6 +-
 lib/Kconfig                         |    8 -
 lib/mpi/Makefile                    |   11 --
 lib/mpi/generic_mpi-asm-defs.h      |    4 -
 lib/mpi/mpi-add.c                   |  234 ------------------------
 lib/mpi/mpi-bit.c                   |  162 -----------------
 lib/mpi/mpi-cmp.c                   |   68 -------
 lib/mpi/mpi-div.c                   |  338 -----------------------------------
 lib/mpi/mpi-gcd.c                   |   59 ------
 lib/mpi/mpi-inline.c                |   31 ----
 lib/mpi/mpi-inv.c                   |  187 -------------------
 lib/mpi/mpi-mpow.c                  |  134 --------------
 lib/mpi/mpi-mul.c                   |  194 --------------------
 lib/mpi/mpi-scan.c                  |  136 --------------
 lib/mpi/mpicoder.c                  |   75 --------
 lib/mpi/mpih-div.c                  |  309 --------------------------------
 lib/mpi/mpih-mul.c                  |   30 ----
 lib/mpi/mpiutil.c                   |   88 ---------
 samples/seccomp/.gitignore          |    3 +
 security/integrity/ima/Kconfig      |    3 +-
 security/integrity/ima/Makefile     |    3 +-
 security/integrity/ima/ima.h        |    9 +
 security/integrity/ima/ima_api.c    |    4 +-
 security/integrity/ima/ima_audit.c  |    3 -
 security/integrity/ima/ima_fs.c     |   11 +-
 security/integrity/ima/ima_init.c   |    5 -
 security/integrity/ima/ima_main.c   |   50 ++++--
 security/integrity/ima/ima_policy.c |    2 +
 security/keys/compat.c              |    4 +-
 security/keys/internal.h            |    2 +-
 security/keys/keyctl.c              |    2 +-
 security/keys/keyring.c             |    2 +
 security/security.c                 |    1 +
 security/smack/smack.h              |   14 +-
 security/smack/smack_access.c       |    9 +-
 security/smack/smack_lsm.c          |   25 ++-
 security/smack/smackfs.c            |   53 +++---
 39 files changed, 154 insertions(+), 2168 deletions(-)
 delete mode 100644 lib/mpi/generic_mpi-asm-defs.h
 delete mode 100644 lib/mpi/mpi-add.c
 delete mode 100644 lib/mpi/mpi-cmp.c
 delete mode 100644 lib/mpi/mpi-div.c
 delete mode 100644 lib/mpi/mpi-gcd.c
 delete mode 100644 lib/mpi/mpi-inline.c
 delete mode 100644 lib/mpi/mpi-inv.c
 delete mode 100644 lib/mpi/mpi-mpow.c
 delete mode 100644 lib/mpi/mpi-mul.c
 delete mode 100644 lib/mpi/mpi-scan.c
 create mode 100644 samples/seccomp/.gitignore
