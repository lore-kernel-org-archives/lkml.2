Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab1EWNxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 09:53:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64488 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677Ab1EWNxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 09:53:15 -0400
X-Authority-Analysis: v=1.1 cv=u/eXSd3k4P+OuNmbl5aZU3ellt6eTxbOnGssQLT4hSY= c=1 sm=0 a=vhdKIqpQuCYA:10 a=B4H3_XNQ7NkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=1JS0_13_If6MzOpMcOYA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110523135314.617304764@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 23 May 2011 09:51:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/6] ktest: If test failed due to timeout, print that
References: <20110523135120.309567301@goodmis.org>
Content-Disposition: inline; filename=0002-ktest-If-test-failed-due-to-timeout-print-that.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

If the test failed due to timeout for boot, print a message saying
so. Otherwise the user will be confused to why their test just failed.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 7301d03..0603e64 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -838,6 +838,7 @@ sub monitor {
 
 	if ($stop_test_after > 0 && !$booted && !$bug) {
 	    if (time - $monitor_start > $stop_test_after) {
+		doprint "STOP_TEST_AFTER ($stop_test_after seconds) timed out\n";
 		$done = 1;
 	    }
 	}
-- 
1.7.4.4


