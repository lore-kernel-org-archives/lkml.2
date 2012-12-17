Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab2LQNJP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 08:09:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23294 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535Ab2LQNJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 08:09:14 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 0/3] perf tool: Add support for wildcard in tracepoint system name
Date: Mon, 17 Dec 2012 14:08:35 +0100
Message-Id: <1355749718-4355-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

Attached patches:
  1/3 perf tools: Add missing closedir in multi tracepoint processing
  2/3 perf tools: Add support for wildcard in tracepoint system name
  3/3 perf tests: Add event parsing test for '*:*' tracepoints

The automated test (patch 3) exposes warnings from traceevent lib about
not being able to parse some tracepoints' format data. Exposing these
messages in the automated test suite will probably speed up the fix ;-)

I've already talked to Steve about the solution. Additional parsing
plugins need to be added (some moved from trace-cmd) into traceevent
lib.

thanks,
jirka

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 tools/perf/tests/parse-events.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/parse-events.c  | 52 +++++++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 109 insertions(+), 5 deletions(-)
