Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab1EXGa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 02:30:56 -0400
Received: from sncsmrelay2.nai.com ([67.97.80.206]:44076 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab1EXGay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 02:30:54 -0400
Date: Tue, 24 May 2011 16:30:35 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-ID: <201105240630.p4O6UZ6t015935@goober.internal.moreton.com.au>
CC: <gerg@uclinux.org>, <linux-kernel@vger.kernel.org>,
        <linux-m68k@vger.kernel.org>, <uclinux-dev@uclinux.org>
Subject: [git pull] m68knommu arch updates
To: <torvalds@linux-foundation.org>
X-Mailer: mail (GNU Mailutils 2.1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Can you please pull the m68knommu git tree, for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

A couple of changes to fix breakage from the m68k/m68knommu merge.
But most of this is a start on cleaning up common or nearly common
code that couldn't be trivially combined. Of course this is doing the
easy stuff first. Much more to come.

Thanks
Greg





The following changes since commit ea2b50ef4c9e030749ae473e95258f477c3a68ca:
  Linus Torvalds (1):
        Merge branch 'x86-apic-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

Akinobu Mita (1):
      m68knommu: use asm-generic/bitops/ext2-atomic.h

Geert Uytterhoeven (2):
      m68knommu: Remove obsolete #include <linux/sys.h>
      m68knommu: Use generic show_interrupts()

Greg Ungerer (18):
      m68k: merge mmu and non-mmu versions of muldi3
      m68k: merge mmu and non-mmu versions of lib/Makefile
      m68k: remove duplicate memmove() implementation
      m68k: remove duplicate memset() implementation
      m68k: remove duplicate memcpy() implementation
      m68k: let Makefile sort out compiling mmu and non-mmu lib/checksum.c
      m68knommu: remove unused kernel_set_cachemode()
      m68knommu: remove stubs for __ioremap() and iounmap()
      m68k: mv kmap_mm.c to kmap.c
      m68k: merge the mmu and non-mmu mm/Makefile
      m68knommu: clean up mm/init_no.c
      m68knommu: move EXPORT of dump_fpu to function definition
      m68knommu: move EXPORT of local checksumming functions to definitions
      m68knommu: move EXPORT of kernel_thread to function definition
      m68knommu: remove un-needed exporting of COLDFIRE symbols
      m68k: merge non-mmu and mmu versions of m68k_ksyms.c
      m68k: merge mmu and non-mmu versions of asm-offsets.c
      m68k: merge the mmu and non-mmu versions of sys_m68k.c

Steven King (1):
      coldfire_qspi compile fix

 arch/m68k/Kconfig                   |    1 +
 arch/m68k/include/asm/bitops_no.h   |   18 +-
 arch/m68k/include/asm/io_no.h       |    8 +-
 arch/m68k/kernel/asm-offsets.c      |  106 ++++++-
 arch/m68k/kernel/asm-offsets_mm.c   |  100 ------
 arch/m68k/kernel/asm-offsets_no.c   |   76 -----
 arch/m68k/kernel/entry_no.S         |    1 -
 arch/m68k/kernel/irq.c              |   28 --
 arch/m68k/kernel/m68k_ksyms.c       |   36 ++-
 arch/m68k/kernel/m68k_ksyms_mm.c    |   16 -
 arch/m68k/kernel/m68k_ksyms_no.c    |   78 -----
 arch/m68k/kernel/process_no.c       |    2 +
 arch/m68k/kernel/sys_m68k.c         |  581 ++++++++++++++++++++++++++++++++++-
 arch/m68k/kernel/sys_m68k_mm.c      |  546 --------------------------------
 arch/m68k/kernel/sys_m68k_no.c      |   94 ------
 arch/m68k/kernel/syscalltable.S     |    1 -
 arch/m68k/lib/Makefile              |   13 +-
 arch/m68k/lib/Makefile_mm           |    6 -
 arch/m68k/lib/Makefile_no           |    7 -
 arch/m68k/lib/checksum.c            |    5 -
 arch/m68k/lib/checksum_no.c         |    3 +
 arch/m68k/lib/memcpy.c              |  128 +++++----
 arch/m68k/lib/memmove.c             |    2 -
 arch/m68k/lib/memset.c              |  114 +++++---
 arch/m68k/lib/muldi3.c              |   99 ++++++-
 arch/m68k/lib/muldi3_mm.c           |   63 ----
 arch/m68k/lib/muldi3_no.c           |   86 -----
 arch/m68k/lib/string.c              |  223 --------------
 arch/m68k/mm/Makefile               |   14 +-
 arch/m68k/mm/Makefile_mm            |    8 -
 arch/m68k/mm/Makefile_no            |    5 -
 arch/m68k/mm/init_no.c              |   51 +---
 arch/m68k/mm/kmap.c                 |  368 ++++++++++++++++++++++-
 arch/m68k/mm/kmap_mm.c              |  367 ----------------------
 arch/m68k/mm/kmap_no.c              |   45 ---
 arch/m68k/platform/68328/entry.S    |    7 +-
 arch/m68k/platform/68360/entry.S    |    7 +-
 arch/m68k/platform/coldfire/dma.c   |    3 +
 arch/m68k/platform/coldfire/entry.S |   11 +-
 arch/m68k/platform/coldfire/head.S  |    1 -
 drivers/spi/coldfire_qspi.c         |    1 +
 41 files changed, 1369 insertions(+), 1960 deletions(-)
 delete mode 100644 arch/m68k/kernel/asm-offsets_mm.c
 delete mode 100644 arch/m68k/kernel/asm-offsets_no.c
 delete mode 100644 arch/m68k/kernel/m68k_ksyms_mm.c
 delete mode 100644 arch/m68k/kernel/m68k_ksyms_no.c
 delete mode 100644 arch/m68k/kernel/sys_m68k_mm.c
 delete mode 100644 arch/m68k/kernel/sys_m68k_no.c
 delete mode 100644 arch/m68k/lib/Makefile_mm
 delete mode 100644 arch/m68k/lib/Makefile_no
 delete mode 100644 arch/m68k/lib/checksum.c
 delete mode 100644 arch/m68k/lib/muldi3_mm.c
 delete mode 100644 arch/m68k/lib/muldi3_no.c
 delete mode 100644 arch/m68k/mm/Makefile_mm
 delete mode 100644 arch/m68k/mm/Makefile_no
 delete mode 100644 arch/m68k/mm/kmap_mm.c
 delete mode 100644 arch/m68k/mm/kmap_no.c
