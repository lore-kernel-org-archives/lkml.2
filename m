Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125Ab1GZBYw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 21:24:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63368 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab1GZBY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 21:24:27 -0400
X-Authority-Analysis: v=1.1 cv=s3eDhkhcaTLnj7IEXy8aaXUiY7FbET0mf+/2Xe0elbc= c=1 sm=0 a=vhdKIqpQuCYA:10 a=4QiUszmc-mEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=fYFMpAs7BQ0P5jfUwEAA:9 a=R8l9n4QTuz-KE_E5gc8A:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=yFUa0BxowBysKeqY:21 a=HFNXlz9igwSsRHxM:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110726012425.290369841@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 25 Jul 2011 21:22:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 04/19] ktest: Add TEST_NAME option
References: <20110726012238.271008621@goodmis.org>
Content-Disposition: inline; filename=0004-ktest-Add-TEST_NAME-option.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Searching through several tests, it gets confusing which test result
is for which test. By adding the TEST_NAME option, the user can tell
which test result belongs to which test.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl    |   18 ++++++++++++++++--
 tools/testing/ktest/sample.conf |    6 ++++++
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index dbc02de..579569f 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -101,6 +101,7 @@ my $sleep_time;
 my $bisect_sleep_time;
 my $patchcheck_sleep_time;
 my $store_failures;
+my $test_name;
 my $timeout;
 my $booted_timeout;
 my $detect_triplefault;
@@ -620,9 +621,15 @@ sub fail {
 	    end_monitor;
 	}
 
+	my $name = "";
+
+	if (defined($test_name)) {
+	    $name = " ($test_name)";
+	}
+
 	doprint "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n";
 	doprint "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n";
-	doprint "KTEST RESULT: TEST $i Failed: ", @_, "\n";
+	doprint "KTEST RESULT: TEST $i$name Failed: ", @_, "\n";
 	doprint "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n";
 	doprint "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n";
 
@@ -1130,9 +1137,15 @@ sub success {
 
     $successes++;
 
+    my $name = "";
+
+    if (defined($test_name)) {
+	$name = " ($test_name)";
+    }
+
     doprint "\n\n*******************************************\n";
     doprint     "*******************************************\n";
-    doprint     "KTEST RESULT: TEST $i SUCCESS!!!!         **\n";
+    doprint     "KTEST RESULT: TEST $i$name SUCCESS!!!!         **\n";
     doprint     "*******************************************\n";
     doprint     "*******************************************\n";
 
@@ -2181,6 +2194,7 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
     $bisect_skip = set_test_option("BISECT_SKIP", $i);
     $config_bisect_good = set_test_option("CONFIG_BISECT_GOOD", $i);
     $store_failures = set_test_option("STORE_FAILURES", $i);
+    $test_name = set_test_option("TEST_NAME", $i);
     $timeout = set_test_option("TIMEOUT", $i);
     $booted_timeout = set_test_option("BOOTED_TIMEOUT", $i);
     $console = set_test_option("CONSOLE", $i);
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.conf
index be531c2..0e5f764 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -545,6 +545,12 @@
 #  all preceding tests until a new CHECKOUT is set.
 #
 #
+# TEST_NAME = name
+#
+#  If you want the test to have a name that is displayed in
+#  the test result banner at the end of the test, then use this
+#  option. This is useful to search for the RESULT keyword and
+#  not have to translate a test number to a test in the config.
 #
 # For TEST_TYPE = patchcheck
 #
-- 
1.7.5.4


