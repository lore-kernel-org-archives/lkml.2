Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab2JTQG1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 12:06:27 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38370 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752585Ab2JTQGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 12:06:24 -0400
Date: Sat, 20 Oct 2012 17:06:14 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] arm64: Fixes for 3.7
Message-ID: <20121020160614.GA7674@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the arm64-fixes tag below. Thanks.

The following changes since commit ddffeb8c4d0331609ef2581d84de4d763607bd37:

  Linux 3.7-rc1 (2012-10-14 14:41:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64.git tags/arm64-fixes

for you to fetch changes up to aeed41a9371ee02257b608eb06a9058507a7d0f4:

  arm64: fix alignment padding in assembly code (2012-10-20 11:12:01 +0100)

----------------------------------------------------------------
Main changes:
- AArch64 Linux compilation fixes following 3.7-rc1 changes
  (MODULES_USE_ELF_RELA, update_vsyscall() prototype)
- Unnecessary register setting in start_thread() (thanks to Al Viro)
- ptrace fixes

----------------------------------------------------------------
Catalin Marinas (4):
      arm64: Select MODULES_USE_ELF_RELA
      arm64: Fix the update_vsyscall() prototype
      arm64: Ignore memory blocks below PHYS_OFFSET
      arm64: No need to set the x0-x2 registers in start_thread()

Marc Zyngier (1):
      arm64: fix alignment padding in assembly code

Sachin Kamat (1):
      arm64: Remove duplicate inclusion of mmu_context.h in smp.c

Will Deacon (2):
      arm64: ptrace: make structure padding explicit for debug registers
      arm64: ptrace: use HW_BREAKPOINT_EMPTY type for disabled breakpoints

 arch/arm64/Kconfig                   |  1 +
 arch/arm64/include/asm/Kbuild        |  1 -
 arch/arm64/include/asm/linkage.h     |  7 ++++
 arch/arm64/include/asm/processor.h   | 10 -----
 arch/arm64/include/uapi/asm/ptrace.h |  3 +-
 arch/arm64/kernel/ptrace.c           | 73 +++++++++++++++++++++++++-----------
 arch/arm64/kernel/setup.c            | 12 ++++++
 arch/arm64/kernel/smp.c              |  1 -
 arch/arm64/kernel/vdso.c             | 20 +++++-----
 9 files changed, 83 insertions(+), 45 deletions(-)
 create mode 100644 arch/arm64/include/asm/linkage.h
