Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641Ab2EVBg6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 21:36:58 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:38655 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab2EVBgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 21:36:55 -0400
Date: Tue, 22 May 2012 11:36:25 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-ID: <201205220136.q4M1aPb2022782@goober.corp.nai.org>
CC: <gerg@uclinux.org>, <linux-kernel@vger.kernel.org>,
        <linux-m68k@vger.kernel.org>, <uclinux-dev@uclinux.org>,
        <geert@linux-m68k.org>
Subject: [git pull]  m68knommu arch updates for 3.5
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

More merge and clean up of MMU and non-MMU common files, namely signal.c
and dma.c. There is also a simplification of the ColdFire GPIO setup tables.
Using a couple of simple macros we make the init tables really small and
easy to read, and save a couple of thousand lines of code. Also a move of
all the ColdFire subarch support files into the existing coldfire directory.
The sub-directories just ended up duplicating Makefiles and now only contain
really simple pieces of code. This saves quite a few lines of code too.

As always a couple of bugs fixes thrown in too. Oh and a new defconfig for
the ColdFire platforms that support having the MMU enabled.

Thanks
Greg





The following changes since commit 36be50515fe2aef61533b516fa2576a2c7fe7664:
  Linus Torvalds (1):
        Linux 3.4-rc7

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-next

Ezequiel Garcia (1):
      m68k: fix compiler warning by properly inlining flat_set_persistent()

Greg Ungerer (37):
      m68k: merge the MMU and non-MMU signal.c code
      m68knommu: introduce macros to simplify ColdFire GPIO table initialization
      m68knommu: switch to GPIO init macros in ColdFire 5206 init code
      m68knommu: switch to GPIO init macros in ColdFire 520x init code
      m68knommu: switch to GPIO init macros in ColdFire 523x init code
      m68knommu: switch to GPIO init macros in ColdFire 5249 init code
      m68knommu: switch to GPIO init macros in ColdFire 5272 init code
      m68knommu: switch to GPIO init macros in ColdFire 527x init code
      m68knommu: switch to GPIO init macros in ColdFire 528x init code
      m68knommu: switch to GPIO init macros in ColdFire 5307 init code
      m68knommu: switch to GPIO init macros in ColdFire 5407 init code
      m68knommu: switch to GPIO init macros in ColdFire 532x init code
      m68knommu: make duplicated ColdFire GPIO init code common for all
      m68knommu: simplify the ColdFire 5206 GPIO struct setup
      m68knommu: simplify the ColdFire 520x GPIO struct setup
      m68knommu: simplify the ColdFire 523x GPIO struct setup
      m68knommu: simplify the ColdFire 5249 GPIO struct setup
      m68knommu: simplify the ColdFire 5272 GPIO struct setup
      m68knommu: simplify the ColdFire 527x GPIO struct setup
      m68knommu: simplify the ColdFire 528x GPIO struct setup
      m68knommu: simplify the ColdFire 5307 GPIO struct setup
      m68knommu: simplify the ColdFire 532x GPIO struct setup
      m68knommu: simplify the ColdFire 5407 GPIO struct setup
      m68knommu: move the 5206 platform code into the common ColdFire code directory
      m68knommu: move the 520x platform code into the common ColdFire code directory
      m68knommu: move the 523x platform code into the common ColdFire code directory
      m68knommu: move the 5249 platform code into the common ColdFire code directory
      m68knommu: move the 5272 platform code into the common ColdFire code directory
      m68knommu: move the 527x platform code into the common ColdFire code directory
      m68knommu: move the 528x platform code into the common ColdFire code directory
      m68knommu: move the 5307 platform code into the common ColdFire code directory
      m68knommu: move the 5407 platform code into the common ColdFire code directory
      m68knommu: move the 532x platform code into the common ColdFire code directory
      m68knommu: move the 54xx platform code into the common ColdFire code directory
      m68knommu: reorganize the no-MMU cache flushing to match m68k
      m68k: merge the MMU and non-MMU versions of the arch dma code
      m68k: add a defconfig for the M5475EVB ColdFire with MMU board

