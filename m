Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab1EWNyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 09:54:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64488 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107Ab1EWNxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 09:53:16 -0400
X-Authority-Analysis: v=1.1 cv=u/eXSd3k4P+OuNmbl5aZU3ellt6eTxbOnGssQLT4hSY= c=1 sm=0 a=vhdKIqpQuCYA:10 a=LfW8AmoCqf8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=r2TLMV5xLo1mi54m2pYA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110523135314.896139545@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 23 May 2011 09:51:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/6] ktest: Reboot to good kernel after every bisect run
References: <20110523135120.309567301@goodmis.org>
Content-Disposition: inline; filename=0003-ktest-Reboot-to-good-kernel-after-every-bisect-run.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Reboot after each bisect run regardless if the bisect passed
or failed. The test may just be to boot the kernel and that kernel
may not have a way to copy the next kerne to it. Reboot to a known
good kernel after each bisect run.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 0603e64..2011222 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1248,14 +1248,14 @@ sub run_bisect_test {
 
     if ($failed) {
 	$result = 0;
-
-	# reboot the box to a good kernel
-	if ($type ne "build") {
-	    bisect_reboot;
-	}
     } else {
 	$result = 1;
     }
+
+    # reboot the box to a kernel we can ssh to
+    if ($type ne "build") {
+	bisect_reboot;
+    }
     $in_bisect = 0;
 
     return $result;
-- 
1.7.4.4


