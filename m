Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab2DWXJK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 19:09:10 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42159 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291Ab2DWXJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 19:09:08 -0400
From: Russ Dill <Russ.Dill@ti.com>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>, Russ Dill <Russ.Dill@ti.com>
Subject: [PATCH] Fix combined usage of BISECT_REVERSE and BISECT_SKIP
Date: Mon, 23 Apr 2012 16:08:59 -0700
Message-Id: <1335222539-31546-1-git-send-email-Russ.Dill@ti.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When BISECT_REVERSE and BISECT_SKIP are used together with boot or test testing,
build failures are treated as boot or test failures and 'git bisect bad' is executed instead
of 'git bisect good'. This is because the $ret value of -1 is treated as a build failure, but
the $reverse_bisect logic does not properly handle this.

Simple fix, don't invert $ret if it is -1.

Signed-off-by: Russ Dill <Russ.Dill@ti.com>
---
 tools/testing/ktest/ktest.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 95d6a6f..5221b00 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -2192,7 +2192,7 @@ sub run_bisect {
     }
 
     # Are we looking for where it worked, not failed?
-    if ($reverse_bisect) {
+    if ($reverse_bisect && $ret != -1) {
 	$ret = !$ret;
     }
 
-- 
1.7.9.5

