Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab1AFWsD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:48:03 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39278
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752589Ab1AFWsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:48:00 -0500
Date: Thu, 06 Jan 2011 14:48:32 -0800 (PST)
Message-Id: <20110106.144832.189697659.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Not a whole lot here, mainly:

1) sparc 32-bit LEON updates from Daniel Hellstrom.

2) PROM cleanups and consolidation of the 32-bit and 64-bit
   piggyback programs into one unified code base, from Sam
   Ravnborg.

3) An atyfb on sparc bootup regression fix, which will be sent
   to -stable.

Please pull, thanks a lot.

The following changes since commit cb600d2f83c854ec3d6660063e4466431999489b:

  Merge branch 'x86-mm-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip (2011-01-06 11:12:17 -0800)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-next-2.6.git master

Daniel Hellstrom (7):
      SPARC/LEON: find IRQCTRL and Timer via OF-Tree, instead of hardcoded.
      SPARC/LEON: added support for IRQAMP IRQ Controller
      LEON: added raw AMBA vendor/device number to find TIMER, IRQCTRL
      SPARC/LEON: added support for selecting Timer Core and Timer within core
      SPARC/LEON: avoid AMBAPP name duplicates in openprom fs when REG is missing
      APBUART: added raw AMBA vendor/device number to match against.
      Added support for ampopts in APBUART driver. Used in AMP systems.

David S. Miller (3):
      Merge master.kernel.org:/.../davem/sparc-2.6
      sparc: Eliminate prom_stdin.
      atyfb: Fix bootup hangs on sparc64.

Julian Calaby (1):
      sparc: prom: Sanitize return value from prom_nbputchar()

Sam Ravnborg (15):
      sparc: drop prom/devmap.c
      sparc: drop prom/palloc.c
      sparc: remove unused prom cpu functions
      sparc: remove unused prom tree functions
      sparc: fix sparse warnings in arch/sparc/prom for 32 bit build
      sparc: refactor piggy_32.c
      sparc: use trapbase in setup_arch
      sparc: use _start for the start entry (like 64 bit does)
      sparc: additional comments to piggyback_32.c
      sparc: remove obsolete ELF support in piggyback_32.c
      sparc: add $BITS to piggyback arguments
      sparc: fix tftpboot.img for sparc64 on little-endian host
      sparc: rename piggyback_32 to piggyback
      sparc: unify strip command in boot/Makefile
      sparc: update copyright in piggyback.c

 arch/sparc/boot/Makefile           |   28 ++---
 arch/sparc/boot/piggyback.c        |  272 ++++++++++++++++++++++++++++++++++++
 arch/sparc/boot/piggyback_32.c     |  137 ------------------
 arch/sparc/boot/piggyback_64.c     |  110 ---------------
 arch/sparc/include/asm/leon.h      |   12 ++
 arch/sparc/include/asm/leon_amba.h |    6 +-
 arch/sparc/include/asm/openprom.h  |    2 +-
 arch/sparc/include/asm/oplib_32.h  |   83 +----------
 arch/sparc/include/asm/oplib_64.h  |   50 +------
 arch/sparc/kernel/head_32.S        |    3 +-
 arch/sparc/kernel/leon_kernel.c    |  114 +++++++++++++---
 arch/sparc/kernel/prom_32.c        |   27 +++-
 arch/sparc/kernel/setup_32.c       |    3 +-
 arch/sparc/mm/sun4c.c              |    8 +-
 arch/sparc/prom/Makefile           |    3 -
 arch/sparc/prom/bootstr_32.c       |    3 +-
 arch/sparc/prom/console_32.c       |   68 ++-------
 arch/sparc/prom/console_64.c       |   83 ++---------
 arch/sparc/prom/devmap.c           |   53 -------
 arch/sparc/prom/devops_32.c        |   87 ------------
 arch/sparc/prom/devops_64.c        |   67 ---------
 arch/sparc/prom/init_64.c          |    3 +-
 arch/sparc/prom/misc_32.c          |    2 +-
 arch/sparc/prom/misc_64.c          |   16 +--
 arch/sparc/prom/mp.c               |   78 ----------
 arch/sparc/prom/palloc.c           |   43 ------
 arch/sparc/prom/printf.c           |   35 ++++-
 arch/sparc/prom/ranges.c           |    6 +-
 arch/sparc/prom/tree_32.c          |   66 +--------
 arch/sparc/prom/tree_64.c          |   18 ---
 drivers/serial/apbuart.c           |    8 +-
 drivers/video/aty/atyfb_base.c     |   27 +---
 32 files changed, 514 insertions(+), 1007 deletions(-)
 create mode 100644 arch/sparc/boot/piggyback.c
 delete mode 100644 arch/sparc/boot/piggyback_32.c
 delete mode 100644 arch/sparc/boot/piggyback_64.c
 delete mode 100644 arch/sparc/prom/devmap.c
 delete mode 100644 arch/sparc/prom/devops_32.c
 delete mode 100644 arch/sparc/prom/devops_64.c
 delete mode 100644 arch/sparc/prom/palloc.c
