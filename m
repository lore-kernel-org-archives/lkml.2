Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab1EYSol (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 14:44:41 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:34408 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233Ab1EYSoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 14:44:39 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: uclinux-dist-devel@blackfin.uclinux.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/37] Blackfin updates for 2.6.40-rc1
Date: Wed, 25 May 2011 14:44:40 -0400
Message-Id: <1306349080-12793-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.5.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've got some /proc updates to seq_file's, some cpumask to newer APIs,
clean up of the Blackfin system interrupt handling to make life with the
BF537 easier and more correct, more anomaly workarounds, and initial
perf_event support.  As well as your minor sets of board updates.

Sorry for getting this out late as I was doing a spot of traveling this
weekend.  Seems like I always manage to do that as a new release is made.

Alexey Dobriyan (2):
  Blackfin: switch /proc/gpio to seq_file
  Blackfin: convert /proc/sram to seq_file

KOSAKI Motohiro (3):
  Blackfin: don't touch cpu_possible_map and cpu_present_map directly
  Blackfin: don't touch task->cpus_allowed directly
  Blackfin: convert old cpumask API to new one

Lars-Peter Clausen (1):
  MAINTAINERS: Fix Analog Devices mailinglist address

Mike Frysinger (27):
  Blackfin: first pass at debug mmr support
  Blackfin: ints-priority: clean up some local vars
  Blackfin: ints-priority: unify duplicate vec to irq lookup logic
  Blackfin: unify core IRQ definitions
  Blackfin: clean up style in irq defines
  Blackfin: bf533/bf537/bf561: convert to BFIN_IRQ helper
  Blackfin: bf527-ezkit: tweak sound defconfig
  Blackfin: clean up /proc/cpuinfo output
  Blackfin: SMP: fix cpudata cache setup
  Blackfin: SMP: drop unused blackfin_cpudata.idle pointer
  Blackfin: delete duplicated user single step prototypes
  Blackfin: bf51x/bf52x: fix typo in hysteresis MMR names
  Blackfin: clean up irq ifdef logic a bit
  Blackfin: move internal irq prototypes out of global namespace
  Blackfin: move bf537-specific irq code out of common code
  Blackfin: bf54x: drop unused pm gpio handling
  Blackfin: bf537: fix excessive gpio int demuxing
  Blackfin: bf537: demux port H mask A and emac rx ints
  Blackfin: optimize MMR reads during startup a bit
  Blackfin: bf533-stamp/bf537-stamp: drop ad1980 from defconfigs
  Blackfin: use on-chip reset func with newer parts
  Blackfin: update anomaly lists to latest public info
  Blackfin: initial perf_event support
  Blackfin: bf548-ezkit/bf561-ezkit: update nor flash layout
  Blackfin: fix indentation with bfin_read() helper
  Blackfin: fix addr type with bfin_write_{or,and} helpers
  Blackfin: use new common PERCPU_INPUT define

Scott Jiang (1):
  Blackfin: boards: update ASoC resources after machine driver overhaul

Sonic Zhang (2):
  Blackfin: don't attempt to flush on-chip L1 SRAM regions
  Blackfin: kgdb: cache flushing is not safe in SMP mode

