Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab2DZPGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 11:06:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48940 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757033Ab2DZPGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 11:06:32 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hagen Paul Pfeifer <hagen@jauu.net>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/4] perf/annotate loop detection V2, fixes
Date: Thu, 26 Apr 2012 12:06:13 -0300
Message-Id: <1335452777-27326-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling into tip/perf/core.

	Just flushing out the annotate queue before it gets too big.

	I'll work on the suggestions made on G+ and on lkml.

- Arnaldo

The following changes since commit a3f895be1f1ed17f66e6e71adeef0cc7f937512c:

  perf annotate browser: Initial loop detection (2012-04-24 14:24:28 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-annotate-for-mingo

for you to fetch changes up to 38b31bd0cefbb0e69a182d9a94b09a7e648549dc:

  perf annotate browser: Don't draw jump connectors for out of function jumps (2012-04-25 14:18:42 -0300)

----------------------------------------------------------------
Fixes on top of the previous perf/annotate pull request

. Sometimes a jump points to an offset with no instructions, make the
  mark jump targets function handle that, for now just ignoring such
  jump targets, more investigation is needed to figure out how to cope
  with that.

. Handle jump targets that are outside the function, for now just don't
  try to draw the connector arrow, right thing seems to be to mark this
  jump with a -> (right arrow) and handle it like a callq.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (4):
      perf annotate browser: Handle NULL jump targets
      perf annotate: Disambiguage offsets and addresses in operands
      perf annotate: Mark jump instructions with no offset
      perf annotate browser: Don't draw jump connectors for out of function jumps

 tools/perf/ui/browsers/annotate.c |   27 ++++++++++++++++++---------
 tools/perf/util/annotate.c        |   27 +++++++++++++++------------
 tools/perf/util/annotate.h        |   13 +++++++++++--
 3 files changed, 44 insertions(+), 23 deletions(-)
