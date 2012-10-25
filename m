Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936044Ab2JYTsG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 15:48:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:59158 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935280Ab2JYTsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 15:48:04 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/3] perf/core trace improvements
Date: Thu, 25 Oct 2012 17:47:42 -0200
Message-Id: <1351194465-29083-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling, got sidetracked today with some other stuff,
but made progress on reviewing the group patches from Namhyung that Jiri uses
for that PERF_SAMPLE_READ patchset.

- Arnaldo

The following changes since commit 6ca2a9c6543dd1a307c0250991d4de93550209ce:

  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2012-10-25 09:42:03 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to 1302d88e66f12a7b46a5598e641d93f0713007e0:

  perf trace: Use sched:sched_stat_runtime to provide a thread summary (2012-10-25 10:57:43 -0200)

----------------------------------------------------------------
perf/core trace improvements:

. Don't stop synthesizing threads when one vanishes, this is for
  the existing threads when we start a tool like trace.

. Use sched:sched_stat_runtime to provide a thread summary, this
  produces the same output as the 'trace summary' subcommand of
  tglx's original "trace" tool.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (3):
      perf tools: Don't stop synthesizing threads when one vanishes
      perf trace: Count number of events for each thread and globally
      perf trace: Use sched:sched_stat_runtime to provide a thread summary

 tools/perf/Documentation/perf-trace.txt |    3 +
 tools/perf/builtin-trace.c              |  108 +++++++++++++++++++++++++++++--
 tools/perf/util/event.c                 |   13 ++--
 3 files changed, 110 insertions(+), 14 deletions(-)
