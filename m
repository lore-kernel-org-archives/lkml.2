Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880Ab2DXVu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 17:50:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24525 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757310Ab2DXVuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 17:50:55 -0400
X-Authority-Analysis: v=2.0 cv=XbcLPfF5 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Fe8JwCa6ILMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=VwQbUJbxAAAA:8 a=sozttTNsAAAA:8 a=meVymXHHAAAA:8 a=oI_w9Qc0qDhhcDqVKwUA:9 a=PUjeQqilurYA:10 a=Gq9PjJF5URkA:10 a=x2szoZtqnggA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1335304253.28106.149.camel@gandalf.stny.rr.com>
Subject: [PATCH][GIT PULL] ktest.pl: Fix combined usage of BISECT_REVERSE
 and BISECT_SKIP
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Russ Dill <Russ.Dill@ti.com>
Date: Tue, 24 Apr 2012 17:50:53 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull the latest ktest-v3.4-rc4 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-ktest.git
ktest-v3.4-rc4

Head SHA1: 97f106a13ae6ff0bd8f37763ceab1644a77ca119


Russ Dill (1):
      ktest.pl: Fix combined usage of BISECT_REVERSE and BISECT_SKIP

----
 tools/testing/ktest/ktest.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
---------------------------
commit 2bc90df49d62e213acaaea84b45abd9d6ceaa4c1
Author: Russ Dill <Russ.Dill@ti.com>
Date:   Mon Apr 23 19:43:00 2012 -0700

    ktest.pl: Fix combined usage of BISECT_REVERSE and BISECT_SKIP
    
    When BISECT_REVERSE and BISECT_SKIP are used together with boot or test
    testing, build failures are treated as boot or test failures and
    'git bisect bad' is executed instead of 'git bisect skip'. This is because
    the $ret value of -1 is treated as a build failure, but the $reverse_bisect
    logic does not properly handle this.
    
    Simple fix, only invert it if it is positive.
    
    Link: http://lkml.kernel.org/r/1335235380-8509-1-git-send-email-Russ.Dill@ti.com
    
    Signed-off-by: Russ Dill <Russ.Dill@ti.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

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
 


