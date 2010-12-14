Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759897Ab0LNUKu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 15:10:50 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40278
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759671Ab0LNUKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 15:10:49 -0500
Date: Tue, 14 Dec 2010 12:11:17 -0800 (PST)
Message-Id: <20101214.121117.112596216.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This fixes two bugs.

First a fix from Daniel Hellstrom that eliminates a hard-coded HZ
constant in the LEON code.

Second, fix a regression in sparc64 firmware calls.

Some kinds of firmware calls are not safe to pass buffer addresses
over 4GB, they really aren't 64-bit safe universally especially on
older sparc64 systems.

So I fixed this in two steps:

1) Remove firmware interfaces unused by the kernel right now, which is
   safer than trying to recode them to use bounce buffers or similar.

2) Add a bounce buffer for PROM console writes to ensure that the
   buffer restrictions are met.

Tested successfully by the original bug reporter.

Please pull, thanks a lot!

The following changes since commit 6313e3c21743cc88bb5bd8aa72948ee1e83937b6:

  Merge branches 'x86-fixes-for-linus', 'perf-fixes-for-linus' and 'sched-fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip (2010-12-08 06:40:59 -0800)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

Daniel Hellstrom (1):
      SPARC/LEON: removed constant timer initialization as if HZ=100, now it reflects the value of HZ

David S. Miller (9):
      sparc64: Delete prom_puts() unused.
      sparc: Remove prom_pathtoinode()
      sparc: Kill prom devops_{32,64}.c
      sparc64: Unexport prom_service_exists().
      sparc64: Delete prom_setcallback().
      sparc: Do not export prom_nb{get,put}char().
      sparc: Pass buffer pointer all the way down to prom_{get,put}char().
      sparc: Delete prom_*getchar().
      sparc: Write to prom console using indirect buffer.

 arch/sparc/include/asm/openprom.h |    2 +-
 arch/sparc/include/asm/oplib_32.h |   35 +--------------
 arch/sparc/include/asm/oplib_64.h |   46 +-------------------
 arch/sparc/kernel/leon_kernel.c   |    4 +-
 arch/sparc/prom/Makefile          |    1 -
 arch/sparc/prom/console_32.c      |   65 +++++----------------------
 arch/sparc/prom/console_64.c      |   81 ++++++----------------------------
 arch/sparc/prom/devops_32.c       |   87 -------------------------------------
 arch/sparc/prom/devops_64.c       |   67 ----------------------------
 arch/sparc/prom/misc_64.c         |   16 +------
 arch/sparc/prom/printf.c          |   35 ++++++++++++---
 arch/sparc/prom/tree_32.c         |   16 -------
 arch/sparc/prom/tree_64.c         |   18 --------
 13 files changed, 64 insertions(+), 409 deletions(-)
 delete mode 100644 arch/sparc/prom/devops_32.c
 delete mode 100644 arch/sparc/prom/devops_64.c
