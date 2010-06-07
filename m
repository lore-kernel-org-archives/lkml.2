Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396Ab0FGNzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 09:55:43 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35524 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab0FGNzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 09:55:42 -0400
Message-ID: <4C0CF9DF.2050603@monstr.eu>
Date: Mon, 07 Jun 2010 15:53:35 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/microblaze fixes for 2.6.35-rc3
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following changes. There are two changes out of 
arch/microblaze folder. The first disables FRAME_POINTER selection.
The second change is in asm-generic/atomic.h which change 
local_irq_save/restore to raw_local_irq_save/restore because of irqsoff 
tracer. I am not sure about other archs but Microblaze needs it.

Thanks,
Michal


The following changes since commit 386f40c86d6c8d5b717ef20620af1a750d0dacb4:
   Linus Torvalds (1):
         Revert "tty: fix a little bug in scrup, vt.c"

are available in the git repository at:

   git://git.monstr.eu/linux-2.6-microblaze.git next

Michal Simek (12):
       microblaze: Fix __copy_to/from_user_inatomic macros
       microblaze: Fix copy_to_user_page macro
       microblaze: Disable FRAME_POINTER selection
       microblaze: Sync noMMU and MMU setup_memory
       microblaze: Fix comment for TLB
       microblaze: Fix sys_clone syscall
       microblaze: Implement flush_dcache_page macro
       microblaze: Trace hardirqs
       microblaze: Enable NEED_SG_DMA_LENGTH
       microblaze: Remove unused label
       microblaze: Define ARCH_SLAB_MINALIGN
       asm-generic: Use raw_local_irq_save/restore instead 
local_irq_save/restore

Steven J. Magnani (2):
       microblaze: add stack unwinder
       microblaze: allow PAGE_SIZE configuration

  arch/microblaze/Kconfig                       |   33 +++
  arch/microblaze/include/asm/cacheflush.h      |   18 +-
  arch/microblaze/include/asm/elf.h             |    2 +-
  arch/microblaze/include/asm/exceptions.h      |    5 +
  arch/microblaze/include/asm/page.h            |   14 +-
  arch/microblaze/include/asm/system.h          |    1 -
  arch/microblaze/include/asm/uaccess.h         |    4 +-
  arch/microblaze/include/asm/unwind.h          |   29 +++
  arch/microblaze/kernel/Makefile               |    2 +-
  arch/microblaze/kernel/cpu/mb.c               |    1 +
  arch/microblaze/kernel/entry-nommu.S          |   28 +++
  arch/microblaze/kernel/entry.S                |   41 +++-
  arch/microblaze/kernel/head.S                 |    4 +-
  arch/microblaze/kernel/hw_exception_handler.S |    4 +-
  arch/microblaze/kernel/irq.c                  |    2 +
  arch/microblaze/kernel/misc.S                 |    2 +-
  arch/microblaze/kernel/ptrace.c               |   17 ++-
  arch/microblaze/kernel/stacktrace.c           |   44 +---
  arch/microblaze/kernel/traps.c                |   91 +++----
  arch/microblaze/kernel/unwind.c               |  318 
+++++++++++++++++++++++++
  arch/microblaze/kernel/vmlinux.lds.S          |   12 +-
  arch/microblaze/mm/fault.c                    |    1 -
  arch/microblaze/mm/init.c                     |    7 +-
  include/asm-generic/atomic.h                  |   12 +-
  lib/Kconfig.debug                             |    6 +-
  25 files changed, 560 insertions(+), 138 deletions(-)
  create mode 100644 arch/microblaze/include/asm/unwind.h
  create mode 100644 arch/microblaze/kernel/unwind.c


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
