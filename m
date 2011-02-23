Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab1BWOwz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 09:52:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:33149 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336Ab1BWOww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 09:52:52 -0500
Date: Wed, 23 Feb 2011 14:52:26 GMT
From: tip-bot for Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110222205312.GA18474@joi.lan>
References: <20110222205312.GA18474@joi.lan>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf lock: Document valid sort keys
Message-ID: <tip-9826e8329bc160e4cc58b83019f3f056965e42d0@git.kernel.org>
Git-Commit-ID: 9826e8329bc160e4cc58b83019f3f056965e42d0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 23 Feb 2011 14:52:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9826e8329bc160e4cc58b83019f3f056965e42d0
Gitweb:     http://git.kernel.org/tip/9826e8329bc160e4cc58b83019f3f056965e42d0
Author:     Marcin Slusarz <marcin.slusarz@gmail.com>
AuthorDate: Tue, 22 Feb 2011 21:53:12 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 23 Feb 2011 07:29:33 -0300

perf lock: Document valid sort keys

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
