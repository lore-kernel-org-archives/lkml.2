Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab2EBTZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 15:25:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:56713 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756401Ab2EBTZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 15:25:16 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Ulrich Drepper <drepper@gmail.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/15] perf/core fixes and improvements
Date: Wed,  2 May 2012 16:24:47 -0300
Message-Id: <1335986702-9408-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit a385ec4f11bdcf81af094c03e2444ee9b7fad2e5:

  Merge tag 'v3.4-rc2' into perf/core (2012-04-13 09:57:10 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to dc41b9b8f02dbe2228ae787d525dac43beebb7fa:

  perf ui: Change fallback policy of setup_browser() (2012-05-02 16:17:37 -0300)

----------------------------------------------------------------
New features and fixes for perf/core:

. Improvements in how the gtk UI is handled when setting up the browser,
  from Namhyung Kim.

. Introduce a perf_target class to coalesce target (user, thread, cpu, etc)
  handling and validation, from Namhyung Kim.

. Clean up realloc use, from Ulrich Drepper.

. Add missing include in parse-events.h, from Robert Richter.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (1):
      perf test: Make the rdpmc test honour 'verbose' mode

Namhyung Kim (12):
      perf tools: Introduce struct perf_target
      perf stat: Convert to struct perf_target
      perf top: Convert to struct perf_target
      perf tools: Introduce perf_target__validate() helper
      perf evlist: Make create_maps() take struct perf_target
      perf tools: Check more combinations of PID/TID, UID and CPU switches
      perf target: Split out perf_target handling code
      perf ui: Make setup_browser() generic
      perf ui gtk: Drop arg[cv] arguments from perf_gtk_setup_browser()
      perf ui gtk: Rename functions for consistency
      perf ui: Add gtk2 support into setup_browser()
      perf ui: Change fallback policy of setup_browser()

Robert Richter (1):
      perf tools: Fix include header files in util/parse-events.h

Ulrich Drepper (1):
      perf tools: Cleanup realloc use

 tools/perf/Makefile            |    8 ++
 tools/perf/builtin-record.c    |   38 +++++----
 tools/perf/builtin-report.c    |   10 +--
 tools/perf/builtin-stat.c      |   46 +++++------
 tools/perf/builtin-test.c      |   12 +--
 tools/perf/builtin-top.c       |   34 +++-----
 tools/perf/perf.h              |    8 +-
 tools/perf/ui/gtk/browser.c    |   31 +++-----
 tools/perf/ui/gtk/setup.c      |   12 +++
 tools/perf/ui/setup.c          |  168 +++++++---------------------------------
 tools/perf/ui/tui/setup.c      |  140 +++++++++++++++++++++++++++++++++
 tools/perf/util/cache.h        |   24 ++++--
 tools/perf/util/evlist.c       |   15 ++--
 tools/perf/util/evlist.h       |    4 +-
 tools/perf/util/evsel.c        |   11 +--
 tools/perf/util/header.c       |   17 ++--
 tools/perf/util/parse-events.h |    2 +
 tools/perf/util/target.c       |   45 +++++++++++
 tools/perf/util/target.h       |   18 +++++
 tools/perf/util/top.c          |   19 ++---
 tools/perf/util/top.h          |    6 +-
 tools/perf/util/usage.c        |    9 +--
 tools/perf/util/util.h         |    2 +-
 23 files changed, 380 insertions(+), 299 deletions(-)
 create mode 100644 tools/perf/ui/gtk/setup.c
 create mode 100644 tools/perf/ui/tui/setup.c
 create mode 100644 tools/perf/util/target.c
 create mode 100644 tools/perf/util/target.h
