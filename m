Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406Ab0JVOlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 10:41:14 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:54807 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063Ab0JVOlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 10:41:10 -0400
Date: Fri, 22 Oct 2010 16:41:03 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Greg Ungerer <gerg@uclinux.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [git pull] m68k updates for 2.6.37
Message-ID: <alpine.DEB.2.00.1010221057200.14783@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus,

The following changes since commit f6f94e2ab1b33f0082ac22d71f66385a60d8157f:
  Linus Torvalds (1):
        Linux 2.6.36

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus
  git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus

Andrew Morton (1):
      m68k: __pa(): cast arg to long

Christian Dietrich (3):
      m68k: Remove dead GG2 config option
      m68k/m68knommu: Remove dead SMP config option
      fbdev: atafb - Remove undead ifdef ATAFB_FALCON

Geert Uytterhoeven (1):
      m68k: Remove big kernel lock in cache flush code

Greg Ungerer (7):
      m68k: move definition of THREAD_SIZE into thread_info_mm.h
      m68k/m68knommu: merge MMU and non-MMU string.h
      m68k/m68knommu: merge machdep.h files into a single file
      m68k/m68knommu: clean up page.h
      m68k/m68knommu: merge MMU and non-MMU atomic.h
      m68k/m68knommu: merge MMU and non-MMU thread_info.h
      m68k/m68knommu: merge the MMU and non-MMU traps.h

Henrik Kretzschmar (1):
      fbdev/m68k: Fix section mismatches in q40fb.c

Jeff Mahoney (1):
      m68k: Use asm-generic/ioctls.h (enables termiox)

Thorsten Glaser (1):
      m68k: Add missing I/O macros {in,out}{w,l}_p() for !CONFIG_ISA

Vasiliy Kulikov (1):
      zorro: Fix device_register() error handling

 arch/m68k/Kconfig                        |    4 +-
 arch/m68k/include/asm/amigahw.h          |    1 -
 arch/m68k/include/asm/atomic.h           |  210 ++++++++++++++++++++++-
 arch/m68k/include/asm/atomic_mm.h        |  200 ----------------------
 arch/m68k/include/asm/atomic_no.h        |  155 -----------------
 arch/m68k/include/asm/entry_mm.h         |    3 +
 arch/m68k/include/asm/io_mm.h            |   43 +----
 arch/m68k/include/asm/ioctls.h           |   80 +---------
 arch/m68k/include/asm/machdep.h          |   49 +++++-
 arch/m68k/include/asm/machdep_mm.h       |   35 ----
 arch/m68k/include/asm/machdep_no.h       |   26 ---
 arch/m68k/include/asm/page.h             |   48 +++++-
 arch/m68k/include/asm/page_mm.h          |   57 +------
 arch/m68k/include/asm/page_no.h          |   51 +-----
 arch/m68k/include/asm/string.h           |  134 ++++++++++++++-
 arch/m68k/include/asm/string_mm.h        |  131 --------------
 arch/m68k/include/asm/string_no.h        |  126 --------------
 arch/m68k/include/asm/system_mm.h        |    2 -
 arch/m68k/include/asm/system_no.h        |    9 -
 arch/m68k/include/asm/thread_info.h      |  109 ++++++++++++-
 arch/m68k/include/asm/thread_info_mm.h   |   71 --------
 arch/m68k/include/asm/thread_info_no.h   |  102 -----------
 arch/m68k/include/asm/traps.h            |  275 +++++++++++++++++++++++++++++-
 arch/m68k/include/asm/traps_mm.h         |  272 -----------------------------
 arch/m68k/include/asm/traps_no.h         |  154 -----------------
 arch/m68k/kernel/setup.c                 |    6 -
 arch/m68k/kernel/sys_m68k.c              |    3 -
 arch/m68k/kernel/time.c                  |    2 -
 arch/m68k/sun3/sun3ints.c                |    2 -
 arch/m68knommu/kernel/time.c             |    3 +-
 arch/m68knommu/platform/coldfire/entry.S |    4 +-
 drivers/video/atafb.c                    |    2 -
 drivers/video/q40fb.c                    |    4 +-
 drivers/zorro/zorro.c                    |    2 +
 34 files changed, 833 insertions(+), 1542 deletions(-)
 delete mode 100644 arch/m68k/include/asm/atomic_mm.h
 delete mode 100644 arch/m68k/include/asm/atomic_no.h
 delete mode 100644 arch/m68k/include/asm/machdep_mm.h
 delete mode 100644 arch/m68k/include/asm/machdep_no.h
 delete mode 100644 arch/m68k/include/asm/string_mm.h
 delete mode 100644 arch/m68k/include/asm/string_no.h
 delete mode 100644 arch/m68k/include/asm/thread_info_mm.h
 delete mode 100644 arch/m68k/include/asm/thread_info_no.h
 delete mode 100644 arch/m68k/include/asm/traps_mm.h
 delete mode 100644 arch/m68k/include/asm/traps_no.h

Thanks for pulling!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
