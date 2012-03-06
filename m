Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768Ab2CFTbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 14:31:18 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:47145 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754648Ab2CFTbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 14:31:16 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] checkpatch: Warn on use of yield()
Date: Tue,  6 Mar 2012 11:31:10 -0800
Message-Id: <f027ae6deb2d02819f754ae9d45f54507a2d63f2.1331061916.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <1331057839.2140.12.camel@joe2Laptop>
References: <1331057839.2140.12.camel@joe2Laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using yield() is generally wrong.  Warn on its use.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 04eb9eb..135cb8f 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3344,6 +3344,12 @@ sub process {
 			     "__func__ should be used instead of gcc specific __FUNCTION__\n"  . $herecurr);
 		}
 
+# check for use of yield()
+		if ($line =~ /\byield\s*\(\s*\)/ {
+			WARN("YIELD",
+			     "Using yield() is generally wrong. See yield() kernel-doc (sched/core.c)\n"  . $herecurr);
+		}
+
 # check for semaphores initialized locked
 		if ($line =~ /^.\s*sema_init.+,\W?0\W?\)/) {
 			WARN("CONSIDER_COMPLETION",
-- 
1.7.8.111.gad25c.dirty

