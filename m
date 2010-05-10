Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932824Ab0EJW4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 18:56:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:50150 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932593Ab0EJWxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:53:19 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tzanussi@gmail.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/10] perf/trace/scripting: wakeup-latency script cleanup
Date: Mon, 10 May 2010 19:53:03 -0300
Message-Id: <1273531987-28956-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1273531987-28956-1-git-send-email-acme@infradead.org>
References: <1273531987-28956-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <tzanussi@gmail.com>

Some minor fixes for the wakeup-latency script:

 - Fix nuisance 'use of uninitialized value' warnings

 - Avoid divide-by-zero error

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <1273466820-9330-5-git-send-email-tzanussi@gmail.com>
Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/scripts/perl/wakeup-latency.pl |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/perf/scripts/perl/wakeup-latency.pl b/tools/perf/scripts/perl/wakeup-latency.pl
index ed58ef2..d9143dc 100644
--- a/tools/perf/scripts/perl/wakeup-latency.pl
+++ b/tools/perf/scripts/perl/wakeup-latency.pl
@@ -22,8 +22,8 @@ my %last_wakeup;
 
 my $max_wakeup_latency;
 my $min_wakeup_latency;
-my $total_wakeup_latency;
-my $total_wakeups;
+my $total_wakeup_latency = 0;
+my $total_wakeups = 0;
 
 sub sched::sched_switch
 {
@@ -67,8 +67,12 @@ sub trace_end
 {
     printf("wakeup_latency stats:\n\n");
     print "total_wakeups: $total_wakeups\n";
-    printf("avg_wakeup_latency (ns): %u\n",
-	   avg($total_wakeup_latency, $total_wakeups));
+    if ($total_wakeups) {
+	printf("avg_wakeup_latency (ns): %u\n",
+	       avg($total_wakeup_latency, $total_wakeups));
+    } else {
+	printf("avg_wakeup_latency (ns): N/A\n");
+    }
     printf("min_wakeup_latency (ns): %u\n", $min_wakeup_latency);
     printf("max_wakeup_latency (ns): %u\n", $max_wakeup_latency);
 
-- 
1.6.2.5

