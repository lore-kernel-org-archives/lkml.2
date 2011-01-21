Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab1AUEuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 23:50:50 -0500
Received: from gate.crashing.org ([63.228.1.57]:35409 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827Ab1AUEus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 23:50:48 -0500
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 Jan 2011 15:50:02 +1100
Message-ID: <1295585402.2148.274.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here's a bunch of powerpc stuff for you to pull. There's a whole series from
Anton which is in large part trivial cleanups, but it's all obvious enough
stuff or worthy enough fixes that I decided to not wait until the next merge
window (besides it's from Anton :-)

The rest is generally minor fixes. The two simple_write_to_buffer changes
from Akinobu were around for a while (and Andrew had picked them up already),
I just happen to have "missed" them in my collection for the previous batch.

Cheers,
Ben.

The following changes since commit 12fcdba1b7ae8b25696433f420b775aeb556d89b:

  Merge branch 'x86-fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip (2011-01-19 20:27:25 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Akinobu Mita (2):
      powerpc/spufs: Use simple_write_to_buffer
      powerpc/rtas_flash: Use simple_read_from_buffer

Anton Blanchard (19):
      powerpc/kexec: Move all ppc_md kexec function pointers together
      powerpc/kexec: Remove ppc_md.machine_kexec_cleanup
      powerpc/kexec: Remove ppc_md.machine_kexec
      powerpc/kdump: Remove ppc_md.machine_crash_shutdown
      powerpc/kexec: Don't initialise kexec hooks to default handlers
      powerpc/kexec: Remove empty ppc_md.machine_kexec_prepare
      powerpc/kdump: Move crash_kexec_stop_spus to kdump crash handler
      powerpc/kdump: Disable ftrace during kexec
      powerpc: Print 32 bits of DSISR in show_regs
      powerpc: Don't force MSR_RI in machine_check_exception
      powerpc: Never halt RTAS error logging after receiving an unrecoverable machine check
      powerpc: Remove duplicate debugger hook in machine_check_exception
      powerpc: Don't silently handle machine checks from userspace
      powerpc: Rework pseries machine check handler
      powerpc: Fix corruption when grabbing FWNMI data
      powerpc: Check RTAS extended log flag before checking length
      powerpc: machine_check_generic is wrong on 64bit
      powerpc: Disable mcount tracers in pseries defconfig
      powerpc: Enable 64kB pages and 1024 threads in pseries config

Ben Hutchings (1):
      powerpc/boot/dts: Install dts from the right directory

Benjamin Herrenschmidt (1):
      Merge remote branch 'kumar/next' into merge

Ilya Yanok (1):
      powerpc/mpc8308: fix USB DR controller initialization

Li Yang (1):
      powerpc/85xx: add e500 HID1 bit definition

Michael Ellerman (1):
      powerpc: Ensure the else case of feature sections will fit

Nishanth Aravamudan (1):
      powerpc/pseries: Add BNX2=m to defconfig

Scott Wood (1):
      powerpc/mpic: Fix mask/unmask timeout message

Shaohui Xie (1):
      powerpc/fsl_rio: Fix non-standard HID1 register access

Steven Rostedt (2):
      powerpc/ppc64/tracing: Add stack frame to calls of trace_hardirqs_on/off
      powerpc/ppc32/tracing: Add stack frame to calls of trace_hardirqs_on/off

Tejun Heo (1):
      powerpc/cell: Use system_wq in cpufreq_spudemand

Timur Tabi (2):
      powerpc/85xx: fix compatible properties of the P1022DS DMA nodes used for audio
      powerpc: fix warning when compiling immap_qe.h

roel kluin (1):
      powerpc/macintosh: Fix wrong test in fan_{read,write}_reg()

 arch/powerpc/boot/Makefile                      |    2 +-
 arch/powerpc/boot/dts/mpc8308rdb.dts            |    2 +-
 arch/powerpc/boot/dts/p1022ds.dts               |    4 +-
 arch/powerpc/configs/pseries_defconfig          |    7 +-
 arch/powerpc/include/asm/feature-fixups.h       |   27 ++++---
 arch/powerpc/include/asm/immap_qe.h             |   21 ++++--
 arch/powerpc/include/asm/irqflags.h             |   40 +++++++--
 arch/powerpc/include/asm/machdep.h              |   18 +----
 arch/powerpc/include/asm/reg.h                  |    2 +
 arch/powerpc/include/asm/reg_booke.h            |   14 +++
 arch/powerpc/include/asm/spu.h                  |    8 --
 arch/powerpc/kernel/cpu_setup_fsl_booke.S       |    6 ++
 arch/powerpc/kernel/cputable.c                  |   23 -----
 arch/powerpc/kernel/crash.c                     |   72 +----------------
 arch/powerpc/kernel/entry_32.S                  |   11 +++
 arch/powerpc/kernel/machine_kexec.c             |   19 ++--
 arch/powerpc/kernel/process.c                   |    2 +-
 arch/powerpc/kernel/rtas_flash.c                |   53 ++-----------
 arch/powerpc/kernel/rtasd.c                     |    2 +-
 arch/powerpc/kernel/time.c                      |   25 +++++-
 arch/powerpc/kernel/traps.c                     |   12 +---
 arch/powerpc/lib/feature-fixups-test.S          |   19 ++++
 arch/powerpc/platforms/83xx/mpc83xx.h           |    2 +
 arch/powerpc/platforms/83xx/usb.c               |   21 ++++-
 arch/powerpc/platforms/cell/cpufreq_spudemand.c |   20 +----
 arch/powerpc/platforms/cell/qpace_setup.c       |    5 -
 arch/powerpc/platforms/cell/spu_base.c          |   70 ++++++++++++++++
 arch/powerpc/platforms/cell/spufs/file.c        |   27 ++-----
 arch/powerpc/platforms/embedded6xx/gamecube.c   |   11 ---
 arch/powerpc/platforms/embedded6xx/wii.c        |   11 ---
 arch/powerpc/platforms/pseries/kexec.c          |   10 --
 arch/powerpc/platforms/pseries/ras.c            |  102 +++++++++++++++-------
 arch/powerpc/sysdev/fsl_rio.c                   |    2 -
 arch/powerpc/sysdev/mpic.c                      |    6 +-
 drivers/macintosh/therm_pm72.c                  |    4 +-
 35 files changed, 334 insertions(+), 346 deletions(-)


