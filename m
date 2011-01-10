Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276Ab1AJT7K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 14:59:10 -0500
Received: from brigitte.telenet-ops.be ([195.130.137.66]:41646 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab1AJT7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 14:59:07 -0500
Date: Mon, 10 Jan 2011 20:58:59 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Greg Ungerer <gerg@uclinux.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>
Subject: [git pull] m68k updates for 2.6.38
Message-ID: <alpine.DEB.2.00.1101082222060.25612@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus,

The following changes since commit 3c0eee3fe6a3a1c745379547c7e7c904aa64f6d5:
  Linus Torvalds (1):
        Linux 2.6.37

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus
  git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus

The m68knommu changes have been acked by Greg Ungerer.

Al Viro (16):
      m68k: Resetting sa_handler in local copy of k_sigaction is pointless
      m68k: Switch to saner sigsuspend()
      m68k: Simplify the singlestepping handling in signals
      m68k: Don't lose state if sigframe setup fails
      m68k: If we fail to set sigframe up, just leave regs alone...
      m68k: Fix stack mangling logics in sigreturn
      m68k: Missing syscall_trace() on sigreturn
      m68k: Check __get_user()/__put_user() return value
      m68knommu: Don't bother with SA_ONESHOT
      m68knommu: Switch to saner sigsuspend
      m68knommu: Handle multiple pending signals
      m68knommu: Don't lose state if sigframe setup fails
      m68knommu: f_pcr has been gone since headers' merge
      m68knommu: Equivalent of "m68k: handle new gcc's"
      m68knommu: signal.c __user annotations
      m68knommu: Need to check __get_user()/__put_user() result

Geert Uytterhoeven (1):
      m68k/sun3: Kill pte_unmap() warnings

 arch/m68k/include/asm/sun3_pgtable.h     |    5 +-
 arch/m68k/include/asm/thread_info.h      |    1 +
 arch/m68k/include/asm/unistd.h           |    1 +
 arch/m68k/kernel/entry.S                 |   30 +---
 arch/m68k/kernel/signal.c                |  314 +++++++++++++-----------------
 arch/m68knommu/kernel/entry.S            |   16 --
 arch/m68knommu/kernel/signal.c           |  188 ++++++++----------
 arch/m68knommu/platform/68328/entry.S    |    7 +-
 arch/m68knommu/platform/68360/entry.S    |    7 +-
 arch/m68knommu/platform/coldfire/entry.S |    5 +-
 10 files changed, 231 insertions(+), 343 deletions(-)

Thanks for pulling!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
