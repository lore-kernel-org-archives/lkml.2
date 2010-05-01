Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956Ab0EACxz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 22:53:55 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41533 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758598Ab0EACxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 22:53:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=evA1/IMRJhGApPsHtYs0v1IMna/xof3+f2HzM03jJJL9lvNkSsAbHc9Dd8+EBc4sbA
         LbuXu0VDI3JWHns8oAeU0HXuESxHiOslRGI0VAOdb4ChQ/wWDLRNpH5xNdlVy1xQWiC7
         mF/D1bbPOAeLw1yo9XYIS/y09jRdicBVv/MPA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL] perf and breakpoints updates
Date: Sat,  1 May 2010 04:53:47 +0200
Message-Id: <1272682436-10682-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/core branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/core

Thanks,
	Frederic
---

Frederic Weisbecker (8):
      perf: Remove leftover useless options to record trace events from scripts
      perf: Fix warning while reading ring buffer headers
      hw-breakpoints: Tag ptrace breakpoint as exclude_kernel
      hw-breakpoints: Check disabled breakpoints again
      hw-breakpoints: Change/Enforce some breakpoints policies
      hw-breakpoints: Separate constraint space for data and instruction breakpoints
      hw-breakpoints: Handle breakpoint weight in allocation constraints
      hw-breakpoints: Get the number of available registers on boot dynamically


 arch/Kconfig                                       |   11 +
 arch/sh/Kconfig                                    |    1 +
 arch/sh/include/asm/hw_breakpoint.h                |   10 +-
 arch/sh/kernel/hw_breakpoint.c                     |   34 +---
 arch/sh/kernel/ptrace_32.c                         |    2 +-
 arch/x86/Kconfig                                   |    1 +
 arch/x86/include/asm/hw_breakpoint.h               |   10 +-
 arch/x86/kernel/hw_breakpoint.c                    |   41 +----
 arch/x86/kernel/ptrace.c                           |    2 +-
 include/linux/hw_breakpoint.h                      |   25 +++-
 kernel/hw_breakpoint.c                             |  196 +++++++++++++++-----
 kernel/trace/trace_ksym.c                          |   26 +--
 tools/perf/Documentation/perf-trace-perl.txt       |    6 +-
 tools/perf/Documentation/perf-trace-python.txt     |   10 +-
 .../perf/scripts/perl/bin/check-perf-trace-record  |    2 +-
 tools/perf/scripts/perl/bin/failed-syscalls-record |    2 +-
 tools/perf/scripts/perl/bin/rw-by-file-record      |    2 +-
 tools/perf/scripts/perl/bin/rw-by-pid-record       |    2 +-
 tools/perf/scripts/perl/bin/rwtop-record           |    2 +-
 tools/perf/scripts/perl/bin/wakeup-latency-record  |    2 +-
 tools/perf/scripts/perl/bin/workqueue-stats-record |    2 +-
 .../python/bin/failed-syscalls-by-pid-record       |    2 +-
 tools/perf/scripts/python/bin/sctop-record         |    2 +-
 .../python/bin/syscall-counts-by-pid-record        |    2 +-
 .../perf/scripts/python/bin/syscall-counts-record  |    2 +-
 tools/perf/util/trace-event-parse.c                |   89 ---------
 tools/perf/util/trace-event-read.c                 |   12 +-
 tools/perf/util/trace-event.h                      |    1 -
 28 files changed, 243 insertions(+), 256 deletions(-)
