Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab0ESUNY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 16:13:24 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39663 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895Ab0ESUNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 16:13:21 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,5987"; a="41877852"
Subject: [GIT PULL] ARM MSM update for 2.6.35
From: Daniel Walker <dwalker@codeaurora.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 May 2010 13:13:06 -0700
Message-ID: <1274299986.22641.24.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

Here's an update for ARM MSM for 2.6.35. It includes support to
generalize the sub-architecture to support more chips, and adds support
for two new chips (MSM7x30 and QSD8x50). There some syncing with Google
and Qualcomm trees, and it also includes a number of needed changes to
get this sub-architecture into a more usable state.

Daniel 


The following changes since commit 1252fa3154fae1f9624ea40cbbf0ea5e21319013:

  Revert "arm: msm: add oprofile pmu support" (2010-05-07 12:09:52 -0700)

are available in the git repository at:
  git://codeaurora.org/quic/kernel/dwalker/linux-msm.git msm-core

Arve Hjønnevåg (7):
      [ARM] msm: halibut: Add memory configuration.
      [ARM] msm: Add MSM_DEBUG_UART option.
      [ARM] msm: irq: fix lockdep issues
      [ARM] msm: dma: disable_irq -> disable_irq_nosync
      [ARM] msm: dma: Enable dma clock while dma is active
      [ARM] msm: Add item argument to smsm_change_state and smsm_get_state
      [ARM] msm: Add 8k power collapse support to smd

Brian Swetland (8):
      msm: add dsb() syncronization to datamover driver
      [ARM] msm: shared memory interface for baseband processor ipc
      [ARM] msm: smd: don't crash if the smd channel table doesn't exist
      msm: smd: initial support for smd v2
      [ARM] msm: cleanup smd, separate debugfs support
      [ARM] msm: smd: add support for DSP SMD channels
      msm/qsd: smd: avoid race condition in smd channel allocation
      msm: smd: provide atomic channel writes

Daniel Walker (39):
      arm: msm: add board file for the HTC Sapphire device
      arm: msm: add board file for MSM7x25/MSM7x27 SURF and FFA
      arm: msm: add board file for MSM7x30 SURF and FFA
      arm: msm: add board file for QSD8x50 SURF and FFA
      arm: msm: add cpu frequency controls
      arm: msm: move board-dream.c to board-trout.c
      arm: msm: warning fix in acpuclock.c
      arm: msm: add board file for Nexus One (ie. mahimahi)
      MAINTAINERS: add MSM mailing list
      arm: msm: smd: checkpatch clean up of smd/proc_comm
      arm: msm: smd: use either package v3 or v4 not both
      arm: msm: smd: convert unsigned addr to unsigned long
      arm: msm: smd: msm7x30 a2m clean up
      arm: msm: smd: remove unneeded predefines
      arm: msm: smd: ifdef dsp irq handler
      arm: msm: smd: fix SMD modem processor sync condition
      arm: msm: smd: remove Kconfig menu option
      arm: msm: trout: fix build failure without UART
      arm: msm: smd: fix initcall prototype compiler warning
      arm: msm: video: add msm_fb.h
      msm: generalize clock support.
      msm: timer: allow MSM_DGT_BASE to be overriden
      msm: irqs: add irqs-8x50.h for QSD8x50 support
      msm: add msm_iomap-8x50.h for QSD8x50 support
      msm: update basic board layout for QSD8x50
      msm: add devices-qsd8x50.c
      msm: add extern for 8x50 clock list.
      msm: io: add io support for 8x50
      msm: physical offset for QSD8x50
      msm: 8x50 Kconfig changes
      msm: irqs: add irqs-7x30.h for MSM7x30 support
      msm: add msm_iomap-7x30.h for MSM7x30 support
      msm: add devices-msm7x30.c
      msm: update basic board layout for MSM7x30
      msm: dma: add 7x30 security domain abstraction
      msm: Add extern for 7x30 clock list.
      msm: io: add io support for 7x30
      msm: physical offset for MSM7X30
      msm: 7x30 Kconfig and makefile changes

