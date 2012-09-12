Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749Ab2ILArf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 20:47:35 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:33423 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752113Ab2ILAre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 20:47:34 -0400
Message-ID: <1347410853.2456.7.camel@joe2Laptop>
Subject: [PATCH] checkpatch: Check networking specific block comment style
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Date: Tue, 11 Sep 2012 17:47:33 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In an effort to get fewer checkpatch reviewer corrections,
add a networking specific style test for the preferred
networking comment style.

	/* The preferred style for block comments in
	 * drivers/net/... and net/... is like this
	 */

These tests are only used in net/ and drivers/net/

Tested with:

$ cat drivers/net/t.c

/* foo */

/*
 * foo
 */

/* foo
 */

/* foo
 * bar */
$ ./scripts/checkpatch.pl -f drivers/net/t.c
WARNING: networking block comments don't use an empty /* line, use /* Comment...
#4: FILE: net/t.c:4:
+
+/*

WARNING: networking block comments put the trailing */ on a separate line
#12: FILE: net/t.c:12:
+ * bar */

total: 0 errors, 2 warnings, 12 lines checked

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index ca05ba2..7165516 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1873,6 +1873,20 @@ sub process {
 			    "No space is necessary after a cast\n" . $hereprev);
 		}
 
+		if ($realfile =~ m@^(drivers/net/|net/)@ &&
+		    $rawline =~ /^\+[ \t]*\/\*[ \t]*$/ &&
+		    $prevrawline =~ /^\+[ \t]*$/) {
+			WARN("NETWORKING_BLOCK_COMMENT_STYLE",
+			     "networking block comments don't use an empty /* line, use /* Comment...\n" . $hereprev);
+		}
+
+		if ($realfile =~ m@^(drivers/net/|net/)@ &&
+		    $rawline !~ m@^\+[ \t]*(\/\*|\*\/)@ &&
+		    $rawline =~ m@^\+[ \t]*.+\*\/[ \t]*$@) {
+			WARN("NETWORKING_BLOCK_COMMENT_STYLE",
+			     "networking block comments put the trailing */ on a separate line\n" . $herecurr);
+		}
+
 # check for spaces at the beginning of a line.
 # Exceptions:
 #  1) within comments


