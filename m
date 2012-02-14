Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759119Ab2BNBya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 20:54:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:45753 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758737Ab2BNBxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 20:53:37 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andi Kleen <andi@firstfloor.org>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Arun Sharma <asharma@fb.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Wang <jasowang@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>, Lin Ming <ming.m.lin@intel.com>,
        Namhyung Kim <namhyung@gmail.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Roberto Agostino Vitillo <ravitillo@lbl.gov>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vweaver1@eecs.utk.edu>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/16] perf/core improvements and fixes
Date: Mon, 13 Feb 2012 23:52:39 -0200
Message-Id: <1329184375-27911-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.123.g65da0
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit c98fdeaa92731308ed80386261fa2589addefa47:

  x86/sched/perf/AMD: Set sched_clock_stable (2012-02-07 13:12:08 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf-core-for-mingo

for you to fetch changes up to 7e1ccd3804281fc0755eb726b654469c40a96d89:

  perf tools: cleanup initialization of attr->size (2012-02-13 23:35:04 -0200)

----------------------------------------------------------------
perf/core fixes and improvements.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
David Ahern (3):
      perf record: No build id option fails
      perf tools: Fix out of tree compiles
      perf tools: Allow multiple threads or processes in record, stat, top

Jiri Olsa (3):
      perf tools: Remove unused functions from debugfs object
      perf tools: Add sysfs mountpoint interface
      perf tools: Add bitmap_or function into bitmap object

Joerg Roedel (2):
      perf top: Don't process samples with no valid machine object
      perf tools: Change perf_guest default back to false

Namhyung Kim (4):
      perf tools: Fix build dependency of perf python extension
      perf tools: Implement islower/isupper macro into util.h
      perf tools: ctype.c only wants util.h
      perf tools: Get rid of ctype.h in symbol.c

Robert Richter (2):
      perf tools: Moving code in header.c
      perf tools: Factor out feature op to process header sections

Stephane Eranian (2):
      perf tools: fix endianness detection in perf.data
      perf tools: cleanup initialization of attr->size

 tools/perf/Documentation/perf-record.txt |    4 +-
 tools/perf/Documentation/perf-stat.txt   |    4 +-
 tools/perf/Documentation/perf-top.txt    |    4 +-
 tools/perf/MANIFEST                      |    1 +
 tools/perf/Makefile                      |    7 +-
 tools/perf/builtin-record.c              |   14 +-
 tools/perf/builtin-stat.c                |   31 ++-
 tools/perf/builtin-test.c                |    2 -
 tools/perf/builtin-top.c                 |   18 +-
 tools/perf/perf.h                        |    5 +-
 tools/perf/util/bitmap.c                 |   10 +
 tools/perf/util/ctype.c                  |    2 +-
 tools/perf/util/debugfs.c                |  141 ----------
 tools/perf/util/debugfs.h                |    6 -
 tools/perf/util/evlist.c                 |   10 +-
 tools/perf/util/evlist.h                 |    4 +-
 tools/perf/util/evsel.c                  |    2 +-
 tools/perf/util/header.c                 |  421 +++++++++++++++++-------------
 tools/perf/util/hist.h                   |    1 +
 tools/perf/util/include/linux/bitmap.h   |   11 +
 tools/perf/util/python-ext-sources       |   19 ++
 tools/perf/util/session.c                |   10 +
 tools/perf/util/setup.py                 |    8 +-
 tools/perf/util/symbol.c                 |    2 +-
 tools/perf/util/sysfs.c                  |   60 +++++
 tools/perf/util/sysfs.h                  |    6 +
 tools/perf/util/thread_map.c             |  128 +++++++++
 tools/perf/util/thread_map.h             |    4 +
 tools/perf/util/top.c                    |   10 +-
 tools/perf/util/top.h                    |    2 +-
 tools/perf/util/usage.c                  |    6 +-
 tools/perf/util/util.c                   |    4 +-
 tools/perf/util/util.h                   |    6 +-
 33 files changed, 571 insertions(+), 392 deletions(-)
 create mode 100644 tools/perf/util/python-ext-sources
 create mode 100644 tools/perf/util/sysfs.c
 create mode 100644 tools/perf/util/sysfs.h
