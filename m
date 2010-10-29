Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761602Ab0J2Som (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 14:44:42 -0400
Received: from mail.windriver.com ([147.11.1.11]:58541 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761560Ab0J2Sog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 14:44:36 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [GIT PULL] kgdb/kdb tree for 2.6.37
Date: Fri, 29 Oct 2010 13:43:34 -0500
Message-Id: <1288377821-24520-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
X-OriginalArrivalTime: 29 Oct 2010 18:43:47.0535 (UTC) FILETIME=[38B615F0:01CB7799]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the for_linus branch to pick up the final updates
for the 2.6.37 merge window for kgdb/kdb.

git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_linus

This second pull request for the merge window contains mainly
regression fixes and cleanups.  The 2 non fix/cleanup things in this
patch series are:

   * Added a kdb_hello module for the samples/ dir which shows how
     to dynamically add kdb shell commands

   * Converted the arch specific powerpc kgdb stub to the individual
     register access, joining x86, arm, and mips

Thanks,
Jason.

---
The following changes since commit 12ba8d1e9262ce81a695795410bd9ee5c9407ba1:
  Al Viro (1):
        fix braino in fs: do not assign default i_ino in new_inode

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_linus

Dongdong Deng (3):
      debug_core,x86,blackfin: Clean up hw debug disable API
      kgdbts: prevent re-entry to kgdbts before it unregisters
      kgdb,ppc: Individual register get/set for ppc

Jason Wessel (3):
      kdb: Add kdb kernel module sample
      kdb: fix per_cpu command to remove supress mask
      kdb: Fix early debugging crash regression

Rabin Vincent (1):
      kgdb,arm: fix register dump

 Documentation/DocBook/kgdb.tmpl |   13 +++-
 arch/arm/include/asm/kgdb.h     |    5 +-
 arch/arm/kernel/kgdb.c          |    2 +-
 arch/blackfin/kernel/kgdb.c     |    3 +-
 arch/powerpc/include/asm/kgdb.h |    1 +
 arch/powerpc/kernel/kgdb.c      |  188 ++++++++++++++++++++++++++-------------
 arch/x86/kernel/kgdb.c          |    3 +-
 drivers/misc/kgdbts.c           |   16 +---
 include/linux/kgdb.h            |   13 +--
 kernel/debug/debug_core.c       |   16 +---
 kernel/debug/kdb/kdb_main.c     |   48 +++--------
 samples/Kconfig                 |    7 ++
 samples/Makefile                |    2 +-
 samples/kdb/Makefile            |    1 +
 samples/kdb/kdb_hello.c         |   60 ++++++++++++
 15 files changed, 235 insertions(+), 143 deletions(-)
 create mode 100644 samples/kdb/Makefile
 create mode 100644 samples/kdb/kdb_hello.c
