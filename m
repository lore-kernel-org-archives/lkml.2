Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758962Ab0EBW7Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 18:59:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51467 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758828Ab0EBW7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 18:59:15 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 0/5] perf inject + say no to __KERNEL__ only stuff
Date: Sun,  2 May 2010 19:58:57 -0300
Message-Id: <1272841142-26029-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Hi Ingo,

	Please consider pulling from:

	git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf

- Arnaldo

Arnaldo Carvalho de Melo (3):
  perf tools: Don't use code surrounded by __KERNEL__
  perf record: Don't exit in live mode when no tracepoints are enabled
  perf inject: Refactor read_buildid function

Tom Zanussi (2):
  perf/live: don't synthesize build ids at the end of a live mode trace
  perf: add perf-inject builtin

 tools/perf/Makefile                    |   17 +--
 tools/perf/builtin-annotate.c          |    2 +-
 tools/perf/builtin-buildid-list.c      |    2 +-
 tools/perf/builtin-diff.c              |    4 +-
 tools/perf/builtin-inject.c            |  228 ++++++++++++++++++++++++++++++++
 tools/perf/builtin-kmem.c              |    2 +-
 tools/perf/builtin-lock.c              |    2 +-
 tools/perf/builtin-record.c            |   24 ++--
 tools/perf/builtin-report.c            |    2 +-
 tools/perf/builtin-sched.c             |    2 +-
 tools/perf/builtin-timechart.c         |    2 +-
 tools/perf/builtin-top.c               |    2 +-
 tools/perf/builtin-trace.c             |    2 +-
 tools/perf/builtin.h                   |    1 +
 tools/perf/perf.c                      |    1 +
 tools/perf/util/bitmap.c               |   21 +++
 tools/perf/util/header.c               |   96 ++++----------
 tools/perf/util/header.h               |    2 -
 tools/perf/util/hweight.c              |   31 +++++
 tools/perf/util/include/asm/bitops.h   |   18 ---
 tools/perf/util/include/asm/hweight.h  |    8 +
 tools/perf/util/include/linux/bitmap.h |   38 +++++-
 tools/perf/util/include/linux/bitops.h |   20 ++--
 tools/perf/util/session.c              |    3 +-
 tools/perf/util/session.h              |    3 +-
 tools/perf/util/trace-event-read.c     |   19 +++-
 tools/perf/util/trace-event.h          |    2 +-
 27 files changed, 407 insertions(+), 147 deletions(-)
 create mode 100644 tools/perf/builtin-inject.c
 create mode 100644 tools/perf/util/bitmap.c
 create mode 100644 tools/perf/util/hweight.c
 delete mode 100644 tools/perf/util/include/asm/bitops.h
 create mode 100644 tools/perf/util/include/asm/hweight.h

