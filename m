Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab1KQWhh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 17:37:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:12670 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893Ab1KQWhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 17:37:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="77077668"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: linux-kernel@vger.kernel.org, kbuild@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "H.J. Lu" <hjl.tools@gmail.com>, David Woodhouse <dwmw2@infradead.org>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 0/8] RFC x86: Generate system calls from a simple table
Date: Thu, 17 Nov 2011 14:37:18 -0800
Message-Id: <1321569446-20433-1-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

This patch series generates all the files that depend on the x86
system call numbers -- specifically unistd_*.h and the system call
tables themselves -- from a simple text file table.  Furthermore, it
unifies the multiple different ways that the system call tables are
generated.  Although this is an x86-specific patch, the scripts are
intended to be generic enough that it should be easy for other
architectures to use them as well.

The "ABI" column in the text file is currently unused, however, it is
intended to support the new x32 ABI, and may be helpful for other
architectures that have multiple system call ABI ranges as well.

Special thanks to David Woodhouse, Michal Marek and Sam Ravnborg for
helping me straight out the maze of Kbuild dependencies.

 Documentation/kbuild/makefiles.txt |   50 ++-
 Makefile                           |    9 +-
 arch/x86/Makefile                  |    6 +
 arch/x86/ia32/Makefile             |    1 +
 arch/x86/ia32/ia32entry.S          |  359 ------------------
 arch/x86/ia32/nosyscall.c          |    7 +
 arch/x86/ia32/syscall_ia32.c       |   25 ++
 arch/x86/include/asm/Kbuild        |    5 +-
 arch/x86/include/asm/ia32_unistd.h |   13 +-
 arch/x86/include/asm/unistd.h      |   54 +++-
 arch/x86/include/asm/unistd_32.h   |  401 --------------------
 arch/x86/include/asm/unistd_64.h   |  732 ------------------------------------
 arch/x86/kernel/Makefile           |    3 +-
 arch/x86/kernel/asm-offsets_32.c   |    8 +
 arch/x86/kernel/asm-offsets_64.c   |   19 +-
 arch/x86/kernel/entry_32.S         |   37 +--
 arch/x86/kernel/syscall_32.c       |   25 ++
 arch/x86/kernel/syscall_64.c       |   20 +-
 arch/x86/kernel/syscall_table_32.S |  350 -----------------
 arch/x86/syscalls/Makefile         |   43 +++
 arch/x86/syscalls/syscall_32.tbl   |  357 ++++++++++++++++++
 arch/x86/syscalls/syscall_64.tbl   |  320 ++++++++++++++++
 arch/x86/syscalls/syscallhdr.sh    |   36 ++
 arch/x86/syscalls/syscalltbl.sh    |   15 +
 kernel/trace/trace_syscalls.c      |    1 +
 scripts/Makefile.headersinst       |   10 +-
 scripts/checksyscalls.sh           |   15 +-
 scripts/headers.sh                 |    1 +
 28 files changed, 993 insertions(+), 1929 deletions(-)
