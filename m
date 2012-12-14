Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab2LNQBi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 11:01:38 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:52129 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756478Ab2LNQBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 11:01:37 -0500
Message-ID: <50CB4D5E.1000100@monstr.eu>
Date: Fri, 14 Dec 2012 17:01:34 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/microblaze changes for 3.8-rc1
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following changes. The main patch is UAPI.

Thanks,
Michal


The following changes since commit 4336bac52b85201cf92c775940ee70097471c4e2:
   Michal Simek (1):
         microblaze: Remove BIP from childregs

are available in the git repository at:

   git://git.monstr.eu/linux-2.6-microblaze.git next

David Howells (1):
       UAPI: (Scripted) Disintegrate arch/microblaze/include/asm

Michal Simek (9):
       microblaze: uaccess.h: Fix timerfd syscall
       microblaze: Remove passing the second arg to schedule_tail
       microblaze: Do not initialized regs->r1 twice in ELF_PLAT_INIT
       microblaze: Fix intc_enable_or_unmask function
       microblaze: Wire-up new system call kcmp
       microblaze: Add static qualifiers
       microblaze: lib: Remove helper macros
       microblaze: lib: Add lib function declarations
       microblaze: signal: Declare do_notify_resume

  arch/microblaze/include/asm/Kbuild                 |    2 -
  arch/microblaze/include/asm/elf.h                  |   97 +-----
  arch/microblaze/include/asm/entry.h                |    2 +
  arch/microblaze/include/asm/ptrace.h               |   62 +---
  arch/microblaze/include/asm/setup.h                |    6 +-
  arch/microblaze/include/asm/uaccess.h              |    3 +-
  arch/microblaze/include/asm/unistd.h               |  390 +-------------------
  arch/microblaze/include/uapi/asm/Kbuild            |   32 ++
  arch/microblaze/include/{ => uapi}/asm/auxvec.h    |    0
  .../include/{ => uapi}/asm/bitsperlong.h           |    0
  arch/microblaze/include/{ => uapi}/asm/byteorder.h |    0
  arch/microblaze/include/uapi/asm/elf.h             |  121 ++++++
  arch/microblaze/include/{ => uapi}/asm/errno.h     |    0
  arch/microblaze/include/{ => uapi}/asm/fcntl.h     |    0
  arch/microblaze/include/{ => uapi}/asm/ioctl.h     |    0
  arch/microblaze/include/{ => uapi}/asm/ioctls.h    |    0
  arch/microblaze/include/{ => uapi}/asm/ipcbuf.h    |    0
  arch/microblaze/include/{ => uapi}/asm/msgbuf.h    |    0
  arch/microblaze/include/{ => uapi}/asm/param.h     |    0
  arch/microblaze/include/{ => uapi}/asm/poll.h      |    0
  .../include/{ => uapi}/asm/posix_types.h           |    0
  arch/microblaze/include/uapi/asm/ptrace.h          |   72 ++++
  arch/microblaze/include/{ => uapi}/asm/resource.h  |    0
  arch/microblaze/include/{ => uapi}/asm/sembuf.h    |    0
  arch/microblaze/include/uapi/asm/setup.h           |   19 +
  arch/microblaze/include/{ => uapi}/asm/shmbuf.h    |    0
  .../microblaze/include/{ => uapi}/asm/sigcontext.h |    0
  arch/microblaze/include/{ => uapi}/asm/siginfo.h   |    0
  arch/microblaze/include/{ => uapi}/asm/signal.h    |    0
  arch/microblaze/include/{ => uapi}/asm/socket.h    |    0
  arch/microblaze/include/{ => uapi}/asm/sockios.h   |    0
  arch/microblaze/include/{ => uapi}/asm/stat.h      |    0
  arch/microblaze/include/{ => uapi}/asm/statfs.h    |    0
  arch/microblaze/include/{ => uapi}/asm/swab.h      |    0
  arch/microblaze/include/{ => uapi}/asm/termbits.h  |    0
  arch/microblaze/include/{ => uapi}/asm/termios.h   |    0
  arch/microblaze/include/{ => uapi}/asm/types.h     |    0
  arch/microblaze/include/uapi/asm/unistd.h          |  401 ++++++++++++++++++++
  arch/microblaze/kernel/entry-nommu.S               |    1 -
  arch/microblaze/kernel/intc.c                      |    5 +-
  arch/microblaze/kernel/prom.c                      |    4 +-
  arch/microblaze/kernel/signal.c                    |    2 +-
  arch/microblaze/kernel/syscall_table.S             |    1 +
  arch/microblaze/lib/libgcc.h                       |    7 +
  arch/microblaze/lib/muldi3.c                       |   28 +-
  47 files changed, 679 insertions(+), 576 deletions(-)
  rename arch/microblaze/include/{ => uapi}/asm/auxvec.h (100%)
  rename arch/microblaze/include/{ => uapi}/asm/bitsperlong.h (100%)
  rename arch/microblaze/include/{ => uapi}/asm/byteorder.h (100%)
  create mode 100644 arch/microblaze/include/uapi/asm/elf.h
  rename arch/microblaze/include/{ => uapi}/asm/errno.h (100%)
  rename arch/microblaze/include/{ => uapi}/asm/fcntl.h (100%)
  rename arch/microblaze/include/{ => uapi}/asm/ioctl.h (100%)
  rename arch/microblaze/include/{ => uapi}/asm/ioctls.h (100%)
  rename arch/microblaze/include/{ => uapi}/asm/ipcbuf.h (100%)
  rename arch/microblaze/include/{ => uapi}/asm/kvm_para.h (100%)
  rename arch/microblaze/include/{ => uapi}/asm/mman.h (100%)
  rename arch/microblaze/include/{ => uapi}/asm/msgbuf.h (100%)
  rename arch/microblaze/include/{ => uapi}/asm/param.h (100%)
  rename arch/microblaze/include/{ => uapi}/asm/poll.h (100%)
  rename arch/microblaze/include/{ => uapi}/asm/posix_types.h (100%)
  create mode 100644 arch/microblaze/include/uapi/asm/ptrace.h
  rename arch/microblaze/include/{ => uapi}/asm/resource.h (100%)
  rename arch/microblaze/include/{ => uapi}/asm/sembuf.h (100%)
  create mode 100644 arch/microblaze/include/uapi/asm/setup.h
  rename arch/microblaze/include/{ => uapi}/asm/shmbuf.h (100%)
  rename arch/microblaze/include/{ => uapi}/asm/sigcontext.h (100%)
  rename arch/microblaze/include/{ => uapi}/asm/siginfo.h (100%)
  rename arch/microblaze/include/{ => uapi}/asm/signal.h (100%)
  rename arch/microblaze/include/{ => uapi}/asm/socket.h (100%)
  rename arch/microblaze/include/{ => uapi}/asm/sockios.h (100%)
  rename arch/microblaze/include/{ => uapi}/asm/stat.h (100%)
  rename arch/microblaze/include/{ => uapi}/asm/statfs.h (100%)
  rename arch/microblaze/include/{ => uapi}/asm/swab.h (100%)
  rename arch/microblaze/include/{ => uapi}/asm/termbits.h (100%)
  rename arch/microblaze/include/{ => uapi}/asm/termios.h (100%)
  rename arch/microblaze/include/{ => uapi}/asm/types.h (100%)
  create mode 100644 arch/microblaze/include/uapi/asm/unistd.h



-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
