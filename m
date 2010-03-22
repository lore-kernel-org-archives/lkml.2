Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047Ab0CVTTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 15:19:55 -0400
Received: from mail.windriver.com ([147.11.1.11]:36499 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755875Ab0CVTSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 15:18:20 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [GIT PULL] kgdb fixes for 2.6.34-rc2
Date: Mon, 22 Mar 2010 14:17:21 -0500
Message-Id: <1269285449-1424-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
X-OriginalArrivalTime: 22 Mar 2010 19:17:35.0471 (UTC) FILETIME=[5429CFF0:01CAC9F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the kgdb-fixes for 2.6.34.  

git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git kgdb-fixes

Summary:
  * The first 2 patches are the gdbstub and debug core split from the kdb tree
  * The rest are the fixes cherry picked from the kdb pull request

The previous kdb pull will require a rebase if you accept the kgdb
fixes because there were patch splits that occurred to make this patch
set.

Thanks,
Jason.

---
The following changes since commit 220bf991b0366cc50a94feede3d7341fa5710ee4:
  Linus Torvalds (1):
        Linux 2.6.34-rc2

are available in the git repository at:

Jason Wessel (8):
      Move kernel/kgdb.c to kernel/debug/debug_core.c
      Separate the gdbstub from the debug core
      kgdb: eliminate kgdb_wait(), all cpus enter the same way
      kgdb: have ebin2mem call probe_kernel_write once
      kgdb,debug_core: Use atomic operators which use barriers
      kgdbts,sh: Add in breakpoint pc offset for superh
      debug_core: Turn off tracing while in the debugger
      MAINTAINERS: update kgdb, and debug_core info

 MAINTAINERS               |    5 +-
 drivers/misc/kgdbts.c     |    6 +
 include/linux/kgdb.h      |    1 +
 kernel/Makefile           |    2 +-
 kernel/debug/Makefile     |    5 +
 kernel/debug/debug_core.c |  848 ++++++++++++++++++++++
 kernel/debug/debug_core.h |   55 ++
 kernel/debug/gdbstub.c    |  934 ++++++++++++++++++++++++
 kernel/kgdb.c             | 1763 ---------------------------------------------
 9 files changed, 1853 insertions(+), 1766 deletions(-)
 create mode 100644 kernel/debug/Makefile
 create mode 100644 kernel/debug/debug_core.c
 create mode 100644 kernel/debug/debug_core.h
 create mode 100644 kernel/debug/gdbstub.c
 delete mode 100644 kernel/kgdb.c
