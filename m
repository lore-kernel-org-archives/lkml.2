Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758421Ab0FIVjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 17:39:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47039 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758386Ab0FIVjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 17:39:33 -0400
Date: Wed, 9 Jun 2010 17:38:43 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
       fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
       vgoyal@redhat.com, sam@ravnborg.org
Message-Id: <cover.1276116186.git.jbaron@redhat.com>
Subject: [PATCH 00/13] jump label v9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

updates for -v9:

*build time detection of gcc 'asm goto' feature via scripts/gcc-goto.sh,
which basically tries to compile a simple 'asm goto' c program, and if
it succeeds we define CC_HAVE_ASM_GOTO. In this way we detect the 4.5 gcc
feature if its backported, as it has been done to 4.4 gcc in fedora.

*misc cleanups and simplifications.

thanks,

-Jason


David S. Miller (1):
  sparc64: Add jump_label support

Jason Baron (11):
  jump label: base patch
  jump label: x86 support
  jump label: tracepoint support
  jump label: add module support
  jump label: move ftrace_dyn_arch_init to common code
  jump label: sort jump table at build-time
  jump label: initialize workqueue tracepoints *before* they are
    registered
  jump label: jump_label_text_reserved() to reserve our jump points
  jump label: convert jump label to use a key
  jump label: convert dynamic debug to use jump labels.
  jump label: add docs

Mathieu Desnoyers (1):
  jump label: notifier atomic call chain notrace

 Documentation/jump-label.txt        |  151 +++++++++++++
 Makefile                            |   11 +-
 arch/Kconfig                        |    3 +
 arch/sparc/Kconfig                  |    1 +
 arch/sparc/include/asm/jump_label.h |   32 +++
 arch/sparc/kernel/Makefile          |    2 +
 arch/sparc/kernel/jump_label.c      |   38 +++
 arch/sparc/kernel/module.c          |    6 +
 arch/x86/Kconfig                    |    1 +
 arch/x86/include/asm/alternative.h  |   14 ++
 arch/x86/include/asm/jump_label.h   |   47 ++++
 arch/x86/kernel/Makefile            |    2 +-
 arch/x86/kernel/alternative.c       |   72 ++++++-
 arch/x86/kernel/ftrace.c            |   70 +------
 arch/x86/kernel/jump_label.c        |   47 ++++
 arch/x86/kernel/kprobes.c           |    3 +-
 arch/x86/kernel/module.c            |    3 +
 arch/x86/kernel/ptrace.c            |    1 +
 arch/x86/kernel/setup.c             |    3 +
 include/asm-generic/vmlinux.lds.h   |   22 ++-
 include/linux/dynamic_debug.h       |   42 ++--
 include/linux/jump_label.h          |   59 +++++
 include/linux/module.h              |    5 +-
 include/linux/tracepoint.h          |    7 +-
 kernel/Makefile                     |    2 +-
 kernel/jump_label.c                 |  426 +++++++++++++++++++++++++++++++++++
 kernel/kprobes.c                    |    3 +-
 kernel/module.c                     |    7 +
 kernel/notifier.c                   |    6 +-
 kernel/trace/ftrace.c               |   13 +-
 kernel/trace/trace_workqueue.c      |   10 +-
 kernel/tracepoint.c                 |    8 +
 lib/dynamic_debug.c                 |   42 +----
 scripts/Makefile.lib                |   11 +-
 scripts/basic/Makefile              |    2 +-
 scripts/basic/hash.c                |   64 ------
 scripts/gcc-goto.sh                 |    5 +
 scripts/mod/Makefile                |    1 +
 scripts/mod/modpost.c               |   73 ++++++-
 scripts/mod/modpost.h               |    1 +
 40 files changed, 1077 insertions(+), 237 deletions(-)
 create mode 100644 Documentation/jump-label.txt
 create mode 100644 arch/sparc/include/asm/jump_label.h
 create mode 100644 arch/sparc/kernel/jump_label.c
 create mode 100644 arch/x86/include/asm/jump_label.h
 create mode 100644 arch/x86/kernel/jump_label.c
 create mode 100644 include/linux/jump_label.h
 create mode 100644 kernel/jump_label.c
 delete mode 100644 scripts/basic/hash.c
 create mode 100644 scripts/gcc-goto.sh

