Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823Ab0HOU26 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 16:28:58 -0400
Received: from king.tilera.com ([72.1.168.226]:38679 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656Ab0HOU25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 16:28:57 -0400
Date: Sun, 15 Aug 2010 16:28:55 -0400
Message-Id: <201008152028.o7FKSt9s017638@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL] updates to Tilera's "tile" architecture for 2.6.36
X-OriginalArrivalTime: 15 Aug 2010 20:28:56.0738 (UTC) FILETIME=[7C4ED020:01CB3CB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git

to get recent fixes for the "tile" architecture.  The changes in the tree
represent some catch-up changes to sync up with commits from other folks
(e.g. __arch_hweight, ARCH_DMA_MINALIGN, kunmap_atomic_notypecheck);
some sync-up from the Tilera internal development tree; and a few cleanup
changes that have been submitted to me by other folks.

Almost all of this material is bug fixes.  There are a couple of minor
enhancements due to the sync-up with our internal development, which is
why I'm sending this pull request while the merge window is still open.
In particular there is one change to the syscall return value ABI
(returning errors in register r1) that I'd like to get into 2.6.36 so
it will be compatible with the next release of our userspace.

The only change outside of arch/tile is the fix to add the fanotify
syscalls to include/asm-generic, which several folks have signed off on.

Thanks!
Chris Metcalf
cmetcalf@tilera.com

 arch/tile/Makefile                  |   20 +++---
 arch/tile/configs/tile_defconfig    |    1 -
 arch/tile/include/arch/abi.h        |    4 +-
 arch/tile/include/asm/atomic_32.h   |   37 ----------
 arch/tile/include/asm/backtrace.h   |    4 +-
 arch/tile/include/asm/bitops.h      |    9 ++-
 arch/tile/include/asm/cache.h       |    5 +-
 arch/tile/include/asm/highmem.h     |    2 +-
 arch/tile/include/asm/page.h        |    6 ++-
 arch/tile/include/asm/scatterlist.h |   21 ------
 arch/tile/include/asm/setup.h       |    8 ++-
 arch/tile/include/asm/siginfo.h     |    4 +
 arch/tile/include/asm/uaccess.h     |    4 +-
 arch/tile/include/hv/hypervisor.h   |    8 +-
 arch/tile/kernel/backtrace.c        |  137 +++++++++++++++++++++++++----------
 arch/tile/kernel/compat_signal.c    |    4 +-
 arch/tile/kernel/intvec_32.S        |   14 +++-
 arch/tile/kernel/proc.c             |    1 -
 arch/tile/kernel/setup.c            |    4 +-
 arch/tile/kernel/stack.c            |    8 --
 arch/tile/kernel/time.c             |   33 +++++----
 arch/tile/kernel/traps.c            |    4 +-
 arch/tile/lib/Makefile              |    4 +-
 arch/tile/lib/exports.c             |   16 +++--
 arch/tile/lib/memcpy_32.S           |   20 +----
 arch/tile/lib/memset_32.c           |   25 -------
 arch/tile/mm/fault.c                |    8 ++
 arch/tile/mm/highmem.c              |    4 +-
 arch/tile/mm/homecache.c            |    3 +
 arch/tile/mm/pgtable.c              |    1 -
 include/asm-generic/unistd.h        |    6 ++-
 31 files changed, 218 insertions(+), 207 deletions(-)
