Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab2GHAZr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 20:25:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54685 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab2GHAYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 20:24:53 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH -mm 3/3] fault-injection: mention failcmd.sh tool in document
Date: Sun,  8 Jul 2012 09:24:26 +0900
Message-Id: <1341707066-10742-3-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341707066-10742-1-git-send-email-akinobu.mita@gmail.com>
References: <1341707066-10742-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fault-injection-add-tool-to-run-command-with-failslab-or-fail_page_alloc.patch
in -mm tree adds tools/testing/fault-injection/failcmd.sh to make it
easier to inject slab/page allocation failures by fault injection.

This adds the introduction to
Documentation/fault-injection/fault-injection.txt.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 Documentation/fault-injection/fault-injection.txt |   27 +++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/Documentation/fault-injection/fault-injection.txt b/Documentation/fault-injection/fault-injection.txt
index dc77948..832fc4f 100644
--- a/Documentation/fault-injection/fault-injection.txt
+++ b/Documentation/fault-injection/fault-injection.txt
@@ -241,3 +241,30 @@ trap "echo 0 > /sys/kernel/debug/$FAILTYPE/probability" SIGINT SIGTERM EXIT
 echo "Injecting errors into the module $module... (interrupt to stop)"
 sleep 1000000
 
+Tool to run command with failslab or fail_page_alloc
+----------------------------------------------------
+In order to make it easier to accomplish the tasks mentioned above, we can use
+tools/testing/fault-injection/failcmd.sh.  Please run a command
+"./tools/testing/fault-injection/failcmd.sh --help" for more information and
+see the following examples.
+
+Examples:
+
+Run a command "make -C tools/testing/selftests/ run_tests" with injecting slab
+allocation failure.
+
+	# ./tools/testing/fault-injection/failcmd.sh \
+		-- make -C tools/testing/selftests/ run_tests
+
+Same as above except to specify 100 times failures at most instead of one time
+at most by default.
+
+	# ./tools/testing/fault-injection/failcmd.sh --times=100 \
+		-- make -C tools/testing/selftests/ run_tests
+
+Same as above except to inject page allocation failure instead of slab
+allocation failure.
+
+	# env FAILCMD_TYPE=fail_page_alloc \
+		./tools/testing/fault-injection/failcmd.sh --times=100 \
+                -- make -C tools/testing/selftests/ run_tests
-- 
1.7.10.4

