Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760122Ab2BNLlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 06:41:23 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:44682 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755154Ab2BNLlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 06:41:21 -0500
From: Matt Fleming <matt@console-pimps.org>
To: linux-arch@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 00/40] arch: set_current_blocked() and block_sigmask()
Date: Tue, 14 Feb 2012 11:40:33 +0000
Message-Id: <1329219673-28711-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

This series simplifies the architecture code for handling signals by
making use of set_current_blocked() introduced in e6fa16ab ("signal:
sigprocmask() should do retarget_shared_pending()") and
block_sigmask() introduced in commit 5e6292c0f28f ("signal: add
block_sigmask() for adding sigmask to current->blocked").

A number of architectures have bugs in this code. Using the helper
functions should avoid this problem in the future.

Note that I've only been able to compile test the following,

	- alpha
	- arm
	- m68k
	- mips
	- powerpc
	- s390
	- sh

and that I don't have the hardware to test any of these patches.

Unlike the previous versions of this series, these patches can be
taken through the arch maintainer's trees because the requisite patch
("signal: add block_sigmask() for adding sigmask to current->blocked")
went into v3.3-rc1.

Matt Fleming (39):
  alpha: Use set_current_blocked() and block_sigmask()
  arm: Use set_current_blocked() and block_sigmask()
  avr32: Don't mask signals in the error path
  avr32: Use block_sigmask()
  blackfin: Use set_current_blocked() and block_sigmask()
  C6X: Use set_current_blocked() and block_sigmask()
  cris: Use set_current_blocked() and block_sigmask()
  frv: Use set_current_blocked() and block_sigmask()
  h8300: Use set_current_blocked() and block_sigmask()
  Hexagon: Use set_current_blocked() and block_sigmask()
  ia64: Use set_current_blocked() and block_sigmask()
  m32r: Use set_current_blocked() and block_sigmask()
  m68k: Use set_current_blocked() and block_sigmask()
  microblaze: Don't reimplement force_sigsegv()
  microblaze: No need to reset handler if SA_ONESHOT
  microblaze: Fix signal masking
  microblaze: Use set_current_blocked() and block_sigmask()
  MIPS: Use set_current_blocked() and block_sigmask()
  mn10300: Use set_current_blocked() and block_sigmask()
  OpenRISC: Don't reimplement force_sigsegv()
  OpenRISC: No need to reset handler if SA_ONESHOT
  OpenRISC: Don't mask signals if we fail to setup signal stack
  OpenRISC: Use set_current_blocked() and block_sigmask()
  parisc: Use set_current_blocked() and block_sigmask()
  powerpc: Use set_current_blocked() and block_sigmask()
  [S390] Use block_sigmask()
  score: Don't mask signals if we fail to setup signal stack
  score: Use set_current_blocked() and block_sigmask()
  sh: No need to reset handler if SA_ONESHOT
  sh: Use set_current_blocked() and block_sigmask()
  sparc: Use block_sigmask()
  tile: Use set_current_blocked() and block_sigmask()
  um: Don't restore current->blocked on error
  um: Use set_current_blocked() and block_sigmask()
  unicore32: Use block_sigmask()
  xtensa: Don't reimplement force_sigsegv()
  xtensa: No need to reset handler if SA_ONESHOT
  xtensa: Don't mask signals if we fail to setup signal stack
  xtensa: Use set_current_blocked() and block_sigmask()

Oleg Nesterov (1):
  avr32: use set_current_blocked() in handle_signal/sys_rt_sigreturn

 arch/alpha/kernel/signal.c         |   31 ++++++++----------------
 arch/arm/kernel/signal.c           |   24 ++++++------------
 arch/avr32/kernel/signal.c         |   26 ++++++--------------
 arch/blackfin/kernel/signal.c      |   17 +++----------
 arch/c6x/kernel/signal.c           |   16 ++----------
 arch/cris/arch-v10/kernel/signal.c |   34 +++++++++-----------------
 arch/cris/arch-v32/kernel/signal.c |   37 ++++++++--------------------
 arch/frv/kernel/signal.c           |   32 ++++++++-----------------
 arch/h8300/kernel/signal.c         |   33 +++++++-------------------
 arch/hexagon/kernel/signal.c       |   12 +--------
 arch/ia64/kernel/signal.c          |   15 +----------
 arch/m32r/kernel/signal.c          |   12 +--------
 arch/m68k/kernel/signal_mm.c       |   22 +++++++----------
 arch/m68k/kernel/signal_no.c       |   28 +++++++---------------
 arch/microblaze/kernel/signal.c    |   42 +++++++++++++--------------------
 arch/mips/kernel/signal.c          |   27 ++++-----------------
 arch/mips/kernel/signal32.c        |   20 +++------------
 arch/mips/kernel/signal_n32.c      |   10 +------
 arch/mn10300/kernel/signal.c       |   32 ++++++++-----------------
 arch/openrisc/kernel/signal.c      |   45 +++++++++++++++--------------------
 arch/parisc/kernel/signal.c        |   12 +--------
 arch/powerpc/kernel/signal.c       |   13 +--------
 arch/powerpc/kernel/signal_32.c    |   11 ++++----
 arch/s390/kernel/compat_signal.c   |    6 +----
 arch/s390/kernel/signal.c          |    6 +----
 arch/score/kernel/signal.c         |   13 ++--------
 arch/sh/kernel/signal_32.c         |   35 ++++++++--------------------
 arch/sh/kernel/signal_64.c         |   40 ++++++++------------------------
 arch/sparc/kernel/signal32.c       |    7 +----
 arch/sparc/kernel/signal_32.c      |    7 +----
 arch/sparc/kernel/signal_64.c      |    6 +----
 arch/tile/kernel/compat_signal.c   |    5 +---
 arch/tile/kernel/signal.c          |   13 +--------
 arch/um/kernel/signal.c            |   26 +++++---------------
 arch/unicore32/kernel/signal.c     |    5 +---
 arch/xtensa/kernel/signal.c        |   35 ++++++++-------------------
 36 files changed, 216 insertions(+), 539 deletions(-)

-- 
1.7.4.4

