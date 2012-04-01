Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab2DAQCg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 12:02:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55546 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab2DAQCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 12:02:33 -0400
Subject: [RFC PATCH -tip 00/16] in-kernel x86 disassember
To: linux-kernel@vger.kernel.org
From: Masami Hiramatsu <masami.hiramatsu@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 02 Apr 2012 01:02:29 +0900
Message-ID: <20120401160229.4502.2541.stgit@shimauta>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is a series of patches of the in-kernel x86 disassembler
for the latest tip tree.
This will show you a pretty disassembled code instead of
just a digital code sequence when you gets a kernel panic etc.
(I know, we also have script/decodecode for the panic use)

This feature is not for users, but mainly for kernel developers
who can understand disassembly code of x86 ;). This is just like
a joke feature in kernel. (yeah, I spend my spare time for this.
It's my fun :))

Currently, this can disassemble only most popular instructions
in-kernel, such as non-SSE, non-MMX, non-AVX, and so on, becuase
these extended instructions are rarely used in kernel :)
This series supports AT&T syntax, but not fully same as objdump.
Still it doesn't decode instruction suffix of operand size
(w,d,q etc).

The series is also hosted on a repository on GitHub,
you can get the latest version from below public repository.

 git://github.com/mhiramat/linux.git

This series adds below features:

 - Debugfs disassembler interface for kernel function. You can disassemble
   running kernel function on-line.
 - Panic dump shows disassembly code instead of instruction byte stream.
   It generates more human-readable report. (I strongly recommend you to
   add a serial logger if it is enabled :))
 - Disassemble command for KDB. 'dis' command is now available.
 - User-land disassembly tool.

Thank you,

---

Masami Hiramatsu (16):
      x86: Split default64 flag from force64 flag
      x86: Change the order of segment prefix macro
      x86: Add bogus disassembler support
      x86: Show kernel symbol in disassembler
      x86: Disassemble x86-64 only instructions
      x86: Change asm syntax to AT&T-like one
      kdb: Provide original instruction modified by sw breakpoint
      x86/kprobes: Recover breakpoint instruction if KGDB knows
      x86: kernel function disassembly interface
      x86/disasm: Indicate modified instructions
      tracing/docs: add explanation about disassembler interface
      x86: Merge code dump in show_registers
      x86: Disassemble support in register dump
      x86: Indicate trapped address and probed address
      x86/kdb: Add x86 disassembe command
      tools/bogodis: Add bogus disassembler tool in userspace


 Documentation/trace/kprobetrace.txt      |   14 +
 arch/x86/Kconfig.debug                   |   16 +
 arch/x86/include/asm/disasm.h            |   14 +
 arch/x86/include/asm/inat.h              |   38 ++
 arch/x86/include/asm/insn.h              |   16 +
 arch/x86/include/asm/kdebug.h            |    1 
 arch/x86/include/asm/kprobes.h           |    2 
 arch/x86/kernel/dumpstack.c              |  146 +++++++++
 arch/x86/kernel/dumpstack_32.c           |   26 --
 arch/x86/kernel/dumpstack_64.c           |   25 -
 arch/x86/kernel/kdebugfs.c               |  159 +++++++++
 arch/x86/kernel/kgdb.c                   |   72 ++++
 arch/x86/kernel/kprobes.c                |    9 +
 arch/x86/lib/Makefile                    |   18 +
 arch/x86/lib/disasm.c                    |  508 ++++++++++++++++++++++++++++++
 arch/x86/lib/insn.c                      |    2 
 arch/x86/lib/mnemonic.c                  |   96 ++++++
 arch/x86/tools/gen-insn-attr-x86.awk     |    7 
 arch/x86/tools/gen-insn-mnemonic-x86.awk |  352 +++++++++++++++++++++
 include/linux/kdb.h                      |    3 
 include/linux/kgdb.h                     |    1 
 kernel/debug/debug_core.c                |   14 +
 kernel/debug/kdb/kdb_main.c              |   35 ++
 tools/bogodis/Makefile                   |   51 +++
 tools/bogodis/bogodis.c                  |  202 ++++++++++++
 25 files changed, 1759 insertions(+), 68 deletions(-)
 create mode 100644 arch/x86/include/asm/disasm.h
 create mode 100644 arch/x86/lib/disasm.c
 create mode 100644 arch/x86/lib/mnemonic.c
 create mode 100644 arch/x86/tools/gen-insn-mnemonic-x86.awk
 create mode 100644 tools/bogodis/Makefile
 create mode 100644 tools/bogodis/bogodis.c

--
Masami Hiramatsu <masami.hiramatsu@gmail.com>
 
