Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965577Ab2EXVcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 17:32:46 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:43485 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965535Ab2EXVcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 17:32:43 -0400
Date: Thu, 24 May 2012 17:32:39 -0400 (EDT)
Message-Id: <20120524.173239.1413482842035447647.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 24 May 2012 14:32:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This has the generic strncpy_from_user() implementation architectures
can now use, which we've been developing on linux-arch over the past
few days.

For good measure I ran both a 32-bit and a 64-bit glibc testsuite
run, and the latter of which pointed out an adjustment I needed to
make to sparc's user_addr_max() definition.  Linus, you were right,
STACK_TOP was not the right thing to use, even on sparc itself :-)

>From Sam Ravnborg, we have a conversion of sparc32 over to the common
alloc_thread_info_node(), since the aspect which originally blocked
our doing so (sun4c) has been removed.

Please pull, thanks a lot.

The following changes since commit 72c04af9a2d57b7945cf3de8e71461bd80695d50:

  fbdev: sh_mobile_lcdc: Don't confuse line size with pitch (2012-05-21 20:59:32 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc.git master

for you to fetch changes up to c5389831cda3b38a56606a348a537a1332f2d729:

  sparc: Fix user_addr_max() definition. (2012-05-24 13:41:58 -0700)

----------------------------------------------------------------
David S. Miller (6):
      sparc: Add full proper error handling to strncpy_from_user().
      sparc: Optimize strncpy_from_user() zero byte search.
      sparc: Increase portability of strncpy_from_user() implementation.
      kernel: Move REPEAT_BYTE definition into linux/kernel.h
      lib: Sparc's strncpy_from_user is generic enough, move under lib/
      sparc: Fix user_addr_max() definition.

Sam Ravnborg (1):
      sparc32: use the common implementation of alloc_thread_info_node()

 arch/sparc/Kconfig                      |    2 +-
 arch/sparc/include/asm/processor_64.h   |    4 +-
 arch/sparc/include/asm/thread_info_32.h |   11 +--
 arch/sparc/include/asm/uaccess.h        |    6 ++
 arch/sparc/include/asm/uaccess_32.h     |   10 ---
 arch/sparc/include/asm/uaccess_64.h     |    4 -
 arch/sparc/lib/Makefile                 |    2 +-
 arch/sparc/lib/ksyms.c                  |    3 -
 arch/sparc/lib/strncpy_from_user_32.S   |   47 ----------
 arch/sparc/lib/strncpy_from_user_64.S   |  133 ----------------------------
 arch/sparc/lib/usercopy.c               |    1 +
 arch/sparc/mm/srmmu.c                   |   27 ------
 arch/x86/include/asm/word-at-a-time.h   |    4 +-
 fs/namei.c                              |    1 +
 include/linux/kernel.h                  |    2 +
 lib/Kconfig                             |    3 +
 lib/Makefile                            |    2 +
 lib/strncpy_from_user.c                 |  146 +++++++++++++++++++++++++++++++
 18 files changed, 170 insertions(+), 238 deletions(-)
 delete mode 100644 arch/sparc/lib/strncpy_from_user_32.S
 delete mode 100644 arch/sparc/lib/strncpy_from_user_64.S
 create mode 100644 lib/strncpy_from_user.c
