Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab2CUFUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 01:20:52 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:2838
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751322Ab2CUFUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 01:20:49 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275dhz2ei87h2a8h668h839hd24h)
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Bob Liu <lliubbo@gmail.com>
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <uclinux-dist-devel@blackfin.uclinux.org>,
        <vapier@gentoo.org>, <sonic.zhang@analog.com>,
        Bob Liu <lliubbo@gmail.com>
Subject: [GIT PULL] blackfin updates for v3.4
Date: Wed, 21 Mar 2012 13:18:08 +0800
Message-ID: <1332307088-11233-1-git-send-email-lliubbo@gmail.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit e45836fafe157df137a837093037f741ad8f4c90:
  Linus Torvalds (1):
        Merge branch 'for-3.4' of git://git.kernel.org/.../tj/wq

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lliubbo/blackfin.git for-linus

Barry Song (2):
      blackfin: restore L1 base address and length
      blackfin: cplb-mpu: fix page mask table overflow

Bob Liu (10):
      bfin_sport: add support for ADC/DAC.
      blackfin: bf561: forgot CSYNC in get_core_lock_noflush
      blackfin: kgdb: skip hardware watchpoint test
      blackfin: bf537: stamp: update board file for 193x
      bfin: add bfin_ad73311_machine platform device
      blackfin: thread_info: add suspend flag
      blackfin: update default defconfig
      blackfin: cleanup anomaly workarounds
      arch: blackfin: udpate defconfig
      blackfin:dma: rename bfin_dma_5xx.c to bfin_dma.c

Danny Kukawka (2):
      arch/blackfin: don't generate random mac in bfin_get_ether_addr()
      Blackfin: pnav: delete duplicate linux/export.h include

David Howells (1):
      Disintegrate asm/system.h for Blackfin [ver #2]

Geert Uytterhoeven (1):
      Blackfin: s/#if CONFIG/#ifdef CONFIG/

Mike Frysinger (2):
      spi/bfin_spi: drop bits_per_word from client data
      Blackfin: wire up new process_vm syscalls

Scott Jiang (2):
      bf548: add ppi interrupt mask and blanking clocks
      bf561: add ppi DLEN macro for 10bits to 16bits

Sonic Zhang (2):
      bf548: ssm2602: Add ssm2602 platform data into bf548 ezkit board file.
      blackfin: clean up string bfin_dma_5xx after rename.

Steven Miao (2):
      BF561 MDMA : fixed BF561 DMA MMRs definition mismatch
      blackfin: timer: refine bfin simple timer driver

 arch/blackfin/configs/BF518F-EZBRD_defconfig       |   25 ++-
 arch/blackfin/configs/BF526-EZBRD_defconfig        |   26 ++--
 arch/blackfin/configs/BF527-EZKIT-V2_defconfig     |   27 ++-
 arch/blackfin/configs/BF527-EZKIT_defconfig        |   28 ++--
 arch/blackfin/configs/BF533-EZKIT_defconfig        |   23 +-
 arch/blackfin/configs/BF533-STAMP_defconfig        |   22 +-
 arch/blackfin/configs/BF537-STAMP_defconfig        |   27 ++--
 arch/blackfin/configs/BF548-EZKIT_defconfig        |   15 +-
 arch/blackfin/configs/BF561-EZKIT-SMP_defconfig    |   35 ++--
 arch/blackfin/configs/BF561-EZKIT_defconfig        |   23 +-
 arch/blackfin/include/asm/atomic.h                 |    2 +
 arch/blackfin/include/asm/barrier.h                |   48 ++++
 arch/blackfin/include/asm/bfin5xx_spi.h            |    1 -
 arch/blackfin/include/asm/bfin_simple_timer.h      |   10 +-
 arch/blackfin/include/asm/bfin_sport.h             |    3 +
 arch/blackfin/include/asm/blackfin.h               |   44 ++--
 arch/blackfin/include/asm/cmpxchg.h                |  132 ++++++++++++
 arch/blackfin/include/asm/exec.h                   |    1 +
 arch/blackfin/include/asm/irq_handler.h            |    1 +
 arch/blackfin/include/asm/kgdb.h                   |    1 +
 arch/blackfin/include/asm/mmu_context.h            |    5 +-
 arch/blackfin/include/asm/switch_to.h              |   39 ++++
 arch/blackfin/include/asm/system.h                 |  197 +-----------------
 arch/blackfin/include/asm/thread_info.h            |    2 +
 arch/blackfin/include/asm/unistd.h                 |    4 +-
 arch/blackfin/kernel/Makefile                      |    2 +-
 arch/blackfin/kernel/asm-offsets.c                 |    1 +
 .../blackfin/kernel/{bfin_dma_5xx.c => bfin_dma.c} |    8 +-
 arch/blackfin/kernel/cplb-mpu/cplbmgr.c            |    2 +
 arch/blackfin/kernel/ipipe.c                       |    1 -
 arch/blackfin/kernel/kgdb_test.c                   |    1 -
 arch/blackfin/kernel/process.c                     |    1 +
 arch/blackfin/kernel/ptrace.c                      |    1 -
 arch/blackfin/kernel/reboot.c                      |    1 -
 arch/blackfin/kernel/setup.c                       |    1 +
 arch/blackfin/kernel/trace.c                       |    1 +
 arch/blackfin/kernel/traps.c                       |    1 +
 arch/blackfin/lib/ins.S                            |    2 +-
 arch/blackfin/mach-bf518/boards/ezbrd.c            |    3 +-
 arch/blackfin/mach-bf518/boards/tcm-bf518.c        |    5 +-
 arch/blackfin/mach-bf527/boards/ad7160eval.c       |    3 +-
 arch/blackfin/mach-bf527/boards/cm_bf527.c         |    5 +-
 arch/blackfin/mach-bf527/boards/ezbrd.c            |    3 +-
 arch/blackfin/mach-bf527/boards/ezkit.c            |    3 +-
 arch/blackfin/mach-bf527/boards/tll6527m.c         |    3 +-
 arch/blackfin/mach-bf537/boards/cm_bf537e.c        |    5 +-
 arch/blackfin/mach-bf537/boards/cm_bf537u.c        |    5 +-
 arch/blackfin/mach-bf537/boards/dnp5370.c          |    3 +-
 arch/blackfin/mach-bf537/boards/pnav10.c           |    6 +-
 arch/blackfin/mach-bf537/boards/stamp.c            |   27 ++-
 arch/blackfin/mach-bf537/boards/tcm_bf537.c        |    5 +-
 arch/blackfin/mach-bf548/boards/ezkit.c            |   49 ++++-
 arch/blackfin/mach-bf561/atomic.S                  |    7 +
 arch/blackfin/mach-bf561/include/mach/defBF561.h   |  227 ++++++++++----------
 arch/blackfin/mach-common/entry.S                  |    4 +-
 55 files changed, 631 insertions(+), 496 deletions(-)
 create mode 100644 arch/blackfin/include/asm/barrier.h
 create mode 100644 arch/blackfin/include/asm/cmpxchg.h
 create mode 100644 arch/blackfin/include/asm/exec.h
 create mode 100644 arch/blackfin/include/asm/switch_to.h
 rename arch/blackfin/kernel/{bfin_dma_5xx.c => bfin_dma.c} (98%)

