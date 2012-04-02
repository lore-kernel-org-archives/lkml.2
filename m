Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab2DBRtv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 13:49:51 -0400
Received: from mail.windriver.com ([147.11.1.11]:42060 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab2DBRtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 13:49:50 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <kgdb-bugreport@lists.sourceforge.net>
Subject: [GIT PULL] KGDB/KDB regression fixes for 3.4-rc2
Date: Mon, 2 Apr 2012 12:49:13 -0500
Message-ID: <1333388953-32127-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.9.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 1ba0c1720eb0de2d0f3abf84c0b128d10af520d1:

  kdb: Add message about CONFIG_DEBUG_RODATA on failure to install breakpoint (2012-03-22 15:07:16 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/kgdb.git tags/for_linus-3.4-rc2

for you to fetch changes up to 3751d3e85cf693e10e2c47c03c8caa65e171099b:

  x86,kgdb: Fix DEBUG_RODATA limitation using text_poke() (2012-03-29 17:41:25 -0500)

----------------------------------------------------------------
KGDB/KDB regression fixes
   3.4: Fix an an Smatch warning that appeared in the 3.4 merge window
   3.0: Fix kgdb test suite with SMP for all archs without HW single stepping
2.6.36: Fix kgdb sw breakpoints with CONFIG_DEBUG_RODATA=y limitations on x86
2.6.26: Fix oops on kgdb test suite with CONFIG_DEBUG_RODATA
        Fix kgdb test suite with SMP for all archs with HW single stepping

----------------------------------------------------------------
Jason Wessel (6):
      kdb: Fix smatch warning on dbg_io_ops->is_console
      kgdbts: Fix kernel oops with CONFIG_DEBUG_RODATA
      kgdbts: (1 of 2) fix single step awareness to work correctly with SMP
      kgdbts: (2 of 2) fix single step awareness to work correctly with SMP
      kgdb,debug_core: pass the breakpoint struct instead of address and memory
      x86,kgdb: Fix DEBUG_RODATA limitation using text_poke()

 arch/x86/kernel/kgdb.c    |   60 +++++++++++++++++
 drivers/misc/kgdbts.c     |  160 ++++++++++++++++++++++++++++++++-------------
 include/linux/kgdb.h      |    7 +-
 kernel/debug/debug_core.c |   53 +++++++--------
 kernel/debug/kdb/kdb_io.c |    2 +-
 5 files changed, 204 insertions(+), 78 deletions(-)
