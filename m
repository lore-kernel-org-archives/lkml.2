Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab2AaBY6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 20:24:58 -0500
Received: from casper.infradead.org ([85.118.1.10]:44373 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092Ab2AaBY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 20:24:56 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Masanari Iida <standby24x7@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, yrl.pp-manager.tt@hitachi.com,
        arnaldo.melo@gmail.com
Subject: [GIT PULL 0/9] perf/core fixes and improvements
Date: Mon, 30 Jan 2012 23:24:30 -0200
Message-Id: <1327973079-29426-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.rc2.1.g69204
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit efb3040d481a1594592b1defb4526c406c7a4751:

  jump_label: Add some documentation (2012-01-27 12:14:46 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf-core-for-mingo

for you to fetch changes up to cfeb1d90a1b1db96383b48888cb7a5f10ca12e12:

  perf python: Use attr.watermark in twatch.py (2012-01-30 18:38:23 -0200)

----------------------------------------------------------------
perf/core fixes and improvements.

----------------------------------------------------------------
Akihiro Nagai (4):
      perf script: Unify the expressions indicating "unknown"
      perf script: Print branch_from and branch_to of BTS events
      perf script: Add the offset field specifier
      perf script: Add option resolving vmlinux path

Arnaldo Carvalho de Melo (1):
      perf python: Use attr.watermark in twatch.py

Masanari Iida (1):
      perf evsel: Fix spelling typo

Namhyung Kim (2):
      perf lock: Document lock info subcommand
      perf tools: Remove unnecessary ctype.h inclusion

Stephane Eranian (1):
      perf top: Fix number of samples displayed

 tools/perf/Documentation/perf-lock.txt             |   20 ++++-
 tools/perf/Documentation/perf-script.txt           |    5 +-
 tools/perf/bench/mem-memcpy.c                      |    1 -
 tools/perf/bench/mem-memset.c                      |    1 -
 tools/perf/builtin-lock.c                          |    4 +-
 tools/perf/builtin-script.c                        |   80 ++++++++++++++++----
 tools/perf/builtin-top.c                           |   13 +++-
 tools/perf/python/twatch.py                        |    2 +-
 tools/perf/util/evsel.c                            |    2 +-
 tools/perf/util/map.c                              |   15 ++++
 tools/perf/util/map.h                              |    1 +
 tools/perf/util/probe-finder.c                     |    1 -
 .../util/scripting-engines/trace-event-python.c    |    1 -
 tools/perf/util/session.c                          |   39 ++++------
 tools/perf/util/session.h                          |    2 +-
 tools/perf/util/symbol.c                           |   22 ++++++
 tools/perf/util/symbol.h                           |    4 +
 tools/perf/util/trace-event-parse.c                |    1 -
 tools/perf/util/trace-event-read.c                 |    1 -
 tools/perf/util/trace-event-scripting.c            |    1 -
 tools/perf/util/ui/browsers/map.c                  |    2 +-
 21 files changed, 159 insertions(+), 59 deletions(-)
