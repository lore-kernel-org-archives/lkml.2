Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881Ab1LBPlZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 10:41:25 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33266 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab1LBPlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 10:41:24 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/2] selftests: New very basic kernel selftests directory
Date: Fri,  2 Dec 2011 16:41:14 +0100
Message-Id: <1322840475-19553-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bring a new kernel selftests directory in tools/testing/selftests.
To add a new selftest, create a subdirectory with the sources and
a makefile that creates a target named "run_test" then add the
subdirectory name to the TARGET var in tools/testing/selftests/Makefile
and tools/testing/selftests/run_tests script.

This can help centralizing and maintaining any useful selftest that
developers usually tend to let rust in peace on some random server.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/testing/selftests/Makefile  |   11 +++++++++++
 tools/testing/selftests/run_tests |    8 ++++++++
 2 files changed, 19 insertions(+), 0 deletions(-)
 create mode 100644 tools/testing/selftests/Makefile
 create mode 100755 tools/testing/selftests/run_tests

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
new file mode 100644
index 0000000..298a5c0
--- /dev/null
+++ b/tools/testing/selftests/Makefile
@@ -0,0 +1,11 @@
+TARGETS =
+
+all:
+	for TARGET in $(TARGETS); do \
+		make -C $$TARGET; \
+	done;
+
+clean:
+	for TARGET in $(TARGETS); do \
+		make -C $$TARGET clean; \
+	done;
diff --git a/tools/testing/selftests/run_tests b/tools/testing/selftests/run_tests
new file mode 100755
index 0000000..701960d
--- /dev/null
+++ b/tools/testing/selftests/run_tests
@@ -0,0 +1,8 @@
+#!/bin/bash
+
+TARGETS=
+
+for TARGET in $TARGETS
+do
+	$TARGET/run_test
+done
-- 
1.7.5.4

