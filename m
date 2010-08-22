Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab0HVVPw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 17:15:52 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62603 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab0HVVPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 17:15:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=mMQzZJ5zOuUq4OXWQjLPlAz92sfAFOUI4U20bVjd1e9Mw905ZAIz1wCSDT8b4q0B8c
         IdlB1LHVIdXy/JAvQ19monRypvo7O8I8I3YRQlq/PWvm8eC00u2lqEvbXSmHCYtLYsPG
         F7gX9GVOXCTETohJjNeweXYpJgMdEh571KtRE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: [GIT PULL] perf callchain improvement and fixes
Date: Sun, 22 Aug 2010 23:15:37 +0200
Message-Id: <1282511740-22631-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/core branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/core

Unfortunately we were missing a lot of callchains in multithread
cases. And this was not a regression, it was rather the fact I
was missing a part of the histogram processing: the collapsing.

Anyway, this is eventually fixed. Thanks a lot to Chistoph Hellwig
who reported this.

Thanks,
	Frederic
---

Frederic Weisbecker (3):
      perf: Keep track of the max depth of a callchain
      perf: Rename append_callchain into callchain_append
      perf: Support for callchains merge


 tools/perf/builtin-report.c |    3 +-
 tools/perf/util/callchain.c |   98 ++++++++++++++++++++++++++++++++++---------
 tools/perf/util/callchain.h |   25 +++++++----
 tools/perf/util/hist.c      |    4 +-
 tools/perf/util/sort.h      |    2 +-
 5 files changed, 100 insertions(+), 32 deletions(-)