Dima Zavin (4):
      [ARM] msm: Update list of proc_comm enums.
      [ARM] msm: sdcc: Make slot status irq be a resource
      arm: msm: correctly signal the apps-to-modem irq in smd/proc_comm
      [ARM] msm: smd: Force the half_channel struct aligmnent to 4

Gregory Bean (7):
      msm: generalization to support multiple SOCs.
      msm: generialize IRQ to support multiple SOCs.
      msm: generialize iomap to support multiple SOCs.
      msm: add sirc interrupt controller driver.
      msm: add tlmm support for gpio.
      msm: add Qualcomm 7x30 interrupt controller driver.
      msm: clock support for the MSM7x30 CPU.

Haley Teng (1):
      [ARM] msm: smd: Update the correct fTAIL pointer after reading from fifo

Iliyan Malchev (1):
      [ARM] msm: add /proc/last_radio_log when supported by the modem.

Matt Wilson (1):
      arm: msm: add vreg reference count

San Mehat (1):
      [ARM] msm: common: Add SDC device runtime registration

Steve Muckle (2):
      arm: msm: return error pointer in vreg_get if vreg not found
      arm: msm: status for vreg

Willie Ruan (1):
      [ARM] msm: add new vreg IDs for MSM7X30

 MAINTAINERS                                        |    1 +
 arch/arm/mach-msm/Kconfig                          |   92 ++-
 arch/arm/mach-msm/Makefile                         |   23 +-
 arch/arm/mach-msm/acpuclock-arm11.c                |  526 ++++++++++
 arch/arm/mach-msm/acpuclock.h                      |   32 +
 arch/arm/mach-msm/board-halibut.c                  |   17 +-
 arch/arm/mach-msm/board-mahimahi.c                 |   87 ++
 arch/arm/mach-msm/board-msm7x27.c                  |  179 ++++
 arch/arm/mach-msm/board-msm7x30.c                  |  120 +++
 arch/arm/mach-msm/board-qsd8x50.c                  |   94 ++
 arch/arm/mach-msm/board-sapphire.c                 |  118 +++
 arch/arm/mach-msm/{board-dream.c => board-trout.c} |    8 +-
 arch/arm/mach-msm/{board-dream.h => board-trout.h} |    0
 arch/arm/mach-msm/clock-7x01a.c                    |  126 ---
 arch/arm/mach-msm/clock-7x30.h                     |  168 ++++
 arch/arm/mach-msm/clock-pcom.c                     |  131 +++
 arch/arm/mach-msm/clock-pcom.h                     |  153 +++
 arch/arm/mach-msm/clock.c                          |  258 ++++--
 arch/arm/mach-msm/clock.h                          |   71 ++-
 arch/arm/mach-msm/devices-msm7x00.c                |  393 ++++++++
 arch/arm/mach-msm/devices-msm7x30.c                |  128 +++
 arch/arm/mach-msm/devices-qsd8x50.c                |   92 ++
 arch/arm/mach-msm/devices.c                        |  268 -----
 arch/arm/mach-msm/devices.h                        |   11 +
 arch/arm/mach-msm/dma.c                            |   23 +-
 arch/arm/mach-msm/gpio.c                           |   85 ++
 arch/arm/mach-msm/include/mach/board.h             |   14 +-
 arch/arm/mach-msm/include/mach/clk.h               |   57 ++
 arch/arm/mach-msm/include/mach/dma.h               |   32 +-
 arch/arm/mach-msm/include/mach/gpio.h              |  142 +++
 arch/arm/mach-msm/include/mach/io.h                |    5 +
 arch/arm/mach-msm/include/mach/irqs-7x00.h         |   75 ++
 arch/arm/mach-msm/include/mach/irqs-7x30.h         |  170 ++++
 arch/arm/mach-msm/include/mach/irqs-8x50.h         |  105 ++
 arch/arm/mach-msm/include/mach/irqs.h              |   81 +--
 arch/arm/mach-msm/include/mach/memory.h            |    8 +
 arch/arm/mach-msm/include/mach/msm_fb.h            |  147 +++
 arch/arm/mach-msm/include/mach/msm_iomap-7x00.h    |  139 +++
 arch/arm/mach-msm/include/mach/msm_iomap-7x30.h    |  122 +++
 arch/arm/mach-msm/include/mach/msm_iomap-8x50.h    |  147 +++
 arch/arm/mach-msm/include/mach/msm_iomap.h         |   95 +--
 arch/arm/mach-msm/include/mach/msm_smd.h           |  109 ++
 arch/arm/mach-msm/include/mach/sirc.h              |  115 +++
 arch/arm/mach-msm/include/mach/system.h            |    5 +
 arch/arm/mach-msm/include/mach/vreg.h              |    2 +-
 arch/arm/mach-msm/io.c                             |   75 ++-
 arch/arm/mach-msm/irq-vic.c                        |  365 +++++++
 arch/arm/mach-msm/irq.c                            |    4 +-
 arch/arm/mach-msm/last_radio_log.c                 |   82 ++
 arch/arm/mach-msm/proc_comm.c                      |   26 +-
 arch/arm/mach-msm/proc_comm.h                      |  105 ++-
 arch/arm/mach-msm/sirc.c                           |  177 ++++
 arch/arm/mach-msm/smd.c                            | 1046 ++++++++++++++++++++
 arch/arm/mach-msm/smd_debug.c                      |  315 ++++++
 arch/arm/mach-msm/smd_private.h                    |  403 ++++++++
 arch/arm/mach-msm/timer.c                          |    2 +
 arch/arm/mach-msm/vreg.c                           |  154 +++-
 57 files changed, 6807 insertions(+), 721 deletions(-)
 create mode 100644 arch/arm/mach-msm/acpuclock-arm11.c
 create mode 100644 arch/arm/mach-msm/acpuclock.h
 create mode 100644 arch/arm/mach-msm/board-mahimahi.c
 create mode 100644 arch/arm/mach-msm/board-msm7x27.c
 create mode 100644 arch/arm/mach-msm/board-msm7x30.c
 create mode 100644 arch/arm/mach-msm/board-qsd8x50.c
 create mode 100644 arch/arm/mach-msm/board-sapphire.c
 rename arch/arm/mach-msm/{board-dream.c => board-trout.c} (93%)
 rename arch/arm/mach-msm/{board-dream.h => board-trout.h} (100%)
 delete mode 100644 arch/arm/mach-msm/clock-7x01a.c
 create mode 100644 arch/arm/mach-msm/clock-7x30.h
 create mode 100644 arch/arm/mach-msm/clock-pcom.c
 create mode 100644 arch/arm/mach-msm/clock-pcom.h
 create mode 100644 arch/arm/mach-msm/devices-msm7x00.c
 create mode 100644 arch/arm/mach-msm/devices-msm7x30.c
 create mode 100644 arch/arm/mach-msm/devices-qsd8x50.c
 delete mode 100644 arch/arm/mach-msm/devices.c
 create mode 100644 arch/arm/mach-msm/gpio.c
 create mode 100644 arch/arm/mach-msm/include/mach/clk.h
 create mode 100644 arch/arm/mach-msm/include/mach/gpio.h
 create mode 100644 arch/arm/mach-msm/include/mach/irqs-7x00.h
 create mode 100644 arch/arm/mach-msm/include/mach/irqs-7x30.h
 create mode 100644 arch/arm/mach-msm/include/mach/irqs-8x50.h
 create mode 100644 arch/arm/mach-msm/include/mach/msm_fb.h
 create mode 100644 arch/arm/mach-msm/include/mach/msm_iomap-7x00.h
 create mode 100644 arch/arm/mach-msm/include/mach/msm_iomap-7x30.h
 create mode 100644 arch/arm/mach-msm/include/mach/msm_iomap-8x50.h
 create mode 100644 arch/arm/mach-msm/include/mach/msm_smd.h
 create mode 100644 arch/arm/mach-msm/include/mach/sirc.h
 create mode 100644 arch/arm/mach-msm/irq-vic.c
 create mode 100644 arch/arm/mach-msm/last_radio_log.c
 create mode 100644 arch/arm/mach-msm/sirc.c
 create mode 100644 arch/arm/mach-msm/smd.c
 create mode 100644 arch/arm/mach-msm/smd_debug.c
 create mode 100644 arch/arm/mach-msm/smd_private.h


