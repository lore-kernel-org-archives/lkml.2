Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935091Ab1IOVcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 17:32:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:16206 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934998Ab1IOVb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 17:31:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,389,1312182000"; 
   d="scan'208";a="54195376"
From: Andi Kleen <andi@firstfloor.org>
To: acme@ghostprotocols.net
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 3/3] perf: Clarify -c help text
Date: Thu, 15 Sep 2011 14:31:42 -0700
Message-Id: <1316122302-24306-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316122302-24306-1-git-send-email-andi@firstfloor.org>
References: <1316122302-24306-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Clarify what perf record/top -c actually does in the help text.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Documentation/perf-record.txt |    6 +++---
 tools/perf/Documentation/perf-top.txt    |    2 +-
 tools/perf/builtin-record.c              |    2 +-
 tools/perf/builtin-top.c                 |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 5a520f8..f636cc8 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -72,9 +72,9 @@ OPTIONS
 --force::
 	Overwrite existing data file. (deprecated)
 
--c::
---count=::
-	Event period to sample.
+-cN::
+--count=N::
+	Sample event every N occurrences.
 
 -o::
 --output=::
diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index f6eb1cd..b6043b0 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -23,7 +23,7 @@ OPTIONS
 
 -c <count>::
 --count=<count>::
-	Event period to sample.
+	Sample event every COUNT occurrences.
 
 -C <cpu-list>::
 --cpu=<cpu>::
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 042117f..22a9a27 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -761,7 +761,7 @@ const struct option record_options[] = {
 		    "list of cpus to monitor"),
 	OPT_BOOLEAN('f', "force", &force,
 			"overwrite existing data file (deprecated)"),
-	OPT_U64('c', "count", &user_interval, "event period to sample"),
+	OPT_U64('c', "count", &user_interval, "sample every COUNTS events"),
 	OPT_STRING('o', "output", &output_name, "file",
 		    "output file name"),
 	OPT_BOOLEAN('i', "no-inherit", &no_inherit,
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index a43433f..79bfb5d 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -992,7 +992,7 @@ static const struct option options[] = {
 		     "event selector. use 'perf list' to list available events",
 		     parse_events_option),
 	OPT_INTEGER('c', "count", &default_interval,
-		    "event period to sample"),
+		    "sample event every N occurrences"),
 	OPT_INTEGER('p', "pid", &top.target_pid,
 		    "profile events on existing process id"),
 	OPT_INTEGER('t', "tid", &top.target_tid,
-- 
1.7.4.4

