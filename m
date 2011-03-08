Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab1CHP0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 10:26:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:55482 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798Ab1CHPZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 10:25:31 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=_Atk6O0qAXQA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=BM5NF0PkXgaL02LBgS4A:9 a=QFN9-i7JxP_z8XAzGlX9HLXGin0A:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110308152528.995957273@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 08 Mar 2011 10:22:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7/9] ktest: Fix bug where the test would not end after failure
References: <20110308152158.799699072@goodmis.org>
Content-Disposition: inline; filename=0007-ktest-Fix-bug-where-the-test-would-not-end-after-fai.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The config STOP_AFTER_FAILURE is the number of seconds to continue
the test when a failure is detected. This lets the monitor record
more data to the logs and console that may be helpful in solving
the bug that was found.

But the test had a bug. If the failure caused multiple
"Call Trace" stack dumps, the start time to compare the
STOP_AFTER_FAILURE would constantly be reset. Only update the start
time at the first "Call Trace" instance.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 65c5c55..125ab94 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -804,7 +804,7 @@ sub monitor {
 	}
 
 	if ($full_line =~ /call trace:/i) {
-	    if (!$skip_call_trace) {
+	    if (!$bug && !$skip_call_trace) {
 		$bug = 1;
 		$failure_start = time;
 	    }
-- 
1.7.2.3


