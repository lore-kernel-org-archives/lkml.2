Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279Ab2CWQYr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 12:24:47 -0400
Received: from mail.windriver.com ([147.11.1.11]:58259 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236Ab2CWQYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 12:24:46 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <kgdb-bugreport@lists.sourceforge.net>
Subject: [GIT PULL] KGDB/KDB updates for the 3.4 merge window
Date: Fri, 23 Mar 2012 11:24:19 -0500
Message-ID: <1332519859-9306-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.9.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit c16fa4f2ad19908a47c63d8fa436a1178438c7e7:

  Linux 3.3 (2012-03-18 16:15:34 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/kgdb.git tags/for_linus-3.4-rc1

for you to fetch changes up to 1ba0c1720eb0de2d0f3abf84c0b128d10af520d1:

  kdb: Add message about CONFIG_DEBUG_RODATA on failure to install breakpoint (2012-03-22 15:07:16 -0500)

----------------------------------------------------------------
Fixes:
- Fix KDB keyboard repeat scan codes and leaked keyboard events
- Fix kernel crash with kdb_printf() for users who compile new kdb_printf()'s
  in early code
- Return all segment registers to gdb on x86_64
Features:
- KDB/KGDB hook the reboot notifier and end user can control if it stops,
  detaches or does nothing (updated docs as well)
- Notify users who use CONFIG_DEBUG_RODATA to use hw breakpoints

----------------------------------------------------------------
Andrei Warkentin (1):
      KDB: Fix usability issues relating to the 'enter' key.

Jan Kiszka (2):
      kgdb: x86: Return all segment registers also in 64-bit mode
      kgdb: Respect that flush op is optional

Jason Wessel (3):
      kgdb,debug-core,gdbstub: Hook the reboot notifier for debugger detach
      kgdb,debug_core: add the ability to control the reboot notifier
      kdb: Add message about CONFIG_DEBUG_RODATA on failure to install breakpoint

Tim Bird (1):
      kdb: Avoid using dbg_io_ops until it is initialized

 Documentation/DocBook/kgdb.tmpl |   17 +++++++
 arch/x86/include/asm/kgdb.h     |   10 +++--
 arch/x86/kernel/kgdb.c          |    6 ++-
 kernel/debug/debug_core.c       |   33 ++++++++++++++
 kernel/debug/gdbstub.c          |   10 ++++-
 kernel/debug/kdb/kdb_bp.c       |    7 +++
 kernel/debug/kdb/kdb_io.c       |    2 +-
 kernel/debug/kdb/kdb_keyboard.c |   95 ++++++++++++++++++++++++++++++---------
 kernel/debug/kdb/kdb_main.c     |    3 ++
 kernel/debug/kdb/kdb_private.h  |    7 +++
 10 files changed, 161 insertions(+), 29 deletions(-)
