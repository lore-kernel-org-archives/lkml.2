Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab0EJErP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 00:47:15 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55381 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab0EJErK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 00:47:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DccFPbOUQmS9f3OATJR5p4c+hb7dQCXPeFLM7qfa8fo4Tt/6T1QSl4ztdK1FvjZwKP
         2EqoiuONwZ6Wl6vDrbvrO7sndGixwI62Ux5Rc/y7F1WvTLhFkX4J5dn4Q/wP0rWqaV19
         qjz25kur3wZO98R5VkL2pT2xnP8Ir06S9eH0E=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, acme@ghostprotocols.net
Subject: [PATCH 4/9] perf/trace/scripting: wakeup-latency script cleanup
Date: Sun,  9 May 2010 23:46:55 -0500
Message-Id: <1273466820-9330-5-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1273466820-9330-1-git-send-email-tzanussi@gmail.com>
References: <1273466820-9330-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some minor fixes for the wakeup-latency script:

- Fix nuisance 'use of uninitialized value' warnings

- Avoid divide-by-zero error

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
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
1.6.4.GIT

