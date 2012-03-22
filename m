Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471Ab2CVSdy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 14:33:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46320 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398Ab2CVSdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 14:33:46 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@amd64.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/4] perf/core cleanups and fixes
Date: Thu, 22 Mar 2012 15:32:59 -0300
Message-Id: <1332441183-9514-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling.

- Arnaldo

The following changes since commit 0d09eb7a9a2ca4d7ed32f7b440bea78c0622814a:

  Merge branch 'perf/urgent' into perf/core (2012-03-22 15:09:08 -0300)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to 4bf9ce1b5ecffffeb8b9d7e925bac3e6b10109aa:

  perf diff: Fix to work with new hists design (2012-03-22 15:12:09 -0300)

----------------------------------------------------------------
Cleanups and fixes for perf/core:

. Short term fix for 'diff' tool breakage related to perf.data files
  with multiple events. From Jiri Olsa

. Cleanup for event id tracepoint reading routine, from Borislav Petkov

. 32-bit compilation fixes from Jiri Olsa

. Event parsing modifier assignment fixes from Jiri Olsa

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Borislav Petkov (1):
      perf tools: Simplify event_read_id exit path

Jiri Olsa (3):
      perf tools: Fix various casting issues for 32 bits
      perf tools: Fix modifier to be applied on correct events
      perf diff: Fix to work with new hists design

 tools/perf/builtin-diff.c            |   60 +--
 tools/perf/builtin-test.c            |  116 +++++-
 tools/perf/util/evsel.c              |    2 +-
 tools/perf/util/evsel.h              |    2 +
 tools/perf/util/header.c             |    2 +-
 tools/perf/util/hist.c               |    8 +-
 tools/perf/util/parse-events-bison.c |  675 +++++++++++++++++++---------------
 tools/perf/util/parse-events-bison.h |   15 +-
 tools/perf/util/parse-events.c       |   29 +-
 tools/perf/util/parse-events.h       |    7 +-
 tools/perf/util/parse-events.y       |   40 +-
 tools/perf/util/session.c            |    1 +
 tools/perf/util/trace-event-parse.c  |   10 +-
 13 files changed, 592 insertions(+), 375 deletions(-)
