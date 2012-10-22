Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab2JVJqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 05:46:39 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54597 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab2JVJqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 05:46:38 -0400
From: Irina Tirdea <irina.tirdea@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH v5 0/6] perf tools: fixes for Android
Date: Mon, 22 Oct 2012 12:46:06 +0300
Message-Id: <1350899172-16965-1-git-send-email-irina.tirdea@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Irina Tirdea <irina.tirdea@intel.com>

This is version 5 for the Android fixes. Previous version can be found at [1].

The patches are on top of current perf/core branch from Arnaldo's git tree
(git.kernel.org/pub/scm/linux/kernel/git/acme/linux).

Changes v4->v5:
() make PERF_TMP_DIR and PERF_SHELL_PATH available to all source files
(patch 1 & 2) (Arnaldo)
() split addr2line changes in 2 patches (patch 3 & 5) (Arnaldo)

Changes v3->v4:
() patch 1: fixed compilation issue when calling make from kernel root directory
() patch 4: renamed try_binutils_path to perf_session_env__lookup_binutils_path
() patch 4: replaced scnprintf + strdup with asprintf
() patch 4: handle errors and print messages in case cross-built objdump is not
found
() patch 3,5: split patch with addr2line changes in 2 patches
() patch 6: set default ret to -ENOMEM in order to avoid setting it every time

Thanks,
Irina

[1] https://lkml.org/lkml/2012/10/15/633

Irina Tirdea (6):
  perf tools: configure tmp path at build time
  perf tools: configure shell path at compile time
  perf tools: add --addr2line command line option
  perf tools: Try to find cross-built addr2line path
  perf tools: fix using --sysroot with addr2line
  perf stat: implement --big-num grouping

 tools/perf/Documentation/android.txt       |   19 +++++
 tools/perf/Documentation/jit-interface.txt |    4 +-
 tools/perf/Documentation/perf-annotate.txt |    2 +
 tools/perf/Documentation/perf-report.txt   |    2 +
 tools/perf/Makefile                        |   12 +++-
 tools/perf/arch/common.c                   |    6 ++
 tools/perf/arch/common.h                   |    2 +
 tools/perf/builtin-annotate.c              |    9 +++
 tools/perf/builtin-help.c                  |    2 +-
 tools/perf/builtin-report.c                |    9 +++
 tools/perf/builtin-script.c                |   12 ++--
 tools/perf/builtin-stat.c                  |  106 ++++++++++++++++++++++++++--
 tools/perf/config/feature-tests.mak        |   18 +++++
 tools/perf/perf-archive.sh                 |   13 +++-
 tools/perf/util/annotate.c                 |   13 +++-
 tools/perf/util/dso-test-data.c            |    2 +-
 tools/perf/util/map.c                      |    3 +-
 tools/perf/util/pmu.c                      |    2 +-
 tools/perf/util/sort.c                     |   17 ++++-
 tools/perf/util/symbol.c                   |    4 +-
 tools/perf/util/trace-event-info.c         |    2 +-
 tools/perf/util/vdso.c                     |    2 +-
 22 files changed, 233 insertions(+), 28 deletions(-)

-- 
1.7.9.5

