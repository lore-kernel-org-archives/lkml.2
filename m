Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab0IQPJe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 11:09:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755134Ab0IQPJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 11:09:32 -0400
Date: Fri, 17 Sep 2010 11:08:47 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
        tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com
Message-Id: <cover.1284733808.git.jbaron@redhat.com>
Subject: [PATCH 00/10] jump label v11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

updates in -v11:

-consolidated core jump label changes into a single patch
-updated sparc64 patch from David Miller
-various cleanups

Thanks to Steve Rostedt for helping me clean up the ftrace changes found in
patch 1/10.

thanks,

-Jason

David S. Miller (1):
  jump label: add sparc64 support

Jason Baron (9):
  jump label: x86 - make dynamic no-op selection available outside of ftrace
  jump label: make text_poke_early() globally visisble
  jump label: base patch
  jump label: initialize workqueue tracepoints *before* they are registered
  jump label: jump_label_text_reserved() to reserve our jump points
  jump label: tracepoint support
  jump label: convert dynamic debug to use jump labels
  jump label: x86 support
  jump label: add docs


 Documentation/jump-label.txt        |  148 ++++++++++++
 Makefile                            |    5 +
 arch/Kconfig                        |    3 +
 arch/sparc/Kconfig                  |    1 +
 arch/sparc/include/asm/jump_label.h |   32 +++
 arch/sparc/kernel/Makefile          |    2 +
 arch/sparc/kernel/jump_label.c      |   46 ++++
 arch/sparc/kernel/module.c          |    6 +
 arch/x86/Kconfig                    |    1 +
 arch/x86/include/asm/alternative.h  |   11 +
 arch/x86/include/asm/jump_label.h   |   47 ++++
 arch/x86/kernel/Makefile            |    2 +-
 arch/x86/kernel/alternative.c       |   68 ++++++-
 arch/x86/kernel/ftrace.c            |   63 +-----
 arch/x86/kernel/jump_label.c        |   49 ++++
 arch/x86/kernel/kprobes.c           |    3 +-
 arch/x86/kernel/module.c            |    3 +
 arch/x86/kernel/setup.c             |    6 +
 include/asm-generic/vmlinux.lds.h   |   10 +
 include/linux/dynamic_debug.h       |   39 ++--
 include/linux/jump_label.h          |   64 ++++++
 include/linux/module.h              |    5 +-
 include/linux/tracepoint.h          |    5 +-
 kernel/Makefile                     |    2 +-
 kernel/jump_label.c                 |  421 +++++++++++++++++++++++++++++++++++
 kernel/kprobes.c                    |    4 +-
 kernel/module.c                     |    6 +
 kernel/trace/trace_workqueue.c      |   10 +-
 kernel/tracepoint.c                 |   14 +-
 lib/dynamic_debug.c                 |   42 +----
 scripts/Makefile.lib                |   11 +-
 scripts/basic/Makefile              |    2 +-
 scripts/basic/hash.c                |   64 ------
 scripts/gcc-goto.sh                 |    5 +
 34 files changed, 991 insertions(+), 209 deletions(-)
 create mode 100644 Documentation/jump-label.txt
 create mode 100644 arch/sparc/include/asm/jump_label.h
 create mode 100644 arch/sparc/kernel/jump_label.c
 create mode 100644 arch/x86/include/asm/jump_label.h
 create mode 100644 arch/x86/kernel/jump_label.c
 create mode 100644 include/linux/jump_label.h
 create mode 100644 kernel/jump_label.c
 delete mode 100644 scripts/basic/hash.c
 create mode 100644 scripts/gcc-goto.sh

