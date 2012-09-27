Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab2I0EWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 00:22:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52835 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab2I0EWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 00:22:43 -0400
Date: Wed, 26 Sep 2012 21:22:22 -0700
From: tip-bot for Feng Tang <feng.tang@intel.com>
Message-ID: <tip-b1ab1bd1921536c2a97adb888effeff4370a3246@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        dsahern@gmail.com, tglx@linutronix.de, feng.tang@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        dsahern@gmail.com, tglx@linutronix.de, feng.tang@intel.com
In-Reply-To: <20120828101730.6b2fd97e@feng-i7>
References: <20120828101730.6b2fd97e@feng-i7>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Fix a compiling error in trace-event-perl.c for 32 bits machine
Git-Commit-ID: b1ab1bd1921536c2a97adb888effeff4370a3246
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 26 Sep 2012 21:22:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b1ab1bd1921536c2a97adb888effeff4370a3246
Gitweb:     http://git.kernel.org/tip/b1ab1bd1921536c2a97adb888effeff4370a3246
Author:     Feng Tang <feng.tang@intel.com>
AuthorDate: Thu, 20 Sep 2012 08:30:21 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 20 Sep 2012 08:30:21 -0300

perf tools: Fix a compiling error in trace-event-perl.c for 32 bits machine

On my x86_32 mahcine, there is a compile error:

        CC util/scripting-engines/trace-event-perl.o
        cc1: warnings being treated as errors
        util/scripting-engines/trace-event-perl.c: In function
	perl_process_tracepoint:
        util/scripting-engines/trace-event-perl.c:285: error: format
	expects type 'int', but argument 2 has type '__u64'
        make: *** [util/scripting-engines/trace-event-perl.o] Error 1

Fix it by using the "%PRIu64" for __u64.

v2: use PRIu64 as suggested by Arnaldo.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20120828101730.6b2fd97e@feng-i7
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../perf/util/scripting-engines/trace-event-perl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index ffde3e4..f80605e 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -282,7 +282,7 @@ static void perl_process_tracepoint(union perf_event *perf_event __maybe_unused,
 
 	event = find_cache_event(evsel);
 	if (!event)
-		die("ug! no event found for type %d", evsel->attr.config);
+		die("ug! no event found for type %" PRIu64, evsel->attr.config);
 
 	pid = raw_field_value(event, "common_pid", data);
 
