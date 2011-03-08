Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab1CHP0s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 10:26:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55502 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749Ab1CHPZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 10:25:30 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=WYDb-MkGV_AA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=54WY_Q9KbpJxcML035YA:9 a=UF5lZtWDP2ul6rR3CjJGKBuW2w8A:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110308152528.730443408@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 08 Mar 2011 10:22:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6/9] ktest: Add BISECT_FILES to run git bisect on paths
References: <20110308152158.799699072@goodmis.org>
Content-Disposition: inline; filename=0006-ktest-Add-BISECT_FILES-to-run-git-bisect-on-paths.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Add the config option BISECT_FILES that allows the user to
specify what path in the kernel to run the git bisect on.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl    |    9 ++++++++-
 tools/testing/ktest/sample.conf |    9 +++++++++
 2 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 0f62916..65c5c55 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1280,6 +1280,13 @@ sub bisect {
     my $type = $opt{"BISECT_TYPE[$i]"};
     my $start = $opt{"BISECT_START[$i]"};
     my $replay = $opt{"BISECT_REPLAY[$i]"};
+    my $start_files = $opt{"BISECT_FILES[$i]"};
+
+    if (defined($start_files)) {
+	$start_files = " -- " . $start_files;
+    } else {
+	$start_files = "";
+    }
 
     # convert to true sha1's
     $good = get_sha1($good);
@@ -1333,7 +1340,7 @@ sub bisect {
 	    die "Failed to checkout $head";
     }
 
-    run_command "git bisect start" or
+    run_command "git bisect start$start_files" or
 	dodie "could not start bisect";
 
     run_command "git bisect good $good" or
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.conf
index 4c46b7e..4c83ae7 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -528,6 +528,15 @@
 #   when something other than the BISECT_TYPE fails, ktest.pl will
 #   run "git bisect skip" and try again.
 #
+# BISECT_FILES = <path> (optional, default undefined)
+#
+#   To just run the git bisect on a specific path, set BISECT_FILES.
+#   For example:
+#
+#     BISECT_FILES = arch/x86 kernel/time
+#
+#   Will run the bisect with "git bisect start -- arch/x86 kernel/time"
+#
 # BISECT_REVERSE = 1 (optional, default 0)
 #
 #   In those strange instances where it was broken forever
-- 
1.7.2.3


