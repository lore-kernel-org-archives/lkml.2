Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283Ab1FGOpy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 10:45:54 -0400
Received: from smtp-out.google.com ([74.125.121.67]:10231 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab1FGOpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 10:45:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Eayrl2bQw0pGxS6yncAXnC4H31Osx2MinLfV5nxZxEqRe9B53x8kEKD+M/H4LyRZ+q
         UISO4B6GL/dbBGRPlIxw==
Date: Tue, 7 Jun 2011 16:45:33 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org, acme@redhat.com
Subject: [PATCH] perf: bug fix and cleanups for perf lock
Message-ID: <20110607144533.GA7359@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes the event names used by perf lock. The :r suffix
is not supported anymore, it seems.

The patch also cleans up the help and man page to reflect
actual options. The perf lock trace option does not exist
anymore, AFAICT. When you use it, you get an error but you
have no idea why.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/tools/perf/Documentation/perf-lock.txt b/tools/perf/Documentation/perf-lock.txt
index 4a26a2f..64c7a5a 100644
--- a/tools/perf/Documentation/perf-lock.txt
+++ b/tools/perf/Documentation/perf-lock.txt
@@ -8,7 +8,7 @@ perf-lock - Analyze lock events
 SYNOPSIS
 --------
 [verse]
-'perf lock' {record|report|trace}
+'perf lock' {record|report|script}
 
 DESCRIPTION
 -----------
@@ -20,7 +20,7 @@ and statistics with this 'perf lock' command.
   produces the file "perf.data" which contains tracing
   results of lock events.
 
-  'perf lock trace' shows raw lock events.
+  'perf lock script' shows raw lock events.
 
   'perf lock report' reports statistical data.
 
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 9ac05aa..c24b820 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -925,7 +925,7 @@ static const struct option info_options[] = {
 };
 
 static const char * const lock_usage[] = {
-	"perf lock [<options>] {record|trace|report}",
+	"perf lock [<options>] {record|script|report|info}",
 	NULL
 };
 
@@ -942,10 +942,10 @@ static const char *record_args[] = {
 	"-f",
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
