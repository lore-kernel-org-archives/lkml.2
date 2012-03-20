Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759665Ab2CTLhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 07:37:22 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:33428 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab2CTLhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 07:37:19 -0400
Date: Tue, 20 Mar 2012 12:37:12 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 3.4 merge window
Message-ID: <20120320123712.3fa8527e@de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12032011-0342-0000-0000-00000135BDCA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the s390 changes for the 3.4 merge window. The biggest patch
is the rework of the smp code, something I wanted to do for some time.
There are some patches for our various dump methods and one new thing:
z/VM LGR detection. LGR stands for linux-guest-relocation and is the
guest migration feature of z/VM. For debugging purposes we keep a log
of the systems where a specific guest has lived.

Heiko Carstens (3):
      [S390] irq: set __ARCH_IRQ_EXIT_IRQS_DISABLED
      [S390] irq: external interrupt code passing
      [S390] stack dump: fix indentation in output

Holger Dengler (1):
      [S390] Remove monolithic build option for zcrypt driver.

Martin Schwidefsky (3):
      [S390] rename lowcore field
      [S390] rework smp code
      [S390] rework idle code

Matt Fleming (1):
      [S390] Use block_sigmask()

Michael Holzheu (7):
      [S390] Fix gcc 4.6.0 compile warning
      [S390] Use copy_to_absolute_zero() instead of "stura/sturg"
      [S390] zfcpdump: Implement async sdias event processing
      [S390] kernel: Add z/VM LGR detection
      [S390] kernel: Add OS info memory interface
      [S390] Ensure that vmcore_info pointer is never accessed directly
      [S390] kernel: Pass correct stack for smp_call_ipl_cpu()

Stefan Haberland (1):
      [S390] dasd: prevent validate server for offline devices

 arch/s390/include/asm/cputime.h     |    9 +-
 arch/s390/include/asm/debug.h       |    1 +
 arch/s390/include/asm/hardirq.h     |    1 +
 arch/s390/include/asm/ipl.h         |    1 +
 arch/s390/include/asm/irq.h         |    7 +-
 arch/s390/include/asm/lowcore.h     |  119 ++--
 arch/s390/include/asm/os_info.h     |   50 ++
 arch/s390/include/asm/sigp.h        |  132 ----
 arch/s390/include/asm/smp.h         |   63 +--
 arch/s390/include/asm/system.h      |   34 +
 arch/s390/include/asm/timer.h       |    4 +-
 arch/s390/include/asm/vdso.h        |    4 +-
 arch/s390/kernel/Makefile           |    4 +-
 arch/s390/kernel/asm-offsets.c      |   27 +-
 arch/s390/kernel/compat_signal.c    |    6 +-
 arch/s390/kernel/crash_dump.c       |   37 +-
 arch/s390/kernel/debug.c            |   40 +-
 arch/s390/kernel/early.c            |   22 +-
 arch/s390/kernel/entry.S            |  159 +++---
 arch/s390/kernel/entry.h            |   17 +-
 arch/s390/kernel/entry64.S          |  139 +++--
 arch/s390/kernel/ipl.c              |   99 ++--
 arch/s390/kernel/irq.c              |   14 +-
 arch/s390/kernel/lgr.c              |  200 ++++++
 arch/s390/kernel/machine_kexec.c    |   52 +--
 arch/s390/kernel/nmi.c              |    2 -
 arch/s390/kernel/os_info.c          |  169 +++++
 arch/s390/kernel/process.c          |    7 +-
 arch/s390/kernel/setup.c            |   61 +-
 arch/s390/kernel/signal.c           |    6 +-
 arch/s390/kernel/smp.c              | 1147 ++++++++++++++++++-----------------
 arch/s390/kernel/switch_cpu.S       |   58 --
 arch/s390/kernel/switch_cpu64.S     |   51 --
 arch/s390/kernel/swsusp_asm64.S     |   19 +-
 arch/s390/kernel/time.c             |    4 +-
 arch/s390/kernel/topology.c         |    8 +-
 arch/s390/kernel/traps.c            |    6 +-
 arch/s390/kernel/vdso.c             |   28 +-
 arch/s390/kernel/vtime.c            |  168 ++----
 arch/s390/kvm/interrupt.c           |    6 +-
 arch/s390/lib/delay.c               |   31 +-
 arch/s390/lib/spinlock.c            |   30 +-
 arch/s390/mm/fault.c                |    4 +-
 arch/s390/oprofile/hwsampler.c      |    6 +-
 drivers/crypto/Kconfig              |    9 -
 drivers/s390/block/dasd.c           |    4 +
 drivers/s390/block/dasd_diag.c      |    8 +-
 drivers/s390/block/dasd_eckd.c      |    8 +
 drivers/s390/char/sclp.c            |    4 +-
 drivers/s390/char/sclp_quiesce.c    |    1 -
 drivers/s390/char/sclp_sdias.c      |  101 +++-
 drivers/s390/char/zcore.c           |    1 -
 drivers/s390/cio/cio.c              |    2 -
 drivers/s390/cio/qdio_main.c        |    6 +
 drivers/s390/crypto/Makefile        |   10 -
 drivers/s390/crypto/ap_bus.c        |    2 -
 drivers/s390/crypto/zcrypt_api.c    |    2 -
 drivers/s390/crypto/zcrypt_cex2a.c  |    4 -
 drivers/s390/crypto/zcrypt_mono.c   |  100 ---
 drivers/s390/crypto/zcrypt_pcica.c  |    4 -
 drivers/s390/crypto/zcrypt_pcicc.c  |    4 -
 drivers/s390/crypto/zcrypt_pcixcc.c |    4 -
 drivers/s390/kvm/kvm_virtio.c       |    6 +-
 net/iucv/iucv.c                     |    2 +-
 64 files changed, 1701 insertions(+), 1633 deletions(-)
 create mode 100644 arch/s390/include/asm/os_info.h
 delete mode 100644 arch/s390/include/asm/sigp.h
 create mode 100644 arch/s390/kernel/lgr.c
 create mode 100644 arch/s390/kernel/os_info.c
 delete mode 100644 arch/s390/kernel/switch_cpu.S
 delete mode 100644 arch/s390/kernel/switch_cpu64.S
 delete mode 100644 drivers/s390/crypto/zcrypt_mono.c

