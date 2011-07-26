Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab1GZB0X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 21:26:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47975 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab1GZBYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 21:24:36 -0400
X-Authority-Analysis: v=1.1 cv=Pm0sEXe2MdIPK/rOEC7hwDW84D/yDsPO3JtCzsVYOFU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=SytJNmLq2e4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=0lcaQDnYBR9STwhpT9wA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110726012427.922315778@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 25 Jul 2011 21:22:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 14/19] ktest: Require one TEST_START in config file
References: <20110726012238.271008621@goodmis.org>
Content-Disposition: inline; filename=0014-ktest-Require-one-TEST_START-in-config-file.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

There has been too many times that I put in one too many SKIP
TEST_STARTs and start the test with the default randconfig by accident
that I added this to have ktest ask the user for which test they want to
run if no TEST_START is specified.

Now if I accidently start the test with all TEST_STARTs skipped, ktest
asks what test do I want to run, and I now have a chance to kill it
before it does a make mrproper on my build directory.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 099ceee..6166f3a 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -345,6 +345,7 @@ sub read_config {
     my $num_tests_set = 0;
     my $skip = 0;
     my $rest;
+    my $test_case = 0;
 
     while (<IN>) {
 
@@ -370,6 +371,7 @@ sub read_config {
 		$rest = $1;
 		$skip = 1;
 	    } else {
+		$test_case = 1;
 		$skip = 0;
 	    }
 
@@ -474,6 +476,15 @@ sub read_config {
     # make sure we have all mandatory configs
     get_ktest_configs;
 
+    # was a test specified?
+    if (!$test_case) {
+	print "No test case specified.\n";
+	print "What test case would you like to run?\n";
+	my $ans = <STDIN>;
+	chomp $ans;
+	$default{"TEST_TYPE"} = $ans;
+    }
+
     # set any defaults
 
     foreach my $default (keys %default) {
-- 
1.7.5.4


