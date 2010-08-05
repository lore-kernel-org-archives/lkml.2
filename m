Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760664Ab0HEOim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:38:42 -0400
Received: from mail.windriver.com ([147.11.1.11]:41166 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760589Ab0HEOid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 10:38:33 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [GIT PULL] kgdb,kdb for 2.6.36 (1 of 2)
Date: Thu,  5 Aug 2010 09:37:41 -0500
Message-Id: <1281019078-6636-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
X-OriginalArrivalTime: 05 Aug 2010 14:38:11.0261 (UTC) FILETIME=[D4185ED0:01CB34AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the for_linus branch which contains all the core
kgdb and kdb changes intended for the 2.6.36 kernel.

git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_lin
us

The key new features here are:

  * ftdump command for kdb
    - dumps the ftrace buffer for all cpus or an individual cpu
  * Individual register read / write in kdb (x86, mips, arm)
  * Generic plumbing for gdb serial register packets 'p' and 'P'
    - implementations for x86, mips and arm
  * ARM kgdb makes use of die notifiers
  * Optimize gdbserial response packets containing "thread:"

The remainder of the patches contain miscellaneous cleanups.

Jason.

---
Andi Kleen (1):
      KGDB: Remove set but unused newPC

Andy Shevchenko (1):
      kgdb: remove custom hex_to_bin()implementation

Dongdong Deng (1):
      kgdb,x86: use macro HBP_NUM to replace magic number 4

Jason Wessel (13):
      gdbstub: Optimize kgdb's "thread:" response for the gdb serial protocol
      kgdb,kdb: individual register set and and get API
      kgdb,x86: Individual register get/set for x86
      kgdb,mips: Individual register get/set for mips
      kgdb,arm: Individual register get/set for arm
      gdbstub: Implement gdbserial 'p' and 'P' packets
      gdbstub: do not directly use dbg_reg_def[] in gdb_cmd_reg_set()
      arm,kgdb: Add ability to trap into debugger on notify_die
      ftrace,kdb: Extend kdb to be able to dump the ftrace buffer
      ftrace,kdb: Allow dumping a specific cpu's buffer with ftdump
      mm,kdb,kgdb: Add a debug reference for the kdb kmap usage
      kgdb,mips: remove unused kgdb_cpu_doing_single_step operations
      debug_core,kdb: fix crash when arch does not have single step

Michal Simek (1):
      kgdb,powerpc: Replace hardcoded offset by BREAK_INSTR_SIZE

 arch/arm/include/asm/kgdb.h  |    6 +-
 arch/arm/kernel/kgdb.c       |  124 ++++++++++++++++---------
 arch/mips/include/asm/kgdb.h |   19 ++--
 arch/mips/kernel/kgdb.c      |  211 +++++++++++++++++++++++++++++-------------
 arch/powerpc/kernel/kgdb.c   |    2 +-
 arch/x86/include/asm/kgdb.h  |   20 ++--
 arch/x86/kernel/kgdb.c       |  189 ++++++++++++++++++-------------------
 include/linux/kgdb.h         |   15 +++-
 kernel/debug/debug_core.c    |    2 +
 kernel/debug/gdbstub.c       |  189 +++++++++++++++++++++++++++-----------
 kernel/debug/kdb/kdb_main.c  |  132 ++++++++++++++++++++++++---
 kernel/trace/Makefile        |    3 +
 kernel/trace/trace.c         |   43 +++++----
 kernel/trace/trace.h         |   19 ++++
 kernel/trace/trace_kdb.c     |  136 +++++++++++++++++++++++++++
 mm/highmem.c                 |    7 ++
 16 files changed, 801 insertions(+), 316 deletions(-)
 create mode 100644 kernel/trace/trace_kdb.c
