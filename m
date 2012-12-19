Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103Ab2LSPIF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 10:08:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755476Ab2LSPHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 10:07:55 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [RFC 0/3] perf tests: Adding precise event attribute test
Date: Wed, 19 Dec 2012 16:07:19 +0100
Message-Id: <1355929642-28392-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
as per issues with precise attribute [1], adding simple test to
catch it next time. 

Patch 2 adds sysfs 'precise' attribute containing maximum value
for perf_event_attr::precise_ip.

Patch 3 adds simple test checking the attribute and creating cycle
events with all possible precise values.

I based this on revert (Patch 1) discussed in [1]. I'm not sure
this revert will tak place at the end, but I wanted to get some
feedback on the 'precise' attribute first.

Attached patches:
  1/3 Revert "perf: Require exclude_guest to use PEBS - kernel side enforcement"
  2/3 perf x86: Add precise sysfs attribute
  3/3 perf tests: Add precise event attribute test

thanks,
jirka

[1] http://marc.info/?l=linux-kernel&m=135536724805356&w=2

Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 arch/x86/kernel/cpu/perf_event.c | 38 ++++++++++++++++++++++++--------------
 tools/perf/Makefile              |  1 +
 tools/perf/tests/builtin-test.c  |  4 ++++
 tools/perf/tests/precise.c       | 79 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h         |  1 +
 5 files changed, 109 insertions(+), 14 deletions(-)
