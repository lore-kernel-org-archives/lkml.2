Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759436Ab1D1MoL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 08:44:11 -0400
Received: from glenfiddich.ikibiki.org ([88.191.124.82]:42430 "EHLO
	glenfiddich.ikibiki.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756463Ab1D1MoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 08:44:10 -0400
From: Cyril Brulebois <kibi@debian.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
        Cyril Brulebois <kibi@debian.org>
Subject: [PATCH 3/4 v2] Documentation/00-INDEX.sh: add script to help keeping the index up-to-date
Date: Thu, 28 Apr 2011 14:44:01 +0200
Message-Id: <1303994641-30881-1-git-send-email-kibi@debian.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <20110428124150.GG9517@debian.org>
References: <20110428124150.GG9517@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2: Use [[:space:]] instead of \s for better portability, thanks to Randy Dunlap.

Signed-off-by: Cyril Brulebois <kibi@debian.org>
---
 Documentation/00-INDEX.sh |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)
 create mode 100755 Documentation/00-INDEX.sh

diff --git a/Documentation/00-INDEX.sh b/Documentation/00-INDEX.sh
new file mode 100755
index 0000000..650477e
--- /dev/null
+++ b/Documentation/00-INDEX.sh
@@ -0,0 +1,24 @@
+#!/bin/sh
+# Copyright 2011 Cyril Brulebois <kibi@debian.org>
+#
+# Try and keep the 00-INDEX file up-to-date.
+
+# List all entries below the 00-INDEX entry:
+documented=$(sed '1,/^00-INDEX$/d' 00-INDEX|grep -v '^[[:space:]]'|sed 's,/$,,')
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

