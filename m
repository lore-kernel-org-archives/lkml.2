Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165Ab2IJWRs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 18:17:48 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:36164 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab2IJWRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 18:17:46 -0400
From: Irina Tirdea <irina.tirdea@gmail.com>
To: mingo@redhat.com, acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        rostedt@goodmis.org
Cc: paulus@samba.org, dsahern@gmail.com, namhyung.kim@lge.com,
        linux-kernel@vger.kernel.org, Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH v3 0/6] Porting perf to Android
Date: Tue, 11 Sep 2012 01:14:57 +0300
Message-Id: <1347315303-29906-1-git-send-email-irina.tirdea@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is version 3 for the patches to port perf to Android.
The patches are on top of current perf/core branch of the tip tree.

Changes for v3:
() update patch 3 according to suggestions from Pekka and Peter
() update patch 6 to replace __used definitions from newly merged code
() add ack from Pekka

Changes for v2:
() dropped the patch that replaced on_exit with at_exit. 
A better solution is the one in Bernhard's patch [1]
() dropped one patch and removed unecessary code from patch 02 after
the removal of unneeded network header files [2]
() added two more patches in order to build perf in Android (patches 10 and 11)
() fixed whitespace anc checkpatch issues for patch 12
() make sure all patches are in txt form and will apply properly

[1] https://lkml.org/lkml/2012/8/23/316
[2] https://lkml.org/lkml/2012/8/29/150

Irina Tirdea (6):
  perf tools: include wrapper for magic.h
  perf tools: update types definitions for Android
  perf tools: include __WORDSIZE definition
  perf tools: fix ALIGN redefinition in system headers
  perf tools: fix no return in non-void function
  perf tools: Use __maybe_used for unused variables

 tools/lib/traceevent/event-parse.c                 |    8 +-
 tools/lib/traceevent/event-parse.h                 |    4 +-
 tools/perf/Makefile                                |    1 +
 tools/perf/bench/bench.h                           |    3 +-
 tools/perf/bench/mem-memcpy.c                      |    2 +-
 tools/perf/bench/mem-memset.c                      |    2 +-
 tools/perf/bench/sched-messaging.c                 |    2 +-
 tools/perf/bench/sched-pipe.c                      |    6 +-
 tools/perf/builtin-annotate.c                      |    2 +-
 tools/perf/builtin-bench.c                         |    2 +-
 tools/perf/builtin-buildid-cache.c                 |    7 +-
 tools/perf/builtin-buildid-list.c                  |    3 +-
 tools/perf/builtin-diff.c                          |    4 +-
 tools/perf/builtin-evlist.c                        |    2 +-
 tools/perf/builtin-help.c                          |    2 +-
 tools/perf/builtin-inject.c                        |   24 +++--
 tools/perf/builtin-kmem.c                          |   22 ++--
 tools/perf/builtin-kvm.c                           |    2 +-
 tools/perf/builtin-list.c                          |    2 +-
 tools/perf/builtin-lock.c                          |    4 +-
 tools/perf/builtin-probe.c                         |   24 ++---
 tools/perf/builtin-record.c                        |   10 +-
 tools/perf/builtin-report.c                        |   11 +-
 tools/perf/builtin-sched.c                         |   69 +++++++------
 tools/perf/builtin-script.c                        |   29 +++---
 tools/perf/builtin-stat.c                          |   40 ++++---
 tools/perf/builtin-test.c                          |    9 +-
 tools/perf/builtin-timechart.c                     |   30 +++---
 tools/perf/builtin-top.c                           |    7 +-
 tools/perf/ui/browser.c                            |    7 +-
 tools/perf/ui/browsers/annotate.c                  |    6 +-
 tools/perf/ui/gtk/browser.c                        |    5 +-
 tools/perf/ui/gtk/setup.c                          |    2 +-
 tools/perf/ui/gtk/util.c                           |    4 +-
 tools/perf/ui/helpline.c                           |    2 +-
 tools/perf/ui/helpline.h                           |    8 +-
 tools/perf/ui/hist.c                               |   21 ++--
 tools/perf/ui/tui/setup.c                          |    4 +-
 tools/perf/util/alias.c                            |    3 +-
 tools/perf/util/annotate.c                         |    6 +-
 tools/perf/util/annotate.h                         |   13 +--
 tools/perf/util/build-id.c                         |   11 +-
 tools/perf/util/cache.h                            |    6 +-
 tools/perf/util/callchain.c                        |    6 +-
 tools/perf/util/cgroup.c                           |    4 +-
 tools/perf/util/config.c                           |    6 +-
 tools/perf/util/debug.h                            |    9 +-
 tools/perf/util/event.c                            |   29 +++---
 tools/perf/util/event.h                            |    2 +-
 tools/perf/util/header.c                           |  109 +++++++++++---------
 tools/perf/util/help.c                             |    3 +-
 tools/perf/util/hist.c                             |    2 +-
 tools/perf/util/hist.h                             |   32 +++---
 tools/perf/util/include/linux/bitops.h             |    4 +
 tools/perf/util/include/linux/compiler.h           |    8 +-
 tools/perf/util/include/linux/kernel.h             |   13 ++-
 tools/perf/util/include/linux/magic.h              |   12 +++
 tools/perf/util/include/linux/types.h              |    8 ++
 tools/perf/util/intlist.c                          |    4 +-
 tools/perf/util/map.h                              |    2 +-
 tools/perf/util/parse-events-test.c                |    6 +-
 tools/perf/util/parse-events.c                     |    7 +-
 tools/perf/util/parse-events.l                     |    2 +-
 tools/perf/util/parse-events.y                     |    4 +-
 tools/perf/util/parse-options.c                    |    3 +-
 tools/perf/util/perf_regs.h                        |    2 +-
 tools/perf/util/pmu.y                              |    6 +-
 tools/perf/util/probe-event.c                      |   21 ++--
 tools/perf/util/probe-finder.c                     |    4 +-
 tools/perf/util/python.c                           |    8 +-
 .../perf/util/scripting-engines/trace-event-perl.c |    8 +-
 .../util/scripting-engines/trace-event-python.c    |   10 +-
 tools/perf/util/session.c                          |   54 +++++-----
 tools/perf/util/sort.c                             |   14 ++-
 tools/perf/util/symbol-minimal.c                   |   28 ++---
 tools/perf/util/symbol.c                           |    4 +-
 tools/perf/util/symbol.h                           |    7 +-
 tools/perf/util/trace-event-parse.c                |    4 +-
 tools/perf/util/trace-event-scripting.c            |   33 +++---
 tools/perf/util/unwind.c                           |   36 ++++---
 tools/perf/util/unwind.h                           |   11 +-
 tools/perf/util/util.h                             |    2 +-
 tools/perf/util/wrapper.c                          |    3 +-
 83 files changed, 545 insertions(+), 416 deletions(-)
 create mode 100644 tools/perf/util/include/linux/magic.h

-- 
1.7.9.5

