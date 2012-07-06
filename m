Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933279Ab2GFV63 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 17:58:29 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:60102 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932863Ab2GFV62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 17:58:28 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] checkpatch: Add check for use of sizeof without parenthesis
Date: Fri,  6 Jul 2012 14:58:24 -0700
Message-Id: <62b9dc15110792a127562f38c0788c60952615c8.1341611781.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel style uses parenthesis around sizeof.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 7190f95..a743622 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3265,6 +3265,12 @@ sub process {
 			     "sizeof(& should be avoided\n" . $herecurr);
 		}
 
+# check for sizeof without parenthesis
+		if ($line =~ /\bsizeof\s+($Lval)/) {
+			WARN("SIZEOF_PARENTHESIS",
+			     "sizeof $1 should be sizeof($1)\n" . $herecurr);
+		}
+
 # check for line continuations in quoted strings with odd counts of "
 		if ($rawline =~ /\\$/ && $rawline =~ tr/"/"/ % 2) {
 			WARN("LINE_CONTINUATIONS",
-- 
1.7.8.111.gad25c.dirty

