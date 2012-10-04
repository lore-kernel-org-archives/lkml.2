Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab2JDSJE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 14:09:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:39692 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab2JDSJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 14:09:00 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Arun Sharma <asharma@fb.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Dong Hao <haodong@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Irina Tirdea <irina.tirdea@gmail.com>,
        Irina Tirdea <irina.tirdea@intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        arnaldo.melo@gmail.com, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/42] perf/core improvements and fixes
Date: Thu,  4 Oct 2012 15:08:00 -0300
Message-Id: <1349374122-27806-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit 29a0fc9b2b6084e7a8810481df62a0fa496d8957:

  perf tools: Convert to LIBELF_SUPPORT (2012-09-28 21:07:36 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to 139c0815903de1a7865fe1d6beac5e995fefdf46:

  perf hists: Add more helpers for hist entry stat (2012-10-04 13:36:18 -0300)

----------------------------------------------------------------
perf/core improvements and fixes

. Remove several cases of needless global variables, on most builtins.

. Look up thread using tid instead of pid in 'perf sched'.

. Move global variables into a perf_kvm struct, from David Ahern.

. Hists refactorings, preparatory for improved 'diff' command, from Jiri Olsa.

. Hists refactorings, preparatory for event group viewieng work, from Namhyung Kim.

. Remove double negation on optional feature macro definitions, from Namhyung Kim.

. Bash auto completion improvements, now we can auto complete the tools long
  options, tracepoint event names, etc, from Namhyung Kim.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (19):
      perf trace: Use evsel->handler.func
      perf inject: Remove unused 'input_name' static var
      perf inject: Remove static variables
      perf sched: Look up thread using tid instead of pid
      perf stat: Don't use globals where not needed to
      perf script: Don't use globals where not needed to
      perf help: Don't use globals where not needed to
      perf kmem: Don't use globals where not needed to
      perf lock: Don't use globals where not needed to
      perf timechart: Don't use globals where not needed to
      perf buildid-cache: Don't use globals where not needed to
      perf buildid-list: Don't use globals where not needed to
      perf probe: Don't use globals where not needed to
      perf top: Don't use globals where not needed to
      perf evlist: Don't use globals where not needed to
      perf record: Don't use globals where not needed to
      perf inject: Don't use globals where not needed to
      perf evlist: Introduce add_newtp method
      perf evlist: Remove some unused methods

David Ahern (1):
      perf kvm: Move global variables into a perf_kvm struct

Jiri Olsa (6):
      perf hists: Add struct hists pointer to struct hist_entry
      perf diff: Refactor diff displacement possition info
      perf hists: Separate overhead and baseline columns
      perf tools: Removing hists pair argument from output path
      perf tool: Add hpp interface to enable/disable hpp column
      perf diff: Removing the total_period argument from output code

Namhyung Kim (13):
      perf tools: Convert to LIBUNWIND_SUPPORT
      perf tools: Convert to LIBAUDIT_SUPPORT
      perf tools: Convert to NEWT_SUPPORT
      perf tools: Convert to GTK2_SUPPORT
      perf tools: Convert to HAVE_STRLCPY
      perf tools: Check existence of _get_comp_words_by_ref when bash completing
      perf tools: Complete long option names of perf command
      perf tools: Long option completion support for each subcommands
      perf tools: Convert to BACKTRACE_SUPPORT
      perf tools: Complete tracepoint event names
      perf hists: Introduce struct he_stat
      perf hists: Move he->stat.nr_events initialization to a template
      perf hists: Add more helpers for hist entry stat

 tools/perf/Makefile                |   46 ++--
 tools/perf/bash_completion         |   50 +++-
 tools/perf/builtin-buildid-cache.c |   58 ++---
 tools/perf/builtin-buildid-list.c  |   55 ++---
 tools/perf/builtin-diff.c          |   68 ++++--
 tools/perf/builtin-evlist.c        |   21 +-
 tools/perf/builtin-help.c          |   40 ++--
 tools/perf/builtin-inject.c        |   86 +++----
 tools/perf/builtin-kmem.c          |   66 ++----
 tools/perf/builtin-kvm.c           |  460 ++++++++++++++++++++----------------
 tools/perf/builtin-lock.c          |   90 +++----
 tools/perf/builtin-probe.c         |   26 +-
 tools/perf/builtin-record.c        |   27 ++-
 tools/perf/builtin-report.c        |    4 +-
 tools/perf/builtin-sched.c         |    2 +-
 tools/perf/builtin-script.c        |   90 ++++---
 tools/perf/builtin-stat.c          |  328 +++++++++++++------------
 tools/perf/builtin-timechart.c     |  100 ++++----
 tools/perf/builtin-top.c           |   11 +-
 tools/perf/builtin-trace.c         |  134 +++++++----
 tools/perf/perf.c                  |    2 +-
 tools/perf/ui/browsers/hists.c     |   12 +-
 tools/perf/ui/gtk/browser.c        |    6 +-
 tools/perf/ui/gtk/util.c           |    2 +-
 tools/perf/ui/helpline.h           |   18 +-
 tools/perf/ui/hist.c               |  145 +++++++-----
 tools/perf/ui/setup.c              |    2 +-
 tools/perf/ui/stdio/hist.c         |   45 ++--
 tools/perf/util/annotate.h         |    8 +-
 tools/perf/util/cache.h            |   38 +--
 tools/perf/util/debug.c            |    2 +-
 tools/perf/util/debug.h            |   17 +-
 tools/perf/util/evlist.c           |   88 +------
 tools/perf/util/evlist.h           |   18 +-
 tools/perf/util/hist.c             |   66 ++++--
 tools/perf/util/hist.h             |   38 ++-
 tools/perf/util/parse-options.c    |    8 +
 tools/perf/util/parse-options.h    |    1 +
 tools/perf/util/path.c             |    2 +-
 tools/perf/util/perf_regs.h        |    4 +-
 tools/perf/util/sort.h             |   19 +-
 tools/perf/util/unwind.h           |    4 +-
 tools/perf/util/util.c             |    4 +-
 43 files changed, 1172 insertions(+), 1139 deletions(-)
