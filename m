Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932711Ab0EJXZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:25:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:50153 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932594Ab0EJWxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:53:19 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tzanussi@gmail.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/10] perf/trace/scripting: workqueue-stats script cleanup
Date: Mon, 10 May 2010 19:53:04 -0300
Message-Id: <1273531987-28956-7-git-send-email-acme@infradead.org>
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

Some minor fixes for the workqueue-stats script:

 - Fix nuisance 'use of uninitialized value' warnings

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <1273466820-9330-6-git-send-email-tzanussi@gmail.com>
Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/scripts/perl/workqueue-stats.pl |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/perf/scripts/perl/workqueue-stats.pl b/tools/perf/scripts/perl/workqueue-stats.pl
index 511302c..b84b126 100644
--- a/tools/perf/scripts/perl/workqueue-stats.pl
+++ b/tools/perf/scripts/perl/workqueue-stats.pl
@@ -71,9 +71,9 @@ sub trace_end
     printf("%3s %6s %6s\t%-20s\n", "---", "---", "----", "----");
     foreach my $pidhash (@cpus) {
 	while ((my $pid, my $wqhash) = each %$pidhash) {
-	    my $ins = $$wqhash{'inserted'};
-	    my $exe = $$wqhash{'executed'};
-	    my $comm = $$wqhash{'comm'};
+	    my $ins = $$wqhash{'inserted'} || 0;
+	    my $exe = $$wqhash{'executed'} || 0;
+	    my $comm = $$wqhash{'comm'} || "";
 	    if ($ins || $exe) {
 		printf("%3u %6u %6u\t%-20s\n", $cpu, $ins, $exe, $comm);
 	    }
@@ -87,9 +87,9 @@ sub trace_end
     printf("%3s %6s %6s\t%-20s\n", "---", "-------", "---------", "----");
     foreach my $pidhash (@cpus) {
 	while ((my $pid, my $wqhash) = each %$pidhash) {
-	    my $created = $$wqhash{'created'};
-	    my $destroyed = $$wqhash{'destroyed'};
-	    my $comm = $$wqhash{'comm'};
+	    my $created = $$wqhash{'created'} || 0;
+	    my $destroyed = $$wqhash{'destroyed'} || 0;
+	    my $comm = $$wqhash{'comm'} || "";
 	    if ($created || $destroyed) {
 		printf("%3u %6u %6u\t%-20s\n", $cpu, $created, $destroyed,
 		       $comm);
-- 
1.6.2.5

