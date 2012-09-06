Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab2IFGZH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 02:25:07 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:60553 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab2IFGZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 02:25:06 -0400
X-AuditID: 9c93016f-b7cc0ae000000e9f-36-504841bc83f9
From: Namhyung Kim <namhyung@kernel.org>
To: Minchan Kim <minchan@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH] Linux kernel contribution count script
Date: Thu,  6 Sep 2012 15:17:34 +0900
Message-Id: <1346912254-21526-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

$ ./contrib-count.sh
Usage: ./contrib-count.sh <Name> [ <Year> ]

$ ./contrib-count.sh Namhyung
Signed-off: 125
Reviewed: 3
Acked: 1
Tested: 0

$ ./contrib-count.sh Minchan 2012
Signed-off: 20
Reviewed: 32
Acked: 10
Tested: 1

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 contrib-count.sh | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)
 create mode 100755 contrib-count.sh

diff --git a/contrib-count.sh b/contrib-count.sh
new file mode 100755
index 000000000000..4d246db5735d
--- /dev/null
+++ b/contrib-count.sh
@@ -0,0 +1,27 @@
+#!/bin/sh
+#
+# Linux kernel contiribution counter.
+# It actually can be used on any git-managed projects.
+#
+
+if [ $# -eq 0 ]; then
+    echo "Usage: $0 <Name> [ <Year> ]"
+    exit 1
+fi
+
+NAME=$1
+
+# defaults to current year in YYYY format
+YEAR=$(date +"%Y")
+
+if [ $# -ge 2 ]; then
+    YEAR=$2
+fi
+
+for TAG in "Signed-off" "Reviewed" "Acked" "Tested";
+do
+    echo -n "$TAG: "
+    git log --grep="$TAG-by: $NAME" --since "$YEAR-01-01" --until "$YEAR-12-31" origin/master | \
+	git shortlog -sn | \
+	awk 'BEGIN { count = 0; } { count += $1; } END { print count; }'
+done
-- 
1.7.11.4

