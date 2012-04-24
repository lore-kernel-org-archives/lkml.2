Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463Ab2DXCnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 22:43:13 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48864 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361Ab2DXCnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 22:43:11 -0400
From: Russ Dill <Russ.Dill@ti.com>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>, Russ Dill <Russ.Dill@ti.com>
Subject: [PATCH v3] ktest.pl: Fix combined usage of BISECT_REVERSE and BISECT_SKIP
Date: Mon, 23 Apr 2012 19:43:00 -0700
Message-Id: <1335235380-8509-1-git-send-email-Russ.Dill@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1335222909-14191-1-git-send-email-Russ.Dill@ti.com>
References: <1335222909-14191-1-git-send-email-Russ.Dill@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v3: Ignore all negative values, not just -1.

When BISECT_REVERSE and BISECT_SKIP are used together with boot or test testing,
build failures are treated as boot or test failures and 'git bisect bad' is executed instead
of 'git bisect skip'. This is because the $ret value of -1 is treated as a build failure, but
the $reverse_bisect logic does not properly handle this.

Simple fix, only invert it if it is positive.

Signed-off-by: Russ Dill <Russ.Dill@ti.com>
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

