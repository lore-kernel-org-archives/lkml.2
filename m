Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab2ISPWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 11:22:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52818 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847Ab2ISPWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 11:22:42 -0400
Date: Wed, 19 Sep 2012 08:22:18 -0700
From: tip-bot for Feng Tang <feng.tang@intel.com>
Message-ID: <tip-36385be55da10b3271407c45c3a62d9af3db666e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, andi@firstfloor.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, dsahern@gmail.com, tglx@linutronix.de,
        feng.tang@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, andi@firstfloor.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, dsahern@gmail.com, tglx@linutronix.de,
        feng.tang@intel.com
In-Reply-To: <1347007349-3102-3-git-send-email-feng.tang@intel.com>
References: <1347007349-3102-3-git-send-email-feng.tang@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf scripts:
  Add --symbols option to handle specific symbols
Git-Commit-ID: 36385be55da10b3271407c45c3a62d9af3db666e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 19 Sep 2012 08:22:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  36385be55da10b3271407c45c3a62d9af3db666e
Gitweb:     http://git.kernel.org/tip/36385be55da10b3271407c45c3a62d9af3db666e
Author:     Feng Tang <feng.tang@intel.com>
AuthorDate: Fri, 7 Sep 2012 16:42:24 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 17 Sep 2012 13:11:06 -0300

perf scripts: Add --symbols option to handle specific symbols

Since perf script no longer only handle the trace points, we can add the
symbol filter option so that scripts can handle specified samples.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1347007349-3102-3-git-send-email-feng.tang@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 6d98a83..76577e6 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -14,6 +14,7 @@
 #include "util/util.h"
 #include "util/evlist.h"
 #include "util/evsel.h"
+#include "util/sort.h"
 #include <linux/bitmap.h>
 
 static char const		*script_name;
@@ -1143,6 +1144,8 @@ static const struct option options[] = {
 		     parse_output_fields),
 	OPT_BOOLEAN('a', "all-cpus", &system_wide,
 		     "system-wide collection from all CPUs"),
+	OPT_STRING('S', "symbols", &symbol_conf.sym_list_str, "symbol[,symbol...]",
+		   "only consider these symbols"),
 	OPT_STRING('C', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
 	OPT_STRING('c', "comms", &symbol_conf.comm_list_str, "comm[,comm...]",
 		   "only display events for these comms"),
