Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab1DWQXK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 12:23:10 -0400
Received: from glenfiddich.ikibiki.org ([88.191.124.82]:32828 "EHLO
	glenfiddich.ikibiki.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab1DWQXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 12:23:07 -0400
From: Cyril Brulebois <kibi@debian.org>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Cyril Brulebois <kibi@debian.org>
Subject: [PATCH 3/4] Documentation/00-INDEX.sh: add script to help keeping the index up-to-date
Date: Sat, 23 Apr 2011 18:15:43 +0200
Message-Id: <1303575344-10403-3-git-send-email-kibi@debian.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1303575344-10403-1-git-send-email-kibi@debian.org>
References: <1303575344-10403-1-git-send-email-kibi@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyril Brulebois <kibi@debian.org>
---
 Documentation/00-INDEX.sh |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)
 create mode 100755 Documentation/00-INDEX.sh

diff --git a/Documentation/00-INDEX.sh b/Documentation/00-INDEX.sh
new file mode 100755
index 0000000..31d92d2
--- /dev/null
+++ b/Documentation/00-INDEX.sh
@@ -0,0 +1,24 @@
+#!/bin/sh
+# Copyright 2011 Cyril Brulebois <kibi@debian.org>
+#
+# Try and keep the 00-INDEX file up-to-date.
+
+# List all entries below the 00-INDEX entry:
+documented=$(sed '1,/^00-INDEX$/d' 00-INDEX|grep -v '^\s'|sed 's,/$,,')
+
+# List all files/directories except 00-INDEX* and Makefile:
+present=$(ls -1|grep -v '^00-INDEX'|grep -v '^Makefile$')
+
+echo "Undocumented:"
+for i in $present; do
+  if ! echo "$documented"|grep -qs "\<$i\>"; then
+    echo "  $i"
+  fi
+done
+
+echo "Documented but missing:"
+for i in $documented; do
+  if [ ! -e $i ]; then
+    echo "  $i"
+  fi
+done
-- 
1.7.4.4

