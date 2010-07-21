Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643Ab0GUEZZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:25:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55021
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750904Ab0GUEZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:25:23 -0400
Date: Tue, 20 Jul 2010 21:25:39 -0700 (PDT)
Message-Id: <20100720.212539.94888874.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] SPARC
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Couple sparc fixes that have piled up over the past few week:

1) L1_CACHE_ALIGN macro unnecessary, from FUJITA Tomonori

2) _FP_FROM_INT() math-emu off-by-one bug that hits sparc and
   other math-emu using platforms.  From Mikael Pettersson.

3) Add missing DWARF register lookup to perf.

4) When console= is explicitly specified for a serial console,
   don't try to override with firmware provided settings.

5) Use after free in sunsu driver.

6) maybe_change_configuration() perf event code uses wrong %pcr
   setting, notices by Peter Z.

7) Fix build failure in some configs, from Dongdong Deng.

Please pull, thanks a lot!

The following changes since commit e0959371b4aaddb9b986019d5cfef93f9801d0ff:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client (2010-07-20 16:27:58 -0700)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (8):
      sparc32: Kill none_mask, it's bogus.
      sunserial: Don't call add_preferred_console() when console= is specified.
      sunsu: Fix use after free in su_remove().
      sparc64: Update defconfig.
      sparc64: Fix maybe_change_configuration() PCR setting.
      Merge branch 'master' of /home/davem/src/GIT/linux-2.6/
      MAINTAINERS: Add SBUS driver path to sparc entry.
      perf: Add DWARF register lookup for sparc

Dongdong Deng (1):
      sparc64: fix the build error due to smp_kgdb_capture_client()

FUJITA Tomonori (1):
      sparc: remove homegrown L1_CACHE_ALIGN macro

Joe Perches (1):
      drivers/sbus: Remove unnecessary casts of private_data

Julia Lawall (1):
      arch/sparc/kernel: Eliminate what looks like a NULL pointer dereference

Mikael Pettersson (1):
      math-emu: correct test for downshifting fraction in _FP_FROM_INT()

 MAINTAINERS                             |    1 +
 arch/sparc/configs/sparc64_defconfig    |   49 ++++++++++++++++++++++---------
 arch/sparc/include/asm/cache.h          |    1 -
 arch/sparc/include/asm/pgtable_32.h     |    5 +--
 arch/sparc/kernel/perf_event.c          |    1 +
 arch/sparc/kernel/sun4d_irq.c           |    2 +-
 arch/sparc/kernel/ttable.S              |    2 +-
 arch/sparc/mm/srmmu.c                   |    2 -
 arch/sparc/mm/sun4c.c                   |    3 --
 drivers/sbus/char/openprom.c            |    4 +-
 drivers/serial/suncore.c                |    4 ++-
 drivers/serial/sunsu.c                  |   13 ++++++--
 include/math-emu/op-common.h            |    2 +-
 tools/perf/arch/sparc/Makefile          |    4 ++
 tools/perf/arch/sparc/util/dwarf-regs.c |   43 +++++++++++++++++++++++++++
 15 files changed, 103 insertions(+), 33 deletions(-)
 create mode 100644 tools/perf/arch/sparc/Makefile
 create mode 100644 tools/perf/arch/sparc/util/dwarf-regs.c
