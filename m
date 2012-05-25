Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323Ab2EYVtP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 17:49:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:40735 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755907Ab2EYVtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 17:49:12 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Franck Bui-Huu <fbuihuu@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/5 v2] perf/urgent fixes
Date: Fri, 25 May 2012 18:48:54 -0300
Message-Id: <1337982539-2882-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	There was a problem in the previous series, the 4 patches that ended up
being posted were not the 4 on perf/urgent, but on my local perf/core branch,
so I'm reposting now and have resigned the perf-urgent-for-mingo signed tag.

	Please consider pulling and sorry for the thinko,

- Arnaldo

The following changes since commit eaec12d7f526694f24d581a4ad23de6ce0315cd2:

  tools lib traceevent: Fix signature of create_arg_item() (2012-05-24 11:36:05 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo

for you to fetch changes up to a00dc319e98161949aa87f71a17db32e925c3257:

  perf record: Fix branch_stack type in perf_record_opts (2012-05-25 18:32:44 -0300)

----------------------------------------------------------------
Fixes for perf/urgent.

. Fix build on newer distros where _FORTIFY_SOURCE needs optimization enable.

. Fix event name caching when fallbacking to cpu-clock

. Event name reconstruction from perf_event_attr now include modifiers.

. Elliminate leak on error path when parsing pid/tid list, From Franck Bui-Huu.

. Fix type problems resulting in endianness problems on PPC64, from Stephane Eranian.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (3):
      perf tools: Do not use _FORTIFY_SOURCE when DEBUG=1 is specified
      perf top: Fix counter name fixup when fallbacking to cpu-clock
      perf tools: Reconstruct event with modifiers from perf_event_attr

Franck Bui-Huu (1):
      perf tools: fix thread_map__new_by_pid_str() memory leak in error path

Stephane Eranian (1):
      perf record: Fix branch_stack type in perf_record_opts

 tools/perf/Makefile            |    4 +-
 tools/perf/builtin-top.c       |    2 +-
 tools/perf/perf.h              |    2 +-
 tools/perf/util/evsel.c        |   90 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/evsel.h        |    3 ++
 tools/perf/util/parse-events.c |   27 +++++-------
 tools/perf/util/thread_map.c   |   21 +++++-----
 7 files changed, 118 insertions(+), 31 deletions(-)
