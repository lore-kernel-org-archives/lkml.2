Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446Ab2CWKUA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 06:20:00 -0400
Received: from mail.southpole.se ([193.12.106.18]:36484 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716Ab2CWKT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 06:19:59 -0400
Message-ID: <1332497996.27665.77.camel@jerome.southpole.se>
Subject: [GIT PULL] OpenRISC arch for 3.4
From: Jonas Bonn <jonas@southpole.se>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Date: Fri, 23 Mar 2012 11:19:56 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Assp-Version: 2.1.1(11364) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 97995-04778
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following changes since commit
3f6ffc8c2087791920721f086f9a92fde7bed9e2:

  openrisc: Fix up audit_syscall_[entry|exit]() usage (2012-02-17
09:53:12 +0100)

are available in the git repository at:

  git://openrisc.net/jonas/linux for-3.4

for you to fetch changes up to fa8d9d74c360726fe743b08af00ee3d0e0eb8bc1:

  OpenRISC: Remove memory_start/end prototypes (2012-03-06 10:37:21
+0100)

----------------------------------------------------------------
OpenRISC changes for 3.4

This series for the OpenRISC architecture consists of mostly trivial
fixups.
The most interesting bits of the series are:

* A fix to the timer code whereby the shortest trigger period is set to
  100 cycles; previously, it was possible to set this to 1 cycle, but by
  the time the register was written, that time had already passed and
the
  timer interrupt would not go off until the cycle counter had gone a
full
  cycle.

* Allowing a device tree binary to be passed in to the kernel from
u-boot.
  The OpenRISC architecture has been recently merged into upstream
u-boot,
  so this change gets OpenRISC Linux into sync with that project.

----------------------------------------------------------------
Danny Kukawka (1):
      openrisc: included linux/thread_info.h twice

Jonas Bonn (4):
      openrisc: Set shortest clock event to 100 ticks
      openrisc: fix virt_addr_valid
      openrisc: sanitize use of orig_gpr11
      openrisc: remove semicolon from KSTK_ defs

Julia Lawall (1):
      arch/openrisc/mm/init.c: trivial: use BUG_ON

Matt Fleming (4):
      OpenRISC: Don't reimplement force_sigsegv()
      OpenRISC: No need to reset handler if SA_ONESHOT
      OpenRISC: Don't mask signals if we fail to setup signal stack
      OpenRISC: Use set_current_blocked() and block_sigmask()

Richard Weinberger (3):
      OpenRISC: Select GENERIC_ATOMIC64
      OpenRISC: Export dump_stack()
      OpenRISC: Remove memory_start/end prototypes

Stefan Kristiansson (1):
      openrisc: enable passing of flattened device tree pointer

 arch/openrisc/Kconfig                 |    1 +
 arch/openrisc/include/asm/page.h      |    6 +---
 arch/openrisc/include/asm/processor.h |    4 +-
 arch/openrisc/include/asm/ptrace.h    |    6 +++-
 arch/openrisc/include/asm/syscall.h   |    7 +---
 arch/openrisc/include/asm/uaccess.h   |    1 -
 arch/openrisc/kernel/entry.S          |   16 +++++-----
 arch/openrisc/kernel/head.S           |   17 +++++++++++-
 arch/openrisc/kernel/ptrace.c         |    4 +-
 arch/openrisc/kernel/setup.c          |   18 ++++++------
 arch/openrisc/kernel/signal.c         |   47
++++++++++++++-------------------
 arch/openrisc/kernel/time.c           |   13 +++-----
 arch/openrisc/kernel/traps.c          |    9 +++---
 arch/openrisc/mm/init.c               |    3 +-
 14 files changed, 77 insertions(+), 75 deletions(-)


