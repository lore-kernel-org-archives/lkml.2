Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab1GZC3A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 22:29:00 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:42322 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab1GZC2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 22:28:55 -0400
X-Greylist: delayed 612 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Jul 2011 22:28:54 EDT
Message-ID: <4E2E2417.9060407@snapgear.com>
Date: Tue, 26 Jul 2011 12:19:03 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        uClinux development list <uclinux-dev@uclinux.org>,
        Greg Ungerer <gerg@uclinux.org>
Subject: [git pull] m68knommu arch updates
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Can you please pull the m68knommu git tree, for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

Mostly this is more m68k/m68knommu merge and cleanup work. Still more
of that to come too. A couple of minor fixes as well.

Thanks
Greg



The following changes since commit b6844e8f64920cdee620157252169ba63afb0c89:
   Linus Torvalds (1):
         Merge branch 'for-linus' of master.kernel.org:/home/rmk/linux-2.6-arm

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

Geert Uytterhoeven (4):
       m68knommu: Make empty_zero_page "void *", like on m68k
       m68knommu: Fix printk() format in free_initrd_mem()
       m68knommu: Move forward declaration of do_IRQ() from machdep.h to irq.h
       m68k: Revive reporting of spurious interrupts

Greg Ungerer (9):
       m68k: merge the non-mmu and mmu versions of module.c
       m68k: merge MMU and non-MMU versions of asm/hardirq.h
       m68k: merge MMU and non MMU versions of system.h
       m68k: merge mmu and non-mmu bitops.h
       m68knommu: merge ColdFire 5206 and 5206e platform code
       m68knommu: correctly use trap_init
       m68k: merge and clean up delay.h files
       m68k: use CPU_HAS_NO_BITFIELDS for signal functions
       m68k: fix some atomic operation asm address modes for ColdFire

  arch/m68k/Kconfig                       |    4 +
  arch/m68k/Kconfig.nommu                 |    3 +
  arch/m68k/Makefile_no                   |    2 +-
  arch/m68k/include/asm/atomic.h          |    6 +-
  arch/m68k/include/asm/bitops.h          |  531 ++++++++++++++++++++++++++++++-
  arch/m68k/include/asm/bitops_mm.h       |  501 -----------------------------
  arch/m68k/include/asm/bitops_no.h       |  333 -------------------
  arch/m68k/include/asm/delay.h           |   97 ++++++-
  arch/m68k/include/asm/delay_mm.h        |   57 ----
  arch/m68k/include/asm/delay_no.h        |   76 -----
  arch/m68k/include/asm/entry_no.h        |   12 +-
  arch/m68k/include/asm/hardirq.h         |   35 ++-
  arch/m68k/include/asm/hardirq_mm.h      |   16 -
  arch/m68k/include/asm/hardirq_no.h      |   19 --
  arch/m68k/include/asm/irq.h             |   11 +-
  arch/m68k/include/asm/machdep.h         |    1 -
  arch/m68k/include/asm/module.h          |   31 +-
  arch/m68k/include/asm/signal.h          |   15 +-
  arch/m68k/include/asm/system.h          |  194 +++++++++++-
  arch/m68k/include/asm/system_mm.h       |  193 -----------
  arch/m68k/include/asm/system_no.h       |  153 ---------
  arch/m68k/include/asm/traps.h           |    1 -
  arch/m68k/kernel/irq.c                  |   10 +
  arch/m68k/kernel/module.c               |  130 ++++++++-
  arch/m68k/kernel/module_mm.c            |  128 --------
  arch/m68k/kernel/module_no.c            |   92 ------
  arch/m68k/kernel/traps_no.c             |    4 -
  arch/m68k/lib/Makefile                  |    2 +-
  arch/m68k/lib/delay.c                   |   21 --
  arch/m68k/mm/init_no.c                  |   11 +-
  arch/m68k/platform/5206/config.c        |    6 +
  arch/m68k/platform/5206e/Makefile       |   18 -
  arch/m68k/platform/5206e/config.c       |  127 --------
  arch/m68k/platform/5206e/gpio.c         |   49 ---
  arch/m68k/platform/5272/intc.c          |    2 -
  arch/m68k/platform/68328/entry.S        |   15 +-
  arch/m68k/platform/68328/ints.c         |   10 +-
  arch/m68k/platform/68360/entry.S        |   15 +-
  arch/m68k/platform/68360/ints.c         |   11 +-
  arch/m68k/platform/coldfire/entry.S     |   24 +-
  arch/m68k/platform/coldfire/intc-2.c    |    2 -
  arch/m68k/platform/coldfire/intc-simr.c |    2 -
  arch/m68k/platform/coldfire/intc.c      |    1 -
  arch/m68k/platform/coldfire/vectors.c   |   10 +-
  44 files changed, 1074 insertions(+), 1907 deletions(-)
  delete mode 100644 arch/m68k/include/asm/bitops_mm.h
  delete mode 100644 arch/m68k/include/asm/bitops_no.h
  delete mode 100644 arch/m68k/include/asm/delay_mm.h
  delete mode 100644 arch/m68k/include/asm/delay_no.h
  delete mode 100644 arch/m68k/include/asm/hardirq_mm.h
  delete mode 100644 arch/m68k/include/asm/hardirq_no.h
  delete mode 100644 arch/m68k/include/asm/system_mm.h
  delete mode 100644 arch/m68k/include/asm/system_no.h
  delete mode 100644 arch/m68k/kernel/module_mm.c
  delete mode 100644 arch/m68k/kernel/module_no.c
  delete mode 100644 arch/m68k/lib/delay.c
  delete mode 100644 arch/m68k/platform/5206e/Makefile
  delete mode 100644 arch/m68k/platform/5206e/config.c
  delete mode 100644 arch/m68k/platform/5206e/gpio.c
