Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912Ab2KIRBP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 12:01:15 -0500
Received: from service87.mimecast.com ([91.220.42.44]:33380 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab2KIRBK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 12:01:10 -0500
Date: Fri, 9 Nov 2012 16:56:00 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] arm64 fixes for 3.7
Message-ID: <20121109165559.GG5998@arm.com>
MIME-Version: 1.0
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 09 Nov 2012 16:56:00.0615 (UTC) FILETIME=[18A2E770:01CDBE9B]
X-MC-Unique: 112110916560203201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the arm64 fixes below. The following changes since commit
3d70f8c617a436c7146ecb81df2265b4626dfe89:

  Linux 3.7-rc4 (2012-11-04 11:07:39 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64.git tags/arm64-fixes

for you to fetch changes up to f483a853b0b932a1d75eb27a1dcbd732862260db:

  arm64: mm: fix booting on systems with no memory below 4GB (2012-11-08 16:06:21 +0000)

Thanks.

----------------------------------------------------------------
AArch64 kernel fixes:
- correct argument type (pgprot_t) when calling __ioremap()
- PCI_IOBASE virtual address change
- use architected event for CPU cycle counter
- fix ELF core dumping
- select CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION
- missing completion for secondary CPU boot
- booting on systems with all memory beyond 4GB

----------------------------------------------------------------
Catalin Marinas (3):
      arm64: Use pgprot_t as the last argument when invoking __ioremap()
      arm64: Move PCI_IOBASE closer to MODULES_VADDR
      Merge tag 'v3.7-rc4' into upstream-master

Will Deacon (5):
      arm64: perf: use architected event for CPU cycle counter
      arm64: elf: fix core dumping definitions for GP and FP registers
      arm64: compat: select CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION
      arm64: smp: add missing completion for secondary boot
      arm64: mm: fix booting on systems with no memory below 4GB

 Documentation/arm64/memory.txt     | 12 ++++++------
 arch/arm64/Kconfig                 |  1 +
 arch/arm64/include/asm/elf.h       |  5 +----
 arch/arm64/include/asm/fpsimd.h    |  5 ++---
 arch/arm64/include/asm/io.h        |  8 ++++----
 arch/arm64/include/asm/processor.h |  2 ++
 arch/arm64/include/asm/unistd.h    |  1 -
 arch/arm64/kernel/perf_event.c     | 10 ++--------
 arch/arm64/kernel/process.c        | 18 ------------------
 arch/arm64/kernel/smp.c            |  3 +--
 arch/arm64/mm/init.c               |  2 +-
 11 files changed, 20 insertions(+), 47 deletions(-)

