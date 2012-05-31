Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700Ab2EaX6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 19:58:12 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60322 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932624Ab2EaX5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 19:57:50 -0400
Date: Fri, 1 Jun 2012 00:57:48 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] signal.git pile 2 (of 3, probably)
Message-ID: <20120531235748.GE30000@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That one is just task_work_add() series + remaining prereqs for it.
There probably will be another pull request from that tree this
cycle - at least for helpers, to get them out of the way for per-arch
fixes remaining in the tree.  Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/signal for-linus

Shortlog:
Al Viro (4):
      TIF_NOTIFY_RESUME is defined on all targets now
      move key_repace_session_keyring() into tracehook_notify_resume()
      parisc: need to check NOTIFY_RESUME when exiting from syscall
      avr32: missed _TIF_NOTIFY_RESUME on one of do_notify_resume callers

Oleg Nesterov (5):
      task_work_add: generic process-context callbacks
      genirq: reimplement exit_irq_thread() hook via task_work_add()
      keys: change keyctl_session_to_parent() to use task_work_add()
      keys: kill the dummy key_replace_session_keyring()
      keys: kill task_struct->replacement_session_keyring

Diffstat:
 arch/alpha/kernel/signal.c       |    2 -
 arch/arm/kernel/signal.c         |    2 -
 arch/avr32/kernel/entry-avr32b.S |    2 +-
 arch/avr32/kernel/signal.c       |    2 -
 arch/blackfin/kernel/signal.c    |    2 -
 arch/c6x/kernel/signal.c         |    2 -
 arch/cris/kernel/ptrace.c        |    2 -
 arch/frv/kernel/signal.c         |    2 -
 arch/h8300/kernel/signal.c       |    2 -
 arch/hexagon/kernel/signal.c     |    2 -
 arch/ia64/kernel/process.c       |    2 -
 arch/m32r/kernel/signal.c        |    2 -
 arch/m68k/kernel/signal.c        |    5 +--
 arch/microblaze/kernel/signal.c  |    5 +--
 arch/mips/kernel/signal.c        |    2 -
 arch/mn10300/kernel/signal.c     |    2 -
 arch/openrisc/kernel/signal.c    |    2 -
 arch/parisc/kernel/entry.S       |    2 +-
 arch/parisc/kernel/signal.c      |    2 -
 arch/powerpc/kernel/signal.c     |    2 -
 arch/s390/kernel/signal.c        |    2 -
 arch/score/kernel/signal.c       |    2 -
 arch/sh/kernel/signal_32.c       |    2 -
 arch/sh/kernel/signal_64.c       |    2 -
 arch/sparc/kernel/signal_32.c    |    2 -
 arch/sparc/kernel/signal_64.c    |    2 -
 arch/tile/kernel/process.c       |    2 -
 arch/um/kernel/process.c         |    5 +--
 arch/unicore32/kernel/signal.c   |    2 -
 arch/x86/kernel/signal.c         |    2 -
 arch/xtensa/kernel/signal.c      |    5 +--
 include/linux/interrupt.h        |    4 --
 include/linux/key.h              |    4 --
 include/linux/sched.h            |   14 ++-----
 include/linux/task_work.h        |   33 +++++++++++++++
 include/linux/tracehook.h        |   13 +++++-
 kernel/Makefile                  |    2 +-
 kernel/cred.c                    |    9 ----
 kernel/exit.c                    |    5 +-
 kernel/fork.c                    |    1 +
 kernel/irq/manage.c              |   68 +++++++++++++++----------------
 kernel/task_work.c               |   84 ++++++++++++++++++++++++++++++++++++++
 security/keys/internal.h         |    2 +
 security/keys/keyctl.c           |   73 ++++++++++++++++-----------------
 security/keys/process_keys.c     |   20 +++------
 45 files changed, 220 insertions(+), 186 deletions(-)
 create mode 100644 include/linux/task_work.h
 create mode 100644 kernel/task_work.c
