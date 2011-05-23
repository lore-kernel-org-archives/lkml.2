Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab1EWLbl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 07:31:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:34815 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076Ab1EWLbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 07:31:40 -0400
Date: Mon, 23 May 2011 11:31:22 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Message-ID: <tip-3cb6d1540880e767d911b79eb49578de2190f428@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1306148788-6179-2-git-send-email-fweisbec@gmail.com>
References: <1306148788-6179-2-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Fix sample size bit operations
Git-Commit-ID: 3cb6d1540880e767d911b79eb49578de2190f428
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 23 May 2011 11:31:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3cb6d1540880e767d911b79eb49578de2190f428
Gitweb:     http://git.kernel.org/tip/3cb6d1540880e767d911b79eb49578de2190f428
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Mon, 23 May 2011 13:06:27 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 May 2011 13:26:36 +0200

perf tools: Fix sample size bit operations

What we want is to count the number of bits in the mask,
not some other random operation written in the middle
of the night.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1306148788-6179-2-git-send-email-fweisbec@gmail.com
[ Fixed perf_event__names[] alignment which was nearby and hurting my eyes ... ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/event.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 17c1c3c..252b72a 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -9,21 +9,21 @@
 #include "thread_map.h"
 
 static const char *perf_event__names[] = {
-	[0]			 = "TOTAL",
-	[PERF_RECORD_MMAP]	 = "MMAP",
-	[PERF_RECORD_LOST]	 = "LOST",
-	[PERF_RECORD_COMM]	 = "COMM",
-	[PERF_RECORD_EXIT]	 = "EXIT",
-	[PERF_RECORD_THROTTLE]	 = "THROTTLE",
-	[PERF_RECORD_UNTHROTTLE] = "UNTHROTTLE",
-	[PERF_RECORD_FORK]	 = "FORK",
-	[PERF_RECORD_READ]	 = "READ",
-	[PERF_RECORD_SAMPLE]	 = "SAMPLE",
-	[PERF_RECORD_HEADER_ATTR]	 = "ATTR",
-	[PERF_RECORD_HEADER_EVENT_TYPE]	 = "EVENT_TYPE",
-	[PERF_RECORD_HEADER_TRACING_DATA]	 = "TRACING_DATA",
-	[PERF_RECORD_HEADER_BUILD_ID]	 = "BUILD_ID",
-	[PERF_RECORD_FINISHED_ROUND]	 = "FINISHED_ROUND",
+	[0]					= "TOTAL",
+	[PERF_RECORD_MMAP]			= "MMAP",
+	[PERF_RECORD_LOST]			= "LOST",
+	[PERF_RECORD_COMM]			= "COMM",
+	[PERF_RECORD_EXIT]			= "EXIT",
+	[PERF_RECORD_THROTTLE]			= "THROTTLE",
+	[PERF_RECORD_UNTHROTTLE]		= "UNTHROTTLE",
+	[PERF_RECORD_FORK]			= "FORK",
+	[PERF_RECORD_READ]			= "READ",
+	[PERF_RECORD_SAMPLE]			= "SAMPLE",
+	[PERF_RECORD_HEADER_ATTR]		= "ATTR",
+	[PERF_RECORD_HEADER_EVENT_TYPE]		= "EVENT_TYPE",
+	[PERF_RECORD_HEADER_TRACING_DATA]	= "TRACING_DATA",
+	[PERF_RECORD_HEADER_BUILD_ID]		= "BUILD_ID",
+	[PERF_RECORD_FINISHED_ROUND]		= "FINISHED_ROUND",
 };
 
 const char *perf_event__name(unsigned int id)
@@ -42,7 +42,7 @@ int perf_sample_size(u64 sample_type)
 	int i;
 
 	for (i = 0; i < 64; i++) {
-		if ((mask << i) & 1)
+		if (mask & (1UL << i))
 			size++;
 	}
 
