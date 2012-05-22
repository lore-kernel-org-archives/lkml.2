Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633Ab2EVWTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 18:19:00 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892Ab2EVWS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 18:18:58 -0400
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 23 May 2012 00:18:55 +0200
From: Richard Weinberger <richard@nod.at>
To: <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>,
        <user-mode-linux-devel@lists.sourceforge.net>, <richard@nod.at>
Subject: [GIT PULL] UML changes for 3.5-rc1
Message-ID: <02661875af6e093160428627ea08ea63@radon2.swed.at>
User-Agent: RoundCube Webmail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest for-linus tree from:

  git://git.kernel.org/pub/scm/linux/kernel/git/rw/uml.git for-linus

  HEAD: 2ccf62b36097aa88e0ea152d6ef0c0ca2d3884e6:
  Merge branch 'for-um' of 
git://git.kernel.org/pub/scm/linux/kernel/git/viro/signal into for-3.5 
(2012-05-21 23:25:37 +0200)

Most changes are bug fixes and cleanups.

Thanks,
//richard

----------------------------------------------------------------

Al Viro (7):
      um: ->restart_block.fn needs to be reset on sigreturn
      um: add TIF_NOTIFY_RESUME
      um: wrong sigmask saved in case of multiple sigframes
      um: bury unused _TIF_RESTORE_SIGMASK
      um/x86: merge (and trim) 32- and 64-bit variants of ptrace.h
      um: stub_rt_sigsuspend isn't needed these days anymore
      um: missing checks of __put_user()/__get_user() return values

Richard Weinberger (9):
      um: Remove unused variables
      um: Add BUG() to do_ops()'s error path
      um: Implement a custom pte_same() function
      um: Fix __swp_type()
      um: Implement um_free_irq()
      um: Remove usage of irq_chip->release()
      um: Remove CONFIG_IRQ_RELEASE_METHOD
      irq: Remove irq_chip->release()
      Merge branch 'for-um' of git://git.kernel.org/.../viro/signal 
into for-3.5

 arch/um/Kconfig.common                |    5 --
 arch/um/defconfig                     |    1 -
 arch/um/drivers/chan_kern.c           |    9 +--
 arch/um/drivers/line.c                |    2 +-
 arch/um/drivers/net_kern.c            |    4 +-
 arch/um/drivers/port_kern.c           |    2 +-
 arch/um/drivers/xterm_kern.c          |    2 +-
 arch/um/include/asm/pgtable.h         |   10 +++-
 arch/um/include/asm/thread_info.h     |    2 +-
 arch/um/include/shared/irq_kern.h     |    2 +-
 arch/um/kernel/irq.c                  |    9 ++-
 arch/um/kernel/process.c              |   10 +++-
 arch/um/kernel/signal.c               |   14 ++---
 arch/um/kernel/skas/syscall.c         |    2 +-
 arch/um/kernel/tlb.c                  |    1 +
 arch/um/os-Linux/skas/mem.c           |   10 ----
 arch/x86/um/asm/elf.h                 |   42 +++++++-------
 arch/x86/um/asm/ptrace.h              |   34 +++++++++++
 arch/x86/um/asm/ptrace_32.h           |   23 --------
 arch/x86/um/asm/ptrace_64.h           |   26 ---------
 arch/x86/um/shared/sysdep/ptrace.h    |   67 ++++++++++++++++++++--
 arch/x86/um/shared/sysdep/ptrace_32.h |   92 
+++---------------------------
 arch/x86/um/shared/sysdep/ptrace_64.h |  101 
++-------------------------------
 arch/x86/um/signal.c                  |   29 +++++-----
 arch/x86/um/sys_call_table_64.c       |    1 -
 arch/x86/um/syscalls_32.c             |   12 ++--
 arch/x86/um/sysrq_32.c                |    8 +--
 arch/x86/um/sysrq_64.c                |    8 +--
 arch/x86/um/tls_32.c                  |    2 +-
 include/linux/irq.h                   |    5 --
 kernel/irq/manage.c                   |    6 --
 31 files changed, 201 insertions(+), 340 deletions(-)

