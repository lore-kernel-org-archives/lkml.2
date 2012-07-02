Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697Ab2GBUT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 16:19:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48109 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932878Ab2GBUTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 16:19:22 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Arun Sharma <asharma@fb.com>,
        Benjamin Redelings <benjamin.redelings@nescent.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>, David Ahern <dsahern@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hitoshi Mitake <h.mitake@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Jovi Zhang <bookjovi@gmail.com>,
        Konstantin Stepanyuk <konstantin.stepanyuk@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
        Ulrich Drepper <drepper@gmail.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/13] perf/core fixes and improvements
Date: Mon,  2 Jul 2012 17:18:38 -0300
Message-Id: <1341260331-10204-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit add79461a2a7d964a00b4a2fdaf313c4cf9cf4ec:

  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2012-06-29 15:11:26 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to 17d7a1123f0f6d532830152564cc812cc73db2f3:

  perf bench: Fix confused variable namings and descriptions in mem subsystem (2012-07-02 14:35:45 -0300)

----------------------------------------------------------------
perf/core improvements and fixes

. Fix libtraceevent 'clean' make target, from Namhyung Kim

. Teach ctags about libtraceevent error codes, from Namhyung Kim

. Fix libtraceevent dependency files usage, from Namhyung Kim

. Support hex number pretty printing in libtraceevent, fixing
  kvm output, from Namhyung Kim

. Kill some die() usage in libtraceevent, from Namhyung Kim

. Improve support for hw breakpoints parsing/pretty printing/testing,
  from Jiri Olsa

. Clarify perf bench option naming, from Hitoshi Mitake

. Look for ".note" ELF notes too, used in the kernel vdso, from Jiri Olsa

. Fix internal PMU list usage, removing leak, from Robert Richter

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Hitoshi Mitake (1):
      perf bench: Fix confused variable namings and descriptions in mem subsystem

Jiri Olsa (4):
      perf tools: Fix hw breakpoint's type modifier parsing
      perf evsel: Handle hw breakpoints event names in perf_evsel__name()
      perf symbols: Add '.note' check into search for NOTE section
      perf tools: Adding round_up/round_down macros

Konstantin Stepanyuk (1):
      tools lib traceevent: Fix clean target in Makefile

Namhyung Kim (6):
      tools lib traceevent: Teach [ce]tags about libtraceeevent error codes
      tools lib traceevent: Make dependency files regeneratable
      tools lib traceevent: Check string is really printable
      tools lib traceevent: Use local variable 'field'
      tools lib traceevent: Add support for __print_hex()
      tools lib traceevent: Replace malloc_or_die to plain malloc in alloc_event()

Robert Richter (1):
      perf tools: Fix generation of pmu list

 tools/lib/traceevent/Makefile                      |   14 ++-
 tools/lib/traceevent/event-parse.c                 |  112 ++++++++++++++++++--
 tools/lib/traceevent/event-parse.h                 |    7 ++
 tools/perf/Documentation/perf-bench.txt            |    4 +-
 tools/perf/bench/mem-memcpy.c                      |   80 +++++++-------
 tools/perf/bench/mem-memset.c                      |   80 +++++++-------
 tools/perf/util/evsel.c                            |   30 ++++++
 tools/perf/util/include/linux/kernel.h             |   10 ++
 tools/perf/util/parse-events-test.c                |   47 ++++++++
 tools/perf/util/parse-events.c                     |   20 ++--
 tools/perf/util/parse-events.l                     |    2 +-
 tools/perf/util/pmu.c                              |    3 +-
 .../perf/util/scripting-engines/trace-event-perl.c |    4 +
 .../util/scripting-engines/trace-event-python.c    |    4 +
 tools/perf/util/symbol.c                           |   29 +++--
 15 files changed, 335 insertions(+), 111 deletions(-)
