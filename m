Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab2JOXeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 19:34:00 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:42032 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab2JOXd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 19:33:58 -0400
From: Irina Tirdea <irina.tirdea@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH v4 0/6] perf tools: fixes for Android
Date: Tue, 16 Oct 2012 02:33:34 +0300
Message-Id: <1350344020-8071-1-git-send-email-irina.tirdea@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Irina Tirdea <irina.tirdea@intel.com>

This is version 4 for the Android fixes.
Thanks for the review! This version contains fixes for issues raised by Arnaldo [1].

Changes v3->v4:
() patch 1: fixed compilation issue when calling make from kernel root directory
() patch 4: renamed try_binutils_path to perf_session_env__lookup_binutils_path
() patch 4: replaced scnprintf + strdup with asprintf
() patch 4: handle errors and print messages in case cross-built objdump is not
found
() patch 3,5: split patch with addr2line changes in 2 patches
() patch 6: set default ret to -ENOMEM in order to avoid setting it every time

[1] https://lkml.org/lkml/2012/10/8/45

Irina Tirdea (5):
  perf tools: configure tmp path at build time
  perf tools: configure shell path at compile time
  perf tools: add --addr2line command line option
  perf tools: Try to find cross-built addr2line path
  perf stat: implement --big-num grouping

Namhyung Kim (1):
  perf tools: Try to find cross-built objdump path

 tools/perf/Documentation/android.txt       |   19 +++
 tools/perf/Documentation/jit-interface.txt |    4 +-
 tools/perf/Documentation/perf-annotate.txt |    2 +
 tools/perf/Documentation/perf-report.txt   |    2 +
 tools/perf/Makefile                        |   36 +++++-
 tools/perf/arch/common.c                   |  184 ++++++++++++++++++++++++++++
 tools/perf/arch/common.h                   |   12 ++
 tools/perf/builtin-annotate.c              |   16 +++
 tools/perf/builtin-help.c                  |    2 +-
 tools/perf/builtin-report.c                |   16 +++
 tools/perf/builtin-script.c                |   12 +-
 tools/perf/builtin-stat.c                  |  106 ++++++++++++++--
 tools/perf/config/feature-tests.mak        |   18 +++
 tools/perf/perf-archive.sh                 |   13 +-
 tools/perf/util/annotate.c                 |   13 +-
 tools/perf/util/annotate.h                 |    1 -
 tools/perf/util/dso-test-data.c            |    2 +-
 tools/perf/util/map.c                      |    3 +-
 tools/perf/util/pmu.c                      |    2 +-
 tools/perf/util/sort.c                     |   15 ++-
 tools/perf/util/symbol.c                   |    4 +-
 tools/perf/util/trace-event-info.c         |    2 +-
 tools/perf/util/vdso.c                     |    2 +-
 23 files changed, 456 insertions(+), 30 deletions(-)
 create mode 100644 tools/perf/arch/common.c
 create mode 100644 tools/perf/arch/common.h

-- 
1.7.9.5

