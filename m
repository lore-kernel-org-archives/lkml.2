Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364Ab2CUJkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 05:40:20 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:64014 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab2CUJkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 05:40:17 -0400
Date: Wed, 21 Mar 2012 11:37:25 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-ID: <201203210137.q2L1bPMB005418@goober.corp.nai.org>
CC: <gerg@uclinux.org>, <linux-kernel@vger.kernel.org>,
        <linux-m68k@vger.kernel.org>, <uclinux-dev@uclinux.org>,
        <geert@linux-m68k.org>
Subject: [git pull] m68knommu arch updates for 3.4
To: <torvalds@linux-foundation.org>
X-Mailer: mail (GNU Mailutils 2.1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Can you please pull the m68knommu git tree, for-next branch:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-next

Includes a cleanup of the non-MMU linker script (it now almost exclusively
uses the well defined linker script support macros and definitions).
Some more merging of MMU and non-MMU common files (specifically the arch
process.c, ptrace and time.c). And a big cleanup of the massively duplicated
ColdFire device definition code. Overall we remove about 2000 lines of code,
and end up with a single set of platform device definitions for the serial
ports, ethernet ports and QSPI ports common in most ColdFire SoCs.

I expect you will get a merge conflict on arch/m68k/kernel/process.c,
in cpu_idle(). It should be relatively strait forward to fixup.

Regards
Greg



The following changes since commit 192cfd58774b4d17b2fe8bdc77d89c2ef4e0591d:
  Linus Torvalds (1):
        Linux 3.3-rc6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-next

Greg Ungerer (57):
      m68knommu: hard set the ColdFire MBAR register on startup
      m68knommu: clean up linker script
      m68knommu: remove reduntant definitions of _ramvec
      m68knommu: make persistent clock code consistent with m68k
      m68knommu: modify timer init code to make it consistent with m68k code
      m68knommu: remove unused CONFIG_GENERIC_CMOS_UPDATE option
      m68k: merge mmu and non-mmu versions of time.c
      m68k: remove dead timer code
      m68k: merge the mmu and non-mmu versions of ptrace.c
      m68k: make support for FPU hardware configurable
      m68k: merge the MMU and non-MMU versions of process.c
      m68knommu: make 5206 UART platform addressing consistent
      m68knommu: make 520x UART platform addressing consistent
      m68knommu: make 523x UART platform addressing consistent
      m68knommu: make 5249 UART platform addressing consistent
      m68knommu: make 5272 UART platform addressing consistent
      m68knommu: make 527x UART platform addressing consistent
      m68knommu: make 5307 UART platform addressing consistent
      m68knommu: make 528x UART platform addressing consistent
      m68knommu: make 532x UART platform addressing consistent
      m68knommu: make 5407 UART platform addressing consistent
      m68knommu: make 54xx UART platform addressing consistent
      m68knommu: simplify the 5206 UART setup code
      m68knommu: simplify the 520x UART setup code
      m68knommu: simplify the 5249 UART setup code
      m68knommu: simplify the 5272 UART setup code
      m68knommu: simplify the 527x UART setup code
      m68knommu: simplify the 528x UART setup code
      m68knommu: simplify the 5307 UART setup code
      m68knommu: simplify the 532x UART setup code
      m68knommu: simplify the 5407 UART setup code
      m68knommu: simplify the 54xx UART setup code
      m68knommu: merge common ColdFire UART platform setup code
      m68knommu: merge common ColdFire UART IRQ setup
      m68knommu: make 520x FEC platform addressing consistent
      m68knommu: make 523x FEC platform addressing consistent
      m68knommu: make 5272 FEC platform addressing consistent
      m68knommu: make 527x FEC platform addressing consistent
      m68knommu: make 528x FEC platform addressing consistent
      m68knommu: make 532x FEC platform addressing consistent
      m68knommu: merge common ColdFire FEC platform setup code
      m68knommu: make 520x QSPI platform addressing consistent
      m68knommu: make 523x QSPI platform addressing consistent
      m68knommu: make 5249 QSPI platform addressing consistent
      m68knommu: make 527x QSPI platform addressing consistent
      m68knommu: make 528x QSPI platform addressing consistent
      m68knommu: make 532x QSPI platform addressing consistent
      m68knommu: merge common ColdFire QSPI platform setup code
      m68knommu: clean up init code in ColdFire 523x startup
      m68knommu: clean up init code in ColdFire 528x startup
      m68knommu: clean up init code in ColdFire 532x startup
      m68knommu: move old ColdFire timers init from CPU init to timers code
      m68knommu: factor some common ColdFire cpu reset code
      m68knommu: make 523x CPU reset register addressing consistent
      m68knommu: make 527x CPU reset register addressing consistent
      m68knommu: make 528x CPU reset register addressing consistent
      m68knommu: factor more common ColdFire cpu reset code

 arch/m68k/Kconfig                      |    7 +-
 arch/m68k/include/asm/m5206sim.h       |   10 +-
 arch/m68k/include/asm/m520xsim.h       |   33 +++-
 arch/m68k/include/asm/m523xsim.h       |   42 +++-
 arch/m68k/include/asm/m5249sim.h       |   18 ++-
 arch/m68k/include/asm/m5272sim.h       |   17 +-
 arch/m68k/include/asm/m527xsim.h       |   53 ++++-
 arch/m68k/include/asm/m528xsim.h       |   40 +++-
 arch/m68k/include/asm/m5307sim.h       |   10 +-
 arch/m68k/include/asm/m532xsim.h       |   35 +++-
 arch/m68k/include/asm/m5407sim.h       |    6 +-
 arch/m68k/include/asm/m54xxsim.h       |   16 +-
 arch/m68k/include/asm/machdep.h        |    5 +-
 arch/m68k/include/asm/mcfqspi.h        |   11 -
 arch/m68k/include/asm/mcfuart.h        |    5 +-
 arch/m68k/kernel/process.c             |  379 +++++++++++++++++++++++++++++-
 arch/m68k/kernel/process_mm.c          |  369 -----------------------------
 arch/m68k/kernel/process_no.c          |  406 --------------------------------
 arch/m68k/kernel/ptrace.c              |  306 ++++++++++++++++++++++++-
 arch/m68k/kernel/ptrace_mm.c           |  295 -----------------------
 arch/m68k/kernel/ptrace_no.c           |  255 --------------------
 arch/m68k/kernel/setup_no.c            |    3 +
 arch/m68k/kernel/time.c                |  116 +++++++++-
 arch/m68k/kernel/time_mm.c             |  114 ---------
 arch/m68k/kernel/time_no.c             |   90 -------
 arch/m68k/kernel/vmlinux-nommu.lds     |  200 ++++------------
 arch/m68k/platform/5206/config.c       |   91 +-------
 arch/m68k/platform/520x/config.c       |  256 ++-------------------
 arch/m68k/platform/523x/config.c       |  235 +------------------
 arch/m68k/platform/5249/config.c       |  244 +------------------
 arch/m68k/platform/5272/config.c       |   84 +------
 arch/m68k/platform/527x/config.c       |  296 +-----------------------
 arch/m68k/platform/528x/config.c       |  230 +-----------------
 arch/m68k/platform/5307/config.c       |   91 +-------
 arch/m68k/platform/532x/config.c       |  221 +----------------
 arch/m68k/platform/5407/config.c       |   91 +-------
 arch/m68k/platform/54xx/config.c       |   77 +------
 arch/m68k/platform/68328/config.c      |    5 +-
 arch/m68k/platform/68328/ints.c        |    2 -
 arch/m68k/platform/68328/timers.c      |   18 +-
 arch/m68k/platform/68360/config.c      |    8 +-
 arch/m68k/platform/68360/ints.c        |    2 -
 arch/m68k/platform/68EZ328/config.c    |    5 +-
 arch/m68k/platform/68VZ328/config.c    |    5 +-
 arch/m68k/platform/coldfire/Makefile   |   22 +-
 arch/m68k/platform/coldfire/device.c   |  318 +++++++++++++++++++++++++
 arch/m68k/platform/coldfire/head.S     |    4 +
 arch/m68k/platform/coldfire/pit.c      |    2 +-
 arch/m68k/platform/coldfire/reset.c    |   50 ++++
 arch/m68k/platform/coldfire/sltimers.c |    7 +-
 arch/m68k/platform/coldfire/timers.c   |   27 ++-
 arch/m68k/platform/coldfire/vectors.c  |    2 -
 52 files changed, 1593 insertions(+), 3641 deletions(-)
 delete mode 100644 arch/m68k/kernel/process_mm.c
 delete mode 100644 arch/m68k/kernel/process_no.c
 delete mode 100644 arch/m68k/kernel/ptrace_mm.c
 delete mode 100644 arch/m68k/kernel/ptrace_no.c
 delete mode 100644 arch/m68k/kernel/time_mm.c
 delete mode 100644 arch/m68k/kernel/time_no.c
 create mode 100644 arch/m68k/platform/coldfire/device.c
 create mode 100644 arch/m68k/platform/coldfire/reset.c
