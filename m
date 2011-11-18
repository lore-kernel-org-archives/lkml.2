Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab1KRD3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 22:29:20 -0500
Received: from gate.crashing.org ([63.228.1.57]:42859 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755107Ab1KRD3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 22:29:19 -0500
Message-ID: <1321586945.2847.5.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Fri, 18 Nov 2011 14:29:05 +1100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are a few fixes remaining for powerpc in 3.2. Some tiny build
breakage, a couple of nasty ps3 bugs fixes, other very small and
quite obvious fixes and and a long standing issue with atomics &
ordering for which we have to use stronger barriers than we do to
be correct.

Cheers,
Ben.

The following changes since commit a9098b372606a15745cdeb012de4ee91c0df82c4:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6 (2011-11-17 15:28:54 -0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Al Viro (4):
      powerpc: Fix build breakage in jump_label.c
      carma-fpga: Missed switch from of_register_platform_driver()
      powerpc/fsl_udc_core: Fix dumb typo
      powerpc/fsl: MCU_MPC8349EMITX wants I2C built-in, modular won't do...

Anton Blanchard (2):
      powerpc: panic if we can't instantiate RTAS
      powerpc: Copy down exception vectors after feature fixups

Benjamin Herrenschmidt (1):
      powerpc: Fix atomic_xxx_return barrier semantics

Geoff Levand (2):
      powerpc/ps3: Fix lost SMP IPIs
      powerpc/ps3: Fix SMP lockdep boot warning

Kevin Hao (1):
      powerpc/trace: Add a dummy stack frame for trace_hardirqs_off

Kumar Gala (3):
      powerpc: Revert show_regs() define for readability
      powerpc: Remove extraneous CONFIG_PPC_ADV_DEBUG_REGS define
      powerpc/book3e-64: Fix debug support for userspace

Kyle Moffett (1):
      powerpc: Remove buggy 9-year-old test for binutils < 2.12.1

Michael Neuling (1):
      powerpc: Add hvcall.h include to book3s_hv.c

Suzuki Poulose (1):
      powerpc/4xx: Fix typos in kexec config dependencies

Will Deacon (1):
      powerpc/signal32: Fix sigset_t conversion when copying to user

 arch/powerpc/Kconfig                    |    2 +-
 arch/powerpc/Makefile                   |    6 ---
 arch/powerpc/include/asm/atomic.h       |   48 ++++++++++++------------
 arch/powerpc/include/asm/bitops.h       |   12 +++---
 arch/powerpc/include/asm/futex.h        |    7 ++-
 arch/powerpc/include/asm/reg_booke.h    |    2 +-
 arch/powerpc/include/asm/sections.h     |    2 +-
 arch/powerpc/include/asm/synch.h        |    9 +++-
 arch/powerpc/kernel/entry_32.S          |   15 +++++++
 arch/powerpc/kernel/jump_label.c        |    2 +
 arch/powerpc/kernel/kvm.c               |    1 -
 arch/powerpc/kernel/misc_32.S           |    2 +-
 arch/powerpc/kernel/process.c           |   24 +-----------
 arch/powerpc/kernel/prom_init.c         |    6 +--
 arch/powerpc/kernel/setup_32.c          |    2 +
 arch/powerpc/kernel/setup_64.c          |    1 +
 arch/powerpc/kernel/signal_32.c         |    2 +-
 arch/powerpc/kernel/traps.c             |    2 -
 arch/powerpc/kvm/book3s_hv.c            |    1 +
 arch/powerpc/lib/feature-fixups.c       |   23 +++++++++++
 arch/powerpc/platforms/Kconfig          |    2 +-
 arch/powerpc/platforms/ps3/interrupt.c  |   23 +++++++++++-
 arch/powerpc/platforms/ps3/platform.h   |    1 +
 arch/powerpc/platforms/ps3/smp.c        |   62 ++++++++++++++++---------------
 drivers/misc/carma/carma-fpga-program.c |    9 ++--
 drivers/misc/carma/carma-fpga.c         |    9 ++--
 drivers/usb/gadget/fsl_udc_core.c       |    2 +-
 27 files changed, 158 insertions(+), 119 deletions(-)


