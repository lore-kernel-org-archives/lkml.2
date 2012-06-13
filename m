Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626Ab2FMH5n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 03:57:43 -0400
Received: from linux-sh.org ([111.68.239.195]:47893 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770Ab2FMH5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 03:57:41 -0400
Date: Wed, 13 Jun 2012 16:57:38 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh fixes for 3.5-rc3
Message-ID: <20120613075737.GA27673@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 94fa83c424321189ca24fb6cb4c0d224cdedc72d:

  Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux (2012-06-12 18:48:17 +0300)

are available in the git repository at:


  git://github.com/pmundt/linux-sh sh-for-linus

for you to fetch changes up to 380622e9ff56201f9c3c1f153d1ca0a24324a1d4:

  Merge branches 'sh/urgent', 'sh/core', 'sh/clockevents', 'sh/asm-generic' and 'sh/trivial' into sh-fixes-for-linus (2012-06-13 12:01:33 +0900)

----------------------------------------------------------------

SuperH fixes for 3.5-rc3

----------------------------------------------------------------
Geert Uytterhoeven (1):
      sh: Setup CROSS_COMPILE at the top

Laurent Pinchart (2):
      serial: sh-sci: Fix probe error paths
      serial: sh-sci: Make probe fail for ports that exceed the maximum count

Paul Bolle (1):
      sh: Kill off last dead UBC header

Paul Mundt (13):
      sh: arch/sh/kernel/process.c needs asm/fpu.h for unlazy_fpu().
      sh64: Fix up fallout from generic init_task conversion.
      sh: convert to kbuild asm-generic support.
      bug.h: need linux/kernel.h for TAINT_WARN.
      clocksource: sh_cmt: Convert timer lock to raw spinlock.
      clocksource: sh_mtu2: Convert timer lock to raw spinlock.
      clocksource: sh_tmu: Convert timer lock to raw spinlock.
      clocksource: sh_tmu: Use clockevents_config_and_register().
      sh: switch to generic strncpy_from_user().
      sh: use the new generic strnlen_user() function
      sh: Fix up link time defsym warnings.
      sh: Kill off additional asm-generic wrappers.
      Merge branches 'sh/urgent', 'sh/core', 'sh/clockevents', 'sh/asm-generic' and 'sh/trivial' into sh-fixes-for-linus

 arch/sh/Kconfig                         |    2 +
 arch/sh/Makefile                        |   16 +++---
 arch/sh/include/asm/Kbuild              |   34 +++++++++++++
 arch/sh/include/asm/bitsperlong.h       |    1 -
 arch/sh/include/asm/cputime.h           |    6 --
 arch/sh/include/asm/current.h           |    1 -
 arch/sh/include/asm/delay.h             |    1 -
 arch/sh/include/asm/div64.h             |    1 -
 arch/sh/include/asm/emergency-restart.h |    6 --
 arch/sh/include/asm/errno.h             |    6 --
 arch/sh/include/asm/fcntl.h             |    1 -
 arch/sh/include/asm/ioctl.h             |    1 -
 arch/sh/include/asm/ipcbuf.h            |    1 -
 arch/sh/include/asm/irq_regs.h          |    1 -
 arch/sh/include/asm/kvm_para.h          |    1 -
 arch/sh/include/asm/local.h             |    7 ---
 arch/sh/include/asm/local64.h           |    1 -
 arch/sh/include/asm/mman.h              |    1 -
 arch/sh/include/asm/msgbuf.h            |    1 -
 arch/sh/include/asm/param.h             |    1 -
 arch/sh/include/asm/parport.h           |    1 -
 arch/sh/include/asm/percpu.h            |    6 --
 arch/sh/include/asm/poll.h              |    1 -
 arch/sh/include/asm/resource.h          |    6 --
 arch/sh/include/asm/scatterlist.h       |    6 --
 arch/sh/include/asm/sembuf.h            |    1 -
 arch/sh/include/asm/serial.h            |    1 -
 arch/sh/include/asm/shmbuf.h            |    1 -
 arch/sh/include/asm/siginfo.h           |    6 --
 arch/sh/include/asm/sizes.h             |    1 -
 arch/sh/include/asm/socket.h            |    1 -
 arch/sh/include/asm/statfs.h            |    6 --
 arch/sh/include/asm/termbits.h          |    1 -
 arch/sh/include/asm/termios.h           |    1 -
 arch/sh/include/asm/uaccess.h           |   75 +++-------------------------
 arch/sh/include/asm/uaccess_32.h        |   75 ----------------------------
 arch/sh/include/asm/uaccess_64.h        |    4 --
 arch/sh/include/asm/ucontext.h          |    1 -
 arch/sh/include/asm/word-at-a-time.h    |   53 ++++++++++++++++++++
 arch/sh/include/asm/xor.h               |    1 -
 arch/sh/include/cpu-sh2a/cpu/ubc.h      |   28 -----------
 arch/sh/kernel/cpu/sh5/entry.S          |   82 -------------------------------
 arch/sh/kernel/process.c                |    1 +
 arch/sh/kernel/process_64.c             |    1 +
 arch/sh/kernel/sh_ksyms_64.c            |    2 -
 drivers/clocksource/sh_cmt.c            |   26 +++++-----
 drivers/clocksource/sh_mtu2.c           |    6 +-
 drivers/clocksource/sh_tmu.c            |   16 ++----
 drivers/tty/serial/sh-sci.c             |   38 +++++++++-----
 include/asm-generic/bug.h               |    1 +
 50 files changed, 153 insertions(+), 386 deletions(-)
 delete mode 100644 arch/sh/include/asm/bitsperlong.h
 delete mode 100644 arch/sh/include/asm/cputime.h
 delete mode 100644 arch/sh/include/asm/current.h
 delete mode 100644 arch/sh/include/asm/delay.h
 delete mode 100644 arch/sh/include/asm/div64.h
 delete mode 100644 arch/sh/include/asm/emergency-restart.h
 delete mode 100644 arch/sh/include/asm/errno.h
 delete mode 100644 arch/sh/include/asm/fcntl.h
 delete mode 100644 arch/sh/include/asm/ioctl.h
 delete mode 100644 arch/sh/include/asm/ipcbuf.h
 delete mode 100644 arch/sh/include/asm/irq_regs.h
 delete mode 100644 arch/sh/include/asm/kvm_para.h
 delete mode 100644 arch/sh/include/asm/local.h
 delete mode 100644 arch/sh/include/asm/local64.h
 delete mode 100644 arch/sh/include/asm/mman.h
 delete mode 100644 arch/sh/include/asm/msgbuf.h
 delete mode 100644 arch/sh/include/asm/param.h
 delete mode 100644 arch/sh/include/asm/parport.h
 delete mode 100644 arch/sh/include/asm/percpu.h
 delete mode 100644 arch/sh/include/asm/poll.h
 delete mode 100644 arch/sh/include/asm/resource.h
 delete mode 100644 arch/sh/include/asm/scatterlist.h
 delete mode 100644 arch/sh/include/asm/sembuf.h
 delete mode 100644 arch/sh/include/asm/serial.h
 delete mode 100644 arch/sh/include/asm/shmbuf.h
 delete mode 100644 arch/sh/include/asm/siginfo.h
 delete mode 100644 arch/sh/include/asm/sizes.h
 delete mode 100644 arch/sh/include/asm/socket.h
 delete mode 100644 arch/sh/include/asm/statfs.h
 delete mode 100644 arch/sh/include/asm/termbits.h
 delete mode 100644 arch/sh/include/asm/termios.h
 delete mode 100644 arch/sh/include/asm/ucontext.h
 create mode 100644 arch/sh/include/asm/word-at-a-time.h
 delete mode 100644 arch/sh/include/asm/xor.h
 delete mode 100644 arch/sh/include/cpu-sh2a/cpu/ubc.h
