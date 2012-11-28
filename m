Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275Ab2K1TvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 14:51:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38782 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754963Ab2K1Tu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 14:50:56 -0500
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mario Gzuk <mariogzuk@technikz.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 0/8] RFC: Remove 386 support
Date: Wed, 28 Nov 2012 11:50:22 -0800
Message-Id: <1354132230-21854-1-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

According to kernel bugzilla 44931:

    https://bugzilla.kernel.org/show_bug.cgi?id=44931

... the Linux kernel hasn't actually been compiling for 386 for three
releases now.  I have verified that it doesn't, because the 386
fallback code for not having cmpxchg doesn't actually build.

Given that, I thought I'd refresh my patchset for completely removing
386 support and am inviting comments.

The code savings aren't huge, just under 400 lines of code, but this
is all code that very few if any people still care about.

Note that I have no inclination to remove support for 486.  486 and
clones are widely used in embedded applications and there is enough
traffic about them that I am quite sure people do still care about
some versions of those.

Comments appreciated.

 arch/x86/Kconfig                  | 11 ++----
 arch/x86/Kconfig.cpu              | 73 +++++++++++----------------------------
 arch/x86/Makefile_32.cpu          |  1 -
 arch/x86/include/asm/atomic.h     | 16 ---------
 arch/x86/include/asm/cmpxchg_32.h | 55 -----------------------------
 arch/x86/include/asm/cpufeature.h |  6 ----
 arch/x86/include/asm/futex.h      | 12 -------
 arch/x86/include/asm/local.h      | 18 +---------
 arch/x86/include/asm/module.h     |  2 --
 arch/x86/include/asm/percpu.h     |  3 --
 arch/x86/include/asm/processor.h  | 29 ++++++++++------
 arch/x86/include/asm/swab.h       | 29 ++--------------
 arch/x86/include/asm/tlbflush.h   |  3 --
 arch/x86/include/asm/uaccess.h    | 42 ----------------------
 arch/x86/kernel/cpu/amd.c         |  3 --
 arch/x86/kernel/cpu/bugs.c        | 41 ++--------------------
 arch/x86/kernel/cpu/intel.c       |  4 ---
 arch/x86/lib/Makefile             |  1 -
 arch/x86/lib/cmpxchg.c            | 54 -----------------------------
 arch/x86/lib/usercopy_32.c        | 57 ------------------------------
 arch/x86/mm/init_32.c             |  5 +--
 arch/x86/mm/tlb.c                 |  8 ++---
 arch/x86/um/Kconfig               |  2 +-
 arch/x86/xen/Kconfig              |  2 +-
 24 files changed, 52 insertions(+), 425 deletions(-)
