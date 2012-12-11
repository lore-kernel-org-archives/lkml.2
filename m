Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab2LKWs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 17:48:56 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53888
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754781Ab2LKWsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 17:48:53 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andi Kleen <andi@firstfloor.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Feng Tang <feng.tang@intel.com>, Frank Eigler <fche@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Kushal Das <kdas@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>, acme@ghostprotocols.net,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/37] perf/core improvements and fixes
Date: Tue, 11 Dec 2012 19:47:46 -0300
Message-Id: <1355266103-17238-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling.

	Jiri, tomorrow I'll go over the hists patches as I think you're fully
ok with Namhyung latest patchset.

Regards,

- Arnaldo

The following changes since commit cc1b39dbf9f55a438e8a21a694394c20e6a17129:

  Merge branch 'tip/perf/core' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace into perf/core (2012-12-08 15:54:35 +0100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to 2376c67a7bbc7849b806688ba2efb8520c21c458:

  perf top: Use perf_evlist__config() (2012-12-11 17:22:39 -0300)

----------------------------------------------------------------
perf/core improvements and fixes

. perf build-id cache now can show DSOs present in a perf.data file that are
  not in the cache, to integrate with build-id servers being put in place by
  organizations such as Fedora.

. perf buildid-list -i an-elf-file-instead-of-a-perf.data is back showing its
  build-id.

. No need to do feature checks when doing a 'make tags'

. Fix some 'perf test' errors and make them use the tracepoint evsel constructor.

. perf top now shares more of the evsel config/creation routines with 'record',
  paving the way for further integration like 'top' snapshots, etc.

. perf top now supports DWARF callchains.

. perf evlist decodes sample_type and read_format, helping diagnose problems.

. Fix mmap limitations on 32-bit, fix from David Miller.

. perf diff fixes from Jiri Olsa.

. Ignore ABS symbols when loading data maps, fix from Namhyung Kim

. Hists improvements from Namhyung Kim

. Don't check configuration on make clean, from Namhyung Kim

. Fix dso__fprintf() print statement, from Stephane Eranian.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (20):
      perf top: Add missing newline on pr_err call
      perf tools: Don't check configuration on make tags
      perf tools: Fix TUI helpline output
      perf buildid-list: We need to check if a file is ELF first
      perf symbols: Generalize filter in __fprintf_buildid methods
      perf buildid-cache: Add option to show build ids that are missing in the cache
      perf machine: Move more machine methods to machine.c
      perf evsel: Update sample_size when setting sample_type bits
      perf test: Fixup error reporting in basic mmap test
      perf test: Use perf_evsel__newtp constructor in the tracepoint tests
      perf evsel: Introduce method to request IDs be used
      perf evsel: No need to always ask for PERF_FORMAT_ID in read_format
      perf evsel: No need to always ask for PERF_FORMAT_TOTAL_TIME_{ENABLED,RUNNING}
      perf evlist: Set the leader in the perf_evlist__config method
      perf evsel: Adopt fprintf routine from 'perf evlist'
      perf tools: Add install-bin Makefile target
      perf evsel: Decode read_format and sample_type in perf_evsel__fprintf
      perf record: Pass perf_record_opts to the callchain cmdline parsing callback
      perf record: Export the callchain parsing routine and help
      perf top: Use perf_evlist__config()

David Miller (1):
      perf tools: Fix mmap limitations on 32-bit

Jiri Olsa (6):
      perf hists: Introduce perf_hpp__list for period related columns
      perf hists: Fix period symbol_conf.field_sep display
      perf diff: Remove displacement from struct hist_entry_diff
      perf diff: Change compute methods to work with pair directly
      perf diff: Change formula methods to work with pair directly
      perf diff: Remove displacement output option

Namhyung Kim (9):
      perf ui: Always compile error printing code
      perf ui/helpline: Introduce ui_helpline__vshow()
      perf tools: Don't check configuration on make clean
      perf session: Free environment information when deleting session
      perf symbols: Ignore ABS symbols when loading data maps
      perf hists: Fix typo on hist__entry_add_pair
      perf hists: Link hist entry pairs to leader
      perf evsel: Set leader evsel's ->leader to itself
      perf evsel: Convert to _is_group_leader method

Stephane Eranian (1):
      perf symbols: Fix dso__fprintf() print statement

 tools/perf/Documentation/Makefile               |    4 +
 tools/perf/Documentation/perf-buildid-cache.txt |    3 +
 tools/perf/Documentation/perf-diff.txt          |    4 -
 tools/perf/Documentation/perf-top.txt           |    2 +-
 tools/perf/Makefile                             |   51 +-
 tools/perf/builtin-buildid-cache.c              |   48 +-
 tools/perf/builtin-buildid-list.c               |   21 +-
 tools/perf/builtin-diff.c                       |  121 ++--
 tools/perf/builtin-evlist.c                     |   81 +--
 tools/perf/builtin-record.c                     |   40 +-
 tools/perf/builtin-report.c                     |    1 +
 tools/perf/builtin-stat.c                       |    2 +-
 tools/perf/builtin-top.c                        |  207 ++-----
 tools/perf/builtin-trace.c                      |    2 +-
 tools/perf/tests/attr/base-record               |    2 +-
 tools/perf/tests/attr/test-record-group         |    2 +
 tools/perf/tests/attr/test-record-group1        |    2 +
 tools/perf/tests/mmap-basic.c                   |   40 +-
 tools/perf/tests/open-syscall-all-cpus.c        |   18 +-
 tools/perf/tests/open-syscall.c                 |   17 +-
 tools/perf/tests/parse-events.c                 |   20 +-
 tools/perf/tests/perf-record.c                  |    8 +-
 tools/perf/tests/tests.h                        |    3 -
 tools/perf/tests/util.c                         |   30 -
 tools/perf/ui/browsers/hists.c                  |   20 +-
 tools/perf/ui/gtk/browser.c                     |   30 +-
 tools/perf/ui/gtk/helpline.c                    |   23 +-
 tools/perf/ui/helpline.c                        |   12 +
 tools/perf/ui/helpline.h                        |   22 +-
 tools/perf/ui/hist.c                            |  170 +++---
 tools/perf/ui/setup.c                           |    1 +
 tools/perf/ui/stdio/hist.c                      |   17 +-
 tools/perf/ui/tui/helpline.c                    |   29 +-
 tools/perf/ui/util.c                            |   10 +
 tools/perf/util/callchain.h                     |    5 +
 tools/perf/util/debug.c                         |   28 +-
 tools/perf/util/debug.h                         |   33 +-
 tools/perf/util/dso.c                           |    6 +-
 tools/perf/util/dso.h                           |    2 +-
 tools/perf/util/evlist.c                        |   17 +-
 tools/perf/util/evlist.h                        |    4 +-
 tools/perf/util/evsel.c                         |  186 +++++-
 tools/perf/util/evsel.h                         |   25 +-
 tools/perf/util/hist.c                          |    4 +-
 tools/perf/util/hist.h                          |   22 +-
 tools/perf/util/machine.c                       |  742 +++++++++++++++++++++++
 tools/perf/util/machine.h                       |   11 +-
 tools/perf/util/session.c                       |  256 +-------
 tools/perf/util/session.h                       |    5 +-
 tools/perf/util/sort.h                          |    5 +-
 tools/perf/util/symbol-elf.c                    |   11 +
 tools/perf/util/symbol.c                        |  522 +---------------
 tools/perf/util/symbol.h                        |    4 +
 tools/perf/util/thread.c                        |   20 +-
 tools/perf/util/thread.h                        |    1 +
 tools/perf/util/top.c                           |   22 +-
 tools/perf/util/top.h                           |    8 +-
 57 files changed, 1483 insertions(+), 1519 deletions(-)
 delete mode 100644 tools/perf/tests/util.c
