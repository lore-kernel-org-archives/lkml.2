Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244Ab2EBAyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 20:54:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21694 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab2EBAyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 20:54:17 -0400
X-Authority-Analysis: v=2.0 cv=fvFelSEf c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=AgoqaY6-wiIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=sozttTNsAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=Cy0GkuCSYmtOqYyWeFMA:9 a=9rm9Eiz7d7cA:10 a=x2szoZtqnggA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120502005415.756997253@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 01 May 2012 20:44:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Russ Dill <Russ.Dill@ti.com>
Subject: [PATCH 1/2] ktest.pl: Fix combined usage of BISECT_REVERSE and BISECT_SKIP
References: <20120502004439.965120020@goodmis.org>
Content-Disposition: inline; filename=0001-ktest.pl-Fix-combined-usage-of-BISECT_REVERSE-and-BI.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russ Dill <Russ.Dill@ti.com>

When BISECT_REVERSE and BISECT_SKIP are used together with boot or test
testing, build failures are treated as boot or test failures and
'git bisect bad' is executed instead of 'git bisect skip'. This is because
the $ret value of -1 is treated as a build failure, but the $reverse_bisect
logic does not properly handle this.

Simple fix, only invert it if it is positive.

Link: http://lkml.kernel.org/r/1335235380-8509-1-git-send-email-Russ.Dill@ti.com

Signed-off-by: Russ Dill <Russ.Dill@ti.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 95d6a6f..d2ede59 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -2192,7 +2192,7 @@ sub run_bisect {
     }
 
     # Are we looking for where it worked, not failed?
-    if ($reverse_bisect) {
+    if ($reverse_bisect && $ret >= 0) {
 	$ret = !$ret;
     }
 
-- 
1.7.9.5


