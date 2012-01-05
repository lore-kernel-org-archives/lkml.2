Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507Ab2AEO4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 09:56:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933Ab2AEO4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 09:56:36 -0500
Date: Thu, 5 Jan 2012 16:58:36 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] use generic pci_iomap on all architectures
Message-ID: <20120105145836.GA2751@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the following changes for 3.3, thanks a lot!

These changes have been on linux-next for a while now.
They touch a lot of arches and have interdependencies, so merging
separately seems to make sense, I think.

The following changes since commit 805a6af8dba5dfdd35ec35dc52ec0122400b2610:

  Linux 3.2 (2012-01-04 15:55:44 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git for-linus

for you to fetch changes up to 193a667fba76b3df482cbf865228e26ee246e889:

  alpha: drop pci_iomap/pci_iounmap from pci-noop.c (2011-12-04 16:00:19 +0200)

----------------------------------------------------------------
lib: use generic pci_iomap on all architectures

Many architectures don't want to pull in iomap.c,
so they ended up duplicating pci_iomap from that file.
That function isn't trivial, and we are going to modify it
https://lkml.org/lkml/2011/11/14/183
so the duplication hurts.

This reduces the scope of the problem significantly,
by moving pci_iomap to a separate file and
referencing that from all architectures.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Michael S. Tsirkin (16):
      lib: move GENERIC_IOMAP to lib/Kconfig
      lib: add GENERIC_PCI_IOMAP
      alpha: switch to GENERIC_PCI_IOMAP
      arm: switch to GENERIC_PCI_IOMAP
      microblaze: switch to GENERIC_PCI_IOMAP
      mips: switch to GENERIC_PCI_IOMAP
      parisc: switch to GENERIC_PCI_IOMAP
      powerpc: switch to GENERIC_PCI_IOMAP
      sh: switch to GENERIC_PCI_IOMAP
      sparc: switch to GENERIC_PCI_IOMAP
      tile: don't panic on iomap
      tile: switch to GENERIC_PCI_IOMAP
      frv: switch to GENERIC_PCI_IOMAP
      mn10300: add missing __iomap markers
      mn10300: switch to GENERIC_PCI_IOMAP
      alpha: drop pci_iomap/pci_iounmap from pci-noop.c

 arch/alpha/Kconfig                    |    5 +---
 arch/alpha/kernel/pci-noop.c          |   12 --------
 arch/alpha/kernel/pci.c               |   26 +-----------------
 arch/arm/Kconfig                      |    1 +
 arch/arm/include/asm/io.h             |    2 +-
 arch/arm/mm/iomap.c                   |   21 --------------
 arch/cris/Kconfig                     |    5 +---
 arch/frv/Kconfig                      |    1 +
 arch/frv/include/asm/io.h             |    2 +-
 arch/frv/mb93090-mb00/Makefile        |    2 +-
 arch/frv/mb93090-mb00/pci-iomap.c     |   29 --------------------
 arch/hexagon/Kconfig                  |    4 +--
 arch/ia64/Kconfig                     |    5 +---
 arch/m68k/Kconfig                     |    4 +--
 arch/microblaze/Kconfig               |    1 +
 arch/microblaze/pci/iomap.c           |   19 -------------
 arch/mips/Kconfig                     |    1 +
 arch/mips/lib/iomap-pci.c             |   26 ------------------
 arch/mn10300/Kconfig                  |    1 +
 arch/mn10300/include/asm/io.h         |   17 +++++------
 arch/mn10300/unit-asb2305/Makefile    |    2 +-
 arch/mn10300/unit-asb2305/pci-iomap.c |   31 ---------------------
 arch/openrisc/Kconfig                 |    3 --
 arch/parisc/Kconfig                   |    1 +
 arch/parisc/lib/iomap.c               |   23 ---------------
 arch/powerpc/Kconfig                  |    1 +
 arch/powerpc/kernel/iomap.c           |   19 -------------
 arch/powerpc/platforms/Kconfig        |    3 --
 arch/score/Kconfig                    |    4 +--
 arch/sh/Kconfig                       |    4 +--
 arch/sh/drivers/pci/pci.c             |   23 ---------------
 arch/sparc/Kconfig                    |    1 +
 arch/sparc/include/asm/io_32.h        |    2 +-
 arch/sparc/include/asm/io_64.h        |    2 +-
 arch/sparc/lib/iomap.c                |   23 ---------------
 arch/tile/Kconfig                     |    1 +
 arch/tile/include/asm/io.h            |    3 +-
 arch/tile/include/asm/pci.h           |    2 +-
 arch/tile/kernel/pci.c                |   21 --------------
 arch/unicore32/Kconfig                |    4 +--
 arch/x86/Kconfig                      |    4 +--
 include/asm-generic/io.h              |    4 +-
 include/asm-generic/iomap.h           |    9 ++----
 include/asm-generic/pci_iomap.h       |   25 +++++++++++++++++
 lib/Kconfig                           |    7 +++++
 lib/Makefile                          |    1 +
 lib/iomap.c                           |   38 +------------------------
 lib/pci_iomap.c                       |   48 +++++++++++++++++++++++++++++++++
 48 files changed, 124 insertions(+), 369 deletions(-)
 delete mode 100644 arch/frv/mb93090-mb00/pci-iomap.c
 delete mode 100644 arch/mn10300/unit-asb2305/pci-iomap.c
 create mode 100644 include/asm-generic/pci_iomap.h
 create mode 100644 lib/pci_iomap.c
