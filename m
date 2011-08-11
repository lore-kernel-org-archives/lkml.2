Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518Ab1HKN5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 09:57:21 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60012 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751033Ab1HKN5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 09:57:20 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/41] signal: Use set_current_blocked()
Date: Thu, 11 Aug 2011 14:56:34 +0100
Message-Id: <1313071035-12047-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Hi Oleg,

I did a tree wide scan of all the code that modifies current->blocked
without using the set_current_blocked() accessor. This patch series is
the result of the conversion to the new accessor functions.

This series also helps to reduce the complexity of my signal
scalability patches that I posted in April, because we now have much
fewer callers of recalc_sigpending() (the signal scalability patches
introduce a new lock that needs to be held when calling
recalc_sigpending()).

This series is available in the 'oleg/set-current-blocked' branch at,

    git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/linux-2.6.git

P.S I've punted on fully converting ia64 to set_current_blocked()
because bits of the signal code are written in asm. I'll follow up
with a later patch that does the conversion once I've improved my ia64
foo (or coerced Tony Luck into doing it ;).

Matt Fleming (40):
  alpha: Use set_current_blocked()
  arm: Use set_current_blocked()
  avr32: Don't mask signals in the error path
  blackfin: Use set_current_blocked()
  cris: Use set_current_blocked()
  frv: Use set_current_blocked()
  h8300: Use set_current_blocked()
  ia64: Use set_current_blocked()
  m32r: Use set_current_blocked()
  m68k: Use set_current_blocked()
  microblaze: Don't reimplement force_sigsegv()
  microblaze: No need to reset handler if SA_ONESHOT
  microblaze: Fix signal masking
  microblaze: Use set_current_blocked()
  MIPS: Use set_current_blocked()
  mn10300: Use set_current_blocked()
  OpenRISC: Don't reimplement force_sigsegv()
  OpenRISC: No need to reset handler if SA_ONESHOT
  OpenRISC: Don't mask signals if we fail to setup signal stack
  OpenRISC: Use set_current_blocked()
  parisc: Use set_current_blocked()
  powerpc: Use set_current_blocked()
  score: Don't mask signals if we fail to setup signal stack
  score: Use set_current_blocked()
  sh: No need to reset handler if SA_ONESHOT
  sh: Use set_current_blocked()
  sparc: Use set_current_blocked()
  tile: Use set_current_blocked()
  um: Use set_current_blocked()
  um: Don't restore current->blocked on error
  unicore32: Use set_current_blocked()
  xtensa: Don't reimplement force_sigsegv()
  xtensa: No need to reset handler if SA_ONESHOT
  xtensa: Don't mask signals if we fail to setup signal stack
  xtensa: Use set_current_blocked()
  autofs4: Use set_current_blocked()
  coda: Use set_current_blocked()
  dlm: Remove another superfluous call to recalc_sigpending()
  ncpfs: Use set_current_blocked()
  exit: Use __set_task_blocked()

Oleg Nesterov (1):
  avr32: use set_current_blocked() in handle_signal/sys_rt_sigreturn

 arch/alpha/kernel/signal.c         |   31 ++++++++++-------------
 arch/arm/kernel/signal.c           |   25 ++++++++----------
 arch/avr32/kernel/signal.c         |   30 +++++++++-------------
 arch/blackfin/kernel/signal.c      |   16 ++++-------
 arch/cris/arch-v10/kernel/signal.c |   33 ++++++++++--------------
 arch/cris/arch-v32/kernel/signal.c |   37 ++++++++++-----------------
 arch/frv/kernel/signal.c           |   32 ++++++++++--------------
 arch/h8300/kernel/signal.c         |   36 ++++++++++-----------------
 arch/ia64/kernel/signal.c          |   18 ++++---------
 arch/m32r/kernel/signal.c          |   16 +++++-------
 arch/m68k/kernel/signal_mm.c       |   24 +++++++++---------
 arch/m68k/kernel/signal_no.c       |   30 +++++++++-------------
 arch/microblaze/kernel/signal.c    |   46 ++++++++++++++++-------------------
 arch/mips/kernel/signal.c          |   29 ++++++----------------
 arch/mips/kernel/signal32.c        |   20 +++------------
 arch/mips/kernel/signal_n32.c      |   10 +------
 arch/mn10300/kernel/signal.c       |   32 ++++++++++--------------
 arch/openrisc/kernel/signal.c      |   47 ++++++++++++++++-------------------
 arch/parisc/kernel/signal.c        |   15 ++++-------
 arch/powerpc/kernel/signal.c       |   16 ++++-------
 arch/powerpc/kernel/signal_32.c    |   11 ++++----
 arch/score/kernel/signal.c         |   19 +++++++-------
 arch/sh/kernel/signal_32.c         |   35 ++++++++++----------------
 arch/sh/kernel/signal_64.c         |   40 ++++++++++--------------------
 arch/sparc/kernel/signal32.c       |   19 ++++----------
 arch/sparc/kernel/signal_32.c      |   30 +++++++++-------------
 arch/sparc/kernel/signal_64.c      |   30 +++++++++-------------
 arch/tile/kernel/compat_signal.c   |    5 +---
 arch/tile/kernel/signal.c          |   16 ++++-------
 arch/um/kernel/signal.c            |   30 ++++++++++-------------
 arch/um/sys-i386/signal.c          |   12 +-------
 arch/um/sys-x86_64/signal.c        |    6 +----
 arch/unicore32/kernel/signal.c     |   15 ++++-------
 arch/xtensa/kernel/signal.c        |   37 ++++++++++-----------------
 fs/autofs4/waitq.c                 |   15 ++++-------
 fs/coda/upcall.c                   |   19 ++++++--------
 fs/dlm/user.c                      |    1 -
 fs/ncpfs/sock.c                    |   12 ++++-----
 kernel/exit.c                      |    7 ++++-
 39 files changed, 351 insertions(+), 551 deletions(-)

-- 
1.7.4.4

