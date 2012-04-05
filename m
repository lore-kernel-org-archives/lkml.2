Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab2DEX3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 19:29:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:54153 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557Ab2DEX3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 19:29:12 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sorin Dumitru <dumitru.sorin87@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/5] perf/urgent fixes
Date: Thu,  5 Apr 2012 20:28:47 -0300
Message-Id: <1333668532-3624-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit 7b78f13603c6fcb64e020a0bbe31a651ea2b657b:

  perf tools: Fix getrusage() related build failure on glibc trunk (2012-04-04 11:59:00 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo

for you to fetch changes up to 31d68e7b66f168e623902e194af1e52b8cf75d71:

  perf annotate: Validate addr in symbol__inc_addr_samples (2012-04-05 19:51:14 -0300)

----------------------------------------------------------------
Fixes for perf/urgent

. Fix annotation histograms decay: We were decaying just the entries on the
  objdump lines, i.e. the first byte of an instruction, leading to percentage
  errors when samples happened in the other bytes of instructions. Affects
  only live annotation.

. Use most recent map for an histogram, avoiding underflow problems in
  annotation histograms. Fix from David Miller

. Add validation in 'perf top' for the underflow problems mentioned in the
  previous fix. Present information to the user when such thing happens and
  ask for reporting to lkml.

. Fix the hists browser when there are multiple events in a perf.data file but
  one of them has no samples. Fix from Jiri Olsa

. Add intel_idle to the list of idle routines to skip in perf top.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (3):
      perf top: Add intel_idle to the skip list
      perf annotate: Fix hist decay
      perf annotate: Validate addr in symbol__inc_addr_samples

David Miller (1):
      perf hists: Catch and handle out-of-date hist entry maps.

Jiri Olsa (1):
      perf hists browser: Fix NULL deref in hists browsing code

 tools/perf/builtin-top.c            |   36 ++++++++++++++++++++++++++++++++++-
 tools/perf/util/annotate.c          |   16 ++++++----------
 tools/perf/util/hist.c              |   12 ++++++++++++
 tools/perf/util/map.c               |    1 +
 tools/perf/util/map.h               |    1 +
 tools/perf/util/ui/browsers/hists.c |    3 +++
 6 files changed, 58 insertions(+), 11 deletions(-)
