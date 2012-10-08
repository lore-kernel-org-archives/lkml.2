Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab2JHGoL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 02:44:11 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45412 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab2JHGoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 02:44:09 -0400
From: Irina Tirdea <irina.tirdea@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH 0/8] perf tools: fixes for Android
Date: Mon,  8 Oct 2012 09:43:25 +0300
Message-Id: <1349678613-7045-1-git-send-email-irina.tirdea@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Irina Tirdea <irina.tirdea@intel.com>

Hi,

I have gathered in this set all remaining patches with Android fixes.

Starting from Bernhard's patch [1], I added 2 patches (patch 1 and 2) that
include on_exit implementation and Android support in the Makefile.
I have also added some documentation on building for Android (patch 3).

I have included version 3 for the patchset "perf: android: configure hardcoded
paths" [2]. Changes for v3:
() add documentation and update Makefile for Android for patch 4 and 5
() move the detection of cross-build objdump path in one file (common.c) so that
is available for addr2line as well. (patch 6)
() implement detection of cross-build path for addr2line (patch 7)

I have also included version 3 for the patch "perf stat: implement --big-num
grouping" [3] (patch 8). Changes for v3:
() replace LOCALE_SUPPORT with NO_LOCALE for consistency with recent changes
done by Namhyung

Thanks,
Irina

[1] https://lkml.org/lkml/2012/8/23/316
[2] https://lkml.org/lkml/2012/9/23/100
[3] https://lkml.org/lkml/2012/9/23/128

Bernhard Rosenkraenzer (1):
  perf tools: add on_exit implementation

Irina Tirdea (6):
  perf tools: update Makefile for Android
  Documentation: add documentation on compiling for Android
  perf tools: configure tmp path at build time
  perf tools: configure shell path at compile time
  perf tools: configure addr2line for cross-compiling
  perf stat: implement --big-num grouping

Namhyung Kim (1):
  perf tools: Try to find cross-built objdump path

 tools/perf/Documentation/android.txt       |   94 ++++++++++++++++
 tools/perf/Documentation/jit-interface.txt |    4 +-
 tools/perf/Documentation/perf-annotate.txt |    2 +
 tools/perf/Documentation/perf-report.txt   |    2 +
 tools/perf/Makefile                        |   64 +++++++++--
 tools/perf/arch/common.c                   |  164 ++++++++++++++++++++++++++++
 tools/perf/arch/common.h                   |   12 ++
 tools/perf/builtin-annotate.c              |    9 ++
 tools/perf/builtin-help.c                  |    2 +-
 tools/perf/builtin-record.c                |   32 ++++++
 tools/perf/builtin-report.c                |    7 ++
 tools/perf/builtin-script.c                |   12 +-
 tools/perf/builtin-stat.c                  |  112 +++++++++++++++++--
 tools/perf/config/feature-tests.mak        |   38 ++++++-
 tools/perf/perf-archive.sh                 |   13 ++-
 tools/perf/util/annotate.c                 |   13 ++-
 tools/perf/util/annotate.h                 |    1 -
 tools/perf/util/dso-test-data.c            |    2 +-
 tools/perf/util/map.c                      |    3 +-
 tools/perf/util/pmu.c                      |    2 +-
 tools/perf/util/sort.c                     |   16 ++-
 tools/perf/util/symbol.c                   |    4 +-
 tools/perf/util/trace-event-info.c         |    2 +-
 23 files changed, 574 insertions(+), 36 deletions(-)
 create mode 100644 tools/perf/Documentation/android.txt
 create mode 100644 tools/perf/arch/common.c
 create mode 100644 tools/perf/arch/common.h

-- 
1.7.9.5