Steven Miao (1):
  Blackfin: work around anomaly 05000480

 MAINTAINERS                                       |   20 +-
 arch/blackfin/Kconfig                             |    2 +
 arch/blackfin/Kconfig.debug                       |    2 +-
 arch/blackfin/configs/BF527-EZKIT-V2_defconfig    |   12 +-
 arch/blackfin/configs/BF527-EZKIT_defconfig       |   14 +-
 arch/blackfin/configs/BF533-STAMP_defconfig       |    2 -
 arch/blackfin/configs/BF537-STAMP_defconfig       |    2 -
 arch/blackfin/include/asm/bfin-global.h           |   10 -
 arch/blackfin/include/asm/bfin_pfmon.h            |   44 +
 arch/blackfin/include/asm/bfin_sport.h            |    4 +
 arch/blackfin/include/asm/cacheflush.h            |   23 +-
 arch/blackfin/include/asm/cpu.h                   |    3 -
 arch/blackfin/include/asm/def_LPBlackfin.h        |   12 +-
 arch/blackfin/include/asm/irq_handler.h           |   25 +
 arch/blackfin/include/asm/kgdb.h                  |    6 +-
 arch/blackfin/include/asm/perf_event.h            |    1 +
 arch/blackfin/include/asm/ptrace.h                |    2 -
 arch/blackfin/include/mach-common/irq.h           |   57 +
 arch/blackfin/kernel/Makefile                     |    3 +
 arch/blackfin/kernel/bfin_dma_5xx.c               |    5 +
 arch/blackfin/kernel/bfin_gpio.c                  |   34 +-
 arch/blackfin/kernel/bfin_ksyms.c                 |    1 +
 arch/blackfin/kernel/debug-mmrs.c                 | 1860 +++++++++++++++++++++
 arch/blackfin/kernel/ipipe.c                      |    1 +
 arch/blackfin/kernel/irqchip.c                    |    1 +
 arch/blackfin/kernel/nmi.c                        |    8 +-
 arch/blackfin/kernel/perf_event.c                 |  498 ++++++
 arch/blackfin/kernel/process.c                    |    6 +-
 arch/blackfin/kernel/reboot.c                     |   65 +-
 arch/blackfin/kernel/setup.c                      |   54 +-
 arch/blackfin/kernel/vmlinux.lds.S                |    8 +-
 arch/blackfin/mach-bf518/include/mach/anomaly.h   |    4 +-
 arch/blackfin/mach-bf518/include/mach/cdefBF512.h |   16 +-
 arch/blackfin/mach-bf518/include/mach/defBF512.h  |    8 +-
 arch/blackfin/mach-bf518/include/mach/irq.h       |  262 ++--
 arch/blackfin/mach-bf527/boards/ezkit.c           |   74 +-
 arch/blackfin/mach-bf527/include/mach/anomaly.h   |    8 +-
 arch/blackfin/mach-bf527/include/mach/cdefBF522.h |   16 +-
 arch/blackfin/mach-bf527/include/mach/defBF522.h  |    8 +-
 arch/blackfin/mach-bf527/include/mach/irq.h       |  266 ++--
 arch/blackfin/mach-bf533/include/mach/anomaly.h   |   11 +-
 arch/blackfin/mach-bf533/include/mach/irq.h       |  168 +--
 arch/blackfin/mach-bf537/boards/stamp.c           |  106 ++-
 arch/blackfin/mach-bf537/include/mach/anomaly.h   |   10 +-
 arch/blackfin/mach-bf537/include/mach/irq.h       |  365 ++---
 arch/blackfin/mach-bf537/ints-priority.c          |  163 ++
 arch/blackfin/mach-bf538/include/mach/anomaly.h   |    9 +-
 arch/blackfin/mach-bf538/include/mach/irq.h       |   89 +-
 arch/blackfin/mach-bf548/boards/ezkit.c           |  116 ++-
 arch/blackfin/mach-bf548/include/mach/anomaly.h   |    8 +-
 arch/blackfin/mach-bf548/include/mach/irq.h       |   89 +-
 arch/blackfin/mach-bf561/boards/ezkit.c           |   10 +-
 arch/blackfin/mach-bf561/include/mach/anomaly.h   |   15 +-
 arch/blackfin/mach-bf561/include/mach/irq.h       |  505 ++----
 arch/blackfin/mach-bf561/smp.c                    |   17 +-
 arch/blackfin/mach-common/dpmc.c                  |    7 +-
 arch/blackfin/mach-common/ints-priority.c         |  476 ++----
 arch/blackfin/mach-common/smp.c                   |   28 +-
 arch/blackfin/mm/sram-alloc.c                     |   43 +-
 59 files changed, 4011 insertions(+), 1671 deletions(-)
 create mode 100644 arch/blackfin/include/asm/bfin_pfmon.h
 create mode 100644 arch/blackfin/include/asm/perf_event.h
 create mode 100644 arch/blackfin/include/mach-common/irq.h
 create mode 100644 arch/blackfin/kernel/debug-mmrs.c
 create mode 100644 arch/blackfin/kernel/perf_event.c

-- 
1.7.5.rc3

