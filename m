Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab2DGUzV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 16:55:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51998 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261Ab2DGUyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 16:54:24 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andi Kleen <andi@firstfloor.org>,
        Ashay Rane <ashay.rane@tacc.utexas.edu>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/8] perf/urgent new features
Date: Sat,  7 Apr 2012 17:54:01 -0300
Message-Id: <1333832049-2399-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling.

	This was forked from my perf/urgent branch, that I submitted to you
recently.

	The jump stuff needs some more work and the offset mode has to become
the default, the long address as operand of jump instructions needs to be
suppressed, but I just wanted to push what I have to get comments about it at
this stage.

	Will be visiting some airports in the next two days on my way home, so
with limited or no connectivity.

- Arnaldo

The following changes since commit 31d68e7b66f168e623902e194af1e52b8cf75d71:

  perf annotate: Validate addr in symbol__inc_addr_samples (2012-04-05 19:51:14 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to d3d1f61acf62204bb7b2b4509329247bffaedd7c:

  perf annotate browser: string search: /?n (2012-04-07 17:37:22 -0300)

----------------------------------------------------------------
Improvements for perf/core:

. Navigate jump instructions in the annotate browser, just press enter or ->,
  still needs support for a jump navigation history, i.e. to go back.

. Search string in the annotate browser: same keys as vim:
   / forward
   n next backward/forward
   ? backward

. Clarify number of events/samples in the report header, from Ashay Rane

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (7):
      perf ui browser: Return the current color when setting a new one
      perf annotate: Allow printing objdump line addr in different color
      perf ui annotate browser: Allow toggling addr offset view
      perf ui annotate browser: Move callq handling to separate function
      perf ui annotate browser: Add list based search for addr offset
      perf annotate browser: Initial support for navigating jump instructions
      perf annotate browser: string search: /?n

Ashay Rane (1):
      perf report: Correct display of samples and events in header

 tools/perf/Documentation/perfconfig.example |    1 +
 tools/perf/builtin-report.c                 |   11 +-
 tools/perf/util/annotate.c                  |   35 ++-
 tools/perf/util/ui/browser.c                |   11 +-
 tools/perf/util/ui/browser.h                |    4 +-
 tools/perf/util/ui/browsers/annotate.c      |  362 ++++++++++++++++++++++-----
 tools/perf/util/ui/browsers/hists.c         |   10 +-
 7 files changed, 353 insertions(+), 81 deletions(-)
