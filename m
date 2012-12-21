Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab2LUAVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 19:21:16 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:48966 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab2LUAVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 19:21:03 -0500
Date: Fri, 21 Dec 2012 00:21:00 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [git pull] signal.git pile 2
Message-ID: <20121221002100.GM4939@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sigaltstack infrastructure + conversion for x86, alpha and um,
COMPAT_SYSCALL_DEFINE infrastructure.  Note that there are several
conflicts between "unify SS_ONSTACK/SS_DISABLE definitions" and
UAPI patches in mainline; resolution is trivial - just remove definitions
of SS_ONSTACK and SS_DISABLED from arch/*/uapi/asm/signal.h; they are
all identical and include/uapi/linux/signal.h contains the unified
variant.  Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/signal for-linus

Shortlog:
Al Viro (11):
      COMPAT_SYSCALL_DEFINE: infrastructure
      Bury the conditionals from kernel_thread/kernel_execve series
      missing user_stack_pointer() instances
      new helper: current_user_stack_pointer()
      unify SS_ONSTACK/SS_DISABLE definitions
      new helper: restore_altstack()
      new helper: compat_user_stack_pointer()
      introduce generic sys_sigaltstack(), switch x86 and um to it
      generic compat_sys_sigaltstack()
      new helpers: __save_altstack/__compat_save_altstack, switch x86 and um to those
      alpha: switch to generic sigaltstack

Diffstat:
 arch/Kconfig                             |    9 +--
 arch/alpha/Kconfig                       |    3 +-
 arch/alpha/include/asm/ptrace.h          |    1 +
 arch/alpha/include/asm/signal.h          |    6 --
 arch/alpha/include/asm/unistd.h          |    1 -
 arch/alpha/kernel/signal.c               |   10 +----
 arch/arm/Kconfig                         |    2 -
 arch/arm/include/asm/unistd.h            |    1 -
 arch/arm/include/uapi/asm/signal.h       |    7 ---
 arch/arm64/Kconfig                       |    2 -
 arch/arm64/include/asm/compat.h          |    5 +-
 arch/arm64/include/asm/unistd.h          |    1 -
 arch/avr32/Kconfig                       |    2 -
 arch/avr32/include/asm/ptrace.h          |    1 +
 arch/avr32/include/asm/unistd.h          |    1 -
 arch/avr32/include/uapi/asm/signal.h     |    6 --
 arch/blackfin/Kconfig                    |    2 -
 arch/blackfin/include/asm/ptrace.h       |    1 +
 arch/blackfin/include/asm/unistd.h       |    1 -
 arch/c6x/Kconfig                         |    2 -
 arch/c6x/include/uapi/asm/unistd.h       |    1 -
 arch/cris/Kconfig                        |    2 -
 arch/cris/include/asm/ptrace.h           |    1 +
 arch/cris/include/asm/signal.h           |    6 --
 arch/cris/include/asm/unistd.h           |    1 -
 arch/frv/Kconfig                         |    2 -
 arch/frv/include/asm/unistd.h            |    1 -
 arch/h8300/Kconfig                       |    2 -
 arch/h8300/include/asm/ptrace.h          |    1 +
 arch/h8300/include/asm/signal.h          |    6 --
 arch/h8300/include/asm/unistd.h          |    1 -
 arch/hexagon/Kconfig                     |    2 -
 arch/hexagon/include/uapi/asm/unistd.h   |    1 -
 arch/ia64/Kconfig                        |    2 -
 arch/ia64/include/asm/ptrace.h           |    5 ++
 arch/ia64/include/asm/unistd.h           |    1 -
 arch/ia64/include/uapi/asm/signal.h      |    6 --
 arch/m32r/Kconfig                        |    2 -
 arch/m32r/include/asm/ptrace.h           |    1 +
 arch/m32r/include/asm/signal.h           |    6 --
 arch/m32r/include/asm/unistd.h           |    1 -
 arch/m68k/Kconfig                        |    2 -
 arch/m68k/include/asm/ptrace.h           |    1 +
 arch/m68k/include/asm/unistd.h           |    1 -
 arch/m68k/include/uapi/asm/signal.h      |    6 --
 arch/microblaze/Kconfig                  |    2 -
 arch/microblaze/include/asm/ptrace.h     |    1 +
 arch/microblaze/include/asm/unistd.h     |    1 -
 arch/mips/Kconfig                        |    2 -
 arch/mips/include/asm/ptrace.h           |    1 +
 arch/mips/include/asm/unistd.h           |    1 -
 arch/mips/include/uapi/asm/signal.h      |    6 --
 arch/mn10300/Kconfig                     |    2 -
 arch/mn10300/include/asm/unistd.h        |    1 -
 arch/mn10300/include/uapi/asm/signal.h   |    6 --
 arch/openrisc/Kconfig                    |    2 -
 arch/openrisc/include/uapi/asm/unistd.h  |    1 -
 arch/parisc/Kconfig                      |    2 -
 arch/parisc/include/asm/unistd.h         |    1 -
 arch/parisc/include/uapi/asm/signal.h    |    6 --
 arch/powerpc/Kconfig                     |    2 -
 arch/powerpc/include/asm/unistd.h        |    1 -
 arch/powerpc/include/uapi/asm/signal.h   |    6 --
 arch/s390/Kconfig                        |    2 -
 arch/s390/include/asm/compat.h           |    3 +
 arch/s390/include/asm/unistd.h           |    1 -
 arch/s390/include/uapi/asm/signal.h      |    6 --
 arch/score/Kconfig                       |    2 -
 arch/score/include/asm/ptrace.h          |    1 +
 arch/score/include/asm/unistd.h          |    1 -
 arch/sh/Kconfig                          |    2 -
 arch/sh/include/asm/unistd.h             |    1 -
 arch/sparc/Kconfig                       |    2 -
 arch/sparc/include/asm/unistd.h          |    1 -
 arch/sparc/include/uapi/asm/signal.h     |    6 --
 arch/tile/Kconfig                        |    2 -
 arch/tile/include/asm/ptrace.h           |    1 +
 arch/tile/include/asm/unistd.h           |    1 -
 arch/um/kernel/signal.c                  |    5 --
 arch/unicore32/Kconfig                   |    2 -
 arch/unicore32/include/asm/ptrace.h      |    1 +
 arch/unicore32/include/uapi/asm/unistd.h |    1 -
 arch/x86/Kconfig                         |    3 +-
 arch/x86/ia32/ia32_signal.c              |   55 +---------------------
 arch/x86/ia32/ia32entry.S                |    1 -
 arch/x86/include/asm/ia32.h              |   10 +---
 arch/x86/include/asm/ptrace.h            |    7 +++
 arch/x86/include/asm/signal.h            |    6 --
 arch/x86/include/asm/sys_ia32.h          |    2 -
 arch/x86/include/asm/syscalls.h          |    3 -
 arch/x86/include/asm/unistd.h            |    1 -
 arch/x86/kernel/entry_32.S               |    1 -
 arch/x86/kernel/entry_64.S               |    3 -
 arch/x86/kernel/signal.c                 |   29 ++----------
 arch/x86/syscalls/syscall_32.tbl         |    2 +-
 arch/x86/syscalls/syscall_64.tbl         |    4 +-
 arch/x86/um/Kconfig                      |    3 +-
 arch/x86/um/asm/ptrace.h                 |    1 +
 arch/x86/um/signal.c                     |    9 +---
 arch/x86/um/sys_call_table_32.c          |    1 -
 arch/x86/um/sys_call_table_64.c          |    1 -
 arch/xtensa/Kconfig                      |    2 -
 arch/xtensa/include/asm/ptrace.h         |    2 +
 arch/xtensa/include/asm/unistd.h         |    1 -
 arch/xtensa/include/uapi/asm/signal.h    |    6 --
 fs/exec.c                                |   21 --------
 include/linux/binfmts.h                  |    4 --
 include/linux/compat.h                   |   62 +++++++++++++++++++++++++
 include/linux/ptrace.h                   |    4 ++
 include/linux/sched.h                    |    2 -
 include/linux/signal.h                   |    3 +
 include/linux/syscalls.h                 |   15 ++----
 include/uapi/asm-generic/signal.h        |    6 --
 include/uapi/linux/signal.h              |    2 +
 init/main.c                              |    4 +-
 kernel/fork.c                            |    2 -
 kernel/kmod.c                            |    6 +-
 kernel/signal.c                          |   74 ++++++++++++++++++++++++++++++
 118 files changed, 211 insertions(+), 357 deletions(-)
