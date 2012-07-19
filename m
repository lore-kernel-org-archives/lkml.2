Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab2GSPnv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 11:43:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33560 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab2GSPnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 11:43:49 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] perf report: Cleanup and refactor hist printing code
Date: Fri, 20 Jul 2012 00:42:33 +0900
Message-Id: <1342712558-8185-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm working on improving perf report. Main goal is adding support for
event-grouping (viewer part) and callchain accumulation (aka sort inclusive).
I'm hoping that I can post an initial series by the end of next week.

But before that, I just want to cleanup the code somewhat since it's a pain
to look at it in the current form. So I added struct hist_period_print (or
a better name?), and let callers configure it dynamically for their needs.
I think this can make it easy to work with the code.

I know that it'll be conflict with Frederic recent changes. But it should be
trivial to resolve them upon this series (or the other way around).

Any comments are welcome.

Thanks,
Namhyung


Namhyung Kim (5):
  perf tools: Separate out hist print functions
  perf tools: Refactor some functions
  perf tools: Introduce hist_period_print functions
  perf ui/browser: Use hist_period_print functions
  perf gtk/browser: Use hist_period_print functions

 tools/perf/Makefile            |    4 +-
 tools/perf/ui/browsers/hists.c |  102 +++--
 tools/perf/ui/gtk/browser.c    |  103 ++++-
 tools/perf/ui/hist.c           |  820 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/hist.c         |  685 +--------------------------------
 tools/perf/util/hist.h         |   41 +-
 6 files changed, 1045 insertions(+), 710 deletions(-)
 create mode 100644 tools/perf/ui/hist.c

-- 
1.7.9.2

