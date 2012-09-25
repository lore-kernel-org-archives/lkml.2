Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab2IYOhc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 10:37:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:60524 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540Ab2IYOh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 10:37:29 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [GIT PULL 0/2] perf/core fixes
Date: Tue, 25 Sep 2012 11:37:17 -0300
Message-Id: <1348583839-4264-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
X-MIME-Error: demime acl condition: double headers (content-type, content-disposition or content-transfer-encoding)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling, on top of the previous req,

- Arnaldo

The following changes since commit b1ac754b67b5a875d63bee880f60ccb0c6bd8899:

  tools lib traceevent: Handle alloc_arg failure (2012-09-24 12:31:52 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to f1b2256d66fe8d613b9afcc1c16079362f9fc05c:

  tools lib traceevent: Fix error path on pevent_parse_event (2012-09-25 09:53:53 -0300)

----------------------------------------------------------------
perf/core fixes:

. The new perf_evsel__tp_sched_test 'perf test' broke the build by setting the
  'ret' variable but not using it, caught by newer gcc
  -Werror=unused-but-set-variable, fix from Namhyung Kim.

. pevent_parse_event should return a proper PEVENT_ERRNO__ and call
  pevent_free_format on its failure path, fixes from Namhyung Kim.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Namhyung Kim (2):
      perf test: Fix build failure
      tools lib traceevent: Fix error path on pevent_parse_event

 tools/lib/traceevent/event-parse.c |    8 ++++----
 tools/perf/builtin-test.c          |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)
