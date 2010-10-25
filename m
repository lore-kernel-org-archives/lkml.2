Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936Ab0JYAbA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 20:31:00 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:31881 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab0JYAa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 20:30:57 -0400
Date: Mon, 25 Oct 2010 10:29:24 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-ID: <201010250029.o9P0TO2v003092@goober.internal.moreton.com.au>
CC: <gerg@uclinux.org>, <linux-kernel@vger.kernel.org>,
        <linux-m68k@vger.kernel.org>
Subject: [git pull] m68knommu arch updates
To: <torvalds@linux-foundation.org>
X-Mailer: mail (GNU Mailutils 2.1)
X-OriginalArrivalTime: 25 Oct 2010 00:30:42.0941 (UTC) FILETIME=[DB983AD0:01CB73DB]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Can you please pull the m68knommu git tree, for-linus branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

Changes include support for the ColdFire 548x family, removal of
__do_IRQ use, strace cleanups, some minor bug fixes, and quite a
few cleanup patches (remove un-used symbols, whitespace formating,
comments, etc).

Thanks
Greg



The following changes since commit f6f94e2ab1b33f0082ac22d71f66385a60d8157f:
  Linus Torvalds (1):
        Linux 2.6.36

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

Christian Dietrich (5):
      arch/m68knommu: Removing dead M68000 config option
      arch/m68knommu: Removing dead RELOCATE config option
      arch/m68knommu: Removing dead M68KFPU_EMU config option
      arch/m68knommu: Removing dead RAM_{16,32}_MB config option
      arch/m68knommu: Removing dead 68328_SERIAL_UART2 config option

Greg Ungerer (5):
      m68knommu: stop using __do_IRQ
      m68knommu: mask of vector bits in exception word properly
      m68knommu: support the external GPIO based interrupts of the 5272
      m68knommu: some boards use fixed phy for FEC ethernet
      m68knommu: convert to using tracehook_report_syscall_*

Philippe De Muyter (10):
      m68knommu: fix default starting date
      m68knommu: fix strace support for 68328/68360
      m68knommu: Document supported chips in intc-2.c and intc-simr.c.
      m68knommu: whitespace cleanup in 68328/entry.S
      m68k{nommu}: Remove unused DEFINE's from asm-offsets.c
      m68knommu: add support for Coldfire 547x/548x interrupt controller
      m68knommu: rename PT_OFF_VECTOR to PT_OFF_FORMATVEC.
      m68knommu: .gitignore vmlinux.lds
      m68knommu: add basic mmu-less m548x support
      m68knommu: Fix MCFUART_TXFIFOSIZE for m548x.

matt mooney (1):
      m68knommu: change to new flag variables

 arch/m68k/include/asm/cacheflush_no.h        |    2 +-
 arch/m68k/include/asm/coldfire.h             |    4 +-
 arch/m68k/include/asm/gpio.h                 |    7 +-
 arch/m68k/include/asm/m548xgpt.h             |   88 ++++++++++++++++
 arch/m68k/include/asm/m548xsim.h             |   55 ++++++++++
 arch/m68k/include/asm/mcfcache.h             |    2 +-
 arch/m68k/include/asm/mcfsim.h               |    2 +
 arch/m68k/include/asm/mcfslt.h               |   44 ++++++++
 arch/m68k/include/asm/mcfuart.h              |    9 ++-
 arch/m68k/kernel/asm-offsets.c               |   12 --
 arch/m68knommu/Kconfig                       |   11 ++-
 arch/m68knommu/Makefile                      |    3 +
 arch/m68knommu/kernel/.gitignore             |    1 +
 arch/m68knommu/kernel/asm-offsets.c          |   11 +--
 arch/m68knommu/kernel/ptrace.c               |   47 +++------
 arch/m68knommu/kernel/setup.c                |    3 -
 arch/m68knommu/kernel/time.c                 |   13 ++-
 arch/m68knommu/kernel/traps.c                |   26 ++---
 arch/m68knommu/platform/5206/Makefile        |    4 +-
 arch/m68knommu/platform/5206e/Makefile       |    4 +-
 arch/m68knommu/platform/520x/Makefile        |    4 +-
 arch/m68knommu/platform/523x/Makefile        |    4 +-
 arch/m68knommu/platform/5249/Makefile        |    4 +-
 arch/m68knommu/platform/5272/Makefile        |    4 +-
 arch/m68knommu/platform/5272/config.c        |   16 +++
 arch/m68knommu/platform/5272/intc.c          |   60 +++++++++--
 arch/m68knommu/platform/527x/Makefile        |    4 +-
 arch/m68knommu/platform/528x/Makefile        |    4 +-
 arch/m68knommu/platform/5307/Makefile        |    4 +-
 arch/m68knommu/platform/532x/Makefile        |    4 +-
 arch/m68knommu/platform/5407/Makefile        |    4 +-
 arch/m68knommu/platform/548x/Makefile        |   18 +++
 arch/m68knommu/platform/548x/config.c        |  115 ++++++++++++++++++++
 arch/m68knommu/platform/68328/entry.S        |   36 +++---
 arch/m68knommu/platform/68328/head-de2.S     |    6 -
 arch/m68knommu/platform/68328/head-ram.S     |   27 -----
 arch/m68knommu/platform/68328/ints.c         |    6 +-
 arch/m68knommu/platform/68360/entry.S        |   13 ++-
 arch/m68knommu/platform/68360/ints.c         |    6 +-
 arch/m68knommu/platform/68VZ328/config.c     |    5 -
 arch/m68knommu/platform/coldfire/Makefile    |    5 +-
 arch/m68knommu/platform/coldfire/entry.S     |    4 +-
 arch/m68knommu/platform/coldfire/intc-2.c    |   53 ++++++++--
 arch/m68knommu/platform/coldfire/intc-simr.c |   10 +-
 arch/m68knommu/platform/coldfire/intc.c      |    8 +-
 arch/m68knommu/platform/coldfire/sltimers.c  |  145 ++++++++++++++++++++++++++
 drivers/serial/68328serial.h                 |    5 -
 47 files changed, 707 insertions(+), 215 deletions(-)
 create mode 100644 arch/m68k/include/asm/m548xgpt.h
 create mode 100644 arch/m68k/include/asm/m548xsim.h
 create mode 100644 arch/m68k/include/asm/mcfslt.h
 create mode 100644 arch/m68knommu/kernel/.gitignore
 create mode 100644 arch/m68knommu/platform/548x/Makefile
 create mode 100644 arch/m68knommu/platform/548x/config.c
 create mode 100644 arch/m68knommu/platform/coldfire/sltimers.c
