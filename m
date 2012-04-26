Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759569Ab2DZXfn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 19:35:43 -0400
Received: from mail.windriver.com ([147.11.1.11]:38806 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab2DZXfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 19:35:41 -0400
Date: Thu, 26 Apr 2012 19:35:38 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] build fixes for less mainstream architectures
Message-ID: <20120426233537.GA23799@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

These are fixes for frv(1), blackfin(2), powerpc(1) and xtensa(4).

Fortunately the touches are nearly all specific to files just used
by the arch in question.   The two touches to shared/common files 
[kernel/irq/debug.h and drivers/pci/Makefile] are trivial to assess
as no risk to anyone.

Half of them relate to xtensa directly.  It was only when I fixed the
last xtensa issue that I realized that the arch has been broken for
a significant time, and isn't a specific v3.4 regression.  So if you
wanted, we could leave xtensa lying bleeding in the street for a couple
more weeks and queue those for 3.5.  But given they are no risk to
anyone outside of xtensa, I figured to just leave them in.

If you are OK with taking the xtensa fixes, then please pull to get:

-one last implicit include uncovered by system.h that is in a file
 specific to just one powerpc defconfig.  (I'd sync'd with BenH).

-fix an oversight in the PCI makefile where shared code wasn't being
 compiled for ARCH=frv

-fix a missing include for GPIO in blackfin framebuffer.

-audit and tag endif in blackfin ezkit board file, in order to find
 and fix the misplaced endif masking a block of code.

-fix irq/debug.h choice of temporary macro names to be more internal
 so they don't conflict with names used by xtensa.

-fix a reference to an undeclared local var in xtensa's signal.c

-fix an implicit bug.h usage in xtensa's asm/io.h uncovered by my
 removing bug.h from kernel.h

-fix xtensa to properly indicate it is using asm-generic/hardirq.h
 in order to resolve the link error - undefined ack_bad_irq

The xtensa still fails final link as my latest binutils does something
evil when ld forward-relocates unlikely() blocks, but in theory people
who have older/valid toolchains could now use the thing.

Thanks,
Paul.
---

The following changes since commit e816b57a337ea3b755de72bec38c10c864f23015:

  Linux 3.4-rc3 (2012-04-15 18:28:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulg/linux.git for-v3.4-rc5

for you to fetch changes up to 8e12a038f88e819c878e5697ff681cb08bcebb08:

  xtensa: fix build fail on undefined ack_bad_irq (2012-04-26 18:35:32 -0400)

----------------------------------------------------------------
Paul Gortmaker (8):
      powerpc: fix system.h fallout in sysdev/scom.c [chroma_defconfig]
      xtensa: fix build failure in xtensa/kernel/signal.c
      xtensa: fix build error in xtensa/include/asm/io.h
      irq: hide debug macros so they don't collide with others.
      pci: frv architecture needs generic setup-bus infrastructure
      blackfin: fix compile error in bfin-lq035q1-fb.c
      blackfin: fix ifdef fustercluck in mach-bf538/boards/ezkit.c
      xtensa: fix build fail on undefined ack_bad_irq

 arch/blackfin/mach-bf538/boards/ezkit.c |   53 +++++++++++++++----------------
 arch/powerpc/sysdev/scom.c              |    1 +
 arch/xtensa/include/asm/hardirq.h       |    3 --
 arch/xtensa/include/asm/io.h            |    1 +
 arch/xtensa/kernel/signal.c             |    1 +
 drivers/pci/Makefile                    |    1 +
 drivers/video/bfin-lq035q1-fb.c         |    1 +
 kernel/irq/debug.h                      |   38 +++++++++++-----------
 8 files changed, 50 insertions(+), 49 deletions(-)

