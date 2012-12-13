Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab2LMToS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 14:44:18 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:42692 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097Ab2LMToR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 14:44:17 -0500
Date: Thu, 13 Dec 2012 20:44:14 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Greg Ungerer <gerg@uclinux.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [git pull] m68k updates for 3.8
Message-ID: <alpine.DEB.2.00.1212132040040.14664@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus,

The following changes since commit 29594404d7fe73cd80eaa4ee8c43dcc53970c60e:
  Linus Torvalds (1):
        Linux 3.7

are available in the git repository at:

  ra.kernel.org:/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus
  git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus

Greg Ungerer (13):
      m68k: switch to using the asm-generic hw_irq.h
      m68k: switch to using the asm-generic spinlock.h
      m68k: switch to using the asm-generic shmparam.h
      m68k: switch to using the asm-generic auxvec.h
      m68k: switch to using the asm-generic msgbuf.h
      m68k: switch to using the asm-generic sembuf.h
      m68k: switch to using the asm-generic shmbuf.h
      m68k: switch to using the asm-generic socket.h
      m68k: switch to using the asm-generic sockios.h
      m68k: switch to using the asm-generic termbits.h
      m68k: switch to using the asm-generic termios.h
      m68k: merge MMU and non-MMU versions of mm/init.c
      m68k: move to a single instance of free_initmem()

Kees Cook (1):
      arch/m68k: remove CONFIG_EXPERIMENTAL

Thomas Bogendoerfer (2):
      m68k/sun3: Get interrupts working again
      m68k/sun3: Fix instruction faults

Summarized:
  - Two fixes for Sun-3
  - Several clean ups

There will be a trivial merge conflict in
arch/m68k/include/uapi/asm/socket.h, as we switched to the generic
version, while you already pulled the net tree that added SO_GET_FILTER
everywhere. Just remove the offending file to fix it.

Thanks for pulling!

 arch/m68k/Kconfig.bus                 |    4 +-
 arch/m68k/Kconfig.cpu                 |    3 +-
 arch/m68k/Kconfig.debug               |    2 +-
 arch/m68k/Kconfig.devices             |    6 +-
 arch/m68k/include/asm/Kbuild          |    4 +
 arch/m68k/include/asm/hw_irq.h        |    6 -
 arch/m68k/include/asm/shmparam.h      |    6 -
 arch/m68k/include/asm/spinlock.h      |    6 -
 arch/m68k/include/asm/termios.h       |   50 --------
 arch/m68k/include/uapi/asm/Kbuild     |   17 ++--
 arch/m68k/include/uapi/asm/auxvec.h   |    4 -
 arch/m68k/include/uapi/asm/msgbuf.h   |   31 -----
 arch/m68k/include/uapi/asm/sembuf.h   |   25 ----
 arch/m68k/include/uapi/asm/shmbuf.h   |   42 ------
 arch/m68k/include/uapi/asm/socket.h   |   72 -----------
 arch/m68k/include/uapi/asm/sockios.h  |   13 --
 arch/m68k/include/uapi/asm/termbits.h |  201 -----------------------------
 arch/m68k/include/uapi/asm/termios.h  |   44 -------
 arch/m68k/kernel/traps.c              |    2 +-
 arch/m68k/mm/init.c                   |  224 ++++++++++++++++++++++++++++++++-
 arch/m68k/mm/init_mm.c                |  176 --------------------------
 arch/m68k/mm/init_no.c                |  145 ---------------------
 arch/m68k/mm/mcfmmu.c                 |    4 -
 arch/m68k/mm/motorola.c               |   14 --
 arch/m68k/mm/sun3mmu.c                |    4 -
 arch/m68k/sun3/sun3ints.c             |   29 +----
 26 files changed, 247 insertions(+), 887 deletions(-)
 delete mode 100644 arch/m68k/include/asm/hw_irq.h
 delete mode 100644 arch/m68k/include/asm/shmparam.h
 delete mode 100644 arch/m68k/include/asm/spinlock.h
 delete mode 100644 arch/m68k/include/asm/termios.h
 delete mode 100644 arch/m68k/include/uapi/asm/auxvec.h
 delete mode 100644 arch/m68k/include/uapi/asm/msgbuf.h
 delete mode 100644 arch/m68k/include/uapi/asm/sembuf.h
 delete mode 100644 arch/m68k/include/uapi/asm/shmbuf.h
 delete mode 100644 arch/m68k/include/uapi/asm/socket.h
 delete mode 100644 arch/m68k/include/uapi/asm/sockios.h
 delete mode 100644 arch/m68k/include/uapi/asm/termbits.h
 delete mode 100644 arch/m68k/include/uapi/asm/termios.h
 delete mode 100644 arch/m68k/mm/init_mm.c
 delete mode 100644 arch/m68k/mm/init_no.c

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
