Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab2HGNUC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 09:20:02 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60206 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661Ab2HGNUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 09:20:00 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 0/2] perf tools: Basic bash completion support
Date: Tue,  7 Aug 2012 15:19:44 +0200
Message-Id: <1344345586-15068-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Basic bash completion support. Only support perf subcommands and most -e basic
event descriptor (no grouping).

I just have a small issue with tracepoints because of their ":" in the middle.
It auto completes as long as we haven't yet reached the semicolon. Otherwise
we need to add a double quote in the beginning of the expression. I'm quite
a newbie in bash completion though, so I might find a subtelty later to solve
this.

Frederic Weisbecker (2):
  perf tools: Initial bash completion support
  perf tools: Support for events bash completion

 tools/perf/Makefile            |    1 +
 tools/perf/bash_completion     |   24 ++++++++++++++
 tools/perf/builtin-list.c      |   14 ++++---
 tools/perf/perf.c              |   69 ++++++++++++++++++++++-----------------
 tools/perf/util/parse-events.c |   70 +++++++++++++++++++++++++---------------
 tools/perf/util/parse-events.h |    7 ++--
 6 files changed, 120 insertions(+), 65 deletions(-)
 create mode 100644 tools/perf/bash_completion

-- 
1.7.5.4