Luis Alves (1):
      m68knommu: unaligned.h fix for M68000 core

 arch/m68k/Makefile                                 |   12 -
 arch/m68k/configs/m5475evb_defconfig               |   62 +
 arch/m68k/include/asm/cacheflush_no.h              |   32 +-
 arch/m68k/include/asm/flat.h                       |    7 +-
 arch/m68k/include/asm/m528xsim.h                   |  179 ++--
 arch/m68k/include/asm/mcfgpio.h                    |   57 +
 arch/m68k/include/asm/unaligned.h                  |    2 +-
 arch/m68k/kernel/dma.c                             |  165 +++-
 arch/m68k/kernel/dma_mm.c                          |  131 ---
 arch/m68k/kernel/dma_no.c                          |   75 --
 arch/m68k/kernel/signal.c                          | 1201 +++++++++++++++++++-
 arch/m68k/kernel/signal_mm.c                       | 1115 ------------------
 arch/m68k/kernel/signal_no.c                       |  765 -------------
 arch/m68k/platform/5206/Makefile                   |   18 -
 arch/m68k/platform/5206/gpio.c                     |   49 -
 arch/m68k/platform/520x/Makefile                   |   17 -
 arch/m68k/platform/520x/gpio.c                     |  175 ---
 arch/m68k/platform/523x/Makefile                   |   17 -
 arch/m68k/platform/523x/gpio.c                     |  284 -----
 arch/m68k/platform/5249/Makefile                   |   18 -
 arch/m68k/platform/5249/gpio.c                     |   65 --
 arch/m68k/platform/5272/Makefile                   |   18 -
 arch/m68k/platform/5272/gpio.c                     |   81 --
 arch/m68k/platform/527x/Makefile                   |   18 -
 arch/m68k/platform/527x/gpio.c                     |  609 ----------
 arch/m68k/platform/528x/Makefile                   |   18 -
 arch/m68k/platform/528x/gpio.c                     |  438 -------
 arch/m68k/platform/5307/Makefile                   |   20 -
 arch/m68k/platform/5307/gpio.c                     |   49 -
 arch/m68k/platform/532x/Makefile                   |   18 -
 arch/m68k/platform/532x/gpio.c                     |  337 ------
 arch/m68k/platform/5407/Makefile                   |   18 -
 arch/m68k/platform/5407/gpio.c                     |   49 -
 arch/m68k/platform/54xx/Makefile                   |   19 -
 arch/m68k/platform/coldfire/Makefile               |   28 +-
 arch/m68k/platform/{54xx => coldfire}/firebee.c    |    0
 arch/m68k/platform/coldfire/gpio.c                 |    4 +
 .../{5249/intc2.c => coldfire/intc-5249.c}         |    0
 .../platform/{5272/intc.c => coldfire/intc-5272.c} |    0
 .../platform/{5206/config.c => coldfire/m5206.c}   |    9 +
 .../platform/{520x/config.c => coldfire/m520x.c}   |   16 +
 .../platform/{523x/config.c => coldfire/m523x.c}   |   22 +
 .../platform/{5249/config.c => coldfire/m5249.c}   |   10 +
 .../platform/{5272/config.c => coldfire/m5272.c}   |   11 +
 .../platform/{527x/config.c => coldfire/m527x.c}   |   43 +
 .../platform/{528x/config.c => coldfire/m528x.c}   |   31 +
 .../platform/{5307/config.c => coldfire/m5307.c}   |    9 +
 .../platform/{532x/config.c => coldfire/m532x.c}   |   25 +
 .../platform/{5407/config.c => coldfire/m5407.c}   |    9 +
 .../platform/{54xx/config.c => coldfire/m54xx.c}   |    7 +
 arch/m68k/platform/{5307 => coldfire}/nettel.c     |    0
 51 files changed, 1807 insertions(+), 4555 deletions(-)
 create mode 100644 arch/m68k/configs/m5475evb_defconfig
 delete mode 100644 arch/m68k/kernel/dma_mm.c
 delete mode 100644 arch/m68k/kernel/dma_no.c
 delete mode 100644 arch/m68k/kernel/signal_mm.c
 delete mode 100644 arch/m68k/kernel/signal_no.c
 delete mode 100644 arch/m68k/platform/5206/Makefile
 delete mode 100644 arch/m68k/platform/5206/gpio.c
 delete mode 100644 arch/m68k/platform/520x/Makefile
 delete mode 100644 arch/m68k/platform/520x/gpio.c
 delete mode 100644 arch/m68k/platform/523x/Makefile
 delete mode 100644 arch/m68k/platform/523x/gpio.c
 delete mode 100644 arch/m68k/platform/5249/Makefile
 delete mode 100644 arch/m68k/platform/5249/gpio.c
 delete mode 100644 arch/m68k/platform/5272/Makefile
 delete mode 100644 arch/m68k/platform/5272/gpio.c
 delete mode 100644 arch/m68k/platform/527x/Makefile
 delete mode 100644 arch/m68k/platform/527x/gpio.c
 delete mode 100644 arch/m68k/platform/528x/Makefile
 delete mode 100644 arch/m68k/platform/528x/gpio.c
 delete mode 100644 arch/m68k/platform/5307/Makefile
 delete mode 100644 arch/m68k/platform/5307/gpio.c
 delete mode 100644 arch/m68k/platform/532x/Makefile
 delete mode 100644 arch/m68k/platform/532x/gpio.c
 delete mode 100644 arch/m68k/platform/5407/Makefile
 delete mode 100644 arch/m68k/platform/5407/gpio.c
 delete mode 100644 arch/m68k/platform/54xx/Makefile
 rename arch/m68k/platform/{54xx => coldfire}/firebee.c (100%)
 rename arch/m68k/platform/{5249/intc2.c => coldfire/intc-5249.c} (100%)
 rename arch/m68k/platform/{5272/intc.c => coldfire/intc-5272.c} (100%)
 rename arch/m68k/platform/{5206/config.c => coldfire/m5206.c} (80%)
 rename arch/m68k/platform/{520x/config.c => coldfire/m520x.c} (84%)
 rename arch/m68k/platform/{523x/config.c => coldfire/m523x.c} (74%)
 rename arch/m68k/platform/{5249/config.c => coldfire/m5249.c} (87%)
 rename arch/m68k/platform/{5272/config.c => coldfire/m5272.c} (88%)
 rename arch/m68k/platform/{527x/config.c => coldfire/m527x.c} (70%)
 rename arch/m68k/platform/{528x/config.c => coldfire/m528x.c} (73%)
 rename arch/m68k/platform/{5307/config.c => coldfire/m5307.c} (85%)
 rename arch/m68k/platform/{532x/config.c => coldfire/m532x.c} (94%)
 rename arch/m68k/platform/{5407/config.c => coldfire/m5407.c} (77%)
 rename arch/m68k/platform/{54xx/config.c => coldfire/m54xx.c} (93%)
 rename arch/m68k/platform/{5307 => coldfire}/nettel.c (100%)
