Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab2IWT1w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 15:27:52 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:41111 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab2IWT1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 15:27:51 -0400
From: Irina Tirdea <irina.tirdea@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH v2 0/4] perf: android: configure hardcoded paths
Date: Sun, 23 Sep 2012 22:27:22 +0300
Message-Id: <1348428446-28245-1-git-send-email-irina.tirdea@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Irina Tirdea <irina.tirdea@intel.com>

This is version 2 of the set of patches that replace hardcoded paths used
in perf with configurable options in the Makefile.

First version can be found at https://lkml.org/lkml/2012/9/20/537.

Thanks everybody for the reviews! This version fixes all issues mentioned in
reviews.

Changes for v2:
() updated tools/perf/Documentation/jit-interface.txt regarding PERF_TMP_DIR
(patch 1)
() fixed hardcoded size for PERF_TMP_DIR"/perf-"  (patch 1)
() use PERF_SHELL_PATH instead of PERF_SHELL_DIR  (patch 2)
() use DEFAULT_OBJDUMP_PATH and DEFAULT_ADDR2LINE_PATH (patch 3,4)
() add CROSS_COMPILE prefix to addr2line and objdump in Makefile (patch 3,4)

Thanks,
Irina

Irina Tirdea (4):
  perf tools: configure tmp path at build time
  perf tools: configure shell path at compile time
  perf annotate: configure objdump path at compile time
  perf tools: configure addr2line path at compile time

 tools/perf/Documentation/jit-interface.txt |    4 +++-
 tools/perf/Makefile                        |   30 ++++++++++++++++++++++++++--
 tools/perf/builtin-help.c                  |    2 +-
 tools/perf/builtin-script.c                |   12 +++++------
 tools/perf/perf-archive.sh                 |   13 ++++++++++--
 tools/perf/util/annotate.c                 |    5 +++--
 tools/perf/util/dso-test-data.c            |    2 +-
 tools/perf/util/map.c                      |    3 ++-
 tools/perf/util/pmu.c                      |    2 +-
 tools/perf/util/sort.c                     |    2 +-
 tools/perf/util/symbol.c                   |    4 +++-
 tools/perf/util/trace-event-info.c         |    2 +-
 12 files changed, 61 insertions(+), 20 deletions(-)

-- 
1.7.9.5

