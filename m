Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab1BGPBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 10:01:05 -0500
Received: from casper.infradead.org ([85.118.1.10]:39155 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab1BGPBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 10:01:03 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        2nddept-manager@sdl.hitachi.co.jp,
        Borislav Petkov <borislav.petkov@amd.com>,
        Denis Kirjanov <dkirjanov@kernel.org>,
        Franck Bui-Huu <fbuihuu@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Kyle McMartin <kyle@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Michael Witten <mfwitten@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 0/9] perf/core improvements and fixes
Date: Mon,  7 Feb 2011 13:00:03 -0200
Message-Id: <1297090812-10782-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core

Regards,

- Arnaldo

Borislav Petkov (1):
  perf annotate: Fix build error

Denis Kirjanov (1):
  perf top: Use pid_t for target_{pid|tid}

Franck Bui-Huu (1):
  perf probe: Rewrite find_lazy_match_lines() by using getline(3)

Kyle McMartin (1):
  perf tool: Fix gcc 4.6.0 issues

Masami Hiramatsu (4):
  tracing/kprobes: Cleanup strict_strtol() using code
  tracing/kprobes: Support longer (>128 bytes) command
  tracing/kprobes: Add bitfield type
  perf probe: Add bitfield member support

Michael Witten (1):
  perf tools: Makefile: Use $(QUIET_GEN) for perf.so

 Documentation/trace/kprobetrace.txt                |   16 ++-
 kernel/trace/trace_kprobe.c                        |  111 +++++++++++++-
 tools/perf/Makefile                                |    2 +-
 tools/perf/bench/sched-pipe.c                      |    2 +-
 tools/perf/builtin-sched.c                         |   12 +-
 tools/perf/builtin-top.c                           |    2 +-
 tools/perf/util/annotate.c                         |    3 -
 tools/perf/util/annotate.h                         |    2 +-
 tools/perf/util/header.c                           |    2 +-
 tools/perf/util/probe-finder.c                     |  165 +++++++++++--------
 .../util/scripting-engines/trace-event-python.c    |    3 +-
 tools/perf/util/symbol.c                           |    4 +-
 tools/perf/util/top.h                              |    4 +-
 tools/perf/util/trace-event-parse.c                |    2 +-
 tools/perf/util/ui/browsers/map.c                  |    2 +-
 15 files changed, 231 insertions(+), 101 deletions(-)

