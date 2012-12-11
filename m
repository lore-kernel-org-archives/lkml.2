Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab2LKQPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 11:15:31 -0500
Received: from service87.mimecast.com ([91.220.42.44]:58991 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab2LKQPa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 11:15:30 -0500
Date: Tue, 11 Dec 2012 16:15:20 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] arm64 patches for 3.8-rc1
Message-ID: <20121211161520.GB16071@arm.com>
MIME-Version: 1.0
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 11 Dec 2012 16:15:26.0806 (UTC) FILETIME=[BB311F60:01CDD7BA]
X-MC-Unique: 112121116152808701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following arm64 patches for 3.8-rc1. Thanks.

The following changes since commit 77b67063bb6bce6d475e910d3b886a606d0d91f7:

  Linux 3.7-rc5 (2012-11-11 13:44:33 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64.git tags/arm64-for-linus

for you to fetch changes up to d19766ec52218007d45888860dd40a24bb7f6651:

  arm64: Update the MAINTAINERS entry (2012-12-11 13:58:05 +0000)

----------------------------------------------------------------
Main AArch64 changes:
- Generic execve, kernel_thread, fork/vfork/clone.
- Preparatory patches for KVM support (initialising EL2 mode for later
  installing KVM support, hypervisor stub).
- Signal handling corner case fix (alternative signal stack set up for a
  SEGV handler, which is raised in response to RLIMIT_STACK being
  reached).
- Sub-nanosecond timer error fix.

----------------------------------------------------------------
Al Viro (3):
      arm64: get rid of fork/vfork/clone wrappers
      Merge commit '6ba1bc826d160fe4f32bcb188687dcca4bdfaf3d' into arch-arm64
      arm64: compat for clock_adjtime(2) is miswired

Alexander Shiyan (1):
      ARM64: Remove incorrect Kconfig symbol HAVE_SPARSE_IRQ

Catalin Marinas (12):
      arm64: Use generic kernel_thread() implementation
      arm64: Use generic kernel_execve() implementation
      arm64: Use generic sys_execve() implementation
      Merge tag 'v3.7-rc5' into execve
      arm64: Make the user fault reporting more specific
      Merge branch 'execve' into upstream
      Merge remote-tracking branch 'viro/arch-arm64' into execve
      Merge branch 'execve' into upstream
      arm64: Include the clkdev.h generic header
      arm64: Convert empty flush_cache_{mm,page} functions to static inline
      arm64: Make !dirty ptes read-only
      arm64: Update the MAINTAINERS entry

Deepak Saxena (1):
      arm64: Force use of common clk at architecture level

Marc Zyngier (7):
      arm64: expand register mapping between AArch32 and AArch64
      arm64: add AArch32 execution modes to ptrace.h
      arm64: move vector entry macro to assembler.h
      arm64: record boot mode when entering the kernel
      arm64: add hypervisor stub
      arm64: hyp: initialize vttbr_el2 to zero
      arm64: move FP-SIMD save/restore code to a macro

Tekkaman Ninja (1):
      Documentation: Fixes a word in Documentation/arm64/memory.txt

Will Deacon (10):
      arm64: mm: update max_dma32 before calculating size of NORMAL zone
      arm64: signal: push the unwinding prologue on the signal stack
      arm64: signal: align return types for compat and native setup_return
      arm64: signal: return struct rt_sigframe from get_sigframe
      arm64: signal: let the compiler inline compat_get_sigframe
      arm64: vdso: fix clocksource mask when extracting bottom 56 bits
      arm64: vdso: check sequence counter even for coarse realtime operations
      arm64: vdso: rework __do_get_tspec register allocation and return shift
      arm64: vdso: defer shifting of nanosecond component of timespec
      arm64: generic timer: use virtual counter instead of physical at EL0

 Documentation/arm64/memory.txt        |   2 +-
 MAINTAINERS                           |   2 +
 arch/arm64/Kconfig                    |   4 +-
 arch/arm64/include/asm/Kbuild         |   1 +
 arch/arm64/include/asm/arm_generic.h  |   8 +--
 arch/arm64/include/asm/assembler.h    |   8 +++
 arch/arm64/include/asm/cacheflush.h   |  11 +++-
 arch/arm64/include/asm/fpsimdmacros.h |  64 ++++++++++++++++++++
 arch/arm64/include/asm/pgtable.h      |   2 +
 arch/arm64/include/asm/processor.h    |   5 --
 arch/arm64/include/asm/ptrace.h       |  31 +++++++++-
 arch/arm64/include/asm/syscalls.h     |  14 ++---
 arch/arm64/include/asm/unistd.h       |   1 +
 arch/arm64/include/asm/unistd32.h     |  10 ++--
 arch/arm64/include/asm/virt.h         |  54 +++++++++++++++++
 arch/arm64/kernel/Makefile            |   3 +-
 arch/arm64/kernel/entry-fpsimd.S      |  43 +-------------
 arch/arm64/kernel/entry.S             |  21 ++-----
 arch/arm64/kernel/head.S              |  33 +++++++++-
 arch/arm64/kernel/hyp-stub.S          | 109 ++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/process.c           |  83 ++++++++++----------------
 arch/arm64/kernel/signal.c            |  49 +++++++--------
 arch/arm64/kernel/signal32.c          |  20 +++----
 arch/arm64/kernel/sys.c               |  76 +-----------------------
 arch/arm64/kernel/sys32.S             |  19 ------
 arch/arm64/kernel/sys_compat.c        |  38 ++----------
 arch/arm64/kernel/vdso.c              |   2 +-
 arch/arm64/kernel/vdso/gettimeofday.S | 100 ++++++++++++++++---------------
 arch/arm64/mm/fault.c                 |  13 +++-
 arch/arm64/mm/flush.c                 |   9 ---
 arch/arm64/mm/init.c                  |   4 +-
 drivers/clocksource/arm_generic.c     |   2 +-
 32 files changed, 473 insertions(+), 368 deletions(-)
 create mode 100644 arch/arm64/include/asm/fpsimdmacros.h
 create mode 100644 arch/arm64/include/asm/virt.h
 create mode 100644 arch/arm64/kernel/hyp-stub.S

