Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab0IWD4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 23:56:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50745 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab0IWD4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 23:56:08 -0400
X-Authority-Analysis: v=1.1 cv=GglhOq9PVtWDmzXFaQc2b9ix+3dKCE90LyQFAZ1FxMQ= c=1 sm=0 a=1Gtjo3wpoQIA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=m5rYXYtuimWiuXPNHdQA:9 a=WOO7IzaGpEHKhkop_W0A:7 a=FC2EjwGVSDQMUJhxIXyzmwa_Pl8A:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20100923034910.867858597@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 22 Sep 2010 23:49:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <compudj@krystal.dyndns.org>,
        Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>,
        David Miller <davem@davemloft.net>
Subject: [GIT PULL] jump label: add jump label code 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I finally got around to doing some basic tests. The thing that
took the longest, was setting up all my distcc computers with gcc 2.5.1.
I also hit a little glitch in one of my tests that would trigger
RCU stalls, but that's another story.

Anyway, I took Jason's patches and applied them, with a few
formatting clean ups (basically, shortened function prototypes).

I added two patches at the end of the series to remove the duplicate
structure and also to remove the dependency on !CC_OPTIMIZE_FOR_SIZE.

Andi,

I saw your patches but have not had time to take a deeper look at
them. If you want, you can rebase them against this tree.

Thanks,

Please pull the latest tip/perf/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/core


David S. Miller (1):
      jump label: Add sparc64 support

Jason Baron (8):
      jump label: Make dynamic no-op selection available outside of ftrace
      jump label: Make text_poke_early() globally visible
      jump label: Base patch for jump label
      jump label: Initialize workqueue tracepoints *before* they are registered
      jump label: Add jump_label_text_reserved() to reserve jump points
      jump label: Tracepoint support for jump labels
      jump label: Convert dynamic debug to use jump labels
      jump label: x86 support

Steven Rostedt (2):
      jump label: Remove duplicate structure for x86
      jump label/x86/sparc64: Remove !CC_OPTIMIZE_FOR_SIZE config conditions

----
 Makefile                            |    5 +
 arch/Kconfig                        |    3 +
 arch/sparc/Kconfig                  |    1 +
 arch/sparc/include/asm/jump_label.h |   32 +++
 arch/sparc/kernel/Makefile          |    2 +
 arch/sparc/kernel/jump_label.c      |   47 ++++
 arch/sparc/kernel/module.c          |    6 +
 arch/x86/Kconfig                    |    1 +
 arch/x86/include/asm/alternative.h  |   11 +
 arch/x86/include/asm/jump_label.h   |   37 +++
 arch/x86/kernel/Makefile            |    2 +-
 arch/x86/kernel/alternative.c       |   68 ++++++-
 arch/x86/kernel/ftrace.c            |   63 +-----
 arch/x86/kernel/jump_label.c        |   50 ++++
 arch/x86/kernel/kprobes.c           |    3 +-
 arch/x86/kernel/module.c            |    3 +
 arch/x86/kernel/setup.c             |    6 +
 include/asm-generic/vmlinux.lds.h   |   10 +
 include/linux/dynamic_debug.h       |   39 ++--
 include/linux/jump_label.h          |   64 ++++++
 include/linux/module.h              |    5 +-
 include/linux/tracepoint.h          |    5 +-
 kernel/Makefile                     |    2 +-
 kernel/jump_label.c                 |  429 +++++++++++++++++++++++++++++++++++
 kernel/kprobes.c                    |    4 +-
 kernel/module.c                     |    6 +
 kernel/trace/trace_workqueue.c      |   10 +-
 kernel/tracepoint.c                 |   14 +-
 lib/dynamic_debug.c                 |   42 +----
 scripts/Makefile.lib                |   11 +-
 scripts/basic/Makefile              |    2 +-
 scripts/basic/hash.c                |   64 ------
 scripts/gcc-goto.sh                 |    5 +
 33 files changed, 843 insertions(+), 209 deletions(-)
