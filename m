Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab1GZB0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 21:26:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33228 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936Ab1GZBYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 21:24:32 -0400
X-Authority-Analysis: v=1.1 cv=sbbt6Wn8j+VvNVI1Ftt/uHhinWyuFt+R57MN9Ty2Tys= c=1 sm=0 a=vhdKIqpQuCYA:10 a=O82Dm4fRqkYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=fs_Kvdk5qjXsthMDf1oA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110726012426.892699368@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 25 Jul 2011 21:22:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 10/19] ktest: Have the testing tmp dir include machine name
References: <20110726012238.271008621@goodmis.org>
Content-Disposition: inline; filename=0010-ktest-Have-the-testing-tmp-dir-include-machine-name.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

As multiple tests may be executed by the same server, have the test
machine name add uniqueness to the value of the temp directory.
Otherwise the temp directories may overwrite each other's tests.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl    |    2 +-
 tools/testing/ktest/sample.conf |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index d0e1de6..24286ce 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -27,7 +27,7 @@ $default{"TEST_TYPE"}		= "test";
 $default{"BUILD_TYPE"}		= "randconfig";
 $default{"MAKE_CMD"}		= "make";
 $default{"TIMEOUT"}		= 120;
-$default{"TMP_DIR"}		= "/tmp/ktest";
+$default{"TMP_DIR"}		= "/tmp/ktest/\${MACHINE}";
 $default{"SLEEP_TIME"}		= 60;	# sleep time between tests
 $default{"BUILD_NOCLEAN"}	= 0;
 $default{"REBOOT_ON_ERROR"}	= 0;
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.conf
index 1092e47..e2d8d83 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -392,8 +392,8 @@
 #ADD_CONFIG = /home/test/config-broken
 
 # The location on the host where to write temp files
-# (default /tmp/ktest)
-#TMP_DIR = /tmp/ktest
+# (default /tmp/ktest/${MACHINE})
+#TMP_DIR = /tmp/ktest/${MACHINE}
 
 # Optional log file to write the status (recommended)
 #  Note, this is a DEFAULT section only option.
-- 
1.7.5.4


