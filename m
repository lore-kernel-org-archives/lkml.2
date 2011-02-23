Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab1BWNgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 08:36:35 -0500
Received: from casper.infradead.org ([85.118.1.10]:58207 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469Ab1BWNge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 08:36:34 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Marcin Slusarz <marcin.slusarz@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/2] perf lock: Document valid sort keys
Date: Wed, 23 Feb 2011 10:36:27 -0300
Message-Id: <1298468187-6096-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1298468187-6096-1-git-send-email-acme@infradead.org>
References: <1298468187-6096-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcin Slusarz <marcin.slusarz@gmail.com>

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20110222205312.GA18474@joi.lan>
Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-lock.txt |   12 ++++++++++--
 tools/perf/builtin-lock.c              |    2 +-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/perf-lock.txt b/tools/perf/Documentation/perf-lock.txt
index 921de25..4a26a2f 100644
--- a/tools/perf/Documentation/perf-lock.txt
+++ b/tools/perf/Documentation/perf-lock.txt
@@ -24,8 +24,8 @@ and statistics with this 'perf lock' command.
 
   'perf lock report' reports statistical data.
 
-OPTIONS
--------
+COMMON OPTIONS
+--------------
 
 -i::
 --input=<file>::
@@ -39,6 +39,14 @@ OPTIONS
 --dump-raw-trace::
         Dump raw trace in ASCII.
 
+REPORT OPTIONS
+--------------
+
+-k::
+--key=<value>::
+        Sorting key. Possible values: acquired (default), contended,
+        wait_total, wait_max, wait_min.
+
 SEE ALSO
 --------
 linkperf:perf[1]
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index e00d938..2e93f99 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -893,7 +893,7 @@ static const char * const report_usage[] = {
 
 static const struct option report_options[] = {
 	OPT_STRING('k', "key", &sort_key, "acquired",
-		    "key for sorting"),
+		    "key for sorting (acquired / contended / wait_total / wait_max / wait_min)"),
 	/* TODO: type */
 	OPT_END()
 };
-- 
1.6.2.5

