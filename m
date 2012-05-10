Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758451Ab2EJRST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:18:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:60514 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758363Ab2EJRSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:18:14 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Arun Sharma <asharma@fb.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>, David Ahern <dsahern@gmail.com>,
        "Frank C. Eigler" <fche@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, Ulrich Drepper <drepper@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/16] perf/core fixes and improvements
Date: Thu, 10 May 2012 14:17:29 -0300
Message-Id: <1336670265-20401-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	This is on top of a 15 patches long series still outstanding on my
perf/core branch, please consider pulling,

- Arnaldo

The following changes since commit dc41b9b8f02dbe2228ae787d525dac43beebb7fa:

  perf ui: Change fallback policy of setup_browser() (2012-05-02 16:17:37 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to 5a5626b1b4bf8467891c9297ffda979db97ed5ec:

  perf hists browser: Use '/' for search/filter instead of 's' (2012-05-10 13:07:59 -0300)

----------------------------------------------------------------
Fixes and improvements for perf/core:

. perf_target: abstraction for --uid, --pid, --tid, --cpu, --all-cpus handling,
  eliminating code duplicated in the tools, having constraints that apply to
  all of them, from Namhyung Kim

. Fixes for handling fallback to cpu-clock on PPC, from David Ahern

. Fix for processing events with unknown size, from Jiri Olsa

. Compilation fix on 32-bit, from Jiri Olsa

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (3):
      perf top: Set target.system_wide
      perf top: Default to system wide using perf_target methods
      perf hists browser: Use '/' for search/filter instead of 's'

David Ahern (5):
      perf record: Fix fallback to cpu-clock on ppc
      perf stat: handle ENXIO error for perf_event_open
      perf top: Update event name when falling back to cpu-clock
      perf record: Reset event name when falling back to cpu-clock
      perf annotate: shorten helpline so it fits in visible space

Jiri Olsa (2):
      perf session: Fail on processing event with unknown size
      perf report: Fix format string for x86-32 compilation

Namhyung Kim (6):
      perf evlist: Fix creation of cpu map
      perf target: Introduce perf_target_errno
      perf target: Introduce perf_target__parse_uid()
      perf tools: Introduce perf_target__strerror()
      perf target: Consolidate target task/cpu checking
      perf stat: Use perf_evlist__create_maps

 tools/perf/builtin-record.c       |   36 ++++++++---
 tools/perf/builtin-report.c       |    2 +-
 tools/perf/builtin-stat.c         |   41 +++++++------
 tools/perf/builtin-top.c          |   29 +++++++--
 tools/perf/ui/browsers/annotate.c |    6 +-
 tools/perf/ui/browsers/hists.c    |    4 +-
 tools/perf/util/debug.c           |    1 +
 tools/perf/util/evlist.c          |    9 ++-
 tools/perf/util/evsel.c           |    8 +--
 tools/perf/util/session.c         |   30 +++-------
 tools/perf/util/target.c          |  119 +++++++++++++++++++++++++++++++++----
 tools/perf/util/target.h          |   48 ++++++++++++++-
 tools/perf/util/usage.c           |   31 ----------
 tools/perf/util/util.h            |    3 -
 14 files changed, 250 insertions(+), 117 deletions(-)
