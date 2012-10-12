Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933551Ab2JLN53 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 09:57:29 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53223 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932996Ab2JLN52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 09:57:28 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <kgdb-bugreport@lists.sourceforge.net>
Subject: [GIT PULL] KGDB/KDB fixes for 3.7
Date: Fri, 12 Oct 2012 08:57:11 -0500
Message-ID: <1350050231-19461-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the kgdb tree's usual minor fixes/improvements. 

git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/kgdb.git tags/for_linus-3.7

Thanks,
Jason.

-----------------------------------------------------------------
The following changes since commit a0d271cbfed1dd50278c6b06bead3d00ba0a88f9:

  Linux 3.6 (2012-09-30 16:47:46 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/kgdb.git tags/for_linus-3.7

for you to fetch changes up to f2f0945e356daef87cdb01c0302801fb11cf382a:

  tty/console: fix warnings in drivers/tty/serial/kgdboc.c (2012-10-12 06:37:36 -0500)

----------------------------------------------------------------
KGDB/KDB fixes and cleanups
 Cleanups
   Clean up compile warnings in kgdboc.c and x86/kernel/kgdb.c
   Add module event hooks for simplified debugging with gdb
 Fixes
   Fix kdb to stop paging with 'q' on bta and dmesg
   Fix for data that scrolls off the vga console due to line wrapping
     when using the kdb pager
 New
   The debug core registers for kernel module events which allows a
     kernel aware gdb to automatically load symbols and break on entry
     to a kernel module
   Allow kgdboc=kdb to setup kdb on the vga console

----------------------------------------------------------------
Arnd Bergmann (1):
      tty/console: fix warnings in drivers/tty/serial/kgdboc.c

Jason Wessel (6):
      kgdb: Add module event hooks
      mips,kgdb: fix recursive page fault with CONFIG_KPROBES
      kgdb,x86: fix warning about unused variable
      kgdboc: Accept either kbd or kdb to activate the vga + keyboard kdb shell
      kdb: Fix dmesg/bta scroll to quit with 'q'
      kdb,vt_console: Fix missed data due to pager overruns

 arch/mips/kernel/kgdb.c     |    9 +++++++++
 arch/x86/kernel/kgdb.c      |    2 ++
 drivers/tty/serial/kgdboc.c |    3 ++-
 drivers/tty/vt/vt.c         |   13 +++++++++++++
 include/linux/console.h     |   10 ++++++++--
 kernel/debug/debug_core.c   |   18 ++++++++++++++++++
 kernel/debug/kdb/kdb_bt.c   |    2 ++
 kernel/debug/kdb/kdb_io.c   |   33 ++++++++++++++++++++++++++++-----
 kernel/debug/kdb/kdb_main.c |    2 ++
 9 files changed, 84 insertions(+), 8 deletions(-)
