Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab1GZBZC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 21:25:02 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33228 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab1GZBY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 21:24:26 -0400
X-Authority-Analysis: v=1.1 cv=sbbt6Wn8j+VvNVI1Ftt/uHhinWyuFt+R57MN9Ty2Tys= c=1 sm=0 a=vhdKIqpQuCYA:10 a=EKGgieDs2FkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=d9iESwFk6OaBoFjjqEkA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110726012424.494530158@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 25 Jul 2011 21:22:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 01/19] ktest: Notify reason to break out of monitoring boot
References: <20110726012238.271008621@goodmis.org>
Content-Disposition: inline; filename=0001-ktest-Notify-reason-to-break-out-of-monitoring-boot.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Different timeouts can cause the ktest monitor to break out of the
loop. It becomes annoying that one does not know the reason why
it exited the monitor loop. Display the cause of the reason why
the loop was exited.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index cef28e6..b96d381 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -841,12 +841,20 @@ sub monitor {
 
 	if ($booted) {
 	    $line = wait_for_input($monitor_fp, $booted_timeout);
+	    if (!defined($line)) {
+		my $s = $booted_timeout == 1 ? "" : "s";
+		doprint "Successful boot found: break after $booted_timeout second$s\n";
+		last;
+	    }
 	} else {
 	    $line = wait_for_input($monitor_fp);
+	    if (!defined($line)) {
+		my $s = $timeout == 1 ? "" : "s";
+		doprint "Timed out after $timeout second$s\n";
+		last;
+	    }
 	}
 
-	last if (!defined($line));
-
 	doprint $line;
 	print DMESG $line;
 
-- 
1.7.5.4


