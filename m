Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab2IMS6H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 14:58:07 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:7349 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab2IMS6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 14:58:04 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6834"; a="234069687"
Date: Thu, 13 Sep 2012 11:58:02 -0700
From: David Brown <davidb@codeaurora.org>
To: arm@kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL 5/5] msm all changes
Message-ID: <20120913185802.GE30032@codeaurora.org>
References: <20120913185342.GA29823@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120913185342.GA29823@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 28a33cbc24e4256c143dce96c7d93bf423229f92:

  Linux 3.5 (2012-07-21 13:58:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git tags/msm-merged-for-3.7

for you to fetch changes up to 9b9b5ed018ac77127140d41fbfbe0224fad1d088:

  Merge branch '36/board' into 36/merged (2012-09-13 11:23:22 -0700)

----------------------------------------------------------------

This is a merge of the following tags:
    msm-board-for-3.7
    msm-cleanup-for-3.7
    msm-dt-for-3.7
    msm-fix-noncrit-for-3.7

mostly to show the correct merge resolution.  There's a trivial merge
resolve in arch/arm/mach-msm/io.c.

The rename of arch/arm/mach-msm/board-msm8x60.c to
arch/arm/mach-msm/board-dt-8660.c seems to have confused git, causing
it to drop
  ARM: msm: Remove call to missing FPGA init on 8660
so this merge resolution fixes that.

----------------------------------------------------------------
David Brown (5):
      ARM: msm: Remove call to missing FPGA init on 8660
      Merge branch '36/cleanup' into 36/merged
      Merge branch '36/fix-noncrit' into 36/merged
      Merge branch '36/dt' into 36/merged
      Merge branch '36/board' into 36/merged

Rohit Vaswani (2):
      ARM: msm: io: Remove 7x30 iomap region from 7x00
      ARM: msm: io: Change the default static iomappings to be shared

Stephen Boyd (20):
      ARM: msm: Remove msm_hw_reset_hook
      ARM: msm: clock-pcom: Mark functions static
      ARM: msm: Remove unused idle.c
      ARM: msm: Fix early debug uart mapping on some memory configs
      ARM: msm: Add handle_irq handler for 8660 DT machine
      ARM: msm: Add msm8660-surf.dts to Makefile.boot
      ARM: msm: Fix sparse warnings due to incorrect type
      ARM: msm: Remove unused acpuclock-arm11
      ARM: msm: Remove uncompiled board-msm7x27
      ARM: msm: Don't touch GIC registers outside of GIC code
      ARM: msm: Allow timer.c to compile on multiple targets
      ARM: msm: Add DT support to msm_timer
      ARM: msm: Move 8660 to DT timer
      ARM: msm: Make 8660 a DT only target
      ARM: msm: Rename board-msm8x60 to signify its DT only status
      ARM: msm: Move io mapping prototypes to common.h
      ARM: msm: Add DT support for 8960
      ARM: msm: Remove non-DT targets from 8960
      ARM: msm: Allow msm_iomap-8x60 and msm_iomap-8960 to coexist
      ARM: msm: Allow 8960 and 8660 to compile together

Wei Yongjun (1):
      ARM: msm: dma: use list_move_tail instead of list_del/list_add_tail

 .../devicetree/bindings/arm/msm/timer.txt          |  38 ++
 arch/arm/boot/dts/msm8660-surf.dts                 |  19 +-
 arch/arm/boot/dts/msm8960-cdp.dts                  |  41 ++
 arch/arm/mach-msm/Kconfig                          |  49 +-
 arch/arm/mach-msm/Makefile                         |   8 +-
 arch/arm/mach-msm/Makefile.boot                    |   3 +
 arch/arm/mach-msm/acpuclock-arm11.c                | 525 ---------------------
 arch/arm/mach-msm/acpuclock.h                      |  32 --
 arch/arm/mach-msm/board-dt-8660.c                  |  63 +++
 arch/arm/mach-msm/board-dt-8960.c                  |  49 ++
 arch/arm/mach-msm/board-halibut.c                  |   5 +-
 arch/arm/mach-msm/board-mahimahi.c                 |   1 -
 arch/arm/mach-msm/board-msm7x27.c                  | 170 -------
 arch/arm/mach-msm/board-msm7x30.c                  |   9 +-
 arch/arm/mach-msm/board-msm8960.c                  | 122 -----
 arch/arm/mach-msm/board-msm8x60.c                  | 166 -------
 arch/arm/mach-msm/board-qsd8x50.c                  |   7 +-
 arch/arm/mach-msm/board-sapphire.c                 |   1 -
 arch/arm/mach-msm/board-trout.c                    |   5 +-
 arch/arm/mach-msm/clock-pcom.c                     |  18 +-
 arch/arm/mach-msm/common.h                         |  30 ++
 arch/arm/mach-msm/devices-msm8960.c                |  85 ----
 arch/arm/mach-msm/dma.c                            |   3 +-
 arch/arm/mach-msm/idle.c                           |  49 --
 arch/arm/mach-msm/include/mach/board.h             |  13 -
 arch/arm/mach-msm/include/mach/msm_iomap-7x00.h    |   7 -
 arch/arm/mach-msm/include/mach/msm_iomap-7x30.h    |   4 -
 arch/arm/mach-msm/include/mach/msm_iomap-8960.h    |   6 +-
 arch/arm/mach-msm/include/mach/msm_iomap-8x50.h    |   4 -
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h    |  17 +-
 arch/arm/mach-msm/include/mach/msm_iomap.h         |   3 +-
 arch/arm/mach-msm/include/mach/system.h            |  19 -
 arch/arm/mach-msm/io.c                             |  32 +-
 arch/arm/mach-msm/platsmp.c                        |   8 -
 arch/arm/mach-msm/proc_comm.c                      |   1 -
 arch/arm/mach-msm/smd.c                            |   7 -
 arch/arm/mach-msm/timer.c                          | 188 ++++++--
 37 files changed, 443 insertions(+), 1364 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/msm/timer.txt
 create mode 100644 arch/arm/boot/dts/msm8960-cdp.dts
 delete mode 100644 arch/arm/mach-msm/acpuclock-arm11.c
 delete mode 100644 arch/arm/mach-msm/acpuclock.h
 create mode 100644 arch/arm/mach-msm/board-dt-8660.c
 create mode 100644 arch/arm/mach-msm/board-dt-8960.c
 delete mode 100644 arch/arm/mach-msm/board-msm7x27.c
 delete mode 100644 arch/arm/mach-msm/board-msm8960.c
 delete mode 100644 arch/arm/mach-msm/board-msm8x60.c
 create mode 100644 arch/arm/mach-msm/common.h
 delete mode 100644 arch/arm/mach-msm/devices-msm8960.c
 delete mode 100644 arch/arm/mach-msm/idle.c
 delete mode 100644 arch/arm/mach-msm/include/mach/system.h

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
