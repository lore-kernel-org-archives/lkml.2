Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab1BVPjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 10:39:12 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:55521 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517Ab1BVPjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 10:39:10 -0500
X-Greylist: delayed 636 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Feb 2011 10:39:10 EST
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, mitake@dcl.info.waseda.ac.jp,
        h.mitake@gmail.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] perf lock: clean the options for perf record
Date: Wed, 23 Feb 2011 00:28:27 +0900
Message-Id: <1298388507-19774-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hitoshi Mitake <h.mitake@gmail.com>

Hi Frederic, really sorry for my slow work...

This patch cleans the options passed for perf record(or cmd_record()).
1. remove ":r" at the tail of the name of events, because it is not supported now
2. remove "-f" deprecated option, because it is already default

Signed-off-by: Hitoshi Mitake <h.mitake@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 tools/perf/builtin-lock.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index e00d938..2359f52 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -926,13 +926,12 @@ static const struct option lock_options[] = {
 static const char *record_args[] = {
 	"record",
 	"-R",
-	"-f",
 	"-m", "1024",
 	"-c", "1",
-	"-e", "lock:lock_acquire:r",
-	"-e", "lock:lock_acquired:r",
-	"-e", "lock:lock_contended:r",
-	"-e", "lock:lock_release:r",
+	"-e", "lock:lock_acquire",
+	"-e", "lock:lock_acquired",
+	"-e", "lock:lock_contended",
+	"-e", "lock:lock_release",
 };
 
 static int __cmd_record(int argc, const char **argv)
-- 
1.7.3.3

