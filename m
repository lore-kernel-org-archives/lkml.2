Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab1HELZg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 07:25:36 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:48528 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914Ab1HELZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 07:25:35 -0400
Date: Fri, 05 Aug 2011 04:25:32 -0700 (PDT)
Message-Id: <20110805.042532.69526399598685175.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 05 Aug 2011 04:25:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just a few more Niagara T3 refinements as well as several
bug fixes, including:

1) On sun4v we need to access the TSB using physical addresses otherwise
   we can read/write different data than what the hypervisor and/or
   the hardware TSB walker does.

2) sparc32 __atomic_add_unless return value needs correction, from
   Josip Rodin.

3) Sun4v cpu mondo queue sizes could be way too large, and we'd fail
   to allocate them because the page allocation order would exceed
   MAX_ORDER.  Set a sane cap to fix the problem.

4) Sam Ravnborg's patch to use kbuild-generic.

5) Use the hypervisor interface to set the 'reboot-cmd' variable so
   that rebooting into the correct image works even if the service
   processor is dead or in degraded mode.

Please pull, thanks a lot!

The following changes since commit 140d0b2108faebc77c6523296e211e509cb9f5f9:

  Do 'shm_init_ns()' in an early pure_initcall (2011-08-04 19:35:59 -1000)

are available in the git repository at:
  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc.git master

David S. Miller (9):
      sparc: Sanitize cpu feature detection and reporting.
      sparc: Minor tweaks to Niagara page copy/clear.
      sparc: Use popc if possible for hweight routines.
      sparc: Use hweight64() in popc emulation.
      sparc: Add some missing hypervisor API groups.
      sparc: Set reboot-cmd using reboot data hypervisor call if available.
      sparc: Use popc when possible for ffs/__ffs/ffz.
      sparc: Access kernel TSB using physical addressing when possible.
      sparc: Size mondo queues more sanely.

Josip Rodin (1):
      sparc: Fix __atomic_add_unless() return value.

Sam Ravnborg (1):
      sparc: use kbuild-generic support for true asm-generic header files

 arch/sparc/include/asm/Kbuild       |    5 +
 arch/sparc/include/asm/bitops_64.h  |   49 ++--------
 arch/sparc/include/asm/div64.h      |    1 -
 arch/sparc/include/asm/elf_64.h     |   65 ++++++-------
 arch/sparc/include/asm/hypervisor.h |   13 +++
 arch/sparc/include/asm/irq_regs.h   |    1 -
 arch/sparc/include/asm/local.h      |    6 -
 arch/sparc/include/asm/local64.h    |    1 -
 arch/sparc/include/asm/tsb.h        |   51 +++++-----
 arch/sparc/kernel/cpu.c             |    1 +
 arch/sparc/kernel/ds.c              |   30 +++++-
 arch/sparc/kernel/entry.h           |   14 +++
 arch/sparc/kernel/head_64.S         |    2 +-
 arch/sparc/kernel/hvapi.c           |    6 +
 arch/sparc/kernel/hvcalls.S         |    7 ++
 arch/sparc/kernel/kernel.h          |   15 +++
 arch/sparc/kernel/ktlb.S            |   24 +++---
 arch/sparc/kernel/mdesc.c           |   30 +++++--
 arch/sparc/kernel/setup_64.c        |  186 +++++++++++++++++++++++++++++++++++
 arch/sparc/kernel/sparc_ksyms_64.c  |   11 ++
 arch/sparc/kernel/sstate.c          |    9 +--
 arch/sparc/kernel/unaligned_64.c    |   15 +--
 arch/sparc/kernel/vmlinux.lds.S     |   21 ++++-
 arch/sparc/lib/Makefile             |    4 +-
 arch/sparc/lib/NG2page.S            |   61 ------------
 arch/sparc/lib/NGpage.S             |  114 ++++++++++++++-------
 arch/sparc/lib/atomic32.c           |    2 +-
 arch/sparc/lib/ffs.S                |   84 ++++++++++++++++
 arch/sparc/lib/hweight.S            |   51 ++++++++++
 arch/sparc/mm/init_64.c             |   40 +++++++-
 30 files changed, 661 insertions(+), 258 deletions(-)
 delete mode 100644 arch/sparc/include/asm/div64.h
 delete mode 100644 arch/sparc/include/asm/irq_regs.h
 delete mode 100644 arch/sparc/include/asm/local.h
 delete mode 100644 arch/sparc/include/asm/local64.h
 delete mode 100644 arch/sparc/lib/NG2page.S
 create mode 100644 arch/sparc/lib/ffs.S
 create mode 100644 arch/sparc/lib/hweight.S
