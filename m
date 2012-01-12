Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280Ab2ALGvw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 01:51:52 -0500
Received: from linux-sh.org ([111.68.239.195]:55025 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536Ab2ALGvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 01:51:50 -0500
Date: Thu, 12 Jan 2012 15:51:45 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 3.3-rc1
Message-ID: <20120112065144.GA24051@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here goes my attempt at a merge request by way of signed tag, hopefully
I've not botched anything too terribly.

I noticed some people using 3.3 in their signed tags and others with a
single for-linus one that seems like it will be overwritten on each
subsequent merge. I've opted for the latter as presumably verification is
only of interest at the time of merging, but can switch to the former if
that's the preferred way going forward.

Ideally this should be pulled prior to the rmobile updates, which build
on top of some of the changes in here.

The following changes since commit e343a895a9f342f239c5e3c5ffc6c0b1707e6244:

  Merge tag 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost (2012-01-10 18:04:27 -0800)

are available in the git repository at:


  git://github.com/pmundt/linux-sh sh-for-linus

for you to fetch changes up to 1c1744cc7cee83b96e3a89c1b9853fc033bafb9c:

  sh: magicpanelr2: Update for parse_mtd_partitions() fallout. (2012-01-12 13:49:05 +0900)

----------------------------------------------------------------
SuperH updates for 3.3 merge window.

----------------------------------------------------------------
Guennadi Liakhovetski (5):
      sh: sh7724: use runtime PM implementation, common with arm/mach-shmobile
      sh: sh7722: use runtime PM implementation, common with arm/mach-shmobile
      sh: sh7723: use runtime PM implementation, common with arm/mach-shmobile
      sh: sh7722: fix Oops: remove empty clock entries
      sh: also without PM_RUNTIME pm_runtime.o must be built

Kuninori Morimoto (7):
      sh: sh7724.h: bugfix: remove unused clock index
      sh: sh7723.h: bugfix: remove unused clock index
      sh: clkfwk: setup clock parent from current register value
      sh: clock-sh7723: add CLKDEV_ICK_ID for cleanup
      sh: clkfwk: clock-sh7724: all div6_clks use SH_CLK_DIV6_EXT()
      sh: clkfwk: clock-sh73a0: all div6_clks use SH_CLK_DIV6_EXT()
      sh: clkfwk: sh_clk_init_parent() should be called after clk_register()

Magnus Damm (5):
      sh: extend clock struct with mapped_reg member
      sh: use ioread32/iowrite32 and mapped_reg for mstp32
      sh: use ioread32/iowrite32 and mapped_reg for div4
      sh: use ioread32/iowrite32 and mapped_reg for div6
      sh: pfc: ioremap() support

Paul Mundt (24):
      sh: Kill off remaining private runtime PM bits.
      sh: cpuidle: Migrate off of hwblk API.
      sh: hwblk: Kill off hwblk_id from pdev archdata.
      sh: hwblk: Kill off remaining bits of hwblk API.
      serial: sh-sci: Fix up SCFCR handling.
      serial: sh-sci: Support icount statistics for error cases.
      serial: sh-sci: Clarify enable_ms/break_ctl comments.
      serial: sh-sci: Fix up modem control handling.
      serial: sh-sci: Add support for loopback mode.
      serial: sh-sci: per-port modem control.
      serial: sh-sci: Avoid FIFO clear for MCE toggle.
      serial: sh-sci: Handle GPIO function requests.
      Merge branches 'common/clkfwk', 'common/pfc' and 'common/serial-rework' into sh-latest
      Merge branch 'master' of git://git.kernel.org/.../torvalds/linux into sh-latest
      Merge branch 'common/clkfwk' into sh-latest
      sh: Fix up store queue code for subsys_interface changes.
      sh: Ensure IRQs are enabled across do_notify_resume().
      sh: Remove redundant try_to_freeze() invocations.
      Merge branch 'sh/urgent' into sh-latest
      Merge branch 'sh/pm-runtime' into sh-latest
      Merge branch 'sh/hwblk' into sh-latest
      Merge branch 'sh/nommu' into sh-latest
      sh: mach-rsk: Update for parse_mtd_partitions() fallout.
      sh: magicpanelr2: Update for parse_mtd_partitions() fallout.

Phil Edworthy (1):
      sh: sh2a: Improve cache flush/invalidate functions

Shimoda, Yoshihiro (3):
      sh: modify clock-sh7757 for renesas_usbhs
      sh: add platform_device for renesas_usbhs in board-sh7757lcr
      sh: add a resource name for shdma

 arch/arm/mach-shmobile/clock-sh7372.c        |    6 +-
 arch/arm/mach-shmobile/clock-sh73a0.c        |  140 ++++++++++--
 arch/arm/mach-shmobile/include/mach/common.h |    2 +
 arch/sh/boards/board-magicpanelr2.c          |   34 +---
 arch/sh/boards/board-sh7757lcr.c             |   39 +++
 arch/sh/boards/mach-ap325rxa/setup.c         |   12 -
 arch/sh/boards/mach-ecovec24/setup.c         |   36 ---
 arch/sh/boards/mach-kfr2r09/setup.c          |   12 -
 arch/sh/boards/mach-migor/setup.c            |   12 -
 arch/sh/boards/mach-rsk/setup.c              |   43 +---
 arch/sh/boards/mach-se/7722/setup.c          |    3 -
 arch/sh/boards/mach-se/7724/setup.c          |   30 ---
 arch/sh/include/asm/device.h                 |   10 -
 arch/sh/include/asm/hwblk.h                  |   70 ------
 arch/sh/include/cpu-sh4/cpu/sh7722.h         |   13 +-
 arch/sh/include/cpu-sh4/cpu/sh7723.h         |    3 +-
 arch/sh/include/cpu-sh4/cpu/sh7724.h         |    4 +-
 arch/sh/kernel/cpu/Makefile                  |    2 +-
 arch/sh/kernel/cpu/hwblk.c                   |  159 -------------
 arch/sh/kernel/cpu/sh4/sq.c                  |    8 +-
 arch/sh/kernel/cpu/sh4a/Makefile             |    6 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7722.c       |   77 ++++---
 arch/sh/kernel/cpu/sh4a/clock-sh7723.c       |  209 +++++++----------
 arch/sh/kernel/cpu/sh4a/clock-sh7724.c       |  201 +++++++++--------
 arch/sh/kernel/cpu/sh4a/clock-sh7757.c       |    2 +-
 arch/sh/kernel/cpu/sh4a/hwblk-sh7722.c       |  106 ---------
 arch/sh/kernel/cpu/sh4a/hwblk-sh7723.c       |  117 ----------
 arch/sh/kernel/cpu/sh4a/hwblk-sh7724.c       |  121 ----------
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c       |   38 +---
 arch/sh/kernel/cpu/sh4a/setup-sh7723.c       |   39 ---
 arch/sh/kernel/cpu/sh4a/setup-sh7724.c       |   64 +-----
 arch/sh/kernel/cpu/sh4a/setup-sh7757.c       |    7 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7780.c       |    2 +
 arch/sh/kernel/cpu/sh4a/setup-sh7785.c       |    2 +
 arch/sh/kernel/cpu/sh4a/setup-sh7786.c       |    2 +-
 arch/sh/kernel/cpu/shmobile/Makefile         |    1 -
 arch/sh/kernel/cpu/shmobile/cpuidle.c        |    3 +-
 arch/sh/kernel/cpu/shmobile/pm_runtime.c     |  319 --------------------------
 arch/sh/kernel/entry-common.S                |    1 +
 arch/sh/kernel/signal_32.c                   |    4 -
 arch/sh/kernel/signal_64.c                   |    4 -
 arch/sh/kernel/time.c                        |    2 -
 arch/sh/mm/cache-sh2a.c                      |  123 +++++++---
 drivers/sh/Makefile                          |    9 +-
 drivers/sh/clk/core.c                        |    9 +-
 drivers/sh/clk/cpg.c                         |   79 +++++--
 drivers/sh/pfc.c                             |  137 +++++++++--
 drivers/tty/serial/sh-sci.c                  |  183 +++++++++++++--
 include/linux/serial_sci.h                   |   22 ++
 include/linux/sh_clk.h                       |   10 +-
 include/linux/sh_pfc.h                       |   11 +
 51 files changed, 897 insertions(+), 1651 deletions(-)
 delete mode 100644 arch/sh/include/asm/hwblk.h
 delete mode 100644 arch/sh/kernel/cpu/hwblk.c
 delete mode 100644 arch/sh/kernel/cpu/sh4a/hwblk-sh7722.c
 delete mode 100644 arch/sh/kernel/cpu/sh4a/hwblk-sh7723.c
 delete mode 100644 arch/sh/kernel/cpu/sh4a/hwblk-sh7724.c
 delete mode 100644 arch/sh/kernel/cpu/shmobile/pm_runtime.c
