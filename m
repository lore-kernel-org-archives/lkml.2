Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab1AGKbH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 05:31:07 -0500
Received: from cantor.suse.de ([195.135.220.2]:43295 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498Ab1AGKaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 05:30:09 -0500
From: Thomas Renninger <trenn@suse.de>
Cc: linux-perf-users@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
        lenb@kernel.org, j-pihet@ti.com, Thomas Renninger <trenn@suse.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/9] perf (userspace): Introduce --verbose param for perf timechart
Date: Fri,  7 Jan 2011 11:29:48 +0100
Message-Id: <1294396190-23031-8-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1294396190-23031-1-git-send-email-trenn@suse.de>
References: <1294396190-23031-1-git-send-email-trenn@suse.de>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

by making use of the already available global verbose variable
from util/debug.h (similar to perf diff or perf top).

Some already introduced if (verbose) condtitions in util/svnhelper.c
will also be activated with that one.

Signed-off-by: Thomas Renninger <trenn@suse.de>
CC: Arjan van de Ven <arjan@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
CC: linux-perf-users@vger.kernel.org
---
 tools/perf/builtin-timechart.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 746cf03..54e9c37 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -31,6 +31,7 @@
 #include "util/event.h"
 #include "util/session.h"
 #include "util/svghelper.h"
+#include "util/debug.h"
 
 #define SUPPORT_OLD_POWER_EVENTS 1
 #define PWR_EVENT_EXIT -1
@@ -382,6 +383,10 @@ static void c_state_end(int cpu, u64 timestamp)
 	pwr->next = power_events;
 
 	power_events = pwr;
+	if (verbose)
+		printf("CPU: %d - start_time: %llu - end_time: %llu\n",
+		       power_events->cpu, power_events->start_time,
+		       power_events->end_time);
 }
 
 static void p_state_change(int cpu, u64 timestamp, u64 new_freq)
@@ -1069,6 +1074,8 @@ parse_process(const struct option *opt __used, const char *arg, int __used unset
 }
 
 static const struct option options[] = {
+	OPT_INCR('v', "verbose", &verbose,
+		    "print extended debug info to stdout"),
 	OPT_STRING('i', "input", &input_name, "file",
 		    "input file name"),
 	OPT_STRING('o', "output", &output_name, "file",
-- 
1.7.3.1

