Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab2IJQuz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 12:50:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930Ab2IJQuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 12:50:52 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/4] perf tools: Back [vdso] DSO with real data
Date: Mon, 10 Sep 2012 18:50:15 +0200
Message-Id: <1347295819-23177-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
this patchset adds data behind the [vdso] map as a special DSO.
This is helpful for dwarf unwind, because now we can unwind
samples taken from [vdso] map. Example output is given in
patch 4/4.

Patch 1/1 fixies separate issue.

Attached patches:
  1/4 perf tools: Do backtrace post unwind only if we regs and stack were captured
  2/4 perf tools: Add memdup function
  3/4 perf dso: Make dsos__find function globally available
  4/4 perf tools: Back [vdso] DSO with real data

thanks,
jirka

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/Makefile                    |   2 ++
 tools/perf/builtin-buildid-cache.c     |   3 ++-
 tools/perf/util/header.c               |  70 +++++++++++++++++++++++++++++++++++++++-----------------
 tools/perf/util/header.h               |   2 +-
 tools/perf/util/include/linux/string.h |   2 ++
 tools/perf/util/map.c                  |  12 +++++++---
 tools/perf/util/session.c              |   7 ++++++
 tools/perf/util/string.c               |  18 ++++++++++++++-
 tools/perf/util/symbol.c               |   2 +-
 tools/perf/util/symbol.h               |   1 +
 tools/perf/util/vdso.c                 | 111 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/vdso.h                 |  18 +++++++++++++++
 12 files changed, 220 insertions(+), 28 deletions(-)
