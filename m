Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab2H1V7M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 17:59:12 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36458 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab2H1V7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 17:59:11 -0400
MIME-Version: 1.0
From: Irina Tirdea <irina.tirdea@gmail.com>
Date: Wed, 29 Aug 2012 00:58:50 +0300
Message-ID: <CANg8OWKBjawB4DQK=NQsYKYcOffA30L7Mgm5oiVjnKvMVR2AZw@mail.gmail.com>
Subject: [PATCH 00/13] Porting perf to Android
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a set of patches to port perf to Android.
My approach is to include missing functions in Android (like getline,
getsid, etc). I am currently working on upstreaming these to Google.
With the missing functionality added to bionic, this compiles on latest
Android tree (JellyBean). This will make perf compile, but there are still
fixes needed at runtime which I am currently working on.

I have seen that another patch that ports perf to Android was recently
submitted to this list. The approach is different and there are also
changes that do not overlap. If the other patch will be merged first, I
will rebase my work on top of it.

Thank you,
Irina

--

Irina Tirdea (13):
  perf tools: include wrapper for magic.h
  perf tools: update types definitions for Android
  perf tools: drop asm/byteorder.h wrapper
  perf tools: include __WORDSIZE definition
  perf tools: fix ALIGN redefinition in system headers
  perf tools: include basename for non-glibc systems
  perf tools: fix missing winsize definition
  perf tools: Use __maybe_used for unused variables
  perf tools: include missing pthread.h header
  perf tools: fix non-void function without return statement
  perf tools: replace mempcpy with memcpy
  perf tools: replace on_exit with atexit
  perf tools: replace mkostemp with mkstemp

 tools/perf/Makefile                      |    2 +-
 tools/perf/bench/bench.h                 |    2 +-
 tools/perf/bench/mem-memcpy.c            |    2 +-
 tools/perf/bench/mem-memset.c            |    2 +-
 tools/perf/bench/sched-messaging.c       |    2 +-
 tools/perf/bench/sched-pipe.c            |    4 +-
 tools/perf/builtin-annotate.c            |    2 +-
 tools/perf/builtin-bench.c               |    2 +-
 tools/perf/builtin-buildid-cache.c       |    6 +--
 tools/perf/builtin-buildid-list.c        |    2 +-
 tools/perf/builtin-diff.c                |    4 +-
 tools/perf/builtin-evlist.c              |    2 +-
 tools/perf/builtin-help.c                |    2 +-
 tools/perf/builtin-inject.c              |   20 +++----
 tools/perf/builtin-kmem.c                |   20 +++----
 tools/perf/builtin-kvm.c                 |    2 +-
 tools/perf/builtin-list.c                |    2 +-
 tools/perf/builtin-lock.c                |    4 +-
 tools/perf/builtin-probe.c               |   24 ++++-----
 tools/perf/builtin-record.c              |   24 +++++----
 tools/perf/builtin-report.c              |   10 ++--
 tools/perf/builtin-sched.c               |   64 +++++++++++------------
 tools/perf/builtin-script.c              |   16 +++---
 tools/perf/builtin-stat.c                |   24 ++++-----
 tools/perf/builtin-test.c                |    6 +--
 tools/perf/builtin-timechart.c           |   28 +++++-----
 tools/perf/builtin-top.c                 |    6 +--
 tools/perf/perf.c                        |    1 +
 tools/perf/ui/browser.c                  |    6 +--
 tools/perf/ui/browsers/annotate.c        |    4 +-
 tools/perf/ui/gtk/browser.c              |    4 +-
 tools/perf/ui/gtk/setup.c                |    2 +-
 tools/perf/ui/gtk/util.c                 |    4 +-
 tools/perf/ui/helpline.c                 |    2 +-
 tools/perf/ui/helpline.h                 |    8 +--
 tools/perf/ui/tui/setup.c                |    4 +-
 tools/perf/util/alias.c                  |    2 +-
 tools/perf/util/annotate.c               |    6 +--
 tools/perf/util/annotate.h               |   13 ++---
 tools/perf/util/build-id.c               |   10 ++--
 tools/perf/util/cache.h                  |    6 +--
 tools/perf/util/callchain.c              |    6 +--
 tools/perf/util/cgroup.c                 |    4 +-
 tools/perf/util/config.c                 |    4 +-
 tools/perf/util/debug.h                  |    8 +--
 tools/perf/util/dso-test-data.c          |    2 +-
 tools/perf/util/event.c                  |   28 +++++-----
 tools/perf/util/event.h                  |    2 +-
 tools/perf/util/header.c                 |   84
+++++++++++++++---------------
 tools/perf/util/help.c                   |    3 +-
 tools/perf/util/hist.c                   |    2 +-
 tools/perf/util/hist.h                   |   30 +++++------
 tools/perf/util/include/asm/byteorder.h  |    2 -
 tools/perf/util/include/asm/swab.h       |    2 +-
 tools/perf/util/include/linux/bitops.h   |    9 ++++
 tools/perf/util/include/linux/compiler.h |    6 ++-
 tools/perf/util/include/linux/kernel.h   |   15 +++++-
 tools/perf/util/include/linux/magic.h    |   12 +++++
 tools/perf/util/include/linux/types.h    |   15 ++++++
 tools/perf/util/intlist.c                |    6 +--
 tools/perf/util/map.h                    |    2 +-
 tools/perf/util/parse-events-test.c      |    6 +--
 tools/perf/util/parse-events.c           |    6 +--
 tools/perf/util/parse-events.l           |    3 +-
 tools/perf/util/parse-events.y           |    4 +-
 tools/perf/util/parse-options.c          |    2 +-
 tools/perf/util/perf_regs.h              |    2 +-
 tools/perf/util/pmu.y                    |    6 +--
 tools/perf/util/probe-finder.c           |    4 +-
 tools/perf/util/python.c                 |    6 +--
 tools/perf/util/session.c                |   50 +++++++++---------
 tools/perf/util/sort.c                   |   10 ++--
 tools/perf/util/symbol-minimal.c         |   24 ++++-----
 tools/perf/util/symbol.c                 |    4 +-
 tools/perf/util/symbol.h                 |    9 ++--
 tools/perf/util/target.c                 |    4 +-
 tools/perf/util/top.h                    |    1 +
 tools/perf/util/unwind.c                 |   32 ++++++------
 tools/perf/util/unwind.h                 |   10 ++--
 tools/perf/util/util.h                   |    3 +-
 tools/perf/util/wrapper.c                |    2 +-
 81 files changed, 424 insertions(+), 362 deletions(-)
 delete mode 100644 tools/perf/util/include/asm/byteorder.h
 create mode 100644 tools/perf/util/include/linux/magic.h

-- 
1.7.9.5
