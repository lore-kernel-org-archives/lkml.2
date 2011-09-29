Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628Ab1I2Wsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 18:48:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:43983 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756792Ab1I2Wsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 18:48:37 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jim Cromie <jim.cromie@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Neil Horman <nhorman@tuxdriver.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, arnaldo.melo@gmail.com
Subject: [GIT PULL 00/16] perf/core improvements and fixes
Date: Thu, 29 Sep 2011 19:47:54 -0300
Message-Id: <1317336490-19437-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://github.com/acmel/linux.git perf/core

	This was rebased against your perf/core on tesla.

Regards,

- Arnaldo

Andi Kleen (2):
  perf tools: Make stat/record print fatal signals of the target program
  perf: Support setting the disassembler style

Arnaldo Carvalho de Melo (6):
  perf symbols: Stop using 'self' in map_groups__ methods
  perf buildid-list: Add option to show the running kernel build id
  perf buildid-list: Support showing the build id in an ELF file
  perf top browser: Fix up line width calculation
  perf top: Improve lost events warning
  perf report: Fix stdio event name header printing

Jim Cromie (5):
  perf stat: Add --log-fd <N> option to redirect stderr elsewhere
  perf stat: Fix +- nan% in --no-aggr runs
  perf stat: Suppress printing std-dev when its 0
  perf stat: Allow tab as cvs delimiter
  perf stat: Fix spelling in comment

Jiri Olsa (2):
  perf sched: Fix script command documentation
  perf symbols: Treat all memory maps without dso file as loaded

Neil Horman (1):
  perf script: Add drop monitor script

 tools/perf/Documentation/perf-annotate.txt         |    3 +
 tools/perf/Documentation/perf-buildid-list.txt     |    6 +
 tools/perf/Documentation/perf-report.txt           |    3 +
 tools/perf/Documentation/perf-sched.txt            |    6 +-
 tools/perf/Documentation/perf-stat.txt             |   11 ++-
 tools/perf/builtin-annotate.c                      |    2 +
 tools/perf/builtin-buildid-list.c                  |   52 ++++++++++-
 tools/perf/builtin-record.c                        |   19 ++++-
 tools/perf/builtin-report.c                        |    7 +-
 tools/perf/builtin-stat.c                          |   35 ++++++-
 tools/perf/builtin-top.c                           |   34 ++++----
 .../perf/scripts/python/bin/net_dropmonitor-record |    2 +
 .../perf/scripts/python/bin/net_dropmonitor-report |    4 +
 tools/perf/scripts/python/net_dropmonitor.py       |   72 ++++++++++++++
 tools/perf/util/annotate.c                         |    6 +-
 tools/perf/util/annotate.h                         |    2 +
 tools/perf/util/map.c                              |   98 +++++++++++---------
 tools/perf/util/map.h                              |   42 ++++----
 tools/perf/util/top.h                              |    3 +
 tools/perf/util/ui/browsers/top.c                  |   28 +++++-
 20 files changed, 333 insertions(+), 102 deletions(-)
 create mode 100755 tools/perf/scripts/python/bin/net_dropmonitor-record
 create mode 100755 tools/perf/scripts/python/bin/net_dropmonitor-report
 create mode 100755 tools/perf/scripts/python/net_dropmonitor.py

