Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943Ab0JVU5H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 16:57:07 -0400
Received: from mail.windriver.com ([147.11.1.11]:36313 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab0JVU5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 16:57:05 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [GIT PULL] kgdb/kdb tree for 2.6.37
Date: Fri, 22 Oct 2010 15:56:20 -0500
Message-Id: <1287780991-7476-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
X-OriginalArrivalTime: 22 Oct 2010 20:56:47.0862 (UTC) FILETIME=[A4771960:01CB722B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the for_linus branch to pick up the latest updates
for kgdb/kdb.

git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_lin
us

This pull request comes a few days into the merge window because I was
waiting for the rcu tree to be merged so the debug core specific
patches created back in August could make use of the new rcu stall
detector API.

Summary of changes: 
  * Fixed the ability to dynamically register a kdb shell command from
    a kernel module
  * Exiting kgdb/kdb will reset the RCU stall detector
  * The locking algorithm for multi cpu systems was simplified to use
    2 spinlocks instead of multiple atomic counter arrays the size of
    NR_CPUS.
  * Some minor bug fixes for edge cases and a few code cleanups 

Thanks,
Jason.

---
The following changes since commit f5d9d249b9a6884daff513ef08afa43d3f7e085f:
  Linus Torvalds (1):
        Merge branch 'urgent' of git://git.kernel.org/.../brodo/pcmcia-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_linus

Dongdong Deng (2):
      debug_core: disable hw_breakpoints on all cores in kgdb_cpu_enter()
      x86,kgdb: remove unnecessary call to kgdb_correct_hw_break()

Jason Wessel (9):
      x86,kgdb: fix debugger hw breakpoint test regression in 2.6.35
      debug_core: move all watch dog syncs to a single function
      debug_core: stop rcu warnings on kernel resume
      kdb: Allow kernel loadable modules to add kdb shell functions
      kdb,ftdump: Remove reference to internal kdb include
      kdb: Fix oops in kdb_unregister
      kdb,kgdb: fix sparse fixups
      debug_core: refactor locking for master/slave cpus
      kdb,debug_core: adjust master cpu switch logic against new debug_core locking

 arch/x86/kernel/kgdb.c          |   11 ++-
 drivers/serial/kgdboc.c         |    2 +-
 include/linux/kdb.h             |   51 ++++++++++++++
 kernel/debug/debug_core.c       |  139 ++++++++++++++++++++-------------------
 kernel/debug/debug_core.h       |    1 +
 kernel/debug/kdb/kdb_debugger.c |    3 +-
 kernel/debug/kdb/kdb_io.c       |    2 +-
 kernel/debug/kdb/kdb_main.c     |   18 +++--
 kernel/debug/kdb/kdb_private.h  |   48 +-------------
 kernel/trace/trace_kdb.c        |    1 -
 10 files changed, 144 insertions(+), 132 deletions(-)
