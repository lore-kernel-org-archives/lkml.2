Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab0G0Uyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 16:54:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752934Ab0G0Uyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 16:54:38 -0400
Date: Tue, 27 Jul 2010 16:53:58 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
        tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com
Message-Id: <cover.1280263065.git.jbaron@redhat.com>
Subject: [PATCH 00/12] jump label v10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

updates in -v10:

*removed build-time jump table sort. Since I moved to faster lib/sort.c qsort
 method, the run-time sort is really fast. This change also reduces the
 complexity quite a bit.

*added arch_jump_label_text_poke_early(), removing text_poke_early() in generic code. 
 I think for most arches this should be a no-op.

*various Sparc cleanups and build testing on x86_64 using the 4.5 sparc64 cross
 compiler for both 'asm goto' enabled/disabled cases.

*re-ordered the patches, so as to separate out arch bits cleanly

*various cleanups - incorporating last round of feedback and docs update

Special thanks to Tony Breeds for helping me with the sparc64 cross compiler 4.5
toolchain.

thanks,

-Jason

David S. Miller (1):
  sparc64: Add jump_label support

Jason Baron (11):
  jump label: base patch
  jump label: add module support
  jump label: move ftrace_dyn_arch_init to common code
  jump label: initialize workqueue tracepoints *before* they are registered
  jump label: jump_label_text_reserved() to reserve our jump points
  jump label: convert jump label to use a key
  jump label: use lib/sort.c
  jump label: tracepoint support
  jump label: convert dynamic debug to use jump labels.
  jump label: x86 support
  jump label: add docs

 Documentation/jump-label.txt        |  151 +++++++++++++
 Makefile                            |    5 +
 arch/Kconfig                        |    3 +
 arch/sparc/Kconfig                  |    1 +
 arch/sparc/include/asm/jump_label.h |   32 +++
 arch/sparc/kernel/Makefile          |    2 +
 arch/sparc/kernel/jump_label.c      |   39 ++++
 arch/sparc/kernel/module.c          |    6 +
 arch/x86/Kconfig                    |    1 +
 arch/x86/include/asm/alternative.h  |   14 ++
 arch/x86/include/asm/jump_label.h   |   47 ++++
 arch/x86/kernel/Makefile            |    2 +-
 arch/x86/kernel/alternative.c       |   72 ++++++-
 arch/x86/kernel/ftrace.c            |   70 +------
 arch/x86/kernel/jump_label.c        |   49 ++++
 arch/x86/kernel/kprobes.c           |    3 +-
 arch/x86/kernel/module.c            |    3 +
 arch/x86/kernel/setup.c             |    3 +
 include/asm-generic/vmlinux.lds.h   |   10 +
 include/linux/dynamic_debug.h       |   39 ++--
 include/linux/jump_label.h          |   64 ++++++
 include/linux/module.h              |    5 +-
 include/linux/tracepoint.h          |    5 +-
 kernel/Makefile                     |    2 +-
 kernel/jump_label.c                 |  421 +++++++++++++++++++++++++++++++++++
 kernel/kprobes.c                    |    3 +-
 kernel/module.c                     |    7 +
 kernel/trace/ftrace.c               |   13 +-
 kernel/trace/trace_workqueue.c      |   10 +-
 kernel/tracepoint.c                 |   14 +-
 lib/dynamic_debug.c                 |   42 +----
 scripts/Makefile.lib                |   11 +-
 scripts/basic/Makefile              |    2 +-
 scripts/basic/hash.c                |   64 ------
 scripts/gcc-goto.sh                 |    5 +
 35 files changed, 992 insertions(+), 228 deletions(-)
 create mode 100644 Documentation/jump-label.txt
 create mode 100644 arch/sparc/include/asm/jump_label.h
 create mode 100644 arch/sparc/kernel/jump_label.c
 create mode 100644 arch/x86/include/asm/jump_label.h
 create mode 100644 arch/x86/kernel/jump_label.c
 create mode 100644 include/linux/jump_label.h
 create mode 100644 kernel/jump_label.c
 delete mode 100644 scripts/basic/hash.c
 create mode 100644 scripts/gcc-goto.sh

