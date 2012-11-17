Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818Ab2KQMdI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 07:33:08 -0500
Received: from 50-87-16-10.unifiedlayer.com ([50.87.16.10]:59646 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751696Ab2KQMdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 07:33:07 -0500
From: Constantine Shulyupin <const@MakeLinux.com>
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        Andy Whitcroft <apw@canonical.com>
Cc: Constantine Shulyupin <const@MakeLinux.com>
Subject: [PATCH] checkpatch: debugfs_remove() can take NULL
Date: Sat, 17 Nov 2012 14:33:01 +0200
Message-Id: <1353155581-30852-1-git-send-email-const@MakeLinux.com>
X-Mailer: git-send-email 1.7.9.5
X-Identified-User: {1470:box668.bluehost.com:makelinu:makelinux.net} {sentby:smtp auth 77.126.70.233 authed with poster@makelinux.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Constantine Shulyupin <const@MakeLinux.com>

debugfs_remove() can take a NULL, so let's check and warn about that.

Signed-off-by: Constantine Shulyupin <const@MakeLinux.com>
---
 scripts/checkpatch.pl |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index f18750e..c062476 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3221,6 +3221,14 @@ sub process {
 				     "kfree(NULL) is safe this check is probably not required\n" . $hereprev);
 			}
 		}
+# check for needless debugfs_remove() checks
+		if ($prevline =~ /\bif\s*\(([^\)]*)\)/) {
+			my $expr = $1;
+			if ($line =~ /\bdebugfs_remove\(\Q$expr\E\);/) {
+				WARN("NEEDLESS_DEBUGFS_REMOVE",
+				     "debugfs_remove(NULL) is safe this check is probably not required\n" . $hereprev);
+			}
+		}
 # check for needless usb_free_urb() checks
 		if ($prevline =~ /\bif\s*\(([^\)]*)\)/) {
 			my $expr = $1;
-- 
1.7.9.5

