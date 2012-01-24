Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab2AXXIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 18:08:54 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59184 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab2AXXIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 18:08:21 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>, David Daney <david.daney@cavium.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jan Beulich <jbeulich@suse.com>, Joerg Roedel <joerg.roedel@amd.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com
Subject: [GIT PULL 0/9] perf/core improvements and fixes
Date: Tue, 24 Jan 2012 21:07:52 -0200
Message-Id: <1327446481-5505-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.rc2.1.g69204
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	This is a signed tag, please lemme know if everything went well.

	The --uid feature works for root, we still need to sort out that
paranoia with some threads owned by a user that prevents 'perf --uid
non-root-user' to work for 'non-root-user'.

	http://git.kernel.org/?p=linux/kernel/git/acme/linux.git;a=tag;h=ce9600c4c664ce7f97e8aa5e756b0b4ea5b017c7
looks ok to me, need just to improve on the commit log message, I'll get
used to it :-)

- Arnaldo

The following changes since commit 172d1b0b73256551f100fc00c69e356d047103f5:

  perf tools: Fix compile error on x86_64 Ubuntu (2012-01-08 13:34:55 -0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf-core-for-mingo

for you to fetch changes up to f8f4b2872295dca88339ec0c403b2217b1197353:

  perf tools: Fix strlen() bug in perf_event__synthesize_event_type() (2012-01-24 20:31:34 -0200)

----------------------------------------------------------------
perf/core improvements and fixes

----------------------------------------------------------------
Arnaldo Carvalho de Melo (2):
      perf tools: Add fprintf methods for thread_map and cpu_map classes
      perf tools: Introduce per user view

David Daney (1):
      perf tools: Fix broken build by defining _GNU_SOURCE in Makefile

Jan Beulich (4):
      perf bench: Make "default" memcpy() selection actually use glibc's implementation
      perf bench: Also allow measuring alternative memcpy implementations
      perf bench: Also allow measuring memset()
      perf bench: Allow passing an iteration count to "bench mem mem{cpy,set}"

Srikar Dronamraju (1):
      perf probe: Usability fixes

Stephane Eranian (1):
      perf tools: Fix strlen() bug in perf_event__synthesize_event_type()

 tools/perf/Documentation/perf-record.txt     |    4 +
 tools/perf/Documentation/perf-top.txt        |    4 +
 tools/perf/Makefile                          |   11 +-
 tools/perf/bench/bench.h                     |    1 +
 tools/perf/bench/mem-memcpy-x86-64-asm-def.h |    8 +
 tools/perf/bench/mem-memcpy-x86-64-asm.S     |    6 +-
 tools/perf/bench/mem-memcpy.c                |   11 +-
 tools/perf/bench/mem-memset-arch.h           |   12 +
 tools/perf/bench/mem-memset-x86-64-asm-def.h |   12 +
 tools/perf/bench/mem-memset-x86-64-asm.S     |    6 +
 tools/perf/bench/mem-memset.c                |  298 ++++++++++++++++++++++++++
 tools/perf/builtin-bench.c                   |    3 +
 tools/perf/builtin-probe.c                   |    2 -
 tools/perf/builtin-record.c                  |   12 +-
 tools/perf/builtin-stat.c                    |    2 +-
 tools/perf/builtin-test.c                    |    8 +-
 tools/perf/builtin-top.c                     |   22 ++-
 tools/perf/perf.h                            |    1 +
 tools/perf/util/cpumap.c                     |   11 +
 tools/perf/util/cpumap.h                     |    4 +
 tools/perf/util/evlist.c                     |    6 +-
 tools/perf/util/evlist.h                     |    2 +-
 tools/perf/util/header.c                     |    2 +-
 tools/perf/util/hist.h                       |    1 +
 tools/perf/util/include/asm/dwarf2.h         |    4 +-
 tools/perf/util/probe-event.c                |    8 +-
 tools/perf/util/python.c                     |   10 +-
 tools/perf/util/symbol.c                     |    1 -
 tools/perf/util/thread_map.c                 |  109 +++++++++-
 tools/perf/util/thread_map.h                 |    7 +-
 tools/perf/util/top.c                        |    3 +
 tools/perf/util/top.h                        |    2 +
 tools/perf/util/trace-event-parse.c          |    3 +-
 tools/perf/util/ui/browsers/hists.c          |    5 +-
 tools/perf/util/ui/helpline.c                |    1 -
 tools/perf/util/usage.c                      |   39 ++++
 tools/perf/util/util.h                       |    3 +-
 37 files changed, 597 insertions(+), 47 deletions(-)
 create mode 100644 tools/perf/bench/mem-memset-arch.h
 create mode 100644 tools/perf/bench/mem-memset-x86-64-asm-def.h
 create mode 100644 tools/perf/bench/mem-memset-x86-64-asm.S
 create mode 100644 tools/perf/bench/mem-memset.c
