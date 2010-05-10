Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab0EJEsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 00:48:20 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34682 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab0EJErM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 00:47:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Gwdh/qpUCv34YQqWf/3G3UiRvZ2FAc9J8hDqoXh/PgCPPGtjLqpCbTZ9KunQN5Hyhm
         di360iPK75IcrzKEmY9i5JSNPqse0TO1lFVkTIFjZ3GMdpNtTw3rCy3KOuEADC+Qpjxt
         cIXEcae4rDSvk0pZL2tQSxbPXJVhH3mFgEvL4=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, acme@ghostprotocols.net
Subject: [PATCH 5/9] perf/trace/scripting: workqueue-stats script cleanup
Date: Sun,  9 May 2010 23:46:56 -0500
Message-Id: <1273466820-9330-6-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1273466820-9330-1-git-send-email-tzanussi@gmail.com>
References: <1273466820-9330-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some minor fixes for the workqueue-stats script:

- Fix nuisance 'use of uninitialized value' warnings

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
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
1.6.4.GIT

