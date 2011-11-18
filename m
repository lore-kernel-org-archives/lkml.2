Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab1KRTWJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 14:22:09 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:43249 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175Ab1KRTWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 14:22:07 -0500
Date: Fri, 18 Nov 2011 14:22:04 -0500 (EST)
Message-Id: <20111118.142204.540812327639462900.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 18 Nov 2011 11:22:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Several bug fixes:

1) Make syscall restart properly save and restore the first argument
   register across possible ptrace modifications.

2) Implement sparc's io_remap_pfn_range() in terms of remap_pfn_range().
   A ton of divergance has occured over time and it makes no sense to
   have a completely seperate loop for what amounts to being a very
   minor optimization on sparc64.

3) Because modules can use things like pgprot_noncached() and friends,
   we have to process the sun4v code patching sections upon module
   load on sparc64.  This fixes crashes with infiniband on Niagara
   machines.

4) Missing header include, from Ben Hutchings.

Please pull, thanks a lot!

The following changes since commit b6844523839779030430ff28f036f83e2a3f43e6:

  Merge branch 'stable/for-linus-fixes-3.2' of git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen (2011-11-18 13:18:07 -0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc.git master

Ben Hutchings (1):
      sparc: sigutil: Include <linux/errno.h>

David S. Miller (4):
      sparc: Fix handling of orig_i0 wrt. debugging when restarting syscalls.
      sparc: Stash orig_i0 into %g6 instead of %g2
      sparc: Kill custom io_remap_pfn_range().
      sparc64: Patch sun4v code sequences properly on module load.

 arch/sparc/include/asm/pgtable_32.h |   20 ++++-
 arch/sparc/include/asm/pgtable_64.h |   20 ++++-
 arch/sparc/kernel/entry.h           |    7 ++
 arch/sparc/kernel/module.c          |   27 ++++++
 arch/sparc/kernel/setup_64.c        |   48 ++++++----
 arch/sparc/kernel/signal32.c        |   18 ++--
 arch/sparc/kernel/signal_32.c       |   30 +++++-
 arch/sparc/kernel/signal_64.c       |   42 ++++++---
 arch/sparc/kernel/sigutil_64.c      |    1 +
 arch/sparc/mm/Makefile              |    1 -
 arch/sparc/mm/generic_32.c          |   99 ---------------------
 arch/sparc/mm/generic_64.c          |  165 -----------------------------------
 12 files changed, 159 insertions(+), 319 deletions(-)
 delete mode 100644 arch/sparc/mm/generic_32.c
 delete mode 100644 arch/sparc/mm/generic_64.c

   
