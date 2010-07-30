Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760752Ab0G3TV1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 15:21:27 -0400
Received: from mail.windriver.com ([147.11.1.11]:33840 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756782Ab0G3TSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 15:18:04 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu
Subject: [PATCH 0/15] kgdb,kdb: proposed merge set for 2.6.36
Date: Fri, 30 Jul 2010 14:17:21 -0500
Message-Id: <1280517456-1167-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
X-OriginalArrivalTime: 30 Jul 2010 19:17:39.0486 (UTC) FILETIME=[E041F3E0:01CB301B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are the patches for kgdb we have so far which have passed
regression testing during the 2.6.35 cycle. 

The key new features here are:

  * ftdump command for kdb
    - dumps the ftrace buffer for all cpus or an indivdual cpu
  * Individual register read / read in kdb (x86, mips, arm)
  * Generic plumbing for gdb serial register packets 'p' and 'P'
    - implmentations for x86, mips and arm
  * A new console poll driver for the sunhv serial console (sparc)
  * ARM kgdb makes use of die notifiers
  * Optimize gdbserial response packets contaning "thread:"

The remainders of the patches contain miscelaenous cleanups.
optimation for the gdb serial packets which contain the "thread:"

Jason.

---
The following changes since commit a2dccdb2055abeb8a7ce8e45e5f83de9c980a00c:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git390.marist.edu/pub/scm/linux-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git kgdb-next

Andi Kleen (1):
      KGDB: Remove set but unused newPC

Andy Shevchenko (1):
      kgdb: remove custom hex_to_bin()implementation

Jason Wessel (12):
      gdbstub: Optimize kgdb's "thread:" response for the gdb serial protocol
      kgdb,kdb: individual register set and and get API
      x86,kgdb: Individual register get/set for x86
      mips,kgdb: Individual register get/set for mips
      arm,kgdb: Individual register get/set for arm
      gdbstub,x86: Implement gdbserial 'p' and 'P' packets
      gdbstub: do not directly use dbg_reg_def[] in gdb_cmd_reg_set()
      arm,kgdb: Add ability to trap into debugger on notify_die
      ftrace,kdb: Extend kdb to be able to dump the ftrace buffer
      ftrace,kdb: Allow dumping a specific cpu's buffer with ftdump
      sunhv,kgdboc: Add sunhv console poll hooks for kgdboc
      mm,kdb,kgdb: Add a debug reference for the kdb kmap usage

Michal Simek (1):
      powerpc: Replace hardcoded offset by BREAK_INSTR_SIZE

 arch/arm/include/asm/kgdb.h  |    6 +-
 arch/arm/kernel/kgdb.c       |  124 +++++++++++++++++---------
 arch/mips/include/asm/kgdb.h |   19 ++--
 arch/mips/kernel/kgdb.c      |  203 ++++++++++++++++++++++++++++++------------
 arch/powerpc/kernel/kgdb.c   |    2 +-
 arch/x86/include/asm/kgdb.h  |   20 +++--
 arch/x86/kernel/kgdb.c       |  171 +++++++++++++++++------------------
 drivers/serial/sunhv.c       |   51 +++++++++++
 include/linux/kgdb.h         |   15 +++-
 kernel/debug/gdbstub.c       |  189 ++++++++++++++++++++++++++++-----------
 kernel/debug/kdb/kdb_main.c  |  132 +++++++++++++++++++++++++---
 kernel/trace/Makefile        |    3 +
 kernel/trace/trace.c         |   43 +++++-----
 kernel/trace/trace.h         |   19 ++++
 kernel/trace/trace_kdb.c     |  136 ++++++++++++++++++++++++++++
 mm/highmem.c                 |    7 ++
 16 files changed, 840 insertions(+), 300 deletions(-)
 create mode 100644 kernel/trace/trace_kdb.c
