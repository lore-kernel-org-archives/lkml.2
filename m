Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab2IXOgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 10:36:24 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63368 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683Ab2IXOgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 10:36:20 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Amerigo Wang <amwang@redhat.com>,
        "Jonathan M. Foote" <jmfoote@cert.org>,
        Roland McGrath <roland@hack.frob.com>, Pedro Alves <palves@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH -mm v4 0/4] coredump: add new elf notes: siginfo, mapped files
Date: Mon, 24 Sep 2012 16:35:59 +0200
Message-Id: <1348497363-341-1-git-send-email-vda.linux@googlemail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, this changeset supersedes all my recent previous patches,
please drop them from -mm.

This changeset is on top of "add support for %d=__get_dumpable() in core name"
patch currently in -mm.

Changes since previous version:
* added a patch which unifies location of compat_siginfo_t
  (this should fix powerpc64 compile failure)
* merged with the NT_FILE patch
* added missed include of vmalloc.h
* minor style fixes

Compat coredump code was compile tested on x86-64 and mips64.
Changeset also touches arm64, parisc, powerpc64, s390, sparc, and tile
arches, I can't compile-test those at the moment.

Denys Vlasenko (4):
  coredump: pass siginfo_t* to do_coredump() and below, not merely
    signr
  compat: move compat_siginfo_t definition to asm/compat.h
  coredump: add a new elf note with siginfo of the signal
  coredump: extend core dump note section to contain file names of
    mapped files

 arch/arm64/include/asm/compat.h       |   60 +++++++++++++-
 arch/arm64/kernel/signal32.c          |   53 ------------
 arch/mips/include/asm/compat-signal.h |   62 --------------
 arch/mips/include/asm/compat.h        |   69 +++++++++++++++-
 arch/parisc/include/asm/compat.h      |   59 +++++++++++++-
 arch/parisc/kernel/signal32.h         |   52 ------------
 arch/powerpc/include/asm/compat.h     |   60 +++++++++++++-
 arch/powerpc/include/asm/siginfo.h    |    1 -
 arch/powerpc/kernel/ppc32.h           |   51 -----------
 arch/s390/include/asm/compat.h        |   75 +++++++++++++++++-
 arch/s390/kernel/compat_linux.h       |   68 ---------------
 arch/sparc/include/asm/compat.h       |   61 +++++++++++++-
 arch/sparc/include/asm/siginfo.h      |    1 -
 arch/sparc/kernel/signal32.c          |   52 ------------
 arch/tile/include/asm/compat.h        |   62 ++++++++++++++
 arch/tile/kernel/compat_signal.c      |   57 -------------
 arch/x86/include/asm/compat.h         |   74 ++++++++++++++++-
 arch/x86/include/asm/ia32.h           |   67 ---------------
 fs/binfmt_aout.c                      |    2 +-
 fs/binfmt_elf.c                       |  147 ++++++++++++++++++++++++++++++---
 fs/binfmt_elf_fdpic.c                 |    6 +-
 fs/binfmt_flat.c                      |    2 +-
 fs/compat_binfmt_elf.c                |    7 ++
 fs/coredump.c                         |   10 +-
 include/linux/binfmts.h               |    2 +-
 include/linux/compat.h                |    5 -
 include/linux/coredump.h              |    4 +-
 include/linux/elf.h                   |    6 ++
 kernel/signal.c                       |    2 +-
 29 files changed, 676 insertions(+), 501 deletions(-)

-- 
1.7.7.6

