Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab2KLRek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 12:34:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972Ab2KLRei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 12:34:38 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 0/5] perf tool: Fix enable/disable events logic for record command
Date: Mon, 12 Nov 2012 18:33:59 +0100
Message-Id: <1352741644-16809-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
this patchset fixes the event enable/disable logic for record command
(patches 1 - 4) plus small fix for event parsing (patch 5).

Attached patches:
  1/5 perf tool: Fix attributes for '{}' defined event groups
  2/5 perf tool: Fix 'disabled' attribute config for record command
  3/5 perf tool: Ensure single disable call per event in record comand
  4/5 perf tool: Omit group members from perf_evlist__disable/enable
  5/5 perf tool: Add basic event modifier sanity check

Also available in:
git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/linux.git
perf/enable5

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
 tools/perf/builtin-record.c               | 26 ++++++++++++++++++++++----
 tools/perf/builtin-stat.c                 | 11 ++++-------
 tools/perf/tests/attr/test-record-group   |  1 +
 tools/perf/tests/attr/test-record-group1  |  5 ++---
 tools/perf/tests/attr/test-stat-group1    |  6 ++----
 tools/perf/tests/open-syscall-tp-fields.c |  2 +-
 tools/perf/util/evlist.c                  | 10 ++++++----
 tools/perf/util/evsel.c                   | 50 ++++++++++++++++++++++++++++++++++++++++++++------
 tools/perf/util/evsel.h                   |  3 +--
 tools/perf/util/parse-events.c            | 20 ++++++++++++++++++++
 tools/perf/util/parse-events.l            |  2 +-
 11 files changed, 104 insertions(+), 32 deletions(-)
