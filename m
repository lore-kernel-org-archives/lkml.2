Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808Ab2J0VS6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 17:18:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778Ab2J0VSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 17:18:53 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 0/5] perf dso: Separate dso symbols to separate object
Date: Sat, 27 Oct 2012 23:18:27 +0200
Message-Id: <1351372712-21104-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
separating dso related stuff into dso object plus some other symbol
object cleanup. It's just a code moving, no actual change was done.

Attached patches:
  1/5 perf tool: Move build_id__sprintf into build-id object
  2/5 perf tool: Move BUILD_ID_SIZE into build-id object
  3/5 perf tool: Move hex2u64 into util object
  4/5 perf tool: Move strxfrchar into string object
  5/5 perf tool: Move dso_* related functions into dso object

Also available in:
git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/linux.git
perf/dso1

thanks,
jirka

Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                |   2 +
 tools/perf/builtin-buildid-cache.c |   1 +
 tools/perf/util/annotate.c         |   1 +
 tools/perf/util/build-id.c         |  15 ++
 tools/perf/util/build-id.h         |   7 +-
 tools/perf/util/dso.c              | 594 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/dso.h              | 148 +++++++++++++++
 tools/perf/util/event.h            |   3 +-
 tools/perf/util/header.c           |   1 +
 tools/perf/util/map.c              |   1 +
 tools/perf/util/string.c           |  18 ++
 tools/perf/util/symbol.c           | 657 +------------------------------------------------------------------
 tools/perf/util/symbol.h           | 141 +--------------
 tools/perf/util/util.c             |  33 ++++
 tools/perf/util/util.h             |   2 +
 15 files changed, 831 insertions(+), 793 deletions(-)
