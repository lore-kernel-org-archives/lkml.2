Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab2B0TR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 14:17:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26951 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292Ab2B0TRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 14:17:24 -0500
X-Authority-Analysis: v=2.0 cv=Z7xu7QtA c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=syijb7dvkC0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=9C9NpJO2t9LjqTaBmBgA:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1330370242.25686.196.camel@gandalf.stny.rr.com>
Subject: [PATCH][GIT PULL][v3.3] ktest: Fix make_min_config test when build
 fails
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 27 Feb 2012 14:17:22 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

At ELC I was demoing ktest and stumbled on a small bug in the
make_min_config test that, embarrassingly, made a config that wouldn't
boot. As people are using your latest tree to get the ktest program
(those at the conference), I would like to have this bug fixed as people
will most likely hit this bug too.

Also, this is the first signed-tag pull request that I'm doing. I only
pushed the tag itself. I hope it worked. The tag name is below my
repository.

Thanks!

-- Steve


Please pull the latest for-linus tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-ktest.git
ktest-fix-make-min-failed-build

Head SHA1: bf1c95abaf24b56c45f458051c693f31fd9b7052


Steven Rostedt (1):
      ktest: Fix make_min_config test when build fails

----
 tools/testing/ktest/ktest.pl |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)
---------------------------
commit bf1c95abaf24b56c45f458051c693f31fd9b7052
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Mon Feb 27 13:58:49 2012 -0500

    ktest: Fix make_min_config test when build fails
    
    The make_min_config does not take into account when the build fails,
    resulting in a invalid MIN_CONFIG .config file. When the build fails,
    it is ignored and the boot test is executed, using the previous built
    kernel. The configs that should be tested are not tested and they may
    be added or removed depending on the result of the last kernel that
    succeeded to be built.
    
    If the build fails, mark the current config as a failure and the
    configs that were disabled may still be needed.
    
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 62a134d..9507c4b 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -3244,9 +3244,11 @@ sub make_min_config {
 	$in_bisect = 1;
 
 	my $failed = 0;
-	build "oldconfig";
-	start_monitor_and_boot or $failed = 1;
-	end_monitor;
+	build "oldconfig" or $failed = 1;
+	if (!$failed) {
+		start_monitor_and_boot or $failed = 1;
+		end_monitor;
+	}
 
 	$in_bisect = 0;
 


